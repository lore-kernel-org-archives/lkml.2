Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933101Ab1FWRZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:25:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933077Ab1FWRZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:25:23 -0400
Date: Thu, 23 Jun 2011 13:25:22 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20110623172522.27773.42472.sendpatchset@prarit.bos.redhat.com>
Content-Type: text/plain; charset=us-ascii
Subject: [PATCH 31/35] drivers/watchdog changes for SMBIOS and System
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/watchdog changes for SMBIOS and System Firmware

As part of the new SMBIOS and System Firmware code:

- Replace old dmi* structures and functions with new sysfw* and smbios*
structures and functions in individual drivers
- cleanup sysfw_id lookup tables

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 drivers/watchdog/hpwdt.c          |   16 +++++++++-------
 drivers/watchdog/ibmasr.c         |    9 +++------
 drivers/watchdog/sbc_fitpc2_wdt.c |   22 +++++++++++++++-------
 3 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 8cb2685..8849eac 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -28,7 +28,7 @@
 #include <linux/uaccess.h>
 #include <linux/watchdog.h>
 #ifdef CONFIG_HPWDT_NMI_DECODING
-#include <linux/dmi.h>
+#include <linux/smbios.h>
 #include <linux/spinlock.h>
 #include <linux/nmi.h>
 #include <linux/kdebug.h>
@@ -374,19 +374,19 @@ asm(".text                      \n\t"
     ".previous");
 
 /*
- *	dmi_find_cru
+ *	smbios_find_cru
  *
  *	Routine Description:
- *	This function checks whether or not a SMBIOS/DMI record is
+ *	This function checks whether or not a SMBIOS/SMBIOS record is
  *	the 64bit CRU info or not
  */
-static void __devinit dmi_find_cru(const struct dmi_header *dm, void *dummy)
+static int __devinit smbios_find_cru(const union smbios_struct *ss, void *dummy)
 {
 	struct smbios_cru64_info *smbios_cru64_ptr;
 	unsigned long cru_physical_address;
 
-	if (dm->type == SMBIOS_CRU64_INFORMATION) {
-		smbios_cru64_ptr = (struct smbios_cru64_info *) dm;
+	if (ss->header.type == SMBIOS_CRU64_INFORMATION) {
+		smbios_cru64_ptr = (struct smbios_cru64_info *) &ss;
 		if (smbios_cru64_ptr->signature == CRU_BIOS_SIGNATURE_VALUE) {
 			cru_physical_address =
 				smbios_cru64_ptr->physical_address +
@@ -395,15 +395,17 @@ static void __devinit dmi_find_cru(const struct dmi_header *dm, void *dummy)
 				smbios_cru64_ptr->double_length);
 			set_memory_x((unsigned long)cru_rom_addr & PAGE_MASK,
 				smbios_cru64_ptr->double_length >> PAGE_SHIFT);
+			return SMBIOS_WALK_STOP;
 		}
 	}
+	return SMBIOS_WALK_CONTINUE;
 }
 
 static int __devinit detect_cru_service(void)
 {
 	cru_rom_addr = NULL;
 
-	dmi_walk(dmi_find_cru, NULL);
+	smbios_walk(smbios_find_cru, NULL);
 
 	/* if cru_rom_addr has been set then we found a CRU service */
 	return ((cru_rom_addr != NULL) ? 0 : -ENODEV);
diff --git a/drivers/watchdog/ibmasr.c b/drivers/watchdog/ibmasr.c
index 195e0f7..b8cc126 100644
--- a/drivers/watchdog/ibmasr.c
+++ b/drivers/watchdog/ibmasr.c
@@ -17,7 +17,7 @@
 #include <linux/timer.h>
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
-#include <linux/dmi.h>
+#include <linux/smbios.h>
 #include <linux/io.h>
 #include <linux/uaccess.h>
 
@@ -376,12 +376,9 @@ static int __init ibmasr_init(void)
 	struct ibmasr_id *id;
 	int rc;
 
-	for (id = ibmasr_id_table; id->desc; id++) {
-		if (dmi_find_device(DMI_DEV_TYPE_OTHER, id->desc, NULL)) {
+	for (id = ibmasr_id_table; id->desc; id++)
+		if (smbios_is_onboard_device(id->desc, 0))
 			asr_type = id->type;
-			break;
-		}
-	}
 
 	if (!asr_type)
 		return -ENODEV;
diff --git a/drivers/watchdog/sbc_fitpc2_wdt.c b/drivers/watchdog/sbc_fitpc2_wdt.c
index d5d3994..0419e01 100644
--- a/drivers/watchdog/sbc_fitpc2_wdt.c
+++ b/drivers/watchdog/sbc_fitpc2_wdt.c
@@ -21,7 +21,7 @@
 #include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/moduleparam.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 #include <linux/io.h>
 #include <linux/uaccess.h>
 
@@ -198,17 +198,25 @@ static struct miscdevice fitpc2_wdt_miscdev = {
 	.fops		= &fitpc2_wdt_fops,
 };
 
+static struct sysfw_id __initdata fitpc2_device_table[] = {
+	{
+		.ident = "SBC-FITPC2 Watchdog",
+		.matches = {
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "SBC-FITPC2"),
+		},
+	},
+	{}
+};
+
 static int __init fitpc2_wdt_init(void)
 {
 	int err;
-	const char *brd_name;
+	const struct sysfw_id *id;
 
-	brd_name = dmi_get_system_info(DMI_BOARD_NAME);
-
-	if (!brd_name || !strstr(brd_name, "SBC-FITPC2"))
+	id = sysfw_callback(fitpc2_device_table);
+	if (!id)
 		return -ENODEV;
-
-	pr_info("%s found\n", brd_name);
+	pr_info("%s found\n", id->ident);
 
 	if (!request_region(COMMAND_PORT, 1, WATCHDOG_NAME)) {
 		pr_err("I/O address 0x%04x already in use\n", COMMAND_PORT);
-- 
1.7.5.4

