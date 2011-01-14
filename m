Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab1ANKcn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 05:32:43 -0500
Received: from mail.pripojeni.net ([217.66.174.14]:42217 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab1ANKcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 05:32:36 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Renninger <trenn@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH option A 2/2] PCI: do not create quirk I/O regions below PCIBIOS_MIN_IO
Date: Fri, 14 Jan 2011 11:32:26 +0100
Message-Id: <1295001146-14910-3-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <4D3025F4.6020001@gmail.com>
References: <4D3025F4.6020001@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some broken BIOSes on ICH4 chipset report an ACPI region which is in
conflict with legacy IDE ports when ACPI is disabled. Even though the
regions overlap, IDE ports are working correctly (we cannot find out
the decoding rules on chipsets).

So the only problem is the reported region itself, if we don't reserve
the region in the quirk everything works as expected.

This patch avoids reserving any quirk regions below PCIBIOS_MIN_IO
which is 0x1000. Some regions might be (and are by a fast google
query) below this border, but the only difference is that they won't
be reserved anymore. They should still work though the same as before.

The conflicts look like (1f.0 is bridge, 1f.1 is IDE ctrl):
pci 0000:00:1f.1: address space collision: [io 0x0170-0x0177] conflicts with 0000:00:1f.0 [io  0x0100-0x017f]

At 0x0100 a 128 bytes long ACPI region is reported in the quirk for
ICH4. ata_piix then fails to find disks because the IDE legacy ports
are zeroed:
ata_piix 0000:00:1f.1: device not available (can't reserve [io 0x0000-0x0007])

References: https://bugzilla.novell.com/show_bug.cgi?id=558740
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 drivers/pci/quirks.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 8db2426..cfedf2b 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -388,7 +388,14 @@ static void __devinit quirk_io_region(struct pci_dev *dev, unsigned region,
 	unsigned size, int nr, const char *name)
 {
 	region &= ~(size-1);
-	if (region) {
+	/*
+	 * The check for PCIBIOS_MIN_IO is to ensure we won't create a conflict
+	 * with low legacy (and fixed) ports. We don't know the decoding
+	 * priority and can't tell whether the legacy device or the one created
+	 * here is really at that address. This happens on boards with broken
+	 * BIOSes. At least one known is with ICH4.
+	 */
+	if (region && region >= PCIBIOS_MIN_IO) {
 		struct pci_bus_region bus_region;
 		struct resource *res = dev->resource + nr;
 
-- 
1.7.3.4


