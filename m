Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab0GJSiQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 14:38:16 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56514 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab0GJSiP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 14:38:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=PYzyoC9fXnaeg6hFE/muyr/sDUULX99kREQb7mrUdgv+S4S+QoabIUKgQPc2TrOYGT
         vmbapk+zsC3FCadJRHVTsUV5qkk0pfNhaIpwqRdlSQSKWVn2OplGcTbs2I2JAr1qcYSD
         8W/A2fADiujdrYzDDG7qqRwwJmeBoFTZCY+lo=
MIME-Version: 1.0
In-Reply-To: <1278785277-22629-1-git-send-email-penberg@cs.helsinki.fi>
References: <1278785277-22629-1-git-send-email-penberg@cs.helsinki.fi>
Date: Sat, 10 Jul 2010 11:38:13 -0700
X-Google-Sender-Auth: G51NHzaUEedl0qTM2U2WPPy1YF8
Message-ID: <AANLkTinzSEafau_T5ugcZoiP8NXvbvihKyNbQDnFI2Xr@mail.gmail.com>
Subject: Re: [RFC/PATCH] x86: Early-boot serial I/O support
From: Yinghai Lu <yinghai@kernel.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, Cyrill Gorcunov <gorcunov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 10, 2010 at 11:07 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> This patch adds serial I/O support to very early boot printf(). It's useful for
> debugging boot code when running Linux under KVM, for example. The actual code
> was lifted from early printk.
>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Cyrill Gorcunov <gorcunov@gmail.com>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  arch/x86/boot/boot.h |    1 +
>  arch/x86/boot/main.c |    3 ++
>  arch/x86/boot/tty.c  |   65 +++++++++++++++++++++++++++++++++++++++++++++----
>  3 files changed, 63 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
> index 98239d2..5b37014 100644
> --- a/arch/x86/boot/boot.h
> +++ b/arch/x86/boot/boot.h
> @@ -333,6 +333,7 @@ size_t strnlen(const char *s, size_t maxlen);
>  unsigned int atou(const char *s);
>
>  /* tty.c */
> +void serial_init(void);
>  void puts(const char *);
>  void putchar(int);
>  int getchar(void);
> diff --git a/arch/x86/boot/main.c b/arch/x86/boot/main.c
> index 140172b..1437efe 100644
> --- a/arch/x86/boot/main.c
> +++ b/arch/x86/boot/main.c
> @@ -127,6 +127,9 @@ static void init_heap(void)
>
>  void main(void)
>  {
> +       /* Initialize serial console */
> +       serial_init();
> +
>        /* First, copy the boot header into the "zeropage" */
>        copy_boot_params();
>
> diff --git a/arch/x86/boot/tty.c b/arch/x86/boot/tty.c
> index 01ec69c..2f0def5 100644
> --- a/arch/x86/boot/tty.c
> +++ b/arch/x86/boot/tty.c
> @@ -10,8 +10,7 @@
>  * ----------------------------------------------------------------------- */
>
>  /*
> - * Very simple screen I/O
> - * XXX: Probably should add very simple serial I/O?
> + * Very simple screen and serial I/O
>  */
>
>  #include "boot.h"
> @@ -20,13 +19,58 @@
>  * These functions are in .inittext so they can be used to signal
>  * error during initialization.
>  */
> +static int early_serial_base = 0x3f8;  /* ttyS0 */

it seems you should analyze the command line to get io port and baud rate.

earlycon=
console=uart8250...
console=ttyS0 etc.

cmdline_find_option could be used with this.

Thanks

Yinghai
