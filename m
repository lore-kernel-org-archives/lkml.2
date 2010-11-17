Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934940Ab0KQQSM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 11:18:12 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:48244 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934864Ab0KQQSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 11:18:10 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/7] sst: Change the SST driver PCM interface
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 17 Nov 2010 15:58:11 +0000
Message-ID: <20101117155807.21681.28473.stgit@localhost.localdomain>
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

The PCM interface in SST driver is cmds only, this patch changes the interface to open, close and cmd interface.
This allows SST driver to keep easy track of handles open

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/intel_sst/intel_sst.h              |    8 +
 .../staging/intel_sst/intel_sst_app_interface.c    |   25 +++-
 drivers/staging/intel_sst/intel_sst_common.h       |    4 -
 .../staging/intel_sst/intel_sst_drv_interface.c    |  118 +++++++++++++-------
 drivers/staging/intel_sst/intel_sst_fw_ipc.h       |    1 
 drivers/staging/intel_sst/intel_sst_stream.c       |    2 
 .../staging/intel_sst/intel_sst_stream_encoded.c   |    9 +-
 drivers/staging/intel_sst/intelmid.c               |   37 +++---
 drivers/staging/intel_sst/intelmid_ctrl.c          |   13 +-
 drivers/staging/intel_sst/intelmid_pvt.c           |   10 +-
 10 files changed, 136 insertions(+), 91 deletions(-)


diff --git a/drivers/staging/intel_sst/intel_sst.h b/drivers/staging/intel_sst/intel_sst.h
index 1f19f0d..cb03ff7 100644
--- a/drivers/staging/intel_sst/intel_sst.h
+++ b/drivers/staging/intel_sst/intel_sst.h
@@ -29,6 +29,7 @@
  *	and middleware.
  *  This file is shared between the SST and MAD drivers
  */
+#include "intel_sst_ioctl.h"
 
 #define SST_CARD_NAMES "intel_mid_card"
 
@@ -107,10 +108,15 @@ struct snd_pmic_ops {
 	int (*power_down_pmic) (void);
 };
 
+struct intel_sst_pcm_control {
+	int (*open) (struct snd_sst_params *str_param);
+	int (*device_control) (int cmd, void *arg);
+	int (*close) (unsigned int str_id);
+};
 struct intel_sst_card_ops {
 	char *module_name;
 	unsigned int  vendor_id;
-	int (*control_set) (int control_element, void *value);
+	struct intel_sst_pcm_control *pcm_control;
 	struct snd_pmic_ops *scard_ops;
 };
 
diff --git a/drivers/staging/intel_sst/intel_sst_app_interface.c b/drivers/staging/intel_sst/intel_sst_app_interface.c
index 9618c79..60aca55 100644
--- a/drivers/staging/intel_sst/intel_sst_app_interface.c
+++ b/drivers/staging/intel_sst/intel_sst_app_interface.c
@@ -34,10 +34,9 @@
 #include <linux/uaccess.h>
 #include <linux/firmware.h>
 #include <linux/ioctl.h>
-#include <linux/smp_lock.h>
 #ifdef CONFIG_MRST_RAR_HANDLER
-#include <linux/rar_register.h>
-#include "../../../drivers/staging/memrar/memrar.h"
+#include "../rar_register/rar_register.h"
+#include "../memrar/memrar.h"
 #endif
 #include "intel_sst.h"
 #include "intel_sst_ioctl.h"
