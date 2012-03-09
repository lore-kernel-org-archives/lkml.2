Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759368Ab2CIAFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 19:05:15 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:41263 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757812Ab2CIAES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 19:04:18 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4EAN1HWU9bdWOb/2dsb2JhbABDhTWwe4ILAQUjBAsBIyMQJQIYDgICOQMbBgESiA6oGpIFgS+OEYEWBJVFhWWDXIZXgmQ
X-IronPort-AV: E=Sophos;i="4.73,554,1325458800"; 
   d="scan'208";a="886086948"
From: =?UTF-8?q?V=C3=ADctor=20Manuel=20J=C3=A1quez=20Leal?= 
	<vjaquez@igalia.com>
To: Omar Ramirez Luna <omar.ramirez@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Felipe Contreras <felipe.contreras@nokia.com>,
        linux-omap@vger.kernel.org
Subject: [PATCH 17/17] staging: tidspbridge: remove nldr_init() and nldr_exit()
Date: Fri,  9 Mar 2012 01:03:52 +0100
Message-Id: <15501a475f483f6190aaa0d8bcb61ec4a7102b4e.1331250369.git.vjaquez@igalia.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <cover.1331250368.git.vjaquez@igalia.com>
References: <cover.1331250368.git.vjaquez@igalia.com>
In-Reply-To: <cover.1331250368.git.vjaquez@igalia.com>
References: <cover.1331250368.git.vjaquez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dynamic loader was called by node.c with an interface. This interface was
also modified to avoid the use of nldr_init() and nldr_exit().

There is not functional changes.

Signed-off-by: Víctor Manuel Jáquez Leal <vjaquez@igalia.com>
---
 .../staging/tidspbridge/include/dspbridge/nldr.h   |    2 -
 .../tidspbridge/include/dspbridge/nldrdefs.h       |   34 --------------------
 drivers/staging/tidspbridge/rmgr/nldr.c            |   19 -----------
 drivers/staging/tidspbridge/rmgr/node.c            |    7 ----
 4 files changed, 0 insertions(+), 62 deletions(-)

diff --git a/drivers/staging/tidspbridge/include/dspbridge/nldr.h b/drivers/staging/tidspbridge/include/dspbridge/nldr.h
index d9653ee..c5e48ca 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/nldr.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/nldr.h
@@ -36,7 +36,6 @@ extern int nldr_create(struct nldr_object **nldr,
 			      const struct nldr_attrs *pattrs);
 
 extern void nldr_delete(struct nldr_object *nldr_obj);
-extern void nldr_exit(void);
 
 extern int nldr_get_fxn_addr(struct nldr_nodeobject *nldr_node_obj,
 				    char *str_fxn, u32 * addr);
