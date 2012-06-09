Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab2FITjX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 15:39:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47678 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab2FITjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 15:39:22 -0400
From: Philip Rakity <philipspatches@gmail.com>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: linux-mmc@vger.kernel.org, Philip Rakity <prakity@marvell.com>
Subject: [PATCH] regulator: pass voltage when calling notifier for change
Date: Sat,  9 Jun 2012 12:39:15 -0700
Message-Id: <1339270755-2503-1-git-send-email-prakity@marvell.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The notified call back does pass the voltage that has
changed when calling the notifier callback.  This makes
it impossible to know what to do.  Pass the data
parameter (voltage) to the notifier.

A call to regulator_get_voltage cannot be made by the
receiver of the notifier since the mutex is held by
the regulator code and the call is blocked.  Deadlock
occurs.

This code was tested on a slightly earlier version of
linux where it was used to adjust the chip pad voltage
when doing SD vccq signaling for SDXC cards.

Signed-off-by: Philip Rakity <prakity@marvell.com>
---
 drivers/regulator/core.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index e70dd38..f3d66d6 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1916,11 +1916,16 @@ static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 		udelay(delay);
 	}
 
-	if (ret == 0)
-		_notifier_call_chain(rdev, REGULATOR_EVENT_VOLTAGE_CHANGE,
-				     NULL);
+	if (ret == 0) {
+		int voltage;
 
-	trace_regulator_set_voltage_complete(rdev_get_name(rdev), selector);
+		voltage = _regulator_get_voltage(rdev);
+		if (voltage >= 0)
+			_notifier_call_chain(rdev,
+					REGULATOR_EVENT_VOLTAGE_CHANGE,
+					(void *)voltage);
+	}
+	trace_regulator_set_voltage_complete(rdev_get_name(rdev), ret);
 
 	return ret;
 }
@@ -2405,7 +2410,7 @@ static void _notifier_call_chain(struct regulator_dev *rdev,
 				  unsigned long event, void *data)
 {
 	/* call rdev chain first */
-	blocking_notifier_call_chain(&rdev->notifier, event, NULL);
+	blocking_notifier_call_chain(&rdev->notifier, event, data);
 }
 
 /**
-- 
1.7.0.4

