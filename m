Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189Ab2CIAFM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 19:05:12 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:47122 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935Ab2CIAEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 19:04:11 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4EAN1HWU9bdWOb/2dsb2JhbABDhTWwe4ILAQUjDwEjIxAlAhgOAgI5AxsGARKIDqgakgWBL44RgRYElUWFZYNchleCZA
X-IronPort-AV: E=Sophos;i="4.73,554,1325458800"; 
   d="scan'208";a="886086917"
From: =?UTF-8?q?V=C3=ADctor=20Manuel=20J=C3=A1quez=20Leal?= 
	<vjaquez@igalia.com>
To: Omar Ramirez Luna <omar.ramirez@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Felipe Contreras <felipe.contreras@nokia.com>,
        linux-omap@vger.kernel.org
Subject: [PATCH 03/17] staging: tidspbridge: remove proc_init() and proc_exit()
Date: Fri,  9 Mar 2012 01:03:38 +0100
Message-Id: <a7496c4b97282c041bdf9fe04cf4ed9441688179.1331250369.git.vjaquez@igalia.com>
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

The proc module has a proc_init() and a proc_exit() whose only purpose
is to keep a reference counting which is not used at all.

This patch removes these functions and the reference count variable.

There is no functional changes.

Signed-off-by: Víctor Manuel Jáquez Leal <vjaquez@igalia.com>
---
 .../staging/tidspbridge/include/dspbridge/proc.h   |   28 --------------------
 drivers/staging/tidspbridge/pmgr/dspapi.c          |    9 +-----
 drivers/staging/tidspbridge/rmgr/proc.c            |   28 --------------------
 3 files changed, 2 insertions(+), 63 deletions(-)

diff --git a/drivers/staging/tidspbridge/include/dspbridge/proc.h b/drivers/staging/tidspbridge/include/dspbridge/proc.h
index f00dffd..a82380e 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/proc.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/proc.h
@@ -189,20 +189,6 @@ extern int proc_get_resource_info(void *hprocessor,
 					 u32 resource_info_size);
 
 /*
- *  ======== proc_exit ========
- *  Purpose:
- *      Decrement reference count, and free resources when reference count is
- *      0.
- *  Parameters:
- *  Returns:
- *  Requires:
- *      PROC is initialized.
- *  Ensures:
- *      When reference count == 0, PROC's private resources are freed.
- */
-extern void proc_exit(void);
-
-/*
  * ======== proc_get_dev_object =========
  *  Purpose:
  *      Returns the DEV Hanlde for a given Processor handle
@@ -223,20 +209,6 @@ extern int proc_get_dev_object(void *hprocessor,
 				      struct dev_object **device_obj);
 
 /*
- *  ======== proc_init ========
- *  Purpose:
- *      Initialize PROC's private state, keeping a reference count on each
- *      call.
- *  Parameters:
- *  Returns:
- *      TRUE if initialized; FALSE if error occurred.
- *  Requires:
- *  Ensures:
- *      TRUE: A requirement for the other public PROC functions.
- */
-extern bool proc_init(void);
-
-/*
  *  ======== proc_get_state ========
  *  Purpose:
  *      Report the state of the specified DSP processor.
diff --git a/drivers/staging/tidspbridge/pmgr/dspapi.c b/drivers/staging/tidspbridge/pmgr/dspapi.c
index 971e839..7c20a0f 100644
--- a/drivers/staging/tidspbridge/pmgr/dspapi.c
+++ b/drivers/staging/tidspbridge/pmgr/dspapi.c
@@ -274,7 +274,6 @@ void api_exit(void)
 		strm_exit();
 		disp_exit();
 		node_exit();
-		proc_exit();
 		mgr_exit();
 		rmm_exit();
 	}
@@ -289,12 +288,11 @@ bool api_init(void)
 {
 	bool ret = true;
 	bool fdev, fchnl, fmsg, fio;
-	bool fmgr, fproc, fnode, fdisp, fstrm, frmm;
+	bool fmgr, fnode, fdisp, fstrm, frmm;
 
 	if (api_c_refs == 0) {
 		/* initialize driver and other modules */
 		fmgr = mgr_init();
-		fproc = proc_init();
 		fnode = node_init();
 		fdisp = disp_init();
 		fstrm = strm_init();
@@ -304,7 +302,7 @@ bool api_init(void)
 		fio = io_init();
 		fdev = dev_init();
 		ret = fdev && fchnl && fmsg && fio;
-		ret = ret && fmgr && fproc && frmm;
+		ret = ret && fmgr && frmm;
 		if (!ret) {
 
 			if (fmgr)
@@ -313,9 +311,6 @@ bool api_init(void)
 			if (fstrm)
 				strm_exit();
 
-			if (fproc)
-				proc_exit();
-
 			if (fnode)
 				node_exit();
 
diff --git a/drivers/staging/tidspbridge/rmgr/proc.c b/drivers/staging/tidspbridge/rmgr/proc.c
index b865d64..7e4f12f 100644
--- a/drivers/staging/tidspbridge/rmgr/proc.c
+++ b/drivers/staging/tidspbridge/rmgr/proc.c
@@ -98,8 +98,6 @@ struct proc_object {
 	struct list_head proc_list;
 };
 
-static u32 refs;
-
 DEFINE_MUTEX(proc_lock);	/* For critical sections */
 
 /*  ----------------------------------- Function Prototypes */
@@ -909,17 +907,6 @@ func_end:
 }
 
 /*
- *  ======== proc_exit ========
- *  Purpose:
- *      Decrement reference count, and free resources when reference count is
- *      0.
- */
-void proc_exit(void)
-{
-	refs--;
-}
-
-/*
  *  ======== proc_get_dev_object ========
  *  Purpose:
  *      Return the Dev Object handle for a given Processor.
@@ -1010,21 +997,6 @@ int proc_get_trace(void *hprocessor, u8 * pbuf, u32 max_size)
 }
 
 /*
- *  ======== proc_init ========
- *  Purpose:
- *      Initialize PROC's private state, keeping a reference count on each call
- */
-bool proc_init(void)
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
  *  ======== proc_load ========
  *  Purpose:
  *      Reset a processor and load a new base program image.
-- 
1.7.9.1

