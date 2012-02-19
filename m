Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab2BSH2a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 02:28:30 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25143 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab2BSH23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 02:28:29 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6624"; a="164447548"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] regulator: Fix and simplify debugfs support
Date: Sat, 18 Feb 2012 23:28:25 -0800
Message-Id: <1329636505-13651-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.9.1.244.gb0d66b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_DEBUG_FS=y debugfs functions will never return an
ERR_PTR. Instead they'll return NULL. The intent is to remove
ifdefs in calling code.

Instead of checking for an ERR_PTR check for NULL. This simplifies
the code and also fixes an error check that would never have
worked otherwise. While we're here modernize the code to use
S_IRUGO instead of 0444.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

If we're willing to sacrifice a pointer per rdev we can remove the
ifdefs and the compiler should be able to optimize away the dead
code.

 drivers/regulator/core.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index e9a83f8..f20696d 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1145,9 +1145,8 @@ static struct regulator *create_regulator(struct regulator_dev *rdev,
 #ifdef CONFIG_DEBUG_FS
 	regulator->debugfs = debugfs_create_dir(regulator->supply_name,
 						rdev->debugfs);
-	if (IS_ERR_OR_NULL(regulator->debugfs)) {
+	if (!regulator->debugfs) {
 		rdev_warn(rdev, "Failed to create debugfs directory\n");
-		regulator->debugfs = NULL;
 	} else {
 		debugfs_create_u32("uA_load", 0444, regulator->debugfs,
 				   &regulator->uA_load);
@@ -2712,9 +2711,8 @@ static void rdev_init_debugfs(struct regulator_dev *rdev)
 {
 #ifdef CONFIG_DEBUG_FS
 	rdev->debugfs = debugfs_create_dir(rdev_get_name(rdev), debugfs_root);
-	if (IS_ERR(rdev->debugfs) || !rdev->debugfs) {
+	if (!rdev->debugfs) {
 		rdev_warn(rdev, "Failed to create debugfs directory\n");
-		rdev->debugfs = NULL;
 		return;
 	}
 
@@ -3129,13 +3127,10 @@ static int __init regulator_init(void)
 
 #ifdef CONFIG_DEBUG_FS
 	debugfs_root = debugfs_create_dir("regulator", NULL);
-	if (IS_ERR(debugfs_root) || !debugfs_root) {
+	if (!debugfs_root)
 		pr_warn("regulator: Failed to create debugfs directory\n");
-		debugfs_root = NULL;
-	}
-
-	if (IS_ERR(debugfs_create_file("supply_map", 0444, debugfs_root,
-				       NULL, &supply_map_fops)))
+	else if (!debugfs_create_file("supply_map", S_IRUGO, debugfs_root,
+				       NULL, &supply_map_fops))
 		pr_warn("regulator: Failed to create supplies debugfs\n");
 #endif
 
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

