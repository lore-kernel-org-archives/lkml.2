Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774Ab2JKL4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 07:56:35 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60778 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758599Ab2JKLzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 07:55:43 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <peter.ujfalusi@ti.com>
Subject: [PATCH 3/6] MFD: twl6040: Restructure power up and down code
Date: Thu, 11 Oct 2012 13:55:30 +0200
Message-ID: <1349956533-6374-4-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1349956533-6374-1-git-send-email-peter.ujfalusi@ti.com>
References: <1349956533-6374-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rearrange the code path for power up and down sequence.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl6040-core.c | 38 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
index a46d987..6d9db27 100644
--- a/drivers/mfd/twl6040-core.c
+++ b/drivers/mfd/twl6040-core.c
@@ -104,7 +104,7 @@ int twl6040_clear_bits(struct twl6040 *twl6040, unsigned int reg, u8 mask)
 EXPORT_SYMBOL(twl6040_clear_bits);
 
 /* twl6040 codec manual power-up sequence */
-static int twl6040_power_up(struct twl6040 *twl6040)
+static int twl6040_power_up_manual(struct twl6040 *twl6040)
 {
 	u8 ldoctl, ncpctl, lppllctl;
 	int ret;
@@ -158,11 +158,12 @@ ncp_err:
 	ldoctl &= ~(TWL6040_HSLDOENA | TWL6040_REFENA | TWL6040_OSCENA);
 	twl6040_reg_write(twl6040, TWL6040_REG_LDOCTL, ldoctl);
 
+	dev_err(twl6040->dev, "manual power-up failed\n");
 	return ret;
 }
 
 /* twl6040 manual power-down sequence */
-static void twl6040_power_down(struct twl6040 *twl6040)
+static void twl6040_power_down_manual(struct twl6040 *twl6040)
 {
 	u8 ncpctl, ldoctl, lppllctl;
 
@@ -218,18 +219,22 @@ static irqreturn_t twl6040_naudint_handler(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static int twl6040_power_up_completion(struct twl6040 *twl6040)
+static int twl6040_power_up_automatic(struct twl6040 *twl6040)
 {
 	int time_left;
-	u8 intid;
+
+	gpio_set_value(twl6040->audpwron, 1);
 
 	time_left = wait_for_completion_timeout(&twl6040->ready,
 						msecs_to_jiffies(144));
 	if (!time_left) {
+		u8 intid;
+
+		dev_warn(twl6040->dev, "timeout waiting for READYINT\n");
 		intid = twl6040_reg_read(twl6040, TWL6040_REG_INTID);
 		if (!(intid & TWL6040_READYINT)) {
-			dev_err(twl6040->dev,
-				"timeout waiting for READYINT\n");
+			dev_err(twl6040->dev, "automatic power-up failed\n");
+			gpio_set_value(twl6040->audpwron, 0);
 			return -ETIMEDOUT;
 		}
 	}
@@ -239,7 +244,6 @@ static int twl6040_power_up_completion(struct twl6040 *twl6040)
 
 int twl6040_power(struct twl6040 *twl6040, int on)
 {
-	int audpwron = twl6040->audpwron;
 	int ret = 0;
 
 	mutex_lock(&twl6040->mutex);
@@ -249,23 +253,17 @@ int twl6040_power(struct twl6040 *twl6040, int on)
 		if (twl6040->power_count++)
 			goto out;
 
-		if (gpio_is_valid(audpwron)) {
-			/* use AUDPWRON line */
-			gpio_set_value(audpwron, 1);
-			/* wait for power-up completion */
-			ret = twl6040_power_up_completion(twl6040);
+		if (gpio_is_valid(twl6040->audpwron)) {
+			/* use automatic power-up sequence */
+			ret = twl6040_power_up_automatic(twl6040);
 			if (ret) {
-				dev_err(twl6040->dev,
-					"automatic power-up failed\n");
 				twl6040->power_count = 0;
 				goto out;
 			}
 		} else {
 			/* use manual power-up sequence */
-			ret = twl6040_power_up(twl6040);
+			ret = twl6040_power_up_manual(twl6040);
 			if (ret) {
-				dev_err(twl6040->dev,
-					"manual power-up failed\n");
 				twl6040->power_count = 0;
 				goto out;
 			}
@@ -286,15 +284,15 @@ int twl6040_power(struct twl6040 *twl6040, int on)
 		if (--twl6040->power_count)
 			goto out;
 
-		if (gpio_is_valid(audpwron)) {
+		if (gpio_is_valid(twl6040->audpwron)) {
 			/* use AUDPWRON line */
-			gpio_set_value(audpwron, 0);
+			gpio_set_value(twl6040->audpwron, 0);
 
 			/* power-down sequence latency */
 			usleep_range(500, 700);
 		} else {
 			/* use manual power-down sequence */
-			twl6040_power_down(twl6040);
+			twl6040_power_down_manual(twl6040);
 		}
 		twl6040->sysclk = 0;
 		twl6040->mclk = 0;
-- 
1.7.12

