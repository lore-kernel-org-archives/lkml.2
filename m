Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab0I1OB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 10:01:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755869Ab0I1OB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 10:01:26 -0400
Date: Tue, 28 Sep 2010 10:01:12 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        kexec <kexec@lists.infradead.org>, caiqian@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: kexec load failure introduced by "x86, memblock: Replace
 e820_/_early string with memblock_"
Message-ID: <20100928140112.GB8950@redhat.com>
References: <4CA11918.7050708@kernel.org>
 <4CA11FB7.2080101@zytor.com>
 <4CA126BE.7000609@kernel.org>
 <4CA1283C.9010105@zytor.com>
 <4CA12976.5060504@kernel.org>
 <4CA129EB.5000309@zytor.com>
 <4CA12BAB.1040308@kernel.org>
 <20100928005358.GA6456@redhat.com>
 <4CA16522.8060107@zytor.com>
 <4CA195D7.4010706@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CA195D7.4010706@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 12:14:31AM -0700, Yinghai Lu wrote:
> On 09/27/2010 08:46 PM, H. Peter Anvin wrote:
> > On 09/27/2010 05:53 PM, Vivek Goyal wrote:
> >>
> >> Actually, hardcoding the upper limit to 4G is probably not the best idea.
> >> Kexec loads the the relocatable binary (purgatory) and I remember that
> >> one of the generated relocation type was signed 32 bit and allowed max value
> >> to be 2G only. So IIRC, purgatory code always needed to be loaded below 2G.
> >>
> >> I liked HPA's other idea better of introducing memblock_find_in_range_lowest() 
> >> so that we search bottom up and not rely on a specific upper limit.
> >>
> > 
> > No, it's just another crappy hack which is broken in the same way.  It's
> > better than open-coding, but it's still a hack.
> > 
> > The Right Thing[TM] to do is for kexec to communicate the topmost
> > address it wants to this code, so it has both the upper and the lower
> > boundaries available to it instead of just one.
> 
> hope you are happy with this one.
> 
> [PATCH -v5] x86, memblock: Fix crashkernel allocation
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
> -v5: use DEFAULT_BZIMAGE_ADDR_MAX to limit area that could be used by bzImge.
>      also second try for vmlinux or new kexec tools will use bzImage 64bit entry
> 
> Reported-and-Bisected-by: CAI Qian <caiqian@redhat.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/kernel/setup.c |   24 ++++++++++++++++++------
>  1 file changed, 18 insertions(+), 6 deletions(-)
> 
> Index: linux-2.6/arch/x86/kernel/setup.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/setup.c
> +++ linux-2.6/arch/x86/kernel/setup.c
> @@ -501,6 +501,7 @@ static inline unsigned long long get_tot
>  	return total << PAGE_SHIFT;
>  }
>  
> +#define DEFAULT_BZIMAGE_ADDR_MAX 0x37FFFFFF
>  static void __init reserve_crashkernel(void)
>  {
>  	unsigned long long total_mem;
> @@ -518,17 +519,28 @@ static void __init reserve_crashkernel(v
>  	if (crash_base <= 0) {
>  		const unsigned long long alignment = 16<<20;	/* 16M */
>  
> -		crash_base = memblock_find_in_range(alignment, ULONG_MAX, crash_size,
> -				 alignment);
> +		/*
> +		 * Assume half crash_size is for bzImage
> +		 *  kexec want bzImage is below DEFAULT_BZIMAGE_ADDR_MAX
> +		 */
> +		crash_base = memblock_find_in_range(alignment,
> +				DEFAULT_BZIMAGE_ADDR_MAX + crash_size/2,
> +				crash_size, alignment);
> +

IMHO, these kind of hardcodings are worse than finding the lowest possible
address. It is assuming that kexec is going to load a bzImage.

So we have following three options sorted from best to worst.

- Specify upper limit in "crashkernel=" command line syntax
- Find the lowest possible address for crashkernel reservations
- Hardcode upper limit based on certain factors.

Because upper limit depends on image being loaded and can also vary as
kexec-tools changes, knowing it for sure will require extra reboot. It
also make command line syntax more complicated as we need to introduce
another field to speciy upper limit. Especially for the following case.

crashkernel=<range1>:<size1>[,<range2>:<size2>,...][@offset]

So personally I think we can stick to second best option and that is
finding the lowest possible memory area.

Thanks
Vivek
