Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab1ECQyz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 12:54:55 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45625 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908Ab1ECQxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 12:53:03 -0400
X-Greylist: delayed 357 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 May 2011 12:52:53 EDT
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 06/23] intel_sst: parameter tuning ioctl
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 03 May 2011 17:32:49 +0100
Message-ID: <20110503163248.24853.15491.stgit@bob.linux.org.uk>
In-Reply-To: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
References: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vinod Koul <vinod.koul@intel.com>

This patch adds new IOCTL for application interface.

Using parameter tuning IOCTL, application can fine
tune the audio firmware for it's requirement.

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Ramesh Babu K V <ramesh.babu@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 .../staging/intel_sst/intel_sst_app_interface.c    |   37 ++++++++++++++++++++
 drivers/staging/intel_sst/intel_sst_common.h       |    4 +-
 drivers/staging/intel_sst/intel_sst_fw_ipc.h       |    1 +
 drivers/staging/intel_sst/intel_sst_ioctl.h        |    8 ++++
 drivers/staging/intel_sst/intel_sst_ipc.c          |   18 ++++++++++
 5 files changed, 66 insertions(+), 2 deletions(-)


diff --git a/drivers/staging/intel_sst/intel_sst_app_interface.c b/drivers/staging/intel_sst/intel_sst_app_interface.c
index d7454e2..b8c7ddb 100644
--- a/drivers/staging/intel_sst/intel_sst_app_interface.c
+++ b/drivers/staging/intel_sst/intel_sst_app_interface.c
@@ -961,6 +961,34 @@ free_mem:
 	return retval;
 }
 
+
+int sst_ioctl_tuning_params(unsigned long arg)
+{
+	struct snd_sst_tuning_params params;
+	struct ipc_post *msg;
+
+	if (copy_from_user(&params, (void __user *)arg, sizeof(params)))
+		return -EFAULT;
+	if (params.size > SST_MAILBOX_SIZE)
+		return -ENOMEM;
+	pr_debug("Parameter %d, Stream %d, Size %d\n", params.type,
+			params.str_id, params.size);
+	if (sst_create_large_msg(&msg))
+		return -ENOMEM;
+
+	sst_fill_header(&msg->header, IPC_IA_TUNING_PARAMS, 1, params.str_id);
+	msg->header.part.data = sizeof(u32) + sizeof(params) + params.size;
+	memcpy(msg->mailbox_data, &msg->header.full, sizeof(u32));
+	memcpy(msg->mailbox_data + sizeof(u32), &params, sizeof(params));
+	if (copy_from_user(msg->mailbox_data + sizeof(params),
+			(void __user *)(unsigned long)params.addr,
+			params.size)) {
+		kfree(msg->mailbox_data);
+		kfree(msg);
+		return -EFAULT;
+	}
+	return sst_send_algo_ipc(&msg);
+}
 /**
  * intel_sst_ioctl - receives the device ioctl's
  * @file_ptr:pointer to file
@@ -1412,6 +1440,15 @@ free_iobufs:
 		}
 		retval = intel_sst_ioctl_dsp(cmd, arg);
 		break;
+
+	case _IOC_NR(SNDRV_SST_TUNING_PARAMS):
+		if (minor != AM_MODULE) {
+			retval = -EBADRQC;
+			break;
+		}
+		retval = sst_ioctl_tuning_params(arg);
+		break;
+
 	default:
 		retval = -EINVAL;
 	}
diff --git a/drivers/staging/intel_sst/intel_sst_common.h b/drivers/staging/intel_sst/intel_sst_common.h
index 9aff1a3..e37b377 100644
--- a/drivers/staging/intel_sst/intel_sst_common.h
+++ b/drivers/staging/intel_sst/intel_sst_common.h
@@ -28,8 +28,8 @@
  *  Common private declarations for SST
  */
 
