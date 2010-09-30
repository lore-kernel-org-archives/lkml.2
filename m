Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828Ab0I3S10 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 14:27:26 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52149 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972Ab0I3S1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 14:27:24 -0400
From: Ernesto Ramos <ernesto@ti.com>
To: gregkh@suse.de, linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: ameya.palande@nokia.com, felipe.contreras@gmail.com,
        andy.shevchenko@gmail.com, Ernesto Ramos <ernesto@ti.com>,
        Omar Ramirez Luna <omar.ramirez@ti.com>
Subject: [PATCH] staging:ti dspbridge: remove cmm_xlator_delete wrapper
Date: Thu, 30 Sep 2010 13:33:41 -0500
Message-Id: <1285871621-26918-1-git-send-email-ernesto@ti.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending this patch since it was missed in the last merge...

Remove unnecessary cmm_xlator_delete function and use
kfree() kernel function directly.

Signed-off-by: Ernesto Ramos <ernesto@ti.com>
Signed-off-by: Omar Ramirez Luna <omar.ramirez@ti.com>
---
 .../staging/tidspbridge/include/dspbridge/cmm.h    |   19 -------------------
 drivers/staging/tidspbridge/pmgr/cmm.c             |   17 -----------------
 drivers/staging/tidspbridge/rmgr/node.c            |    9 ++-------
 drivers/staging/tidspbridge/rmgr/strm.c            |   11 ++---------
 4 files changed, 4 insertions(+), 52 deletions(-)

diff --git a/drivers/staging/tidspbridge/include/dspbridge/cmm.h b/drivers/staging/tidspbridge/include/dspbridge/cmm.h
index a921f1b..6ad313f 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/cmm.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/cmm.h
@@ -300,25 +300,6 @@ extern int cmm_xlator_create(struct cmm_xlatorobject **xlator,
 				    struct cmm_xlatorattrs *xlator_attrs);
 
 /*
- *  ======== cmm_xlator_delete ========
- *  Purpose:
- *      Delete translator resources
- *  Parameters:
- *      xlator:    handle to translator.
- *      force:     force = TRUE will free XLators SM buffers/dscriptrs.
- *  Returns:
- *      0:        Success.
- *      -EFAULT:    Bad translator handle.
- *      -EPERM:      Unable to free translator resources.
- *  Requires:
- *      refs > 0
- *  Ensures:
- *
- */
-extern int cmm_xlator_delete(struct cmm_xlatorobject *xlator,
-				    bool force);
-
-/*
  *  ======== cmm_xlator_free_buf ========
  *  Purpose:
  *      Free SM buffer and descriptor.
diff --git a/drivers/staging/tidspbridge/pmgr/cmm.c b/drivers/staging/tidspbridge/pmgr/cmm.c
index e3f77bd..93a7c4f 100644
--- a/drivers/staging/tidspbridge/pmgr/cmm.c
+++ b/drivers/staging/tidspbridge/pmgr/cmm.c
@@ -968,23 +968,6 @@ int cmm_xlator_create(struct cmm_xlatorobject **xlator,
 }
 
 /*
- *  ======== cmm_xlator_delete ========
- *  Purpose:
- *      Free the Xlator resources.
- *      VM gets freed later.
- */
-int cmm_xlator_delete(struct cmm_xlatorobject *xlator, bool force)
-{
-	struct cmm_xlator *xlator_obj = (struct cmm_xlator *)xlator;
-
-	DBC_REQUIRE(refs > 0);
-
-	kfree(xlator_obj);
-
-	return 0;
-}
-
-/*
  *  ======== cmm_xlator_alloc_buf ========
  */
 void *cmm_xlator_alloc_buf(struct cmm_xlatorobject *xlator, void *va_buf,
diff --git a/drivers/staging/tidspbridge/rmgr/node.c b/drivers/staging/tidspbridge/rmgr/node.c
index 84882dc..1562f3c 100644
--- a/drivers/staging/tidspbridge/rmgr/node.c
+++ b/drivers/staging/tidspbridge/rmgr/node.c
@@ -2505,7 +2505,6 @@ static void delete_node(struct node_object *hnode,
 			struct process_context *pr_ctxt)
 {
 	struct node_mgr *hnode_mgr;
-	struct cmm_xlatorobject *xlator;
 	struct bridge_drv_interface *intf_fxns;
 	u32 i;
 	enum node_type node_type;
@@ -2523,7 +2522,7 @@ static void delete_node(struct node_object *hnode,
 	hnode_mgr = hnode->hnode_mgr;
 	if (!hnode_mgr)
 		goto func_end;
-	xlator = hnode->xlator;
+
 	node_type = node_get_type(hnode);
 	if (node_type != NODE_DEVICE) {
 		node_msg_args = hnode->create_args.asa.node_msg_args;
@@ -2619,11 +2618,7 @@ static void delete_node(struct node_object *hnode,
 	hnode->dcd_props.obj_data.node_obj.pstr_i_alg_name = NULL;
 
 	/* Free all SM address translator resources */
-	if (xlator) {
-		(void)cmm_xlator_delete(xlator, true);	/* force free */
-		xlator = NULL;
-	}
-
+	kfree(hnode->xlator);
 	kfree(hnode->nldr_node_obj);
 	hnode->nldr_node_obj = NULL;
 	hnode->hnode_mgr = NULL;
diff --git a/drivers/staging/tidspbridge/rmgr/strm.c b/drivers/staging/tidspbridge/rmgr/strm.c
index f4986b7..2e42714 100644
--- a/drivers/staging/tidspbridge/rmgr/strm.c
+++ b/drivers/staging/tidspbridge/rmgr/strm.c
@@ -834,16 +834,9 @@ static int delete_strm(struct strm_object *stream_obj)
 			 * is invalid. */
 			status = (*intf_fxns->pfn_chnl_close)
 					(stream_obj->chnl_obj);
-			/* Free all SM address translator resources */
-			if (!status) {
-				if (stream_obj->xlator) {
-					/* force free */
-					(void)cmm_xlator_delete(stream_obj->
-								xlator,
-								true);
-				}
-			}
 		}
+		/* Free all SM address translator resources */
+		kfree(stream_obj->xlator);
 		kfree(stream_obj);
 	} else {
 		status = -EFAULT;
-- 
1.5.4.5

