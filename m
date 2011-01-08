Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab1AHARM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 19:17:12 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:4006 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab1AHARK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 19:17:10 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] PCI: tune up ICH4 quirk for broken BIOSes
Date: Fri, 7 Jan 2011 17:16:36 -0700
User-Agent: KMail/1.13.2 (Linux/2.6.32-26-generic; KDE/4.4.2; x86_64; ; )
Cc: Jiri Slaby <jslaby@suse.cz>, jbarnes@virtuousgeek.org,
        linux-pci@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Thomas Renninger <trenn@suse.de>
References: <1294327066-23518-1-git-send-email-jslaby@suse.cz> <201101071603.29999.bjorn.helgaas@hp.com> <4D27A1BC.4080802@gmail.com>
In-Reply-To: <4D27A1BC.4080802@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201101071716.38220.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 07, 2011 04:29:00 pm Jiri Slaby wrote:
> On 01/08/2011 12:03 AM, Bjorn Helgaas wrote:
> > On Friday, January 07, 2011 01:44:35 pm Jiri Slaby wrote:
> >> On 01/06/2011 08:24 PM, Bjorn Helgaas wrote:
> >>> Theoretically, ACPI tells us about the GPIO/TCO/etc. regions in a
> >>> generic way via namespace devices or something in the static tables.
> >>> Is that generic information missing, or is it there and Linux is
> >>> ignoring it?  If we're ignoring it, I'd rather fix that.
> >>
> >> It works for most boxes I would say. Try to google for "claimed by ICH4
> >> ACPI/GPIO/TCO", it reports sane ranges like 0400-047f or 4000-407f.
> > 
> > My point is that BIOS should be telling the OS about GPIO/TCO/etc.
> > regions via an ACPI mechanism, and, ideally, we would use that rather
> > than reading the address out of chipset-dependent registers.
> > 
> > Even though PMBASE says the ACPI registers occupy 128 bytes from
> > 0x100-0x17f, it's likely there's no actual conflict between the
> > last 16 bytes and the IDE device.
> 
> I wouldn't say so. According to the datasheet 0x60-0x7f of the space
> (i.e. 0x160-0x17f here) is for TCO registers. There:
> 0x10 -- Software IRQ Generation Register (i.e. 0x170)
> 0x11-0x1f -- reserved (0x171-0x17f)
> 
> So at least 0x170 should be conflicting. Unless TCO is unused/disabled
> and not mapped there at all. May be that the case?

Maybe.  All your patch does is avoid reserving this 0x100-0x1f7
region; it doesn't actually *move* anything.  And the IDE device
apparently works at the 0x170 compatibility address.  So the
ICH ACPI stuff is still at 0x100-0x17f, so apparently they don't
conflict or maybe the ICH ACPI stuff is disabled.  If the box
doesn't even have ACPI, I suppose there would be no reason to
have the ACPI registers enabled.  Is there something in ICH
that tells us whether they're enabled?

> > ACPI probably reports this region via the FADT (the GPE PM register
> > blocks) and possibly a PNP0C02 device.  These will probably report
> > something that doesn't conflict with the legacy IDE ports, i.e., a
> > subset of the 0x100-0x17f range.
> > 
> > Ooooh, I notice in the bugzilla that something's wrong with SMBIOS
> > (comment 29) and ACPI is disabled because we couldn't find the
> > RSDP (dmesg in comment 27).  What sort of machine is this, anyway?
> > We didn't find PNPBIOS, either.
> 
> Hmm, it looks like some old crap. What exact information you would like
> to know? I've just asked if ACPI is not disabled in BIOS. There should
> be no machine without ACPI running still in the 21st century, I think.

I'm just wondering if the machine actually does have ACPI, but
there's some Linux problem related to finding the tables.  If it's
really old enough, that wouldn't be so surprising, but I see USB
and gigabit NIC hardware, so it's not truly ancient.

Bjorn
