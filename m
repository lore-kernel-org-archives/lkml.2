Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762Ab1LHMnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 07:43:37 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:43477 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751182Ab1LHMng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 07:43:36 -0500
X-Sasl-enc: N+Z6tj7zQshzbMjy17ivLFiGfDqTm9vpivn0vQvFjg74 1323348214
Message-ID: <4EE0B156.4080708@ladisch.de>
Date: Thu, 08 Dec 2011 13:45:10 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Jeroen Van den Keybus <jeroen.vandenkeybus@gmail.com>
CC: "Huang, Shane" <Shane.Huang@amd.com>, Borislav Petkov <bp@amd64.org>,
        "Nguyen, Dong" <Dong.Nguyen@amd.com>, linux-kernel@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net
Subject: Re: Unhandled IRQs on AMD E-450
References: <CAPRPZsCrGXKwYiOTzDde=5=8wMnMX0sxFvnustSSz4Z6BYJNzA@mail.gmail.com> <20111130154445.GA27198@gere.osrc.amd.com> <1E8B869C0C6913418421A406C094DF7C0205358F@sshaexmb1.amd.com> <CAPRPZsAL=xUCjTKaSgq117zppvZS0S7fHB0Ebk-JqXvV1vTPCQ@mail.gmail.com> <4EDB6C10.10102@ladisch.de> <CAPRPZsAc8wr_2KsRi3LnGi4ic-CzrFLbRvQfkrXckH--vaLkVQ@mail.gmail.com> <CAPRPZsBdnrProsTaSYnMKi6Q3dSsP9nYkw0CKnmb-BrmJxBivw@mail.gmail.com> <CAPRPZsBO_hvAv8o0vKh7XuE+RiEunETaxaPsmdm5yPe5YvOdPA@mail.gmail.com> <CAPRPZsDU2+ApCjQvEzRfOXfMLgfDS1j5zXF7hw4wy5yrzT-_7Q@mail.gmail.com> <4EDBA70E.3090905@ladisch.de> <CAPRPZsAqjWtbUH8FSh3O3C6iQ7+L11782fc1e=-UDSQkgm7FPg@mail.gmail.com> <CAPRPZsBzBNzrzbNDN2fBnWwQ-MYcRssfY5V+5mDXLbJ+-gd9SA@mail.gmail.com>
In-Reply-To: <CAPRPZsBzBNzrzbNDN2fBnWwQ-MYcRssfY5V+5mDXLbJ+-gd9SA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeroen Van den Keybus wrote:
> I have the impression that I see the same failure mechanism for both
> IRQs. All goes well for a while, until an IRQ storm starts right
> (e1000: 19 us, firewire-ohci: 39 us) after a valid IRQ.
>
> Therefore there is a strong correlation between the arrival of the
> spurious interrupt, alledgedly caused by a mystery device, and the
> earlier arrival of a valid interrupt for a device. Combined with the
> fact that it happens on 2 different IRQs pretty much rules out the
> possibilty for me that there is either a mystery device at all, or
> that the existing devices would both be defective, does it not ?

There appears to be a problem with the interrupt handling.

In PCI, interrupts are level-triggered, which means that the interrupt
line (INTx) is active when it's at level 0 and inactive when it's at
level 1.  When a device wants to trigger an interrupt, it outputs zero
on its interrupt output.  The level doesn't get reset to 1 until the
driver acknowledges the interrupt (in e1000, read of the ICR; in
firewire-ohci, write of IntEventClear).  As long as the line stays at 0,
all interrupt handlers will continue being called.  This mechanism
allows multiple devices to share one interrupt line.

In PCI Express, there are only one-to-one connections, and there are no
separate interrupt lines.  A device raises an interrupt by sending
an interrupt message, which could be understood as a memory write to
a special address at the interrupt controller.  Nothing needs to be done
to deactive the interrupt; if the device has another reason for
an interrupt, it just sends another interrupt message.

When a PCI device is connected to a PCI Express system, the old INTx
interrupt line must be converted to PCI Express messages.  This is done
with _two_ special messages, Assert_INTx and Deassert_INTx.  The first
tells the interrupt controller that some INTx line went from 1 to 0, the
second tells it that it went from 0 back to 1; this allows the interrupt
controller to implement the level-triggered behaviour.

It appears that some Deassert_INTx messages get lost on your system.
There are no indications of any other missing PCIe packets, so this
looks like a problem with the interrupt handling in your PCI/PCIe
bridge, the ASM1083 chip.

> I also do not understand, if there would be a stuck IRQ line, why I
> can unload and reload e1000 and firewire-ohci without immediately
> getting the same IRQ storm.

Linux will reenable the interrupt line when a new driver attaches to it.
At this point, it's still stuck, but the device initialization will
trigger some actual interrupts, and after the first assert/deassert
pair, the line will be unstuck.


Regards,
Clemens
