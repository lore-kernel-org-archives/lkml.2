Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252Ab2ICOss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 10:48:48 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6765 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab2ICOsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 10:48:47 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 03 Sep 2012 07:48:42 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <lrg@ti.com>, <broonie@opensource.wolfsonmicro.com>,
        <rabin.vincent@gmail.com>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V3] regulator: disable supply regulator if it is enabled for boot-on
Date: Mon, 3 Sep 2012 19:55:39 +0530
Message-ID: <1346682339-13322-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If supply regulator is enabled because of boot-on (not always-on)
then disable regulator need to be call if regulator have some
user or full constraint has been enabled.
This will make sure that reference count of supply regulator
is in sync with child regulator's state.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Reported-by: Rabin Vincent <rabin.vincent@gmail.com>
---
Changes from V1:
Rabin reported that the nested locking trace is getting generated.
This is because the regulator lock mutex and disable himself and then
call for supply disable which again lock the regulator lock.
Probably because both lock is taken from regulator structure in nested
manner, the trace is getting generated.
Rewritten patch to avoid nested locking.

Changes from v2:
The patch 1 does not handle the case where a regulator is not set boot_on
but is considered on (for example, because of the lack of an is_enabled
callback), and is later actually enabled by a consumer before
regulator_init_complete().
So here I added the flag to track if the supply is enabled during registration.


 drivers/regulator/core.c         |   15 ++++++++++++++-
 include/linux/regulator/driver.h |    5 +++++
 2 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 06186ba..f166a4f 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3284,6 +3284,7 @@ regulator_register(const struct regulator_desc *regulator_desc,
 			ret = regulator_enable(rdev->supply);
 			if (ret < 0)
 				goto scrub;
+			rdev->need_supply_disable = 1;
 		}
 	}
 
@@ -3312,8 +3313,13 @@ unset_supplies:
 	unset_regulator_supplies(rdev);
 
 scrub:
-	if (rdev->supply)
+	if (rdev->supply) {
+		if (rdev->need_supply_disable) {
+			regulator_disable(rdev->supply);
+			rdev->need_supply_disable = 0;
+		}
 		regulator_put(rdev->supply);
+	}
 	if (rdev->ena_gpio)
 		gpio_free(rdev->ena_gpio);
 	kfree(rdev->constraints);
@@ -3606,6 +3612,8 @@ static int __init regulator_init_complete(void)
 	 * default behaviour in the future.
 	 */
 	list_for_each_entry(rdev, &regulator_list, list) {
+		bool supply_disable = true;
+
 		ops = rdev->desc->ops;
 		c = rdev->constraints;
 
@@ -3641,10 +3649,15 @@ static int __init regulator_init_complete(void)
 			 * anything here.
 			 */
 			rdev_warn(rdev, "incomplete constraints, leaving on\n");
+			supply_disable = false;
 		}
 
 unlock:
 		mutex_unlock(&rdev->mutex);
+		if (rdev->need_supply_disable && supply_disable) {
+			regulator_disable(rdev->supply);
+			rdev->need_supply_disable = 0;
+		}
 	}
 
 	mutex_unlock(&regulator_list_mutex);
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index c10012f..bf31771 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -279,6 +279,11 @@ struct regulator_dev {
 	int ena_gpio;
 	unsigned int ena_gpio_invert:1;
 	unsigned int ena_gpio_state:1;
+
+	/* If supply enabled during registrtaion then need to disable
+	 * when full constraint enabled.
+	 */
+	unsigned int need_supply_disable:1;
 };
 
 struct regulator_dev *
-- 
1.7.1.1

