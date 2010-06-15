Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab0FOBty (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 21:49:54 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:36828 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab0FOBtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 21:49:52 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH -v2] x86, pci: Handle fallout pci devices with peer root bus
Date: Mon, 14 Jun 2010 19:49:50 -0600
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
References: <4BF40014.30303@ntlworld.com> <201006141420.15799.bjorn.helgaas@hp.com> <4C169ABC.1090406@zytor.com>
In-Reply-To: <4C169ABC.1090406@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006141949.51674.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 14, 2010 03:10:20 pm H. Peter Anvin wrote:
> On 06/14/2010 01:20 PM, Bjorn Helgaas wrote:
> > 
> > OK, but Graham's system doesn't have anything resembling a PCI-to-PCI
> > bridge leading to bus 80.  So while I agree that in an ideal world,
> > HT/PCI host bridges might always look like PCI-to-PCI bridges, it
> > seems this is not the case in practice.
> 
> Invisible PCI bridges have been known to occur in pure PCI space, too.

Are you talking about PCI host bridges that don't appear in PCI config
space?  I suppose those could be described as "invisible," but since
host bridges aren't architected and their primary interface isn't PCI,
it seems only natural that we'd discover them by a non-PCI mechanism.
They're invisible in PCI terms, but obviously perfectly discoverable
and configurable via ACPI.

If you ask me, it's weird that most x86 chipsets put PCI host bridge
configuration in PCI config space -- it may be convenient in some ways,
but still architecturally strange.

> > Yes, absolutely.  My point is that what the HT spec means by "host bridge"
> > is not the same as what the PCI spec and Linux mean by "PCI host bridge".
> 
> Actually, they're *exactly* the same thing.

If HT is identical to PCI, I agree "HT host bridge" means the same
as "PCI host bridge" (that's almost too trivial to say :-)).

I guess I'm still dubious that HT is identical to PCI.  Since Graham's
box has a single HT change, we know that all his devices are on HT
chain A.  If HT is identical to PCI, that chain must be bus 00.  Here
are the relevant parts of the box:

  00:00.0 Host bridge: VIA K8T890CF Host Bridge
  00:00.1 Host bridge: VIA VT3351 Host Bridge
  00:00.2 Host bridge: VIA VT3351 Host Bridge
  00:00.3 Host bridge: VIA VT3351 Host Bridge
  00:00.4 Host bridge: VIA VT3351 Host Bridge
  00:00.7 Host bridge: VIA VT3351 Host Bridge
  00:02.0 PCI bridge:  VIA K8T890 PCI to PCI Bridge [to bus 06]
  00:03.0 PCI bridge:  VIA K8T890 PCI to PCI Bridge [to bus 05]
  00:03.1 PCI bridge:  VIA K8T890 PCI to PCI Bridge [to bus 04]
  00:03.2 PCI bridge:  VIA K8T890 PCI to PCI Bridge [to bus 03]
  00:03.3 PCI bridge:  VIA K8T890 PCI to PCI Bridge [to bus 02]
  00:11.7 Host bridge: VIA VT8251 Ultra VLINK Controller
  00:13.0 Host bridge: VIA VT8237A Host Bridge
  00:18.0 Host bridge: AMD HyperTransport Technology Configuration
  80:01.0 Audio device: VIA VT1708/A High Definition Audio Controller

The question is "how do we get to bus 80?"  If everything behind the
AMD HT host bridge is PCI and can be understood solely in terms of
PCI specs, there must be a P2P bridge from bus 00 to bus 80.  We
clearly don't have that.

I suppose one could argue that there's a non-standard P2P bridge
from bus 00 to bus 80, but I can't imagine anybody doing that.
An OS would have to have vendor-specific code just to do PCI
resource management, and that really misses the point of PCI.

It seems more likely to me that one of the VIA host bridges leads
to bus 80.  PCI host bridges are not architected, so if this bridge
lives on HT chain 00, and we can think of HT as "not quite PCI,"
then it seems natural that the host bridge would be VIA-specific,
just like it was in pre-HT days.

The underlying question for all of this is "what's the future of
amd_bus.c?" or stated another way, "does AMD HT config and standard
PCI P2P bridge config tell us everything we need to know about
address space routing?"

On this machine, I claim the answer is "no," and therefore we must
use ACPI to discover and configure the host bridges, i.e., we have
to turn on "pci=use_crs".  We currently turn it on automatically for
machines from 2008 and newer.  I think we need to do it for older
machines, too, perhaps even whenever we use ACPI at all.

Bjorn
