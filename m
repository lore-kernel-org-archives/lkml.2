Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab0L1RRQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 12:17:16 -0500
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:42228 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754203Ab0L1RRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 12:17:02 -0500
From: Felipe Balbi <balbi@ti.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Cc: Tony Lindgren <tony@atomide.com>, David Brownell <david-b@pacbell.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [RFC/PATCH 3/3] mfd: twl4030-irq: implement bus_*lock
Date: Tue, 28 Dec 2010 19:14:19 +0200
Message-Id: <1293556459-28613-4-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.3.4.598.g85356
In-Reply-To: <1293556459-28613-1-git-send-email-balbi@ti.com>
References: <20101228161657.GF2239@legolas.emea.dhcp.ti.com>
 <1293556459-28613-1-git-send-email-balbi@ti.com>
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drop all the locking around mask/unmask and
implement bus_lock and bus_sync_unlock methods.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mfd/twl4030-irq.c |   30 ++++++++++++++++++------------
 1 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
index 298956d..ff7bb93 100644
--- a/drivers/mfd/twl4030-irq.c
+++ b/drivers/mfd/twl4030-irq.c
@@ -461,8 +461,6 @@ static void twl4030_sih_mask(unsigned irq)
 
 	agent->imr |= BIT(irq - agent->irq_base);
 
-	mutex_lock(&agent->irq_lock);
-
 	/* byte[0] gets overwritten as we write ... */
 	imr.word = cpu_to_le32(agent->imr << 8);
 
@@ -472,7 +470,6 @@ static void twl4030_sih_mask(unsigned irq)
 	if (status)
 		pr_err("twl4030: %s, %s --> %d\n", __func__,
 				"write", status);
-	mutex_unlock(&agent->irq_lock);
 }
 
 static void twl4030_sih_unmask(unsigned irq)
@@ -487,7 +484,6 @@ static void twl4030_sih_unmask(unsigned irq)
 
 	int			status;
 
-	mutex_lock(&agent->irq_lock);
 	agent->imr &= ~BIT(irq - agent->irq_base);
 
 	/* byte[0] gets overwritten as we write ... */
@@ -499,7 +495,6 @@ static void twl4030_sih_unmask(unsigned irq)
 	if (status)
 		pr_err("twl4030: %s, %s --> %d\n", __func__,
 				"write", status);
-	mutex_unlock(&agent->irq_lock);
 }
 
 static int twl4030_sih_set_type(unsigned irq, unsigned trigger)
@@ -517,7 +512,6 @@ static int twl4030_sih_set_type(unsigned irq, unsigned trigger)
 	if (trigger & ~(IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING))
 		return -EINVAL;
 
-	mutex_lock(&agent->irq_lock);
 	if ((desc->status & IRQ_TYPE_SENSE_MASK) != trigger) {
 		u8			bytes[6];
 		u32			edge_change;
@@ -537,7 +531,7 @@ static int twl4030_sih_set_type(unsigned irq, unsigned trigger)
 		if (status) {
 			pr_err("twl4030: %s, %s --> %d\n", __func__,
 					"read", status);
-			goto out;
+			return status;
 		}
 
 		/* Modify only the bits we know must change */
@@ -550,8 +544,7 @@ static int twl4030_sih_set_type(unsigned irq, unsigned trigger)
 			if (!d) {
 				pr_err("twl4030: Invalid IRQ: %d\n",
 						i + agent->irq_base);
-				status = -ENODEV;
-				goto out;
+				return -ENODEV;
 			}
 
 			bytes[byte] &= ~(0x03 << off);
@@ -574,17 +567,30 @@ static int twl4030_sih_set_type(unsigned irq, unsigned trigger)
 					"write", status);
 	}
 
-out:
-	mutex_unlock(&agent->irq_lock);
-
 	return status;
 }
 
+static void twl4030_sih_bus_lock(unsigned int irq)
+{
+	struct sih_agent	*agent = get_irq_chip_data(irq);
+
+	mutex_lock(&agent->irq_lock);
+}
+
+static void twl4030_sih_bus_sync_unlock(unsigned int irq)
+{
+	struct sih_agent	*agent = get_irq_chip_data(irq);
+
+	mutex_unlock(&agent->irq_lock);
+}
+
 static struct irq_chip twl4030_sih_irq_chip = {
 	.name		= "twl4030",
 	.mask		= twl4030_sih_mask,
 	.unmask		= twl4030_sih_unmask,
 	.set_type	= twl4030_sih_set_type,
+	.bus_lock	= twl4030_sih_bus_lock,
+	.bus_sync_unlock = twl4030_sih_bus_sync_unlock,
 };
 
 /*----------------------------------------------------------------------*/
-- 
1.7.3.4.598.g85356

