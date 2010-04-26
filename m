Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab0DZJgK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 05:36:10 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:37016 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab0DZJgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 05:36:09 -0400
Message-ID: <4BD55E85.4020709@cs.helsinki.fi>
Date: Mon, 26 Apr 2010 12:36:05 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Guenter Roeck <guenter.roeck@ericsson.com>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, x86@kernel.org
Subject: Re: [PATCH v3] x86: Do not write into VGA memory space if there is
 no VGA device in the system
References: <1271780217-27472-1-git-send-email-guenter.roeck@ericsson.com>
In-Reply-To: <1271780217-27472-1-git-send-email-guenter.roeck@ericsson.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guenter Roeck kirjoitti:
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
>  arch/x86/kernel/early_printk.c |   17 +++++++++++++----
>  1 files changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
> index b9c830c..783cb25 100644
> --- a/arch/x86/kernel/early_printk.c
> +++ b/arch/x86/kernel/early_printk.c
> @@ -170,10 +170,13 @@ asmlinkage void early_printk(const char *fmt, ...)
>  	int n;
>  	va_list ap;
>  
> -	va_start(ap, fmt);
> -	n = vscnprintf(buf, sizeof(buf), fmt, ap);
> -	early_console->write(early_console, buf, n);
> -	va_end(ap);
> +	if (early_console && (early_console_initialized ||
> +			      boot_params.screen_info.orig_video_isVGA == 1)) {
> +		va_start(ap, fmt);
> +		n = vscnprintf(buf, sizeof(buf), fmt, ap);
> +		early_console->write(early_console, buf, n);
> +		va_end(ap);
> +	}
>  }
>  
>  static inline void early_console_register(struct console *con, int keep_early)
> @@ -233,6 +236,12 @@ static int __init setup_early_printk(char *buf)
>  #endif
>  		buf++;
>  	}
> +
> +	/* If there is no VGA device, don't try to use it as early console. */
> +	if (early_console == &early_vga_console &&
> +	    boot_params.screen_info.orig_video_isVGA != 1)
> +		early_console = NULL;

Wouldn't it be better to switch to, say, serial console here to avoid 
the NULL check in early_printk()?

> +
>  	return 0;
>  }
> 
