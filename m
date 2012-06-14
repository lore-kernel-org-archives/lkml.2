Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab2FNWHL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 18:07:11 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:60439 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab2FNWHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 18:07:09 -0400
From: Philip Rakity <philipspatches@gmail.com>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: linux-mmc@vger.kernel.org, Philip Rakity <prakity@marvell.com>
Subject: [PATCH 1/2] regulator: core.c Pass voltage to notifier when setting voltage
Date: Thu, 14 Jun 2012 15:06:49 -0700
Message-Id: <1339711609-3417-1-git-send-email-prakity@marvell.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V2
--

Incorporate performance suggestions made by Mark Brown
Use linux-next as base code rather than mmc-next

The voltage being set should be passed to the handler requesting
the callback.  Currently this is not done.

The callback cannot call regulator_get_voltage() to get the
information since the mutex is held by the regulator and
deadlock occurs.

Without this change the receiver of the notify cannot now what
action to take.  This is used, for example, to set PAD voltages
when doing SD vccq voltage changes.

Signed-off-by: Philip Rakity <prakity@marvell.com>
---
 drivers/regulator/core.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 63507a5..5b04916 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2153,7 +2153,7 @@ static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 	if (rdev->desc->ops->list_voltage)
 		best_val = rdev->desc->ops->list_voltage(rdev, selector);
 	else
-		best_val = -1;
+		best_val = _regulator_get_voltage(rdev);
 
 	/* Call set_voltage_time_sel if successfully obtained old_selector */
 	if (_regulator_is_enabled(rdev) && ret == 0 && old_selector >= 0 &&
@@ -2176,9 +2176,9 @@ static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 		udelay(delay);
 	}
 
-	if (ret == 0)
+	if (ret == 0 && best_val >= 0)
 		_notifier_call_chain(rdev, REGULATOR_EVENT_VOLTAGE_CHANGE,
-				     NULL);
+				     (void *)best_val);
 
 	trace_regulator_set_voltage_complete(rdev_get_name(rdev), best_val);
 
-- 
1.7.0.4

