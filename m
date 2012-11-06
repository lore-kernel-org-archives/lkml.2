Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628Ab2KFKgd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 05:36:33 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18718 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab2KFKgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 05:36:32 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 06 Nov 2012 02:36:26 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: core: avoid memory access after freeing it
Date: Tue, 6 Nov 2012 16:04:09 +0530
Message-ID: <1352198049-5941-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When regulator_register() failed due to non availability of
supply then it exits through cleanup path. In this case it
checks for supply and if it is valid then unregister the supply.

The change done by Charles Keepax:
	regulator: core: Move regulator release to avoid deadlock

puts the release of supply regualtor after device_unregister().
The device_unregister() frees the rdev and hence accessing rdev
member pointer after this calls gives incorrect pointer and cause
the system to crash.

Adding the locked version of regulator_put() as __regulator_put_locked()
so that it can be called in locked context also to avoid the deadlock
to address the above issue.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |   30 ++++++++++++++++++------------
 1 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index b4a425a..59280b6 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1382,23 +1382,16 @@ struct regulator *regulator_get_exclusive(struct device *dev, const char *id)
 EXPORT_SYMBOL_GPL(regulator_get_exclusive);
 
 /**
- * regulator_put - "free" the regulator source
- * @regulator: regulator source
- *
- * Note: drivers must ensure that all regulator_enable calls made on this
- * regulator source are balanced by regulator_disable calls prior to calling
- * this function.
+ * Locked version of regulator_put
  */
-void regulator_put(struct regulator *regulator)
+static void __regulator_put_locked(struct regulator *regulator)
 {
 	struct regulator_dev *rdev;
 
 	if (regulator == NULL || IS_ERR(regulator))
 		return;
 
-	mutex_lock(&regulator_list_mutex);
 	rdev = regulator->rdev;
-
 	debugfs_remove_recursive(regulator->debugfs);
 
 	/* remove any sysfs entries */
@@ -1412,6 +1405,20 @@ void regulator_put(struct regulator *regulator)
 	rdev->exclusive = 0;
 
 	module_put(rdev->owner);
+}
+
+/**
+ * regulator_put - "free" the regulator source
+ * @regulator: regulator source
+ *
+ * Note: drivers must ensure that all regulator_enable calls made on this
+ * regulator source are balanced by regulator_disable calls prior to calling
+ * this function.
+ */
+void regulator_put(struct regulator *regulator)
+{
+	mutex_lock(&regulator_list_mutex);
+	__regulator_put_locked(regulator);
 	mutex_unlock(&regulator_list_mutex);
 }
 EXPORT_SYMBOL_GPL(regulator_put);
@@ -3453,11 +3460,10 @@ scrub:
 		gpio_free(rdev->ena_gpio);
 	kfree(rdev->constraints);
 wash:
+	if (rdev->supply)
+		__regulator_put_locked(rdev->supply);
 	device_unregister(&rdev->dev);
-
 	mutex_unlock(&regulator_list_mutex);
-	if (rdev->supply)
-		regulator_put(rdev->supply);
 
 	/* device core frees rdev */
 	rdev = ERR_PTR(ret);
-- 
1.7.1.1

