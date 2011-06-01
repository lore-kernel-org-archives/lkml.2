Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604Ab1FAQgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 12:36:55 -0400
Received: from smtp-out.google.com ([216.239.44.51]:5612 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab1FAQgw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 12:36:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=St9c5owcYf7/Obiq0dnuVsRAg+QXNfCE+6wwcdf77Fs2u8nLspVSEC5TgTOW/ffWjZ
         6/KIyAxjuPG9AZfvPkrQ==
MIME-Version: 1.0
In-Reply-To: <334319B2EBE0B144BAE1402B79D82DC5CE13B082@srvpegasus>
References: <334319B2EBE0B144BAE1402B79D82DC5CE13B056@srvpegasus>
 <BANLkTimNSe5JjM2+_-XzS7D8XPeZrPL0oA@mail.gmail.com> <334319B2EBE0B144BAE1402B79D82DC5CE13B05A@srvpegasus>
 <BANLkTimX1KG-BZ98LH_NweOUOaUbQtZirg@mail.gmail.com> <BANLkTimrpnCdzRArjAn2NOZMu0Bhf6Pn8Q@mail.gmail.com>
 <334319B2EBE0B144BAE1402B79D82DC5CE13B07E@srvpegasus> <BANLkTikgg_4Xj2Z3q6pR+QJSxg6c6cQ32w@mail.gmail.com>
 <334319B2EBE0B144BAE1402B79D82DC5CE13B082@srvpegasus>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 1 Jun 2011 10:36:29 -0600
Message-ID: <BANLkTikyq-vn1vLZi_ReccwLqm7joRHbwg@mail.gmail.com>
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

On Fri, May 27, 2011 at 12:48 AM, Hornung, Michael <mhornung@init-ka.de> wrote:
> Hi Bjorn,
>
>>>> Hi Michael,
>>>>
>>>> Any update on this problem?  Did it make any difference to put the
>>>> UART in the ACPI namespace?
>>>
>>> thank you very much for your support. Unfortunately I'm not able to get it to work. I changed
>>> the BIOS and added PNP0500 device nodes for all 21 UARTS (all located in the FPGA, all connected
>>> via LPC, all located at addresses between 0x1900 and 0x19a7h and all using IRQ3), but the kernel does not care about
>>> that nodes. CONFIG_SERIAL_8250_PNP is set to "y" (see attached config.txt) but the kernel output does not show
>>> up any differences (2.6.38.6.log).
>>
>> Hmm, let's see...  It's been a while since I really worked in this area.
>>
>> I think there are two problems here:
>>
>> 1) Something must be wrong with your PNP0500 devices because we only
>> found seven PNP/ACPI devices, the same as we found in the original
>> boot.Your most recent boot didn't have "debug" on the command line;
>> that should show us the PNP devices we did find.  Can you post the
>> DSDT?  Maybe it will have a clue about why we didn't find 28 (the
>> original 7 + the new 21 UARTs) devices.
>
> The BIOS sources were a little bit confusing at that point, but finally
> I am able to add PNP device nodes.
>
>> 2) Even if the PNP0500 devices were all there, Linux has a
>> long-standing problem that we don't actually *do* anything with PNP
>> resources until a driver claims the device.  This PCI assignment is
>> happening before the serial driver would claim the devices, so I'm
>> afraid it won't help with the problem you're seeing.  Ugh.  I've been
>> wanting to fix this for years, but haven't had a chance to dig into
>> it.
>
>> It does seem unnecessary to assign I/O resources to the 00:1c.1 bridge
>> at all, since there's no device below the bridge that needs I/O
>> resources.  But changing that is a bigger project, too.
>
>> There *is* an exception to the "Linux ignores PNP resources" rule,
>> though -- maybe we could take advantage of that.  We do reserve
>> "motherboard" resources (PNP0C01 and PNP0C02 devices), and there's
>> even a comment in drivers/pnp/system.c about doing it early, before
>> PCI assigns resources.  So if you change your new PNP0500 devices to
>> PNP0C02 (and fix whatever is preventing PNPACPI from finding them),
>> that might fix the PCI bridge assignment.  Then you'd have to keep the
>> serial.h hack, since the serial driver wouldn't be able to claim the
>> UARTs.
>
> Thank you so much, that actually did the trick. I got it done to add a
> PNP0C02 device with a memory region from 0x1900 to 0x1947 and that is
> sufficient to get the kernel booting.
>
>> Ugh.  I'm really sorry you're tripping over this ugliness in Linux.
>
> Don't mind, 21 UARTs, all starting at address 0x1900 is a little bit "special".
>
>> The way this is *supposed* to work is that first, ACPI tells us where
>> all the fixed hardware is.  The UARTs and PCI host bridges are
>> examples of this fixed hardware.  Then we're supposed to enumerate
>> things below the host bridges and assign unused space when necessary.
>> But Linux has always discovered PCI stuff first, mostly ignoring ACPI,
>> so keep tripping over problems like this.

I opened this bug report to make sure we don't lose this.  I don't
know when or if this will be addressed, but your system is valuable as
a real live test case that shows what we're doing wrong.

https://bugzilla.kernel.org/show_bug.cgi?id=36462

Bjorn
