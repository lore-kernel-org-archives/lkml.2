Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab2KMQam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 11:30:42 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49030 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754564Ab2KMQal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 11:30:41 -0500
Date: Tue, 13 Nov 2012 16:30:40 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>, lrg@ti.com,
        ldewangan@nvidia.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] regulator: core: Add locked version of regulator_put to
	avoid deadlock
Message-ID: <20121113163040.GA19089@opensource.wolfsonmicro.com>
References: <1352198049-5941-1-git-send-email-ldewangan@nvidia.com> <20121106111256.GA2512@opensource.wolfsonmicro.com> <20121106113138.GB10080@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121106113138.GB10080@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When regulator_register fails and exits through the scrub path the
regulator_put function was called whilst holding the
regulator_list_mutex, which is also locked from regulator_put, causing
deadlock.

This patch adds a locked version of the regulator_put function which can
be safely called whilst holding the mutex, replacing the aforementioned
call.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>
---

I hope this isn't bad etiquette but I took the liberaty of fixing up
the patch as per the comments and taking into account the removal of
my original patch. Apologies if this is not the done thing, do let
me know if you would rather submit a version yourself but I
thought best to address the issue and get a fix in.

 drivers/regulator/core.c |   26 +++++++++++++++++---------
 1 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 5c4829c..854d18f 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1382,21 +1382,15 @@ struct regulator *regulator_get_exclusive(struct device *dev, const char *id)
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
 
 	debugfs_remove_recursive(regulator->debugfs);
@@ -1412,6 +1406,20 @@ void regulator_put(struct regulator *regulator)
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
@@ -3445,7 +3453,7 @@ unset_supplies:
 
 scrub:
 	if (rdev->supply)
-		regulator_put(rdev->supply);
+		__regulator_put_locked(rdev->supply);
 	if (rdev->ena_gpio)
 		gpio_free(rdev->ena_gpio);
 	kfree(rdev->constraints);
-- 
1.7.2.5

