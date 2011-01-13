Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103Ab1AMXTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 18:19:48 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:42854 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab1AMXTl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 18:19:41 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] PCI: tune up ICH4 quirk for broken BIOSes
Date: Thu, 13 Jan 2011 16:19:00 -0700
User-Agent: KMail/1.13.2 (Linux/2.6.32-26-generic; KDE/4.4.2; x86_64; ; )
Cc: Jiri Slaby <jslaby@suse.cz>, jbarnes@virtuousgeek.org,
        linux-pci@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Thomas Renninger <trenn@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <1294327066-23518-1-git-send-email-jslaby@suse.cz> <201101101140.45501.bjorn.helgaas@hp.com> <4D2ECEDC.4040804@gmail.com>
In-Reply-To: <4D2ECEDC.4040804@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201101131619.01893.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 13, 2011 03:07:24 am Jiri Slaby wrote:
> On 01/10/2011 07:40 PM, Bjorn Helgaas wrote:
> > On Saturday, January 08, 2011 02:58:01 am Jiri Slaby wrote:
> >> On 01/08/2011 01:16 AM, Bjorn Helgaas wrote:
> >>> On Friday, January 07, 2011 04:29:00 pm Jiri Slaby wrote:
> >>>> On 01/08/2011 12:03 AM, Bjorn Helgaas wrote:
> >>>>> On Friday, January 07, 2011 01:44:35 pm Jiri Slaby wrote:
> >>>>>> On 01/06/2011 08:24 PM, Bjorn Helgaas wrote:
> >>>>>>> Theoretically, ACPI tells us about the GPIO/TCO/etc. regions in a
> >>>>>>> generic way via namespace devices or something in the static tables.
> >>>>>>> Is that generic information missing, or is it there and Linux is
> >>>>>>> ignoring it?  If we're ignoring it, I'd rather fix that.
> >>>>>>
> >>>>>> It works for most boxes I would say. Try to google for "claimed by ICH4
> >>>>>> ACPI/GPIO/TCO", it reports sane ranges like 0400-047f or 4000-407f.
> >>>>>
> >>>>> My point is that BIOS should be telling the OS about GPIO/TCO/etc.
> >>>>> regions via an ACPI mechanism, and, ideally, we would use that rather
> >>>>> than reading the address out of chipset-dependent registers.
> >>>>>
> >>>>> Even though PMBASE says the ACPI registers occupy 128 bytes from
> >>>>> 0x100-0x17f, it's likely there's no actual conflict between the
> >>>>> last 16 bytes and the IDE device.
> >>>>
> >>>> I wouldn't say so. According to the datasheet 0x60-0x7f of the space
> >>>> (i.e. 0x160-0x17f here) is for TCO registers. There:
> >>>> 0x10 -- Software IRQ Generation Register (i.e. 0x170)
> >>>> 0x11-0x1f -- reserved (0x171-0x17f)
> >>>>
> >>>> So at least 0x170 should be conflicting. Unless TCO is unused/disabled
> >>>> and not mapped there at all. May be that the case?
> >>>
> >>> Maybe.  All your patch does is avoid reserving this 0x100-0x1f7
> >>> region; it doesn't actually *move* anything.  And the IDE device
> >>> apparently works at the 0x170 compatibility address.  So the
> >>> ICH ACPI stuff is still at 0x100-0x17f, so apparently they don't
> >>> conflict or maybe the ICH ACPI stuff is disabled.  If the box
> >>> doesn't even have ACPI, I suppose there would be no reason to
> >>> have the ACPI registers enabled.  Is there something in ICH
> >>> that tells us whether they're enabled?
> >>
> >> Hmm, there is:
> >> bit 4: ACPI Enable (ACPI_EN) — R/W.
> >>   0 = Disable.
> >>   1 = Decode of the I/O range pointed to by the ACPI Base register is
> >> enabled, and the ACPI power management function is enabled. Note that
> >> the APM power management ranges (B2/B3h) are always enabled and are not
> >> affected by this bit.
> >>
> >> at 0x44 in the bridge conf space. So we should definitely check the value.
> >>
> >> I don't have the actual value in that register when ACPI is disabled in
> >> BIOS. From the run where acpi=off was passed to the kernel, there is
> >> 0x10 (i.e. ACPI_EN=1). However I don't know whether ACPI was disabled in
> >> BIOS at that time.
> > 
> > Checking ACPI_EN before doing anything in the quirk looks like
> > the simplest thing (if the BIOS actually sets ACPI_EN=0 when
> > it disables ACPI).
> 
> Unfortunately, they double checked and the BIOS leaves ACPI_EN=1 even
> when ACPI is disabled.
> From hexdump -Cv /sys/bus/pci/devices/0000\:00\:1f.0/config:
> 00000040  01 01 00 00 10 00 00 00  00 00 00 00 00 00 01 00
>           ^base addr^|^-- 4th bit ~ ACPI_EN
> 
> But I think we still should add the check in any case, the same for GPIO
> (there is GPIO_EN) and maybe for newer ICHs. What do you think?
> 
> The problem is we can't add a quirk based on DMI for this one, since
> there is no DMI table.
> 
> I'm out of ideas now.

I think we're back to the question of why we have the ICH4 quirk in
the first place, and I don't know the answer to that.

If we didn't have the quirk at all, this machine would work.  Other
machines *should* work without, but maybe there's a BIOS or old Linux
bug that the quirk covers up.  I added Linus because he added some
similar "should be unnecessary" code for ICH7+ (894886e5d).

Maybe you could make the ICH4 quirk only claim the region if it's
above PCIBIOS_MIN_IO, i.e., if it's in the area where we could put
another PCI device on top of it?

Bjorn
