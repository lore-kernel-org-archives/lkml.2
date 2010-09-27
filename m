Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759021Ab0I0JQs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 05:16:48 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:34217 "EHLO
	mx02.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758984Ab0I0JQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 05:16:47 -0400
Date: Mon, 27 Sep 2010 05:16:31 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, kexec <kexec@lists.infradead.org>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Message-ID: <502772083.2028061285578991642.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <4CA03A2D.4050503@kernel.org>
Subject: Re: kexec load failure introduced by "x86, memblock: Replace
 e820_/_early string with memblock_"
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.72]
X-Mailer: Zimbra 5.0.21_GA_3150.RHEL4_64 (ZimbraWebClient - FF3.0 (Linux)/5.0.21_GA_3150.RHEL4_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- "Yinghai Lu" <yinghai@kernel.org> wrote:

> Please check this one on top of tip or next.
This failed for both trees.
[root@localhost linux-next]# patch -Np1 <memblock.patch
patching file arch/x86/kernel/setup.c
Hunk #1 FAILED at 516.
1 out of 1 hunk FAILED -- saving rejects to file arch/x86/kernel/setup.c.rej

> 
> Thanks
> 
> Yinghai
> 
> [PATCH] x86, memblock: Fix crashkernel allocation
> 
> Cai Qian found that crashkernel is broken with x86 memblock changes
> 1. crashkernel=128M@32M always reported that range is used, even first
> kernel is small
>    no one use that range
> 2. always get following report when using "kexec -p"
> 	Could not find a free area of memory of a000 bytes...
> 	locate_hole failed
> 
> The root cause is that generic memblock_find_in_range() will try to
> get range from top_down.
> But crashkernel do need from low and specified range.
> 
> Let's limit the target range with rash_base + crash_size to make sure
> that
> We get range from bottom.
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
> @@ -516,19 +516,28 @@ static void __init reserve_crashkernel(v
>  
>  	/* 0 means: find the address automatically */
>  	if (crash_base <= 0) {
> +		unsigned long long start = 0;
>  		const unsigned long long alignment = 16<<20;	/* 16M */
>  
> -		crash_base = memblock_find_in_range(alignment, ULONG_MAX,
> crash_size,
> -				 alignment);
> -		if (crash_base == MEMBLOCK_ERROR) {
> +		crash_base = alignment;
> +		while (crash_base < 0xffffffff) {
> +			start = memblock_find_in_range(crash_base,
> +				crash_base + crash_size, crash_size, alignment);
> +
> +			if (start == crash_base)
> +				break;
> +
> +			crash_base += alignment;
> +		}
> +		if (start != crash_base) {
>  			pr_info("crashkernel reservation failed - No suitable area
> found.\n");
>  			return;
>  		}
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
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
