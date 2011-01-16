Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab1APXEg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 18:04:36 -0500
Received: from nm18.bullet.mail.sp2.yahoo.com ([98.139.91.88]:20466 "HELO
	nm18.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751254Ab1APXEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 18:04:35 -0500
X-Yahoo-Newman-Id: 980520.79946.bm@omp1017.mail.sp2.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: HWkCysQVM1ktrH_e8Uq741F.4YxAhCqabgnpJPP4jzSqJG2
 ih0eZeH6Os_i0kHrnCkcpR.AMjCSbeTKDcuJMQGimB0yTzzwDXgDxW7whgln
 P_NH8k6iEuO6ubgwj6e4hCU0qViG8eHhdDgsLNblw1lIA0b9VdA5g_j.Z3IU
 syccTby0Smq1MR598GwLVz3LE5f3tuCyrpcmc3v9orVN9dH6AXm_7SIP.6Q1
 3spKDSazbsMgylFOZajMy9icKPxEoHbjgVOleWu7hOQzngacQh65xTbKDTUL
 PZHBF5PkMOuTTdSoyQorlHk_b9.pan.FnltemnTf07g4BhJYK_lw3XraMA3J
 rjY06arSDjaLB.okaVXVwQmRc4xJ3xWur
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@suse.de>, Jesper Juhl <jj@chaosbits.net>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH] target/iblock: Fix memory leak in iblock_set_configfs_dev_params
Date: Sun, 16 Jan 2011 15:04:30 -0800
Message-Id: <1295219071-32722-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

The match_strdup() allocation for Opt_udev_path needs to be released
after usage.

Reported-off-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_iblock.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 67f0c09..422187b 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -469,7 +469,7 @@ static ssize_t iblock_set_configfs_dev_params(struct se_hba *hba,
 					       const char *page, ssize_t count)
 {
 	struct iblock_dev *ib_dev = se_dev->se_dev_su_ptr;
-	char *orig, *ptr, *opts;
+	char *orig, *ptr, *arg_p, *opts;
 	substring_t args[MAX_OPT_ARGS];
 	int ret = 0, arg, token;
 
@@ -492,9 +492,14 @@ static ssize_t iblock_set_configfs_dev_params(struct se_hba *hba,
 				ret = -EEXIST;
 				goto out;
 			}
-
-			ret = snprintf(ib_dev->ibd_udev_path, SE_UDEV_PATH_LEN,
-				"%s", match_strdup(&args[0]));
+			arg_p = match_strdup(&args[0]);
+			if (!arg_p) {
+				ret = -ENOMEM;
+				break;
+			}
+			snprintf(ib_dev->ibd_udev_path, SE_UDEV_PATH_LEN,
+					"%s", arg_p);
+			kfree(arg_p);
 			printk(KERN_INFO "IBLOCK: Referencing UDEV path: %s\n",
 					ib_dev->ibd_udev_path);
 			ib_dev->ibd_flags |= IBDF_HAS_UDEV_PATH;
-- 
1.5.6.5

