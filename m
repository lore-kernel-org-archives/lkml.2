Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932589Ab2EJJYj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 05:24:39 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56737 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932448Ab2EJJYe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 05:24:34 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwiLp1z+2mzkrFsid1WZQ0TQkcn8F2E6NL_AVR+m1fZ2w@mail.gmail.com>
References: <Pine.LNX.4.64.1205042250130.18896@file.rdu.redhat.com>
	<20120505115851.1fecbe50@pyramind.ukuu.org.uk>
	<Pine.LNX.4.64.1205051448400.2623@file.rdu.redhat.com>
	<CA+55aFy2O8KcLC-yGCG2ZRpCpAdZ_T7z-sSme4fMrXG=YNAAhA@mail.gmail.com>
	<Pine.LNX.4.64.1205082259350.16707@file.rdu.redhat.com>
	<CA+55aFwiLp1z+2mzkrFsid1WZQ0TQkcn8F2E6NL_AVR+m1fZ2w@mail.gmail.com>
Date: Thu, 10 May 2012 11:24:32 +0200
X-Google-Sender-Auth: RLe2w-Yl2_C20l-6g6vcpn0S274
Message-ID: <CAMuHMdX+TjGqeGVxb6_aw_B8=VUYF7jPaUow6H=p-XW5ZA-TPg@mail.gmail.com>
Subject: Re: [PATCH] Fix compile failure on PA-RISC
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 9, 2012 at 7:51 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, May 8, 2012 at 8:20 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>>> Switching it to zero and testing that things still work would be appreciated.
>> It works, but there is plenty of interrupt controllers on PC-RISC and I
>> can only test it on C8000 with IO-SAPIC. I don't know if irq 0 is used on
>> some PA-RISC interrupt controller. It would be best if James Bottomley
>> tests it on his set of machines.
>
> Heh. It sounds like we have more PA-RISC machines than we have actual users.
>
>> And what about x86? --- irq 0 is used for timer and there is
>> void __init setup_default_timer_irq(void)
>> {
>>        setup_irq(0, &irq0);
>> }
>> in arch/x86/kernel/time.c.
>
> That's fine. There's no "irq" variable associated with it that people
> can test. No driver will ever see an irq number of zero, no dynamic
> irq code will ever see the zero.
>
> So x86 rules have always been that the way drivers etc test for irq
> existence has always been "irq 0 means no irq". Despite the fact that
> it internally uses irq0 for its own nefarious uses.

So can x86 please show the purely internal irq0 in its arch_show_interrupts(),
and accept "[PATCH] /proc/interrupts: irq zero is invalid"
(http://lkml.indiana.edu/hypermail/linux/kernel/1112.0/02229.html)?

Also, the several for_each_irq*() macros still iterate over zero, e.g.

# define for_each_irq_desc(irq, desc)                                   \
        for (irq = 0, desc = irq_to_desc(irq); irq < nr_irqs;           \
             irq++, desc = irq_to_desc(irq))                            \
                if (!desc)                                              \
                        ;                                               \
                else


# define for_each_irq_desc_reverse(irq, desc)                           \
        for (irq = nr_irqs - 1, desc = irq_to_desc(irq); irq >= 0;      \
             irq--, desc = irq_to_desc(irq))                            \
                if (!desc)                                              \
                        ;                                               \
                else

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
