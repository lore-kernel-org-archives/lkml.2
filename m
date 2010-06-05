Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab0FEBhb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 21:37:31 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41432 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab0FEBh1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 21:37:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HgsDlDOekIbxTORf69m8GFoNtx7AdnAgtgahrQnGTQigeq/p9gz/rI5lDgnm9bz73+
         U/mqaE7Q0KNpruoVYIQhAlcWoUbt+lo4J8xG7QlTBjfynis8PV01jSjV/Omeax+Q/Ut+
         qECd+sLbhxwjouQzs26GAQvj5gyRLjpv5UHbo=
MIME-Version: 1.0
In-Reply-To: <AANLkTimFY5YQv8DC-zTQ1RF84rno6svvcyLzHGWL6HOk@mail.gmail.com>
References: <AANLkTiktNufXK_pn6mP2-zyowAIbHlUy5TGu3AtpALv-@mail.gmail.com>
	<20100603020006.GB19123@srcf.ucam.org>
	<AANLkTikpv86r5BBPCEOHujpm8uCgY0DxghSKjBufBWiM@mail.gmail.com>
	<4C08760B.8050002@gmail.com>
	<AANLkTimFY5YQv8DC-zTQ1RF84rno6svvcyLzHGWL6HOk@mail.gmail.com>
Date: Fri, 4 Jun 2010 19:37:27 -0600
Message-ID: <AANLkTimXcF1pafrSt8dMbUs59AjnqaRwpzDnPIPjdjsn@mail.gmail.com>
Subject: Re: Hang during boot, bisected to commit 96d60303fd
From: Robert Hancock <hancockrwd@gmail.com>
To: Marc Dionne <marc.c.dionne@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, garzik@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Fri, Jun 4, 2010 at 7:23 PM, Marc Dionne <marc.c.dionne@gmail.com> wrote:
> On Thu, Jun 3, 2010 at 11:42 PM, Robert Hancock <hancockrwd@gmail.com> wrote:
>> On 06/03/2010 07:21 PM, Marc Dionne wrote:
>>>
>>> On Wed, Jun 2, 2010 at 10:00 PM, Matthew Garrett<mjg59@srcf.ucam.org>
>>>  wrote:
>>>>
>>>> On Wed, Jun 02, 2010 at 09:49:27PM -0400, Marc Dionne wrote:
>>>>>
>>>>>    Since somewhere early in the 2.6.35 merge window I've been seeing a
>>>>> hang
>>>>>    during boot.  The hang last roughly 30 seconds and is followed by
>>>>> this:
>>>>>
>>>>>    ata4.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
>>>>>    ata4.00: failed command: READ FPDMA QUEUED
>>>>>    ata4.00: cmd 60/08:00:00:00:00/00:00:00:00:00/40 tag 0 ncq 4096 in
>>>>>             res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>>>>>    ata4.00: status: { DRDY }
>>>>>    ata4: hard resetting link
>>>>>    ahci_is_device_present: status is: 80
>>>>>    ahci_is_device_present: status(2) is: 3
>>>>>    ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>>>>>    ata4.00: configured for UDMA/133
>>>>>    ata4.00: device reported invalid CHS sector 0
>>>>>    ata4: EH complete
>>>>>
>>>>>    The system works normally once booted.  I had some time to do a
>>>>> bisect
>>>>>    today and it cleanly ended up pointing to this commit:
>>>>>        96d60303fd: ahci: Turn off DMA engines when there's no device
>>>>> attached
>>>>>
>>>>>    Reverting the commit makes the system boot cleanly as before.  System
>>>>> has
>>>>>    an Intel ICH10 based board, in AHCI mode, disk is an Intel X25M SSD.
>>>>
>>>> Hm, interesting. Jeff, any immediate ideas? I don't see this behaviour
>>>> on my ICH10. Is there actually a device on ata4?
>>>>
>>>> --
>>>> Matthew Garrett | mjg59@srcf.ucam.org
>>>
>>> If it's helpful, attached are the dmesg output following a normal boot
>>> and one with the hang.
>>>
>>> The only difference in the kernel used for those two boots is that the
>>> return statement in ahci_start_engine following the call to
>>> ahci_is_device_present is commented out for the normal boot case.
>>> When the return statement is active, the 30 second hang occurs.
>>
>> Can you try and put a printk in where it's returning out of the
>> ahci_start_engine method? I wonder if that's getting triggered somewhere
>> unexpected..
>
> Attached is a dmesg output with some printks added to show the status
> when ahci_is_device_present causes ahci_start_engine to return early..
>
> It looks to me like there's two passes through ahci_start_engine for
> all ports, and during the first pass the port with the disk is showing
> a status of 127, causing the function to return early and skipping the
> start DMA part.  This seems to cause the hang later on.
>
> I noticed that during this first pass all the print_id fields for the
> ports are still set to -1, so as a test I made ahci_start_engine only
> do the check for ahci_is_device_present if print_id != -1, and this
> makes the system boot normally.

Is that the right dmesg? I didn't see where the extra output was. It
might be useful to put a WARN_ON(1); inside ahci_start_engine to see
the two code paths where it's being called..
