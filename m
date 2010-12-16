Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab0LPN7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 08:59:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38383 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756068Ab0LPN7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 08:59:33 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Saravana Kannan <skannan@codeaurora.org>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Only notify voltage changes when they succeed
Date: Thu, 16 Dec 2010 13:59:10 +0000
Message-Id: <1292507950-8288-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we notify a voltage change whenever we exit set_voltage(),
even if the change failed for some reason (eg, a constraints issue).
This shouldn't cause any substantial ill effects but is wasteful as
listeners get notified on noops. Fix this by moving the notification
into _do_set_voltage() and only notifying if we don't return an error.

Reported-by: Saravana Kannan <skannan@codeaurora.org>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index a0579f0..3d72cc8 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1667,6 +1667,10 @@ static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 		ret = -EINVAL;
 	}
 
+	if (ret == 0)
+		_notifier_call_chain(rdev, REGULATOR_EVENT_VOLTAGE_CHANGE,
+				     NULL);
+
 	trace_regulator_set_voltage_complete(rdev_get_name(rdev), selector);
 
 	return ret;
@@ -1718,7 +1722,6 @@ int regulator_set_voltage(struct regulator *regulator, int min_uV, int max_uV)
 	ret = _regulator_do_set_voltage(rdev, min_uV, max_uV);
 
 out:
-	_notifier_call_chain(rdev, REGULATOR_EVENT_VOLTAGE_CHANGE, NULL);
 	mutex_unlock(&rdev->mutex);
 	return ret;
 }
-- 
1.7.1

