Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932947Ab1FWRXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:23:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932714Ab1FWRXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:23:50 -0400
Date: Thu, 23 Jun 2011 13:23:49 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20110623172349.27691.96969.sendpatchset@prarit.bos.redhat.com>
Content-Type: text/plain; charset=us-ascii
Subject: [PATCH 16/35] drivers/media changes for SMBIOS and System Firmware
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/media changes for SMBIOS and System Firmware

As part of the new SMBIOS and System Firmware code:

- Replace old dmi* structures and functions with new sysfw* and smbios*
structures and functions in individual drivers
- cleanup sysfw_id lookup tables
- cleanup of includes for dmi.h and mod_devicetable.h which were included in
some files that did not need them

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 drivers/media/dvb/firewire/firedtv-fw.c        |    1 -
 drivers/media/dvb/firewire/firedtv.h           |    1 -
 drivers/media/video/cafe_ccic.c                |   14 ++--
 drivers/media/video/gspca/m5602/m5602_ov9650.c |   46 ++++++------
 drivers/media/video/gspca/m5602/m5602_ov9650.h |    2 +-
 drivers/media/video/gspca/m5602/m5602_s5k4aa.c |  102 ++++++++++++++----------
 drivers/media/video/gspca/m5602/m5602_s5k4aa.h |    2 +-
 drivers/media/video/gspca/sn9c20x.c            |   30 ++++---
 drivers/media/video/pvrusb2/pvrusb2-devattr.h  |    1 -
 9 files changed, 107 insertions(+), 92 deletions(-)

diff --git a/drivers/media/dvb/firewire/firedtv-fw.c b/drivers/media/dvb/firewire/firedtv-fw.c
index 864b627..5f808c1 100644
--- a/drivers/media/dvb/firewire/firedtv-fw.c
+++ b/drivers/media/dvb/firewire/firedtv-fw.c
@@ -9,7 +9,6 @@
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/mm.h>
-#include <linux/mod_devicetable.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
diff --git a/drivers/media/dvb/firewire/firedtv.h b/drivers/media/dvb/firewire/firedtv.h
index bd00b04..409b892 100644
--- a/drivers/media/dvb/firewire/firedtv.h
+++ b/drivers/media/dvb/firewire/firedtv.h
@@ -16,7 +16,6 @@
 #include <linux/dvb/dmx.h>
 #include <linux/dvb/frontend.h>
 #include <linux/list.h>
-#include <linux/mod_devicetable.h>
 #include <linux/mutex.h>
 #include <linux/spinlock_types.h>
 #include <linux/types.h>
diff --git a/drivers/media/video/cafe_ccic.c b/drivers/media/video/cafe_ccic.c
index 6647033..831d11d 100644
--- a/drivers/media/video/cafe_ccic.c
+++ b/drivers/media/video/cafe_ccic.c
@@ -25,7 +25,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/fs.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 #include <linux/mm.h>
 #include <linux/pci.h>
 #include <linux/i2c.h>
@@ -1974,15 +1974,15 @@ static irqreturn_t cafe_irq(int irq, void *data)
  * PCI interface stuff.
  */
 
-static const struct dmi_system_id olpc_xo1_dmi[] = {
+static const struct sysfw_id olpc_xo1_id[] = {
 	{
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "OLPC"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "XO"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "1"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "OLPC"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "XO"),
+			SYSFW_MATCH(SYSFW_PRODUCT_VERSION, "1"),
 		},
 	},
