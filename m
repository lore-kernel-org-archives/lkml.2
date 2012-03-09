Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465Ab2CIAFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 19:05:20 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:41263 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758630Ab2CIAEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 19:04:20 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4EAN1HWU9bdWOb/2dsb2JhbABDhTWwe4ILAQUjDwEjIxAlAhgOAgI5AxsGARKIDqgakgWBL44RgRYElUWFZYNchleCZA
X-IronPort-AV: E=Sophos;i="4.73,554,1325458800"; 
   d="scan'208";a="886086952"
From: =?UTF-8?q?V=C3=ADctor=20Manuel=20J=C3=A1quez=20Leal?= 
	<vjaquez@igalia.com>
To: Omar Ramirez Luna <omar.ramirez@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Felipe Contreras <felipe.contreras@nokia.com>,
        linux-omap@vger.kernel.org
Subject: [PATCH 13/17] staging: tidspbridge: remove dev_init() and dev_exit()
Date: Fri,  9 Mar 2012 01:03:48 +0100
Message-Id: <3e2fd084f9cb97370f666142ddb88e869f26bf24.1331250369.git.vjaquez@igalia.com>
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

The dev module has a dev_init() and a dev_exit() whose only purpose is
to keep a reference counting which is not used at all.

This patch removes these functions and the reference count variable.

There is no functional changes.

Signed-off-by: Víctor Manuel Jáquez Leal <vjaquez@igalia.com>
---
 .../staging/tidspbridge/include/dspbridge/dev.h    |   27 ------------------
 drivers/staging/tidspbridge/pmgr/dev.c             |   29 --------------------
 drivers/staging/tidspbridge/pmgr/dspapi.c          |   22 ++-------------
 3 files changed, 3 insertions(+), 75 deletions(-)

diff --git a/drivers/staging/tidspbridge/include/dspbridge/dev.h b/drivers/staging/tidspbridge/include/dspbridge/dev.h
index f92b4be..fa2d79e 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dev.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dev.h
@@ -478,33 +478,6 @@ extern int dev_get_bridge_context(struct dev_object *hdev_obj,
 				      **phbridge_context);
 
 /*
- *  ======== dev_exit ========
- *  Purpose:
- *      Decrement reference count, and free resources when reference count is
- *      0.
- *  Parameters:
- *  Returns:
- *  Requires:
- *      DEV is initialized.
- *  Ensures:
- *      When reference count == 0, DEV's private resources are freed.
- */
-extern void dev_exit(void);
-
-/*
- *  ======== dev_init ========
- *  Purpose:
- *      Initialize DEV's private state, keeping a reference count on each call.
- *  Parameters:
- *  Returns:
- *      TRUE if initialized; FALSE if error occurred.
- *  Requires:
- *  Ensures:
- *      TRUE: A requirement for the other public DEV functions.
- */
-extern bool dev_init(void);
-
-/*
  *  ======== dev_insert_proc_object ========
  *  Purpose:
  *      Inserts the Processor Object into the List of PROC Objects
diff --git a/drivers/staging/tidspbridge/pmgr/dev.c b/drivers/staging/tidspbridge/pmgr/dev.c
index c5e627c..6234ffb 100644
--- a/drivers/staging/tidspbridge/pmgr/dev.c
+++ b/drivers/staging/tidspbridge/pmgr/dev.c
@@ -81,9 +81,6 @@ struct drv_ext {
 	char sz_string[MAXREGPATHLENGTH];
 };
 
-/*  ----------------------------------- Globals */
-static u32 refs;		/* Module reference count */
-
 /*  ----------------------------------- Function Prototypes */
 static int fxn_not_implemented(int arg, ...);
 static int init_cod_mgr(struct dev_object *dev_obj);
@@ -649,32 +646,6 @@ int dev_get_bridge_context(struct dev_object *hdev_obj,
 }
 
 /*
- *  ======== dev_exit ========
- *  Purpose:
- *      Decrement reference count, and free resources when reference count is
- *      0.
- */
-void dev_exit(void)
-{
-	refs--;
-}
-
-/*
- *  ======== dev_init ========
- *  Purpose:
- *      Initialize DEV's private state, keeping a reference count on each call.
- */
-bool dev_init(void)
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
  *  ======== dev_notify_clients ========
  *  Purpose:
  *      Notify all clients of this device of a change in device status.
diff --git a/drivers/staging/tidspbridge/pmgr/dspapi.c b/drivers/staging/tidspbridge/pmgr/dspapi.c
index b9ca24c..9ef1ad9 100644
--- a/drivers/staging/tidspbridge/pmgr/dspapi.c
+++ b/drivers/staging/tidspbridge/pmgr/dspapi.c
@@ -265,11 +265,8 @@ void api_exit(void)
 {
 	api_c_refs--;
 
-	if (api_c_refs == 0) {
-		/* Release all modules initialized in api_init(). */
-		dev_exit();
+	if (api_c_refs == 0)
 		mgr_exit();
-	}
 }
 
 /*
@@ -280,23 +277,10 @@ void api_exit(void)
 bool api_init(void)
 {
 	bool ret = true;
-	bool fdev;
-	bool fmgr;
-
-	if (api_c_refs == 0) {
-		/* initialize driver and other modules */
-		fmgr = mgr_init();
-		fdev = dev_init();
-		ret = fdev && fmgr;
-		if (!ret) {
 
-			if (fmgr)
-				mgr_exit();
+	if (api_c_refs == 0)
+		ret = mgr_init();
 
-			if (fdev)
-				dev_exit();
-		}
-	}
 	if (ret)
 		api_c_refs++;
 
-- 
1.7.9.1

