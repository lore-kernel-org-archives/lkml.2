Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab1AFPR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 10:17:58 -0500
Received: from mail.pripojeni.net ([217.66.174.14]:45626 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753001Ab1AFPR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 10:17:56 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 1/1] PCI: tune up ICH4 quirk for broken BIOSes
Date: Thu,  6 Jan 2011 16:17:46 +0100
Message-Id: <1294327066-23518-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are BIOSes out there where they provide ACPI mapping that
conflicts with fixed one. Then e.g. an IDE controller doesn't work due
to I/O space conflict:
pci 0000:00:1f.1: address space collision: [io  0x0170-0x0177] conflicts with 0000:00:1f.0 [io  0x0100-0x017f]

0x0170-0x0177 for IDE controllers is created in pci_setup_device.
0x0100-0x017f for the ICH4 ISA bridge is created in quirk_ich4_lpc_acpi

The former is fixed, according to specs at that address.
The latter is read from the bridge confspace which contains:
00000000  86 80 a1 25 0f 00 80 02  02 00 01 06 00 00 80 00 |...%............|
00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00 |................|
00000020  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00 |................|
00000030  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00 |................|
00000040  01 01 00 00 10 00 00 00  00 00 00 00 00 00 01 00 |................|
00000050  00 00 00 00 00 00 00 00  01 05 00 00 10 00 00 00 |................|
...
I.e. 0x00000101 as a base (ORed by 1 meaning I/O space) for ACPI per
ICH4 specs.

Don't accept bases below 0x180 for this dynamic mapping.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/pci/quirks.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 53a786f..6d241eb 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -543,7 +543,14 @@ static void __devinit quirk_ich4_lpc_acpi(struct pci_dev *dev)
 	u32 region;
 
 	pci_read_config_dword(dev, 0x40, &region);
-	quirk_io_region(dev, region, 128, PCI_BRIDGE_RESOURCES, "ICH4 ACPI/GPIO/TCO");
+	/*
+	 * some BIOSes are bogus and create this dynamic mapping so that it
+	 * conflicts with fixed. There is no space below 0x180 for
+	 * ACPI/GPIO/TCO which is 128B long and 128B aligned.
+	 */
+	if (region >= 0x180)
+		quirk_io_region(dev, region, 128, PCI_BRIDGE_RESOURCES,
+				"ICH4 ACPI/GPIO/TCO");
 
 	pci_read_config_dword(dev, 0x58, &region);
 	quirk_io_region(dev, region, 64, PCI_BRIDGE_RESOURCES+1, "ICH4 GPIO");
-- 
1.7.3.4