-#define SST_DRIVER_VERSION "1.2.14"
-#define SST_VERSION_NUM 0x1214
+#define SST_DRIVER_VERSION "1.2.15"
+#define SST_VERSION_NUM 0x1215
 
 /* driver names */
 #define SST_DRV_NAME "intel_sst_driver"
diff --git a/drivers/staging/intel_sst/intel_sst_fw_ipc.h b/drivers/staging/intel_sst/intel_sst_fw_ipc.h
index 8628a8a..5d0cc56 100644
--- a/drivers/staging/intel_sst/intel_sst_fw_ipc.h
+++ b/drivers/staging/intel_sst/intel_sst_fw_ipc.h
@@ -71,6 +71,7 @@
 #define IPC_IA_DECODE_FRAMES 0x18
 
 #define IPC_IA_ALG_PARAMS 0x1A
+#define IPC_IA_TUNING_PARAMS 0x1B
 
 /* I2L Stream config/control msgs */
 #define IPC_IA_ALLOC_STREAM 0x20 /* Allocate a stream ID */
diff --git a/drivers/staging/intel_sst/intel_sst_ioctl.h b/drivers/staging/intel_sst/intel_sst_ioctl.h
index bebc395..5da5ee0 100644
--- a/drivers/staging/intel_sst/intel_sst_ioctl.h
+++ b/drivers/staging/intel_sst/intel_sst_ioctl.h
@@ -400,6 +400,13 @@ struct snd_sst_dbufs  {
 	struct snd_sst_buffs *obufs;
 };
 
+struct snd_sst_tuning_params {
+	__u8 type;
+	__u8 str_id;
+	__u8 size;
+	__u8 rsvd;
+	__aligned_u64 addr;
+} __attribute__ ((packed));
 /*IOCTL defined here */
 /*SST MMF IOCTLS only */
 #define SNDRV_SST_STREAM_SET_PARAMS _IOR('L', 0x00, \
@@ -428,5 +435,6 @@ struct snd_sst_dbufs  {
 /*DSP Ioctls on /dev/intel_sst_ctrl only*/
 #define SNDRV_SST_SET_ALGO	_IOW('L', 0x30,  struct snd_ppp_params *)
 #define SNDRV_SST_GET_ALGO	_IOWR('L', 0x31,  struct snd_ppp_params *)
+#define SNDRV_SST_TUNING_PARAMS	_IOW('L', 0x32,  struct snd_sst_tuning_params *)
 
 #endif /* __INTEL_SST_IOCTL_H__ */
diff --git a/drivers/staging/intel_sst/intel_sst_ipc.c b/drivers/staging/intel_sst/intel_sst_ipc.c
index 878b19d..5c3444f 100644
--- a/drivers/staging/intel_sst/intel_sst_ipc.c
+++ b/drivers/staging/intel_sst/intel_sst_ipc.c
@@ -416,6 +416,24 @@ void sst_process_reply(struct work_struct *work)
 		}
 		break;
 	}
+
+	case IPC_IA_TUNING_PARAMS: {
+		pr_debug("sst:IPC_TUNING_PARAMS resp: %x\n", msg->header.full);
+		pr_debug("data value %x\n", msg->header.part.data);
+		if (msg->header.part.large) {
+			pr_debug("alg set failed\n");
+			sst_drv_ctx->ppp_params_blk.ret_code =
+							-msg->header.part.data;
+		} else {
+			pr_debug("alg set success\n");
+			sst_drv_ctx->ppp_params_blk.ret_code = 0;
+		}
+		if (sst_drv_ctx->ppp_params_blk.on == true) {
+			sst_drv_ctx->ppp_params_blk.condition = true;
+			wake_up(&sst_drv_ctx->wait_queue);
+		}
+	}
+
 	case IPC_IA_GET_FW_INFO: {
 		struct snd_sst_fw_info *fw_info =
 			(struct snd_sst_fw_info *)msg->mailbox;

