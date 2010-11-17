Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934986Ab0KQQTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 11:19:43 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:48260 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934944Ab0KQQTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 11:19:42 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 7/7] sst: add ioctls for post processing algorithm interface
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 17 Nov 2010 15:59:42 +0000
Message-ID: <20101117155940.21681.91737.stgit@localhost.localdomain>
In-Reply-To: <20101117155748.21681.71501.stgit@localhost.localdomain>
References: <20101117155748.21681.71501.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vinod Koul <vinod.koul@intel.com>

This patch adds two new ioctls to intel_sst_ctrl device.
This i/f can be used by application to send algorithm parameters

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
[This will need further discussion in the context of the final ALSA interface
 but is fine for staging, ie anyone who relies on it should expect changes
 Also fixed a missing kmalloc fail check]
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/intel_sst/intel_sst.c              |   23 ++-
 .../staging/intel_sst/intel_sst_app_interface.c    |  143 ++++++++++++++++++++
 drivers/staging/intel_sst/intel_sst_common.h       |    2 
 drivers/staging/intel_sst/intel_sst_fw_ipc.h       |    2 
 drivers/staging/intel_sst/intel_sst_ioctl.h        |   15 +-
 drivers/staging/intel_sst/intel_sst_ipc.c          |   49 +++++++
 6 files changed, 213 insertions(+), 21 deletions(-)


