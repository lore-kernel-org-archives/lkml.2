Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758643Ab1E0Gsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 02:48:31 -0400
Received: from mx0.init-ka.de ([62.153.77.47]:28695 "EHLO gateway13.init-ka.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751306Ab1E0Gs3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 02:48:29 -0400
From: "Hornung, Michael" <mhornung@init-ka.de>
To: "'Bjorn Helgaas'" <bhelgaas@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Date: Fri, 27 May 2011 08:48:24 +0200
Subject: AW: Kernel > 2.6.30: PCI issue causes Kernel freeze at booting
Thread-Topic: Kernel > 2.6.30: PCI issue causes Kernel freeze at booting
Thread-Index: Acwa9D4fsf+vFlZLRL669fyo2vl66AAyAH0A
Message-ID: <334319B2EBE0B144BAE1402B79D82DC5CE13B082@srvpegasus>
References: <334319B2EBE0B144BAE1402B79D82DC5CE13B056@srvpegasus>
 <BANLkTimNSe5JjM2+_-XzS7D8XPeZrPL0oA@mail.gmail.com>
 <334319B2EBE0B144BAE1402B79D82DC5CE13B05A@srvpegasus>
 <BANLkTimX1KG-BZ98LH_NweOUOaUbQtZirg@mail.gmail.com>
 <BANLkTimrpnCdzRArjAn2NOZMu0Bhf6Pn8Q@mail.gmail.com>
 <334319B2EBE0B144BAE1402B79D82DC5CE13B07E@srvpegasus>
 <BANLkTikgg_4Xj2Z3q6pR+QJSxg6c6cQ32w@mail.gmail.com>
In-Reply-To: <BANLkTikgg_4Xj2Z3q6pR+QJSxg6c6cQ32w@mail.gmail.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 27 May 2011 06:48:26.0142 (UTC) FILETIME=[1450C3E0:01CC1C3A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

>>> Hi Michael,
>>>
>>> Any update on this problem?  Did it make any difference to put the
>>> UART in the ACPI namespace?
>>
>> thank you very much for your support. Unfortunately I'm not able to get it to work. I changed
>> the BIOS and added PNP0500 device nodes for all 21 UARTS (all located in the FPGA, all connected
>> via LPC, all located at addresses between 0x1900 and 0x19a7h and all using IRQ3), but the kernel does not care about
>> that nodes. CONFIG_SERIAL_8250_PNP is set to "y" (see attached config.txt) but the kernel output does not show
>> up any differences (2.6.38.6.log).
>
> Hmm, let's see...  It's been a while since I really worked in this area.
>
> I think there are two problems here: 
>
> 1) Something must be wrong with your PNP0500 devices because we only
> found seven PNP/ACPI devices, the same as we found in the original
> boot.Your most recent boot didn't have "debug" on the command line;
> that should show us the PNP devices we did find.  Can you post the
> DSDT?  Maybe it will have a clue about why we didn't find 28 (the
> original 7 + the new 21 UARTs) devices.

The BIOS sources were a little bit confusing at that point, but finally
I am able to add PNP device nodes.

> 2) Even if the PNP0500 devices were all there, Linux has a
> long-standing problem that we don't actually *do* anything with PNP
> resources until a driver claims the device.  This PCI assignment is
> happening before the serial driver would claim the devices, so I'm
> afraid it won't help with the problem you're seeing.  Ugh.  I've been
> wanting to fix this for years, but haven't had a chance to dig into
> it.

> It does seem unnecessary to assign I/O resources to the 00:1c.1 bridge
> at all, since there's no device below the bridge that needs I/O
> resources.  But changing that is a bigger project, too.

> There *is* an exception to the "Linux ignores PNP resources" rule,
> though -- maybe we could take advantage of that.  We do reserve
> "motherboard" resources (PNP0C01 and PNP0C02 devices), and there's
> even a comment in drivers/pnp/system.c about doing it early, before
> PCI assigns resources.  So if you change your new PNP0500 devices to
> PNP0C02 (and fix whatever is preventing PNPACPI from finding them),
> that might fix the PCI bridge assignment.  Then you'd have to keep the
> serial.h hack, since the serial driver wouldn't be able to claim the
> UARTs.

Thank you so much, that actually did the trick. I got it done to add a 
PNP0C02 device with a memory region from 0x1900 to 0x1947 and that is 
sufficient to get the kernel booting. 

> Ugh.  I'm really sorry you're tripping over this ugliness in Linux.

Don't mind, 21 UARTs, all starting at address 0x1900 is a little bit "special".

> The way this is *supposed* to work is that first, ACPI tells us where
> all the fixed hardware is.  The UARTs and PCI host bridges are
> examples of this fixed hardware.  Then we're supposed to enumerate
> things below the host bridges and assign unused space when necessary.
> But Linux has always discovered PCI stuff first, mostly ignoring ACPI,
> so keep tripping over problems like this.

> Bjorn


Again Bjorn, thank you very very much!

With best regards

Michael Hornung


------------------------------------------------------------
Michael Hornung
Hardware
Mobile Telematic and Fare Collection Systems

Phone +49-(0)721-6100-305
Fax +49-(0)721-6100-399
E-Mail mhornung@init-ka.de

INIT Innovative Informatikanwendungen
in Transport-, Verkehrs- und Leitsystemen GmbH 
Käppelestrasse 4-6
76131 Karlsruhe
Germany
http://www.init-ka.de  
 
Geschäftsführer:
Dr.-Ing. Gottfried Greschner, Dipl.-Inform. Achim Becker, Dipl.-Ing. (FH) Wolfgang Degen, Dipl.-Kfm. Dr. Jürgen Greschner
 
Amtsgericht Mannheim HRB 103679 . Internationale Registrierungen: 988055689MVA (Norwegen), FC027220 (UK)  
 
Vertraulichkeitshinweis:
Der Inhalt dieser E-Mail ist vertraulich zu behandeln. Das Schreiben ist nur zur Kenntnis des oben genannten Empfängers bestimmt. Wenn Sie nicht der richtige Adressat sind, informieren Sie bitte sofort den Absender und vernichten diese Nachricht. Unerlaubte Kopien sowie unbefugte Weitergabe sind nicht gestattet.
Bitte beachten Sie, dass durch diese E-Mail keine rechtsverbindlichen Willenserklärungen abgegeben werden.
 
Privacy Notice:
Content of this e-mail must be treated as strictly confidential. This writing is intended only for the knowledge of the above-mentioned addressee. If you are not the correct recipient please inform the sender immediately and permanently erase this message. Illegal copies as well as unauthorized passing is not permitted and strictly forbidden.
Please note that by sending this mail INIT does not make any commitment and is under no obligation.
