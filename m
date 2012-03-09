Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759318Ab2CIAEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 19:04:50 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:41263 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757019Ab2CIAEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 19:04:14 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4EAN1HWU9bdWOb/2dsb2JhbABDhTWwe4ILAQUjDwEUDyMQJQIYDgICOQMbBgESiA6oGoNojh2BL44RgRYElUWFZYNchleCZA
X-IronPort-AV: E=Sophos;i="4.73,554,1325458800"; 
   d="scan'208";a="886086920"
From: =?UTF-8?q?V=C3=ADctor=20Manuel=20J=C3=A1quez=20Leal?= 
	<vjaquez@igalia.com>
To: Omar Ramirez Luna <omar.ramirez@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Felipe Contreras <felipe.contreras@nokia.com>,
        linux-omap@vger.kernel.org
Subject: [PATCH 04/17] staging: tidspbridge: remove node_init() and node_exit()
Date: Fri,  9 Mar 2012 01:03:39 +0100
Message-Id: <e37bf4c22995c807dbd9f53771766c775ce4354b.1331250369.git.vjaquez@igalia.com>
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

The node module has a node_init() and a node_exit() whose only purpose
is to keep a reference counting which is not used at all.

This patch removes these functions and the reference count variable.

There is no functional changes.

Signed-off-by: Víctor Manuel Jáquez Leal <vjaquez@igalia.com>
---
 .../staging/tidspbridge/include/dspbridge/node.h   |   41 --------------------
 .../tidspbridge/include/dspbridge/nodepriv.h       |    1 -
 drivers/staging/tidspbridge/pmgr/dspapi.c          |    7 +---
 drivers/staging/tidspbridge/rmgr/node.c            |   24 -----------
 4 files changed, 1 insertions(+), 72 deletions(-)

diff --git a/drivers/staging/tidspbridge/include/dspbridge/node.h b/drivers/staging/tidspbridge/include/dspbridge/node.h
index 16371d8..7397b7a 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/node.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/node.h
@@ -47,7 +47,6 @@
  *      -EPERM:          A failure occurred, unable to allocate node.
  *      -EBADR:    Proccessor is not in the running state.
  *  Requires:
- *      node_init(void) called.
  *      hprocessor != NULL.
  *      node_uuid != NULL.
  *      noderes != NULL.
