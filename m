Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340Ab0FOPbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 11:31:06 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:37334 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261Ab0FOPa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 11:30:58 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH -v2] x86, pci: Handle fallout pci devices with peer root bus
Date: Tue, 15 Jun 2010 09:30:58 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: Yinghai Lu <yinghai.lu@oracle.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Graham Ramsey <ramsey.graham@ntlworld.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Robert Richter <robert.richter@amd.com>,
       Harald Welte <HaraldWelte@viatech.com>,
       Joseph Chan <JosephChan@via.com.tw>, Jiri Slaby <jslaby@suse.cz>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Myron Stowe <myron.stowe@hp.com>
References: <4BF40014.30303@ntlworld.com> <201006141949.51674.bjorn.helgaas@hp.com> <4C16DDC1.30006@zytor.com>
In-Reply-To: <4C16DDC1.30006@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006150930.58913.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 14, 2010 07:56:17 pm H. Peter Anvin wrote:
> On 06/14/2010 06:49 PM, Bjorn Helgaas wrote:
> 
> >> Invisible PCI bridges have been known to occur in pure PCI space, too.
> > 
> > Are you talking about PCI host bridges that don't appear in PCI config
> > space?  I suppose those could be described as "invisible," but since
> > host bridges aren't architected and their primary interface isn't PCI,
> > it seems only natural that we'd discover them by a non-PCI mechanism.
> > They're invisible in PCI terms, but obviously perfectly discoverable
> > and configurable via ACPI.
> 
> I mean invisible PCI-PCI bridges.  Yes, they exist.

Can you educate me more about these?  What specifically is invisible?
Do they appear in config space?  Are they in config space but merely
non-standard?

Let's say we have:

  1) Invisible P2P bridge from bus X to bus 80.

  2) PCI host bridge to bus 80.

Neither appears in PCI config space.  In both cases, we would
discover bus 80 by blindly probing buses 00-ff.  We could
distinguish them by putting a bus analyzer on bus X: if we
see bus 80 traffic on bus X, we must have case (1).  If the
invisible P2P bridge happened to be below a standard P2P bridge,
we could also distinguish them by disabling the standard bridge:
if bus 80 disappeared, we'd know this is also case (1).

But in general, they seem pretty hard to distinguish, so I wonder
if it's possible that we have a case of mistaken identity, and we
only thought we had invisible P2P bridges because we started from
the assumption that systems only had a single PCI host bridge.

> > If you ask me, it's weird that most x86 chipsets put PCI host bridge
> > configuration in PCI config space -- it may be convenient in some ways,
> > but still architecturally strange.
> 
> It is only strange because they are non-bridge devices.  PCI-Express
> fixes that to some degree with the whole "root complex" notion, but
> really a PCI host bridge should have been a bridge device from the start.

Well, even if host bridges had always looked like P2P bridges, we'd
still have the chicken-and-egg problem of knowing where to look for
them.  The OS could use the hack of "always assume bus 00 exists and
enumerate it," but then we still have to worry about multiple segments.
So we always need a non-PCI description of where the PCI buses live.

> > I suppose one could argue that there's a non-standard P2P bridge
> > from bus 00 to bus 80, but I can't imagine anybody doing that.
> 
> Ah, ye of little imagination.

Heh, nobody's ever accused me of having a vivid imagination :-)

> > An OS would have to have vendor-specific code just to do PCI
> > resource management, and that really misses the point of PCI.
> 
> This really misses the point of HT...

I don't follow you here.  I was trying to get at the fact that if
there are non-standard P2P bridges, an OS without a device-specific
driver would not even find devices behind the bridge (unless it
has a blind probe hack) and it would not know the bridge apertures,
so it could never change resource assignments of peers of the bridge
or devices behind the bridge.

Does HT change that reasoning somehow?

> > It seems more likely to me that one of the VIA host bridges leads
> > to bus 80.  PCI host bridges are not architected, so if this bridge
> > lives on HT chain 00, and we can think of HT as "not quite PCI,"
> > then it seems natural that the host bridge would be VIA-specific,
> > just like it was in pre-HT days.
> 
> I think the best word for it is "incompetent braindamage", but that's
> just me...

That's a pretty broad brush.  We've dismissed many ACPI issues as
being "incompetent braindamage" on the part of BIOS engineers, only
to find out later that we really had problems in the Linux/ACPI code.
Since I know approximately nothing about the VIA chipset, and I see
plenty of warts in Linux PCI code, I'm not ready to assign blame yet.

Bjorn
