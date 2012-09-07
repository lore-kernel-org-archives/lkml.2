Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843Ab2IGDBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 23:01:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42162 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757845Ab2IGDBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 23:01:34 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: core: Fast path non-deferred disables
Date: Fri,  7 Sep 2012 11:01:20 +0800
Message-Id: <1346986880-28846-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Users (especially framework code) may end up passing in a zero deferral
time depending on runtime conditions or configuration. If they do then
just call regulator_disable() directly to save scheduling.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index e6bb1f9..3ddc837 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1749,6 +1749,9 @@ int regulator_disable_deferred(struct regulator *regulator, int ms)
 	if (regulator->always_on)
 		return 0;
 
+	if (!ms)
+		return regulator_disable(regulator);
+
 	mutex_lock(&rdev->mutex);
 	rdev->deferred_disables++;
 	mutex_unlock(&rdev->mutex);
-- 
1.7.10.4

