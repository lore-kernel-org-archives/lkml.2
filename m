Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760686Ab2D0UXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 16:23:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57713 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759754Ab2D0UXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 16:23:46 -0400
Date: Fri, 27 Apr 2012 13:23:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: inux-next: Tree for Apr 27 (uml + mm/memcontrol.c)
Message-Id: <20120427132343.fbb443b9.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1204271141040.28516@chino.kir.corp.google.com>
References: <20120427161146.95422142968526faaff615d4@canb.auug.org.au>
	<4F9ABF9C.2070707@xenotime.net>
	<alpine.DEB.2.00.1204271141040.28516@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2012 11:44:24 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> On Fri, 27 Apr 2012, Randy Dunlap wrote:
> 
> > On 04/26/2012 11:11 PM, Stephen Rothwell wrote:
> > 
> > > Hi all,
> > > 
> > > Changes since 20120424:
> > 
> > 
> > 
> > uml on x86_64 (defconfig):
> > 
> > mm/memcontrol.c:256:30: error: 'HUGE_MAX_HSTATE' undeclared here (not in a function)
> > 
> 
> This is because of "memcg: add HugeTLB extension" from -mm.
> 
> This patch is legal in C99, I wonder if Andrew would let us get away with 
> something like this so there's no a dozen #ifdefs in mm/memcontrol.c?
> ---
> diff --git a/arch/powerpc/include/asm/page.h b/arch/powerpc/include/asm/page.h
> --- a/arch/powerpc/include/asm/page.h
> +++ b/arch/powerpc/include/asm/page.h
> @@ -39,13 +39,13 @@
>  #ifndef __ASSEMBLY__
>  #ifdef CONFIG_HUGETLB_PAGE
>  extern unsigned int HPAGE_SHIFT;
> +#define HUGE_MAX_HSTATE		(MMU_PAGE_COUNT-1)
>  #else
>  #define HPAGE_SHIFT PAGE_SHIFT
>  #endif
>  #define HPAGE_SIZE		((1UL) << HPAGE_SHIFT)
>  #define HPAGE_MASK		(~(HPAGE_SIZE - 1))
>  #define HUGETLB_PAGE_ORDER	(HPAGE_SHIFT - PAGE_SHIFT)
> -#define HUGE_MAX_HSTATE		(MMU_PAGE_COUNT-1)
>  #endif
>  
>  /* We do define AT_SYSINFO_EHDR but don't use the gate mechanism */
> diff --git a/arch/tile/include/asm/page.h b/arch/tile/include/asm/page.h
> --- a/arch/tile/include/asm/page.h
> +++ b/arch/tile/include/asm/page.h
> @@ -136,9 +136,8 @@ static inline __attribute_const__ int get_order(unsigned long size)
>  
>  #define HUGETLB_PAGE_ORDER	(HPAGE_SHIFT - PAGE_SHIFT)
>  
> -#define HUGE_MAX_HSTATE		6
> -
>  #ifdef CONFIG_HUGETLB_PAGE
> +#define HUGE_MAX_HSTATE		6
>  #define HAVE_ARCH_HUGETLB_UNMAPPED_AREA
>  #endif
>  
> diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
> --- a/arch/x86/include/asm/page_types.h
> +++ b/arch/x86/include/asm/page_types.h
> @@ -25,7 +25,9 @@
>  #define HPAGE_MASK		(~(HPAGE_SIZE - 1))
>  #define HUGETLB_PAGE_ORDER	(HPAGE_SHIFT - PAGE_SHIFT)
>  
> +#ifdef CONFIG_HUGETLB_PAGE
>  #define HUGE_MAX_HSTATE 2
> +#endif
>  
>  #define PAGE_OFFSET		((unsigned long)__PAGE_OFFSET)
>  
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -324,6 +324,7 @@ static inline int hstate_index(struct hstate *h)
>  
>  #else
>  struct hstate {};
> +#define HUGE_MAX_HSTATE 0
>  #define alloc_huge_page_node(h, nid) NULL
>  #define alloc_bootmem_huge_page(h) NULL
>  #define hstate_file(f) NULL

Seems reasonable.  But the CONFIG_HUGETLB_PAGE=y,
CONFIG_MEM_RES_CTLR_HUGETLB=n combination will cause unneeded code
generation and space consumption in memcontrol.c.

I wonder if we can additionally do, within memcontrol.c:

/*
 * Nice comment goes here
 */
#ifdef CONFIG_MEM_RES_CTLR_HUGETLB
#define HUGE_MAX_HSTATE_FOO HUGE_MAX_HSTATE
#else
#define HUGE_MAX_HSTATE_FOO 0
#endif

and s/HUGE_MAX_HSTATE/HUGE_MAX_HSTATE_FOO/ in that file.
