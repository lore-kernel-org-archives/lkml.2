Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab1HSFjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 01:39:44 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:31778 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab1HSFjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 01:39:43 -0400
X-AuditID: cbfee61a-b7cf1ae00000208e-5d-4e4df71d5d02
Date: Fri, 19 Aug 2011 14:39:40 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v2 2/2-resubmit] MFD: MAX8997: Support Wake-up from Suspend
In-reply-to: <20110819005900.GA32368@sirena.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, kyungmin.park@samsung.com,
        myungjoo.ham@gmail.com
Message-id: <1313732380-24549-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
References: <20110819005900.GA32368@sirena.org.uk>
X-OriginalArrivalTime: 19 Aug 2011 05:40:24.0073 (UTC)
 FILETIME=[7DE97790:01CC5E32]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Support wake-up from suspend-to-ram.
- Handle pending interrupt after a resume.
- If pdata->wakeup is enabled, by default, the device is assumed to be
capable of wakeup (the interrupt pin is connected to a wakeup-source GPIO)
and may wakeup the system (MAX8997 has a power button input pin).

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Resubmitted to use wakeup interfaces as commented by Mark Brown.

---
 drivers/mfd/max8997.c               |   27 ++++++++++++++++++++++++++-
 include/linux/mfd/max8997-private.h |    1 -
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
index f83103b..dc58750 100644
--- a/drivers/mfd/max8997.c
+++ b/drivers/mfd/max8997.c
@@ -23,6 +23,7 @@
 
 #include <linux/slab.h>
 #include <linux/i2c.h>
+#include <linux/interrupt.h>
 #include <linux/pm_runtime.h>
 #include <linux/mutex.h>
 #include <linux/mfd/core.h>
@@ -142,7 +143,6 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
 
 	max8997->irq_base = pdata->irq_base;
 	max8997->ono = pdata->ono;
-	max8997->wakeup = pdata->wakeup;
 
 	mutex_init(&max8997->iolock);
 
@@ -169,6 +169,9 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
 	if (ret < 0)
 		goto err_mfd;
 
+	/* MAX8997 has a power button input. */
+	device_init_wakeup(max8997->dev, pdata->wakeup);
+
 	return ret;
 
 err_mfd:
@@ -398,7 +401,29 @@ static int max8997_restore(struct device *dev)
 	return 0;
 }
 
+static int max8997_suspend(struct device *dev)
+{
+	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
+	struct max8997_dev *max8997 = i2c_get_clientdata(i2c);
+
+	if (device_may_wakeup(dev))
+		irq_set_irq_wake(max8997->irq, 1);
+	return 0;
+}
+
+static int max8997_resume(struct device *dev)
+{
+	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
+	struct max8997_dev *max8997 = i2c_get_clientdata(i2c);
+
+	if (device_may_wakeup(dev))
+		irq_set_irq_wake(max8997->irq, 0);
+	return max8997_irq_resume(max8997);
+}
+
 const struct dev_pm_ops max8997_pm = {
+	.suspend = max8997_suspend,
+	.resume = max8997_resume,
 	.freeze = max8997_freeze,
 	.restore = max8997_restore,
 };
diff --git a/include/linux/mfd/max8997-private.h b/include/linux/mfd/max8997-private.h
index 5ff2400..3f4deb6 100644
--- a/include/linux/mfd/max8997-private.h
+++ b/include/linux/mfd/max8997-private.h
@@ -326,7 +326,6 @@ struct max8997_dev {
 	int irq;
 	int ono;
 	int irq_base;
-	bool wakeup;
 	struct mutex irqlock;
 	int irq_masks_cur[MAX8997_IRQ_GROUP_NR];
 	int irq_masks_cache[MAX8997_IRQ_GROUP_NR];
-- 
1.7.4.1

