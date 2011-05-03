Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab1ECQxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 12:53:07 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45625 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009Ab1ECQxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 12:53:05 -0400
X-Greylist: delayed 357 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 May 2011 12:52:53 EDT
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 01/23] intel_sst: Save audio state across D3 on Medfield
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 03 May 2011 17:31:49 +0100
Message-ID: <20110503163128.24853.15446.stgit@bob.linux.org.uk>
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

During suspend and runtime_suspend audio dsp will be in D3 state
and will loose its context.

This patch adds support in driver to save the dsp context
and restore this context during resume

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Ramesh Babu K V <ramesh.babu@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/intel_sst/intel_sst.c              |   67 +++++++++++++++++++-
 drivers/staging/intel_sst/intel_sst_common.h       |    9 ++-
 .../staging/intel_sst/intel_sst_drv_interface.c    |    2 +
 drivers/staging/intel_sst/intel_sst_dsp.c          |   14 +++-
 drivers/staging/intel_sst/intel_sst_fw_ipc.h       |    6 ++
 drivers/staging/intel_sst/intel_sst_ipc.c          |   56 ++++++++++++++++-
 drivers/staging/intel_sst/intel_sst_stream.c       |   11 ++-
 .../staging/intel_sst/intel_sst_stream_encoded.c   |    8 +-
 drivers/staging/intel_sst/intelmid.c               |    2 -
 9 files changed, 148 insertions(+), 27 deletions(-)


diff --git a/drivers/staging/intel_sst/intel_sst.c b/drivers/staging/intel_sst/intel_sst.c
index 81c24d1..2f21f42 100644
--- a/drivers/staging/intel_sst/intel_sst.c
+++ b/drivers/staging/intel_sst/intel_sst.c
@@ -316,9 +316,25 @@ static int __devinit intel_sst_probe(struct pci_dev *pci,
 	if (sst_drv_ctx->pci_id == SST_MRST_PCI_ID) {
 		ret = misc_register(&lpe_dev);
 		if (ret) {
- 			pr_err("couldn't register misc driver\n");
+			pr_err("couldn't register LPE device\n");
 			goto do_free_misc;
  		}
+	} else if (sst_drv_ctx->pci_id == SST_MFLD_PCI_ID) {
+		u32 csr;
+
+		/*allocate mem for fw context save during suspend*/
+		sst_drv_ctx->fw_cntx = kzalloc(FW_CONTEXT_MEM, GFP_KERNEL);
+		if (!sst_drv_ctx->fw_cntx) {
+			ret = -ENOMEM;
+			goto do_free_misc;
+		}
+		/*setting zero as that is valid mem to restore*/
+		sst_drv_ctx->fw_cntx_size = 0;
+
+		/*set lpe start clock and ram size*/
+		csr = sst_shim_read(sst_drv_ctx->shim, SST_CSR);
+		csr |= 0x30060; /*remove the clock ratio after fw fix*/
+		sst_shim_write(sst_drv_ctx->shim, SST_CSR, csr);
 	}
 	sst_drv_ctx->lpe_stalled = 0;
 	pm_runtime_set_active(&pci->dev);
@@ -374,16 +390,17 @@ static void __devexit intel_sst_remove(struct pci_dev *pci)
 	sst_drv_ctx->sst_state = SST_UN_INIT;
 	mutex_unlock(&sst_drv_ctx->sst_lock);
 	misc_deregister(&lpe_ctrl);
-	if (sst_drv_ctx->pci_id == SST_MRST_PCI_ID)
-		misc_deregister(&lpe_dev);
 	free_irq(pci->irq, sst_drv_ctx);
 	iounmap(sst_drv_ctx->dram);
 	iounmap(sst_drv_ctx->iram);
 	iounmap(sst_drv_ctx->mailbox);
 	iounmap(sst_drv_ctx->shim);
 	sst_drv_ctx->pmic_state = SND_MAD_UN_INIT;
-	if (sst_drv_ctx->pci_id == SST_MRST_PCI_ID)
+	if (sst_drv_ctx->pci_id == SST_MRST_PCI_ID) {
+		misc_deregister(&lpe_dev);
 		kfree(sst_drv_ctx->mmap_mem);
+	} else
+		kfree(sst_drv_ctx->fw_cntx);
 	flush_scheduled_work();
 	destroy_workqueue(sst_drv_ctx->process_reply_wq);
 	destroy_workqueue(sst_drv_ctx->process_msg_wq);
@@ -398,6 +415,46 @@ static void __devexit intel_sst_remove(struct pci_dev *pci)
 	pci_set_drvdata(pci, NULL);
 }
 
