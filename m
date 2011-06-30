Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217Ab1F3BcG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 21:32:06 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:40845 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758061Ab1F3Bbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 21:31:50 -0400
X-AuditID: cbfee61a-b7c53ae000002dc1-c0-4e0bd2037d66
Date: Thu, 30 Jun 2011 10:31:46 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH 2/3] MFD: MAX8997: Support Wake-up from Suspend
In-reply-to: <1309397507-24959-1-git-send-email-myungjoo.ham@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Donggeun Kim <dg77.kim@samsung.com>, myungjoo.ham@gmail.com
Message-id: <1309397507-24959-2-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
References: <1309397507-24959-1-git-send-email-myungjoo.ham@samsung.com>
X-OriginalArrivalTime: 30 Jun 2011 01:32:02.0191 (UTC)
 FILETIME=[830B39F0:01CC36C5]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Support wake-up from suspend-to-ram.
- Handle pending interrupt after a resume.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/mfd/max8997.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
index f83103b..4ae42c6 100644
--- a/drivers/mfd/max8997.c
+++ b/drivers/mfd/max8997.c
@@ -23,6 +23,7 @@
 
 #include <linux/slab.h>
 #include <linux/i2c.h>
+#include <linux/interrupt.h>
 #include <linux/pm_runtime.h>
 #include <linux/mutex.h>
 #include <linux/mfd/core.h>
@@ -398,7 +399,29 @@ static int max8997_restore(struct device *dev)
 	return 0;
 }
 
+static int max8997_suspend(struct device *dev)
+{
+	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
+	struct max8997_dev *max8997 = i2c_get_clientdata(i2c);
+
+	if (max8997->wakeup && max8997->irq)
+		irq_set_irq_wake(max8997->irq, 1);
+	return 0;
+}
+
+static int max8997_resume(struct device *dev)
+{
+	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
+	struct max8997_dev *max8997 = i2c_get_clientdata(i2c);
+
+	if (max8997->wakeup && max8997->irq)
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
-- 
1.7.4.1

