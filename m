Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759396Ab2CIAE7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 19:04:59 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:47122 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757684Ab2CIAER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 19:04:17 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4EAN1HWU9bdWOb/2dsb2JhbABDhTWwe4ILAQUjDwEUDyMQJQIYDgICOQMKEQYBEogOqBqDaI4dgS+OEYEWBJVFhWWDXIZXgmQ
X-IronPort-AV: E=Sophos;i="4.73,554,1325458800"; 
   d="scan'208";a="886086924"
From: =?UTF-8?q?V=C3=ADctor=20Manuel=20J=C3=A1quez=20Leal?= 
	<vjaquez@igalia.com>
To: Omar Ramirez Luna <omar.ramirez@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Felipe Contreras <felipe.contreras@nokia.com>,
        linux-omap@vger.kernel.org
Subject: [PATCH 06/17] staging: tidspbridge: remove strm_init() and strm_exit()
Date: Fri,  9 Mar 2012 01:03:41 +0100
Message-Id: <138b2320c575412209b10dd098dce7107e4a945c.1331250369.git.vjaquez@igalia.com>
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

The strm module has a strm_init() and a strm_exit() whose only purpose
is to keep a reference counting which is not used at all.

This patch removes these functions and the reference count variable.

There is no functional changes.

Signed-off-by: Víctor Manuel Jáquez Leal <vjaquez@igalia.com>
---
 .../staging/tidspbridge/include/dspbridge/strm.h   |   38 +-------------------
 drivers/staging/tidspbridge/pmgr/dspapi.c          |    7 +---
 drivers/staging/tidspbridge/rmgr/strm.c            |   28 --------------
 3 files changed, 2 insertions(+), 71 deletions(-)

diff --git a/drivers/staging/tidspbridge/include/dspbridge/strm.h b/drivers/staging/tidspbridge/include/dspbridge/strm.h
index 613fe53..dacf0c23 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/strm.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/strm.h
@@ -40,7 +40,6 @@
  *      -EPERM:      Failure occurred, unable to allocate buffers.
  *      -EINVAL:      usize must be > 0 bytes.
  *  Requires:
- *      strm_init(void) called.
  *      ap_buffer != NULL.
  *  Ensures:
  */
