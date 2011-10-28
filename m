Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab1J1RxY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 13:53:24 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:40923 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277Ab1J1RxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 13:53:21 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: dwmw2@infradead.org, dedekind1@gmail.com, mikedunn@newsguy.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH 13/13] mtd/docg3: add suspend and resume
Date: Fri, 28 Oct 2011 19:51:32 +0200
Message-Id: <1319824292-11085-14-git-send-email-robert.jarzmik@free.fr>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1319824292-11085-1-git-send-email-robert.jarzmik@free.fr>
References: <1319824292-11085-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add functions to powerdown and powerup from suspend, in
order to save power.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/mtd/devices/docg3.c |   75 ++++++++++++++++++++++++++++++++++++++++++-
 drivers/mtd/devices/docg3.h |    6 +++
 2 files changed, 80 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/devices/docg3.c b/drivers/mtd/devices/docg3.c
index 3c4f7ed..9260034 100644
--- a/drivers/mtd/devices/docg3.c
+++ b/drivers/mtd/devices/docg3.c
@@ -45,7 +45,6 @@
  * As no specification is available from M-Systems/Sandisk, this drivers lacks
  * several functions available on the chip, as :
  *  - IPL write
- *  - powerdown / powerup
  *
  * The bus data width (8bits versus 16bits) is not handled (if_cfg flag), and
  * the driver assumes a 16bits data bus.
@@ -1624,6 +1623,78 @@ static void doc_release_device(struct mtd_info *mtd)
 }
 
 /**
+ * docg3_resume - Awakens docg3 floor
+ * @pdev: platfrom device
+ *
+ * Returns 0 (always successfull)
+ */
+static int docg3_resume(struct platform_device *pdev)
+{
+	int i;
+	struct mtd_info **docg3_floors, *mtd;
+	struct docg3 *docg3;
+
+	docg3_floors = platform_get_drvdata(pdev);
+	mtd = docg3_floors[0];
+	docg3 = mtd->priv;
+
+	doc_dbg("docg3_resume()\n");
+	for (i = 0; i < 12; i++)
+		doc_readb(docg3, DOC_IOSPACE_IPL);
+	return 0;
+}
+
+/**
+ * docg3_suspend - Put in low power mode the docg3 floor
+ * @pdev: platform device
+ * @state: power state
+ *
+ * Shuts off most of docg3 circuitery to lower power consumption.
+ *
+ * Returns 0 if suspend succeeded, -EIO if chip refused suspend
+ */
+static int docg3_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	int floor, i;
+	struct mtd_info **docg3_floors, *mtd;
+	struct docg3 *docg3;
+	u8 ctrl, pwr_down;
+
+	docg3_floors = platform_get_drvdata(pdev);
+	for (floor = 0; floor < DOC_MAX_NBFLOORS; floor++) {
+		mtd = docg3_floors[floor];
+		if (!mtd)
+			continue;
+		docg3 = mtd->priv;
+
+		doc_writeb(docg3, floor, DOC_DEVICESELECT);
+		ctrl = doc_register_readb(docg3, DOC_FLASHCONTROL);
+		ctrl &= ~DOC_CTRL_VIOLATION & ~DOC_CTRL_CE;
+		doc_writeb(docg3, ctrl, DOC_FLASHCONTROL);
+
+		for (i = 0; i < 10; i++) {
+			usleep_range(3000, 4000);
+			pwr_down = doc_register_readb(docg3, DOC_POWERMODE);
+			if (pwr_down & DOC_POWERDOWN_READY)
+				break;
+		}
+		if (pwr_down & DOC_POWERDOWN_READY) {
+			doc_dbg("docg3_suspend(): floor %d powerdown ok\n",
+				floor);
+		} else {
+			doc_err("docg3_suspend(): floor %d powerdown failed\n",
+				floor);
+			return -EIO;
+		}
+	}
+
+	mtd = docg3_floors[0];
+	docg3 = mtd->priv;
+	doc_set_asic_mode(docg3, DOC_ASICMODE_POWERDOWN);
+	return 0;
+}
+
+/**
  * doc_probe - Probe the IO space for a DiskOnChip G3 chip
  * @pdev: platform device
  *
@@ -1727,6 +1798,8 @@ static struct platform_driver g3_driver = {
 		.name	= "docg3",
 		.owner	= THIS_MODULE,
 	},
+	.suspend	= docg3_suspend,
+	.resume		= docg3_resume,
 	.remove		= __exit_p(docg3_release),
 };
 
diff --git a/drivers/mtd/devices/docg3.h b/drivers/mtd/devices/docg3.h
index 33db727..cd70b18 100644
--- a/drivers/mtd/devices/docg3.h
+++ b/drivers/mtd/devices/docg3.h
@@ -127,6 +127,7 @@
 
 #define DOC_ASICMODECONFIRM		0x1072
 #define DOC_CHIPID_INV			0x1074
+#define DOC_POWERMODE			0x107c
 
 /*
  * Flash sequences
@@ -239,6 +240,11 @@
 #define DOC_READADDR_ADDR_MASK		0x1fff
 
 /*
+ * Flash register : DOC_POWERMODE
+ */
+#define DOC_POWERDOWN_READY		0x80
+
+/*
  * Status of erase and write operation
  */
 #define DOC_PLANES_STATUS_FAIL		0x01
-- 
1.7.5.4

