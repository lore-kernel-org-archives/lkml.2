Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250Ab2CIAFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 19:05:31 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:31437 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758700Ab2CIAEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 19:04:22 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4EAN1HWU9bdWOb/2dsb2JhbABDhTWwe4ILAQUjBAsBIyMQJQIYDgICOQMbBgESiA6oGpIFgS+OEYEWBJVFhWWDXIZXgmQ
X-IronPort-AV: E=Sophos;i="4.73,554,1325458800"; 
   d="scan'208";a="886086954"
From: =?UTF-8?q?V=C3=ADctor=20Manuel=20J=C3=A1quez=20Leal?= 
	<vjaquez@igalia.com>
To: Omar Ramirez Luna <omar.ramirez@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Felipe Contreras <felipe.contreras@nokia.com>,
        linux-omap@vger.kernel.org
Subject: [PATCH 11/17] staging: tidspbridge: remove cmm_init() and cmm_exit()
Date: Fri,  9 Mar 2012 01:03:46 +0100
Message-Id: <4bebbc21b35a37555e4883637233c78e5408ba19.1331250369.git.vjaquez@igalia.com>
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

The cmm module has a cmm_init() and a cmm_exit() whose only purpose is
to keep a reference counting which is not used at all.

This patch removes these functions and the reference count variable.

There is no functional changes.

Signed-off-by: Víctor Manuel Jáquez Leal <vjaquez@igalia.com>
---
 .../staging/tidspbridge/include/dspbridge/cmm.h    |   30 --------------------
 drivers/staging/tidspbridge/pmgr/cmm.c             |   29 -------------------
 drivers/staging/tidspbridge/pmgr/dev.c             |   23 ++------------
 3 files changed, 4 insertions(+), 78 deletions(-)

diff --git a/drivers/staging/tidspbridge/include/dspbridge/cmm.h b/drivers/staging/tidspbridge/include/dspbridge/cmm.h
index aff2205..c66bcf7 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/cmm.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/cmm.h
@@ -79,7 +79,6 @@ extern void *cmm_calloc_buf(struct cmm_object *hcmm_mgr,
  *      -EPERM:      Failed to initialize critical sect sync object.
  *
  *  Requires:
- *      cmm_init(void) called.
  *      ph_cmm_mgr != NULL.
  *      mgr_attrts->min_block_size >= 4 bytes.
  *  Ensures:
@@ -111,20 +110,6 @@ extern int cmm_create(struct cmm_object **ph_cmm_mgr,
 extern int cmm_destroy(struct cmm_object *hcmm_mgr, bool force);
 
 /*
- *  ======== cmm_exit ========
- *  Purpose:
- *     Discontinue usage of module. Cleanup CMM module if CMM cRef reaches zero.
- *  Parameters:
- *     n/a
- *  Returns:
- *     n/a
- *  Requires:
- *     CMM is initialized.
- *  Ensures:
- */
-extern void cmm_exit(void);
-
-/*
  *  ======== cmm_free_buf ========
  *  Purpose:
  *      Free the given buffer.
@@ -185,19 +170,6 @@ extern int cmm_get_info(struct cmm_object *hcmm_mgr,
 			       struct cmm_info *cmm_info_obj);
 
 /*
- *  ======== cmm_init ========
- *  Purpose:
- *      Initializes private state of CMM module.
- *  Parameters:
- *  Returns:
- *      TRUE if initialized; FALSE if error occurred.
- *  Requires:
- *  Ensures:
- *      CMM initialized.
- */
-extern bool cmm_init(void);
-
-/*
  *  ======== cmm_register_gppsm_seg ========
  *  Purpose:
  *      Register a block of SM with the CMM.
@@ -333,7 +305,6 @@ extern int cmm_xlator_free_buf(struct cmm_xlatorobject *xlator,
  *      0:        Success.
  *      -EFAULT:    Bad translator handle.
  *  Requires:
- *      (refs > 0)
  *      (paddr != NULL)
  *      (ul_size > 0)
  *  Ensures:
@@ -355,7 +326,6 @@ extern int cmm_xlator_info(struct cmm_xlatorobject *xlator,
  *  Returns:
  *     Valid address on success, else NULL.
  *  Requires:
- *      refs > 0
  *      paddr != NULL
  *      xtype >= CMM_VA2PA) && (xtype <= CMM_DSPPA2PA)
  *  Ensures:
diff --git a/drivers/staging/tidspbridge/pmgr/cmm.c b/drivers/staging/tidspbridge/pmgr/cmm.c
index 3366e60..4a800da 100644
--- a/drivers/staging/tidspbridge/pmgr/cmm.c
+++ b/drivers/staging/tidspbridge/pmgr/cmm.c
@@ -131,9 +131,6 @@ struct cmm_mnode {
 	u32 client_proc;	/* Process that allocated this mem block */
 };
 
-/*  ----------------------------------- Globals */
-static u32 refs;		/* module reference count */
-
 /*  ----------------------------------- Function Prototypes */
 static void add_to_free_list(struct cmm_allocator *allocator,
 			     struct cmm_mnode *pnode);
@@ -317,17 +314,6 @@ int cmm_destroy(struct cmm_object *hcmm_mgr, bool force)
 }
 
 /*
- *  ======== cmm_exit ========
- *  Purpose:
- *      Discontinue usage of module; free resources when reference count
- *      reaches 0.
- */
-void cmm_exit(void)
-{
-	refs--;
-}
-
-/*
  *  ======== cmm_free_buf ========
  *  Purpose:
  *      Free the given buffer.
@@ -446,21 +432,6 @@ int cmm_get_info(struct cmm_object *hcmm_mgr,
 }
 
 /*
- *  ======== cmm_init ========
- *  Purpose:
- *      Initializes private state of CMM module.
- */
-bool cmm_init(void)
-{
-	bool ret = true;
-
-	if (ret)
-		refs++;
-
-	return ret;
-}
-
-/*
  *  ======== cmm_register_gppsm_seg ========
  *  Purpose:
  *      Register a block of SM with the CMM to be used for later GPP SM
diff --git a/drivers/staging/tidspbridge/pmgr/dev.c b/drivers/staging/tidspbridge/pmgr/dev.c
index 883765e..734d47e 100644
--- a/drivers/staging/tidspbridge/pmgr/dev.c
+++ b/drivers/staging/tidspbridge/pmgr/dev.c
@@ -658,10 +658,8 @@ void dev_exit(void)
 {
 	refs--;
 
-	if (refs == 0) {
-		cmm_exit();
+	if (refs == 0)
 		dmm_exit();
-	}
 }
 
 /*
@@ -671,23 +669,10 @@ void dev_exit(void)
  */
 bool dev_init(void)
 {
-	bool cmm_ret, dmm_ret, ret = true;
-
-	if (refs == 0) {
-		cmm_ret = cmm_init();
-		dmm_ret = dmm_init();
-
-		ret = cmm_ret && dmm_ret;
-
-		if (!ret) {
-			if (cmm_ret)
-				cmm_exit();
+	bool ret = true;
 
-			if (dmm_ret)
-				dmm_exit();
-
-		}
-	}
+	if (refs == 0)
+		dmm_init();
 
 	if (ret)
 		refs++;
-- 
1.7.9.1

