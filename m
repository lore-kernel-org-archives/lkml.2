Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759240Ab2CIAEm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 19:04:42 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:47122 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756683Ab2CIAEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 19:04:13 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4EAN1HWU9bdWOb/2dsb2JhbABDhTWwe4ILAQUjBAsBIyMQJQIYDgICOQMbBgESiA6oGpIFgS+OEYEWBJVFhWWDXIZXgmQ
X-IronPort-AV: E=Sophos;i="4.73,554,1325458800"; 
   d="scan'208";a="886086918"
From: =?UTF-8?q?V=C3=ADctor=20Manuel=20J=C3=A1quez=20Leal?= 
	<vjaquez@igalia.com>
To: Omar Ramirez Luna <omar.ramirez@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Felipe Contreras <felipe.contreras@nokia.com>,
        linux-omap@vger.kernel.org
Subject: [PATCH 02/17] staging: tidspbridge: remove cod_init() and cod_exit()
Date: Fri,  9 Mar 2012 01:03:37 +0100
Message-Id: <bdd5754cbc4d29eb4e3bd746e52db8c1b95ac672.1331250369.git.vjaquez@igalia.com>
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

The cod module has a cod_init() and a cod_exit() whose only purpose is
to keep a reference counting which is not used at all.

This patch removes these functions and the reference count variable.

There is no functional changes.

Signed-off-by: Víctor Manuel Jáquez Leal <vjaquez@igalia.com>
---
 .../staging/tidspbridge/include/dspbridge/cod.h    |   29 --------------------
 drivers/staging/tidspbridge/pmgr/cod.c             |   29 --------------------
 drivers/staging/tidspbridge/pmgr/dspapi.c          |    9 +-----
 drivers/staging/tidspbridge/rmgr/dbdcd.c           |   15 +---------
 4 files changed, 3 insertions(+), 79 deletions(-)

