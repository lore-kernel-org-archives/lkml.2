Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039Ab1EYP4H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 11:56:07 -0400
Received: from smtp-out.google.com ([74.125.121.67]:53465 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757475Ab1EYP4E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 11:56:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=R/FNN96BZ9H5KUdksOWUSS7jLqejDsm/YP/7grkoiYHAumj1d1USU7PLQT61WYih0Q
         mMEDt9Fr885v+Ykr6f5g==
MIME-Version: 1.0
In-Reply-To: <334319B2EBE0B144BAE1402B79D82DC5CE13B07E@srvpegasus>
References: <334319B2EBE0B144BAE1402B79D82DC5CE13B056@srvpegasus>
 <BANLkTimNSe5JjM2+_-XzS7D8XPeZrPL0oA@mail.gmail.com> <334319B2EBE0B144BAE1402B79D82DC5CE13B05A@srvpegasus>
 <BANLkTimX1KG-BZ98LH_NweOUOaUbQtZirg@mail.gmail.com> <BANLkTimrpnCdzRArjAn2NOZMu0Bhf6Pn8Q@mail.gmail.com>
 <334319B2EBE0B144BAE1402B79D82DC5CE13B07E@srvpegasus>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 25 May 2011 09:55:31 -0600
Message-ID: <BANLkTikgg_4Xj2Z3q6pR+QJSxg6c6cQ32w@mail.gmail.com>
Subject: Re: Kernel > 2.6.30: PCI issue causes Kernel freeze at booting
To: "Hornung, Michael" <mhornung@init-ka.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 6:28 AM, Hornung, Michael <mhornung@init-ka.de> wrote:
>>>>>> There is an UART (FPGA IP Core) in that system located at address 1900h using interrupt 3. In order to get Kernel messages at boot time,
>>>>>> I changed file arch/x86/include/asm/serial.h as follows:
>>>>>>
>>>>>> -        { 0, BASE_BAUD, 0x3F8, 4, STD_COM_FLAGS },      /* ttyS0 */     \
>>>>>> +        { 0, BASE_BAUD, 0x1900, 3, STD_COM_FLAGS },     /* ttyS0 */    \
>>>>>>
>>>>>> that is the only change I made to the kernel sources.
>>>>
>>>>> Is this UART connected via PCI?  I don't think so, because I don't see
>>>>> any I/O BARs that include 0x1900.
>>>>
>>>> The UART is connected via LPC bus.
>>>
>>> Makes sense; that's a common way for attaching UARTs, and they are
>>> normally described via ACPI.  When you do that, I think it will show
>>> up as ttyS4 (be sure you build with CONFIG_SERIAL_8250_PNP=y), so
>>> you'll have to use "console=ttyS4" when you boot.  ttyS0-ttyS3 are
>>> taken by the hard-coded ports in serial.h, even though they may not
>>> exist on your platform.
>>
>> Hi Michael,
>>
>> Any update on this problem?  Did it make any difference to put the
>> UART in the ACPI namespace?
>
> thank you very much for your support. Unfortunately I'm not able to get it to work. I changed
> the BIOS and added PNP0500 device nodes for all 21 UARTS (all located in the FPGA, all connected
> via LPC, all located at addresses between 0x1900 and 0x19a7h and all using IRQ3), but the kernel does not care about
> that nodes. CONFIG_SERIAL_8250_PNP is set to "y" (see attached config.txt) but the kernel output does not show
> up any differences (2.6.38.6.log).

Hmm, let's see...  It's been a while since I really worked in this area.

I think there are two problems here:

1) Something must be wrong with your PNP0500 devices because we only
found seven PNP/ACPI devices, the same as we found in the original
boot.  Your most recent boot didn't have "debug" on the command line;
that should show us the PNP devices we did find.  Can you post the
DSDT?  Maybe it will have a clue about why we didn't find 28 (the
original 7 + the new 21 UARTs) devices.

2) Even if the PNP0500 devices were all there, Linux has a
long-standing problem that we don't actually *do* anything with PNP
resources until a driver claims the device.  This PCI assignment is
happening before the serial driver would claim the devices, so I'm
afraid it won't help with the problem you're seeing.  Ugh.  I've been
wanting to fix this for years, but haven't had a chance to dig into
it.

It does seem unnecessary to assign I/O resources to the 00:1c.1 bridge
at all, since there's no device below the bridge that needs I/O
resources.  But changing that is a bigger project, too.

There *is* an exception to the "Linux ignores PNP resources" rule,
though -- maybe we could take advantage of that.  We do reserve
"motherboard" resources (PNP0C01 and PNP0C02 devices), and there's
even a comment in drivers/pnp/system.c about doing it early, before
PCI assigns resources.  So if you change your new PNP0500 devices to
PNP0C02 (and fix whatever is preventing PNPACPI from finding them),
that might fix the PCI bridge assignment.  Then you'd have to keep the
serial.h hack, since the serial driver wouldn't be able to claim the
UARTs.

Ugh.  I'm really sorry you're tripping over this ugliness in Linux.
The way this is *supposed* to work is that first, ACPI tells us where
all the fixed hardware is.  The UARTs and PCI host bridges are
examples of this fixed hardware.  Then we're supposed to enumerate
things below the host bridges and assign unused space when necessary.
But Linux has always discovered PCI stuff first, mostly ignoring ACPI,
so keep tripping over problems like this.

Bjorn
