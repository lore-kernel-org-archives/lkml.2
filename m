Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609Ab2C1Ugz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 16:36:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59983 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755431Ab2C1Ugy (ORCPT
	<rfc822;linux-kernel@Vger.kernel.org>);
	Wed, 28 Mar 2012 16:36:54 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: core: Complain if we can't reenable a supply
Date: Wed, 28 Mar 2012 21:36:52 +0100
Message-Id: <1332967012-18354-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When cleaning up after a failed bulk_disable() we try to reenable any
supplies that we did manage to disable - complain if we fail to do that
when we try.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 957f1d1..e265632 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2566,7 +2566,7 @@ int regulator_bulk_disable(int num_consumers,
 			   struct regulator_bulk_data *consumers)
 {
 	int i;
-	int ret;
+	int ret, r;
 
 	for (i = num_consumers - 1; i >= 0; --i) {
 		ret = regulator_disable(consumers[i].consumer);
@@ -2578,8 +2578,12 @@ int regulator_bulk_disable(int num_consumers,
 
 err:
 	pr_err("Failed to disable %s: %d\n", consumers[i].supply, ret);
-	for (++i; i < num_consumers; ++i)
-		(void)regulator_enable(consumers[i].consumer);
+	for (++i; i < num_consumers; ++i) {
+		r = regulator_enable(consumers[i].consumer);
+		if (r != 0)
+			pr_err("Failed to reename %s: %d\n",
+			       consumers[i].supply, r);
+	}
 
 	return ret;
 }
-- 
1.7.9.1

