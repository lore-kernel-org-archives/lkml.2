Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691Ab1GOCuv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 22:50:51 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41197 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932472Ab1GOCuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 22:50:50 -0400
Subject: [PATCH v3] regulator: Fix memory leak in set_machine_constraints()
 error paths
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jul 2011 10:50:43 +0800
Message-ID: <1310698243.2384.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Properly kfree rdev->constraints in all set_machine_constraints() error paths.
Also properly kfree rdev->constraints in regulator_register() error paths.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/core.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index f59821f..44a45bd 100644
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
 
@@ -2694,6 +2694,7 @@ unset_supplies:
 	unset_regulator_supplies(rdev);
 
 scrub:
+	kfree(rdev->constraints);
 	device_unregister(&rdev->dev);
 	/* device core frees rdev */
 	rdev = ERR_PTR(ret);
-- 
1.7.4.1



