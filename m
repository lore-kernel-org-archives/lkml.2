Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379Ab2COME5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 08:04:57 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:46715 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932301Ab2COME4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 08:04:56 -0400
From: Simon Horman <horms@verge.net.au>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Simon Horman <horms@verge.net.au>
Subject: [PATCH] regulator: notify sysfs when voltage is set
Date: Thu, 15 Mar 2012 21:04:33 +0900
Message-Id: <1331813073-714-1-git-send-email-horms@verge.net.au>
X-Mailer: git-send-email 1.7.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows libudev to be used to monitor voltage changes and thus allows
user-space code to avoid polling the sysfs entry for changes.

Signed-off-by: Simon Horman <horms@verge.net.au>
---
 drivers/regulator/core.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index b97c4a2..f3905b0 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1783,6 +1783,19 @@ int regulator_is_supported_voltage(struct regulator *regulator,
 }
 EXPORT_SYMBOL_GPL(regulator_is_supported_voltage);
 
+static void regulator_generate_event(struct regulator_dev *rdev)
+{
+	char buf[32], *envp[2];
+
+	sprintf(buf, "MICROVOLTS=%d", _regulator_get_voltage(rdev));
+
+	envp[0] = buf;
+	envp[1] = NULL;
+
+	kobject_uevent_env(&rdev->dev.kobj, KOBJ_CHANGE, envp);
+	sysfs_notify(&rdev->dev.kobj, NULL, "microvolts");
+}
+
 static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 				     int min_uV, int max_uV)
 {
@@ -1862,6 +1875,8 @@ static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 		udelay(delay);
 	}
 
+	regulator_generate_event(rdev);
+
 	if (ret == 0)
 		_notifier_call_chain(rdev, REGULATOR_EVENT_VOLTAGE_CHANGE,
 				     NULL);
-- 
1.7.6.3