-	{ }
+	{}
 };
 
 static int cafe_pci_probe(struct pci_dev *pdev,
@@ -2064,7 +2064,7 @@ static int cafe_pci_probe(struct pci_dev *pdev,
 		goto out_freeirq;
 
 	/* Apply XO-1 clock speed */
-	if (dmi_check_system(olpc_xo1_dmi))
+	if (sysfw_callback(olpc_xo1_id))
 		sensor_cfg.clock_speed = 45;
 
 	cam->sensor_addr = ov7670_info.addr;
diff --git a/drivers/media/video/gspca/m5602/m5602_ov9650.c b/drivers/media/video/gspca/m5602/m5602_ov9650.c
index 703d486..d73eed0 100644
--- a/drivers/media/video/gspca/m5602/m5602_ov9650.c
+++ b/drivers/media/video/gspca/m5602/m5602_ov9650.c
@@ -43,69 +43,69 @@ static int ov9650_set_auto_exposure(struct gspca_dev *gspca_dev, __s32 val);
    where the sensor is mounted upside down */
 static
     const
-	struct dmi_system_id ov9650_flip_dmi_table[] = {
+	struct sysfw_id ov9650_flip_id_table[] = {
 	{
 		.ident = "ASUS A6Ja",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "A6J")
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "ASUSTeK Computer Inc."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "A6J")
 		}
 	},
 	{
 		.ident = "ASUS A6JC",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "A6JC")
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "ASUSTeK Computer Inc."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "A6JC")
 		}
 	},
 	{
 		.ident = "ASUS A6K",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "A6K")
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "ASUSTeK Computer Inc."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "A6K")
 		}
 	},
 	{
 		.ident = "ASUS A6Kt",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "A6Kt")
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "ASUSTeK Computer Inc."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "A6Kt")
 		}
 	},
 	{
 		.ident = "ASUS A6VA",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "A6VA")
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "ASUSTeK Computer Inc."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "A6VA")
 		}
 	},
 	{
 
 		.ident = "ASUS A6VC",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "A6VC")
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "ASUSTeK Computer Inc."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "A6VC")
 		}
 	},
 	{
 		.ident = "ASUS A6VM",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "A6VM")
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "ASUSTeK Computer Inc."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "A6VM")
 		}
 	},
 	{
 		.ident = "ASUS A7V",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "A7V")
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "ASUSTeK Computer Inc."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "A7V")
 		}
 	},
 	{
 		.ident = "Alienware Aurora m9700",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "alienware"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Aurora m9700")
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "alienware"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Aurora m9700")
 		}
 	},
 	{}
@@ -424,9 +424,9 @@ int ov9650_start(struct sd *sd)
 	int ver_offs = cam->cam_mode[sd->gspca_dev.curr_mode].priv;
 	int hor_offs = OV9650_LEFT_OFFSET;
 
-	if ((!dmi_check_system(ov9650_flip_dmi_table) &&
+	if ((!sysfw_callback(ov9650_flip_id_table) &&
 		sensor_settings[VFLIP_IDX]) ||
-		(dmi_check_system(ov9650_flip_dmi_table) &&
+		(sysfw_callback(ov9650_flip_id_table) &&
 		!sensor_settings[VFLIP_IDX]))
 		ver_offs--;
 
@@ -709,7 +709,7 @@ static int ov9650_set_hflip(struct gspca_dev *gspca_dev, __s32 val)
 
 	sensor_settings[HFLIP_IDX] = val;
 
-	if (!dmi_check_system(ov9650_flip_dmi_table))
+	if (!sysfw_callback(ov9650_flip_id_table))
 		i2c_data = ((val & 0x01) << 5) |
 				(sensor_settings[VFLIP_IDX] << 4);
 	else
@@ -742,7 +742,7 @@ static int ov9650_set_vflip(struct gspca_dev *gspca_dev, __s32 val)
 	PDEBUG(D_V4L2, "Set vertical flip to %d", val);
 	sensor_settings[VFLIP_IDX] = val;
 
-	if (dmi_check_system(ov9650_flip_dmi_table))
+	if (sysfw_callback(ov9650_flip_id_table))
 		val = !val;
 
 	i2c_data = ((val & 0x01) << 4) | (sensor_settings[VFLIP_IDX] << 5);
diff --git a/drivers/media/video/gspca/m5602/m5602_ov9650.h b/drivers/media/video/gspca/m5602/m5602_ov9650.h
index da9a129..394042f 100644
--- a/drivers/media/video/gspca/m5602/m5602_ov9650.h
+++ b/drivers/media/video/gspca/m5602/m5602_ov9650.h
@@ -19,7 +19,7 @@
 #ifndef M5602_OV9650_H_
 #define M5602_OV9650_H_
 
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 #include "m5602_sensor.h"
 
 /*****************************************************************************/
diff --git a/drivers/media/video/gspca/m5602/m5602_s5k4aa.c b/drivers/media/video/gspca/m5602/m5602_s5k4aa.c
index d27280b..c6860e9 100644
--- a/drivers/media/video/gspca/m5602/m5602_s5k4aa.c
+++ b/drivers/media/video/gspca/m5602/m5602_s5k4aa.c
@@ -33,85 +33,101 @@ static int s5k4aa_set_brightness(struct gspca_dev *gspca_dev, __s32 val);
 
 static
     const
-	struct dmi_system_id s5k4aa_vflip_dmi_table[] = {
+	struct sysfw_id s5k4aa_vflip_id_table[] = {
 	{
 		.ident = "BRUNEINIT",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "BRUNENIT"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "BRUNENIT"),
-			DMI_MATCH(DMI_BOARD_VERSION, "00030D0000000001")
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "BRUNENIT"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "BRUNENIT"),
+			SYSFW_MATCH(SYSFW_BOARD_VERSION, "00030D0000000001")
 		}
-	}, {
+	},
+	{
 		.ident = "Fujitsu-Siemens Amilo Xa 2528",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "AMILO Xa 2528")
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "FUJITSU SIEMENS"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "AMILO Xa 2528")
 		}
