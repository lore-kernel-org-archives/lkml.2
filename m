Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759500Ab0HLA26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:28:58 -0400
Received: from kroah.org ([198.145.64.141]:60086 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932679Ab0HLADu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:03:50 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:01:23 2010
Message-Id: <20100812000123.772064534@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:00:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [05/54] x86/PCI: use host bridge _CRS info on ASRock ALiveSATA2-GLAN
In-Reply-To: <20100812000249.GA30948@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bjorn Helgaas <bjorn.helgaas@hp.com>

commit 2491762cfb475dbdfa3db11ebea6de49f58b7fac upstream.

This DMI quirk turns on "pci=use_crs" for the ALiveSATA2-GLAN because
amd_bus.c doesn't handle this system correctly.

The system has a single HyperTransport I/O chain, but has two PCI host
bridges to buses 00 and 80.  amd_bus.c learns the MMIO range associated
with buses 00-ff and that this range is routed to the HT chain hosted at
node 0, link 0:

    bus: [00, ff] on node 0 link 0
    bus: 00 index 1 [mem 0x80000000-0xfcffffffff]

This includes the address space for both bus 00 and bus 80, and amd_bus.c
assumes it's all routed to bus 00.

We find device 80:01.0, which BIOS left in the middle of that space, but
we don't find a bridge from bus 00 to bus 80, so we conclude that 80:01.0
is unreachable from bus 00, and we move it from the original, working,
address to something outside the bus 00 aperture, which does not work:

    pci 0000:80:01.0: reg 10: [mem 0xfebfc000-0xfebfffff 64bit]
    pci 0000:80:01.0: BAR 0: assigned [mem 0xfd00000000-0xfd00003fff 64bit]

The BIOS told us everything we need to know to handle this correctly,
so we're better off if we just pay attention, which lets us leave the
80:01.0 device at the original, working, address:

    ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-7f])
    pci_root PNP0A03:00: host bridge window [mem 0x80000000-0xff37ffff]
    ACPI: PCI Root Bridge [PCI1] (domain 0000 [bus 80-ff])
    pci_root PNP0A08:00: host bridge window [mem 0xfebfc000-0xfebfffff]

This was a regression between 2.6.33 and 2.6.34.  In 2.6.33, amd_bus.c
was used only when we found multiple HT chains.  3e3da00c01d050, which
enabled amd_bus.c even on systems with a single HT chain, caused this
failure.

This quirk was written by Graham.  If we ever enable "pci=use_crs" for
machines from 2006 or earlir, this quirk should be removed.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=16007

Reported-by: Graham Ramsey <ramsey.graham@ntlworld.com>
Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/pci/acpi.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -34,6 +34,15 @@ static const struct dmi_system_id pci_us
 			DMI_MATCH(DMI_PRODUCT_NAME, "x3800"),
 		},
 	},
+	/* https://bugzilla.kernel.org/show_bug.cgi?id=16007 */
+	/* 2006 AMD HT/VIA system with two host bridges */
+        {
+		.callback = set_use_crs,
+		.ident = "ASRock ALiveSATA2-GLAN",
+		.matches = {
+			DMI_MATCH(DMI_PRODUCT_NAME, "ALiveSATA2-GLAN"),
+                },
+        },
 	{}
 };
 


