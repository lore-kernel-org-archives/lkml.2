Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225Ab1GDKGj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 06:06:39 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44226 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757147Ab1GDKGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 06:06:12 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Misael Lopez Cruz <misael.lopez@ti.com>
Subject: [PATCH 5/6] MFD: twl6040: Remove enum for PLL tracking
Date: Mon, 4 Jul 2011 13:05:57 +0300
Message-ID: <1309773958-14608-6-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1309773958-14608-1-git-send-email-peter.ujfalusi@ti.com>
References: <1309773958-14608-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to have two different types for
tracking the selected PLL.
Use only the defines, when dealing with the PLLs.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl6040-core.c  |   26 +++++++++++++-------------
 include/linux/mfd/twl6040.h |   17 ++++++-----------
 2 files changed, 19 insertions(+), 24 deletions(-)

diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
index b6e5338..50152d7 100644
--- a/drivers/mfd/twl6040-core.c
+++ b/drivers/mfd/twl6040-core.c
@@ -270,7 +270,8 @@ int twl6040_power(struct twl6040 *twl6040, int on)
 				goto out;
 			}
 		}
-		twl6040->pll = TWL6040_LPPLL_ID;
+		/* Default PLL configuration after power up */
+		twl6040->pll = TWL6040_SYSCLK_SEL_LPPLL;
 		twl6040->sysclk = 19200000;
 	} else {
 		/* already powered-down */
@@ -294,7 +295,6 @@ int twl6040_power(struct twl6040 *twl6040, int on)
 			/* use manual power-down sequence */
 			twl6040_power_down(twl6040);
 		}
-		twl6040->pll = TWL6040_NOPLL_ID;
 		twl6040->sysclk = 0;
 	}
 
@@ -310,7 +310,7 @@ int twl6040_is_powered(struct twl6040 *twl6040)
 }
 EXPORT_SYMBOL(twl6040_is_powered);
 
-int twl6040_set_pll(struct twl6040 *twl6040, enum twl6040_pll_id id,
+int twl6040_set_pll(struct twl6040 *twl6040, int pll_id,
 		    unsigned int freq_in, unsigned int freq_out)
 {
 	u8 hppllctl, lppllctl;
@@ -321,8 +321,8 @@ int twl6040_set_pll(struct twl6040 *twl6040, enum twl6040_pll_id id,
 	hppllctl = twl6040_reg_read(twl6040, TWL6040_REG_HPPLLCTL);
 	lppllctl = twl6040_reg_read(twl6040, TWL6040_REG_LPPLLCTL);
 
-	switch (id) {
-	case TWL6040_LPPLL_ID:
+	switch (pll_id) {
+	case TWL6040_SYSCLK_SEL_LPPLL:
 		/* low-power PLL divider */
 		switch (freq_out) {
 		case 17640000:
@@ -358,10 +358,8 @@ int twl6040_set_pll(struct twl6040 *twl6040, enum twl6040_pll_id id,
 			ret = -EINVAL;
 			goto pll_out;
 		}
-
-		twl6040->pll = TWL6040_LPPLL_ID;
 		break;
-	case TWL6040_HPPLL_ID:
+	case TWL6040_SYSCLK_SEL_HPPLL:
 		/* high-performance PLL can provide only 19.2 MHz */
 		if (freq_out != 19200000) {
 			dev_err(&twl6040_dev->dev,
@@ -412,16 +410,15 @@ int twl6040_set_pll(struct twl6040 *twl6040, enum twl6040_pll_id id,
 		twl6040_reg_write(twl6040, TWL6040_REG_LPPLLCTL, lppllctl);
 		lppllctl &= ~TWL6040_LPLLENA;
 		twl6040_reg_write(twl6040, TWL6040_REG_LPPLLCTL, lppllctl);
-
-		twl6040->pll = TWL6040_HPPLL_ID;
 		break;
 	default:
-		dev_err(&twl6040_dev->dev, "unknown pll id %d\n", id);
+		dev_err(&twl6040_dev->dev, "unknown pll id %d\n", pll_id);
 		ret = -EINVAL;
 		goto pll_out;
 	}
 
 	twl6040->sysclk = freq_out;
+	twl6040->pll = pll_id;
 
 pll_out:
 	mutex_unlock(&twl6040->mutex);
@@ -429,9 +426,12 @@ pll_out:
 }
 EXPORT_SYMBOL(twl6040_set_pll);
 
-enum twl6040_pll_id twl6040_get_pll(struct twl6040 *twl6040)
+int twl6040_get_pll(struct twl6040 *twl6040)
 {
-	return twl6040->pll;
+	if (twl6040->power_count)
+		return twl6040->pll;
+	else
+		return -ENODEV;
 }
 EXPORT_SYMBOL(twl6040_get_pll);
 
diff --git a/include/linux/mfd/twl6040.h b/include/linux/mfd/twl6040.h
index d384a01..2008f2e 100644
--- a/include/linux/mfd/twl6040.h
+++ b/include/linux/mfd/twl6040.h
@@ -165,9 +165,6 @@
 #define TWL6040_RESETSPLIT		0x04
 #define TWL6040_INTCLRMODE		0x08
 
-#define TWL6040_SYSCLK_SEL_LPPLL	1
-#define TWL6040_SYSCLK_SEL_HPPLL	2
-
 /* STATUS (0x2E) fields */
 
 #define TWL6040_PLUGCOMP		0x02
@@ -188,11 +185,9 @@
 #define TWL6040_IRQ_VIB			4
 #define TWL6040_IRQ_READY		5
 
-enum twl6040_pll_id {
-	TWL6040_NOPLL_ID,
-	TWL6040_LPPLL_ID,
-	TWL6040_HPPLL_ID,
-};
+/* PLL selection */
+#define TWL6040_SYSCLK_SEL_LPPLL	0
+#define TWL6040_SYSCLK_SEL_HPPLL	1
 
 struct twl6040 {
 	struct device *dev;
@@ -206,7 +201,7 @@ struct twl6040 {
 	int power_count;
 	int rev;
 
-	enum twl6040_pll_id pll;
+	int pll;
 	unsigned int sysclk;
 
 	unsigned int irq;
@@ -251,9 +246,9 @@ int twl6040_clear_bits(struct twl6040 *twl6040, unsigned int reg,
 		       u8 mask);
 int twl6040_power(struct twl6040 *twl6040, int on);
 int twl6040_is_powered(struct twl6040 *twl6040);
-int twl6040_set_pll(struct twl6040 *twl6040, enum twl6040_pll_id id,
+int twl6040_set_pll(struct twl6040 *twl6040, int pll_id,
 		    unsigned int freq_in, unsigned int freq_out);
-enum twl6040_pll_id twl6040_get_pll(struct twl6040 *twl6040);
+int twl6040_get_pll(struct twl6040 *twl6040);
 unsigned int twl6040_get_sysclk(struct twl6040 *twl6040);
 int twl6040_irq_init(struct twl6040 *twl6040);
 void twl6040_irq_exit(struct twl6040 *twl6040);
-- 
1.7.6

