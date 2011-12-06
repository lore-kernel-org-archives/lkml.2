Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932807Ab1LFAGL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 19:06:11 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43109 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932738Ab1LFAGJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 19:06:09 -0500
MIME-Version: 1.0
In-Reply-To: <4EDBA70E.3090905@ladisch.de>
References: <CAPRPZsCrGXKwYiOTzDde=5=8wMnMX0sxFvnustSSz4Z6BYJNzA@mail.gmail.com>
	<20111130154445.GA27198@gere.osrc.amd.com>
	<1E8B869C0C6913418421A406C094DF7C0205358F@sshaexmb1.amd.com>
	<CAPRPZsAL=xUCjTKaSgq117zppvZS0S7fHB0Ebk-JqXvV1vTPCQ@mail.gmail.com>
	<4EDB6C10.10102@ladisch.de>
	<CAPRPZsAc8wr_2KsRi3LnGi4ic-CzrFLbRvQfkrXckH--vaLkVQ@mail.gmail.com>
	<CAPRPZsBdnrProsTaSYnMKi6Q3dSsP9nYkw0CKnmb-BrmJxBivw@mail.gmail.com>
	<CAPRPZsBO_hvAv8o0vKh7XuE+RiEunETaxaPsmdm5yPe5YvOdPA@mail.gmail.com>
	<CAPRPZsDU2+ApCjQvEzRfOXfMLgfDS1j5zXF7hw4wy5yrzT-_7Q@mail.gmail.com>
	<4EDBA70E.3090905@ladisch.de>
Date: Tue, 6 Dec 2011 01:06:08 +0100
Message-ID: <CAPRPZsAqjWtbUH8FSh3O3C6iQ7+L11782fc1e=-UDSQkgm7FPg@mail.gmail.com>
Subject: Re: Unhandled IRQs on AMD E-450
From: Jeroen Van den Keybus <jeroen.vandenkeybus@gmail.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: "Huang, Shane" <Shane.Huang@amd.com>, Borislav Petkov <bp@amd64.org>,
        "Nguyen, Dong" <Dong.Nguyen@amd.com>, linux-kernel@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As long as there is nothing connected, there should be nothing but
> a timing interrupt every 64 seconds, like this:
>  firewire_ohci: IRQ 00200000 cycle64Seconds


That is correct. I see those messages indeed. Until now, however, I
have not been able / lucky to witness another IRQ 16 banning. Still
running the test.

But...

I have also been looking into the e1000 driver. What I did was add
printk's on every invocation of the e1000_intr(). I used
printk_ratelimit(), as well as a local occurrence counter. There are
three places where I did the check and what I wrote to the log:

1. Right after determining that the Interrupt Cause Register is zero.
That means the interrupt was not meant for or caused by the e1000
(hardware failure let alone) ==> e1000: not ours
2. Right after determining that the ICR is set, but the driver is not
active. ==> e1000: ours, but down
3. At the end of e1000_intr. ==> e1000: ours.

The result:

