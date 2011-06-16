Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133Ab1FPTpP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 15:45:15 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54571 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757787Ab1FPTpN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 15:45:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=W1/i4rTshH/S5q6kp6hmNbqdE6DwDF/glZGUYF9ezTLyASntB3KA6FqkLf1vfCOhP1
         J6RomQdB05ri6Dq2MZLMzcQygNjFVIq0nUsfi1DLFmTOAE+9iYszWPgR5IGXBihycTEY
         MEoS3UtCe1bDKOrma6A/cH8hPWcphKw1v5sxs=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1105282010370.16617@ayla.of.borg>
References: <alpine.DEB.2.00.1105282010370.16617@ayla.of.borg>
Date: Thu, 16 Jun 2011 21:45:11 +0200
X-Google-Sender-Auth: 8vNBCyu30t3Qua-FwjWpa8ETE5U
Message-ID: <BANLkTinDvLqHChPUpG9v1AXp0E=iRLteDg@mail.gmail.com>
Subject: Re: m68k: Convert to genirq (WIP)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andreas Schwab <schwab@linux-m68k.org>,
        Michael Schmitz <schmitzmic@googlemail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 28, 2011 at 20:32, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> | ------------[ cut here ]------------
> | WARNING: at linux/kernel/irq/handle.c:130 handle_irq_event_percpu+0xe6/0x148()
> | irq 3 handler nfeth_interrupt+0x0/0x126 enabled interrupts
> | Modules linked in:
> | Call Trace: [<00027670>] warn_slowpath_common+0x3e/0x64
> |  [<0002767e>] warn_slowpath_common+0x4c/0x64
> |  [<0002770c>] warn_slowpath_fmt+0x2a/0x32
> |  [<0004d01a>] handle_irq_event_percpu+0xe6/0x148
> |  [<0004d01a>] handle_irq_event_percpu+0xe6/0x148
> |  [<00009d64>] nfeth_interrupt+0x0/0x126
> |  [<00027dc8>] printk+0x0/0x1a
> |  [<0004d09c>] handle_irq_event+0x20/0x2c
> |  [<0004ecce>] handle_level_irq+0x50/0x9c
> |  [<002496b8>] schedule+0x0/0x31e
> |  [<00006782>] do_IRQ+0x2e/0x44
> |  [<00027dc8>] printk+0x0/0x1a
> |  [<00003eb4>] __m68k_handle_int+0xe/0x12
> |  [<000026e2>] auto_irqhandler_fixup+0x4/0x6
> |  [<00027dc8>] printk+0x0/0x1a
> |  [<00002c46>] default_idle+0x0/0xe
> |  [<00002b0c>] cpu_idle+0x16/0x22
> |  [<00002b18>] kernel_thread+0x0/0x4e
> |  [<00248610>] rest_init+0x5c/0x62
> |  [<0031a220>] start_kernel+0x3a4/0x3b0
> |  [<000106aa>] ssincos+0x27e/0x2ac
> |  [<000106aa>] ssincos+0x27e/0x2ac
> |  [<0031931e>] _sinittext+0x31e/0x9c0
> |
> | ---[ end trace 139ce121c98e96cb ]---

This is the WARN_ONCE(!irqs_disabled()) check.

static inline bool arch_irqs_disabled_flags(unsigned long flags)
{
        return (flags & ~ALLOWINT) != 0;
}

with flags = 0x2300. Due to the "special" value of ALLOWINT on Atari:

#if defined(MACH_ATARI_ONLY)
        /* block out HSYNC on the atari */
#define ALLOWINT        (~0x400)
#define MAX_NOINT_IPL   3
#else
        /* portable version */
#define ALLOWINT        (~0x700)
#define MAX_NOINT_IPL   0
#endif /* machine compilation types */

the test fails.

Would it harm to always use the "portable" version?
That one is used on multi-platform kernels anyway?
Or would it cause too many HBLANK interrupts?

BTW, MAX_NOINT_IPL is no longer used.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
