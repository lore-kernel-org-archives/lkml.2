Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab2CIAEN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 19:04:13 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:47122 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab2CIAEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 19:04:09 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4EAN1HWU9bdWOb/2dsb2JhbABDhTWwe4ILAQUjDwEjIxAlAhgOAgI5AxsGARKIDqgakgWBL44RgRYElUWFZYNchleCZA
X-IronPort-AV: E=Sophos;i="4.73,554,1325458800"; 
   d="scan'208";a="886086915"
From: =?UTF-8?q?V=C3=ADctor=20Manuel=20J=C3=A1quez=20Leal?= 
	<vjaquez@igalia.com>
To: Omar Ramirez Luna <omar.ramirez@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Felipe Contreras <felipe.contreras@nokia.com>,
        linux-omap@vger.kernel.org
Subject: [PATCH 01/17] staging: tidspbridge: remove drv_init() and drv_exit()
Date: Fri,  9 Mar 2012 01:03:36 +0100
Message-Id: <00a2dae835cdd8257d5fa5f1d5900bd5f759df1b.1331250369.git.vjaquez@igalia.com>
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

The drv module has a drv_init() and a drv_exit() whose only purpose is
to keep a reference counting which is not used at all.

This patch removes these functions and the reference count variable.

There is no functional changes.

Signed-off-by: Víctor Manuel Jáquez Leal <vjaquez@igalia.com>
---
 .../staging/tidspbridge/include/dspbridge/drv.h    |   23 -----------------
 drivers/staging/tidspbridge/pmgr/dspapi.c          |    8 +----
 drivers/staging/tidspbridge/rmgr/drv.c             |   26 --------------------
 3 files changed, 2 insertions(+), 55 deletions(-)

diff --git a/drivers/staging/tidspbridge/include/dspbridge/drv.h b/drivers/staging/tidspbridge/include/dspbridge/drv.h
index 9cdbd95..b0c7708 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/drv.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/drv.h
@@ -199,17 +199,6 @@ extern int drv_create(struct drv_object **drv_obj);
 extern int drv_destroy(struct drv_object *driver_obj);
 
 /*
- *  ======== drv_exit ========
- *  Purpose:
- *      Exit the DRV module, freeing any modules initialized in drv_init.
- *  Parameters:
- *  Returns:
- *  Requires:
- *  Ensures:
- */
-extern void drv_exit(void);
-
-/*
  *  ======== drv_get_first_dev_object ========
  *  Purpose:
  *      Returns the Ptr to the FirstDev Object in the List
@@ -294,18 +283,6 @@ extern u32 drv_get_next_dev_object(u32 hdev_obj);
 extern u32 drv_get_next_dev_extension(u32 dev_extension);
 
 /*
- *  ======== drv_init ========
- *  Purpose:
- *      Initialize the DRV module.
- *  Parameters:
- *  Returns:
- *      TRUE if success; FALSE otherwise.
- *  Requires:
- *  Ensures:
- */
-extern int drv_init(void);
-
-/*
  *  ======== drv_insert_dev_object ========
  *  Purpose:
  *      Insert a DeviceObject into the list of Driver object.
diff --git a/drivers/staging/tidspbridge/pmgr/dspapi.c b/drivers/staging/tidspbridge/pmgr/dspapi.c
index 2788946..dcf1dab 100644
--- a/drivers/staging/tidspbridge/pmgr/dspapi.c
+++ b/drivers/staging/tidspbridge/pmgr/dspapi.c
@@ -278,7 +278,6 @@ void api_exit(void)
 		proc_exit();
 		mgr_exit();
 		rmm_exit();
-		drv_exit();
 	}
 }
 
@@ -290,12 +289,11 @@ void api_exit(void)
 bool api_init(void)
 {
 	bool ret = true;
-	bool fdrv, fdev, fcod, fchnl, fmsg, fio;
+	bool fdev, fcod, fchnl, fmsg, fio;
 	bool fmgr, fproc, fnode, fdisp, fstrm, frmm;
 
 	if (api_c_refs == 0) {
 		/* initialize driver and other modules */
-		fdrv = drv_init();
 		fmgr = mgr_init();
 		fproc = proc_init();
 		fnode = node_init();
@@ -307,11 +305,9 @@ bool api_init(void)
 		fio = io_init();
 		fdev = dev_init();
 		fcod = cod_init();
-		ret = fdrv && fdev && fchnl && fcod && fmsg && fio;
+		ret = fdev && fchnl && fcod && fmsg && fio;
 		ret = ret && fmgr && fproc && frmm;
 		if (!ret) {
-			if (fdrv)
-				drv_exit();
 
 			if (fmgr)
 				mgr_exit();
diff --git a/drivers/staging/tidspbridge/rmgr/drv.c b/drivers/staging/tidspbridge/rmgr/drv.c
index b34dba7..6795205 100644
--- a/drivers/staging/tidspbridge/rmgr/drv.c
+++ b/drivers/staging/tidspbridge/rmgr/drv.c
@@ -51,7 +51,6 @@ struct drv_ext {
 };
 
 /*  ----------------------------------- Globals */
-static s32 refs;
 static bool ext_phys_mem_pool_enabled;
 struct ext_phys_mem_pool {
 	u32 phys_mem_base;
@@ -332,16 +331,6 @@ int drv_create(struct drv_object **drv_obj)
 }
 
 /*
- *  ======== drv_exit ========
- *  Purpose:
- *      Discontinue usage of the DRV module.
- */
-void drv_exit(void)
-{
-	refs--;
-}
-
-/*
  *  ======== = drv_destroy ======== =
  *  purpose:
  *      Invoked during bridge de-initialization
@@ -499,21 +488,6 @@ u32 drv_get_next_dev_extension(u32 dev_extension)
 }
 
 /*
- *  ======== drv_init ========
- *  Purpose:
- *      Initialize DRV module private state.
- */
-int drv_init(void)
-{
-	s32 ret = 1;		/* function return value */
-
-	if (ret)
-		refs++;
-
-	return ret;
-}
-
-/*
  *  ======== drv_insert_dev_object ========
  *  Purpose:
  *      Insert a DevObject into the list of Manager object.
-- 
1.7.9.1

