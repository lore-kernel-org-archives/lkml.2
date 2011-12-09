Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab1LIMxj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 07:53:39 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:51772 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751570Ab1LIMxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 07:53:38 -0500
X-Sasl-enc: MxoybRXDyliaUQ3uKunU0V+5Tt3dQW9603am1Z0LTOEq 1323435217
Message-ID: <4EE20531.7000607@ladisch.de>
Date: Fri, 09 Dec 2011 13:55:13 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Jeroen Van den Keybus <jeroen.vandenkeybus@gmail.com>
CC: "Huang, Shane" <Shane.Huang@amd.com>, Borislav Petkov <bp@amd64.org>,
        "Nguyen, Dong" <Dong.Nguyen@amd.com>, linux-kernel@vger.kernel.org
Subject: Re: Unhandled IRQs on AMD E-450
References: <CAPRPZsCrGXKwYiOTzDde=5=8wMnMX0sxFvnustSSz4Z6BYJNzA@mail.gmail.com> <20111130154445.GA27198@gere.osrc.amd.com> <1E8B869C0C6913418421A406C094DF7C0205358F@sshaexmb1.amd.com> <CAPRPZsAL=xUCjTKaSgq117zppvZS0S7fHB0Ebk-JqXvV1vTPCQ@mail.gmail.com> <4EDB6C10.10102@ladisch.de> <CAPRPZsAc8wr_2KsRi3LnGi4ic-CzrFLbRvQfkrXckH--vaLkVQ@mail.gmail.com> <CAPRPZsBdnrProsTaSYnMKi6Q3dSsP9nYkw0CKnmb-BrmJxBivw@mail.gmail.com> <CAPRPZsBO_hvAv8o0vKh7XuE+RiEunETaxaPsmdm5yPe5YvOdPA@mail.gmail.com> <CAPRPZsDU2+ApCjQvEzRfOXfMLgfDS1j5zXF7hw4wy5yrzT-_7Q@mail.gmail.com> <4EDBA70E.3090905@ladisch.de> <CAPRPZsAqjWtbUH8FSh3O3C6iQ7+L11782fc1e=-UDSQkgm7FPg@mail.gmail.com> <CAPRPZsBzBNzrzbNDN2fBnWwQ-MYcRssfY5V+5mDXLbJ+-gd9SA@mail.gmail.com> <4EE0B156.4080708@ladisch.de> <CAPRPZsDmbfESXov1XzOYXv6WSTFAevNwD5jyBdwGU--kffLaMQ@mail.gmail.com> <4EE1C55B.9010708@ladisch.de> <CAPRPZsDtPhjm2S5QxDSkDV2zsz+ABCkL_Rkeq-=Fnpx4+Czzcw@mail.gmail.com>
In-Reply-To: <CAPRPZsDtPhjm2S5QxDSkDV2zsz+ABCkL_Rkeq-=Fnpx4+Czzcw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeroen Van den Keybus wrote:
>> I'm wondering what the difference between triggering an interrupt and
>> reloading the driver is that makes it work again.  I'd guess that
>> reattaching the driver reinitializes the interrupt, which would point
>> to 2).
>
> I tried irq_disable(); irq_enable(); in spurious.c. That didn't change
> anything. Storm continues. Also important: from my logs it appears
> that when a driver is reloaded, there is indeed no storm at all.

Temporarily disabling an irq is different from completely shutting it
down.

>> All PCI interrupts (whether 'real' lines in hardware or emulated with
>> PCIe messages) end up at the I/O-APIC.
>
> That would mean that the IO-APIC would decode MSI messages.

PCI interrupt messages (INTx_(de)assert) are special messages, while MSI
messages are just normal memory writes.

PCI interrupts (whether external or emulated) are always handled by the
I/O-APIC.

MSI interrupts usually go to some LAPIC (see the MSI address in the
lspci output; the I/O-APIC is at FEC00000, the LAPICs are at FEE00000).

> Would it not be possible that the PCI bus IRQ lines are directly
> connected to the FCH IO-APIC inputs (and that the ASM1083 INTx lines
> are simply not connected ?
>
> (Makes me wonder why Asus did not simply use the existing PCI bridge
> on the FCH, which BTW also seems to depend on the use of the external
> INTx lines.)

Device 14.4 would be the PCI bridge on AMD southbridges, but your model,
the A50M, does not have PCI support.

The interrupt lines are correctly connected to the ASM1083; otherwise,
they wouldn't work at all.

Also see "lspci -t".

>>> I also think that the following posts may refer to the same problem:
>>
>> That's similar symptoms, but completely different hardware.
>
> At first sight, yes, but they still share some of the problem areas. I
> justed wanted to point out possibly similar cases.

Indeed, I didn't realize they all have an ASM1083 bridge.

So it appears that this chip is just buggy.


Regards,
Clemens