diff --git a/drivers/staging/tidspbridge/include/dspbridge/cod.h b/drivers/staging/tidspbridge/include/dspbridge/cod.h
index cb684c1..ba2005d 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/cod.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/cod.h
@@ -100,21 +100,6 @@ extern int cod_create(struct cod_manager **mgr,
 extern void cod_delete(struct cod_manager *cod_mgr_obj);
 
 /*
- *  ======== cod_exit ========
- *  Purpose:
- *      Discontinue usage of the COD module.
- *  Parameters:
- *      None.
- *  Returns:
- *      None.
- *  Requires:
- *      COD initialized.
- *  Ensures:
- *      Resources acquired in cod_init(void) are freed.
- */
-extern void cod_exit(void);
-
-/*
  *  ======== cod_get_base_lib ========
  *  Purpose:
  *      Get handle to the base image DBL library.
@@ -243,20 +228,6 @@ extern int cod_get_sym_value(struct cod_manager *cod_mgr_obj,
 				    char *str_sym, u32 * pul_value);
 
 /*
- *  ======== cod_init ========
- *  Purpose:
- *      Initialize the COD module's private state.
- *  Parameters:
- *      None.
- *  Returns:
- *      TRUE if initialized; FALSE if error occurred.
- *  Requires:
- *  Ensures:
- *      A requirement for each of the other public COD functions.
- */
-extern bool cod_init(void);
-
-/*
  *  ======== cod_load_base ========
  *  Purpose:
  *      Load the initial program image, optionally with command-line arguments,
diff --git a/drivers/staging/tidspbridge/pmgr/cod.c b/drivers/staging/tidspbridge/pmgr/cod.c
index d01fb8e..4007826 100644
--- a/drivers/staging/tidspbridge/pmgr/cod.c
+++ b/drivers/staging/tidspbridge/pmgr/cod.c
@@ -58,8 +58,6 @@ struct cod_libraryobj {
 	struct cod_manager *cod_mgr;
 };
 
-static u32 refs = 0L;
-
 static struct dbll_fxns ldr_fxns = {
 	(dbll_close_fxn) dbll_close,
 	(dbll_create_fxn) dbll_create,
@@ -268,17 +266,6 @@ void cod_delete(struct cod_manager *cod_mgr_obj)
 }
 
 /*
- *  ======== cod_exit ========
- *  Purpose:
- *      Discontinue usage of the COD module.
- *
- */
-void cod_exit(void)
-{
-	refs--;
-}
-
-/*
  *  ======== cod_get_base_lib ========
  *  Purpose:
  *      Get handle to the base image DBL library.
@@ -395,22 +382,6 @@ int cod_get_sym_value(struct cod_manager *cod_mgr_obj, char *str_sym,
 }
 
 /*
- *  ======== cod_init ========
- *  Purpose:
- *      Initialize the COD module's private state.
- *
- */
-bool cod_init(void)
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
  *  ======== cod_load_base ========
  *  Purpose:
  *      Load the initial program image, optionally with command-line arguments,
diff --git a/drivers/staging/tidspbridge/pmgr/dspapi.c b/drivers/staging/tidspbridge/pmgr/dspapi.c
index dcf1dab..971e839 100644
--- a/drivers/staging/tidspbridge/pmgr/dspapi.c
+++ b/drivers/staging/tidspbridge/pmgr/dspapi.c
@@ -267,7 +267,6 @@ void api_exit(void)
 
 	if (api_c_refs == 0) {
 		/* Release all modules initialized in api_init(). */
-		cod_exit();
 		dev_exit();
 		chnl_exit();
 		msg_exit();
@@ -289,7 +288,7 @@ void api_exit(void)
 bool api_init(void)
 {
 	bool ret = true;
-	bool fdev, fcod, fchnl, fmsg, fio;
+	bool fdev, fchnl, fmsg, fio;
 	bool fmgr, fproc, fnode, fdisp, fstrm, frmm;
 
 	if (api_c_refs == 0) {
@@ -304,8 +303,7 @@ bool api_init(void)
 		fmsg = msg_mod_init();
 		fio = io_init();
 		fdev = dev_init();
-		fcod = cod_init();
-		ret = fdev && fchnl && fcod && fmsg && fio;
+		ret = fdev && fchnl && fmsg && fio;
 		ret = ret && fmgr && fproc && frmm;
 		if (!ret) {
 
@@ -336,9 +334,6 @@ bool api_init(void)
 			if (fdev)
 				dev_exit();
 
-			if (fcod)
-				cod_exit();
-
 			if (frmm)
 				rmm_exit();
 
diff --git a/drivers/staging/tidspbridge/rmgr/dbdcd.c b/drivers/staging/tidspbridge/rmgr/dbdcd.c
index 8378b7b..12a1d34 100644
--- a/drivers/staging/tidspbridge/rmgr/dbdcd.c
+++ b/drivers/staging/tidspbridge/rmgr/dbdcd.c
@@ -289,7 +289,6 @@ void dcd_exit(void)
 
 	refs--;
 	if (refs == 0) {
-		cod_exit();
 		list_for_each_entry_safe(rv, rv_tmp, &reg_key_list, link) {
 			list_del(&rv->link);
 			kfree(rv->path);
@@ -738,22 +737,10 @@ int dcd_get_library_name(struct dcd_manager *hdcd_mgr,
  */
 bool dcd_init(void)
 {
-	bool init_cod;
 	bool ret = true;
 
-	if (refs == 0) {
-		/* Initialize required modules. */
-		init_cod = cod_init();
-
-		if (!init_cod) {
-			ret = false;
-			/* Exit initialized modules. */
-			if (init_cod)
-				cod_exit();
-		}
-
+	if (refs == 0)
 		INIT_LIST_HEAD(&reg_key_list);
-	}
 
 	if (ret)
 		refs++;
-- 
1.7.9.1

