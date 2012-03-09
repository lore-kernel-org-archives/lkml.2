Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759502Ab2CIAFe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 19:05:34 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:41263 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759156Ab2CIAEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 19:04:22 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4EAN1HWU9bdWOb/2dsb2JhbABDhTWwe4ILAQUjDwEjIxAlAhgOAgI5AxsGARKIDqgakgWBL44RgRYElUWFZYNchleCZA
X-IronPort-AV: E=Sophos;i="4.73,554,1325458800"; 
   d="scan'208";a="886086956"
From: =?UTF-8?q?V=C3=ADctor=20Manuel=20J=C3=A1quez=20Leal?= 
	<vjaquez@igalia.com>
To: Omar Ramirez Luna <omar.ramirez@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Felipe Contreras <felipe.contreras@nokia.com>,
        linux-omap@vger.kernel.org
Subject: [PATCH 10/17] staging: tidspbridge: remove io_init() and io_exit()
Date: Fri,  9 Mar 2012 01:03:45 +0100
Message-Id: <059463ad3da393eb5dd45c6069095dfdef1a93b3.1331250369.git.vjaquez@igalia.com>
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

The io module has a io_init() and a io_exit() whose only purpose is to
keep a reference counting which is not used at all.

This patch removes these functions and the reference count variable.

There is no functional changes.

Signed-off-by: Víctor Manuel Jáquez Leal <vjaquez@igalia.com>
---
 drivers/staging/tidspbridge/include/dspbridge/io.h |   29 --------------------
 drivers/staging/tidspbridge/pmgr/dspapi.c          |   10 +-----
 drivers/staging/tidspbridge/pmgr/io.c              |   28 -------------------
 3 files changed, 2 insertions(+), 65 deletions(-)

diff --git a/drivers/staging/tidspbridge/include/dspbridge/io.h b/drivers/staging/tidspbridge/include/dspbridge/io.h
index 500bbd7..7505718 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/io.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/io.h
@@ -55,7 +55,6 @@ struct io_attrs {
  *      -EINVAL: Invalid DSP word size (must be > 0).
  *               Invalid base address for DSP communications.
  *  Requires:
- *      io_init(void) called.
  *      io_man != NULL.
  *      mgr_attrts != NULL.
  *  Ensures:
@@ -74,36 +73,8 @@ extern int io_create(struct io_mgr **io_man,
  *      0:        Success.
  *      -EFAULT:    hio_mgr was invalid.
  *  Requires:
- *      io_init(void) called.
  *  Ensures:
  */
 extern int io_destroy(struct io_mgr *hio_mgr);
 
-/*
- *  ======== io_exit ========
- *  Purpose:
- *      Discontinue usage of the IO module.
- *  Parameters:
- *  Returns:
- *  Requires:
- *      io_init(void) previously called.
- *  Ensures:
- *      Resources, if any acquired in io_init(void), are freed when the last
- *      client of IO calls io_exit(void).
- */
-extern void io_exit(void);
-
-/*
- *  ======== io_init ========
- *  Purpose:
- *      Initialize the IO module's private state.
- *  Parameters:
- *  Returns:
- *      TRUE if initialized; FALSE if error occurred.
- *  Requires:
- *  Ensures:
- *      A requirement for each of the other public CHNL functions.
- */
-extern bool io_init(void);
-
 #endif /* CHNL_ */
diff --git a/drivers/staging/tidspbridge/pmgr/dspapi.c b/drivers/staging/tidspbridge/pmgr/dspapi.c
index 5201bed..b9ca24c 100644
--- a/drivers/staging/tidspbridge/pmgr/dspapi.c
+++ b/drivers/staging/tidspbridge/pmgr/dspapi.c
@@ -268,7 +268,6 @@ void api_exit(void)
 	if (api_c_refs == 0) {
 		/* Release all modules initialized in api_init(). */
 		dev_exit();
-		io_exit();
 		mgr_exit();
 	}
 }
@@ -281,24 +280,19 @@ void api_exit(void)
 bool api_init(void)
 {
 	bool ret = true;
-	bool fdev, fio;
+	bool fdev;
 	bool fmgr;
 
 	if (api_c_refs == 0) {
 		/* initialize driver and other modules */
 		fmgr = mgr_init();
-		fio = io_init();
 		fdev = dev_init();
-		ret = fdev && fio;
-		ret = ret && fmgr;
+		ret = fdev && fmgr;
 		if (!ret) {
 
 			if (fmgr)
 				mgr_exit();
 
-			if (fio)
-				io_exit();
-
 			if (fdev)
 				dev_exit();
 		}
diff --git a/drivers/staging/tidspbridge/pmgr/io.c b/drivers/staging/tidspbridge/pmgr/io.c
index a56b085..4073c9c 100644
--- a/drivers/staging/tidspbridge/pmgr/io.c
+++ b/drivers/staging/tidspbridge/pmgr/io.c
@@ -30,9 +30,6 @@
 #include <ioobj.h>
 #include <dspbridge/io.h>
 
-/*  ----------------------------------- Globals */
-static u32 refs;
-
 /*
  *  ======== io_create ========
  *  Purpose:
@@ -94,28 +91,3 @@ int io_destroy(struct io_mgr *hio_mgr)
 
 	return status;
 }
-
-/*
- *  ======== io_exit ========
- *  Purpose:
- *      Discontinue usage of the IO module.
- */
-void io_exit(void)
-{
-	refs--;
-}
-
-/*
- *  ======== io_init ========
- *  Purpose:
- *      Initialize the IO module's private state.
- */
-bool io_init(void)
-{
-	bool ret = true;
-
-	if (ret)
-		refs++;
-
-	return ret;
-}
-- 
1.7.9.1

