Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab1HYKN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 06:13:26 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37445 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab1HYKNY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 06:13:24 -0400
MIME-Version: 1.0
In-Reply-To: <20110823221631.GA6827@rz>
References: <CAMuHMdV1bpFDkLyDsdkzgvQg6_C1Jf=hwR=VOVBObB19mhH6yA@mail.gmail.com>
	<20110823221631.GA6827@rz>
Date: Thu, 25 Aug 2011 12:13:22 +0200
X-Google-Sender-Auth: _9tPaxuGDgUWt8QryR4-s605HW4
Message-ID: <CAMuHMdW3SfQO9uYgPH12gr_WsAGFAD71fym-k20BafSkv735jw@mail.gmail.com>
Subject: Re: Q40 interrupts (and genirq)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Richard <rz@linux-m68k.org>
Cc: "Linux/m68k" <linux-m68k@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Wed, Aug 24, 2011 at 00:16, Richard <rz@linux-m68k.org> wrote:
>> I'm a bit puzzled by the Q40 interrupt architecture.
>>
>> arch/m68k/q40/q40ints.c says:
>>
>>  * Q40 IRQs are defined as follows:
>>  *            3,4,5,6,7,10,11,14,15 : ISA dev IRQs
>>
>> Yep, that's _9_ interrupts.
>
> 11 conflicts with q40_irq_startup() but I am not quite sure at the moment which
> one is right. Iirc some of the irqs are shared/indistinguishable as sources but were
> still defined both separately just in case the number is needed.
>
>> In the "new" interrupt code, by Roman Zippel, all interrupts sources are handled
>> through q40_irq_handler().
>> Only autovector IRQs IRQ_AUTO_2 and IRQ_AUTO_4 are enabled.
>>
>> In the old (pre-2006) interrupt code, only internal (master) and ISA interrupts
>> go through q40_irq2_handler on IRQ_AUTO_2.
>> Q40_IRQ_SAMPLE goes via both IRQ_AUTO_4 and IRQ_AUTO_6.
>>
>> Why doesn't the new code use IRQ_AUTO_6? Does the new code work?
>
> iirc IRQ_AUTO_6 was needed for some very early versions of the master chip,
> should work without.
>
> I will need to verify this points but don't have the HW manual right here.
>
>> For the genirq conversion, I was first thinking about using a custom
>> chain-alike flow handler.
>> But it looks like this is not possible, as the Q40 handler remaps
>> autovector interrupts to
>> conflicting numbers (it handles IRQ_AUTO_4 = 4, but ISA interrupt 4 is also 4).
>> So if the custom flow handler would call generic_handle_irq(4) for ISA
>> interrupt 4,
>> it would recurse into the flow handler set up for autovector IRQ 4 :-(
>
> The numbers are equal but they mean different things at different stages
> of abstraction/translation/mapping which is normally no concern as long as
> it is clear at which stage it is.
>
> Perhaps the new algorithm would need an extra flag to keep track of what it
> is dealing with.
> What are the problems you are trying to solve with the new handler?

I'm solving the problem that m68k still doesn't use genirq (and is the single
architecture still doing so, except for s390, which is "different" anyway).

> For the Q40, IRQ_AUTO_4 should be translated to "34   : sample int (10/20 KHz periodic timer)"
> IRQ_AUTO_2 needs further decoding before it can be decided what should be handled.
> It can be any of the ISA irqs or one of 32,33.
>
> So as long as ISA drivers can use the numbers 1-15 and the Q40 specific
> drivers 32-34 nothing there should not be a problem

Thanks! This confirms my findings.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
