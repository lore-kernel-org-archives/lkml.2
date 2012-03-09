Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759347Ab2CIAEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 19:04:53 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:41263 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757417Ab2CIAEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 19:04:16 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4EAN1HWU9bdWOb/2dsb2JhbABDhTWwe4ILAQUjDwEjIxAlAhgOAgI5AxsGARKIDqgakgWBL44RgRYElUWFZYNchleCZIFTBA
X-IronPort-AV: E=Sophos;i="4.73,554,1325458800"; 
   d="scan'208";a="886086923"
From: =?UTF-8?q?V=C3=ADctor=20Manuel=20J=C3=A1quez=20Leal?= 
	<vjaquez@igalia.com>
To: Omar Ramirez Luna <omar.ramirez@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Felipe Contreras <felipe.contreras@nokia.com>,
        linux-omap@vger.kernel.org
Subject: [PATCH 08/17] staging: tidspbridge: remove chnl_init() and chnl_exit()
Date: Fri,  9 Mar 2012 01:03:43 +0100
Message-Id: <a96eeca3f77108d6d839327f8d7521f0dd2035be.1331250369.git.vjaquez@igalia.com>
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

The chnl module has a chnl_init() and a chnl_exit() whose only purpose
is to keep a reference counting which is not used at all.

This patch removes these functions and the reference count variable.

There is no functional changes.

Signed-off-by: Víctor Manuel Jáquez Leal <vjaquez@igalia.com>
---
 .../staging/tidspbridge/include/dspbridge/chnl.h   |   29 --------------------
 drivers/staging/tidspbridge/pmgr/chnl.c            |   28 -------------------
 drivers/staging/tidspbridge/pmgr/dspapi.c          |    9 +-----
 3 files changed, 2 insertions(+), 64 deletions(-)

diff --git a/drivers/staging/tidspbridge/include/dspbridge/chnl.h b/drivers/staging/tidspbridge/include/dspbridge/chnl.h
index 92f6a13..9b018b1 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/chnl.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/chnl.h
@@ -48,7 +48,6 @@
  *      -ECHRNG:     This manager cannot handle this many channels.
  *      -EEXIST:       Channel manager already exists for this device.
  *  Requires:
- *      chnl_init(void) called.
  *      channel_mgr != NULL.
  *      mgr_attrts != NULL.
  *  Ensures:
@@ -70,7 +69,6 @@ extern int chnl_create(struct chnl_mgr **channel_mgr,
  *      0:            Success.
  *      -EFAULT:        hchnl_mgr was invalid.
  *  Requires:
- *      chnl_init(void) called.
  *  Ensures:
  *      0:            Cancels I/O on each open channel.
  *                          Closes each open channel.
@@ -79,31 +77,4 @@ extern int chnl_create(struct chnl_mgr **channel_mgr,
  */
 extern int chnl_destroy(struct chnl_mgr *hchnl_mgr);
 
-/*
- *  ======== chnl_exit ========
- *  Purpose:
- *      Discontinue usage of the CHNL module.
- *  Parameters:
- *  Returns:
- *  Requires:
- *      chnl_init(void) previously called.
- *  Ensures:
- *      Resources, if any acquired in chnl_init(void), are freed when the last
- *      client of CHNL calls chnl_exit(void).
- */
-extern void chnl_exit(void);
-
-/*
- *  ======== chnl_init ========
- *  Purpose:
- *      Initialize the CHNL module's private state.
- *  Parameters:
- *  Returns:
- *      TRUE if initialized; FALSE if error occurred.
- *  Requires:
- *  Ensures:
- *      A requirement for each of the other public CHNL functions.
- */
-extern bool chnl_init(void);
-
 #endif /* CHNL_ */
diff --git a/drivers/staging/tidspbridge/pmgr/chnl.c b/drivers/staging/tidspbridge/pmgr/chnl.c
index 825be20..4bd8686 100644
--- a/drivers/staging/tidspbridge/pmgr/chnl.c
+++ b/drivers/staging/tidspbridge/pmgr/chnl.c
@@ -38,9 +38,6 @@
 /*  ----------------------------------- This */
 #include <dspbridge/chnl.h>
 
-/*  ----------------------------------- Globals */
-static u32 refs;
-
 /*
  *  ======== chnl_create ========
  *  Purpose:
@@ -116,28 +113,3 @@ int chnl_destroy(struct chnl_mgr *hchnl_mgr)
 
 	return status;
 }
-
-/*
- *  ======== chnl_exit ========
- *  Purpose:
- *      Discontinue usage of the CHNL module.
- */
-void chnl_exit(void)
-{
-	refs--;
-}
-
-/*
- *  ======== chnl_init ========
- *  Purpose:
- *      Initialize the CHNL module's private state.
- */
-bool chnl_init(void)
-{
-	bool ret = true;
-
-	if (ret)
-		refs++;
-
-	return ret;
-}
diff --git a/drivers/staging/tidspbridge/pmgr/dspapi.c b/drivers/staging/tidspbridge/pmgr/dspapi.c
index 0a55465..5b9dcad 100644
--- a/drivers/staging/tidspbridge/pmgr/dspapi.c
+++ b/drivers/staging/tidspbridge/pmgr/dspapi.c
@@ -268,7 +268,6 @@ void api_exit(void)
 	if (api_c_refs == 0) {
 		/* Release all modules initialized in api_init(). */
 		dev_exit();
-		chnl_exit();
 		msg_exit();
 		io_exit();
 		mgr_exit();
@@ -283,26 +282,22 @@ void api_exit(void)
 bool api_init(void)
 {
 	bool ret = true;
-	bool fdev, fchnl, fmsg, fio;
+	bool fdev, fmsg, fio;
 	bool fmgr;
 
 	if (api_c_refs == 0) {
 		/* initialize driver and other modules */
 		fmgr = mgr_init();
-		fchnl = chnl_init();
 		fmsg = msg_mod_init();
 		fio = io_init();
 		fdev = dev_init();
-		ret = fdev && fchnl && fmsg && fio;
+		ret = fdev && fmsg && fio;
 		ret = ret && fmgr;
 		if (!ret) {
 
 			if (fmgr)
 				mgr_exit();
 
-			if (fchnl)
-				chnl_exit();
-
 			if (fmsg)
 				msg_exit();
 
-- 
1.7.9.1

