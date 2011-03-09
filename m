Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab1CIXpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 18:45:06 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62949 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab1CIXpD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 18:45:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dHvkQ/qEE2dc2Z+53wN0wB3w/wKKi/6O5YizSxvXkdnWRgsiZxcvnr6XWX9DG/FDc6
         +IztTzYgi3p8tivciCHwxA7+FOCJUp2Bq8nfmUlNxOOL3S/Wj2QFHNesO7vDej31oqNj
         DN2t1G9ZEGIcV9glGWzISwkG67pRQIWobxjMY=
MIME-Version: 1.0
In-Reply-To: <C825D274.919E%Kyle.D.Moffett@boeing.com>
References: <4B4531F9.3060108@gmail.com>
	<C825D274.919E%Kyle.D.Moffett@boeing.com>
Date: Thu, 10 Mar 2011 00:44:29 +0100
Message-ID: <AANLkTikr86_tXWzBATbtpOi5eDV4iVggeQBm-0vkP4+t@mail.gmail.com>
Subject: Re: New MSI support in sata_sil24 still broken in 2.6.33-rc3
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
Cc: Robert Hancock <hancockrwd@gmail.com>,
        Torsten Kaiser <just.for.lkml@googlemail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vivek Mahajan <vivek.mahajan@freescale.com>,
        Jeff Garzik <jgarzik@pobox.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Kyle Moffett <kyle@moffetthome.net>,
        "Livingston, John A" <john.a.livingston@boeing.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kyle,

I'm also using SIL3234 (sil24 driver) on P2020 and encountering
problems. Instead of starting my own investigation first I used google
powers to find this old email thread.

Have you found a more recent working solution to your problem?

Regards,

Leon.


On Sat, May 29, 2010 at 2:05 AM, Moffett, Kyle D
<Kyle.D.Moffett@boeing.com> wrote:
> My advance apologies if this email gets badly MIME-mangled...
>
> On 2010/01/06 20:59, "Robert Hancock" <hancockrwd@gmail.com> wrote:
>> On 01/06/2010 03:37 AM, Torsten Kaiser wrote:
>>> After activating the MSI support by adding sata_sil24.msi=1 to the
>>> kernel command line, the first write to a drive attached to the SiI
>>> 3132 controller results in the following errors:
>>>
>>> [  138.950074] ata2.00: exception Emask 0x0 SAct 0xf SErr 0x0 action 0x6
>>> frozen
>>> [  138.961023] ata2.00: failed command: WRITE FPDMA QUEUED
>>> [  138.970034] ata2.00: cmd 61/00:00:a5:95:4a/04:00:01:00:00/40 tag 0
>>> ncq 524288 out
>>> [  138.970037]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
>>> 0x4 (timeout)
>>
>> Looking at the code in sata_sil24 and the SiI3132 datasheet, there's a
>> control bit which doesn't seem to be handled in the driver, global
>> control register bit 30: "MSI Acknowledge (W). Writing a one to this bit
>> acknowledges a Message Signaled Interrupt and permits generation of
>> another MSI. This bit is cleared immediately after the acknowledgement
>> is recognized by the control logic, hence the bit will always be read as
>> a zero. If all interrupt conditions are removed subsequent to an MSI, it
>> is not necessary to assert this Acknowledge; another MSI will be
>> generated when an interrupt condition occurs."
>>
>> The way the interrupt handler for this driver works is that we check the
>> global IRQ status register, and then based on what ports indicated an
>> interrupt in that register, we check the individual port command
>> completion registers. The issue would seem to be that if a port got an
>> interrupt condition in between these two operations, we'd miss it, and
>> the MSI logic described above then wouldn't generate any more interrupts
>> since we didn't remove all interrupt conditions.
>>
>> Can you try this patch and see if it helps? (Might be whitespace damaged
>> but hopefully you can apply manually in that case.)
>
> I've got this custom board that uses the sata_sil24 driver (off a P2020
> processor).  My current kernel is a slightly patched 2.6.32 kernel
> (including the sata_sil24 enable-MSI patch).
>
> Unfortunately when I turn MSI on, I get the exact same hang described here,
> boot log included as dmesg1.txt.
>
> With this patch applied, it seems to get a little further (dmesg2.txt), but
> still dies miserably.
>
> I'm relatively sure that MSI works on this chipset as I also have an e1000e
> controller off an adjacent PCI-E bus which works correctly with MSI.
>
> It's relatively critical for me to get MSI working, because the legacy-PCI
> INTx interrupt for that PCI-E port happens to share an IRQ line with a
> device that is very unfriendly to shared IRQs (it has no internal IRQ
> disable register).  I'd rather not have to go in there with a soldering iron
> and some scraps of wire to make it work. :-D
>
> Cheers,
> Kyle Moffett
>
>



-- 
Leon
