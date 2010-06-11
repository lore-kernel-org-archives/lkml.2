Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760608Ab0FKVtK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 17:49:10 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:16605 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946Ab0FKVtI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 17:49:08 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai <yinghai.lu@oracle.com>
Subject: Re: [Bug 16007] x86/pci Oops with CONFIG_SND_HDA_INTEL
Date: Fri, 11 Jun 2010 15:49:04 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Graham Ramsey <ramsey.graham@ntlworld.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       bugzilla-daemon@bugzilla.kernel.org, Myron Stowe <myron.stowe@hp.com>,
       Robert Richter <robert.richter@amd.com>,
       Harald Welte <HaraldWelte@viatech.com>,
       Joseph Chan <JosephChan@via.com.tw>
References: <4BF40014.30303@ntlworld.com> <201005201108.07040.bjorn.helgaas@hp.com> <201006021058.57361.bjorn.helgaas@hp.com>
In-Reply-To: <201006021058.57361.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201006111549.05164.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[If you haven't been following this bug, the report is at [3].]

Here's a theory.  I'm not an expert in HyperTransport, so maybe somebody
who knows HyperTransport and/or VIA chipsets can validate or refute it.

This is based on the _HyperTransport I/O Link Specification_, rev 3.10b [1],
and the _BIOS and Kernel Developer's Guide (BKDG) for AMD Family 10h
Processors_ [2].

In a nutshell, I think the problem is that amd_bus.c treats a
HyperTransport (HT) host bridge as though it were a PCI host bridge.  In
particular, when an HT chain contains more than one PCI host bridge, the
HT host bridge apertures encompass all the PCI host bridges, but
amd_bus.c mistakenly assigns all those resources to one PCI host bridge.

>From a software point of view, HyperTransport is similar but not
identical to PCI.  It is possible to make native HyperTransport
peripheral devices, but PCI devices must be attached via a
HyperTransport-to-PCI bridge [1, sec 4.1].

A PCI host bridge has a platform-specific non-PCI connection, e.g., a
front-side bus, on the primary (upstream) side and a PCI bus on the
secondary (downstream) side.  Note that in the HyperTransport spec,
"host bridge" refers to the interface from the host, e.g., CPU cores, to
a HyperTransport chain.  This HyperTransport host bridge has a
HyperTransport link on the secondary side, *not* a PCI bus.

A HyperTransport-to-PCI bridge is one kind of PCI host bridge, because
the primary side is HyperTransport and the secondary side is PCI.

Graham's machine contains one HT host bridge leading to an HT chain, and
it has PCI devices on buses 00, 02, 03, 06, and 80.  In addition, the HT
host bridge configuration registers appear at device 18 (hex) in bus 00
configuration space, though they are not actually PCI functions.  PCI
buses 02, 03, and 06 are reachable from bus 00 via the PCI-to-PCI
bridges at 00:03.3, 00:03.2, and 00:02.0, respectively.

However, there are no PCI-to-PCI bridges that lead to bus 00 or bus 80,
so the HT chain must contain two separate PCI host bridges that lead to
them.

Now, here's the problem: amd_bus.c reads the HT host bridge configuration
and learns that it routes buses 00-ff and the related address space,
including the following range, down the HT chain at node 0, link 0:

    [mem 0x80000000-0xfcffffffff]

That makes sense, because both PCI host bridges are on that HT chain, so
the HT host bridge has to forward all that address space.  The problem
is that amd_bus.c assumes there's only one PCI host bridge on the
chain, so it assigns *all* that address space to PCI bus 00.

This doesn't work because parts of that address space belong to bus 80,
not bus 00, and we can't reach bus 80 from PCI bus 00.  In particular,
we know that at least the following address space is routed to bus 80,
because the 80:01.0 device does work at this address, which is in the
middle of the range we found above:

    [mem 0xfebfc000-0xfebfffff]

(Note that we can reach bus 80 from the HT chain, but the HT chain is
outside the PCI domain, even though some of the HT registers appear in
PCI bus 00 config space.  We need a second PCI host bridge from the HT
chain to PCI bus 80.)

The HT spec does suggest that an HT/PCI host bridge should implement a
HyperTransport Bridge Header [1, sec 7.4].  This header would make the
HT/PCI host bridge look just like a PCI-to-PCI bridge, with the usual
primary/secondary/subordinate bus numbers, memory, prefetchable memory,
and I/O port apertures, etc.

If all the HT/PCI host bridges on a chain were implemented this way, I
think it probably would work to pretend the HT host bridge is a PCI host
bridge.  But this sort of implementation is apparently not universal.
The VIA chipset in Graham's machine doesn't do it that way, and the
Serverworks HT-2100 chipset in the HP DL785 doesn't either.


[1] http://www.hypertransport.org/docs/twgdocs/HTC20051222-0046-0033_changes.pdf
[2] http://support.amd.com/us/Embedded_TechDocs/31116-Public-GH-BKDG_3-28_5-28-09.pdf
[3] https://bugzilla.kernel.org/show_bug.cgi?id=16007
