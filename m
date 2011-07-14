Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039Ab1GNN32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 09:29:28 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52410 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933Ab1GNN31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 09:29:27 -0400
Subject: [PATCH] regulator: Fix memory leak in set_machine_constraints()
 error paths
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jul 2011 21:29:19 +0800
Message-ID: <1310650159.6854.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/core.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index f59821f..e7655a5 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -787,7 +787,6 @@ static int machine_constraints_voltage(struct regulator_dev *rdev,
 		if (ret < 0) {
 			rdev_err(rdev, "failed to apply %duV constraint\n",
 				 rdev->constraints->min_uV);
-			rdev->constraints = NULL;
 			return ret;
 		}
 	}
@@ -873,7 +872,7 @@ static int machine_constraints_voltage(struct regulator_dev *rdev,
 static int set_machine_constraints(struct regulator_dev *rdev,
 	const struct regulation_constraints *constraints)
 {
-	int ret = 0;
+	int ret;
 	struct regulator_ops *ops = rdev->desc->ops;
 
 	rdev->constraints = kmemdup(constraints, sizeof(*constraints),
@@ -890,7 +889,6 @@ static int set_machine_constraints(struct regulator_dev *rdev,
 		ret = suspend_prepare(rdev, rdev->constraints->initial_state);
 		if (ret < 0) {
 			rdev_err(rdev, "failed to set suspend state\n");
-			rdev->constraints = NULL;
 			goto out;
 		}
 	}
@@ -917,13 +915,15 @@ static int set_machine_constraints(struct regulator_dev *rdev,
 		ret = ops->enable(rdev);
 		if (ret < 0) {
 			rdev_err(rdev, "failed to enable\n");
-			rdev->constraints = NULL;
 			goto out;
 		}
 	}
 
 	print_constraints(rdev);
+	return 0;
 out:
+	kfree(rdev->constraints);
+	rdev->constraints = NULL;
 	return ret;
 }
 
-- 
1.7.4.1



