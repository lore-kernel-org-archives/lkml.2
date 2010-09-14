Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab0INQGL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 12:06:11 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58835 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864Ab0INQGE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 12:06:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=WpYh+01AA00H81WsbvIGNejXbZM+F1vt4U367JgP8sKqPhhkhSxCAq6qC6zJDEt5BA
         LhgJGVj0eplY9+gFzLEjsr/47ndyOz4SOiDvxFuV5WFzFSTFiIfV4uLM0Nzp10VkesCC
         ZI5zQCMK0P6683q3ToDpgUPWd3JHoiiyIid8k=
MIME-Version: 1.0
In-Reply-To: <1282329921-24394-1-git-send-email-timur@freescale.com>
References: <1282329921-24394-1-git-send-email-timur@freescale.com>
From: Timur Tabi <timur@freescale.com>
Date: Tue, 14 Sep 2010 11:05:32 -0500
X-Google-Sender-Auth: e7AH8zjEU9fTE-mtoBOvLBWPI3w
Message-ID: <AANLkTikn-DW6g9Zx07vR8hn7Zk3O=JMTe+r9CRbPe_YH@mail.gmail.com>
Subject: Re: [PATCH] hvc_console: fix dropping of characters when output byte
 channel is full
To: Andrew Morton <akpm@kernel.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, kumar.gala@freescale.com,
        amit.shah@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Would you please take a moment to review this patch I sent last month?
I'd like for it to be incorporated into 2.6.37, but I'm having a hard
time finding someone to consider it.

Thanks.

On Fri, Aug 20, 2010 at 1:45 PM, Timur Tabi <timur@freescale.com> wrote:
> hvc_console_print() calls the HVC client driver's put_chars() callback
> to write some characters to the console.  If the callback returns 0, that
> indicates that no characters were written (perhaps the output buffer is
> full), but hvc_console_print() treats that as an error and discards the
> rest of the buffer.
>
> So change hvc_console_print() to just loop and call put_chars() again if it
> returns a 0 return code.
>
> This change makes hvc_console_print() behave more like hvc_push(), which
> does check for a 0 return code and re-schedules itself.
>
> Signed-off-by: Timur Tabi <timur@freescale.com>
> ---
>  drivers/char/hvc_console.c |   19 ++++++++++++++++++-
>  1 files changed, 18 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/char/hvc_console.c b/drivers/char/hvc_console.c
> index fa27d16..b4deffd 100644
> --- a/drivers/char/hvc_console.c
> +++ b/drivers/char/hvc_console.c
> @@ -3,6 +3,7 @@
>  * Copyright (C) 2001 Paul Mackerras <paulus@au.ibm.com>, IBM
>  * Copyright (C) 2004 Benjamin Herrenschmidt <benh@kernel.crashing.org>, IBM Corp.
>  * Copyright (C) 2004 IBM Corporation
> + * Copyright 2009 Freescale Semiconductor, Inc.
>  *
>  * Additional Author(s):
>  *  Ryan S. Arnold <rsa@us.ibm.com>
> @@ -141,6 +142,7 @@ static void hvc_console_print(struct console *co, const char *b,
>        char c[N_OUTBUF] __ALIGNED__;
>        unsigned i = 0, n = 0;
>        int r, donecr = 0, index = co->index;
> +       unsigned int timeout = 1000000; /* Keep trying for up to one second */
>
>        /* Console access attempt outside of acceptable console range. */
>        if (index >= MAX_NR_HVC_CONSOLES)
> @@ -152,6 +154,10 @@ static void hvc_console_print(struct console *co, const char *b,
>
>        while (count > 0 || i > 0) {
>                if (count > 0 && i < sizeof(c)) {
> +                       /* If the local buffer (c) is not full, then copy some
> +                        * bytes from the input buffer to it. We stop when the
> +                        * local buffer is full. \n is converted to \r\n.
> +                        */
>                        if (b[n] == '\n' && !donecr) {
>                                c[i++] = '\r';
>                                donecr = 1;
> @@ -162,14 +168,25 @@ static void hvc_console_print(struct console *co, const char *b,
>                        }
>                } else {
>                        r = cons_ops[index]->put_chars(vtermnos[index], c, i);
> -                       if (r <= 0) {
> +                       if (r < 0) {
>                                /* throw away chars on error */
>                                i = 0;
>                        } else if (r > 0) {
>                                i -= r;
>                                if (i > 0)
>                                        memmove(c, c+r, i);
> +                       } else {
> +                               /* If r == 0, then the client driver didn't do
> +                                * anything, so wait 1us and try again.  If we
> +                                * time out, then just exit.
> +                                */
> +                               if (!--timeout)
> +                                       return;
> +                               udelay(1);
> +                               continue;
>                        }
> +                       /* Reset the timeout */
> +                       timeout = 1000000;
>                }
>        }
>  }
> --
> 1.7.0.1
>
>
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
>



-- 
Timur Tabi
Linux kernel developer at Freescale