[113757.420967] e1000: ours (240)
[113759.424936] e1000: ours (241)
[113761.428516] e1000: ours (242)
[113761.428528] e1000: not ours (0)
[113761.428536] e1000: not ours (1)
[113761.428543] e1000: not ours (2)
[113761.428551] e1000: not ours (3)
[113761.428558] e1000: not ours (4)
[113761.428566] e1000: not ours (5)
[113761.428579] e1000: not ours (6)
[113762.676114] irq 19: nobody cared (try booting with the "irqpoll" option)
[113762.676126] Pid: 0, comm: swapper Not tainted 3.2.0-rc2 #7
[113762.676130] Call Trace:
[113762.676133]  <IRQ>  [<ffffffff810bb9cd>] __report_bad_irq+0x3d/0xe0
[113762.676151]  [<ffffffff810bbe0d>] note_interrupt+0x14d/0x210
[113762.676157]  [<ffffffff810b98a4>] handle_irq_event_percpu+0xc4/0x290
[113762.676164]  [<ffffffff810b9ab8>] handle_irq_event+0x48/0x70
[113762.676170]  [<ffffffff810bc7fa>] handle_fasteoi_irq+0x5a/0xe0
[113762.676177]  [<ffffffff81004012>] handle_irq+0x22/0x40
[113762.676183]  [<ffffffff81506baa>] do_IRQ+0x5a/0xd0
[113762.676189]  [<ffffffff814fe76b>] common_interrupt+0x6b/0x6b
[113762.676192]  <EOI>  [<ffffffff81009906>] ? native_sched_clock+0x26/0x70
[113762.676211]  [<ffffffffa00c50d3>] ?
acpi_idle_enter_simple+0xc5/0x102 [processor]
[113762.676219]  [<ffffffffa00c50ce>] ?
acpi_idle_enter_simple+0xc0/0x102 [processor]
[113762.676227]  [<ffffffff814223b8>] cpuidle_idle_call+0xb8/0x230
[113762.676234]  [<ffffffff81001215>] cpu_idle+0xc5/0x130
[113762.676241]  [<ffffffff814e2370>] rest_init+0x94/0xa4
[113762.676248]  [<ffffffff81aafba4>] start_kernel+0x3a7/0x3b4
[113762.676254]  [<ffffffff81aaf322>] x86_64_start_reservations+0x132/0x136
[113762.676260]  [<ffffffff81aaf416>] x86_64_start_kernel+0xf0/0xf7
[113762.676264] handlers:
[113762.676271] [<ffffffffa01164f0>] e1000_intr
[113762.676275] Disabling IRQ #19
[113768.766055] firewire_ohci: IRQ 00200000 cycle64Seconds
[113832.768181] firewire_ohci: IRQ 00200000 cycle64Seconds
[113896.770536] firewire_ohci: IRQ 00200000 cycle64Seconds
[113960.772976] firewire_ohci: IRQ 00200000 cycle64Seconds
[114024.775340] firewire_ohci: IRQ 00200000 cycle64Seconds
[114088.776662] firewire_ohci: IRQ 00200000 cycle64Seconds
[114152.778105] firewire_ohci: IRQ 00200000 cycle64Seconds
[114200.220155] e1000 0000:05:01.0: PCI INT A disabled
[114216.779703] firewire_ohci: IRQ 00200000 cycle64Seconds
[114265.335175] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[114265.335185] e1000: Copyright (c) 1999-2006 Intel Corporation.
[114265.335268] e1000 0000:05:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[114265.931952] e1000 0000:05:01.0: eth1: (PCI:33MHz:32-bit) 00:0e:0c:d9:6f:ca
[114265.931977] e1000 0000:05:01.0: eth1: Intel(R) PRO/1000 Network Connection
[114265.947250] e1000_intr: 199750 callbacks suppressed
[114265.947257] e1000: ours (0)
[114265.948433] e1000: ours (1)
[114267.9:52645] e1000: ours (2)
[114269.956659] e1000: ours (3)
[114271.960528] e1000: ours (4)
[114273.964811] e1000: ours (5)

The e1000 chip raises the IRQ every 2 seconds. The e1000 driver sees
it ([...] e1000: ours) and, by reading the ICR, clears the IRQ line.

At ours (242) the interrupt arrives exactly at its expected time.
However, 8 microseconds later, e1000_intr() is invoked again. Now the
ICR is still empty, so e1000_intr() is returning IRQ_NONE. Then,
e1000_intr() is overwhelmed by interrupts that are apparently not
caused by the e1000 (and, by reading its ICR every time again, that
IRQ would have been cleared anyway). I suspect that the IRQ is simply
not properly acknowledged. (Only 6 occurrences of 'not ours' were
logged as a result of the use of printk_ratelimit(). After unloading
and loading the modified e1000.ko, ratelimit reports that nearly 200k
messages have been suppressed.)

I will now be checking this again on a fresh build (to ensure I
haven't forgotten to unpatch anything). I will also install a new
e1000 card although I doubt that it is defective.


J.
