Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab1IODeJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 23:34:09 -0400
Received: from mail-vw0-f45.google.com ([209.85.212.45]:56437 "EHLO
	mail-vw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026Ab1IODeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 23:34:08 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Sep 2011 23:34:08 EDT
MIME-Version: 1.0
In-Reply-To: <20110914160013.GH4110@mails.so.argh.org>
References: <1315997270-14332-1-git-send-email-keguang.zhang@gmail.com>
	<20110914113134.GS15003@mails.so.argh.org>
	<CAJhJPsUW+4fpJUSR07LBO=FDCyAw-KHKaZCt8G+sHCJtjts0oA@mail.gmail.com>
	<20110914160013.GH4110@mails.so.argh.org>
Date: Thu, 15 Sep 2011 11:27:30 +0800
Message-ID: <CAJhJPsUXvGJBB-YiLB53VSf8GRXHjkrPRf3F3YE5ekOz-OVqgQ@mail.gmail.com>
Subject: Re: [PATCH] MIPS: Add basic support for Loongson1B
From: Kelvin Cheung <keguang.zhang@gmail.com>
To: Andreas Barth <aba@not.so.argh.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org, wuzhangjin@gmail.com, r0bertz@gentoo.org,
        chenj@lemote.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/15, Andreas Barth <aba@not.so.argh.org>:
> * Kelvin Cheung (keguang.zhang@gmail.com) [110914 15:54]:
>> 2011/9/14, Andreas Barth <aba@not.so.argh.org>:
>> > * keguang.zhang@gmail.com (keguang.zhang@gmail.com) [110914 12:49]:
>> >> This patch adds basic support for Loongson1B
>> >> including serial, timer and interrupt handler.
>> >
>> > I have a couple of questions. One of them is if it shouldn't be
>> > possible to add this as part of the loongson-platform, and if we
>> > really need a new platform. Each platform comes with some maintainence
>> > costs which we should try to avoid. Making things more generic is
>> > usually the right answer.
>>
>> I've tried to add Loongson1 to loongson-platform (acturally loongson2
>> platform), but there is essential difference between them. The
>> loongson2 platform is something like the PC's architecture, which has
>> north and south bridge, while the loongson1 is SoC.
>> So, I think it's better that adding loongson1 as a new platform.
>
> I'm not convinced, but that's also not necessary.

As I mentioned before, Loongson1 is a 32-bit SoC with many built-in
controllers, which implements the MIPS32 release 2 instruction set,
while Loongson2 is a 64-bit CPU, which only implements the MIPSIII
instruction set.
The Loongson1 does not have a PCI controller. And its interrupt and
gpio are different from Loongson2 ...

They are totally different thing.
So, it is hard to reuse the code of loongson-platform.

>> >> --- /dev/null
>> >> +++ b/arch/mips/loongson1/common/clock.c
>> >> @@ -0,0 +1,164 @@
>> >> +/*
>> >> + * Copyright (c) 2011 Zhang, Keguang <keguang.zhang@gmail.com>
>> >
>> > Is this file not derived from any of the clock drivers we already have
>> > in Linux?
>> >
>> > Doesn't any of the existing clock drivers work?
>> >
>> > Is this clock part of the CPU? Otherwise it would make sense to move
>> > it out to the generic drivers section.
>
> What's the answer to this questions?

I just did what other platform did, such as ar7, ath79, bcm63xx and
jz4740. Could you have a look at their clock.c/clk.c?

>> >> --- /dev/null
>> >> +++ b/arch/mips/loongson1/common/irq.c
>> >> @@ -0,0 +1,132 @@
>> >> +/*
>> >> + * Copyright (c) 2011 Zhang, Keguang <keguang.zhang@gmail.com>
>> >> + *
>> >> + * Based on Copyright (C) 2009 Lemote Inc.
>> >
>> > same question here. Also, do you have permission from Lemote to put
>> > the code within GPLv2?
>>
>> These code are based on the loongson platform, which is part of the
>> kernel code already.
>
> In that case, it would make sense to say "derived from arch/mips/..."
> so that other people can understand where it comes from.

Thanks! I will pay attention to this.

>> >> diff --git a/arch/mips/loongson1/common/prom.c
>> >> b/arch/mips/loongson1/common/prom.c
>> >> new file mode 100644
>> >> index 0000000..84a25f6
>> >> --- /dev/null
>> >> +++ b/arch/mips/loongson1/common/prom.c
>> >
>> > Can't we re-use the prom-routines from the loongson platform here? Or
>> > even better, factor them out somewhere else in the mips or even
>> > generic linux tree?
>>
>> Same reason as question 1.
>
> Not really. Please try to de-duplicate code as far as possible, and to
> generalize it's usage. Having some code of the form

I did not just duplicate code, modified exactly. The prom-routines of
loongson platform does not fit loongson1.For instance, the
"cpu_clock_freq" parameter is not needed. The cpu freq. could be get
from the PLL register directly. Moreover, the routines does not
include the parameter "ethaddr", which is useful for embedded system.

> +       while (((readb(PORT(UART_BASE, UART_LSR)) & UART_LSR_THRE) == 0)
> +                       && (timeout-- > 0))
> +               ;
> +
> +       writeb(c, PORT(UART_BASE, UART_TX));
> here doesn't make too much sense to me. (Also questioning why this is
> part of the prom.c file).
>

I just did what other platform did, such as ar7, bcm47xx and jz4740.
Could you have a look at their prom.c?

>
> Andi
>


-- 
Best Regards!
Kelvin
