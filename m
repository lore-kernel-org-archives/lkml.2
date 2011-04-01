Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab1DAKEt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 06:04:49 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:40742 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754856Ab1DAKEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 06:04:48 -0400
From: Robert Rosengren <robert.rosengren@stericsson.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Robert Rosengren <robert.rosengren@stericsson.com>
Subject: [PATCH] regulator: recursive locking detected
Date: Fri, 1 Apr 2011 12:04:17 +0200
Message-ID: <1301652257-19347-1-git-send-email-robert.rosengren@stericsson.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"possible recursive locking detected"-warnings are issued when a
regulator has specified supply regulator. Both when enabling and
disabling regulators uses recursive call chains for notify the supply
regulators. This is due to locking mutexes of the same lock class,
i.e. the locks reside in the regulator_dev struct.

Since this is valid behavior for the regulators, this patch changes the
mutex lock into nested, as suggested in lockdep-design.txt.

Signed-off-by: Robert Rosengren <robert.rosengren@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/regulator/core.c |   35 ++++++++++++++++++++++-------------
 1 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 3ffc697..e9536ff 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -87,7 +87,7 @@ static int _regulator_get_voltage(struct regulator_dev *rdev);
 static int _regulator_get_current_limit(struct regulator_dev *rdev);
 static unsigned int _regulator_get_mode(struct regulator_dev *rdev);
 static void _notifier_call_chain(struct regulator_dev *rdev,
-				  unsigned long event, void *data);
+				  unsigned long event, void *data, int lock_sublevel);
 static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 				     int min_uV, int max_uV);
 
@@ -1279,16 +1279,21 @@ static int _regulator_can_change_status(struct regulator_dev *rdev)
 		return 0;
 }
 
-/* locks held by regulator_enable() */
-static int _regulator_enable(struct regulator_dev *rdev)
+/* locks held by regulator_enable()
+ * lock_sublevel should always be 0, only used for recursive calls.
+ */
+static int _regulator_enable(struct regulator_dev *rdev,
+				int lock_sublevel)
 {
 	int ret, delay;
 
 	if (rdev->use_count == 0) {
 		/* do we need to enable the supply regulator first */
 		if (rdev->supply) {
-			mutex_lock(&rdev->supply->mutex);
-			ret = _regulator_enable(rdev->supply);
+			/* increase sublevel before stepping into nested regulators */
+			lock_sublevel++;
+			mutex_lock_nested(&rdev->supply->mutex, lock_sublevel);
+			ret = _regulator_enable(rdev->supply, lock_sublevel);
 			mutex_unlock(&rdev->supply->mutex);
 			if (ret < 0) {
 				rdev_err(rdev, "failed to enable: %d\n", ret);
@@ -1372,7 +1377,7 @@ int regulator_enable(struct regulator *regulator)
 	int ret = 0;
 
 	mutex_lock(&rdev->mutex);
-	ret = _regulator_enable(rdev);
+	ret = _regulator_enable(rdev, 0);
 	mutex_unlock(&rdev->mutex);
 	return ret;
 }
@@ -1407,7 +1412,7 @@ static int _regulator_disable(struct regulator_dev *rdev,
 			trace_regulator_disable_complete(rdev_get_name(rdev));
 
 			_notifier_call_chain(rdev, REGULATOR_EVENT_DISABLE,
-					     NULL);
+					     NULL, 0);
 		}
 
 		/* decrease our supplies ref count and disable if required */
@@ -1477,7 +1482,7 @@ static int _regulator_force_disable(struct regulator_dev *rdev,
 		}
 		/* notify other consumers that power has been forced off */
 		_notifier_call_chain(rdev, REGULATOR_EVENT_FORCE_DISABLE |
-			REGULATOR_EVENT_DISABLE, NULL);
+			REGULATOR_EVENT_DISABLE, NULL, 0);
 	}
 
 	/* decrease our supplies ref count and disable if required */
@@ -1699,7 +1704,7 @@ static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 
 	if (ret == 0)
 		_notifier_call_chain(rdev, REGULATOR_EVENT_VOLTAGE_CHANGE,
-				     NULL);
+				     NULL, 0);
 
 	trace_regulator_set_voltage_complete(rdev_get_name(rdev), selector);
 
@@ -2167,19 +2172,23 @@ EXPORT_SYMBOL_GPL(regulator_unregister_notifier);
 
 /* notify regulator consumers and downstream regulator consumers.
  * Note mutex must be held by caller.
+ * lock_sublevel should always be 0, only used for recursive calls.
  */
 static void _notifier_call_chain(struct regulator_dev *rdev,
-				  unsigned long event, void *data)
+				  unsigned long event, void *data, int lock_sublevel)
 {
 	struct regulator_dev *_rdev;
 
 	/* call rdev chain first */
 	blocking_notifier_call_chain(&rdev->notifier, event, NULL);
 
+	/* increase sublevel before stepping into nested regulators */
+	lock_sublevel++;
+
 	/* now notify regulator we supply */
 	list_for_each_entry(_rdev, &rdev->supply_list, slist) {
-		mutex_lock(&_rdev->mutex);
-		_notifier_call_chain(_rdev, event, data);
+		mutex_lock_nested(&_rdev->mutex, lock_sublevel);
+		_notifier_call_chain(_rdev, event, data, lock_sublevel);
 		mutex_unlock(&_rdev->mutex);
 	}
 }
@@ -2333,7 +2342,7 @@ EXPORT_SYMBOL_GPL(regulator_bulk_free);
 int regulator_notifier_call_chain(struct regulator_dev *rdev,
 				  unsigned long event, void *data)
 {
-	_notifier_call_chain(rdev, event, data);
+	_notifier_call_chain(rdev, event, data, 0);
 	return NOTIFY_DONE;
 
 }
-- 
1.7.4.1

