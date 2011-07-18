Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369Ab1GRNJL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 09:09:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755753Ab1GRNJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 09:09:07 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, eric.piel@tremplin-utc.net
Subject: [PATCH 17/34] drivers/misc changes for SMBIOS and System Firmware
Date: Mon, 18 Jul 2011 09:08:31 -0400
Message-Id: <1310994528-26276-18-git-send-email-prarit@redhat.com>
In-Reply-To: <1310994528-26276-1-git-send-email-prarit@redhat.com>
References: <1310994528-26276-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 part of the new SMBIOS and System Firmware code:

- Replace old dmi* structures and functions with new sysfw* and smbios*
structures and functions in individual drivers
- cleanup of includes for dmi.h and mod_devicetable.h which were included in
some files that did not need them

Cc: eric.piel@tremplin-utc.net
Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 drivers/misc/eeprom/at24.c         |    1 -
 drivers/misc/lis3lv02d/lis3lv02d.c |    1 -
 drivers/misc/pch_phub.c            |   14 ++++++++++++--
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/eeprom/at24.c b/drivers/misc/eeprom/at24.c
index ab1ad41..1e73630 100644
--- a/drivers/misc/eeprom/at24.c
+++ b/drivers/misc/eeprom/at24.c
@@ -16,7 +16,6 @@
 #include <linux/delay.h>
 #include <linux/mutex.h>
 #include <linux/sysfs.h>
-#include <linux/mod_devicetable.h>
 #include <linux/log2.h>
 #include <linux/bitops.h>
 #include <linux/jiffies.h>
diff --git a/drivers/misc/lis3lv02d/lis3lv02d.c b/drivers/misc/lis3lv02d/lis3lv02d.c
index b928bc1..c48b955 100644
--- a/drivers/misc/lis3lv02d/lis3lv02d.c
+++ b/drivers/misc/lis3lv02d/lis3lv02d.c
@@ -24,7 +24,6 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/dmi.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/platform_device.h>
diff --git a/drivers/misc/pch_phub.c b/drivers/misc/pch_phub.c
index 5fe79df..ecd2cb2 100644
--- a/drivers/misc/pch_phub.c
+++ b/drivers/misc/pch_phub.c
@@ -27,7 +27,7 @@
 #include <linux/mutex.h>
 #include <linux/if_ether.h>
 #include <linux/ctype.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 
 #define PHUB_STATUS 0x00		/* Status Register offset */
 #define PHUB_CONTROL 0x04		/* Control Register offset */
@@ -598,6 +598,16 @@ static ssize_t show_pch_mac(struct device *dev, struct device_attribute *attr,
 				mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
 }
 
+static struct sysfw_id pcih_phub_quirk_id[] = {
+	{
+		 .ident = "CM-iTC",
+		.matches = {
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "CM-iTC"),
+		},
+	},
+	{},
+};
+
 static ssize_t store_pch_mac(struct device *dev, struct device_attribute *attr,
 			     const char *buf, size_t count)
 {
@@ -701,7 +711,7 @@ static int __devinit pch_phub_probe(struct pci_dev *pdev,
 					       CLKCFG_CANCLK_MASK);
 
 		/* quirk for CM-iTC board */
-		if (strstr(dmi_get_system_info(DMI_BOARD_NAME), "CM-iTC"))
+		if (sysfw_callback(pcih_phub_quirk_id))
 			pch_phub_read_modify_write_reg(chip,
 						(unsigned int)CLKCFG_REG_OFFSET,
 						CLKCFG_UART_48MHZ | CLKCFG_BAUDDIV |
-- 
1.6.5.2