@@ -63,7 +62,6 @@ extern int strm_allocate_buffer(struct strm_res_object *strmres,
  *                      been reclaimed.
  *      -EPERM:      Failure to close stream.
  *  Requires:
- *      strm_init(void) called.
  *  Ensures:
  */
 extern int strm_close(struct strm_res_object *strmres,
@@ -83,7 +81,6 @@ extern int strm_close(struct strm_res_object *strmres,
  *      -ENOMEM:    Insufficient memory for requested resources.
  *      -EPERM:      General failure.
  *  Requires:
- *      strm_init(void) called.
  *      strm_man != NULL.
  *      dev_obj != NULL.
  *  Ensures:
@@ -101,7 +98,6 @@ extern int strm_create(struct strm_mgr **strm_man,
  *      strm_mgr_obj:       Handle to STRM manager object from strm_create.
  *  Returns:
  *  Requires:
- *      strm_init(void) called.
  *      Valid strm_mgr_obj.
  *  Ensures:
  *      strm_mgr_obj is not valid.
@@ -109,18 +105,6 @@ extern int strm_create(struct strm_mgr **strm_man,
 extern void strm_delete(struct strm_mgr *strm_mgr_obj);
 
 /*
- *  ======== strm_exit ========
- *  Purpose:
- *      Discontinue usage of STRM module.
- *  Parameters:
- *  Returns:
- *  Requires:
- *      strm_init(void) successfully called before.
- *  Ensures:
- */
-extern void strm_exit(void);
-
-/*
  *  ======== strm_free_buffer ========
  *  Purpose:
  *      Free buffer(s) allocated with strm_allocate_buffer.
@@ -133,7 +117,6 @@ extern void strm_exit(void);
  *      -EFAULT:    Invalid stream handle.
  *      -EPERM:      Failure occurred, unable to free buffers.
  *  Requires:
- *      strm_init(void) called.
  *      ap_buffer != NULL.
  *  Ensures:
  */
@@ -156,7 +139,6 @@ extern int strm_free_buffer(struct strm_res_object *strmres,
  *      -EINVAL:          stream_info_size < sizeof(dsp_streaminfo).
  *      -EPERM:          Unable to get stream info.
  *  Requires:
- *      strm_init(void) called.
  *      stream_info != NULL.
  *  Ensures:
  */
@@ -184,24 +166,11 @@ extern int strm_get_info(struct strm_object *stream_obj,
  *      -ETIME:   A timeout occurred before the stream could be idled.
  *      -EPERM:      Unable to idle stream.
  *  Requires:
- *      strm_init(void) called.
  *  Ensures:
  */
 extern int strm_idle(struct strm_object *stream_obj, bool flush_data);
 
 /*
- *  ======== strm_init ========
- *  Purpose:
- *      Initialize the STRM module.
- *  Parameters:
- *  Returns:
- *      TRUE if initialization succeeded, FALSE otherwise.
- *  Requires:
- *  Ensures:
- */
-extern bool strm_init(void);
-
-/*
  *  ======== strm_issue ========
  *  Purpose:
  *      Send a buffer of data to a stream.
@@ -217,8 +186,7 @@ extern bool strm_init(void);
  *      -ENOSR:    The stream is full.
  *      -EPERM:          Failure occurred, unable to issue buffer.
  *  Requires:
- *      strm_init(void) called.
- *      pbuf != NULL.
+*      pbuf != NULL.
  *  Ensures:
  */
 extern int strm_issue(struct strm_object *stream_obj, u8 * pbuf,
@@ -244,7 +212,6 @@ extern int strm_issue(struct strm_object *stream_obj, u8 * pbuf,
  *              Unable to open stream.
  *      -EINVAL:     Invalid index.
  *  Requires:
- *      strm_init(void) called.
  *      strmres != NULL.
  *      pattr != NULL.
  *  Ensures:
@@ -275,7 +242,6 @@ extern int strm_open(struct node_object *hnode, u32 dir,
  *                      retrieved.
  *      -EPERM:      Failure occurred, unable to reclaim buffer.
  *  Requires:
- *      strm_init(void) called.
  *      buf_ptr != NULL.
  *      nbytes != NULL.
  *      pdw_arg != NULL.
@@ -302,7 +268,6 @@ extern int strm_reclaim(struct strm_object *stream_obj,
  *      -ENOSYS:   Notification type specified by notify_type is not
  *                      supported.
  *  Requires:
- *      strm_init(void) called.
  *      hnotification != NULL.
  *  Ensures:
  */
@@ -328,7 +293,6 @@ extern int strm_register_notify(struct strm_object *stream_obj,
  *      -ETIME:   A timeout occurred before a stream became ready.
  *      -EPERM:      Failure occurred, unable to select a stream.
  *  Requires:
- *      strm_init(void) called.
  *      strm_tab != NULL.
  *      strms > 0.
  *      pmask != NULL.
diff --git a/drivers/staging/tidspbridge/pmgr/dspapi.c b/drivers/staging/tidspbridge/pmgr/dspapi.c
index b1a99f7..06e3b24 100644
--- a/drivers/staging/tidspbridge/pmgr/dspapi.c
+++ b/drivers/staging/tidspbridge/pmgr/dspapi.c
@@ -271,7 +271,6 @@ void api_exit(void)
 		chnl_exit();
 		msg_exit();
 		io_exit();
-		strm_exit();
 		mgr_exit();
 		rmm_exit();
 	}
@@ -286,12 +285,11 @@ bool api_init(void)
 {
 	bool ret = true;
 	bool fdev, fchnl, fmsg, fio;
-	bool fmgr, fstrm, frmm;
+	bool fmgr, frmm;
 
 	if (api_c_refs == 0) {
 		/* initialize driver and other modules */
 		fmgr = mgr_init();
-		fstrm = strm_init();
 		frmm = rmm_init();
 		fchnl = chnl_init();
 		fmsg = msg_mod_init();
@@ -304,9 +302,6 @@ bool api_init(void)
 			if (fmgr)
 				mgr_exit();
 
-			if (fstrm)
-				strm_exit();
-
 			if (fchnl)
 				chnl_exit();
 
diff --git a/drivers/staging/tidspbridge/rmgr/strm.c b/drivers/staging/tidspbridge/rmgr/strm.c
index bd684f1..34cc934 100644
--- a/drivers/staging/tidspbridge/rmgr/strm.c
+++ b/drivers/staging/tidspbridge/rmgr/strm.c
@@ -81,9 +81,6 @@ struct strm_object {
 	struct cmm_xlatorobject *xlator;
 };
 
-/*  ----------------------------------- Globals */
-static u32 refs;		/* module reference count */
-
 /*  ----------------------------------- Function Prototypes */
 static int delete_strm(struct strm_object *stream_obj);
 
@@ -222,16 +219,6 @@ void strm_delete(struct strm_mgr *strm_mgr_obj)
 }
 
 /*
- *  ======== strm_exit ========
- *  Purpose:
- *      Discontinue usage of STRM module.
- */
-void strm_exit(void)
-{
-	refs--;
-}
-
-/*
  *  ======== strm_free_buffer ========
  *  Purpose:
  *      Frees the buffers allocated for a stream.
@@ -350,21 +337,6 @@ int strm_idle(struct strm_object *stream_obj, bool flush_data)
 }
 
 /*
- *  ======== strm_init ========
- *  Purpose:
- *      Initialize the STRM module.
- */
-bool strm_init(void)
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
  *  ======== strm_issue ========
  *  Purpose:
  *      Issues a buffer on a stream
-- 
1.7.9.1

