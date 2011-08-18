Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab1HRHhu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 03:37:50 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:13690 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190Ab1HRHhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 03:37:43 -0400
X-AuditID: cbfee61a-b7cf1ae00000208e-87-4e4cc1444ed1
Date: Thu, 18 Aug 2011 16:37:36 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v2 2/2] MFD: MAX8997: Support Wake-up from Suspend
In-reply-to: <1313653056-27263-1-git-send-email-myungjoo.ham@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, kyungmin.park@samsung.com,
        myungjoo.ham@gmail.com
Message-id: <1313653056-27263-3-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
References: <1313653056-27263-1-git-send-email-myungjoo.ham@samsung.com>
X-OriginalArrivalTime: 18 Aug 2011 07:38:23.0577 (UTC)
 FILETIME=[CF364C90:01CC5D79]
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

