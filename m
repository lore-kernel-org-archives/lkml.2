Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965931Ab2B2XMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 18:12:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34059 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965631Ab2B2XMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 18:12:12 -0500
Message-ID: <4F4EB0B9.2080906@zytor.com>
Date: Wed, 29 Feb 2012 15:11:53 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: "Joshua C." <joshuacov@googlemail.com>
CC: Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [RESUBMIT] [PATCH] Use BIOS Keyboard variable to set Numlock
References: <CAKL7Q7qU0OKzqC-XnM1mY7YWs1SstayqH-8P-5MY3Yg7_wrQZw@mail.gmail.com> <4F4BF11E.4090000@zytor.com> <CAKL7Q7pK_jacfk9shdNootT46AihgABZkN54sbP-SnhA6-1F8Q@mail.gmail.com> <4F4C1F76.70403@zytor.com> <alpine.DEB.2.00.1202281927130.24649@be10.lrz> <4F4D1E6A.5000200@zytor.com> <CAKL7Q7oxYvkgvHgqejzRn+OQqCVg2NOqPPs+T_jBvKAigNKCjQ@mail.gmail.com> <4F4E6B98.2090306@zytor.com> <CAKL7Q7o7udqrvKou=CSxuzJOuAJfemU4bizSsAtaebJZbBMRFQ@mail.gmail.com>
In-Reply-To: <CAKL7Q7o7udqrvKou=CSxuzJOuAJfemU4bizSsAtaebJZbBMRFQ@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good, *except* that this will break the compile for all non-x86
architectures.  It might be worthwhile to factor out the
architecture-dependent bits for cleanliness.

	-hpa

On 02/29/2012 02:56 PM, Joshua C. wrote:
> diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
> index a605549..40a33bf 100644
> --- a/drivers/tty/vt/keyboard.c
> +++ b/drivers/tty/vt/keyboard.c
> @@ -24,6 +24,8 @@
> 
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> 
> +#include <asm/io.h>
> +#include <asm/setup.h>
>  #include <linux/consolemap.h>
>  #include <linux/module.h>
>  #include <linux/sched.h>
> @@ -52,19 +54,6 @@ extern void ctrl_alt_del(void);
> 
>  #define KBD_DEFMODE ((1 << VC_REPEAT) | (1 << VC_META))
> 
> -/*
> - * Some laptops take the 789uiojklm,. keys as number pad when NumLock is on.
> - * This seems a good reason to start with NumLock off. On HIL keyboards
> - * of PARISC machines however there is no NumLock key and everyone
> expects the keypad
> - * to be used for numbers.
> - */
> -
> -#if defined(CONFIG_PARISC) && (defined(CONFIG_KEYBOARD_HIL) ||
> defined(CONFIG_KEYBOARD_HIL_OLD))
> -#define KBD_DEFLEDS (1 << VC_NUMLOCK)
> -#else
> -#define KBD_DEFLEDS 0
> -#endif
> -
>  #define KBD_DEFLOCK 0
> 
>  void compute_shiftstate(void);
> @@ -1428,12 +1417,32 @@ static struct input_handler kbd_handler = {
>  	.id_table	= kbd_ids,
>  };
> 
> +/* Let the user decide if we should use the value from the BIOS. */
> +static int numlock = 1;
> +MODULE_PARM_DESC(numlock, "Should we use the NumLock state returned
> by the BIOS? \
> +				(1 = use BIOS Setting, 0 = don't use it)");
> +module_param_named(numlock, numlock, int, 0400);
> +
>  int __init kbd_init(void)
>  {
>  	int i;
>  	int error;
> 
> -        for (i = 0; i < MAX_NR_CONSOLES; i++) {
> +	/*
> +	* Some laptops take the 789uiojklm,. keys as number pad when NumLock is on.
> +	* This seems a good reason to start with NumLock off. On HIL keyboards
> +	* of PARISC machines however there is no NumLock key and everyone
> expects the keypad
> +	* to be used for numbers. That's why we start with NumLock off and
> ask the bios
> +	* for the correct state.
> +	*/
> +
> +	int KBD_DEFLEDS = 0 << VC_NUMLOCK;
> +
> +	/* Numlock status bit set? */
> +	if ((boot_params.kbd_status & 0x20) && numlock)
> +		KBD_DEFLEDS = 1 << VC_NUMLOCK;
> +
> +	for (i = 0; i < MAX_NR_CONSOLES; i++) {
>  		kbd_table[i].ledflagstate = KBD_DEFLEDS;
>  		kbd_table[i].default_ledflagstate = KBD_DEFLEDS;
>  		kbd_table[i].ledmode = LED_SHOW_FLAGS;


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

