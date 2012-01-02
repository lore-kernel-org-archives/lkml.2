Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400Ab2ABHk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 02:40:27 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15530 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab2ABHkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 02:40:25 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sun, 01 Jan 2012 23:40:25 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Cc: linux-tegra@vger.kernel.org, ldewangan@nvidia.com
Subject: [PATCH V1] regulator: Enable supply regulator if child rail is enabled.
Date: Mon,  2 Jan 2012 13:08:45 +0530
Message-Id: <1325489925-5148-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During regulator_register, the rail is set on the provided
machine constraints and if it is enabled then it is also
require to enable the supply regulator. This will make sure
that:
   1. Proper reference count for supply regulator to be maintain.
   2. Supply regulator should be enable when given rail is enabled.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
When given rail is registered and if it has machine constratins to
enable the rail then it is also require to enable the supply rail for
a given rail. This will make sure that given rail is enabled and
proper reference count is maintained for the supply rail to avoid
disable of supply rail even child rail is enabled.

 drivers/regulator/core.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index dbdebed..6e7a4f1 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2801,6 +2801,14 @@ struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
 		ret = set_supply(rdev, r);
 		if (ret < 0)
 			goto scrub;
+
+		/* Enable supply if rail is enabled */
+		if (rdev->desc->ops->is_enabled &&
+				rdev->desc->ops->is_enabled(rdev)) {
+			ret = regulator_enable(rdev->supply);
+			if (ret < 0)
+				goto scrub;
+		}
 	}
 
 	/* add consumers devices */
-- 
1.7.1.1

