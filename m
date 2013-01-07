Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab3AGP4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 10:56:09 -0500
Received: from mail.skyhub.de ([78.46.96.112]:33331 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753713Ab3AGP4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 10:56:06 -0500
Date: Mon, 7 Jan 2013 16:56:04 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7u1 12/31] x86: add get_ramdisk_image/size()
Message-ID: <20130107155604.GE29449@x1.alien8.de>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yinghai Lu <yinghai@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kiszka <jan.kiszka@web.de>,
	Jason Wessel <jason.wessel@windriver.com>,
	linux-kernel@vger.kernel.org
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
 <1357260531-11115-13-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1357260531-11115-13-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2013 at 04:48:32PM -0800, Yinghai Lu wrote:
> There are several places to find ramdisk information early for reserving
> and relocating.
> 
> Use functions to make code more readable and consistent.
> 
> Later will add ext_ramdisk_image/size in those functions to support
> loading ramdisk above 4g.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/kernel/setup.c |   29 +++++++++++++++++++++--------
>  1 file changed, 21 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 1b8a8cc..644a123 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -294,12 +294,25 @@ static void __init reserve_brk(void)
>  
>  #ifdef CONFIG_BLK_DEV_INITRD
>  
> +static u64 __init get_ramdisk_image(void)
> +{
> +	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
> +
> +	return ramdisk_image;

just do

	return (u64)boot_params.hdr.ramdisk_image;

> +}
> +static u64 __init get_ramdisk_size(void)
> +{
> +	u64 ramdisk_size = boot_params.hdr.ramdisk_size;

ditto.

> +
> +	return ramdisk_size;
> +}
> +
>  #define MAX_MAP_CHUNK	(NR_FIX_BTMAPS << PAGE_SHIFT)
>  static void __init relocate_initrd(void)
>  {
>  	/* Assume only end is not page aligned */
> -	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
> -	u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
> +	u64 ramdisk_image = get_ramdisk_image();
> +	u64 ramdisk_size  = get_ramdisk_size();
>  	u64 area_size     = PAGE_ALIGN(ramdisk_size);
>  	u64 ramdisk_here;
>  	unsigned long slop, clen, mapaddr;
> @@ -338,8 +351,8 @@ static void __init relocate_initrd(void)
>  		ramdisk_size  -= clen;
>  	}
>  
> -	ramdisk_image = boot_params.hdr.ramdisk_image;
> -	ramdisk_size  = boot_params.hdr.ramdisk_size;
> +	ramdisk_image = get_ramdisk_image();
> +	ramdisk_size  = get_ramdisk_size();
>  	printk(KERN_INFO "Move RAMDISK from [mem %#010llx-%#010llx] to"
>  		" [mem %#010llx-%#010llx]\n",
>  		ramdisk_image, ramdisk_image + ramdisk_size - 1,
> @@ -363,8 +376,8 @@ static u64 __init get_mem_size(unsigned long limit_pfn)
>  static void __init early_reserve_initrd(void)
>  {
>  	/* Assume only end is not page aligned */
> -	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
> -	u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
> +	u64 ramdisk_image = get_ramdisk_image();
> +	u64 ramdisk_size  = get_ramdisk_size();
>  	u64 ramdisk_end   = PAGE_ALIGN(ramdisk_image + ramdisk_size);
>  
>  	if (!boot_params.hdr.type_of_loader ||
> @@ -376,8 +389,8 @@ static void __init early_reserve_initrd(void)
>  static void __init reserve_initrd(void)
>  {
>  	/* Assume only end is not page aligned */
> -	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
> -	u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
> +	u64 ramdisk_image = get_ramdisk_image();
> +	u64 ramdisk_size  = get_ramdisk_size();
>  	u64 ramdisk_end   = PAGE_ALIGN(ramdisk_image + ramdisk_size);
>  	u64 mapped_size;
>  
> -- 
> 1.7.10.4
> 
> 

-- 
Regards/Gruss,
Boris.