+void sst_save_dsp_context(void)
+{
+	struct snd_sst_ctxt_params fw_context;
+	unsigned int pvt_id, i;
+	struct ipc_post *msg = NULL;
+
+	/*check cpu type*/
+	if (sst_drv_ctx->pci_id != SST_MFLD_PCI_ID)
+		return;
+		/*not supported for rest*/
+	if (sst_drv_ctx->sst_state != SST_FW_RUNNING) {
+		pr_debug("fw not running no context save ...\n");
+		return;
+	}
+
+	/*send msg to fw*/
+	if (sst_create_large_msg(&msg))
+		return;
+	pvt_id = sst_assign_pvt_id(sst_drv_ctx);
+	i = sst_get_block_stream(sst_drv_ctx);
+	sst_drv_ctx->alloc_block[i].sst_id = pvt_id;
+	sst_fill_header(&msg->header, IPC_IA_GET_FW_CTXT, 1, pvt_id);
+	msg->header.part.data = sizeof(fw_context) + sizeof(u32);
+	fw_context.address = virt_to_phys((void *)sst_drv_ctx->fw_cntx);
+	fw_context.size = FW_CONTEXT_MEM;
+	memcpy(msg->mailbox_data, &msg->header, sizeof(u32));
+	memcpy(msg->mailbox_data + sizeof(u32),
+				&fw_context, sizeof(fw_context));
+	spin_lock(&sst_drv_ctx->list_spin_lock);
+	list_add_tail(&msg->node, &sst_drv_ctx->ipc_dispatch_list);
+	spin_unlock(&sst_drv_ctx->list_spin_lock);
+	sst_post_message(&sst_drv_ctx->ipc_post_msg_wq);
+	/*wait for reply*/
+	if (sst_wait_timeout(sst_drv_ctx, &sst_drv_ctx->alloc_block[i]))
+		pr_debug("err fw context save timeout  ...\n");
+	sst_drv_ctx->alloc_block[i].sst_id = BLOCK_UNINIT;
+	pr_debug("fw context saved  ...\n");
+	return;
+}
+
 /* Power Management */
 /*
 * intel_sst_suspend - PCI suspend function
@@ -417,6 +474,8 @@ int intel_sst_suspend(struct pci_dev *pci, pm_message_t state)
 		pr_err("active streams,not able to suspend\n");
 		return -EBUSY;
 	}
+	/*save fw context*/
+	sst_save_dsp_context();
 	/*Assert RESET on LPE Processor*/
 	csr.full = sst_shim_read(sst_drv_ctx->shim, SST_CSR);
 	csr.full = csr.full | 0x2;
diff --git a/drivers/staging/intel_sst/intel_sst_common.h b/drivers/staging/intel_sst/intel_sst_common.h
index 0a60e86..0f48838 100644
--- a/drivers/staging/intel_sst/intel_sst_common.h
+++ b/drivers/staging/intel_sst/intel_sst_common.h
@@ -28,8 +28,8 @@
  *  Common private declarations for SST
  */
 
-#define SST_DRIVER_VERSION "1.2.09"
-#define SST_VERSION_NUM 0x1209
+#define SST_DRIVER_VERSION "1.2.11"
+#define SST_VERSION_NUM 0x1211
 
 /* driver names */
 #define SST_DRV_NAME "intel_sst_driver"
@@ -37,6 +37,7 @@
 #define SST_MFLD_PCI_ID 0x082F
 #define PCI_ID_LENGTH 4
 #define SST_SUSPEND_DELAY 2000
