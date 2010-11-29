Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab0K2Uow (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 15:44:52 -0500
Received: from gate.crashing.org ([63.228.1.57]:44105 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859Ab0K2Uov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 15:44:51 -0500
Subject: Re: [PATCH 03/11] x86/dtb: Add a device tree for CE4100
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mitch Bradley <wmb@firmworks.com>
Cc: Scott Wood <scottwood@freescale.com>, sodaville@linutronix.de,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <4CF40DF4.9060204@firmworks.com>
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>
	 <1290706801-7323-4-git-send-email-bigeasy@linutronix.de>
	 <1290808645.32570.158.camel@pasglop>	<20101128160449.GC30784@www.tglx.de>
	 <1290984809.32570.208.camel@pasglop>
	 <20101129130720.7d060e1c@udp111988uds.am.freescale.net>
	 <1291061128.32570.298.camel@pasglop>  <4CF40DF4.9060204@firmworks.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Nov 2010 07:44:30 +1100
Message-ID: <1291063470.32570.312.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-29 at 10:32 -1000, Mitch Bradley wrote:
> The usual layout is that the PCI bus is a direct child of
> the root node, and the ISA bus is a child of the PCI bus.

Right, tho we have been relaxing that on SoC for some time now, at least
on powerpc, since the PCI bus itself tend to hang off one of the SoC
internal busses (as a sibling of other busses) and that those tend to be
represented in the tree, so we make PCI be a child of that SoC bus.

This is also useful in the case where you have multiple SoCs (some are
capable of SMP interconnects) in which case you really have multiple
separate PCI busses and it's clearer to have each of them be the child
of its own SoC node.

> That reflects the "Northbridge + Southbridge" wiring that
> was common at the time that PCI was first introduced.
> It's usually the case that faster and wider buses are closer
> to the root, with speed and address width decreasing as you
> go away from the root.
>
> The fact that PCI configuration accesses are done via I/O
> port 0x3fc doesn't make it a child of the ISA bus, because
> I/O space is inherent in the x86 CPU architecture and thus
> can be considered to be part of the root address space.
> 
> In the systems that I have worked with, the ISA bridge is a
> first-class PCI device with a PCI config header, so it fits
> naturally underneath the PCI bus.

This is actually the case of most systems, tho those Atoms SoC are a bit
weird as, afaik, they don't really have PCI... they just simulate some
kind of PCI config space for on-chip devices ,at least that's my
understanding.

Sebastian, do you have a block diagram of the SoC ? Following the actual
bus hierarchy of the chip might be the best approach.

Cheers,
Ben.

> Here are the properties for PCI and ISA on the OLPC XO-1.5
> platform (Via C7 x86 CPU with Via VX855 IO chip):
> 
> 
> ok dev /pci
> ok .properties
> interrupt-map            00000800 00000000 00000000 00000001 ff86bf34 0000000a 00000000
>                          00006000 00000000 00000000 00000001 ff86bf34 0000000a 00000000
>                          00008000 00000000 00000000 00000001 ff86bf34 0000000a 00000000
>                          00008100 00000000 00000000 00000002 ff86bf34 00000009 00000000
>                          00008200 00000000 00000000 00000003 ff86bf34 0000000b 00000000
>                          00008400 00000000 00000000 00000004 ff86bf34 0000000a 00000000
>                          0000a000 00000000 00000000 00000001 ff86bf34 00000009 00000000
> interrupt-map-mask       0000ff00 00000000 00000000 00000007
> #interrupt-cells         00000001
> slot-names               00000000
> slave-only               00000000
> clock-frequency          01fca055
> bus-range                00000000 00000000
> #size-cells              00000002
> #address-cells           00000003
> device_type              pci
> name                     pci
> 
> ok dev /pci/isa
> ok .properties
> devsel-speed             00000001
> class-code               00060100
> subsystem-vendor-id      0000152d
> subsystem-id             00000833
> max-latency              00000000
> min-grant                00000000
> revision-id              00000000
> device-id                00008409
> vendor-id                00001106
> interrupt-parent         ff86bf34
> #interrupt-cells         00000002
> ranges                   00000000 00000000 02000000 00000000 00000000 01000000
>                          00000001 00000000 01000000 00000000 00000000 00010000
> clock-frequency          007ea5e0
> reg                      00008800 00000000 00000000 00000000 00000000
> #size-cells              00000001
> #address-cells           00000002
> device_type              isa
> name                     isa
> 
> Note that the PCI node has no reg property.  On a system with multiple independent PCI buses at the top level, it would be necessary to distinguish them with reg properties reflecting their different addresses in the root address space.  PC-style architectures typically (always?) have a single top-level PCI domain, so I've never never needed to do that in x86 land.  It used to be pretty common on PPC "big iron".
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


