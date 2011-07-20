Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763Ab1GTKNQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 06:13:16 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:25874 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751317Ab1GTKMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 06:12:08 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        alexander.stein@systec-electronic.com
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH 4/6] pch_gpio: modify gpio_nums and mask
Date: Wed, 20 Jul 2011 19:11:00 +0900
Message-Id: <1311156662-3044-4-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1311156662-3044-1-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1311156662-3044-1-git-send-email-tomoya-linux@dsn.okisemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the number of GPIO pins is set fixed value(=12).
Also PIN MASK is set as '0xfff'.
However the pins differs by IOH.
This patch sets the value correctly.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/gpio/pch_gpio.c |   31 +++++++++++++++++++++++++------
 1 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/pch_gpio.c b/drivers/gpio/pch_gpio.c
index d548069..4ac69bd 100644
--- a/drivers/gpio/pch_gpio.c
+++ b/drivers/gpio/pch_gpio.c
@@ -18,9 +18,6 @@
 #include <linux/pci.h>
 #include <linux/gpio.h>
 
-#define PCH_GPIO_ALL_PINS	0xfff /* Mask for GPIO pins 0 to 11 */
-#define GPIO_NUM_PINS	12	/* Specifies number of GPIO PINS GPIO0-GPIO11 */
-
 struct pch_regs {
 	u32	ien;
 	u32	istatus;
@@ -37,6 +34,19 @@ struct pch_regs {
 	u32	reset;
 };
 
+enum pch_type_t {
+	INTEL_EG20T_PCH,
+	OKISEMI_ML7223m_IOH, /* OKISEMI ML7223 IOH PCIe Bus-m */
+	OKISEMI_ML7223n_IOH  /* OKISEMI ML7223 IOH PCIe Bus-n */
+};
+
+/* Specifies number of GPIO PINS */
+static int gpio_pins[] = {
+	[INTEL_EG20T_PCH] = 12,
+	[OKISEMI_ML7223m_IOH] = 8,
+	[OKISEMI_ML7223n_IOH] = 8,
+};
+
 /**
  * struct pch_gpio_reg_data - The register store data.
  * @po_reg:	To store contents of PO register.
@@ -55,6 +65,7 @@ struct pch_gpio_reg_data {
  * @gpio:			Data for GPIO infrastructure.
  * @pch_gpio_reg:		Memory mapped Register data is saved here
  *				when suspend.
+ * @ioh:		IOH ID
  * @spinlock:		Used for register access protection in
  *				interrupt context pch_irq_mask,
  *				pch_irq_unmask and pch_irq_type;
@@ -66,6 +77,7 @@ struct pch_gpio {
 	struct gpio_chip gpio;
 	struct pch_gpio_reg_data pch_gpio_reg;
 	struct mutex lock;
+	enum pch_type_t ioh;
 	spinlock_t spinlock;
 };
 
@@ -100,7 +112,7 @@ static int pch_gpio_direction_output(struct gpio_chip *gpio, unsigned nr,
 	u32 reg_val;
 
 	mutex_lock(&chip->lock);
-	pm = ioread32(&chip->reg->pm) & PCH_GPIO_ALL_PINS;
+	pm = ioread32(&chip->reg->pm) & ((1 << gpio_pins[chip->ioh]) - 1);
 	pm |= (1 << nr);
 	iowrite32(pm, &chip->reg->pm);
 
@@ -122,7 +134,7 @@ static int pch_gpio_direction_input(struct gpio_chip *gpio, unsigned nr)
 	u32 pm;
 
 	mutex_lock(&chip->lock);
-	pm = ioread32(&chip->reg->pm) & PCH_GPIO_ALL_PINS; /*bits 0-11*/
+	pm = ioread32(&chip->reg->pm) & ((1 << gpio_pins[chip->ioh]) - 1);
 	pm &= ~(1 << nr);
 	iowrite32(pm, &chip->reg->pm);
 	mutex_unlock(&chip->lock);
@@ -162,7 +174,7 @@ static void pch_gpio_setup(struct pch_gpio *chip)
 	gpio->set = pch_gpio_set;
 	gpio->dbg_show = NULL;
 	gpio->base = -1;
-	gpio->ngpio = GPIO_NUM_PINS;
+	gpio->ngpio = gpio_pins[chip->ioh];
 	gpio->can_sleep = 0;
 }
 
@@ -196,6 +208,13 @@ static int __devinit pch_gpio_probe(struct pci_dev *pdev,
 		goto err_iomap;
 	}
 
+	if (pdev->device == 0x8803)
+		chip->ioh = INTEL_EG20T_PCH;
+	else if (pdev->device == 0x8014)
+		chip->ioh = OKISEMI_ML7223m_IOH;
+	else if (pdev->device == 0x8043)
+		chip->ioh = OKISEMI_ML7223n_IOH;
+
 	chip->reg = chip->base;
 	pci_set_drvdata(pdev, chip);
 	mutex_init(&chip->lock);
-- 
1.7.4.4

