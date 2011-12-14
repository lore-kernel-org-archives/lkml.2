Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab1LNHtq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 02:49:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47376 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754490Ab1LNHtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 02:49:45 -0500
Date: Wed, 14 Dec 2011 08:47:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@amd64.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 1/6] HWPOISON: clean up memory_failure() vs.
 __memory_failure()
Message-ID: <20111214074749.GD25232@elte.hu>
References: <cover.1323803130.git.tony.luck@intel.com>
 <bb20b30eaea7d0099fc2d5b0e0e5fb67b6268a8a.1323803130.git.tony.luck@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb20b30eaea7d0099fc2d5b0e0e5fb67b6268a8a.1323803130.git.tony.luck@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tony Luck <tony.luck@intel.com> wrote:

> There is only one caller of memory_failure(), all other users call
> __memory_failure() and pass in the flags argument explicitly. The
> lone user of memory_failure() will soon need to pass flags too.
> 
> Add flags argument to the callsite in mce.c. Delete the old memory_failure()
> function, and then rename __memory_failure() without the leading "__".
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |    9 +++++--
>  drivers/base/memory.c            |    2 +-
>  include/linux/mm.h               |    3 +-
>  mm/hwpoison-inject.c             |    4 +-
>  mm/madvise.c                     |    2 +-
>  mm/memory-failure.c              |   46 +++++++++++++++++--------------------
>  6 files changed, 32 insertions(+), 34 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 2af127d..265139d 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -1046,11 +1046,14 @@ out:
>  }
>  EXPORT_SYMBOL_GPL(do_machine_check);
>  
> -/* dummy to break dependency. actual code is in mm/memory-failure.c */
> -void __attribute__((weak)) memory_failure(unsigned long pfn, int vector)
> +#ifndef CONFIG_MEMORY_FAILURE
> +int memory_failure(unsigned long pfn, int vector, int flags)
>  {
>  	printk(KERN_ERR "Action optional memory failure at %lx ignored\n", pfn);

Btw., while at it, could we phrase this message in a more 
obvious way to users, such as 'Non-fatal memory failure at %lx 
ignored'?

Thanks,

	Ingo
