Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab0HHREi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 13:04:38 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54473 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab0HHREe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 13:04:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=m/le3K0R5rAf2OiivBj9f3090A21vOQBWIlKQCX41zyuVYOz0qCKwEHEHAyAulcaof
         RE5t/vdqHc6+sBSU2q6rQc8RXlQndzo5buS5cxfz1zWHeiHL6vzZiS6gcOkfm3YzGYJ6
         5leSCsJIamQS07b3/txCF2i7EYGgAOfMhrDlQ=
From: Jarkko Nikula <jhnikula@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Jarkko Nikula <jhnikula@gmail.com>,
        Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
Subject: [PATCH 2/2] mfd: menelaus: Use macros instead of some constant magic numbers
Date: Sun,  8 Aug 2010 20:05:24 +0300
Message-Id: <1281287124-26693-2-git-send-email-jhnikula@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1281287124-26693-1-git-send-email-jhnikula@gmail.com>
References: <1281287124-26693-1-git-send-email-jhnikula@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is originally done by Carlos Eduardo Aguiar. Original fix is
commit 3305829b2816072b9c8ed01374b205ae4de74027 in
git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git

Author modified the fix for mainline version of menelaus.

Signed-off-by: Jarkko Nikula <jhnikula@gmail.com>
Cc: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
---
 drivers/mfd/menelaus.c |   75 ++++++++++++++++++++++++++++++++++-------------
 1 files changed, 54 insertions(+), 21 deletions(-)

diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
index e02b574..4ba85bb 100644
--- a/drivers/mfd/menelaus.c
+++ b/drivers/mfd/menelaus.c
@@ -128,6 +128,39 @@
 #define MENELAUS_RESERVED14_IRQ		14	/* Reserved */
 #define MENELAUS_RESERVED15_IRQ		15	/* Reserved */
 
