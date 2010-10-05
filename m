Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab0JEPhv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 11:37:51 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:23814 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426Ab0JEPhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 11:37:50 -0400
Subject: [PATCH v3] DMI: log board, system, and BIOS information
To: Andrew Morton <akpm@linux-foundation.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: x86@kernel.org, Arjan van de Ven <arjan@linux.intel.com>,
        linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Tue, 05 Oct 2010 09:37:48 -0600
Message-ID: <20101005153748.19558.11518.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Put basic system information in the dmesg log.  There are lots of dmesg
logs on the web, and it would be useful if they contained this information
for debugging platform problems.  "BOARD/PRODUCT" format copied from
show_regs_common(), which is used in the oops path.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 drivers/firmware/dmi_scan.c |   32 +++++++++++++++++++++++++++++++-
 1 files changed, 31 insertions(+), 1 deletions(-)


diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index b3d22d6..e28e416 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -2,6 +2,7 @@
 #include <linux/string.h>
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/ctype.h>
 #include <linux/dmi.h>
 #include <linux/efi.h>
 #include <linux/bootmem.h>
@@ -361,6 +362,33 @@ static void __init dmi_decode(const struct dmi_header *dm, void *dummy)
 	}
 }
 
+static void __init print_filtered(const char *info)
+{
+	const char *p;
+
+	if (!info)
+		return;
+
+	for (p = info; *p; p++)
+		if (isprint(*p))
+			printk(KERN_CONT "%c", *p);
+		else
+			printk(KERN_CONT "\\x%02x", *p & 0xff);
+}
+
+static void __init dmi_dump_ids(void)
+{
+	printk(KERN_DEBUG "DMI: ");
+	print_filtered(dmi_get_system_info(DMI_BOARD_NAME));
+	printk(KERN_CONT "/");
+	print_filtered(dmi_get_system_info(DMI_PRODUCT_NAME));
+	printk(KERN_CONT ", BIOS ");
+	print_filtered(dmi_get_system_info(DMI_BIOS_VERSION));
+	printk(KERN_CONT " ");
+	print_filtered(dmi_get_system_info(DMI_BIOS_DATE));
+	printk(KERN_CONT "\n");
+}
+
 static int __init dmi_present(const char __iomem *p)
 {
 	u8 buf[15];
@@ -381,8 +409,10 @@ static int __init dmi_present(const char __iomem *p)
 			       buf[14] >> 4, buf[14] & 0xF);
 		else
 			printk(KERN_INFO "DMI present.\n");
-		if (dmi_walk_early(dmi_decode) == 0)
+		if (dmi_walk_early(dmi_decode) == 0) {
+			dmi_dump_ids();
 			return 0;
+		}
 	}
 	return 1;
 }

