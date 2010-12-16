Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227Ab0LPOjn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 09:39:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755765Ab0LPOji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 09:39:38 -0500
Date: Thu, 16 Dec 2010 09:39:25 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Maxim Uvarov <muvarov@gmail.com>, linux-kernel@vger.kernel.org,
        Neil Horman <nhorman@redhat.com>
Subject: Re: kdump broken on 2.6.37-rc4
Message-ID: <20101216143925.GA13870@redhat.com>
References: <20101208141942.GA2335@redhat.com>
 <4D00823A.9050808@kernel.org>
 <20101209124117.GA6032@redhat.com>
 <4D01377B.5070809@kernel.org>
 <20101213100848.GA2237@redhat.com>
 <4D0663F0.2060103@kernel.org>
 <4D06783C.6040009@zytor.com>
 <20101214224135.GB19693@redhat.com>
 <20101215103954.GA2243@redhat.com>
 <4D09958D.2040907@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D09958D.2040907@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 08:29:01PM -0800, Yinghai Lu wrote:
> please check
> 
> [PATCH] x86, crashkernel, 32bit: only try to get range under 512M
> 
> Steanishlaw report kdump is 32bit is broken.
> 
> in misc.c for decompresser, it will do sanity checking to make sure heap
> heap under 512M.

Thanks Yinghai. I am wondering why on 32bit heap has to be with-in 512MB.
I think you are referring to following check in
arch/x86/boot/compressed/misc.c.

	if (end > ((-__PAGE_OFFSET-(512 <<20)-1) & 0x7fffffff))
		error("Destination address too large");

It was introduced here.

commit 968de4f02621db35b8ae5239c8cfc6664fb872d8
Author: Eric W. Biederman <ebiederm@xmission.com>
Date:   Thu Dec 7 02:14:04 2006 +0100

    [PATCH] i386: Relocatable kernel support

Eric,

It has been long. By any chance would you remember where does above
constraint come from?

Thanks
Vivek

> 
> So limit it in first kernel under 512M for 32bit system.
> 
> Reported-by: Stanislaw Gruszka <sgruszka@redhat.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/kernel/setup.c |   14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/arch/x86/kernel/setup.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/setup.c
> +++ linux-2.6/arch/x86/kernel/setup.c
> @@ -499,7 +499,19 @@ static inline unsigned long long get_tot
>  	return total << PAGE_SHIFT;
>  }
>  
> +/*
> + * arch/x86/boot/compressed/misc.c will check heap size for decompresser
> + *  32bit will have more strict limitation
> + */
>  #define DEFAULT_BZIMAGE_ADDR_MAX 0x37FFFFFF
> +#define HEAP_LIMIT_32BIT 0x20000000
> +
> +#ifdef CONFIG_X86_64
> +#define CRASH_KERNEL_LIMIT DEFAULT_BZIMAGE_ADDR_MAX
> +#else
> +#define CRASH_KERNEL_LIMIT HEAP_LIMIT_32BIT
> +#endif
> +
>  static void __init reserve_crashkernel(void)
>  {
>  	unsigned long long total_mem;
> @@ -521,7 +533,7 @@ static void __init reserve_crashkernel(v
>  		 *  kexec want bzImage is below DEFAULT_BZIMAGE_ADDR_MAX
>  		 */
>  		crash_base = memblock_find_in_range(alignment,
> -			       DEFAULT_BZIMAGE_ADDR_MAX, crash_size, alignment);
> +			       CRASH_KERNEL_LIMIT, crash_size, alignment);
>  
>  		if (crash_base == MEMBLOCK_ERROR) {
>  			pr_info("crashkernel reservation failed - No suitable area found.\n");
