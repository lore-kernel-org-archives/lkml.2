Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082Ab2EVGAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 02:00:23 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:33460 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755248Ab2EVGAW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 02:00:22 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1205212308590.3231@ionos>
References: <CAH3Oq6T-OVj_=kVBdDXxize5v5hovp8FQSDhxCHvF_kcX4QPuA@mail.gmail.com>
	<alpine.LFD.2.02.1205212308590.3231@ionos>
Date: Tue, 22 May 2012 14:00:20 +0800
Message-ID: <CAH3Oq6S64c9ttsAStn05FTkg+VC0o27Ad4DhHs=b4E7AKjWdjA@mail.gmail.com>
Subject: Re: Add IRQS_PENDING for nested and simple irq handler as well
From: Ning Jiang <ning.n.jiang@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry that I do not make myself clear.

First, we should keep all the handle_*_irq behave in pretty much the
same way even just for the beauty of it. Every interrupt disabled in
suspend operation needs the ability to abort suspend if there is a
pending irq.

Second, let's take look at a example:

              |
       +---------+
        |   INTC  |
       +---------+
                  |  GPIO_IRQ
            +------------+
             | gpio-exp  |
            +------------+
               |            |
   GPIO0_IRQ  GPIO1_IRQ

In the above diagram, gpio expander has irq number GPIO_IRQ, it is
connected with two sub GPIO pins, GPIO0 and GPIO1.

During suspend, normally we want to set IRQF_NO_SUSPEND for GPIO_IRQ
so that gpio expander driver can handle the sub irq GPIO0_IRQ and
GPIO1_IRQ, and these two irqs themselves are handled by simple or
nested irq in some drivers(typically gpio and mfd driver), if they are
disabled during suspend, we want them to be able to abort suspend too.

2012/5/22 Thomas Gleixner <tglx@linutronix.de>:
> On Tue, 22 May 2012, Ning Jiang wrote:
>
>> >From eb72d4c573b482f85b227558deca297d8a8de1df Mon Sep 17 00:00:00 2001
>> From: Ning Jiang <ning.n.jiang@gmail.com>
>> Date: Tue, 22 May 2012 00:19:20 +0800
>> Subject: [PATCH] genirq: Add IRQS_PENDING for nested and simple irq
>> handler as well
>>
>> Usually nested and simple irq act as second level in interrupt
>> distribution tree, in suspend, we need to keep first level irq
>> functional by irq flag IRQF_NO_SUSPEND and check the 'pending'
>> state in the second level.
>>
>> More information can be found in the log of commit:
>
> Please provide a proper explanation why you think that handling the
> flag for those interrupts is important as well, rather than refering
> to an explanation of something different.
>
> Thanks,
>
>        tglx