+#define FW_CONTEXT_MEM (64*1024)
 
 enum sst_states {
 	SST_FW_LOADED = 1,
@@ -94,7 +95,7 @@ enum sst_ram_type {
 /* SST shim registers to structure mapping  */
 union config_status_reg {
 	struct {
-		u32 rsvd0:1;
+		u32 mfld_strb:1;
 		u32 sst_reset:1;
 		u32 hw_rsvd:3;
 		u32 sst_clk:2;
@@ -417,6 +418,8 @@ struct intel_sst_drv {
 	unsigned int		audio_start;
 	dev_t			devt_d, devt_c;
 	unsigned int		max_streams;
+	unsigned int		*fw_cntx;
+	unsigned int		fw_cntx_size;
 };
 
 extern struct intel_sst_drv *sst_drv_ctx;
diff --git a/drivers/staging/intel_sst/intel_sst_drv_interface.c b/drivers/staging/intel_sst/intel_sst_drv_interface.c
index 971588c..78ee44d 100644
--- a/drivers/staging/intel_sst/intel_sst_drv_interface.c
+++ b/drivers/staging/intel_sst/intel_sst_drv_interface.c
@@ -508,6 +508,7 @@ int register_sst_card(struct intel_sst_card_ops *card)
 			sst_drv_ctx->pmic_state = SND_MAD_INIT_DONE;
 			sst_drv_ctx->rx_time_slot_status = 0; /*default AMIC*/
 			card->pcm_control = sst_pmic_ops.pcm_control;
+			sst_drv_ctx->scard_ops->card_status = SND_CARD_UN_INIT;
 			return 0;
 		} else {
 			pr_err("strcmp fail %s\n", card->module_name);
@@ -519,6 +520,7 @@ int register_sst_card(struct intel_sst_card_ops *card)
 		pr_err("Repeat for registration..denied\n");
 		return -EBADRQC;
 	}
+	sst_drv_ctx->scard_ops->card_status = SND_CARD_UN_INIT;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(register_sst_card);
diff --git a/drivers/staging/intel_sst/intel_sst_dsp.c b/drivers/staging/intel_sst/intel_sst_dsp.c
index bffe4c6..a89e1ad 100644
--- a/drivers/staging/intel_sst/intel_sst_dsp.c
+++ b/drivers/staging/intel_sst/intel_sst_dsp.c
@@ -73,7 +73,8 @@ static int intel_sst_reset_dsp_medfield(void)
 	union config_status_reg csr;
 
 	pr_debug("Resetting the DSP in medfield\n");
-	csr.full = 0x048303E2;
+	csr.full = sst_shim_read(sst_drv_ctx->shim, SST_CSR);
+	csr.full |= 0x382;
 	sst_shim_write(sst_drv_ctx->shim, SST_CSR, csr.full);
 
 	return 0;
@@ -109,11 +110,16 @@ static int sst_start_medfield(void)
 {
 	union config_status_reg csr;
 
-	csr.full = 0x04830062;
+	csr.full = sst_shim_read(sst_drv_ctx->shim, SST_CSR);
+	csr.part.bypass = 0;
 	sst_shim_write(sst_drv_ctx->shim, SST_CSR, csr.full);
-	csr.full = 0x04830063;
+	csr.full = sst_shim_read(sst_drv_ctx->shim, SST_CSR);
+	csr.part.mfld_strb = 1;
 	sst_shim_write(sst_drv_ctx->shim, SST_CSR, csr.full);
-	csr.full = 0x04830061;
+	csr.full = sst_shim_read(sst_drv_ctx->shim, SST_CSR);
+	csr.part.run_stall = 0;
+	csr.part.sst_reset = 0;
+	pr_debug("Starting the DSP_medfld %x\n", csr.full);
 	sst_shim_write(sst_drv_ctx->shim, SST_CSR, csr.full);
 	pr_debug("Starting the DSP_medfld\n");
 
diff --git a/drivers/staging/intel_sst/intel_sst_fw_ipc.h b/drivers/staging/intel_sst/intel_sst_fw_ipc.h
index 0f0c5bb..8628a8a 100644
--- a/drivers/staging/intel_sst/intel_sst_fw_ipc.h
+++ b/drivers/staging/intel_sst/intel_sst_fw_ipc.h
@@ -56,6 +56,8 @@
 #define IPC_IA_GET_FW_VERSION 0x04
 #define IPC_IA_GET_FW_BUILD_INF 0x05
 #define IPC_IA_GET_FW_INFO 0x06
+#define IPC_IA_GET_FW_CTXT 0x07
+#define IPC_IA_SET_FW_CTXT 0x08
 
 /* I2L Codec Config/control msgs */
 #define IPC_IA_SET_CODEC_PARAMS 0x10
@@ -406,4 +408,8 @@ struct ipc_post {
 	char *mailbox_data;
 };
 
+struct snd_sst_ctxt_params {
+	u32 address; /* Physical Address in DDR where the context is stored */
+	u32 size; /* size of the context */
+};
 #endif /* __INTEL_SST_FW_IPC_H__ */
diff --git a/drivers/staging/intel_sst/intel_sst_ipc.c b/drivers/staging/intel_sst/intel_sst_ipc.c
index 0742dde..878b19d 100644
--- a/drivers/staging/intel_sst/intel_sst_ipc.c
+++ b/drivers/staging/intel_sst/intel_sst_ipc.c
@@ -154,6 +154,37 @@ void sst_clear_interrupt(void)
 	sst_shim_write(sst_drv_ctx->shim, SST_IMRX, imr.full);
 }
 
+void sst_restore_fw_context(void)
+{
+	struct snd_sst_ctxt_params fw_context;
+	struct ipc_post *msg = NULL;
+
+	pr_debug("restore_fw_context\n");
+	/*check cpu type*/
+	if (sst_drv_ctx->pci_id != SST_MFLD_PCI_ID)
+		return;
+		/*not supported for rest*/
+	if (!sst_drv_ctx->fw_cntx_size)
+		return;
+		/*nothing to restore*/
+	pr_debug("restoring context......\n");
+	/*send msg to fw*/
+	if (sst_create_large_msg(&msg))
+		return;
+
+	sst_fill_header(&msg->header, IPC_IA_SET_FW_CTXT, 1, 0);
+	msg->header.part.data = sizeof(fw_context) + sizeof(u32);
+	fw_context.address = virt_to_phys((void *)sst_drv_ctx->fw_cntx);
+	fw_context.size = sst_drv_ctx->fw_cntx_size;
+	memcpy(msg->mailbox_data, &msg->header, sizeof(u32));
+	memcpy(msg->mailbox_data + sizeof(u32),
+				&fw_context, sizeof(fw_context));
+	spin_lock(&sst_drv_ctx->list_spin_lock);
+	list_add_tail(&msg->node, &sst_drv_ctx->ipc_dispatch_list);
+	spin_unlock(&sst_drv_ctx->list_spin_lock);
+	sst_post_message(&sst_drv_ctx->ipc_post_msg_wq);
+	return;
+}
 /*
  * process_fw_init - process the FW init msg
  *
@@ -184,13 +215,13 @@ int process_fw_init(struct sst_ipc_msg_wq *msg)
 	sst_drv_ctx->sst_state = SST_FW_RUNNING;
 	sst_drv_ctx->lpe_stalled = 0;
 	mutex_unlock(&sst_drv_ctx->sst_lock);
-	pr_debug("FW Version %x.%x\n",
-			init->fw_version.major, init->fw_version.minor);
-	pr_debug("Build No %x Type %x\n",
-			init->fw_version.build, init->fw_version.type);
+	pr_debug("FW Version %02x.%02x.%02x\n", init->fw_version.major,
+			init->fw_version.minor, init->fw_version.build);
+	pr_debug("Build Type %x\n", init->fw_version.type);
 	pr_debug(" Build date %s Time %s\n",
 			init->build_info.date, init->build_info.time);
 	sst_wake_up_alloc_block(sst_drv_ctx, FW_DWNL_ID, retval, NULL);
+	sst_restore_fw_context();
 	return retval;
 }
 /**
@@ -615,12 +646,18 @@ void sst_process_reply(struct work_struct *work)
 		break;
 
 	case IPC_IA_FREE_STREAM:
+		str_info = &sst_drv_ctx->streams[str_id];
 		if (!msg->header.part.data) {
 			pr_debug("Stream %d freed\n", str_id);
 		} else {
 			pr_err("Free for %d ret error %x\n",
 				       str_id, msg->header.part.data);
 		}
+		if (str_info->ctrl_blk.on == true) {
+			str_info->ctrl_blk.on = false;
+			str_info->ctrl_blk.condition = true;
+			wake_up(&sst_drv_ctx->wait_queue);
+		}
 		break;
 	case IPC_IA_ALLOC_STREAM: {
 		/* map to stream, call play */
@@ -699,6 +736,17 @@ void sst_process_reply(struct work_struct *work)
 	case IPC_IA_START_STREAM:
 		pr_debug("reply for START STREAM %x\n", msg->header.full);
 		break;
+
+	case IPC_IA_GET_FW_CTXT:
+		pr_debug("reply for get fw ctxt  %x\n", msg->header.full);
+		if (msg->header.part.data)
+			sst_drv_ctx->fw_cntx_size = 0;
+		else
+			sst_drv_ctx->fw_cntx_size = *sst_drv_ctx->fw_cntx;
+		pr_debug("fw copied data %x\n", sst_drv_ctx->fw_cntx_size);
+		sst_wake_up_alloc_block(
+			sst_drv_ctx, str_id, msg->header.part.data, NULL);
+		break;
 	default:
 		/* Illegal case */
 		pr_err("process reply:default = %x\n", msg->header.full);
diff --git a/drivers/staging/intel_sst/intel_sst_stream.c b/drivers/staging/intel_sst/intel_sst_stream.c
index dd58be5..55a561c 100644
--- a/drivers/staging/intel_sst/intel_sst_stream.c
+++ b/drivers/staging/intel_sst/intel_sst_stream.c
@@ -31,6 +31,7 @@
 #include <linux/pci.h>
 #include <linux/firmware.h>
 #include <linux/sched.h>
+#include <linux/delay.h>
 #include "intel_sst_ioctl.h"
 #include "intel_sst.h"
 #include "intel_sst_fw_ipc.h"
@@ -519,10 +520,6 @@ int sst_drain_stream(int str_id)
 	str_info->data_blk.on = true;
 	retval = sst_wait_interruptible(sst_drv_ctx, &str_info->data_blk);
 	str_info->need_draining = false;
-	if (retval == -SST_ERR_INVALID_STREAM_ID) {
-		retval = -EINVAL;
-		sst_clean_stream(str_info);
-	}
 	return retval;
 }
 
@@ -563,6 +560,12 @@ int sst_free_stream(int str_id)
 			str_info->data_blk.ret_code = 0;
 			wake_up(&sst_drv_ctx->wait_queue);
 		}
+		str_info->data_blk.on = true;
+		str_info->data_blk.condition = false;
+		retval = sst_wait_interruptible_timeout(sst_drv_ctx,
+				&str_info->ctrl_blk, SST_BLOCK_TIMEOUT);
+		pr_debug("wait for free returned %d\n", retval);
+		msleep(100);
 		mutex_lock(&sst_drv_ctx->stream_lock);
 		sst_clean_stream(str_info);
 		mutex_unlock(&sst_drv_ctx->stream_lock);
diff --git a/drivers/staging/intel_sst/intel_sst_stream_encoded.c b/drivers/staging/intel_sst/intel_sst_stream_encoded.c
index d5f07b8..2be58c5 100644
--- a/drivers/staging/intel_sst/intel_sst_stream_encoded.c
+++ b/drivers/staging/intel_sst/intel_sst_stream_encoded.c
@@ -363,7 +363,6 @@ int sst_parse_target(struct snd_sst_slot_info *slot)
 				pr_err("SST_Activate_target_fail\n");
 			else
 				pr_err("SST_Activate_target_pass\n");
-		return retval;
 	} else if (slot->action == SND_SST_PORT_PREPARE &&
 			slot->device_type == SND_SST_DEVICE_PCM) {
 				retval = sst_prepare_target(slot);
@@ -371,12 +370,11 @@ int sst_parse_target(struct snd_sst_slot_info *slot)
 				pr_err("SST_prepare_target_fail\n");
 			else
 				pr_err("SST_prepare_target_pass\n");
-			return retval;
 	} else {
 		pr_err("slot_action : %d, device_type: %d\n",
 				slot->action, slot->device_type);
-		return retval;
 	}
