Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758631Ab2C1UTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 16:19:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49905 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758510Ab2C1UTd (ORCPT
	<rfc822;linux-kernel@Vger.kernel.org>);
	Wed, 28 Mar 2012 16:19:33 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Fix deadlock on removal of regulators with supplies
Date: Wed, 28 Mar 2012 21:19:29 +0100
Message-Id: <1332965969-13906-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a regulator with a supply is being unregistered we will call
regulator_put() to release the supply with the regulator_list_mutex held
but this deadlocks as regulator_put() takes the same lock. Fix this by
releasing the supply before we take the mutex in regulator_unregister().

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 25d2b11..957f1d1 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2992,14 +2992,14 @@ void regulator_unregister(struct regulator_dev *rdev)
 	if (rdev == NULL)
 		return;
 
+	if (rdev->supply)
+		regulator_put(rdev->supply);
 	mutex_lock(&regulator_list_mutex);
 	debugfs_remove_recursive(rdev->debugfs);
 	flush_work_sync(&rdev->disable_work.work);
 	WARN_ON(rdev->open_count);
 	unset_regulator_supplies(rdev);
 	list_del(&rdev->list);
-	if (rdev->supply)
-		regulator_put(rdev->supply);
 	kfree(rdev->constraints);
 	device_unregister(&rdev->dev);
 	mutex_unlock(&regulator_list_mutex);
-- 
1.7.9.1

