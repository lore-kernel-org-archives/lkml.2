Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964945Ab2JSDaz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:30:55 -0400
Received: from mail.kernel.org ([198.145.19.201]:51204 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756784Ab2JSCrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:47:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 21/62] target: fix return code in target_core_init_configfs error path
Date: Thu, 18 Oct 2012 19:44:49 -0700
Message-Id: <20121019024259.382927590@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024255.944999470@linuxfoundation.org>
References: <20121019024255.944999470@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_configfs.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -3115,6 +3115,7 @@ static int __init target_core_init_confi
 				GFP_KERNEL);
 	if (!target_cg->default_groups) {
 		pr_err("Unable to allocate target_cg->default_groups\n");
+		ret = -ENOMEM;
 		goto out_global;
 	}
 
@@ -3130,6 +3131,7 @@ static int __init target_core_init_confi
 				GFP_KERNEL);
 	if (!hba_cg->default_groups) {
 		pr_err("Unable to allocate hba_cg->default_groups\n");
+		ret = -ENOMEM;
 		goto out_global;
 	}
 	config_group_init_type_name(&alua_group,
@@ -3145,6 +3147,7 @@ static int __init target_core_init_confi
 			GFP_KERNEL);
 	if (!alua_cg->default_groups) {
 		pr_err("Unable to allocate alua_cg->default_groups\n");
+		ret = -ENOMEM;
 		goto out_global;
 	}
 
@@ -3156,14 +3159,17 @@ static int __init target_core_init_confi
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
 