+/* VCORE_CTRL1 register */
+#define VCORE_CTRL1_BYP_COMP		(1 << 5)
+#define VCORE_CTRL1_HW_NSW		(1 << 7)
+
+/* GPIO_CTRL register */
+#define GPIO_CTRL_SLOTSELEN		(1 << 5)
+#define GPIO_CTRL_SLPCTLEN		(1 << 6)
+#define GPIO1_DIR_INPUT			(1 << 0)
+#define GPIO2_DIR_INPUT			(1 << 1)
+#define GPIO3_DIR_INPUT			(1 << 2)
+
+/* MCT_CTRL1 register */
+#define MCT_CTRL1_S1_CMD_OD		(1 << 2)
+#define MCT_CTRL1_S2_CMD_OD		(1 << 3)
+
+/* MCT_CTRL2 register */
+#define MCT_CTRL2_VS2_SEL_D0		(1 << 0)
+#define MCT_CTRL2_VS2_SEL_D1		(1 << 1)
+#define MCT_CTRL2_S1CD_BUFEN		(1 << 4)
+#define MCT_CTRL2_S2CD_BUFEN		(1 << 5)
+#define MCT_CTRL2_S1CD_DBEN		(1 << 6)
+#define MCT_CTRL2_S2CD_BEN		(1 << 7)
+
+/* MCT_CTRL3 register */
+#define MCT_CTRL3_SLOT1_EN		(1 << 0)
+#define MCT_CTRL3_SLOT2_EN		(1 << 1)
+#define MCT_CTRL3_S1_AUTO_EN		(1 << 2)
+#define MCT_CTRL3_S2_AUTO_EN		(1 << 3)
+
+/* MCT_PIN_ST register */
+#define MCT_PIN_ST_S1_CD_ST		(1 << 0)
+#define MCT_PIN_ST_S2_CD_ST		(1 << 1)
+
 static void menelaus_work(struct work_struct *_menelaus);
 
 struct menelaus_chip {
@@ -249,10 +282,10 @@ static void menelaus_mmc_cd_work(struct menelaus_chip *menelaus_hw)
 		return;
 
 	if (!(reg & 0x1))
-		card_mask |= (1 << 0);
+		card_mask |= MCT_PIN_ST_S1_CD_ST;
 
 	if (!(reg & 0x2))
-		card_mask |= (1 << 1);
+		card_mask |= MCT_PIN_ST_S2_CD_ST;
 
 	if (menelaus_hw->mmc_callback)
 		menelaus_hw->mmc_callback(menelaus_hw->mmc_callback_data,
@@ -277,14 +310,14 @@ int menelaus_set_mmc_opendrain(int slot, int enable)
 	val = ret;
 	if (slot == 1) {
 		if (enable)
-			val |= 1 << 2;
+			val |= MCT_CTRL1_S1_CMD_OD;
 		else
-			val &= ~(1 << 2);
+			val &= ~MCT_CTRL1_S1_CMD_OD;
 	} else {
 		if (enable)
-			val |= 1 << 3;
+			val |= MCT_CTRL1_S2_CMD_OD;
 		else
-			val &= ~(1 << 3);
+			val &= ~MCT_CTRL1_S2_CMD_OD;
 	}
 	ret = menelaus_write_reg(MENELAUS_MCT_CTRL1, val);
 	mutex_unlock(&the_menelaus->lock);
@@ -301,11 +334,11 @@ int menelaus_set_slot_sel(int enable)
 	ret = menelaus_read_reg(MENELAUS_GPIO_CTRL);
 	if (ret < 0)
 		goto out;
-	ret |= 0x02;
+	ret |= GPIO2_DIR_INPUT;
 	if (enable)
-		ret |= 1 << 5;
+		ret |= GPIO_CTRL_SLOTSELEN;
 	else
-		ret &= ~(1 << 5);
+		ret &= ~GPIO_CTRL_SLOTSELEN;
 	ret = menelaus_write_reg(MENELAUS_GPIO_CTRL, ret);
 out:
 	mutex_unlock(&the_menelaus->lock);
@@ -330,14 +363,14 @@ int menelaus_set_mmc_slot(int slot, int enable, int power, int cd_en)
 	val = ret;
 	if (slot == 1) {
 		if (cd_en)
-			val |= (1 << 4) | (1 << 6);
+			val |= MCT_CTRL2_S1CD_BUFEN | MCT_CTRL2_S1CD_DBEN;
 		else
-			val &= ~((1 << 4) | (1 << 6));
+			val &= ~(MCT_CTRL2_S1CD_BUFEN | MCT_CTRL2_S1CD_DBEN);
 	} else {
 		if (cd_en)
-			val |= (1 << 5) | (1 << 7);
+			val |= MCT_CTRL2_S2CD_BUFEN | MCT_CTRL2_S2CD_BEN;
 		else
-			val &= ~((1 << 5) | (1 << 7));
+			val &= ~(MCT_CTRL2_S2CD_BUFEN | MCT_CTRL2_S2CD_BEN);
 	}
 	ret = menelaus_write_reg(MENELAUS_MCT_CTRL2, val);
 	if (ret < 0)
@@ -349,25 +382,25 @@ int menelaus_set_mmc_slot(int slot, int enable, int power, int cd_en)
 	val = ret;
 	if (slot == 1) {
 		if (enable)
-			val |= 1 << 0;
+			val |= MCT_CTRL3_SLOT1_EN;
 		else
-			val &= ~(1 << 0);
+			val &= ~MCT_CTRL3_SLOT1_EN;
 	} else {
 		int b;
 
 		if (enable)
-			val |= 1 << 1;
+			val |= MCT_CTRL3_SLOT2_EN;
 		else
-			val &= ~(1 << 1);
+			val &= ~MCT_CTRL3_SLOT2_EN;
 		b = menelaus_read_reg(MENELAUS_MCT_CTRL2);
-		b &= ~0x03;
+		b &= ~(MCT_CTRL2_VS2_SEL_D0 | MCT_CTRL2_VS2_SEL_D1);
 		b |= power;
 		ret = menelaus_write_reg(MENELAUS_MCT_CTRL2, b);
 		if (ret < 0)
 			goto out;
 	}
 	/* Disable autonomous shutdown */
-	val &= ~(0x03 << 2);
+	val &= ~(MCT_CTRL3_S1_AUTO_EN | MCT_CTRL3_S2_AUTO_EN);
 	ret = menelaus_write_reg(MENELAUS_MCT_CTRL3, val);
 out:
 	mutex_unlock(&the_menelaus->lock);
@@ -552,7 +585,7 @@ int menelaus_set_vcore_hw(unsigned int roof_mV, unsigned int floor_mV)
 	if (!the_menelaus->vcore_hw_mode) {
 		val = menelaus_read_reg(MENELAUS_VCORE_CTRL1);
 		/* HW mode, turn OFF byte comparator */
-		val |= ((1 << 7) | (1 << 5));
+		val |= (VCORE_CTRL1_HW_NSW | VCORE_CTRL1_BYP_COMP);
 		ret = menelaus_write_reg(MENELAUS_VCORE_CTRL1, val);
 		the_menelaus->vcore_hw_mode = 1;
 	}
@@ -749,7 +782,7 @@ int menelaus_set_regulator_sleep(int enable, u32 val)
 	ret = menelaus_read_reg(MENELAUS_GPIO_CTRL);
 	if (ret < 0)
 		goto out;
-	t = ((1 << 6) | 0x04);
+	t = (GPIO_CTRL_SLPCTLEN | GPIO3_DIR_INPUT);
 	if (enable)
 		ret |= t;
 	else
-- 
1.7.1