@@ -98,11 +97,15 @@ static int intel_sst_check_device(void)
  */
 int intel_sst_open(struct inode *i_node, struct file *file_ptr)
 {
-	int retval = intel_sst_check_device();
-	if (retval)
-		return retval;
+	unsigned int retval;
 
 	mutex_lock(&sst_drv_ctx->stream_lock);
+	retval = intel_sst_check_device();
+	if (retval) {
+		mutex_unlock(&sst_drv_ctx->stream_lock);
+		return retval;
+	}
+
 	if (sst_drv_ctx->encoded_cnt < MAX_ENC_STREAM) {
 		struct ioctl_pvt_data *data =
 			kzalloc(sizeof(struct ioctl_pvt_data), GFP_KERNEL);
@@ -137,12 +140,16 @@ int intel_sst_open(struct inode *i_node, struct file *file_ptr)
  */
 int intel_sst_open_cntrl(struct inode *i_node, struct file *file_ptr)
 {
-	int retval = intel_sst_check_device();
-	if (retval)
-		return retval;
+	unsigned int retval;
 
 	/* audio manager open */
 	mutex_lock(&sst_drv_ctx->stream_lock);
+	retval = intel_sst_check_device();
+	if (retval) {
+		mutex_unlock(&sst_drv_ctx->stream_lock);
+		return retval;
+	}
+
 	if (sst_drv_ctx->am_cnt < MAX_AM_HANDLES) {
 		sst_drv_ctx->am_cnt++;
 		pr_debug("sst: AM handle opened...\n");
diff --git a/drivers/staging/intel_sst/intel_sst_common.h b/drivers/staging/intel_sst/intel_sst_common.h
index bf0ead7..dcc1ebb 100644
--- a/drivers/staging/intel_sst/intel_sst_common.h
+++ b/drivers/staging/intel_sst/intel_sst_common.h
@@ -28,8 +28,8 @@
  *  Common private declarations for SST
  */
 
-#define SST_DRIVER_VERSION "1.2.05"
-#define SST_VERSION_NUM 0x1205
+#define SST_DRIVER_VERSION "1.2.09"
+#define SST_VERSION_NUM 0x1209
 
 /* driver names */
 #define SST_DRV_NAME "intel_sst_driver"
diff --git a/drivers/staging/intel_sst/intel_sst_drv_interface.c b/drivers/staging/intel_sst/intel_sst_drv_interface.c
index 669e298..22b95ca 100644
--- a/drivers/staging/intel_sst/intel_sst_drv_interface.c
+++ b/drivers/staging/intel_sst/intel_sst_drv_interface.c
@@ -286,18 +286,27 @@ void sst_process_mad_ops(struct work_struct *work)
 	}
 	return;
 }
+
+void send_intial_rx_timeslot(void)
+{
+	if (sst_drv_ctx->pci_id == SST_MRST_PCI_ID &&
+			sst_drv_ctx->rx_time_slot_status != RX_TIMESLOT_UNINIT
+			&& sst_drv_ctx->pmic_vendor != SND_NC)
+		sst_enable_rx_timeslot(sst_drv_ctx->rx_time_slot_status);
+}
+
 /*
- * sst_control_set - Set Control params
+ * sst_open_pcm_stream - Open PCM interface
  *
- * @control_list: list of controls to be set
+ * @str_param: parameters of pcm stream
  *
- * This function is called by MID sound card driver to set
- * SST/Sound card controls. This is registered with MID driver
+ * This function is called by MID sound card driver to open
+ * a new pcm interface
  */
-int sst_control_set(int control_element, void *value)
+int sst_open_pcm_stream(struct snd_sst_params *str_param)
 {
-	int retval = 0, str_id = 0;
-	struct stream_info *stream;
+	struct stream_info *str_info;
+	int retval;
 
 	if (sst_drv_ctx->sst_state == SST_SUSPENDED) {
 		/*LPE is suspended, resume it before proceding*/
@@ -316,53 +325,76 @@ int sst_control_set(int control_element, void *value)
 			pr_err("sst: FW download fail %x, abort\n", retval);
 			return retval;
 		}
-		if (sst_drv_ctx->pci_id == SST_MRST_PCI_ID &&
-			sst_drv_ctx->rx_time_slot_status != RX_TIMESLOT_UNINIT
-				&& sst_drv_ctx->pmic_vendor != SND_NC)
-			sst_enable_rx_timeslot(
-					sst_drv_ctx->rx_time_slot_status);
+		send_intial_rx_timeslot();
 	}
 
-	switch (control_element) {
-	case SST_SND_ALLOC: {
-		struct snd_sst_params *str_param;
-		struct stream_info *str_info;
+	if (!str_param)
+		return -EINVAL;
 
-		str_param = (struct snd_sst_params *)value;
-		BUG_ON(!str_param);
-		retval = sst_get_stream(str_param);
-		if (retval >= 0)
-			sst_drv_ctx->stream_cnt++;
+	retval = sst_get_stream(str_param);
+	if (retval > 0) {
+		sst_drv_ctx->stream_cnt++;
 		str_info = &sst_drv_ctx->streams[retval];
 		str_info->src = MAD_DRV;
-		break;
+
 	}
+	return retval;
+}
 
+/*
+ * sst_close_pcm_stream - Close PCM interface
+ *
+ * @str_id: stream id to be closed
+ *
+ * This function is called by MID sound card driver to close
+ * an existing pcm interface
+ */
+int sst_close_pcm_stream(unsigned int str_id)
+{
+	struct stream_info *stream;
+
+	pr_debug("sst: stream free called\n");
+	if (sst_validate_strid(str_id))
+		return -EINVAL;
+	stream = &sst_drv_ctx->streams[str_id];
+	free_stream_context(str_id);
+	stream->pcm_substream = NULL;
+	stream->status = STREAM_UN_INIT;
+	stream->period_elapsed = NULL;
+	sst_drv_ctx->stream_cnt--;
+	pr_debug("sst: will call runtime put now\n");
+	return 0;
+}
+/*
+ * sst_device_control - Set Control params
+ *
+ * @cmd: control cmd to be set
+ * @arg: command argument
+ *
+ * This function is called by MID sound card driver to set
+ * SST/Sound card controls for an opened stream.
+ * This is registered with MID driver
+ */
+int sst_device_control(int cmd, void *arg)
+{
+	int retval = 0, str_id = 0;
+
+	switch (cmd) {
 	case SST_SND_PAUSE:
 	case SST_SND_RESUME:
 	case SST_SND_DROP:
 	case SST_SND_START:
-		sst_drv_ctx->mad_ops.control_op = control_element;
-		sst_drv_ctx->mad_ops.stream_id = *(int *)value;
+		sst_drv_ctx->mad_ops.control_op = cmd;
+		sst_drv_ctx->mad_ops.stream_id = *(int *)arg;
 		queue_work(sst_drv_ctx->mad_wq, &sst_drv_ctx->mad_ops.wq);
 		break;
 
-	case SST_SND_FREE:
-		str_id = *(int *)value;
-		stream = &sst_drv_ctx->streams[str_id];
-		free_stream_context(str_id);
-		stream->pcm_substream = NULL;
-		stream->status = STREAM_UN_INIT;
-		stream->period_elapsed = NULL;
-		sst_drv_ctx->stream_cnt--;
-		break;
-
 	case SST_SND_STREAM_INIT: {
 		struct pcm_stream_info *str_info;
 		struct stream_info *stream;
 
 		pr_debug("sst: stream init called\n");
-		str_info = (struct pcm_stream_info *)value;
+		str_info = (struct pcm_stream_info *)arg;
 		str_id = str_info->str_id;
 		retval = sst_validate_strid(str_id);
 		if (retval)
@@ -384,7 +416,7 @@ int sst_control_set(int control_element, void *value)
 		struct stream_info *stream;
 
 
-		stream_info = (struct pcm_stream_info *)value;
+		stream_info = (struct pcm_stream_info *)arg;
 		str_id = stream_info->str_id;
 		retval = sst_validate_strid(str_id);
 		if (retval)
@@ -410,7 +442,7 @@ int sst_control_set(int control_element, void *value)
 		break;
 	}
 	case SST_ENABLE_RX_TIME_SLOT: {
-		int status = *(int *)value;
+		int status = *(int *)arg;
 		sst_drv_ctx->rx_time_slot_status = status ;
 		sst_enable_rx_timeslot(status);
 		break;
@@ -425,8 +457,14 @@ int sst_control_set(int control_element, void *value)
 }
 
 
+struct intel_sst_pcm_control pcm_ops = {
+	.open = sst_open_pcm_stream,
+	.device_control = sst_device_control,
+	.close = sst_close_pcm_stream,
+};
+
 struct intel_sst_card_ops sst_pmic_ops = {
-	.control_set = sst_control_set,
+	.pcm_control = &pcm_ops,
 };
 
 /*
@@ -456,7 +494,7 @@ int register_sst_card(struct intel_sst_card_ops *card)
 			sst_pmic_ops.module_name = card->module_name;
 			sst_drv_ctx->pmic_state = SND_MAD_INIT_DONE;
 			sst_drv_ctx->rx_time_slot_status = 0; /*default AMIC*/
-			card->control_set = sst_pmic_ops.control_set;
+			card->pcm_control = sst_pmic_ops.pcm_control;
 			sst_drv_ctx->scard_ops->card_status = SND_CARD_UN_INIT;
 			return 0;
 		} else {
@@ -482,7 +520,7 @@ EXPORT_SYMBOL_GPL(register_sst_card);
  */
 void unregister_sst_card(struct intel_sst_card_ops *card)
 {
-	if (sst_pmic_ops.control_set == card->control_set) {
+	if (sst_pmic_ops.pcm_control == card->pcm_control) {
 		/* unreg */
 		sst_pmic_ops.module_name = "";
 		sst_drv_ctx->pmic_state = SND_MAD_UN_INIT;
diff --git a/drivers/staging/intel_sst/intel_sst_fw_ipc.h b/drivers/staging/intel_sst/intel_sst_fw_ipc.h
index 9d3c368..1a2f67f 100644
--- a/drivers/staging/intel_sst/intel_sst_fw_ipc.h
+++ b/drivers/staging/intel_sst/intel_sst_fw_ipc.h
@@ -31,6 +31,7 @@
 */
 
 #define MAX_NUM_STREAMS_MRST 3
+#define MAX_NUM_STREAMS_MFLD 6
 #define MAX_NUM_STREAMS 6
 #define MAX_DBG_RW_BYTES 80
 #define MAX_NUM_SCATTER_BUFFERS 8
diff --git a/drivers/staging/intel_sst/intel_sst_stream.c b/drivers/staging/intel_sst/intel_sst_stream.c
index b2c4b70..1ce3a9c 100644
--- a/drivers/staging/intel_sst/intel_sst_stream.c
+++ b/drivers/staging/intel_sst/intel_sst_stream.c
@@ -45,7 +45,7 @@
  */
 int sst_check_device_type(u32 device, u32 num_chan, u32 *pcm_slot)
 {
-	if (device >= MAX_NUM_STREAMS) {
+	if (device > MAX_NUM_STREAMS_MFLD) {
 		pr_debug("sst: device type invalid %d\n", device);
 		return -EINVAL;
 	}
diff --git a/drivers/staging/intel_sst/intel_sst_stream_encoded.c b/drivers/staging/intel_sst/intel_sst_stream_encoded.c
index fbae39f..d4d37ed 100644
--- a/drivers/staging/intel_sst/intel_sst_stream_encoded.c
+++ b/drivers/staging/intel_sst/intel_sst_stream_encoded.c
@@ -30,9 +30,9 @@
 #include <linux/syscalls.h>
 #include <linux/firmware.h>
 #include <linux/sched.h>
-#include <linux/rar_register.h>
 #ifdef CONFIG_MRST_RAR_HANDLER
-#include "../../../drivers/staging/memrar/memrar.h"
+#include "../rar_register/rar_register.h"
+#include "../memrar/memrar.h"
 #endif
 #include "intel_sst_ioctl.h"
 #include "intel_sst.h"
@@ -878,13 +878,13 @@ static int sst_send_decode_mess(int str_id, struct stream_info *str_info,
 	return retval;
 }
 
+#ifdef CONFIG_MRST_RAR_HANDLER
 static int sst_prepare_input_buffers_rar(struct stream_info *str_info,
 			struct snd_sst_dbufs *dbufs,
 			int *input_index, int *in_copied,
 			int *input_index_valid_size, int *new_entry_flag)
 {
 	int retval = 0;
-#ifdef CONFIG_MRST_RAR_HANDLER
 	int i;
 
 	if (str_info->ops == STREAM_OPS_PLAYBACK_DRM) {
@@ -919,9 +919,10 @@ static int sst_prepare_input_buffers_rar(struct stream_info *str_info,
 		str_info->decode_ibuf_type = dbufs->ibufs->type;
 		*in_copied = str_info->decode_isize;
 	}
-#endif
 	return retval;
 }
+#endif
+
 /*This function is used to prepare the kernel input buffers with contents
 before sending for decode*/
 static int sst_prepare_input_buffers(struct stream_info *str_info,
diff --git a/drivers/staging/intel_sst/intelmid.c b/drivers/staging/intel_sst/intelmid.c
index 4c0264c..963f476 100644
--- a/drivers/staging/intel_sst/intelmid.c
+++ b/drivers/staging/intel_sst/intelmid.c
@@ -101,12 +101,10 @@ static struct snd_pcm_hardware snd_intelmad_stream = {
 static int snd_intelmad_pcm_trigger(struct snd_pcm_substream *substream,
 					int cmd)
 {
-	int ret_val = 0;
+	int ret_val = 0, str_id;
 	struct snd_intelmad *intelmaddata;
 	struct mad_stream_pvt *stream;
-	/*struct stream_buffer buffer_to_sst;*/
-
-
+	struct intel_sst_pcm_control *sst_ops;
 
 	WARN_ON(!substream);
 
@@ -115,38 +113,35 @@ static int snd_intelmad_pcm_trigger(struct snd_pcm_substream *substream,
 
 	WARN_ON(!intelmaddata->sstdrv_ops);
 	WARN_ON(!intelmaddata->sstdrv_ops->scard_ops);
+	sst_ops  = intelmaddata->sstdrv_ops->pcm_control;
+	str_id = stream->stream_info.str_id;
 
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_START:
 		pr_debug("sst: Trigger Start\n");
-		ret_val = intelmaddata->sstdrv_ops->control_set(SST_SND_START,
-				&stream->stream_info.str_id);
+		ret_val = sst_ops->device_control(SST_SND_START, &str_id);
 		if (ret_val)
 			return ret_val;
 		stream->stream_status = RUNNING;
 		stream->substream = substream;
-		stream->stream_status = RUNNING;
 		break;
 	case SNDRV_PCM_TRIGGER_STOP:
 		pr_debug("sst: in stop\n");
-		ret_val = intelmaddata->sstdrv_ops->control_set(SST_SND_DROP,
-				&stream->stream_info.str_id);
+		ret_val = sst_ops->device_control(SST_SND_DROP, &str_id);
 		if (ret_val)
 			return ret_val;
 		stream->stream_status = DROPPED;
 		break;
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
 		pr_debug("sst: in pause\n");
-		ret_val = intelmaddata->sstdrv_ops->control_set(SST_SND_PAUSE,
-				&stream->stream_info.str_id);
+		ret_val = sst_ops->device_control(SST_SND_PAUSE, &str_id);
 		if (ret_val)
 			return ret_val;
 		stream->stream_status = PAUSED;
 		break;
 	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
 		pr_debug("sst: in pause release\n");
-		ret_val = intelmaddata->sstdrv_ops->control_set(SST_SND_RESUME,
-						&stream->stream_info.str_id);
+		ret_val = sst_ops->device_control(SST_SND_RESUME, &str_id);
 		if (ret_val)
 			return ret_val;
 		stream->stream_status = RUNNING;
@@ -181,8 +176,8 @@ static int snd_intelmad_pcm_prepare(struct snd_pcm_substream *substream)
 
 	if (stream->stream_info.str_id) {
 		pr_debug("sst: Prepare called for already set stream\n");
-		ret_val = intelmaddata->sstdrv_ops->control_set(SST_SND_DROP,
-					&stream->stream_info.str_id);
+		ret_val = intelmaddata->sstdrv_ops->pcm_control->device_control(
+				SST_SND_DROP, &stream->stream_info.str_id);
 		return ret_val;
 	}
 
@@ -250,8 +245,8 @@ static snd_pcm_uframes_t snd_intelmad_pcm_pointer
 	if (stream->stream_status == INIT)
 		return 0;
 
-	ret_val = intelmaddata->sstdrv_ops->control_set(SST_SND_BUFFER_POINTER,
-				&stream->stream_info);
+	ret_val = intelmaddata->sstdrv_ops->pcm_control->device_control(
+			SST_SND_BUFFER_POINTER, &stream->stream_info);
 	if (ret_val) {
 		pr_err("sst: error code = 0x%x\n", ret_val);
 		return ret_val;
@@ -277,20 +272,20 @@ static int snd_intelmad_close(struct snd_pcm_substream *substream)
 {
 	struct snd_intelmad *intelmaddata;
 	struct mad_stream_pvt *stream;
-	int ret_val = 0;
+	int ret_val = 0, str_id;
 
 	WARN_ON(!substream);
 
 	stream = substream->runtime->private_data;
+	str_id = stream->stream_info.str_id;
 
-	pr_debug("sst: snd_intelmad_close called\n");
+	pr_debug("sst: snd_intelmad_close called for %d\n", str_id);
 	intelmaddata = snd_pcm_substream_chip(substream);
 
 	pr_debug("sst: str id = %d\n", stream->stream_info.str_id);
 	if (stream->stream_info.str_id) {
 		/* SST API to actually stop/free the stream */
-		ret_val = intelmaddata->sstdrv_ops->control_set(SST_SND_FREE,
-				&stream->stream_info.str_id);
+		ret_val = intelmaddata->sstdrv_ops->pcm_control->close(str_id);
 		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
 			intelmaddata->playback_cnt--;
 		else
diff --git a/drivers/staging/intel_sst/intelmid_ctrl.c b/drivers/staging/intel_sst/intelmid_ctrl.c
index 03b4ece..0f7d60a 100644
--- a/drivers/staging/intel_sst/intelmid_ctrl.c
+++ b/drivers/staging/intel_sst/intelmid_ctrl.c
@@ -491,6 +491,7 @@ static int snd_intelmad_device_set(struct snd_kcontrol *kcontrol,
 	struct snd_intelmad *intelmaddata;
 	struct snd_pmic_ops *scard_ops;
 	int ret_val = 0, vendor, status;
+	struct intel_sst_pcm_control *pcm_control;
 
 	pr_debug("sst: snd_intelmad_device_set called\n");
 
@@ -518,15 +519,13 @@ static int snd_intelmad_device_set(struct snd_kcontrol *kcontrol,
 	case INPUT_SEL:
 		vendor = intelmaddata->sstdrv_ops->vendor_id;
 		if ((vendor == SND_MX) || (vendor == SND_FS)) {
-			if (uval->value.enumerated.item[0] == HS_MIC) {
+			pcm_control = intelmaddata->sstdrv_ops->pcm_control;
+			if (uval->value.enumerated.item[0] == HS_MIC)
 				status = 1;
-				intelmaddata->sstdrv_ops->
-				control_set(SST_ENABLE_RX_TIME_SLOT, &status);
-			} else {
+			else
 				status = 0;
-				intelmaddata->sstdrv_ops->
-				control_set(SST_ENABLE_RX_TIME_SLOT, &status);
-			}
+			pcm_control->device_control(
+					SST_ENABLE_RX_TIME_SLOT, &status);
 		}
 		ret_val = scard_ops->set_input_dev(
 				uval->value.enumerated.item[0]);
diff --git a/drivers/staging/intel_sst/intelmid_pvt.c b/drivers/staging/intel_sst/intelmid_pvt.c
index 9ed9475..e8938d9 100644
--- a/drivers/staging/intel_sst/intelmid_pvt.c
+++ b/drivers/staging/intel_sst/intelmid_pvt.c
@@ -92,10 +92,8 @@ int snd_intelmad_alloc_stream(struct snd_pcm_substream *substream)
 		pr_debug("sst: Capture stream,Device %d\n", stream->device);
 	}
 	str_params.device_type = stream->device;
-	ret_val = intelmaddata->sstdrv_ops->control_set(SST_SND_ALLOC,
-					&str_params);
-	pr_debug("sst: SST_SND_PLAY/CAPTURE ret_val = %x\n",
-			ret_val);
+	ret_val = intelmaddata->sstdrv_ops->pcm_control->open(&str_params);
+	pr_debug("sst: SST_SND_PLAY/CAPTURE ret_val = %x\n", ret_val);
 	if (ret_val < 0)
 		return ret_val;
 
@@ -118,8 +116,8 @@ int snd_intelmad_init_stream(struct snd_pcm_substream *substream)
 	stream->stream_info.mad_substream = substream;
 	stream->stream_info.buffer_ptr = 0;
 	stream->stream_info.sfreq = substream->runtime->rate;
-	ret_val = intelmaddata->sstdrv_ops->control_set(SST_SND_STREAM_INIT,
-					&stream->stream_info);
+	ret_val = intelmaddata->sstdrv_ops->pcm_control->device_control(
+			SST_SND_STREAM_INIT, &stream->stream_info);
 	if (ret_val)
 		pr_err("sst: control_set ret error %d\n", ret_val);
 	return ret_val;

