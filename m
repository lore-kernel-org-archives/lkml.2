Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932739Ab0JFPPO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 11:15:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759155Ab0JFPPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 11:15:12 -0400
Date: Wed, 6 Oct 2010 11:14:49 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, caiqian@redhat.com, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/memblock] x86, memblock: Fix crashkernel allocation
Message-ID: <20101006151449.GA7378@redhat.com>
References: <4CABAF2A.5090501@kernel.org>
 <tip-9f4c13964b58608fbce05540743281ea3146c0e8@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-9f4c13964b58608fbce05540743281ea3146c0e8@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 06:27:54AM +0000, tip-bot for Yinghai Lu wrote:
> Commit-ID:  9f4c13964b58608fbce05540743281ea3146c0e8
> Gitweb:     http://git.kernel.org/tip/9f4c13964b58608fbce05540743281ea3146c0e8
> Author:     Yinghai Lu <yinghai@kernel.org>
> AuthorDate: Tue, 5 Oct 2010 16:05:14 -0700
> Committer:  H. Peter Anvin <hpa@zytor.com>
> CommitDate: Tue, 5 Oct 2010 21:43:14 -0700
> 
> x86, memblock: Fix crashkernel allocation
> 
> Cai Qian found crashkernel is broken with the x86 memblock changes.
> 
> 1. crashkernel=128M@32M always reported that range is used, even if
>    the first kernel is small and does not usethat range
> 
> 2. we always got following report when using "kexec -p"
> 	Could not find a free area of memory of a000 bytes...
> 	locate_hole failed
> 
> The root cause is that generic memblock_find_in_range() will try to
> allocate from the top of the range, whereas the kexec code was written
> assuming that allocation was always near the bottom and that it could
> blindly extend memory upward.  Unfortunately the kexec code doesn't
> have a system for requesting the range that it really needs, so this
> is subject to probabilistic failures.
> 
> This patch hacks around the problem by limiting the target range
> heuristically to below the traditional bzImage max range.  This number
> is arbitrary and not always correct, and a much better result would be
> obtained by having kexec communicate this number based on the kernel
> header information and any appropriate command line options.
> 
> Reported-and-Bisected-by: CAI Qian <caiqian@redhat.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> LKML-Reference: <4CABAF2A.5090501@kernel.org>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> ---
>  arch/x86/kernel/setup.c |   13 +++++++++----
>  1 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index bf89e0a..b11a238 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -502,6 +502,7 @@ static inline unsigned long long get_total_mem(void)
>  	return total << PAGE_SHIFT;
>  }
>  
> +#define DEFAULT_BZIMAGE_ADDR_MAX 0x37FFFFFF
>  static void __init reserve_crashkernel(void)
>  {
>  	unsigned long long total_mem;
> @@ -519,8 +520,12 @@ static void __init reserve_crashkernel(void)
>  	if (crash_base <= 0) {
>  		const unsigned long long alignment = 16<<20;	/* 16M */
>  
> -		crash_base = memblock_find_in_range(alignment, ULONG_MAX, crash_size,
> -				 alignment);
> +		/*
> +		 *  kexec want bzImage is below DEFAULT_BZIMAGE_ADDR_MAX
> +		 */
> +		crash_base = memblock_find_in_range(alignment,
> +			       DEFAULT_BZIMAGE_ADDR_MAX, crash_size, alignment);
> +

I really don't understand why to put a upper limit of DEFAULT_BZIMAGE_ADDR_MAX.
It does not make much sense to internally impose an upper limit on
reserved memory area if reserver has not specified one.

Why can't we provide a function which does a search from bottom up for
the required size of memory. If the memory finally reserved does not meet
the constraints needed by kexec, then kexec load will fail. Kernel does
not have to try to figure out the upper limit in this case.

Current state of affairs are not perfect, but coming up with artificial
upper limit here is further deterioriating the situation, IMHO.

Regarding the question of specifying the upper limit by kexec on command
line, I think it is hard. Kexec needs to load multiple segments and some
needs to go in really low memory area and some can be in higher memory
area. What is the upper limit in this case. If we take the upper limit
of lowest memory segment, then we will just not have sufficient memory
to load all segments.

That would mean split the reserved region into multiple parts and one
should specifiy separate upper limit for each region. That would make
the whole thing complex.

So can we atleast maintain the status quo where we search for crashkernel
memory bottom up without any upper limits instread of top down.

Thanks
Vivek




>  		if (crash_base == MEMBLOCK_ERROR) {
>  			pr_info("crashkernel reservation failed - No suitable area found.\n");
>  			return;
> @@ -528,8 +533,8 @@ static void __init reserve_crashkernel(void)
>  	} else {
>  		unsigned long long start;
>  
> -		start = memblock_find_in_range(crash_base, ULONG_MAX, crash_size,
> -				 1<<20);
> +		start = memblock_find_in_range(crash_base,
> +				 crash_base + crash_size, crash_size, 1<<20);
>  		if (start != crash_base) {
>  			pr_info("crashkernel reservation failed - memory is in use.\n");
>  			return;