-	}, {
+	},
+	{
 		.ident = "Fujitsu-Siemens Amilo Xi 2428",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "AMILO Xi 2428")
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "FUJITSU SIEMENS"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "AMILO Xi 2428")
 		}
-	}, {
+	},
+	{
 		.ident = "Fujitsu-Siemens Amilo Xi 2528",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "AMILO Xi 2528")
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "FUJITSU SIEMENS"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "AMILO Xi 2528")
 		}
-	}, {
+	},
+	{
 		.ident = "Fujitsu-Siemens Amilo Xi 2550",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "AMILO Xi 2550")
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "FUJITSU SIEMENS"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "AMILO Xi 2550")
 		}
-	}, {
+	},
+	{
 		.ident = "Fujitsu-Siemens Amilo Pa 2548",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "AMILO Pa 2548")
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "FUJITSU SIEMENS"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "AMILO Pa 2548")
 		}
-	}, {
+	},
+	{
 		.ident = "MSI GX700",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Micro-Star International"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "GX700"),
-			DMI_MATCH(DMI_BIOS_DATE, "12/02/2008")
+			SYSFW_MATCH(SYSFW_SYS_VENDOR,
+				    "Micro-Star International"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "GX700"),
+			SYSFW_MATCH(SYSFW_BIOS_DATE, "12/02/2008")
 		}
-	}, {
+	},
+	{
 		.ident = "MSI GX700",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Micro-Star International"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "GX700"),
-			DMI_MATCH(DMI_BIOS_DATE, "07/26/2007")
+			SYSFW_MATCH(SYSFW_SYS_VENDOR,
+				    "Micro-Star International"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "GX700"),
+			SYSFW_MATCH(SYSFW_BIOS_DATE, "07/26/2007")
 		}
-	}, {
+	},
+	{
 		.ident = "MSI GX700",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Micro-Star International"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "GX700"),
-			DMI_MATCH(DMI_BIOS_DATE, "07/19/2007")
+			SYSFW_MATCH(SYSFW_SYS_VENDOR,
+				    "Micro-Star International"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "GX700"),
+			SYSFW_MATCH(SYSFW_BIOS_DATE, "07/19/2007")
 		}
-	}, {
+	},
+	{
 		.ident = "MSI GX700/GX705/EX700",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Micro-Star International"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "GX700/GX705/EX700")
+			SYSFW_MATCH(SYSFW_SYS_VENDOR,
+				    "Micro-Star International"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "GX700/GX705/EX700")
 		}
-	}, {
+	},
+	{
 		.ident = "MSI L735",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Micro-Star International"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MS-1717X")
+			SYSFW_MATCH(SYSFW_SYS_VENDOR,
+				    "Micro-Star International"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "MS-1717X")
 		}
-	}, {
+	},
+	{
 		.ident = "Lenovo Y300",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "L3000 Y300"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Y300")
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "L3000 Y300"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "Y300")
 		}
 	},
