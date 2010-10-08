Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386Ab0JHTsb (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 8 Oct 2010 15:48:31 -0400
Received: from mail153.messagelabs.com ([216.82.253.51]:62394 "EHLO
	mail153.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab0JHTs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 15:48:29 -0400
X-VirusChecked: Checked
X-Env-Sender: jcarlyle@motorola.com
X-Msg-Ref: server-10.tower-153.messagelabs.com!1286567308!24349197!1
X-StarScan-Version: 6.2.4; banners=-,-,-
X-Originating-IP: [129.188.136.8]
From: y@motorola.com
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Lun Chang <L.chang@motorola.com>, <linux-kernel@vger.kernel.org>,
        Jeffrey Carlyle <jeff.carlyle@motorola.com>
Subject: [PATCH v2] regulator: avoid deadlock when disabling regulator with supply
Date: Fri,  8 Oct 2010 14:48:22 -0500
Message-Id: <1286567302-11298-1-git-send-email-y>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20101008185739.GA6098@opensource.wolfsonmicro.com>
References: <20101008185739.GA6098@opensource.wolfsonmicro.com>
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeffrey Carlyle <jeff.carlyle@motorola.com>

I have a regulator A that sets regulator B as its supply. When I call
set_supply to add B as the supply for A, regulator A gets added to the
supply_list for regulator B.

When I call regulator_disable(A), I end up with a call chain like this:

regulator_disable(A)
> mutex_lock(A)
> _regulator_disable(A)
>> _regulator_disable(B)
>>> _notifier_call_chain(B)
>>>> mutex_lock(A)

Which results in dead lock since we are trying to acquire the mutex lock
for regulator A which we already hold.

This patch addresses this issue by moving the call to disable regulator
B outside of the lock aquired inside the initial call to
regulator_disable.

This change also addresses the issue of not acquiring the mutex for
regulator B before calling _regulator_disable(B).

Signed-off-by: Jeffrey Carlyle <jeff.carlyle@motorola.com>
---
 drivers/regulator/core.c |   35 ++++++++++++++++++++++++++---------
 1 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index cc8b337..2d215b5 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -63,7 +63,8 @@ struct regulator {
 };
 
 static int _regulator_is_enabled(struct regulator_dev *rdev);
-static int _regulator_disable(struct regulator_dev *rdev);
+static int _regulator_disable(struct regulator_dev *rdev,
+		struct regulator_dev **supply_rdev_ptr);
 static int _regulator_get_voltage(struct regulator_dev *rdev);
 static int _regulator_get_current_limit(struct regulator_dev *rdev);
 static unsigned int _regulator_get_mode(struct regulator_dev *rdev);
@@ -1348,7 +1349,8 @@ int regulator_enable(struct regulator *regulator)
 EXPORT_SYMBOL_GPL(regulator_enable);
 
 /* locks held by regulator_disable() */
-static int _regulator_disable(struct regulator_dev *rdev)
+static int _regulator_disable(struct regulator_dev *rdev,
+		struct regulator_dev **supply_rdev_ptr)
 {
 	int ret = 0;
 
@@ -1376,8 +1378,7 @@ static int _regulator_disable(struct regulator_dev *rdev)
 		}
 
 		/* decrease our supplies ref count and disable if required */
-		if (rdev->supply)
-			_regulator_disable(rdev->supply);
+		*supply_rdev_ptr = rdev->supply;
 
 		rdev->use_count = 0;
 	} else if (rdev->use_count > 1) {
@@ -1407,17 +1408,29 @@ static int _regulator_disable(struct regulator_dev *rdev)
 int regulator_disable(struct regulator *regulator)
 {
 	struct regulator_dev *rdev = regulator->rdev;
+	struct regulator_dev *supply_rdev = NULL;
 	int ret = 0;
 
 	mutex_lock(&rdev->mutex);
-	ret = _regulator_disable(rdev);
+	ret = _regulator_disable(rdev, &supply_rdev);
 	mutex_unlock(&rdev->mutex);
+
+	/* decrease our supplies ref count and disable if required */
+	while (supply_rdev != NULL) {
+		rdev = supply_rdev;
+
+		mutex_lock(&rdev->mutex);
+		_regulator_disable(rdev, &supply_rdev);
+		mutex_unlock(&rdev->mutex);
+	}
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(regulator_disable);
 
 /* locks held by regulator_force_disable() */
-static int _regulator_force_disable(struct regulator_dev *rdev)
+static int _regulator_force_disable(struct regulator_dev *rdev,
+		struct regulator_dev **supply_rdev_ptr)
 {
 	int ret = 0;
 
@@ -1436,8 +1449,7 @@ static int _regulator_force_disable(struct regulator_dev *rdev)
 	}
 
 	/* decrease our supplies ref count and disable if required */
-	if (rdev->supply)
-		_regulator_disable(rdev->supply);
+	*supply_rdev_ptr = rdev->supply;
 
 	rdev->use_count = 0;
 	return ret;
@@ -1454,12 +1466,17 @@ static int _regulator_force_disable(struct regulator_dev *rdev)
  */
 int regulator_force_disable(struct regulator *regulator)
 {
+	struct regulator_dev *supply_rdev = NULL;
 	int ret;
 
 	mutex_lock(&regulator->rdev->mutex);
 	regulator->uA_load = 0;
-	ret = _regulator_force_disable(regulator->rdev);
+	ret = _regulator_force_disable(regulator->rdev, &supply_rdev);
 	mutex_unlock(&regulator->rdev->mutex);
+
+	if (supply_rdev)
+		regulator_disable(get_device_regulator(rdev_get_dev(supply_rdev)));
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(regulator_force_disable);
-- 
1.6.3.3