+	return retval;
 }
 
 int sst_send_target(struct snd_sst_target_device *target)
@@ -886,8 +884,7 @@ static int sst_prepare_input_buffers_rar(struct stream_info *str_info,
 			int *input_index, int *in_copied,
 			int *input_index_valid_size, int *new_entry_flag)
 {
-	int retval = 0;
-	int i;
+	int retval = 0, i;
 
 	if (str_info->ops == STREAM_OPS_PLAYBACK_DRM) {
 		struct RAR_buffer rar_buffers;
@@ -924,7 +921,6 @@ static int sst_prepare_input_buffers_rar(struct stream_info *str_info,
 	return retval;
 }
 #endif
-
 /*This function is used to prepare the kernel input buffers with contents
 before sending for decode*/
 static int sst_prepare_input_buffers(struct stream_info *str_info,
diff --git a/drivers/staging/intel_sst/intelmid.c b/drivers/staging/intel_sst/intelmid.c
index ebb6d03..0925a88 100644
--- a/drivers/staging/intel_sst/intelmid.c
+++ b/drivers/staging/intel_sst/intelmid.c
@@ -805,8 +805,6 @@ static int __devinit snd_intelmad_sst_register(
 		pr_err("sst card registration failed\n");
 		return ret_val;
 	}
-	sst_drv_ctx->scard_ops->card_status = SND_CARD_UN_INIT;
-
 	sst_card_vendor_id = intelmaddata->sstdrv_ops->vendor_id;
 	intelmaddata->pmic_status = PMIC_UNINIT;
 	return ret_val;

