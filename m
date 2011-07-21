Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929Ab1GUAWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 20:22:10 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:40638 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752153Ab1GUAVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 20:21:33 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        alexander.stein@systec-electronic.com
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH 5/6 v2] gpio-pch: Save register value in suspend()
Date: Thu, 21 Jul 2011 09:19:58 +0900
Message-Id: <1311207599-2553-5-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1311207599-2553-1-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1311207599-2553-1-git-send-email-tomoya-linux@dsn.okisemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, when suspend is occurred, register im0/1 and gpio_use_sel are not
saved.
This patch modifies so that register im0/1 and gpio_use_sel are saved.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/gpio/gpio-pch.c |   22 +++++++++++++++++++++-
 1 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-pch.c b/drivers/gpio/gpio-pch.c
index 4ac69bd..7f773af 100644
--- a/drivers/gpio/gpio-pch.c
+++ b/drivers/gpio/gpio-pch.c
@@ -30,7 +30,8 @@ struct pch_regs {
 	u32	pm;
 	u32	im0;
 	u32	im1;
-	u32	reserved[4];
+	u32	reserved[3];
+	u32	gpio_use_sel;
 	u32	reset;
 };
 
@@ -51,10 +52,17 @@ static int gpio_pins[] = {
  * struct pch_gpio_reg_data - The register store data.
  * @po_reg:	To store contents of PO register.
  * @pm_reg:	To store contents of PM register.
+ * @im0_reg:	To store contents of IM0 register.
+ * @im1_reg:	To store contents of IM1 register.
+ * @gpio_use_sel_reg : To store contents of GPIO_USE_SEL register.
+ *		       (Only ML7223 Bus-n)
  */
 struct pch_gpio_reg_data {
 	u32 po_reg;
 	u32 pm_reg;
+	u32 im0_reg;
+	u32 im1_reg;
+	u32 gpio_use_sel_reg;
 };
 
 /**
@@ -149,6 +157,12 @@ static void pch_gpio_save_reg_conf(struct pch_gpio *chip)
 {
 	chip->pch_gpio_reg.po_reg = ioread32(&chip->reg->po);
 	chip->pch_gpio_reg.pm_reg = ioread32(&chip->reg->pm);
+	chip->pch_gpio_reg.im0_reg = ioread32(&chip->reg->im0);
+	if (chip->ioh == INTEL_EG20T_PCH)
+		chip->pch_gpio_reg.im1_reg = ioread32(&chip->reg->im1);
+	if (chip->ioh == OKISEMI_ML7223n_IOH)
+		chip->pch_gpio_reg.gpio_use_sel_reg =\
+					    ioread32(&chip->reg->gpio_use_sel);
 }
 
 /*
@@ -160,6 +174,12 @@ static void pch_gpio_restore_reg_conf(struct pch_gpio *chip)
 	iowrite32(chip->pch_gpio_reg.po_reg, &chip->reg->po);
 	/* to store contents of PM register */
 	iowrite32(chip->pch_gpio_reg.pm_reg, &chip->reg->pm);
+	iowrite32(chip->pch_gpio_reg.im0_reg, &chip->reg->im0);
+	if (chip->ioh == INTEL_EG20T_PCH)
+		iowrite32(chip->pch_gpio_reg.im1_reg, &chip->reg->im1);
+	if (chip->ioh == OKISEMI_ML7223n_IOH)
+		iowrite32(chip->pch_gpio_reg.gpio_use_sel_reg,
+			  &chip->reg->gpio_use_sel);
 }
 
 static void pch_gpio_setup(struct pch_gpio *chip)
-- 
1.7.4.4

