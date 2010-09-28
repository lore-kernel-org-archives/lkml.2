Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760368Ab0I1Ayb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 20:54:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001Ab0I1Aya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 20:54:30 -0400
Date: Mon, 27 Sep 2010 20:53:58 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        kexec <kexec@lists.infradead.org>, caiqian@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: kexec load failure introduced by "x86, memblock: Replace
 e820_/_early string with memblock_"
Message-ID: <20100928005358.GA6456@redhat.com>
References: <632974489.2046131285586512527.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
 <4CA11918.7050708@kernel.org>
 <4CA11FB7.2080101@zytor.com>
 <4CA126BE.7000609@kernel.org>
 <4CA1283C.9010105@zytor.com>
 <4CA12976.5060504@kernel.org>
 <4CA129EB.5000309@zytor.com>
 <4CA12BAB.1040308@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CA12BAB.1040308@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 04:41:31PM -0700, Yinghai Lu wrote:
> On 09/27/2010 04:34 PM, H. Peter Anvin wrote:
> > On 09/27/2010 04:32 PM, Yinghai Lu wrote:
> >> On 09/27/2010 04:26 PM, H. Peter Anvin wrote:
> >>> On 09/27/2010 04:20 PM, Yinghai Lu wrote:
> >>>>
> >>>> x86 own version for find_area?
> >>>>
> >>>
> >>> No, double no.
> >>>
> >>> Same kind of crap: overloading an interface with semantics it shouldn't
> >>> have.  The right thing is to introduce a new interface with carries the
> >>> explicitly needed policy with it... e.g. memblock_find_in_range_lowest().
> >>>
> >>> That interface would have the explicit semantics of returning the lowest
> >>> possible address, as opposed to any suitable address (which may change
> >>> if policy requirements change.)
> >>>
> >>> The other question is why does kexec need this in the first place?  Is
> >>> this due to a design bug in kexec or is there some fundamental reason
> >>> for this?
> >>
> >> bzImage is used here. so need range below 4g.
> >>
> > 
> > OK, so why don't you cap the range to 4 GiB and then pass that down to
> > the existing interface?  That's different from "lowest possible address".
> 
> but if later bzImage will use 64 entry and kexec honor it, or use 64bit vmlinux directly.
> and crashkernel=4096M, we could get failure again.
> 
> maybe something like this, will give it a try, hope kexec doesn't have other limitation.
> 
> [PATCH -v3] x86, memblock: Fix crashkernel allocation
> 
> Cai Qian found crashkernel is broken with x86 memblock changes
> 1. crashkernel=128M@32M always reported that range is used, even first kernel is small
>    no one use that range
> 2. always get following report when using "kexec -p"
> 	Could not find a free area of memory of a000 bytes...
> 	locate_hole failed
> 
> The root cause is that generic memblock_find_in_range() will try to get range from top_down.
> But crashkernel do need from low and specified range.
> 
> Let's limit the target range with rash_base + crash_size to make sure that
> We get range from bottom.
> 
> -v3: don't use loop for find low one
> 
> Reported-and-Bisected-by: CAI Qian <caiqian@redhat.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/kernel/setup.c |   19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)
> 
> Index: linux-2.6/arch/x86/kernel/setup.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/setup.c
> +++ linux-2.6/arch/x86/kernel/setup.c
> @@ -518,17 +518,23 @@ static void __init reserve_crashkernel(v
>  	if (crash_base <= 0) {
>  		const unsigned long long alignment = 16<<20;	/* 16M */
>  
> -		crash_base = memblock_find_in_range(alignment, ULONG_MAX, crash_size,
> -				 alignment);
> +		crash_base = memblock_find_in_range(alignment, 0xffffffff,
> +				crash_size, alignment);
> +

Actually, hardcoding the upper limit to 4G is probably not the best idea.
Kexec loads the the relocatable binary (purgatory) and I remember that
one of the generated relocation type was signed 32 bit and allowed max value
to be 2G only. So IIRC, purgatory code always needed to be loaded below 2G.

I liked HPA's other idea better of introducing memblock_find_in_range_lowest() 
so that we search bottom up and not rely on a specific upper limit.

Thanks
Vivek
