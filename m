Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355Ab2ACGLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 01:11:40 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17648 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab2ACGLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 01:11:37 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 02 Jan 2012 22:11:36 -0800
From: Laxman Dewangan <ldewangan.com@nvidia.com>
To: broonie@opensource.wolfsonmicro.com, lrg@ti.com
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-tegra@vger.kernel.org, ldewangan@nvidia.com
Subject: [PATCH] regulator: Rail is said to be enable only if this and supply rails are enabled.
Date: Tue,  3 Jan 2012 11:39:43 +0530
Message-Id: <1325570983-3700-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laxman Dewangan <ldewangan@nvidia.com>

The given rail is said to be enabled only if this rail is eanbled
along with supply rail.
Adding check for the supply rail whether it is enabled or not when
query about rail enabled.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
When consumer of any rails query about whether rail is enabled
or not, the function regulator_is_enabled() should return enabled
only if this rail and supply rail (both) are enabled.
if any one of rail, whether the given rail or supply rail, is enabled
then function should return as not enabled.

 drivers/regulator/core.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index dbdebed..d914435 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1701,6 +1701,12 @@ int regulator_is_enabled(struct regulator *regulator)
 {
 	int ret;
 
+	if (regulator->rdev->supply) {
+		ret = regulator_is_enabled(regulator->rdev->supply);
+		if (ret <= 0)
+			return ret;
+	}
+
 	mutex_lock(&regulator->rdev->mutex);
 	ret = _regulator_is_enabled(regulator->rdev);
 	mutex_unlock(&regulator->rdev->mutex);
-- 
1.7.1.1