diff --git a/drivers/staging/intel_sst/intel_sst.c b/drivers/staging/intel_sst/intel_sst.c
index 92e30f6..da29980 100644
--- a/drivers/staging/intel_sst/intel_sst.c
+++ b/drivers/staging/intel_sst/intel_sst.c
@@ -304,18 +304,18 @@ static int __devinit intel_sst_probe(struct pci_dev *pci,
 		goto do_unmap_dram;
 	pr_debug("sst: Registered IRQ 0x%x\n", pci->irq);
 
+	/*Register LPE Control as misc driver*/
+	ret = misc_register(&lpe_ctrl);
+	if (ret) {
+		pr_err("sst: couldn't register control device\n");
+		goto do_free_irq;
+	}
+
 	if (sst_drv_ctx->pci_id == SST_MRST_PCI_ID) {
 		ret = misc_register(&lpe_dev);
 		if (ret) {
-			pr_err("sst: couldn't register LPE device\n");
-			goto do_free_irq;
-		}
-
-		/*Register LPE Control as misc driver*/
-		ret = misc_register(&lpe_ctrl);
-		if (ret) {
 			pr_err("sst: couldn't register misc driver\n");
-			goto do_free_irq;
+			goto do_free_misc;
 		}
 	}
 	sst_drv_ctx->lpe_stalled = 0;
@@ -325,6 +325,8 @@ static int __devinit intel_sst_probe(struct pci_dev *pci,
 	pr_debug("sst: ...successfully done!!!\n");
 	return ret;
 
+do_free_misc:
+	misc_deregister(&lpe_ctrl);
 do_free_irq:
 	free_irq(pci->irq, sst_drv_ctx);
 do_unmap_dram:
@@ -369,10 +371,9 @@ static void __devexit intel_sst_remove(struct pci_dev *pci)
 	mutex_lock(&sst_drv_ctx->sst_lock);
 	sst_drv_ctx->sst_state = SST_UN_INIT;
 	mutex_unlock(&sst_drv_ctx->sst_lock);
-	if (sst_drv_ctx->pci_id == SST_MRST_PCI_ID) {
+	misc_deregister(&lpe_ctrl);
+	if (sst_drv_ctx->pci_id == SST_MRST_PCI_ID)
 		misc_deregister(&lpe_dev);
-		misc_deregister(&lpe_ctrl);
-	}
 	free_irq(pci->irq, sst_drv_ctx);
 	iounmap(sst_drv_ctx->dram);
 	iounmap(sst_drv_ctx->iram);
diff --git a/drivers/staging/intel_sst/intel_sst_app_interface.c b/drivers/staging/intel_sst/intel_sst_app_interface.c
index 9aac69f..c742582 100644
--- a/drivers/staging/intel_sst/intel_sst_app_interface.c
+++ b/drivers/staging/intel_sst/intel_sst_app_interface.c
@@ -825,6 +825,141 @@ static void sst_print_stream_params(struct snd_sst_get_stream_params *get_prm)
 }
 
 /**
+* sst_create_algo_ipc - create ipc msg for algorithm parameters
+*
+* @algo_params: Algorithm parameters
+* @msg: post msg pointer
+*
+* This function is called to create ipc msg
+**/
+int sst_create_algo_ipc(struct snd_ppp_params *algo_params,
+					struct ipc_post **msg)
+{
+	if (sst_create_large_msg(msg))
+		return -ENOMEM;
+	sst_fill_header(&(*msg)->header,
+			IPC_IA_ALG_PARAMS, 1, algo_params->str_id);
+	(*msg)->header.part.data = sizeof(u32) +
+			sizeof(*algo_params) + algo_params->size;
+	memcpy((*msg)->mailbox_data, &(*msg)->header, sizeof(u32));
+	memcpy((*msg)->mailbox_data + sizeof(u32),
+				algo_params, sizeof(*algo_params));
+	return 0;
+}
+
+/**
+* sst_send_algo_ipc - send ipc msg for algorithm parameters
+*
+* @msg: post msg pointer
+*
+* This function is called to send ipc msg
+**/
+int sst_send_algo_ipc(struct ipc_post **msg)
+{
+	sst_drv_ctx->ppp_params_blk.condition = false;
+	sst_drv_ctx->ppp_params_blk.ret_code = 0;
+	sst_drv_ctx->ppp_params_blk.on = true;
+	sst_drv_ctx->ppp_params_blk.data = NULL;
+	spin_lock(&sst_drv_ctx->list_spin_lock);
+	list_add_tail(&(*msg)->node, &sst_drv_ctx->ipc_dispatch_list);
+	spin_unlock(&sst_drv_ctx->list_spin_lock);
+	sst_post_message(&sst_drv_ctx->ipc_post_msg_wq);
+	return sst_wait_interruptible_timeout(sst_drv_ctx,
+			&sst_drv_ctx->ppp_params_blk, SST_BLOCK_TIMEOUT);
+}
+
+/**
+ * intel_sst_ioctl_dsp - recieves the device ioctl's
+ *
+ * @cmd:Ioctl cmd
+ * @arg:data
+ *
+ * This function is called when a user space component
+ * sends a DSP Ioctl to SST driver
+ */
+long intel_sst_ioctl_dsp(unsigned int cmd, unsigned long arg)
+{
+	int retval = 0;
+	struct snd_ppp_params algo_params;
+	struct snd_ppp_params *algo_params_copied;
+	struct ipc_post *msg;
+
+	switch (_IOC_NR(cmd)) {
+	case _IOC_NR(SNDRV_SST_SET_ALGO):
+		if (copy_from_user(&algo_params, (void __user *)arg,
+							sizeof(algo_params)))
+			return -EFAULT;
+		if (algo_params.size > SST_MAILBOX_SIZE)
+			return -EMSGSIZE;
+
+		pr_debug("sst: Algo ID %d Str id %d Enable %d Size %d\n",
+			algo_params.algo_id, algo_params.str_id,
+			algo_params.enable, algo_params.size);
+		retval = sst_create_algo_ipc(&algo_params, &msg);
+		if (retval)
+			break;
+		algo_params.reserved = 0;
+		if (copy_from_user(msg->mailbox_data + sizeof(algo_params),
+				algo_params.params, algo_params.size))
+			return -EFAULT;
+
+		retval = sst_send_algo_ipc(&msg);
+		if (retval) {
+			pr_debug("sst: Error in sst_set_algo = %d\n", retval);
+			retval = -EIO;
+		}
+		break;
+
+	case _IOC_NR(SNDRV_SST_GET_ALGO):
+		if (copy_from_user(&algo_params, (void __user *)arg,
+							sizeof(algo_params)))
+			return -EFAULT;
+		pr_debug("sst: Algo ID %d Str id %d Enable %d Size %d\n",
+			algo_params.algo_id, algo_params.str_id,
+			algo_params.enable, algo_params.size);
+		retval = sst_create_algo_ipc(&algo_params, &msg);
+		if (retval)
+			break;
+		algo_params.reserved = 1;
+		retval = sst_send_algo_ipc(&msg);
+		if (retval) {
+			pr_debug("sst: Error in sst_get_algo = %d\n", retval);
+			retval = -EIO;
+			break;
+		}
+		algo_params_copied = (struct snd_ppp_params *)
+					sst_drv_ctx->ppp_params_blk.data;
+		if (algo_params_copied->size > algo_params.size) {
+			pr_debug("sst: mem insuffiecient to copy\n");
+			retval = -EMSGSIZE;
+			goto free_mem;
+		} else {
+			char __user *tmp;
+
+			if (copy_to_user(algo_params.params,
+					algo_params_copied->params,
+					algo_params_copied->size)) {
+				retval = -EFAULT;
+				goto free_mem;
+			}
+			tmp = (char __user *)arg + offsetof(
+					struct snd_ppp_params, size);
+			if (copy_to_user(tmp, &algo_params_copied->size,
+						 sizeof(__u32))) {
+				retval = -EFAULT;
+				goto free_mem;
+			}
+
+		}
+free_mem:
+		kfree(algo_params_copied->params);
+		kfree(algo_params_copied);
+		break;
+	}
+	return retval;
+}
+
+/**
  * intel_sst_ioctl - recieves the device ioctl's
  * @file_ptr:pointer to file
  * @cmd:Ioctl cmd
@@ -1267,6 +1402,14 @@ free_iobufs:
 		kfree(fw_info);
 		break;
 	}
+	case _IOC_NR(SNDRV_SST_GET_ALGO):
+	case _IOC_NR(SNDRV_SST_SET_ALGO):
+		if (minor != AM_MODULE) {
+			retval = -EBADRQC;
+			break;
+		}
+		retval = intel_sst_ioctl_dsp(cmd, arg);
+		break;
 	default:
 		retval = -EINVAL;
 	}
diff --git a/drivers/staging/intel_sst/intel_sst_common.h b/drivers/staging/intel_sst/intel_sst_common.h
index e0c6339..0a60e86 100644
--- a/drivers/staging/intel_sst/intel_sst_common.h
+++ b/drivers/staging/intel_sst/intel_sst_common.h
@@ -392,7 +392,7 @@ struct intel_sst_drv {
 
 	struct stream_info	streams[MAX_NUM_STREAMS];
 	struct stream_alloc_block alloc_block[MAX_ACTIVE_STREAM];
-	struct sst_block	tgt_dev_blk, fw_info_blk,
+	struct sst_block	tgt_dev_blk, fw_info_blk, ppp_params_blk,
 				vol_info_blk, mute_info_blk, hs_info_blk;
 	struct mutex		list_lock;/* mutex for IPC list locking */
 	spinlock_t	list_spin_lock; /* mutex for IPC list locking */
diff --git a/drivers/staging/intel_sst/intel_sst_fw_ipc.h b/drivers/staging/intel_sst/intel_sst_fw_ipc.h
index 75c1876..8df313d 100644
--- a/drivers/staging/intel_sst/intel_sst_fw_ipc.h
+++ b/drivers/staging/intel_sst/intel_sst_fw_ipc.h
@@ -68,6 +68,8 @@
 #define IPC_IA_CAPT_VOICE 0x17
 #define IPC_IA_DECODE_FRAMES 0x18
 
+#define IPC_IA_ALG_PARAMS 0x1A
+
 /* I2L Stream config/control msgs */
 #define IPC_IA_ALLOC_STREAM 0x20 /* Allocate a stream ID */
 #define IPC_IA_FREE_STREAM 0x21 /* Free the stream ID */
diff --git a/drivers/staging/intel_sst/intel_sst_ioctl.h b/drivers/staging/intel_sst/intel_sst_ioctl.h
index 03b9316..bebc395 100644
--- a/drivers/staging/intel_sst/intel_sst_ioctl.h
+++ b/drivers/staging/intel_sst/intel_sst_ioctl.h
@@ -190,21 +190,15 @@ struct snd_prp_params {
 	__u32 reserved;	/* No pre-processing defined yet */
 };
 
-struct snd_params_block {
-	__u32 type;		/*Type of the parameter*/
-	__u32 size;		/*size of the parameters in the block*/
-	__u8 params[0];	/*Parameters of the algorithm*/
-};
-
 /* Pre and post processing params structure */
 struct snd_ppp_params {
-	enum sst_algo_types	algo_id;/* Post/Pre processing algorithm ID  */
+	__u8			algo_id;/* Post/Pre processing algorithm ID  */
 	__u8			str_id;	/*Only 5 bits used 0 - 31 are valid*/
 	__u8			enable;	/* 0= disable, 1= enable*/
 	__u8			reserved;
 	__u32			size;	/*Size of parameters for all blocks*/
-	struct snd_params_block	params[0];
-};
+	void			*params;
+} __attribute__ ((packed));
 
 struct snd_sst_postproc_info {
 	__u32 src_min;		/* Supported SRC Min sampling freq */
@@ -431,5 +425,8 @@ struct snd_sst_dbufs  {
 #define SNDRV_SST_FW_INFO	_IOR('L', 0x20,  struct snd_sst_fw_info *)
 #define SNDRV_SST_SET_TARGET_DEVICE _IOW('L', 0x21, \
 					struct snd_sst_target_device *)
+/*DSP Ioctls on /dev/intel_sst_ctrl only*/
+#define SNDRV_SST_SET_ALGO	_IOW('L', 0x30,  struct snd_ppp_params *)
+#define SNDRV_SST_GET_ALGO	_IOWR('L', 0x31,  struct snd_ppp_params *)
 
 #endif /* __INTEL_SST_IOCTL_H__ */
diff --git a/drivers/staging/intel_sst/intel_sst_ipc.c b/drivers/staging/intel_sst/intel_sst_ipc.c
index 37c6505..8e098d0 100644
--- a/drivers/staging/intel_sst/intel_sst_ipc.c
+++ b/drivers/staging/intel_sst/intel_sst_ipc.c
@@ -334,6 +334,55 @@ void sst_process_reply(struct work_struct *work)
 				wake_up(&sst_drv_ctx->wait_queue);
 		}
 		break;
