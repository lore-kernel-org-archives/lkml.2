Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932492Ab0LTOdM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 09:33:12 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55542 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753843Ab0LTOdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 09:33:09 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ben Dooks <ben-linux@fluff.org>, Jean Delvare <khali@linux-fr.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Alan Stern <stern@rowland.harvard.edu>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org,
        patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] i2c: Factor out runtime suspend checks from PM operations
Date: Mon, 20 Dec 2010 14:33:13 +0000
Message-Id: <1292855593-30608-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1292855593-30608-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1292855593-30608-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When devices use dev_pm_ops the I2C API is implementing standard functionality
for integration with runtime PM and for checking for the presence of a per
device op. The PM core provides pm_generic_ functions implementing this
behaviour - use them to reduce coupling with future PM updates.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/i2c/i2c-core.c |   57 ++++++++++++++++--------------------------------
 1 files changed, 19 insertions(+), 38 deletions(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 6b4cc56..4478557 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -196,69 +196,50 @@ static int i2c_device_pm_suspend(struct device *dev)
 {
 	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 
-	if (pm) {
-		if (pm_runtime_suspended(dev))
-			return 0;
-		else
-			return pm->suspend ? pm->suspend(dev) : 0;
-	}
-
-	return i2c_legacy_suspend(dev, PMSG_SUSPEND);
+	if (pm)
+		return pm_generic_suspend(dev);
+	else
+		return i2c_legacy_suspend(dev, PMSG_SUSPEND);
 }
 
 static int i2c_device_pm_resume(struct device *dev)
 {
 	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
-	int ret;
 
 	if (pm)
-		ret = pm->resume ? pm->resume(dev) : 0;
+		return pm_generic_resume(dev);
 	else
-		ret = i2c_legacy_resume(dev);
-
-	return ret;
+		return i2c_legacy_resume(dev);
 }
 
 static int i2c_device_pm_freeze(struct device *dev)
 {
 	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 
-	if (pm) {
-		if (pm_runtime_suspended(dev))
-			return 0;
-		else
-			return pm->freeze ? pm->freeze(dev) : 0;
-	}
-
-	return i2c_legacy_suspend(dev, PMSG_FREEZE);
+	if (pm)
+		return pm_generic_freeze(dev);
+	else
+		return i2c_legacy_suspend(dev, PMSG_FREEZE);
 }
 
 static int i2c_device_pm_thaw(struct device *dev)
 {
 	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 
-	if (pm) {
-		if (pm_runtime_suspended(dev))
-			return 0;
-		else
-			return pm->thaw ? pm->thaw(dev) : 0;
-	}
-
-	return i2c_legacy_resume(dev);
+	if (pm)
+		return pm_generic_thaw(dev);
+	else
+		return i2c_legacy_resume(dev);
 }
 
 static int i2c_device_pm_poweroff(struct device *dev)
 {
 	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 
-	if (pm) {
-		if (pm_runtime_suspended(dev))
-			return 0;
-		else
-			return pm->poweroff ? pm->poweroff(dev) : 0;
-	}
-
-	return i2c_legacy_suspend(dev, PMSG_HIBERNATE);
+	if (pm)
+		return pm_generic_poweroff(dev);
+	else
+		return i2c_legacy_suspend(dev, PMSG_HIBERNATE);
 }
 
 static int i2c_device_pm_restore(struct device *dev)
@@ -267,7 +248,7 @@ static int i2c_device_pm_restore(struct device *dev)
 	int ret;
 
 	if (pm)
-		ret = pm->restore ? pm->restore(dev) : 0;
+		ret = pm_generic_restore(dev);
 	else
 		ret = i2c_legacy_resume(dev);
 
-- 
1.7.2.3

