Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932851Ab2KNJjg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 04:39:36 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53401 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932776Ab2KNJjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 04:39:33 -0500
Date: Wed, 14 Nov 2012 09:39:31 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: lrg@ti.com, ldewangan@nvidia.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] regulator: core: Avoid deadlock when
	regulator_register fails
Message-ID: <20121114093931.GA23525@opensource.wolfsonmicro.com>
References: <1352198049-5941-1-git-send-email-ldewangan@nvidia.com> <20121106111256.GA2512@opensource.wolfsonmicro.com> <20121106113138.GB10080@opensource.wolfsonmicro.com> <20121113163040.GA19089@opensource.wolfsonmicro.com> <20121113232537.GA27212@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121113232537.GA27212@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When regulator_register fails and exits through the scrub path the
regulator_put function was called whilst holding the
regulator_list_mutex, causing deadlock.

This patch adds a private version of the regulator_put function which
can be safely called whilst holding the mutex, replacing the
aforementioned call.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/core.c |   28 +++++++++++++++++-----------
 1 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 1a35251..390e173 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1381,22 +1381,14 @@ struct regulator *regulator_get_exclusive(struct device *dev, const char *id)
 }
 EXPORT_SYMBOL_GPL(regulator_get_exclusive);
 
-/**
- * regulator_put - "free" the regulator source
- * @regulator: regulator source
- *
- * Note: drivers must ensure that all regulator_enable calls made on this
- * regulator source are balanced by regulator_disable calls prior to calling
- * this function.
- */
-void regulator_put(struct regulator *regulator)
+/* Locks held by regulator_put() */
+static void _regulator_put(struct regulator *regulator)
 {
 	struct regulator_dev *rdev;
 
 	if (regulator == NULL || IS_ERR(regulator))
 		return;
 
-	mutex_lock(&regulator_list_mutex);
 	rdev = regulator->rdev;
 
 	debugfs_remove_recursive(regulator->debugfs);
@@ -1412,6 +1404,20 @@ void regulator_put(struct regulator *regulator)
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
+	_regulator_put(regulator);
 	mutex_unlock(&regulator_list_mutex);
 }
 EXPORT_SYMBOL_GPL(regulator_put);
@@ -3450,7 +3456,7 @@ unset_supplies:
 
 scrub:
 	if (rdev->supply)
-		regulator_put(rdev->supply);
+		_regulator_put(rdev->supply);
 	if (rdev->ena_gpio)
 		gpio_free(rdev->ena_gpio);
 	kfree(rdev->constraints);
-- 
1.7.2.5

