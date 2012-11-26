Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab2KZRBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:01:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47106 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756123Ab2KZRBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:01:18 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Senna Tschudin <peter.senna@gmail.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 025/270] target: fix return code in target_core_init_configfs error path
Date: Mon, 26 Nov 2012 14:55:15 -0200
Message-Id: <1353949160-26803-26-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Senna Tschudin <peter.senna@gmail.com>

commit 37bb7899ca366dc212b71b150e78566d04808cc0 upstream.

This patch fixes error cases within target_core_init_configfs() to
properly set ret = -ENOMEM before jumping to the out_global exception
path.

This was originally discovered with the following Coccinelle semantic
match information:

Convert a nonnegative error return code to a negative one, as returned
elsewhere in the function.  A simplified version of the semantic match
that finds this problem is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/target/target_core_configfs.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 801efa8..06aca11 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -3132,6 +3132,7 @@ static int __init target_core_init_configfs(void)
 				GFP_KERNEL);
 	if (!target_cg->default_groups) {
 		pr_err("Unable to allocate target_cg->default_groups\n");
+		ret = -ENOMEM;
 		goto out_global;
 	}
 
@@ -3147,6 +3148,7 @@ static int __init target_core_init_configfs(void)
 				GFP_KERNEL);
 	if (!hba_cg->default_groups) {
 		pr_err("Unable to allocate hba_cg->default_groups\n");
+		ret = -ENOMEM;
 		goto out_global;
 	}
 	config_group_init_type_name(&alua_group,
@@ -3162,6 +3164,7 @@ static int __init target_core_init_configfs(void)
 			GFP_KERNEL);
 	if (!alua_cg->default_groups) {
 		pr_err("Unable to allocate alua_cg->default_groups\n");
+		ret = -ENOMEM;
 		goto out_global;
 	}
 
@@ -3173,14 +3176,17 @@ static int __init target_core_init_configfs(void)
 	 * Add core/alua/lu_gps/default_lu_gp
 	 */
 	lu_gp = core_alua_allocate_lu_gp("default_lu_gp", 1);
-	if (IS_ERR(lu_gp))
+	if (IS_ERR(lu_gp)) {
+		ret = -ENOMEM;
 		goto out_global;
+	}
 
 	lu_gp_cg = &alua_lu_gps_group;
 	lu_gp_cg->default_groups = kzalloc(sizeof(struct config_group) * 2,
 			GFP_KERNEL);
 	if (!lu_gp_cg->default_groups) {
 		pr_err("Unable to allocate lu_gp_cg->default_groups\n");
+		ret = -ENOMEM;
 		goto out_global;
 	}
 
-- 
1.7.9.5

