Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932575Ab2JNOsF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:48:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46753 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932416Ab2JNOoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:44:16 -0400
Message-Id: <20121014143537.745836336@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:36:02 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 029/147] target: fix return code in target_core_init_configfs error path
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/target/target_core_configfs.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index a1b4171..015f5be 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -3124,6 +3124,7 @@ static int __init target_core_init_configfs(void)
 				GFP_KERNEL);
 	if (!target_cg->default_groups) {
 		pr_err("Unable to allocate target_cg->default_groups\n");
+		ret = -ENOMEM;
 		goto out_global;
 	}
 
@@ -3139,6 +3140,7 @@ static int __init target_core_init_configfs(void)
 				GFP_KERNEL);
 	if (!hba_cg->default_groups) {
 		pr_err("Unable to allocate hba_cg->default_groups\n");
+		ret = -ENOMEM;
 		goto out_global;
 	}
 	config_group_init_type_name(&alua_group,
@@ -3154,6 +3156,7 @@ static int __init target_core_init_configfs(void)
 			GFP_KERNEL);
 	if (!alua_cg->default_groups) {
 		pr_err("Unable to allocate alua_cg->default_groups\n");
+		ret = -ENOMEM;
 		goto out_global;
 	}
 
@@ -3165,14 +3168,17 @@ static int __init target_core_init_configfs(void)
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
 


