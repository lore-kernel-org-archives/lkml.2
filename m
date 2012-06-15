Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab2FOS1m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 14:27:42 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:34218 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757030Ab2FOS1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 14:27:41 -0400
From: Philip Rakity <philipspatches@gmail.com>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: linux-mmc@vger.kernel.org, Philip Rakity <prakity@marvell.com>
Subject: [PATCH 1/2] regulator: core.c Pass voltage to notifier when setting voltage
Date: Fri, 15 Jun 2012 11:27:36 -0700
Message-Id: <1339784856-1779-1-git-send-email-prakity@marvell.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V3
--

Fix type where data argument was not passed in
blocking_notifier_call_chain.

edits to check in comments (below)

V2
--

Incorporate performance suggestions made by Mark Brown
Use linux-next as base code rather than mmc-next

The voltage being set should be passed to the call in handler
requesting the callback.  Currently this is not done.

The callin handler cannot call regulator_get_voltage() to get the
information since the mutex is held by the regulator and
deadlock occurs.

Without this change the receiver of the call in cannot know what
action to take.  This is used, for example, to set PAD voltages
when doing SD vccq voltage changes.

Signed-off-by: Philip Rakity <prakity@marvell.com>
---
 drivers/regulator/core.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 63507a5..cdf6905 100644
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
 
@@ -2692,7 +2692,7 @@ static void _notifier_call_chain(struct regulator_dev *rdev,
 				  unsigned long event, void *data)
 {
 	/* call rdev chain first */
-	blocking_notifier_call_chain(&rdev->notifier, event, NULL);
+	blocking_notifier_call_chain(&rdev->notifier, event, data);
 }
 
 /**
-- 
1.7.0.4

