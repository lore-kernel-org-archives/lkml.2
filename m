Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069Ab0CaPcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 11:32:07 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:45527 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756267Ab0CaPcF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 11:32:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=V2lOwjQfqVAO0X7H1t/6oWKd6E1n71wJ+YTlK2ktlXaBIn/cOcLgXTzuIaH+tgqbo5
         6Zmho+b17g61/XECSngXeUsAR3duxAzZ00XOnZM0MTt/7ZFWC7Wf/9bVfj9dy0cAFFMT
         98RdBV2GipUEFiJgo/Oa5GUPRNV3ObuTaySYw=
MIME-Version: 1.0
In-Reply-To: <1270046479-4486-1-git-send-email-guenter.roeck@ericsson.com>
References: <1270046479-4486-1-git-send-email-guenter.roeck@ericsson.com>
Date: Wed, 31 Mar 2010 17:32:03 +0200
X-Google-Sender-Auth: f0898c07eaa7fecc
Message-ID: <84144f021003310832i3420e4c1g7396b4d1f311f393@mail.gmail.com>
Subject: Re: [PATCH][RESEND] x86: Do not write to VGA memory space if 
	CONFIG_VGA_CONSOLE is undefined
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com,
       x86 maintainers <x86@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 4:41 PM, Guenter Roeck
<guenter.roeck@ericsson.com> wrote:
> Current early_printk code writes into VGA memory space even
> if CONFIG_VGA_CONSOLE is undefined. This can cause problems
> if there is no VGA device in the system, especially if the memory
> is used by another device.
>
> Fix problem by redirecting output to early_serial_console
> if CONFIG_VGA_CONSOLE is undefined.
>
> Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>

> ---
> Sorry if you have seen this before. I seem to have trouble with our mailer.
>
>  arch/x86/kernel/early_printk.c |   12 ++++++++++--
>  1 files changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
> index b9c830c..1942039 100644
> --- a/arch/x86/kernel/early_printk.c
> +++ b/arch/x86/kernel/early_printk.c
> @@ -160,8 +160,16 @@ static struct console early_serial_console = {
>        .index =        -1,
>  };
>
> +#ifdef CONFIG_VGA_CONSOLE
> +#define EARLY_CONSOLE  early_vga_console
> +static const int have_vga_console = 1;
> +#else
> +#define EARLY_CONSOLE  early_serial_console
> +static const int have_vga_console;
> +#endif
> +
>  /* Direct interface for emergencies */
> -static struct console *early_console = &early_vga_console;
> +static struct console *early_console = &EARLY_CONSOLE;
>  static int __initdata early_console_initialized;
>
>  asmlinkage void early_printk(const char *fmt, ...)
> @@ -216,7 +224,7 @@ static int __init setup_early_printk(char *buf)
>                        early_serial_init(buf + 4);
>                        early_console_register(&early_serial_console, keep);
>                }
> -               if (!strncmp(buf, "vga", 3) &&
> +               if (have_vga_console && !strncmp(buf, "vga", 3) &&
>                    boot_params.screen_info.orig_video_isVGA == 1) {
>                        max_xpos = boot_params.screen_info.orig_video_cols;
>                        max_ypos = boot_params.screen_info.orig_video_lines;
> --
> 1.7.0.87.g0901d
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
