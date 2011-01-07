Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab1AGXEG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 18:04:06 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:5306 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136Ab1AGXED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 18:04:03 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] PCI: tune up ICH4 quirk for broken BIOSes
Date: Fri, 7 Jan 2011 16:03:29 -0700
User-Agent: KMail/1.13.2 (Linux/2.6.32-26-generic; KDE/4.4.2; x86_64; ; )
Cc: Jiri Slaby <jslaby@suse.cz>, jbarnes@virtuousgeek.org,
        linux-pci@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Thomas Renninger <trenn@suse.de>
References: <1294327066-23518-1-git-send-email-jslaby@suse.cz> <201101061224.40596.bjorn.helgaas@hp.com> <4D277B33.1000508@gmail.com>
In-Reply-To: <4D277B33.1000508@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201101071603.29999.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 07, 2011 01:44:35 pm Jiri Slaby wrote:
> On 01/06/2011 08:24 PM, Bjorn Helgaas wrote:
> > On Thursday, January 06, 2011 08:17:46 am Jiri Slaby wrote:

> Only a novell (opensuse) bugzilla:
> https://bugzilla.novell.com/show_bug.cgi?id=558740
> 
> > Is it a regression?  Sounds like an
> > old machine where we should have seen this before.)
> 
> Yes, a regression. 2.6.31 and newer doesn't work. 2.6.27 did. I don't
> know what kernel exactly in between is first defunct.
> 
> > My guess is that we found this "conflict" and tried to move the
> > controller, but it's hardwired to stay at 0x170 when in compatibility
> > mode.  So the hardware is really still at 0x170, but Linux thinks it
> > moved it elsewhere, so it doesn't work.
> 
> Sorry I didn't get this paragraph.

IDE devices are special and are allowed to respond to the legacy
addresses, e.g., 0x170, even if those addresses don't appear in
the BARs.  That's why we have the special case in pci_setup_device().

But the code that detects the address space conflict and tries to
resolve it doesn't know about this hard-wired IDE address decoder.
Linux tries to move it by writing to a BAR, and that probably has
no effect on a compatibility-mode IDE device.

> > Theoretically, ACPI tells us about the GPIO/TCO/etc. regions in a
> > generic way via namespace devices or something in the static tables.
> > Is that generic information missing, or is it there and Linux is
> > ignoring it?  If we're ignoring it, I'd rather fix that.
> 
> It works for most boxes I would say. Try to google for "claimed by ICH4
> ACPI/GPIO/TCO", it reports sane ranges like 0400-047f or 4000-407f.

My point is that BIOS should be telling the OS about GPIO/TCO/etc.
regions via an ACPI mechanism, and, ideally, we would use that rather
than reading the address out of chipset-dependent registers.

Even though PMBASE says the ACPI registers occupy 128 bytes from
0x100-0x17f, it's likely there's no actual conflict between the
last 16 bytes and the IDE device.

ACPI probably reports this region via the FADT (the GPE PM register
blocks) and possibly a PNP0C02 device.  These will probably report
something that doesn't conflict with the legacy IDE ports, i.e., a
subset of the 0x100-0x17f range.

Ooooh, I notice in the bugzilla that something's wrong with SMBIOS
(comment 29) and ACPI is disabled because we couldn't find the
RSDP (dmesg in comment 27).  What sort of machine is this, anyway?
We didn't find PNPBIOS, either.

Bjorn
