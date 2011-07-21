Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab1GUIG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 04:06:58 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:26904 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751425Ab1GUIGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 04:06:55 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk, gregkh@suse.de
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH] pch_phub: Care FUNCSEL register in PM
Date: Thu, 21 Jul 2011 17:07:08 +0900
Message-Id: <1311235628-4887-1-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only ML7213/ML7223(Bus-n) has this register.
Currently,this driver doesn't care register "FUNCSEL" in suspend/resume.
This patch saves/restores FUNCSEL register only when the device is ML7213 or
ML7223(Bus-n).

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/misc/pch_phub.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/pch_phub.c b/drivers/misc/pch_phub.c
index 7bc6f35..b2ea43e 100644
--- a/drivers/misc/pch_phub.c
+++ b/drivers/misc/pch_phub.c
@@ -89,6 +89,7 @@
 #define PCH_PHUB_INTPIN_REG_WPERMIT_REG3	0x002C
 #define PCH_PHUB_INT_REDUCE_CONTROL_REG_BASE	0x0040
 #define CLKCFG_REG_OFFSET			0x500
+#define FUNCSEL_REG_OFFSET			0x508
 
 #define PCH_PHUB_OROM_SIZE 15360
 
@@ -107,6 +108,7 @@
  * @intpin_reg_wpermit_reg3:		INTPIN_REG_WPERMIT register 3 val
  * @int_reduce_control_reg:		INT_REDUCE_CONTROL registers val
  * @clkcfg_reg:				CLK CFG register val
+ * @funcsel_reg:			Function select register value
  * @pch_phub_base_address:		Register base address
  * @pch_phub_extrom_base_address:	external rom base address
  * @pch_mac_start_address:		MAC address area start address
@@ -127,6 +129,7 @@ struct pch_phub_reg {
 	u32 intpin_reg_wpermit_reg3;
 	u32 int_reduce_control_reg[MAX_NUM_INT_REDUCE_CONTROL_REG];
 	u32 clkcfg_reg;
+	u32 funcsel_reg;
 	void __iomem *pch_phub_base_address;
 	void __iomem *pch_phub_extrom_base_address;
 	u32 pch_mac_start_address;
@@ -210,6 +213,8 @@ static void pch_phub_save_reg_conf(struct pci_dev *pdev)
 			__func__, i, chip->int_reduce_control_reg[i]);
 	}
 	chip->clkcfg_reg = ioread32(p + CLKCFG_REG_OFFSET);
+	if ((chip->ioh_type == 2) || (chip->ioh_type == 4))
+		chip->funcsel_reg = ioread32(p + FUNCSEL_REG_OFFSET);
 }
 
 /* pch_phub_restore_reg_conf - restore register configuration */
@@ -270,6 +275,8 @@ static void pch_phub_restore_reg_conf(struct pci_dev *pdev)
 	}
 
 	iowrite32(chip->clkcfg_reg, p + CLKCFG_REG_OFFSET);
+	if ((chip->ioh_type == 2) || (chip->ioh_type == 4))
+		iowrite32(chip->funcsel_reg, p + FUNCSEL_REG_OFFSET);
 }
 
 /**
-- 
1.7.4.4