+	case IPC_IA_ALG_PARAMS: {
+		pr_debug("sst:IPC_ALG_PARAMS response %x\n", msg->header.full);
+		pr_debug("sst: data value %x\n", msg->header.part.data);
+		pr_debug("sst: large value %x\n", msg->header.part.large);
+
+		if (!msg->header.part.large) {
+			if (!msg->header.part.data) {
+				pr_debug("sst: alg set success\n");
+				sst_drv_ctx->ppp_params_blk.ret_code = 0;
+			} else {
+				pr_debug("sst: alg set failed\n");
+				sst_drv_ctx->ppp_params_blk.ret_code =
+							-msg->header.part.data;
+			}
+
+		} else if (msg->header.part.data) {
+			struct snd_ppp_params *mailbox_params, *get_params;
+			char *params;
+
+			pr_debug("sst: alg get success\n");
+			mailbox_params = (struct snd_ppp_params *)msg->mailbox;
+			get_params = kzalloc(sizeof(*get_params), GFP_KERNEL);
+			if (get_params == NULL) {
+				pr_err("sst: out of memory for ALG PARAMS");
+				break;
+			}
+			memcpy_fromio(get_params, mailbox_params,
+							sizeof(*get_params));
+			get_params->params = kzalloc(mailbox_params->size,
+							GFP_KERNEL);
+			if (get_params->params == NULL) {
+				kfree(get_params);
+				pr_err("sst: out of memory for ALG PARAMS block");
+				break;
+			}
+			params = msg->mailbox;
+			params = params + sizeof(*mailbox_params) - sizeof(u32);
+			memcpy_fromio(get_params->params, params,
+							get_params->size);
+			sst_drv_ctx->ppp_params_blk.ret_code = 0;
+			sst_drv_ctx->ppp_params_blk.data = get_params;
+		}
+
+		if (sst_drv_ctx->ppp_params_blk.on == true) {
+			sst_drv_ctx->ppp_params_blk.condition = true;
+			wake_up(&sst_drv_ctx->wait_queue);
+		}
+		break;
+	}
 	case IPC_IA_GET_FW_INFO: {
 		struct snd_sst_fw_info *fw_info =
 			(struct snd_sst_fw_info *)msg->mailbox;

