Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937Ab2BQGmd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 01:42:33 -0500
Received: from mail2.nsc.com ([12.238.8.132]:60142 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751805Ab2BQGmF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 01:42:05 -0500
X-WSS-ID: 0LZIYM0-0A-2HI-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Mark Brown" <broonie@opensource.wolfsonmicro.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 16 Feb 2012 22:41:45 -0800
Subject: [PATCH 2/3] regulator: add set_pulldown in regulator operations
Thread-Topic: [PATCH 2/3] regulator: add set_pulldown in regulator
 operations
Thread-Index: AcztPzci95MsGXKRTgSyE/WBC2TmDA==
Message-ID: <B567DBAB974C0544994013492B949F8E381301284E@EXMAIL03.scwf.nsc.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 632329211LS10440586-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some PMUs provide programmable active shutdown switches
that help discharge the load if the supply is off.
For providing this feature, set_pulldown() is added in the ops.

The set_pulldown() is not exported function.
This function is called internally when the regulator is disabled.
Then pull-down bits can be programmed in each regulator driver.

* patch base version : linux-3.2.4

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/regulator/core.c         |   18 ++++++++++++++++++
 include/linux/regulator/driver.h |    2 ++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 938398f..3053f4f 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1457,6 +1457,15 @@ static int _regulator_disable(struct regulator_dev *rdev)
 				return ret;
 			}
 
+			if (rdev->desc->ops->set_pulldown) {
+				ret = rdev->desc->ops->set_pulldown(rdev);
+				if (ret < 0) {
+					rdev_err(rdev,
+						"failed to set pulldown\n");
+					return ret;
+				}
+			}
+
 			trace_regulator_disable_complete(rdev_get_name(rdev));
 
 			_notifier_call_chain(rdev, REGULATOR_EVENT_DISABLE,
@@ -1518,6 +1527,15 @@ static int _regulator_force_disable(struct regulator_dev *rdev)
 			rdev_err(rdev, "failed to force disable\n");
 			return ret;
 		}
+
+		if (rdev->desc->ops->set_pulldown) {
+			ret = rdev->desc->ops->set_pulldown(rdev);
+			if (ret < 0) {
+				rdev_err(rdev, "failed to set pulldown\n");
+				return ret;
+			}
+		}
+
 		/* notify other consumers that power has been forced off */
 		_notifier_call_chain(rdev, REGULATOR_EVENT_FORCE_DISABLE |
 			REGULATOR_EVENT_DISABLE, NULL);
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index df6e9ec..081f91d 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -38,6 +38,7 @@ enum regulator_status {
  *
  * @enable: Configure the regulator as enabled.
  * @disable: Configure the regulator as disabled.
+ * @set_pulldown : Configure pulldown setting when the regulator is disabled.
  * @is_enabled: Return 1 if the regulator is enabled, 0 if not.
  *		May also return negative errno.
  *
@@ -102,6 +103,7 @@ struct regulator_ops {
 	/* enable/disable regulator */
 	int (*enable) (struct regulator_dev *);
 	int (*disable) (struct regulator_dev *);
+	int (*set_pulldown) (struct regulator_dev *);
 	int (*is_enabled) (struct regulator_dev *);
 
 	/* get/set regulator operating mode (defined in consumer.h) */
-- 
1.7.4.1


Best Regards,
Milo (Woogyom) Kim
Texas Instruments Incorporated




