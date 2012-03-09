Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759371Ab2CIAE4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 19:04:56 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:31437 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757477Ab2CIAEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 19:04:16 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4EAN1HWU9bdWOb/2dsb2JhbABDhTWwe4ILAQUjDwEjIxAlAhgOAgI5AxsGARKIDqgakgWBL44RgRYElUWFZYNchleCZA
X-IronPort-AV: E=Sophos;i="4.73,554,1325458800"; 
   d="scan'208";a="886086925"
From: =?UTF-8?q?V=C3=ADctor=20Manuel=20J=C3=A1quez=20Leal?= 
	<vjaquez@igalia.com>
To: Omar Ramirez Luna <omar.ramirez@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Felipe Contreras <felipe.contreras@nokia.com>,
        linux-omap@vger.kernel.org
Subject: [PATCH 09/17] staging: tidspbridge: remove msg_mod_init() and msg_exit()
Date: Fri,  9 Mar 2012 01:03:44 +0100
Message-Id: <8d005b6699a0656a581c3a3e9c03d2087ef64008.1331250369.git.vjaquez@igalia.com>
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

The msg module has a msg_mod_init() and a msg_exit() whose only
purpose is to keep a reference counting which is not used at all.

This patch removes these functions and the reference count variable.

There is no functional changes.

Signed-off-by: Víctor Manuel Jáquez Leal <vjaquez@igalia.com>
---
 .../staging/tidspbridge/include/dspbridge/msg.h    |   27 --------------------
 drivers/staging/tidspbridge/pmgr/dspapi.c          |    9 +-----
 drivers/staging/tidspbridge/pmgr/msg.c             |   21 ---------------
 3 files changed, 2 insertions(+), 55 deletions(-)

diff --git a/drivers/staging/tidspbridge/include/dspbridge/msg.h b/drivers/staging/tidspbridge/include/dspbridge/msg.h
index 95778bc..2c8712c 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/msg.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/msg.h
@@ -34,7 +34,6 @@
  *      msg_callback:        Called whenever an RMS_EXIT message is received.
  *  Returns:
  *  Requires:
- *      msg_mod_init(void) called.
  *      msg_man != NULL.
  *      hdev_obj != NULL.
  *      msg_callback != NULL.
@@ -52,35 +51,9 @@ extern int msg_create(struct msg_mgr **msg_man,
  *      hmsg_mgr:            Handle returned from msg_create().
  *  Returns:
  *  Requires:
- *      msg_mod_init(void) called.
  *      Valid hmsg_mgr.
  *  Ensures:
  */
 extern void msg_delete(struct msg_mgr *hmsg_mgr);
 
-/*
- *  ======== msg_exit ========
- *  Purpose:
- *      Discontinue usage of msg_ctrl module.
- *  Parameters:
- *  Returns:
- *  Requires:
- *      msg_mod_init(void) successfully called before.
- *  Ensures:
- *      Any resources acquired in msg_mod_init(void) will be freed when last
- *      msg_ctrl client calls msg_exit(void).
- */
-extern void msg_exit(void);
-
-/*
- *  ======== msg_mod_init ========
- *  Purpose:
- *      Initialize the msg_ctrl module.
- *  Parameters:
- *  Returns:
- *      TRUE if initialization succeeded, FALSE otherwise.
- *  Ensures:
- */
-extern bool msg_mod_init(void);
-
 #endif /* MSG_ */
diff --git a/drivers/staging/tidspbridge/pmgr/dspapi.c b/drivers/staging/tidspbridge/pmgr/dspapi.c
index 5b9dcad..5201bed 100644
--- a/drivers/staging/tidspbridge/pmgr/dspapi.c
+++ b/drivers/staging/tidspbridge/pmgr/dspapi.c
@@ -268,7 +268,6 @@ void api_exit(void)
 	if (api_c_refs == 0) {
 		/* Release all modules initialized in api_init(). */
 		dev_exit();
-		msg_exit();
 		io_exit();
 		mgr_exit();
 	}
@@ -282,25 +281,21 @@ void api_exit(void)
 bool api_init(void)
 {
 	bool ret = true;
-	bool fdev, fmsg, fio;
+	bool fdev, fio;
 	bool fmgr;
 
 	if (api_c_refs == 0) {
 		/* initialize driver and other modules */
 		fmgr = mgr_init();
-		fmsg = msg_mod_init();
 		fio = io_init();
 		fdev = dev_init();
-		ret = fdev && fmsg && fio;
+		ret = fdev && fio;
 		ret = ret && fmgr;
 		if (!ret) {
 
 			if (fmgr)
 				mgr_exit();
 
-			if (fmsg)
-				msg_exit();
-
 			if (fio)
 				io_exit();
 
diff --git a/drivers/staging/tidspbridge/pmgr/msg.c b/drivers/staging/tidspbridge/pmgr/msg.c
index 077c118..f093cfb 100644
--- a/drivers/staging/tidspbridge/pmgr/msg.c
+++ b/drivers/staging/tidspbridge/pmgr/msg.c
@@ -33,9 +33,6 @@
 #include <msgobj.h>
 #include <dspbridge/msg.h>
 
-/*  ----------------------------------- Globals */
-static u32 refs;		/* module reference count */
-
 /*
  *  ======== msg_create ========
  *  Purpose:
@@ -92,21 +89,3 @@ void msg_delete(struct msg_mgr *hmsg_mgr)
 			__func__, hmsg_mgr);
 	}
 }
-
-/*
- *  ======== msg_exit ========
- */
-void msg_exit(void)
-{
-	refs--;
-}
-
-/*
- *  ======== msg_mod_init ========
- */
-bool msg_mod_init(void)
-{
-	refs++;
-
-	return true;
-}
-- 
1.7.9.1

