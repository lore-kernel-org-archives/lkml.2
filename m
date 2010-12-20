Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800Ab0LTTPO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 14:15:14 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:12457 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932601Ab0LTTPM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 14:15:12 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #24392] AGP aperture disabled, worked in 2.6.35
Date: Mon, 20 Dec 2010 12:14:56 -0700
User-Agent: KMail/1.13.2 (Linux/2.6.32-26-generic; KDE/4.4.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, "Stephen Kitt" <steve@sk2.org>,
        bugzilla-daemon@bugzilla.kernel.org,
        Kulikov Vasiliy <segooon@gmail.com>
References: <ZRNlsjykcOD.A.b-F.20fDNB@chimera> <xqq2Z3iR9HJ.A.cHG.-0fDNB@chimera>
In-Reply-To: <xqq2Z3iR9HJ.A.cHG.-0fDNB@chimera>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201012201214.57068.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=24392
> First-Bad-Commit: http://git.kernel.org/linus/96576a9e1a0cdb8a43d3af5846be0948f52b4460

>From broken dmesg (https://bugzilla.kernel.org/attachment.cgi?id=39092):

  pci 0000:00:00.0: reg 10: [mem 0xf0000000-0xf7ffffff pref]
  pci 0000:00:1f.1: reg 24: [mem 0x00000000-0x000003ff]
  pci 0000:00:1e.0: PCI bridge to [bus 02-02] (subtractive decode)
  pci 0000:00:1e.0:   bridge window [mem 0xef000000-0xfbffffff]
  pci 0000:00:00.0: address space collision: [mem 0xf0000000-0xf7ffffff pref] conflicts with PCI Bus 0000:02 [mem 0xef000000-0xfbffffff]
  pci 0000:00:1f.1: BAR 5: assigned [mem 0xc0000000-0xc00003ff]
  agpgart-intel 0000:00:00.0: device not available (can't reserve [mem 0x00000000-0x07ffffff pref])

The conflict between the AGP 00:00.0 BAR 0 and the 00:1e.0 bridge window
looks real, so reassigning the AGP BAR looks like the right thing to do.
We assign 00:1f.1 BAR 5 in the pcibios_assign_resources() path, and
I think we would assign the AGP BAR there, too, except that the class
code of 00:00.0 is probably 0x000600 (PCI_CLASS_BRIDGE_HOST), and we
explicitly ignore host bridges in __dev_sort_resources(), so it's up
to the driver to catch this and assign it explicitly before calling
pci_enable_device().

That's kind of ugly because it's an exception to the normal "call
pci_enable_device() first" rule, and it leads to bogus "conflicts"
like this:

  pnp 00:0d: disabling [mem 0x00000000-0x0009ffff] because it overlaps 0000:00:00.0 BAR 0 [mem 0x00000000-0x07ffffff pref]

but I think we're stuck with it for now, and the simplest solution
is to just revert 96576a9e1a.

Here's the old commit that made us ignore host bridge BARs:
  http://git.kernel.org/?p=linux/kernel/git/torvalds/old-2.6-bkcvs.git;a=commitdiff;h=1d6f81a248eb2febbe24892fa4d54db382a1286c

  2004/12/17 13:44:31-08:00 macro
  [PATCH] PCI: Don't touch BARs of host bridges

   BARs of host bridges often have special meaning and AFAIK are best left
  to be setup by the firmware or system-specific startup code and kept
  intact by the generic resource handler.  For example a couple of host
  bridges used for MIPS processors interpret BARs as target-mode decoders
  for accessing host memory by PCI masters (which is quite reasonable).
  For them it's desirable to keep their decoded address range overlapping
  with the host RAM for simplicity if nothing else (I can imagine running
  out of address space with lots of memory and 32-bit PCI with no DAC
  support in the participating devices).

   This is already the case with the i386 and ppc platform-specific PCI
  resource allocators.  Please consider the following change for the generic
  allocator.  Currently we have a pile of hacks implemented for host bridges
  to be left untouched and I'd be pleased to remove them.

  From: "Maciej W. Rozycki" <macro@mips.com>
  Signed-off-by: Greg Kroah-Hartman <greg@kroah.com>
