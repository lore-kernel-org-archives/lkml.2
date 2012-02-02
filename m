Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab2BBWlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 17:41:47 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:57262 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753043Ab2BBWlp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 17:41:45 -0500
MIME-Version: 1.0
In-Reply-To: <CADdbW+EmBWiz=3UDvN+UtXZ-io7iJsDfia6xWPm+MrrH+xXA3w@mail.gmail.com>
References: <4E68A6E8.9020700@pobox.com>
	<20110908165155.f661a738.akpm@linux-foundation.org>
	<4F26B162.4050000@pobox.com>
	<4F274E28.2010200@gmail.com>
	<4F27D9AD.1020806@pobox.com>
	<CADdbW+Eaab4ucATwX+ao-P+kcms-AJKQMGZr2E6g73gLACZSZg@mail.gmail.com>
	<CA+55aFytBRZiQUcnWtSYnxqXUJCfVuS4f5tq=QUNG2GfbF1mhA@mail.gmail.com>
	<CADdbW+EmBWiz=3UDvN+UtXZ-io7iJsDfia6xWPm+MrrH+xXA3w@mail.gmail.com>
Date: Thu, 2 Feb 2012 23:41:44 +0100
Message-ID: <CAPRPZsB8MakxizGJuT7E9mEvdH6QT6fVzuckE0-yxi4RLD0xKQ@mail.gmail.com>
Subject: Re: ASM1083 PCIx-PCI bridge interrupts - widespread problems
From: Jeroen Van den Keybus <jeroen.vandenkeybus@gmail.com>
To: Edward Donovan <edward.donovan@numble.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Palmer <chris.palmer@pobox.com>,
        Robert Hancock <hancockrwd@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
        ghost3k@ghost3k.net, linux-kernel@vger.kernel.org, keve@irb.hu,
        bjorn.ottervik@gmail.com, kaneda@freemail.hu, clemens@ladisch.de,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> And we'd probably need to limit the warning messages if we start
>> re-enabling it - so that people with constantly screaming interrupts
>> don't get a constant stream of 10 "nobody cared, disabling" messages
>> per second.

Main reason for the patch to comment out __report_bad_irq(). There's
other printk's in there right now, allowing monitoring of the patch's
(hack's) performance. After 2 months of testing, the following is a
typical result on my Asus E45M1-M board:

[1675739.482843] Disabling IRQ 16
[1675739.488056] Polling IRQ 16
[1675740.288244] Reenabling IRQ 16
[1675740.288363] Disabling IRQ 16
[1675740.296132] Polling IRQ 16
...
[1675802.512233] Polling IRQ 16
[1675803.312244] Reenabling IRQ 16
[1675803.312362] Disabling IRQ 16
[1675803.320233] Polling IRQ 16
[1675804.120229] Reenabling IRQ 16

Because this particular IRQ is only asserted once every 64 s, polling
mode stays active for that amount of time, until a new INTx Deassert
is received. So it appears that INTx Deassert is not delayed, but
simply lost (either not sent or not received by the IO-APIC).

I did a test (https://lkml.org/lkml/2011/12/8/329) in which I
programmed an e1000 to issue one of the interrupts it doesn't use/need
(RXT0). From that log, it is clear that raising and clearing the IRQ
after more than 60 µs did not generate the expected INTx Deassert
either. There is serious trouble with this device.

> * New logic in the generic IRQ code, in spurious.c, adding a "try
> polling, then re-enable for
>  a while" method, for everybody?

Something like it (poll for a while, then try reenabling). Please see
the patch (https://lkml.org/lkml/2012/1/30/432) for the general idea.

> * Could there be more hardware-specifc code, to crank up the
> frequency, when you do have this chip?  I don't think we have this
> facility at present: would we let the arch-or-drivers code set a
> variable, to be honored by irq/spurious.c?

I would propose to crank up the frequency adaptively. Whenever
reenabling fails (i.e. is followed by a storm immediately), the
poll_spurious_irq_timer interval may be increased gradually up to,
say, 100ms (the value currently used by irqpoll). In the other cases,
it could be decreased progressively to e.g. 1 ms. So add or subtract
one ms of polling time whenever reenabling fails or succeeds,
respectively. Attempt to reenable an IRQ could occur after a fixed
amount of polling cycles (100).

Alternatively, the interval could also be modified by the number of
interrupts received in an interval.

- When, Heaven forbid, more than one IRQ is handled by this mechanism,
what would the polling interval need to be ? The shortest of them all
? Can/should timers be created dynamically ?
- Would struct irq_desc be an appropriate place to keep the per-irq
variables to accomplish all this ? I noticed that there is also
irq_data.
- Are there any alignment/security requirements on struct irq_desc to
be aware of ?
- Alan Cox also suggested that IRQ 0 'magic' could be an issue. I
cannot really find what he refers to in spurious.c, but it may be
important ?
- Are there any drivers that would not be able to operate in a polling fashion ?



J.
