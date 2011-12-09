Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948Ab1LILRp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 06:17:45 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56518 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab1LILRo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 06:17:44 -0500
MIME-Version: 1.0
In-Reply-To: <4EE1C55B.9010708@ladisch.de>
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
	<CAPRPZsAqjWtbUH8FSh3O3C6iQ7+L11782fc1e=-UDSQkgm7FPg@mail.gmail.com>
	<CAPRPZsBzBNzrzbNDN2fBnWwQ-MYcRssfY5V+5mDXLbJ+-gd9SA@mail.gmail.com>
	<4EE0B156.4080708@ladisch.de>
	<CAPRPZsDmbfESXov1XzOYXv6WSTFAevNwD5jyBdwGU--kffLaMQ@mail.gmail.com>
	<4EE1C55B.9010708@ladisch.de>
Date: Fri, 9 Dec 2011 12:17:40 +0100
Message-ID: <CAPRPZsDtPhjm2S5QxDSkDV2zsz+ABCkL_Rkeq-=Fnpx4+Czzcw@mail.gmail.com>
Subject: Re: Unhandled IRQs on AMD E-450
From: Jeroen Van den Keybus <jeroen.vandenkeybus@gmail.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: "Huang, Shane" <Shane.Huang@amd.com>, Borislav Petkov <bp@amd64.org>,
        "Nguyen, Dong" <Dong.Nguyen@amd.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The VT6308 is PCI, and you have only one bus.

There's also a bridge on the FCH: bus 0 dev. 14 fn. 4, but I see that
the memory and IO regions of the e1000 and the VT630x are withing the
range of the ASM108x bridge. Thanks for pointing that out.

> It's possible that
> 1) the ASM1083 does not react to changes of the PCI interrupt line, or
> 2) the interrupt controller ignores INTx_Deassert messages.

I'm a bit puzzled. The IOAPIC operates on external IRQ lines. So that
would mean the LAPICs ?

> I'm wondering what the difference between triggering an interrupt and
> reloading the driver is that makes it work again.  I'd guess that
> reattaching the driver reinitializes the interrupt, which would point
> to 2).

I tried irq_disable(); irq_enable(); in spurious.c. That didn't change
anything. Storm continues. Also important: from my logs it appears
that when a driver is reloaded, there is indeed no storm at all. In my
log posted at Dec. 6, that is clearly visible.

> All PCI interrupts (whether 'real' lines in hardware or emulated with
> PCIe messages) end up at the I/O-APIC.

That would mean that the IO-APIC would decode MSI messages. I don't
think it can do that. Would it not be possible that the PCI bus IRQ
lines are directly connected to the FCH IO-APIC inputs (and that the
ASM1083 INTx lines are simply not connected ?

(Makes me wonder why Asus did not simply use the existing PCI bridge
on the FCH, which BTW also seems to depend on the use of the external
INTx lines.)

> Check if a newer BIOS exists.

Did that. No newer version is available.

> Your trigger-interrupt patch would also be possible with firewire-ohci.

If this would work, you'd have to patch the drivers of all PCI
devices. I'd much rather do it by modifying something in the IRQ
handling code.

>> I'm thinking of immediately re-enabling the irqs after they've been
>> disabled in spurious.c.

> You could try free_irq/request_irq, but I guess you cannot do this
> directly from inside an interrupt handler.

No, I did irq_disable/irq_enable, which should directly call the
mask/unmask methods of the chip handler. I still must check that,
though, and especially if the correct handler is used. But as I said
before, it didn't seem to do the trick.

>> I also think that the following posts may refer to the same problem:

<< > That's similar symptoms, but completely different hardware.
At first sight, yes, but they still share some of the problem areas. I
justed wanted to point out possibly similar cases. Never mind.

(
>> http://ubuntuforums.org/showthread.php?t=1883854
Asus board with ASM1083 (same bridge).

>> https://lkml.org/lkml/2011/6/30/197
>> https://lkml.org/lkml/2011/10/14/146
Has device 1b21:1080 (same bridge) in its Asus system.

https://lkml.org/lkml/2011/10/22/157
Has a E35M1-M board (essentially the same board as the E45M1-M with
the AMD E350 instead of the E450)
)


J.