@@ -81,7 +80,6 @@ extern int node_allocate(struct proc_object *hprocessor,
  *      -EPERM:      General Failure.
  *      -EINVAL:      Invalid Size.
  *  Requires:
- *      node_init(void) called.
  *      pbuffer != NULL.
  *  Ensures:
  */
@@ -106,7 +104,6 @@ extern int node_alloc_msg_buf(struct node_object *hnode,
  *                          or NODE_RUNNING state.
  *      -ETIME:       A timeout occurred before the DSP responded.
  *  Requires:
- *      node_init(void) called.
  *  Ensures:
  *      0 && (Node's current priority == prio)
  */
@@ -157,7 +154,6 @@ extern int node_change_priority(struct node_object *hnode, s32 prio);
  *                              Device node to device node, or device node to
  *                              GPP), the two nodes are on different DSPs.
  *  Requires:
- *      node_init(void) called.
  *  Ensures:
  */
 extern int node_connect(struct node_object *node1,
@@ -185,7 +181,6 @@ extern int node_connect(struct node_object *node1,
  *      -ETIME:       A timeout occurred before the DSP responded.
  *      -EPERM:          A failure occurred, unable to create node.
  *  Requires:
- *      node_init(void) called.
  *  Ensures:
  */
 extern int node_create(struct node_object *hnode);
@@ -206,7 +201,6 @@ extern int node_create(struct node_object *hnode);
  *      -ENOMEM:    Insufficient memory for requested resources.
  *      -EPERM:      General failure.
  *  Requires:
- *      node_init(void) called.
  *      node_man != NULL.
  *      hdev_obj != NULL.
  *  Ensures:
@@ -234,7 +228,6 @@ extern int node_create_mgr(struct node_mgr **node_man,
  *      -EPERM:          A failure occurred in deleting the node.
  *      -ESPIPE:        Delete function not found in the COFF file.
  *  Requires:
- *      node_init(void) called.
  *  Ensures:
  *      0:            hnode is invalid.
  */
@@ -250,7 +243,6 @@ extern int node_delete(struct node_res_object *noderes,
  *  Returns:
  *      0:        Success.
  *  Requires:
- *      node_init(void) called.
  *      Valid hnode_mgr.
  *  Ensures:
  */
@@ -287,20 +279,6 @@ extern int node_enum_nodes(struct node_mgr *hnode_mgr,
 				  u32 *pu_allocated);
 
 /*
- *  ======== node_exit ========
- *  Purpose:
- *      Discontinue usage of NODE module.
- *  Parameters:
- *  Returns:
- *  Requires:
- *      node_init(void) successfully called before.
- *  Ensures:
- *      Any resources acquired in node_init(void) will be freed when last NODE
- *      client calls node_exit(void).
- */
-extern void node_exit(void);
-
-/*
  *  ======== node_free_msg_buf ========
  *  Purpose:
  *      Free a message buffer previously allocated with node_alloc_msg_buf.
@@ -313,7 +291,6 @@ extern void node_exit(void);
  *      -EFAULT:    Invalid node handle.
  *      -EPERM:      Failure to free the buffer.
  *  Requires:
- *      node_init(void) called.
  *      pbuffer != NULL.
  *  Ensures:
  */
@@ -336,7 +313,6 @@ extern int node_free_msg_buf(struct node_object *hnode,
  *      0:        Success.
  *      -EFAULT:    Invalid hnode.
  *  Requires:
- *      node_init(void) called.
  *      pattr != NULL.
  *  Ensures:
  *      0:        *pattrs contains the node's current attributes.
@@ -363,7 +339,6 @@ extern int node_get_attr(struct node_object *hnode,
  *              Error occurred while trying to retrieve a message.
  *      -ETIME:   Timeout occurred and no message is available.
  *  Requires:
- *      node_init(void) called.
  *      message != NULL.
  *  Ensures:
  */
@@ -386,17 +361,6 @@ extern int node_get_nldr_obj(struct node_mgr *hnode_mgr,
 				    struct nldr_object **nldr_ovlyobj);
 
 /*
- *  ======== node_init ========
- *  Purpose:
- *      Initialize the NODE module.
- *  Parameters:
- *  Returns:
- *      TRUE if initialization succeeded, FALSE otherwise.
- *  Ensures:
- */
-extern bool node_init(void);
-
-/*
  *  ======== node_on_exit ========
  *  Purpose:
  *      Gets called when RMS_EXIT is received for a node. PROC needs to pass
@@ -425,7 +389,6 @@ void node_on_exit(struct node_object *hnode, s32 node_status);
  *      -ETIME:       A timeout occurred before the DSP responded.
  *      DSP_EWRONGSTSATE:   Node is not in NODE_RUNNING state.
  *  Requires:
- *      node_init(void) called.
  *  Ensures:
  */
 extern int node_pause(struct node_object *hnode);
@@ -449,7 +412,6 @@ extern int node_pause(struct node_object *hnode);
  *      -ETIME:       Timeout occurred before message could be set.
  *      -EBADR:    Node is in invalid state for sending messages.
  *  Requires:
- *      node_init(void) called.
  *      pmsg != NULL.
  *  Ensures:
  */
@@ -473,7 +435,6 @@ extern int node_put_message(struct node_object *hnode,
  *      -ENOSYS:   Notification type specified by notify_type is not
  *                      supported.
  *  Requires:
- *      node_init(void) called.
  *      hnotification != NULL.
  *  Ensures:
  */
@@ -500,7 +461,6 @@ extern int node_register_notify(struct node_object *hnode,
  *      DSP_EWRONGSTSATE:   Node is not in NODE_PAUSED or NODE_CREATED state.
  *      -ESPIPE:        Execute function not found in the COFF file.
  *  Requires:
- *      node_init(void) called.
  *  Ensures:
  */
 extern int node_run(struct node_object *hnode);
@@ -523,7 +483,6 @@ extern int node_run(struct node_object *hnode);
  *              Unable to terminate the node.
  *      -EBADR:    Operation not valid for the current node state.
  *  Requires:
- *      node_init(void) called.
  *      pstatus != NULL.
  *  Ensures:
  */
diff --git a/drivers/staging/tidspbridge/include/dspbridge/nodepriv.h b/drivers/staging/tidspbridge/include/dspbridge/nodepriv.h
index 9c1e067..d5b54bb 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/nodepriv.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/nodepriv.h
@@ -96,7 +96,6 @@ struct node_createargs {
  *      -EINVAL:     The node's stream corresponding to index and dir
  *                      is not a stream to or from the host.
  *  Requires:
- *      node_init(void) called.
  *      Valid dir.
  *      chan_id != NULL.
  *  Ensures:
diff --git a/drivers/staging/tidspbridge/pmgr/dspapi.c b/drivers/staging/tidspbridge/pmgr/dspapi.c
index 7c20a0f..a5f1f65 100644
--- a/drivers/staging/tidspbridge/pmgr/dspapi.c
+++ b/drivers/staging/tidspbridge/pmgr/dspapi.c
@@ -273,7 +273,6 @@ void api_exit(void)
 		io_exit();
 		strm_exit();
 		disp_exit();
-		node_exit();
 		mgr_exit();
 		rmm_exit();
 	}
@@ -288,12 +287,11 @@ bool api_init(void)
 {
 	bool ret = true;
 	bool fdev, fchnl, fmsg, fio;
-	bool fmgr, fnode, fdisp, fstrm, frmm;
+	bool fmgr, fdisp, fstrm, frmm;
 
 	if (api_c_refs == 0) {
 		/* initialize driver and other modules */
 		fmgr = mgr_init();
-		fnode = node_init();
 		fdisp = disp_init();
 		fstrm = strm_init();
 		frmm = rmm_init();
@@ -311,9 +309,6 @@ bool api_init(void)
 			if (fstrm)
 				strm_exit();
 
-			if (fnode)
-				node_exit();
-
 			if (fdisp)
 				disp_exit();
 
diff --git a/drivers/staging/tidspbridge/rmgr/node.c b/drivers/staging/tidspbridge/rmgr/node.c
index 1b24589..908cd1e 100644
--- a/drivers/staging/tidspbridge/rmgr/node.c
+++ b/drivers/staging/tidspbridge/rmgr/node.c
@@ -261,8 +261,6 @@ static u32 ovly(void *priv_ref, u32 dsp_run_addr, u32 dsp_load_addr,
 static u32 mem_write(void *priv_ref, u32 dsp_add, void *pbuf,
 		     u32 ul_num_bytes, u32 mem_space);
 
-static u32 refs;		/* module reference count */
-
 /* Dynamic loader functions. */
 static struct node_ldr_fxns nldr_fxns = {
 	nldr_allocate,
@@ -1569,16 +1567,6 @@ func_end:
 }
 
 /*
- *  ======== node_exit ========
- *  Purpose:
- *      Discontinue usage of NODE module.
- */
-void node_exit(void)
-{
-	refs--;
-}
-
-/*
  *  ======== node_free_msg_buf ========
  *  Purpose:
  *      Frees the message buffer.
@@ -1852,18 +1840,6 @@ enum node_type node_get_type(struct node_object *hnode)
 }
 
 /*
- *  ======== node_init ========
- *  Purpose:
- *      Initialize the NODE module.
- */
-bool node_init(void)
-{
-	refs++;
-
-	return true;
-}
-
-/*
  *  ======== node_on_exit ========
  *  Purpose:
  *      Gets called when RMS_EXIT is received for a node.
-- 
1.7.9.1

