Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab0ETRIq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 13:08:46 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:35912 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286Ab0ETRIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 13:08:44 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai <yinghai.lu@oracle.com>
Subject: Re: [Bug 16007] x86/pci Oops with CONFIG_SND_HDA_INTEL
Date: Thu, 20 May 2010 11:08:06 -0600
User-Agent: KMail/1.9.10
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Graham Ramsey <ramsey.graham@ntlworld.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       bugzilla-daemon@bugzilla.kernel.org
References: <4BF40014.30303@ntlworld.com> <20100519172221.73702261@virtuousgeek.org> <4BF48425.2040702@oracle.com>
In-Reply-To: <4BF48425.2040702@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201005201108.07040.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>>> looks like your system have a very sick BIOS,
> >>>>
> >>>> system have two HT chains.
> >>>>
> >>>> PCI: Probing PCI hardware (bus 00)
> >>>> PCI: Discovered primary peer bus 80 [IRQ]
> >>>>
> >>>> rt to non-coherent only set one link:
> >>>> node 0 link 0: io port [1000, ffffff]
> >>>> TOM: 0000000080000000 aka 2048M
> >>>> node 0 link 0: mmio [e0000000, efffffff]
> >>>> node 0 link 0: mmio [a0000, bffff]
> >>>> node 0 link 0: mmio [80000000, ffffffff]
> >>>> bus: [00, ff] on node 0 link 0

> >> ah, that 80:01.0 is standalone device, the system still only have one HT chain.
> >> that is CRAZY that they can sell those poor designed chips.
> >>
> >> actually 3e3da00c is fixing another bug with one HT chain.
> >>
> >> We have two options:
> >> 1. revert that 3e3da00c
> >> 2. or use quirks to black out system with VIA chipset.

This is voodoo kernel development, and I don't think we should do it.

Can you explain the cause of Graham's oops?  All I can see is that we
discovered a host bridge window of [mem 0x80000000-0xfcffffffff] to
bus 00, we did *not* find a bridge leading to bus 80, we found a device
on bus 80 that is inside the window forwarded to bus 00, so we moved
that device outside the window:

  bus: 00 index 1 [mem 0x80000000-0xfcffffffff]
  pci 0000:80:01.0: reg 10: [mem 0xfebfc000-0xfebfffff 64bit]
  pci 0000:80:01.0: address space collision: [mem 0xfebfc000-0xfebfffff 64bit] conflicts with PCI Bus #00 [mem 0x80000000-0xfcffffffff]
  pci 0000:80:01.0: BAR 0: set to [mem 0xfd00000000-0xfd00003fff 64bit]

I have no idea why this led to a page fault at ffffc90000078000:

  BUG: unable to handle kernel paging request at ffffc90000078000
  IP: [<ffffffffa0018d11>] azx_probe+0x3a2/0xa6a [snd_hda_intel]

It looks to me like amd_bus.c just failed to discover the host bridge
to bus 80.  If the BIOS can program the chipset to work that way, we
should be able to figure that out, too.

Graham, I think your "pci=earlydump" log is missing the KERN_DEBUG
output.  It would be interesting to see that for the patched kernel
so we can compare it with 2.6.34.

Bjorn