-	{ }
+	{}
 };
 
 static struct v4l2_pix_format s5k4aa_modes[] = {
@@ -520,7 +536,7 @@ static int s5k4aa_set_vflip(struct gspca_dev *gspca_dev, __s32 val)
 	if (err < 0)
 		return err;
 
-	if (dmi_check_system(s5k4aa_vflip_dmi_table))
+	if (sysfw_callback(s5k4aa_vflip_id_table))
 		val = !val;
 
 	data = ((data & ~S5K4AA_RM_V_FLIP) | ((val & 0x01) << 7));
@@ -568,7 +584,7 @@ static int s5k4aa_set_hflip(struct gspca_dev *gspca_dev, __s32 val)
 	if (err < 0)
 		return err;
 
-	if (dmi_check_system(s5k4aa_vflip_dmi_table))
+	if (sysfw_callback(s5k4aa_vflip_id_table))
 		val = !val;
 
 	data = ((data & ~S5K4AA_RM_H_FLIP) | ((val & 0x01) << 6));
diff --git a/drivers/media/video/gspca/m5602/m5602_s5k4aa.h b/drivers/media/video/gspca/m5602/m5602_s5k4aa.h
index 8cc7a3f..d6d1338 100644
--- a/drivers/media/video/gspca/m5602/m5602_s5k4aa.h
+++ b/drivers/media/video/gspca/m5602/m5602_s5k4aa.h
@@ -19,7 +19,7 @@
 #ifndef M5602_S5K4AA_H_
 #define M5602_S5K4AA_H_
 
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 
 #include "m5602_sensor.h"
 
diff --git a/drivers/media/video/gspca/sn9c20x.c b/drivers/media/video/gspca/sn9c20x.c
index c431900..90f919a 100644
--- a/drivers/media/video/gspca/sn9c20x.c
+++ b/drivers/media/video/gspca/sn9c20x.c
@@ -24,7 +24,7 @@
 #include "jpeg.h"
 
 #include <media/v4l2-chip-ident.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 
 MODULE_AUTHOR("Brian Johnson <brijohn@gmail.com>, "
 		"microdia project <microdia@googlegroups.com>");
@@ -135,41 +135,43 @@ static int sd_getexposure(struct gspca_dev *gspca_dev, s32 *val);
 static int sd_setautoexposure(struct gspca_dev *gspca_dev, s32 val);
 static int sd_getautoexposure(struct gspca_dev *gspca_dev, s32 *val);
 
-static const struct dmi_system_id flip_dmi_table[] = {
+static const struct sysfw_id flip_id_table[] = {
 	{
 		.ident = "MSI MS-1034",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "MICRO-STAR INT'L CO.,LTD."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MS-1034"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "0341")
+			SYSFW_MATCH(SYSFW_SYS_VENDOR,
+				    "MICRO-STAR INT'L CO.,LTD."),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "MS-1034"),
+			SYSFW_MATCH(SYSFW_PRODUCT_VERSION, "0341")
 		}
 	},
 	{
 		.ident = "MSI MS-1632",
 		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "MSI"),
-			DMI_MATCH(DMI_BOARD_NAME, "MS-1632")
+			SYSFW_MATCH(SYSFW_BOARD_VENDOR, "MSI"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "MS-1632")
 		}
 	},
 	{
 		.ident = "MSI MS-1633X",
 		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "MSI"),
-			DMI_MATCH(DMI_BOARD_NAME, "MS-1633X")
+			SYSFW_MATCH(SYSFW_BOARD_VENDOR, "MSI"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "MS-1633X")
 		}
 	},
 	{
 		.ident = "MSI MS-1635X",
 		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "MSI"),
-			DMI_MATCH(DMI_BOARD_NAME, "MS-1635X")
+			SYSFW_MATCH(SYSFW_BOARD_VENDOR, "MSI"),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "MS-1635X")
 		}
 	},
 	{
 		.ident = "ASUSTeK W7J",
 		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer Inc."),
-			DMI_MATCH(DMI_BOARD_NAME, "W7J       ")
+			SYSFW_MATCH(SYSFW_BOARD_VENDOR,
+				    "ASUSTeK Computer Inc."),
+			SYSFW_MATCH(SYSFW_BOARD_NAME, "W7J       ")
 		}
 	},
 	{}
@@ -1607,7 +1609,7 @@ static int set_hvflip(struct gspca_dev *gspca_dev)
 	u16 value2;
 	struct sd *sd = (struct sd *) gspca_dev;
 
-	if ((sd->flags & FLIP_DETECT) && dmi_check_system(flip_dmi_table)) {
+	if ((sd->flags & FLIP_DETECT) && sysfw_callback(flip_id_table)) {
 		hflip = !sd->hflip;
 		vflip = !sd->vflip;
 	} else {
diff --git a/drivers/media/video/pvrusb2/pvrusb2-devattr.h b/drivers/media/video/pvrusb2/pvrusb2-devattr.h
index 273c8d4..68b8073 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-devattr.h
+++ b/drivers/media/video/pvrusb2/pvrusb2-devattr.h
@@ -20,7 +20,6 @@
 #ifndef __PVRUSB2_DEVATTR_H
 #define __PVRUSB2_DEVATTR_H
 
-#include <linux/mod_devicetable.h>
 #include <linux/videodev2.h>
 #ifdef CONFIG_VIDEO_PVRUSB2_DVB
 #include "pvrusb2-dvb.h"
-- 
1.7.5.4

