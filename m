Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab0KCXqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 19:46:34 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42859 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020Ab0KCXqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 19:46:31 -0400
From: Rene Sapiens <rene.sapiens@ti.com>
To: greg@kroah.com
Cc: gregkh@suse.de, nm@ti.com, felipe.contreras@gmail.com, ernesto@ti.com,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-omap@vger.kernel.org, Rene Sapiens <rene.sapiens@ti.com>
Subject: [PATCH 1/8] staging: tidspbridge: overwrite DSP error codes
Date: Wed,  3 Nov 2010 17:36:34 -0600
Message-Id: <1288827394-7505-1-git-send-email-rene.sapiens@ti.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When calling the DSP's remote functions, the DSP returns error
codes different from the ones managed by the kernel, the
function's return value is shared with the MPU using a shared
structure. This patch overwrites those error codes by kernel
specifics and deletes unnecessary code.

Signed-off-by: Rene Sapiens <rene.sapiens@ti.com>
---
 drivers/staging/tidspbridge/rmgr/disp.c |   44 +++++-------------------------
 1 files changed, 8 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/tidspbridge/rmgr/disp.c b/drivers/staging/tidspbridge/rmgr/disp.c
index b7ce435..560069a 100644
--- a/drivers/staging/tidspbridge/rmgr/disp.c
+++ b/drivers/staging/tidspbridge/rmgr/disp.c
@@ -460,17 +460,6 @@ int disp_node_create(struct disp_object *disp_obj,
 		DBC_ASSERT(ul_bytes < (RMS_COMMANDBUFSIZE * sizeof(rms_word)));
 		status = send_message(disp_obj, node_get_timeout(hnode),
 				      ul_bytes, node_env);
-		if (status >= 0) {
-			/*
-			 * Message successfully received from RMS.
-			 * Return the status of the Node's create function
-			 * on the DSP-side
-			 */
-			status = (((rms_word *) (disp_obj->pbuf))[0]);
-			if (status < 0)
-				dev_dbg(bridge, "%s: DSP-side failed: 0x%x\n",
-					__func__, status);
-		}
 	}
 func_end:
 	return status;
@@ -513,18 +502,6 @@ int disp_node_delete(struct disp_object *disp_obj,
 			status = send_message(disp_obj, node_get_timeout(hnode),
 					      sizeof(struct rms_command),
 					      &dw_arg);
-			if (status >= 0) {
-				/*
-				 * Message successfully received from RMS.
-				 * Return the status of the Node's delete
-				 * function on the DSP-side
-				 */
-				status = (((rms_word *) (disp_obj->pbuf))[0]);
-				if (status < 0)
-					dev_dbg(bridge, "%s: DSP-side failed: "
-						"0x%x\n", __func__, status);
-			}
-
 		}
 	}
 	return status;
@@ -566,18 +543,6 @@ int disp_node_run(struct disp_object *disp_obj,
 			status = send_message(disp_obj, node_get_timeout(hnode),
 					      sizeof(struct rms_command),
 					      &dw_arg);
-			if (status >= 0) {
-				/*
-				 * Message successfully received from RMS.
-				 * Return the status of the Node's execute
-				 * function on the DSP-side
-				 */
-				status = (((rms_word *) (disp_obj->pbuf))[0]);
-				if (status < 0)
-					dev_dbg(bridge, "%s: DSP-side failed: "
-						"0x%x\n", __func__, status);
-			}
-
 		}
 	}
 
@@ -739,7 +704,14 @@ static int send_message(struct disp_object *disp_obj, u32 timeout,
 		} else {
 			if (CHNL_IS_IO_COMPLETE(chnl_ioc_obj)) {
 				DBC_ASSERT(chnl_ioc_obj.pbuf == pbuf);
-				status = (*((rms_word *) chnl_ioc_obj.pbuf));
+				if (*((int *)chnl_ioc_obj.pbuf) < 0) {
+					/* Translate DSP's to kernel error */
+					status = -EREMOTEIO;
+					dev_dbg(bridge, "%s: DSP-side failed:"
+						" DSP errcode = 0x%x, Kernel "
+						"errcode = %d\n", __func__,
+						*(int *)pbuf, status);
+				}
 				*pdw_arg =
 				    (((rms_word *) (chnl_ioc_obj.pbuf))[1]);
 			} else {
-- 
1.6.3.3