@@ -44,7 +43,6 @@ extern int nldr_get_fxn_addr(struct nldr_nodeobject *nldr_node_obj,
 extern int nldr_get_rmm_manager(struct nldr_object *nldr,
 				       struct rmm_target_obj **rmm_mgr);
 
-extern bool nldr_init(void);
 extern int nldr_load(struct nldr_nodeobject *nldr_node_obj,
 			    enum nldr_phase phase);
 extern int nldr_unload(struct nldr_nodeobject *nldr_node_obj,
diff --git a/drivers/staging/tidspbridge/include/dspbridge/nldrdefs.h b/drivers/staging/tidspbridge/include/dspbridge/nldrdefs.h
index ee3a85f..7e3c7f5 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/nldrdefs.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/nldrdefs.h
@@ -119,7 +119,6 @@ enum nldr_phase {
  *      0:        Success.
  *      -ENOMEM:    Insufficient memory on GPP.
  *  Requires:
- *      nldr_init(void) called.
  *      Valid nldr_obj.
  *      node_props != NULL.
  *      nldr_nodeobj != NULL.
@@ -148,7 +147,6 @@ typedef int(*nldr_allocatefxn) (struct nldr_object *nldr_obj,
  *      0:        Success;
  *      -ENOMEM:    Insufficient memory for requested resources.
  *  Requires:
- *      nldr_init(void) called.
  *      nldr != NULL.
  *      hdev_obj != NULL.
  *	pattrs != NULL.
@@ -168,7 +166,6 @@ typedef int(*nldr_createfxn) (struct nldr_object **nldr,
  *      nldr_obj:          Node manager object.
  *  Returns:
  *  Requires:
- *      nldr_init(void) called.
  *      Valid nldr_obj.
  *  Ensures:
  *	nldr_obj invalid
@@ -176,20 +173,6 @@ typedef int(*nldr_createfxn) (struct nldr_object **nldr,
 typedef void (*nldr_deletefxn) (struct nldr_object *nldr_obj);
 
 /*
- *  ======== nldr_exit ========
- *  Discontinue usage of NLDR module.
- *
- *  Parameters:
- *  Returns:
- *  Requires:
- *      nldr_init(void) successfully called before.
- *  Ensures:
- *      Any resources acquired in nldr_init(void) will be freed when last NLDR
- *      client calls nldr_exit(void).
- */
-typedef void (*nldr_exitfxn) (void);
-
-/*
  *  ======== NLDR_Free ========
  *  Free resources allocated in nldr_allocate.
  *
@@ -197,7 +180,6 @@ typedef void (*nldr_exitfxn) (void);
  *      nldr_node_obj:      Handle returned from nldr_allocate().
  *  Returns:
  *  Requires:
- *      nldr_init(void) called.
  *      Valid nldr_node_obj.
  *  Ensures:
  */
@@ -216,7 +198,6 @@ typedef void (*nldr_freefxn) (struct nldr_nodeobject *nldr_node_obj);
  *      0:        Success.
  *      -ESPIPE:    Address of function not found.
  *  Requires:
- *      nldr_init(void) called.
  *      Valid nldr_node_obj.
  *      addr != NULL;
  *      str_fxn != NULL;
@@ -227,17 +208,6 @@ typedef int(*nldr_getfxnaddrfxn) (struct nldr_nodeobject
 					 char *str_fxn, u32 * addr);
 
 /*
- *  ======== nldr_init ========
- *  Initialize the NLDR module.
- *
- *  Parameters:
- *  Returns:
- *      TRUE if initialization succeeded, FALSE otherwise.
- *  Ensures:
- */
-typedef bool(*nldr_initfxn) (void);
-
-/*
  *  ======== nldr_load ========
  *  Load create, delete, or execute phase function of a node on the DSP.
  *
@@ -251,7 +221,6 @@ typedef bool(*nldr_initfxn) (void);
  *                              is already in use.
  *      -EILSEQ:           Failure in dynamic loader library.
  *  Requires:
- *      nldr_init(void) called.
  *      Valid nldr_node_obj.
  *  Ensures:
  */
@@ -269,7 +238,6 @@ typedef int(*nldr_loadfxn) (struct nldr_nodeobject *nldr_node_obj,
  *      0:        Success.
  *      -ENOMEM:    Insufficient memory on GPP.
  *  Requires:
- *      nldr_init(void) called.
  *      Valid nldr_node_obj.
  *  Ensures:
  */
@@ -283,9 +251,7 @@ struct node_ldr_fxns {
 	nldr_allocatefxn allocate;
 	nldr_createfxn create;
 	nldr_deletefxn delete;
-	nldr_exitfxn exit;
 	nldr_getfxnaddrfxn get_fxn_addr;
-	nldr_initfxn init;
 	nldr_loadfxn load;
 	nldr_unloadfxn unload;
 };
diff --git a/drivers/staging/tidspbridge/rmgr/nldr.c b/drivers/staging/tidspbridge/rmgr/nldr.c
index 46086b5..30d5480 100644
--- a/drivers/staging/tidspbridge/rmgr/nldr.c
+++ b/drivers/staging/tidspbridge/rmgr/nldr.c
@@ -620,15 +620,6 @@ void nldr_delete(struct nldr_object *nldr_obj)
 }
 
 /*
- *  ======== nldr_exit ========
- *  Discontinue usage of NLDR module.
- */
-void nldr_exit(void)
-{
-	/* do nothing */
-}
-
-/*
  *  ======== nldr_get_fxn_addr ========
  */
 int nldr_get_fxn_addr(struct nldr_nodeobject *nldr_node_obj,
@@ -736,16 +727,6 @@ int nldr_get_rmm_manager(struct nldr_object *nldr,
 }
 
 /*
- *  ======== nldr_init ========
- *  Initialize the NLDR module.
- */
-bool nldr_init(void)
-{
-	/* do nothing */
-	return true;
-}
-
-/*
  *  ======== nldr_load ========
  */
 int nldr_load(struct nldr_nodeobject *nldr_node_obj,
diff --git a/drivers/staging/tidspbridge/rmgr/node.c b/drivers/staging/tidspbridge/rmgr/node.c
index 908cd1e..7fb426c 100644
--- a/drivers/staging/tidspbridge/rmgr/node.c
+++ b/drivers/staging/tidspbridge/rmgr/node.c
@@ -159,7 +159,6 @@ struct node_mgr {
 	/* Loader properties */
 	struct nldr_object *nldr_obj;	/* Handle to loader */
 	struct node_ldr_fxns nldr_fxns;	/* Handle to loader functions */
-	bool loader_init;	/* Loader Init function succeeded? */
 };
 
 /*
@@ -266,9 +265,7 @@ static struct node_ldr_fxns nldr_fxns = {
 	nldr_allocate,
 	nldr_create,
 	nldr_delete,
-	nldr_exit,
 	nldr_get_fxn_addr,
-	nldr_init,
 	nldr_load,
 	nldr_unload,
 };
@@ -1337,7 +1334,6 @@ int node_create_mgr(struct node_mgr **node_man,
 	nldr_attrs_obj.write = mem_write;
 	nldr_attrs_obj.dsp_word_size = node_mgr_obj->dsp_word_size;
 	nldr_attrs_obj.dsp_mau_size = node_mgr_obj->dsp_mau_size;
-	node_mgr_obj->loader_init = node_mgr_obj->nldr_fxns.init();
 	status = node_mgr_obj->nldr_fxns.create(&node_mgr_obj->nldr_obj,
 			hdev_obj,
 			&nldr_attrs_obj);
@@ -2507,9 +2503,6 @@ static void delete_node_mgr(struct node_mgr *hnode_mgr)
 		if (hnode_mgr->nldr_obj)
 			hnode_mgr->nldr_fxns.delete(hnode_mgr->nldr_obj);
 
-		if (hnode_mgr->loader_init)
-			hnode_mgr->nldr_fxns.exit();
-
 		kfree(hnode_mgr);
 	}
 }
-- 
1.7.9.1

