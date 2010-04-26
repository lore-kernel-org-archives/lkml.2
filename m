Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab0DZPnt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 11:43:49 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:48578 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab0DZPns convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 11:43:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TC8TMQhsAL+0y2AjheNMrF3hviz4N14aoVoMdXbsnu943eNzSDaxy4WMhizqDqdumV
         CS1YSt5EBTrfSvC+Os8tsXScCFE9OIoHFMoOjMTQOWOnY6nhI4a64A1UbOu29SJsGYCC
         Zo48tskr6n+eUqTxFQxDWibYphTQgPM//bQuY=
MIME-Version: 1.0
In-Reply-To: <1271780217-27472-1-git-send-email-guenter.roeck@ericsson.com>
References: <1271780217-27472-1-git-send-email-guenter.roeck@ericsson.com>
Date: Mon, 26 Apr 2010 17:43:44 +0200
Message-ID: <t2o195c7a901004260843k947fdf2cy3b137e3056db8b62@mail.gmail.com>
Subject: Re: [PATCH v3] x86: Do not write into VGA memory space if there is no 
	VGA device in the system
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi, mingo@redhat.com,
       x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 6:16 PM, Guenter Roeck
<guenter.roeck@ericsson.com> wrote:
> Ensure that early_printk() does not write into VGA memory space
> if there is not VGA device in the system.
>
> Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> ---
> v3:
> Changes are now limited to early_printk.c. Functionality is retained, meaning
> there will still be output on the VGA console before setup_early_printk()
> is called, but only if a VGA device is known to exist in the system.
>
>  arch/x86/kernel/early_printk.c |   17 +++++++++++++----
>  1 files changed, 13 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
> index b9c830c..783cb25 100644
> --- a/arch/x86/kernel/early_printk.c
> +++ b/arch/x86/kernel/early_printk.c
> @@ -170,10 +170,13 @@ asmlinkage void early_printk(const char *fmt, ...)
>        int n;
>        va_list ap;
>
> -       va_start(ap, fmt);
> -       n = vscnprintf(buf, sizeof(buf), fmt, ap);
> -       early_console->write(early_console, buf, n);
> -       va_end(ap);
> +       if (early_console && (early_console_initialized ||
> +                             boot_params.screen_info.orig_video_isVGA == 1)) {
> +               va_start(ap, fmt);
> +               n = vscnprintf(buf, sizeof(buf), fmt, ap);
> +               early_console->write(early_console, buf, n);
> +               va_end(ap);
> +       }
>  }

Instead to this ugly if why not creating a null early_console (write
will do nothing) ?

>  static inline void early_console_register(struct console *con, int keep_early)
> @@ -233,6 +236,12 @@ static int __init setup_early_printk(char *buf)
>  #endif
>                buf++;
>        }
> +
> +       /* If there is no VGA device, don't try to use it as early console. */
> +       if (early_console == &early_vga_console &&
> +           boot_params.screen_info.orig_video_isVGA != 1)
> +               early_console = NULL;
> +
>        return 0;
>  }

And assign null console as the last console as a fallback ?

Regards

Bastien
