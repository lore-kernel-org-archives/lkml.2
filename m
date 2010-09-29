Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048Ab0I2SYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 14:24:05 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:3435 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353Ab0I2SYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 14:24:04 -0400
Subject: [PATCH] DMI: log system, BIOS, and board information
To: Andrew Morton <akpm@linux-foundation.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 29 Sep 2010 12:24:02 -0600
Message-ID: <20100929182402.31093.4303.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Put basic system information in the dmesg log.  There are lots of dmesg
logs on the web, and it would be useful if they contained this information
for debugging platform problems.

DMI often doesn't supply a board name, but I assume the others are pretty
standard.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 drivers/firmware/dmi_scan.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)


diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index b3d22d6..ea6719f 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -364,6 +364,7 @@ static void __init dmi_decode(const struct dmi_header *dm, void *dummy)
 static int __init dmi_present(const char __iomem *p)
 {
 	u8 buf[15];
+	const char *board, *label = " board ";
 
 	memcpy_fromio(buf, p, 15);
 	if ((memcmp(buf, "_DMI_", 5) == 0) && dmi_checksum(buf)) {
@@ -381,8 +382,20 @@ static int __init dmi_present(const char __iomem *p)
 			       buf[14] >> 4, buf[14] & 0xF);
 		else
 			printk(KERN_INFO "DMI present.\n");
-		if (dmi_walk_early(dmi_decode) == 0)
+		if (dmi_walk_early(dmi_decode) == 0) {
+			board = dmi_get_system_info(DMI_BOARD_NAME);
+			if (!board) {
+				board = "";
+				label = "";
+			}
+			printk(KERN_DEBUG "DMI: %s %s BIOS %s %s%s%s\n",
+			       dmi_get_system_info(DMI_SYS_VENDOR),
+			       dmi_get_system_info(DMI_PRODUCT_NAME),
+			       dmi_get_system_info(DMI_BIOS_VERSION),
+			       dmi_get_system_info(DMI_BIOS_DATE),
+			       label, board);
 			return 0;
+		}
 	}
 	return 1;
 }

