Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816Ab1LIIVQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 03:21:16 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:58140 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751025Ab1LIIVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 03:21:15 -0500
X-Sasl-enc: EKr+2gIegAazlLRHHuMWSbNWyPH8m3Hd/6HxH/4/W9bq 1323418873
Message-ID: <4EE1C55B.9010708@ladisch.de>
Date: Fri, 09 Dec 2011 09:22:51 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Jeroen Van den Keybus <jeroen.vandenkeybus@gmail.com>
CC: "Huang, Shane" <Shane.Huang@amd.com>, Borislav Petkov <bp@amd64.org>,
        "Nguyen, Dong" <Dong.Nguyen@amd.com>, linux-kernel@vger.kernel.org
Subject: Re: Unhandled IRQs on AMD E-450
References: <CAPRPZsCrGXKwYiOTzDde=5=8wMnMX0sxFvnustSSz4Z6BYJNzA@mail.gmail.com> <20111130154445.GA27198@gere.osrc.amd.com> <1E8B869C0C6913418421A406C094DF7C0205358F@sshaexmb1.amd.com> <CAPRPZsAL=xUCjTKaSgq117zppvZS0S7fHB0Ebk-JqXvV1vTPCQ@mail.gmail.com> <4EDB6C10.10102@ladisch.de> <CAPRPZsAc8wr_2KsRi3LnGi4ic-CzrFLbRvQfkrXckH--vaLkVQ@mail.gmail.com> <CAPRPZsBdnrProsTaSYnMKi6Q3dSsP9nYkw0CKnmb-BrmJxBivw@mail.gmail.com> <CAPRPZsBO_hvAv8o0vKh7XuE+RiEunETaxaPsmdm5yPe5YvOdPA@mail.gmail.com> <CAPRPZsDU2+ApCjQvEzRfOXfMLgfDS1j5zXF7hw4wy5yrzT-_7Q@mail.gmail.com> <4EDBA70E.3090905@ladisch.de> <CAPRPZsAqjWtbUH8FSh3O3C6iQ7+L11782fc1e=-UDSQkgm7FPg@mail.gmail.com> <CAPRPZsBzBNzrzbNDN2fBnWwQ-MYcRssfY5V+5mDXLbJ+-gd9SA@mail.gmail.com> <4EE0B156.4080708@ladisch.de> <CAPRPZsDmbfESXov1XzOYXv6WSTFAevNwD5jyBdwGU--kffLaMQ@mail.gmail.com>
In-Reply-To: <CAPRPZsDmbfESXov1XzOYXv6WSTFAevNwD5jyBdwGU--kffLaMQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeroen Van den Keybus wrote:
> the ASM1083 can only be the cause if the Firewire controller is also
> on that bus.

The VT6308 is PCI, and you have only one bus.

>> It appears that some Deassert_INTx messages get lost on your system.
>> There are no indications of any other missing PCIe packets, so this
>> looks like a problem with the interrupt handling in your PCI/PCIe
>> bridge, the ASM1083 chip.
>
> Assuming this is the case, I modified the e1000 driver to explicitly
> set its IRQ line after 5 times having to send IRQ_NONE. (e1000_intr()
> code at end of this post). The result of this test is that the IRQ
> line indeed is set (in the next invocation, the ISR sees the forced
> RXT0 interrupt, clears the IRQ line and sends IRQ_HANDLED). But alas,
> the storm is not silenced at all.
>
> If the ASM108x was the problem, I suspect that explicitly raising and
> clearing the interrupt would have retriggered the INTx_Assert and
> INTx_Deassert messages ?

Yes.

> Meaning the bridge wouldn't be the problem.

It's possible that
1) the ASM1083 does not react to changes of the PCI interrupt line, or
2) the interrupt controller ignores INTx_Deassert messages.

I'm wondering what the difference between triggering an interrupt and
reloading the driver is that makes it work again.  I'd guess that
reattaching the driver reinitializes the interrupt, which would point
to 2).

> If I understand correctly, the IO-APIC is not even used in this case ?
> (IRQ requests from e1000 all going through PCIe) Or is there also
> a virtual IO-APIC monitoring Assert and Deassert messages.

All PCI interrupts (whether 'real' lines in hardware or emulated with
PCIe messages) end up at the I/O-APIC.

> Is the BIOS responsible for writing a mapping for the PCI IRQs to MSIs
> into the ASM108x ?

MSIs are edge-triggered; their message is different from the (de)assert
messages used for PCI level-triggered interrupts.

AFAIK the interrupt handling in a PCI/PCIe bridge should work
transparently, i.e., the bridge does not need to be configured by
software.

The BIOS is responsible for telling the kernel about all interrupt
mappings, and ACPI takes part in initializing the I/O-APIC.
Check if a newer BIOS exists.

> (And BTW, should the linux1394-devel still be posted ?)

Your trigger-interrupt patch would also be possible with firewire-ohci.

> I'm thinking of immediately re-enabling the irqs after they've been
> disabled in spurious.c.

You could try free_irq/request_irq, but I guess you cannot do this
directly from inside an interrupt handler.

> I also think that the following posts may refer to the same problem:
>
> http://ubuntuforums.org/showthread.php?t=1883854
> https://lkml.org/lkml/2011/6/30/197
> https://lkml.org/lkml/2011/10/14/146

That's similar symptoms, but completely different hardware.


Regards,
Clemens
