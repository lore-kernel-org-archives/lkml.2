Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab0CWXTK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 19:19:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41048 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130Ab0CWXTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 19:19:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: holt@sgi.com
Subject: Re: [patch 1/2] x86,pat Update the page flags for memtype atomically instead of using memtype_lock. -V3
Date: Wed, 24 Mar 2010 00:21:53 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc2-rjw; KDE/4.3.5; x86_64; ; )
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@gmail.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       x86@kernel.org
References: <20100315132103.228021253@gulag1.americas.sgi.com> <20100315132110.688234145@gulag1.americas.sgi.com>
In-Reply-To: <20100315132110.688234145@gulag1.americas.sgi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201003240021.53830.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 March 2010, holt@sgi.com wrote:
> 
> While testing an application using the xpmem (out of kernel) driver, we
> noticed a significant page fault rate reduction of x86_64 with respect
> to ia64.  For one test running with 32 cpus, one thread per cpu, it
> took 01:08 for each of the threads to vm_insert_pfn 2GB worth of pages.
> For the same test running on 256 cpus, one thread per cpu, it took 14:48
> to vm_insert_pfn 2 GB worth of pages.
> 
> The slowdown was tracked to lookup_memtype which acquires the
> spinlock memtype_lock.  This heavily contended lock was slowing down
> vm_insert_pfn().
> 
> With the cmpxchg on page->flags method, both the 32 cpu and 256 cpu
> cases take approx 00:01.3 seconds to complete.
> 
> 
> To: Ingo Molnar <mingo@redhat.com>
> To: H. Peter Anvin <hpa@zytor.com>
> To: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Robin Holt <holt@sgi.com>
> Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Cc: Venkatesh Pallipadi <venkatesh.pallipadi@gmail.com>
> Cc: Suresh Siddha <suresh.b.siddha@intel.com>
> Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> Cc: x86@kernel.org
> 
> ---
> 
> Changes since -V2:
> 1) Cleared up the naming of the masks used in setting and clearing
> the flags.
> 
> 
> Changes since -V1:
> 1) Introduce atomically setting and clearing the page flags and not
> using the global memtype_lock to protect page->flags.
> 
> 2) This allowed me the opportunity to convert the rwlock back into a
> spinlock and not affect _MY_ tests performance as all the pages my test
> was utilizing are tracked by struct pages.
> 
> 3) Corrected the commit log.  The timings were for 32 cpus and not 256.
> 
>  arch/x86/include/asm/cacheflush.h |   44 +++++++++++++++++++++-----------------
>  arch/x86/mm/pat.c                 |    8 ------
>  2 files changed, 25 insertions(+), 27 deletions(-)
> 
> Index: linux-next/arch/x86/include/asm/cacheflush.h
> ===================================================================
> --- linux-next.orig/arch/x86/include/asm/cacheflush.h	2010-03-12 19:55:06.690471974 -0600
> +++ linux-next/arch/x86/include/asm/cacheflush.h	2010-03-12 19:55:41.846472324 -0600
> @@ -44,9 +44,6 @@ static inline void copy_from_user_page(s
>  	memcpy(dst, src, len);
>  }
>  
> -#define PG_WC				PG_arch_1
> -PAGEFLAG(WC, WC)
> -
>  #ifdef CONFIG_X86_PAT
>  /*
>   * X86 PAT uses page flags WC and Uncached together to keep track of
> @@ -55,16 +52,24 @@ PAGEFLAG(WC, WC)
>   * _PAGE_CACHE_UC_MINUS and fourth state where page's memory type has not
>   * been changed from its default (value of -1 used to denote this).
>   * Note we do not support _PAGE_CACHE_UC here.
> - *
> - * Caller must hold memtype_lock for atomicity.
>   */
> +
> +#define _PGMT_DEFAULT		0
> +#define _PGMT_WC		PG_arch_1
> +#define _PGMT_UC_MINUS		PG_uncached
> +#define _PGMT_WB		(PG_uncached | PG_arch_1)
> +#define _PGMT_MASK		(PG_uncached | PG_arch_1)
> +#define _PGMT_CLEAR_MASK	(~_PGMT_MASK)
> +

Can we manipulate the PG_* constants this way?  They are just bit numbers,
so for example _PGMT_WB should be ((1 << PG_uncached) | (PG_arch_1)) for
example.

Rafael
