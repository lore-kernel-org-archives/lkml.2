Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759268Ab2CIAEo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 19:04:44 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:47122 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757380Ab2CIAEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 19:04:15 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4EAN1HWU9bdWOb/2dsb2JhbABDhTWwe4ILAQUjDwEjIxAlAhgOAgI5AxsGARKIDqgakgWBL44RgRYElUWFZYNchleCZA
X-IronPort-AV: E=Sophos;i="4.73,554,1325458800"; 
   d="scan'208";a="886086922"
From: =?UTF-8?q?V=C3=ADctor=20Manuel=20J=C3=A1quez=20Leal?= 
	<vjaquez@igalia.com>
To: Omar Ramirez Luna <omar.ramirez@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Felipe Contreras <felipe.contreras@nokia.com>,
        linux-omap@vger.kernel.org
Subject: [PATCH 07/17] staging: tidspbridge: remove rmm_init() and rmm_exit()
Date: Fri,  9 Mar 2012 01:03:42 +0100
Message-Id: <0f2a056bd2e36f74bcb51052b48d116e03866d9e.1331250369.git.vjaquez@igalia.com>
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

The rmm module has a rmm_init() and a rmm_exit() whose only purpose is
to keep a reference counting which is not used at all.

This patch removes these functions and the reference count variable.

There is no functional changes.

Signed-off-by: Víctor Manuel Jáquez Leal <vjaquez@igalia.com>
---
 .../staging/tidspbridge/include/dspbridge/rmm.h    |   25 --------------------
 drivers/staging/tidspbridge/pmgr/dspapi.c          |   10 +------
 drivers/staging/tidspbridge/rmgr/nldr.c            |    6 ----
 drivers/staging/tidspbridge/rmgr/rmm.c             |   20 ----------------
 4 files changed, 2 insertions(+), 59 deletions(-)

diff --git a/drivers/staging/tidspbridge/include/dspbridge/rmm.h b/drivers/staging/tidspbridge/include/dspbridge/rmm.h
index baea536..f7a4dc8 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/rmm.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/rmm.h
@@ -115,18 +115,6 @@ extern int rmm_create(struct rmm_target_obj **target_obj,
 extern void rmm_delete(struct rmm_target_obj *target);
 
 /*
- *  ======== rmm_exit ========
- *  Exit the RMM module
- *
- *  Parameters:
- *  Returns:
- *  Requires:
- *      rmm_init successfully called.
- *  Ensures:
- */
-extern void rmm_exit(void);
-
-/*
  *  ======== rmm_free ========
  *  Free or unreserve memory allocated through rmm_alloc().
  *
@@ -148,19 +136,6 @@ extern bool rmm_free(struct rmm_target_obj *target, u32 segid, u32 dsp_addr,
 		     u32 size, bool reserved);
 
 /*
- *  ======== rmm_init ========
- *  Initialize the RMM module
- *
- *  Parameters:
- *  Returns:
- *      TRUE:   Success.
- *      FALSE:  Failure.
- *  Requires:
- *  Ensures:
- */
-extern bool rmm_init(void);
-
-/*
  *  ======== rmm_stat ========
  *  Obtain  memory segment status
  *
diff --git a/drivers/staging/tidspbridge/pmgr/dspapi.c b/drivers/staging/tidspbridge/pmgr/dspapi.c
index 06e3b24..0a55465 100644
--- a/drivers/staging/tidspbridge/pmgr/dspapi.c
+++ b/drivers/staging/tidspbridge/pmgr/dspapi.c
@@ -272,7 +272,6 @@ void api_exit(void)
 		msg_exit();
 		io_exit();
 		mgr_exit();
-		rmm_exit();
 	}
 }
 
@@ -285,18 +284,17 @@ bool api_init(void)
 {
 	bool ret = true;
 	bool fdev, fchnl, fmsg, fio;
-	bool fmgr, frmm;
+	bool fmgr;
 
 	if (api_c_refs == 0) {
 		/* initialize driver and other modules */
 		fmgr = mgr_init();
-		frmm = rmm_init();
 		fchnl = chnl_init();
 		fmsg = msg_mod_init();
 		fio = io_init();
 		fdev = dev_init();
 		ret = fdev && fchnl && fmsg && fio;
-		ret = ret && fmgr && frmm;
+		ret = ret && fmgr;
 		if (!ret) {
 
 			if (fmgr)
@@ -313,10 +311,6 @@ bool api_init(void)
 
 			if (fdev)
 				dev_exit();
-
-			if (frmm)
-				rmm_exit();
-
 		}
 	}
 	if (ret)
diff --git a/drivers/staging/tidspbridge/rmgr/nldr.c b/drivers/staging/tidspbridge/rmgr/nldr.c
index 5cff46f..a9d7a32 100644
--- a/drivers/staging/tidspbridge/rmgr/nldr.c
+++ b/drivers/staging/tidspbridge/rmgr/nldr.c
@@ -628,9 +628,6 @@ void nldr_delete(struct nldr_object *nldr_obj)
 void nldr_exit(void)
 {
 	refs--;
-
-	if (refs == 0)
-		rmm_exit();
 }
 
 /*
@@ -746,9 +743,6 @@ int nldr_get_rmm_manager(struct nldr_object *nldr,
  */
 bool nldr_init(void)
 {
-	if (refs == 0)
-		rmm_init();
-
 	refs++;
 
 	return true;
diff --git a/drivers/staging/tidspbridge/rmgr/rmm.c b/drivers/staging/tidspbridge/rmgr/rmm.c
index 55acfcd..52187bd 100644
--- a/drivers/staging/tidspbridge/rmgr/rmm.c
+++ b/drivers/staging/tidspbridge/rmgr/rmm.c
@@ -80,8 +80,6 @@ struct rmm_target_obj {
 	struct list_head ovly_list;	/* List of overlay memory in use */
 };
 
-static u32 refs;		/* module reference count */
-
 static bool alloc_block(struct rmm_target_obj *target, u32 segid, u32 size,
 			u32 align, u32 *dsp_address);
 static bool free_block(struct rmm_target_obj *target, u32 segid, u32 addr,
@@ -260,14 +258,6 @@ void rmm_delete(struct rmm_target_obj *target)
 }
 
 /*
- *  ======== rmm_exit ========
- */
-void rmm_exit(void)
-{
-	refs--;
-}
-
-/*
  *  ======== rmm_free ========
  */
 bool rmm_free(struct rmm_target_obj *target, u32 segid, u32 dsp_addr, u32 size,
@@ -300,16 +290,6 @@ bool rmm_free(struct rmm_target_obj *target, u32 segid, u32 dsp_addr, u32 size,
 }
 
 /*
- *  ======== rmm_init ========
- */
-bool rmm_init(void)
-{
-	refs++;
-
-	return true;
-}
-
-/*
  *  ======== rmm_stat ========
  */
 bool rmm_stat(struct rmm_target_obj *target, enum dsp_memtype segid,
-- 
1.7.9.1

