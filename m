Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636Ab1JCVqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 17:46:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33510 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751189Ab1JCVqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 17:46:46 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Fix return code from regulator_disable_deferred()
Date: Mon,  3 Oct 2011 22:46:41 +0100
Message-Id: <1317678401-30772-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

schedule_delayed_work() returns a bool indicating if the work was already
queued when it succeeds so we need to squash a true down to zero.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

I'll queue this up along with the addition of the call in ASoC - please
say if this is a problem.

 drivers/regulator/core.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index b39ec9f..0c6d301 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1600,13 +1600,18 @@ static void regulator_disable_work(struct work_struct *work)
 int regulator_disable_deferred(struct regulator *regulator, int ms)
 {
 	struct regulator_dev *rdev = regulator->rdev;
+	int ret;
 
 	mutex_lock(&rdev->mutex);
 	rdev->deferred_disables++;
 	mutex_unlock(&rdev->mutex);
 
-	return schedule_delayed_work(&rdev->disable_work,
-				     msecs_to_jiffies(ms));
+	ret = schedule_delayed_work(&rdev->disable_work,
+				    msecs_to_jiffies(ms));
+	if (ret < 0)
+		return ret;
+	else
+		return 0;
 }
 EXPORT_SYMBOL_GPL(regulator_disable_deferred);
 
-- 
1.7.6.3

