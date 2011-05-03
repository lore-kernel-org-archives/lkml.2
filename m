Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab1ECRx0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 13:53:26 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36881 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343Ab1ECRxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 13:53:06 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 08/23] intel_sst: rework jack implementation
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 03 May 2011 17:33:13 +0100
Message-ID: <20110503163312.24853.98308.stgit@bob.linux.org.uk>
In-Reply-To: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
References: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ramesh Babu K V <ramesh.babu@intel.com>

This patch fixes the below issues w.r.t jack implementation

a) The current jack implementation in driver is implemented
   in intelmid.c. It has moved to vendor files for better managebility
b) Cleaned up jack reporting per upstream comments
c) Implemented jack for msic, added code to read adc and deduce jack
   type based on mic bias
d) Support detection of american headset

Signed-off-by: Dharageswari R <dharageswari.r@intel.com>
Signed-off-by: Ramesh Babu K V <ramesh.babu@intel.com>
[Corrections]
Signed-off-by: Lu Guanqun <guanqun.lu@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/intel_sst/intel_sst.h             |   16 +
 drivers/staging/intel_sst/intel_sst_common.h      |    4 
 drivers/staging/intel_sst/intelmid.c              |  449 +++++----------------
 drivers/staging/intel_sst/intelmid.h              |   14 +
 drivers/staging/intel_sst/intelmid_adc_control.h  |  193 +++++++++
 drivers/staging/intel_sst/intelmid_ctrl.c         |    1 
 drivers/staging/intel_sst/intelmid_msic_control.c |  258 ++++++++++++
 drivers/staging/intel_sst/intelmid_pvt.c          |    1 
 drivers/staging/intel_sst/intelmid_v0_control.c   |  111 +++++
 drivers/staging/intel_sst/intelmid_v1_control.c   |  142 ++++++-
 drivers/staging/intel_sst/intelmid_v2_control.c   |   69 +++
 drivers/staging/intel_sst/jack.h                  |   10 
 12 files changed, 887 insertions(+), 381 deletions(-)
 create mode 100644 drivers/staging/intel_sst/intelmid_adc_control.h
 delete mode 100644 drivers/staging/intel_sst/jack.h


diff --git a/drivers/staging/intel_sst/intel_sst.h b/drivers/staging/intel_sst/intel_sst.h
index c0d3156..986a3df 100644
--- a/drivers/staging/intel_sst/intel_sst.h
+++ b/drivers/staging/intel_sst/intel_sst.h
@@ -30,6 +30,7 @@
  *  This file is shared between the SST and MAD drivers
  */
 #include "intel_sst_ioctl.h"
+#include <sound/jack.h>
 
 #define SST_CARD_NAMES "intel_mid_card"
 
@@ -88,6 +89,7 @@ struct snd_pmic_ops {
 	int output_dev_id;
 	int lineout_dev_id, line_out_names_cnt;
 	int prev_lineout_dev_id;
+	bool jack_interrupt_status;
 	int (*set_input_dev) (u8 value);
 	int (*set_output_dev) (u8 value);
 	int (*set_lineout_dev) (u8 value);
@@ -109,11 +111,25 @@ struct snd_pmic_ops {
 	int (*power_down_pmic_pb) (unsigned int device);
 	int (*power_down_pmic_cp) (unsigned int device);
 	int (*power_down_pmic) (void);
+	void (*pmic_irq_cb) (void *cb_data, u8 value);
+	void (*pmic_irq_enable)(void *data);
+	int (*pmic_jack_enable) (void);
+	int (*pmic_get_mic_bias)(void *intelmaddata);
+	int (*pmic_set_headset_state)(int state);
+
 	unsigned int hw_dmic_map[MFLD_MAX_HW_CH];
 	unsigned int available_dmics;
 	int (*set_hw_dmic_route) (u8 index);
 };
 
+extern void sst_mad_send_jack_report(struct snd_jack *jack,
+				     int buttonpressevent,
+				     int status);
+
+
+int intemad_set_headset_state(int state);
+int intelmad_get_mic_bias(void);
+
 struct intel_sst_pcm_control {
 	int (*open) (struct snd_sst_params *str_param);
 	int (*device_control) (int cmd, void *arg);
diff --git a/drivers/staging/intel_sst/intel_sst_common.h b/drivers/staging/intel_sst/intel_sst_common.h
index e37b377..f8e9da6 100644
--- a/drivers/staging/intel_sst/intel_sst_common.h
+++ b/drivers/staging/intel_sst/intel_sst_common.h
@@ -28,8 +28,8 @@
  *  Common private declarations for SST
  */
 
-#define SST_DRIVER_VERSION "1.2.15"
-#define SST_VERSION_NUM 0x1215
+#define SST_DRIVER_VERSION "1.2.17"
+#define SST_VERSION_NUM 0x1217
 
 /* driver names */
 #define SST_DRV_NAME "intel_sst_driver"
diff --git a/drivers/staging/intel_sst/intelmid.c b/drivers/staging/intel_sst/intelmid.c
index ee070e3..61ef4a6 100644
--- a/drivers/staging/intel_sst/intelmid.c
+++ b/drivers/staging/intel_sst/intelmid.c
@@ -33,10 +33,11 @@
 #include <linux/interrupt.h>
 #include <linux/sched.h>
 #include <linux/firmware.h>
+#include <linux/input.h>
 #include <sound/control.h>
 #include <asm/mrst.h>
 #include <sound/pcm.h>
-#include "jack.h"
+#include <sound/jack.h>
 #include <sound/pcm_params.h>
 #include <sound/initval.h>
 #include "intel_sst.h"
@@ -44,6 +45,7 @@
 #include "intel_sst_fw_ipc.h"
 #include "intel_sst_common.h"
 #include "intelmid_snd_control.h"
+#include "intelmid_adc_control.h"
 #include "intelmid.h"
 
 MODULE_AUTHOR("Vinod Koul <vinod.koul@intel.com>");
@@ -65,7 +67,14 @@ MODULE_PARM_DESC(card_id, "ID string for INTELMAD soundcard.");
 
 int	sst_card_vendor_id;
 int intelmid_audio_interrupt_enable;/*checkpatch fix*/
-
+struct snd_intelmad *intelmad_drv;
+
+#define INFO(_cpu_id, _irq_cache, _size) \
+	((kernel_ulong_t)&(struct snd_intelmad_probe_info) {	\
+		.cpu_id = (_cpu_id),			\
+		.irq_cache = (_irq_cache),			\
+		.size = (_size),				\
+	})
 /* Data path functionalities */
 static struct snd_pcm_hardware snd_intelmad_stream = {
 	.info =	(SNDRV_PCM_INFO_INTERLEAVED |
@@ -426,7 +435,55 @@ static struct snd_pcm_ops snd_intelmad_capture_ops = {
 	.pointer = snd_intelmad_pcm_pointer,
 };
 
+int intelmad_get_mic_bias(void)
+{
+	struct snd_pmic_ops *pmic_ops;
+
+	if (!intelmad_drv || !intelmad_drv->sstdrv_ops)
+		return -ENODEV;
+	pmic_ops = intelmad_drv->sstdrv_ops->scard_ops;
+	if (pmic_ops && pmic_ops->pmic_get_mic_bias)
+		return pmic_ops->pmic_get_mic_bias(intelmad_drv);
+	else
+		return -ENODEV;
+}
+EXPORT_SYMBOL_GPL(intelmad_get_mic_bias);
+
+int intelmad_set_headset_state(int state)
+{
+	struct snd_pmic_ops *pmic_ops;
+
+	if (!intelmad_drv || !intelmad_drv->sstdrv_ops)
+		return -ENODEV;
+	pmic_ops = intelmad_drv->sstdrv_ops->scard_ops;
+	if (pmic_ops && pmic_ops->pmic_set_headset_state)
+		return pmic_ops->pmic_set_headset_state(state);
+	else
+		return -ENODEV;
+}
+EXPORT_SYMBOL_GPL(intelmad_set_headset_state);
+
+void sst_process_mad_jack_detection(struct work_struct *work)
+{
+	u8 interrupt_status;
+	struct mad_jack_msg_wq *mad_jack_detect =
+			container_of(work, struct mad_jack_msg_wq, wq);
+
+	struct snd_intelmad *intelmaddata =
+			mad_jack_detect->intelmaddata;
 
+	if (!intelmaddata)
+		return;
+
+	interrupt_status = mad_jack_detect->intsts;
+	if (intelmaddata->sstdrv_ops && intelmaddata->sstdrv_ops->scard_ops
+			&& intelmaddata->sstdrv_ops->scard_ops->pmic_irq_cb) {
+		intelmaddata->sstdrv_ops->scard_ops->pmic_irq_cb(
+			(void *)intelmaddata, interrupt_status);
+		intelmaddata->sstdrv_ops->scard_ops->pmic_jack_enable();
+	}
+	kfree(mad_jack_detect);
+}
 /**
  * snd_intelmad_intr_handler- interrupt handler
  *
@@ -439,15 +496,17 @@ static irqreturn_t snd_intelmad_intr_handler(int irq, void *dev)
 {
 	struct snd_intelmad *intelmaddata =
 			(struct snd_intelmad *)dev;
-	u8 intsts;
-
-	memcpy_fromio(&intsts,
+	u8 interrupt_status;
+	struct mad_jack_msg_wq  *mad_jack_msg;
+	memcpy_fromio(&interrupt_status,
 			((void *)(intelmaddata->int_base)),
 			sizeof(u8));
-	intelmaddata->mad_jack_msg.intsts = intsts;
-	intelmaddata->mad_jack_msg.intelmaddata = intelmaddata;
 
-	queue_work(intelmaddata->mad_jack_wq, &intelmaddata->mad_jack_msg.wq);
+	mad_jack_msg = kzalloc(sizeof(*mad_jack_msg), GFP_ATOMIC);
+	mad_jack_msg->intsts = interrupt_status;
+	mad_jack_msg->intelmaddata = intelmaddata;
+	INIT_WORK(&mad_jack_msg->wq, sst_process_mad_jack_detection);
+	queue_work(intelmaddata->mad_jack_wq, &mad_jack_msg->wq);
 
 	return IRQ_HANDLED;
 }
@@ -460,286 +519,22 @@ void sst_mad_send_jack_report(struct snd_jack *jack,
 		pr_debug("MAD error jack empty\n");
 
 	} else {
-		pr_debug("MAD send jack report for = %d!!!\n", status);
-		pr_debug("MAD send jack report %d\n", jack->type);
 		snd_jack_report(jack, status);
-
-		/*button pressed and released */
+		/* button pressed and released */
 		if (buttonpressevent)
 			snd_jack_report(jack, 0);
 		pr_debug("MAD sending jack report Done !!!\n");
 	}
-
-
-
-}
-
-void sst_mad_jackdetection_fs(u8 intsts , struct snd_intelmad *intelmaddata)
-{
-	struct snd_jack *jack = NULL;
-	unsigned int present = 0, jack_event_flag = 0, buttonpressflag = 0;
-	struct sc_reg_access sc_access[] = {
-				{0x187, 0x00, MASK7},
-				{0x188, 0x10, MASK4},
-				{0x18b, 0x10, MASK4},
-	};
-
-	struct sc_reg_access sc_access_write[] = {
-				{0x198, 0x00, 0x0},
-	};
-
-	if (intsts & 0x4) {
-
-		if (!(intelmid_audio_interrupt_enable)) {
-			pr_debug("Audio interrupt enable\n");
-			sst_sc_reg_access(sc_access, PMIC_READ_MODIFY, 3);
-
-			sst_sc_reg_access(sc_access_write, PMIC_WRITE, 1);
-			intelmid_audio_interrupt_enable = 1;
-			intelmaddata->jack[0].jack_status = 0;
-			intelmaddata->jack[1].jack_status = 0;
-
-		}
-		/* send headphone detect */
-		pr_debug("MAD headphone %d\n", intsts & 0x4);
-		jack = &intelmaddata->jack[0].jack;
-		present = !(intelmaddata->jack[0].jack_status);
-		intelmaddata->jack[0].jack_status = present;
-		jack_event_flag = 1;
-
-	}
-
-	if (intsts & 0x2) {
-		/* send short push */
-		pr_debug("MAD short push %d\n", intsts & 0x2);
-		jack = &intelmaddata->jack[2].jack;
-		present = 1;
-		jack_event_flag = 1;
-		buttonpressflag = 1;
-	}
-	if (intsts & 0x1) {
-		/* send long push */
-		pr_debug("MAD long push %d\n", intsts & 0x1);
-		jack = &intelmaddata->jack[3].jack;
-		present = 1;
-		jack_event_flag = 1;
-		buttonpressflag = 1;
-	}
-	if (intsts & 0x8) {
-		if (!(intelmid_audio_interrupt_enable)) {
-			pr_debug("Audio interrupt enable\n");
-			sst_sc_reg_access(sc_access, PMIC_READ_MODIFY, 3);
-
-			sst_sc_reg_access(sc_access_write, PMIC_WRITE, 1);
-			intelmid_audio_interrupt_enable = 1;
-			intelmaddata->jack[0].jack_status = 0;
-			intelmaddata->jack[1].jack_status = 0;
-		}
-		/* send headset detect */
-		pr_debug("MAD headset = %d\n", intsts & 0x8);
-		jack = &intelmaddata->jack[1].jack;
-		present = !(intelmaddata->jack[1].jack_status);
-		intelmaddata->jack[1].jack_status = present;
-		jack_event_flag = 1;
-	}
-
-	if (jack_event_flag)
-		sst_mad_send_jack_report(jack, buttonpressflag, present);
 }
 
-
-void sst_mad_jackdetection_mx(u8 intsts, struct snd_intelmad *intelmaddata)
-{
-	u8 value = 0, jack_prev_state = 0;
-	struct snd_jack *jack = NULL;
-	unsigned int present = 0, jack_event_flag = 0, buttonpressflag = 0;
-	time_t  timediff;
-	struct sc_reg_access sc_access_read = {0,};
-	struct snd_pmic_ops *scard_ops;
-
-	scard_ops = intelmaddata->sstdrv_ops->scard_ops;
-
-	pr_debug("previous value: %x\n", intelmaddata->jack_prev_state);
-
-	if (!(intelmid_audio_interrupt_enable)) {
-		pr_debug("Audio interrupt enable\n");
-		intelmaddata->jack_prev_state = 0xC0;
-		intelmid_audio_interrupt_enable = 1;
-	}
-
-	if (intsts & 0x2) {
-		jack_prev_state = intelmaddata->jack_prev_state;
-		if (intelmaddata->pmic_status == PMIC_INIT) {
-			sc_access_read.reg_addr = 0x201;
-			sst_sc_reg_access(&sc_access_read, PMIC_READ, 1);
-			value = (sc_access_read.value);
-			pr_debug("value returned = 0x%x\n", value);
-		}
-
-		if (jack_prev_state == 0xc0 && value == 0x40) {
-			/*headset detected. */
-			pr_debug("MAD headset inserted\n");
-			jack = &intelmaddata->jack[1].jack;
-			present = 1;
-			jack_event_flag = 1;
-			intelmaddata->jack[1].jack_status = 1;
-
-		}
-
-		if (jack_prev_state == 0xc0 && value == 0x00) {
-			/* headphone  detected. */
-			pr_debug("MAD headphone inserted\n");
-			jack = &intelmaddata->jack[0].jack;
-			present = 1;
-			jack_event_flag = 1;
-
-		}
-
-		if (jack_prev_state == 0x40 && value == 0xc0) {
-			/*headset  removed*/
-			pr_debug("Jack headset status %d\n",
-				intelmaddata->jack[1].jack_status);
-			pr_debug("MAD headset removed\n");
-			jack = &intelmaddata->jack[1].jack;
-			present = 0;
-			jack_event_flag = 1;
-			intelmaddata->jack[1].jack_status = 0;
-		}
-
-		if (jack_prev_state == 0x00 && value == 0xc0) {
-			/* headphone  detected. */
-			pr_debug("Jack headphone status %d\n",
-					intelmaddata->jack[0].jack_status);
-			pr_debug("headphone removed\n");
-			jack = &intelmaddata->jack[0].jack;
-			present = 0;
-			jack_event_flag = 1;
-		}
-
-		if (jack_prev_state == 0x40 && value == 0x00) {
-			/*button pressed*/
-			do_gettimeofday(&intelmaddata->jack[1].buttonpressed);
-			pr_debug("MAD button press detected\n");
-		}
-
-
-		if (jack_prev_state == 0x00 && value == 0x40) {
-			if (intelmaddata->jack[1].jack_status) {
-				/*button pressed*/
-				do_gettimeofday(
-					&intelmaddata->jack[1].buttonreleased);
-				/*button pressed */
-				pr_debug("Button Released detected\n");
-				timediff = intelmaddata->jack[1].
-					buttonreleased.tv_sec - intelmaddata->
-					jack[1].buttonpressed.tv_sec;
-				buttonpressflag = 1;
-				if (timediff > 1) {
-					pr_debug("long press detected\n");
-					/* send headphone detect/undetect */
-					jack = &intelmaddata->jack[3].jack;
-					present = 1;
-					jack_event_flag = 1;
-				} else {
-					pr_debug("short press detected\n");
-					/* send headphone detect/undetect */
-					jack = &intelmaddata->jack[2].jack;
-					present = 1;
-					jack_event_flag = 1;
-				}
-			}
-
-		}
-		intelmaddata->jack_prev_state = value;
-	}
-	if (jack_event_flag)
-		sst_mad_send_jack_report(jack, buttonpressflag, present);
-}
-
-
-void sst_mad_jackdetection_nec(u8 intsts, struct snd_intelmad *intelmaddata)
-{
-	u8 value = 0;
-	struct snd_jack *jack = NULL;
-	unsigned int present = 0, jack_event_flag = 0, buttonpressflag = 0;
-	struct sc_reg_access sc_access_read = {0,};
-
-	if (intelmaddata->pmic_status == PMIC_INIT) {
-		sc_access_read.reg_addr = 0x132;
-		sst_sc_reg_access(&sc_access_read, PMIC_READ, 1);
-		value = (sc_access_read.value);
-		pr_debug("value returned = 0x%x\n", value);
-	}
-	if (intsts & 0x1) {
-		pr_debug("headset detected\n");
-		/* send headset detect/undetect */
-		jack = &intelmaddata->jack[1].jack;
-		present = (value == 0x1) ? 1 : 0;
-		jack_event_flag = 1;
-	}
-	if (intsts & 0x2) {
-		pr_debug("headphone detected\n");
-		/* send headphone detect/undetect */
-		jack = &intelmaddata->jack[0].jack;
-		present = (value == 0x2) ? 1 : 0;
-		jack_event_flag = 1;
-	}
-	if (intsts & 0x4) {
-		pr_debug("short push detected\n");
-		/* send short push */
-		jack = &intelmaddata->jack[2].jack;
-		present = 1;
-		jack_event_flag = 1;
-		buttonpressflag = 1;
-	}
-	if (intsts & 0x8) {
-		pr_debug("long push detected\n");
-		/* send long push */
-		jack = &intelmaddata->jack[3].jack;
-		present = 1;
-		jack_event_flag = 1;
-		buttonpressflag = 1;
-	}
-
-	if (jack_event_flag)
-		sst_mad_send_jack_report(jack, buttonpressflag, present);
-
-
-}
-
-void sst_process_mad_jack_detection(struct work_struct *work)
-{
-	u8 intsts;
-	struct mad_jack_msg_wq *mad_jack_detect =
-			container_of(work, struct mad_jack_msg_wq, wq);
-
-	struct snd_intelmad *intelmaddata =
-			mad_jack_detect->intelmaddata;
-
-	intsts = mad_jack_detect->intsts;
-
-	switch (intelmaddata->sstdrv_ops->vendor_id) {
-	case SND_FS:
-		sst_mad_jackdetection_fs(intsts , intelmaddata);
-		break;
-	case SND_MX:
-		sst_mad_jackdetection_mx(intsts , intelmaddata);
-		break;
-	case SND_NC:
-		sst_mad_jackdetection_nec(intsts , intelmaddata);
-		break;
-	}
-}
-
-
 static int __devinit snd_intelmad_register_irq(
-					struct snd_intelmad *intelmaddata)
+		struct snd_intelmad *intelmaddata, unsigned int regbase,
+		unsigned int regsize)
 {
 	int ret_val;
-	u32 regbase = AUDINT_BASE, regsize = 8;
 	char *drv_name;
 
-	pr_debug("irq reg done, regbase 0x%x, regsize 0x%x\n",
+	pr_debug("irq reg regbase 0x%x, regsize 0x%x\n",
 					regbase, regsize);
 	intelmaddata->int_base = ioremap_nocache(regbase, regsize);
 	if (!intelmaddata->int_base)
@@ -811,6 +606,10 @@ static int __devinit snd_intelmad_sst_register(
 	return ret_val;
 }
 
+static void snd_intelmad_page_free(struct snd_pcm *pcm)
+{
+	snd_pcm_lib_preallocate_free_for_all(pcm);
+}
 /* Driver Init/exit functionalities */
 /**
  * snd_intelmad_pcm_new - to setup pcm for the card
@@ -862,6 +661,7 @@ static int __devinit snd_intelmad_pcm_new(struct snd_card *card,
 		snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, cap_ops);
 	/* setup private data which can be retrieved when required */
 	pcm->private_data = intelmaddata;
+	pcm->private_free = snd_intelmad_page_free;
 	pcm->info_flags = 0;
 	strncpy(pcm->name, card->shortname, strlen(card->shortname));
 	/* allocate dma pages for ALSA stream operations */
@@ -906,8 +706,12 @@ static int snd_intelmad_jack(struct snd_intelmad *intelmaddata)
 
 	pr_debug("snd_intelmad_jack called\n");
 	jack = &intelmaddata->jack[0].jack;
-	retval = snd_jack_new(intelmaddata->card, "Headphone",
-				SND_JACK_HEADPHONE, &jack);
+	snd_jack_set_key(jack, SND_JACK_BTN_0, KEY_PHONE);
+	retval = snd_jack_new(intelmaddata->card, "Intel(R) MID Audio Jack",
+		SND_JACK_HEADPHONE | SND_JACK_HEADSET |
+		SW_JACK_PHYSICAL_INSERT | SND_JACK_BTN_0
+		| SND_JACK_BTN_1, &jack);
+	pr_debug("snd_intelmad_jack called\n");
 	if (retval < 0)
 		return retval;
 	snd_jack_report(jack, 0);
@@ -915,40 +719,6 @@ static int snd_intelmad_jack(struct snd_intelmad *intelmaddata)
 	jack->private_data = jack;
 	intelmaddata->jack[0].jack = *jack;
 
-
-	jack = &intelmaddata->jack[1].jack;
-	retval = snd_jack_new(intelmaddata->card, "Headset",
-				SND_JACK_HEADSET, &jack);
-	if (retval < 0)
-		return retval;
-
-
-
-	jack->private_data = jack;
-	intelmaddata->jack[1].jack = *jack;
-
-
-	jack = &intelmaddata->jack[2].jack;
-	retval = snd_jack_new(intelmaddata->card, "Short Press",
-				SND_JACK_HS_SHORT_PRESS, &jack);
-	if (retval < 0)
-		return retval;
-
-
-	jack->private_data = jack;
-	intelmaddata->jack[2].jack = *jack;
-
-
-	jack = &intelmaddata->jack[3].jack;
-	retval = snd_jack_new(intelmaddata->card, "Long Press",
-				SND_JACK_HS_LONG_PRESS, &jack);
-	if (retval < 0)
-		return retval;
-
-
-	jack->private_data = jack;
-	intelmaddata->jack[3].jack = *jack;
-
 	return retval;
 }
 
@@ -1001,14 +771,14 @@ static int snd_intelmad_dev_free(struct snd_device *device)
 	intelmaddata = device->device_data;
 
 	pr_debug("snd_intelmad_dev_free called\n");
-	snd_card_free(intelmaddata->card);
-	/*genl_unregister_family(&audio_event_genl_family);*/
 	unregister_sst_card(intelmaddata->sstdrv_ops);
 
 	/* free allocated memory for internal context */
 	destroy_workqueue(intelmaddata->mad_jack_wq);
+	device->device_data = NULL;
 	kfree(intelmaddata->sstdrv_ops);
 	kfree(intelmaddata);
+
 	return 0;
 }
 
@@ -1039,9 +809,10 @@ int __devinit snd_intelmad_probe(struct platform_device *pdev)
 	int ret_val;
 	struct snd_intelmad *intelmaddata;
 	const struct platform_device_id *id = platform_get_device_id(pdev);
-	unsigned int cpu_id = (unsigned int)id->driver_data;
+	struct snd_intelmad_probe_info *info = (void *)id->driver_data;
 
-	pr_debug("probe for %s cpu_id %d\n", pdev->name, cpu_id);
+	pr_debug("probe for %s cpu_id %d\n", pdev->name, info->cpu_id);
+	pr_debug("rq_chache %x of size %x\n", info->irq_cache, info->size);
 	if (!strcmp(pdev->name, DRIVER_NAME_MRST))
 		pr_debug("detected MRST\n");
 	else if (!strcmp(pdev->name, DRIVER_NAME_MFLD))
@@ -1050,7 +821,8 @@ int __devinit snd_intelmad_probe(struct platform_device *pdev)
 		pr_err("detected unknown device abort!!\n");
 		return -EIO;
 	}
-	if ((cpu_id < CPU_CHIP_LINCROFT) || (cpu_id > CPU_CHIP_PENWELL)) {
+	if ((info->cpu_id < CPU_CHIP_LINCROFT) ||
+				(info->cpu_id > CPU_CHIP_PENWELL)) {
 		pr_err("detected unknown cpu_id abort!!\n");
 		return -EIO;
 	}
@@ -1060,6 +832,7 @@ int __devinit snd_intelmad_probe(struct platform_device *pdev)
 		pr_debug("mem alloctn fail\n");
 		return -ENOMEM;
 	}
+	intelmad_drv = intelmaddata;
 
 	/* allocate memory for LPE API set */
 	intelmaddata->sstdrv_ops = kzalloc(sizeof(struct intel_sst_card_ops),
@@ -1070,7 +843,7 @@ int __devinit snd_intelmad_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	intelmaddata->cpu_id = cpu_id;
+	intelmaddata->cpu_id = info->cpu_id;
 	/* create a card instance with ALSA framework */
 	ret_val = snd_card_create(card_index, card_id, THIS_MODULE, 0, &card);
 	if (ret_val) {
@@ -1094,7 +867,7 @@ int __devinit snd_intelmad_probe(struct platform_device *pdev)
 	ret_val = snd_intelmad_sst_register(intelmaddata);
 	if (ret_val) {
 		pr_err("snd_intelmad_sst_register failed\n");
-		goto free_allocs;
+		goto set_null_data;
 	}
 
 	intelmaddata->pmic_status = PMIC_INIT;
@@ -1102,20 +875,21 @@ int __devinit snd_intelmad_probe(struct platform_device *pdev)
 	ret_val = snd_intelmad_pcm(card, intelmaddata);
 	if (ret_val) {
 		pr_err("snd_intelmad_pcm failed\n");
-		goto free_allocs;
+		goto free_sst;
 	}
 
 	ret_val = snd_intelmad_mixer(intelmaddata);
 	if (ret_val) {
 		pr_err("snd_intelmad_mixer failed\n");
-		goto free_allocs;
+		goto free_card;
 	}
 
 	ret_val = snd_intelmad_jack(intelmaddata);
 	if (ret_val) {
 		pr_err("snd_intelmad_jack failed\n");
-		goto free_allocs;
+		goto free_card;
 	}
+	intelmaddata->adc_address = mid_initialize_adc();
 
 	/*create work queue for jack interrupt*/
 	INIT_WORK(&intelmaddata->mad_jack_msg.wq,
@@ -1123,33 +897,42 @@ int __devinit snd_intelmad_probe(struct platform_device *pdev)
 
 	intelmaddata->mad_jack_wq = create_workqueue("sst_mad_jack_wq");
 	if (!intelmaddata->mad_jack_wq)
-		goto free_mad_jack_wq;
+		goto free_card;
 
-	ret_val = snd_intelmad_register_irq(intelmaddata);
+	ret_val = snd_intelmad_register_irq(intelmaddata,
+					info->irq_cache, info->size);
 	if (ret_val) {
 		pr_err("snd_intelmad_register_irq fail\n");
-		goto free_allocs;
+		goto free_mad_jack_wq;
 	}
 
 	/* internal function call to register device with ALSA */
 	ret_val = snd_intelmad_create(intelmaddata, card);
 	if (ret_val) {
 		pr_err("snd_intelmad_create failed\n");
-		goto free_allocs;
+		goto set_pvt_data;;
 	}
 	card->private_data = &intelmaddata;
 	snd_card_set_dev(card, &pdev->dev);
 	ret_val = snd_card_register(card);
 	if (ret_val) {
 		pr_err("snd_card_register failed\n");
-		goto free_allocs;
+		goto set_pvt_data;;
 	}
 
 	pr_debug("snd_intelmad_probe complete\n");
 	return ret_val;
 
+set_pvt_data:
+	card->private_data = NULL;
 free_mad_jack_wq:
 	destroy_workqueue(intelmaddata->mad_jack_wq);
+free_card:
+	snd_card_free(intelmaddata->card);
+free_sst:
+	unregister_sst_card(intelmaddata->sstdrv_ops);
+set_null_data:
+	platform_set_drvdata(pdev, NULL);
 free_allocs:
 	pr_err("probe failed\n");
 	snd_card_free(card);
@@ -1164,13 +947,11 @@ static int snd_intelmad_remove(struct platform_device *pdev)
 	struct snd_intelmad *intelmaddata = platform_get_drvdata(pdev);
 
 	if (intelmaddata) {
+		free_irq(intelmaddata->irq, intelmaddata);
 		snd_card_free(intelmaddata->card);
-		unregister_sst_card(intelmaddata->sstdrv_ops);
-		/* free allocated memory for internal context */
-		destroy_workqueue(intelmaddata->mad_jack_wq);
-		kfree(intelmaddata->sstdrv_ops);
-		kfree(intelmaddata);
 	}
+	intelmad_drv = NULL;
+	platform_set_drvdata(pdev, NULL);
 	return 0;
 }
 
@@ -1178,8 +959,8 @@ static int snd_intelmad_remove(struct platform_device *pdev)
  *		Driver initialization and exit
  *********************************************************************/
 static const struct platform_device_id snd_intelmad_ids[] = {
-	{DRIVER_NAME_MRST, CPU_CHIP_LINCROFT},
-	{DRIVER_NAME_MFLD, CPU_CHIP_PENWELL},
+	{DRIVER_NAME_MRST, INFO(CPU_CHIP_LINCROFT, AUDINT_BASE, 1)},
+	{DRIVER_NAME_MFLD, INFO(CPU_CHIP_PENWELL, 0xFFFF7FCD, 1)},
 	{"", 0},
 
 };
diff --git a/drivers/staging/intel_sst/intelmid.h b/drivers/staging/intel_sst/intelmid.h
index 7b3dbf6..3201d5a 100644
--- a/drivers/staging/intel_sst/intelmid.h
+++ b/drivers/staging/intel_sst/intelmid.h
@@ -67,12 +67,17 @@
 #define MIN_VOL		0
 #define PLAYBACK_COUNT  1
 #define CAPTURE_COUNT	1
+#define ADC_ONE_LSB_MULTIPLIER 2346
+
+#define MID_JACK_HS_LONG_PRESS SND_JACK_BTN_0
+#define MID_JACK_HS_SHORT_PRESS SND_JACK_BTN_1
 
 extern int	sst_card_vendor_id;
 
 struct mad_jack {
 	struct snd_jack jack;
 	int jack_status;
+	int jack_dev_state;
 	struct timeval buttonpressed;
 	struct timeval  buttonreleased;
 };
@@ -84,6 +89,12 @@ struct mad_jack_msg_wq {
 
 };
 
+struct snd_intelmad_probe_info {
+	unsigned int cpu_id;
+	unsigned int irq_cache;
+	unsigned int size;
+};
+
 /**
  * struct snd_intelmad - intelmad driver structure
  *
@@ -122,6 +133,7 @@ struct snd_intelmad {
 	struct mad_jack jack[4];
 	int playback_cnt;
 	int capture_cnt;
+	u16 adc_address;
 	struct mad_jack_msg_wq  mad_jack_msg;
 	struct workqueue_struct *mad_jack_wq;
 	u8 jack_prev_state;
@@ -188,5 +200,7 @@ extern struct snd_control_val intelmad_ctrl_val[];
 extern struct snd_kcontrol_new snd_intelmad_controls_mrst[];
 extern struct snd_kcontrol_new snd_intelmad_controls_mfld[];
 extern struct snd_pmic_ops *intelmad_vendor_ops[];
+void sst_mad_send_jack_report(struct snd_jack *jack,
+			int buttonpressevent , int status);
 
 #endif /* __INTELMID_H */
diff --git a/drivers/staging/intel_sst/intelmid_adc_control.h b/drivers/staging/intel_sst/intelmid_adc_control.h
new file mode 100644
index 0000000..65d5c39
--- /dev/null
+++ b/drivers/staging/intel_sst/intelmid_adc_control.h
@@ -0,0 +1,193 @@
+#ifndef __INTELMID_ADC_CONTROL_H__
+#define __INTELMID_ADC_CONTROL_H_
+/*
+ *  intelmid_adc_control.h - Intel SST Driver for audio engine
+ *
+ *  Copyright (C) 2008-10 Intel Corporation
+ *  Authors:	R Durgadadoss <r.durgadoss@intel.com>
+ *		Dharageswari R <dharageswari.r@intel.com>
+ *  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ *  Common private ADC declarations for SST
+ */
+
+
+#define MSIC_ADC1CNTL1		0x1C0
+#define MSIC_ADC_ENBL		0x10
+#define MSIC_ADC_START		0x08
+
+#define MSIC_ADC1CNTL3		0x1C2
+#define MSIC_ADCTHERM_ENBL	0x04
+#define MSIC_ADCRRDATA_ENBL	0x05
+
+#define MSIC_STOPBIT_MASK	16
+#define MSIC_ADCTHERM_MASK	4
+
+#define ADC_CHANLS_MAX		15 /* Number of ADC channels */
+#define ADC_LOOP_MAX		(ADC_CHANLS_MAX - 1)
+
+/* ADC channel code values */
+#define AUDIO_DETECT_CODE	0x06
+
+/* ADC base addresses */
+#define ADC_CHNL_START_ADDR	0x1C5	/* increments by 1 */
+#define ADC_DATA_START_ADDR     0x1D4   /* increments by 2 */
+
+
+/**
+ * configure_adc - enables/disables the ADC for conversion
+ * @val: zero: disables the ADC non-zero:enables the ADC
+ *
+ * Enable/Disable the ADC depending on the argument
+ *
+ * Can sleep
+ */
+static inline int configure_adc(int val)
+{
+	int ret;
+	struct sc_reg_access sc_access = {0,};
+
+
+	sc_access.reg_addr = MSIC_ADC1CNTL1;
+	ret = sst_sc_reg_access(&sc_access, PMIC_READ, 1);
+	if (ret)
+		return ret;
+
+	if (val)
+		/* Enable and start the ADC */
+		sc_access.value |= (MSIC_ADC_ENBL | MSIC_ADC_START);
+	else
+		/* Just stop the ADC */
+		sc_access.value &= (~MSIC_ADC_START);
+	sc_access.reg_addr = MSIC_ADC1CNTL1;
+	return sst_sc_reg_access(&sc_access, PMIC_WRITE, 1);
+}
+
+/**
+ * reset_stopbit - sets the stop bit to 0 on the given channel
+ * @addr: address of the channel
+ *
+ * Can sleep
+ */
+static inline int reset_stopbit(uint16_t addr)
+{
+	int ret;
+	struct sc_reg_access sc_access = {0,};
+	sc_access.reg_addr = addr;
+	ret = sst_sc_reg_access(&sc_access, PMIC_READ, 1);
+	if (ret)
+		return ret;
+	/* Set the stop bit to zero */
+	sc_access.reg_addr = addr;
+	sc_access.value = (sc_access.value) & 0xEF;
+	return sst_sc_reg_access(&sc_access, PMIC_WRITE, 1);
+}
+
+/**
+ * find_free_channel - finds an empty channel for conversion
+ *
+ * If the ADC is not enabled then start using 0th channel
+ * itself. Otherwise find an empty channel by looking for a
+ * channel in which the stopbit is set to 1. returns the index
+ * of the first free channel if succeeds or an error code.
+ *
+ * Context: can sleep
+ *
+ */
+static inline int find_free_channel(void)
+{
+	int ret;
+	int i;
+
+	struct sc_reg_access sc_access = {0,};
+
+	/* check whether ADC is enabled */
+	sc_access.reg_addr = MSIC_ADC1CNTL1;
+	ret = sst_sc_reg_access(&sc_access, PMIC_READ, 1);
+	if (ret)
+		return ret;
+
+	if ((sc_access.value & MSIC_ADC_ENBL) == 0)
+		return 0;
+
+	/* ADC is already enabled; Looking for an empty channel */
+	for (i = 0; i < ADC_CHANLS_MAX; i++) {
+
+		sc_access.reg_addr = ADC_CHNL_START_ADDR + i;
+		ret = sst_sc_reg_access(&sc_access, PMIC_READ, 1);
+		if (ret)
+			return ret;
+
+		if (sc_access.value & MSIC_STOPBIT_MASK) {
+			ret = i;
+			break;
+		}
+	}
+	return (ret > ADC_LOOP_MAX) ? (-EINVAL) : ret;
+}
+
+/**
+ * mid_initialize_adc - initializing the ADC
+ * @dev: our device structure
+ *
+ * Initialize the ADC for reading thermistor values. Can sleep.
+ */
+static inline int mid_initialize_adc(void)
+{
+	int base_addr, chnl_addr;
+	int ret;
+	static int channel_index;
+	struct sc_reg_access sc_access = {0,};
+
+	/* Index of the first channel in which the stop bit is set */
+	channel_index = find_free_channel();
+	if (channel_index < 0) {
+		pr_err("No free ADC channels");
+		return channel_index;
+	}
+
+	base_addr = ADC_CHNL_START_ADDR + channel_index;
+
+	if (!(channel_index == 0 || channel_index == ADC_LOOP_MAX)) {
+		/* Reset stop bit for channels other than 0 and 12 */
+		ret = reset_stopbit(base_addr);
+		if (ret)
+			return ret;
+
+		/* Index of the first free channel */
+		base_addr++;
+		channel_index++;
+	}
+
+	/* Since this is the last channel, set the stop bit
+	   to 1 by ORing the DIE_SENSOR_CODE with 0x10 */
+	sc_access.reg_addr = base_addr;
+	sc_access.value = AUDIO_DETECT_CODE | 0x10;
+	ret = sst_sc_reg_access(&sc_access, PMIC_WRITE, 1);
+	if (ret) {
+		pr_err("unable to enable ADC");
+		return ret;
+	}
+
+	chnl_addr = ADC_DATA_START_ADDR + 2 * channel_index;
+	pr_debug("mid_initialize : %x", chnl_addr);
+	configure_adc(1);
+	return chnl_addr;
+}
+#endif
+
diff --git a/drivers/staging/intel_sst/intelmid_ctrl.c b/drivers/staging/intel_sst/intelmid_ctrl.c
index dbe29c3..2c3ee94 100644
--- a/drivers/staging/intel_sst/intelmid_ctrl.c
+++ b/drivers/staging/intel_sst/intelmid_ctrl.c
@@ -29,7 +29,6 @@
 
 #include <sound/core.h>
 #include <sound/control.h>
-#include "jack.h"
 #include "intel_sst.h"
 #include "intel_sst_ioctl.h"
 #include "intelmid_snd_control.h"
diff --git a/drivers/staging/intel_sst/intelmid_msic_control.c b/drivers/staging/intel_sst/intelmid_msic_control.c
index 976091b..70cdb16 100644
--- a/drivers/staging/intel_sst/intelmid_msic_control.c
+++ b/drivers/staging/intel_sst/intelmid_msic_control.c
@@ -89,6 +89,7 @@ static int msic_init_card(void)
 	snd_msic_ops.cap_on = 0;
 	snd_msic_ops.input_dev_id = DMIC; /*def dev*/
 	snd_msic_ops.output_dev_id = STEREO_HEADPHONE;
+	snd_msic_ops.jack_interrupt_status = false;
 	pr_debug("msic init complete!!\n");
 	return 0;
 }
@@ -109,6 +110,9 @@ static int msic_line_out_restore(u8 value)
 	struct sc_reg_access vib2_drv_en[] = {
 		{0x25d, 0x20, 0x20},
 	};
+	struct sc_reg_access pmode_enable[] = {
+		{0x381, 0x10, 0x10},
+	};
 	int retval = 0;
 
 	pr_debug("msic_lineout_restore_lineout_dev:%d\n", value);
@@ -126,6 +130,9 @@ static int msic_line_out_restore(u8 value)
 	case IHF:
 		pr_debug("Selecting Lineout-IHF-restore\n");
 		retval = sst_sc_reg_access(ihf_drv_en, PMIC_READ_MODIFY, 1);
+		if (retval)
+			return retval;
+		retval = sst_sc_reg_access(pmode_enable, PMIC_READ_MODIFY, 1);
 		break;
 	case VIBRA1:
 		pr_debug("Selecting Lineout-Vibra1-restore\n");
@@ -255,6 +262,12 @@ static int msic_set_selected_lineout_dev(u8 value)
 	struct sc_reg_access lout_def[] = {
 		{0x25e, 0x66, 0x0},
 	};
+	struct sc_reg_access pmode_disable[] = {
+		{0x381, 0x00, 0x10},
+	};
+	struct sc_reg_access pmode_enable[] = {
+		{0x381, 0x10, 0x10},
+	};
 	int retval = 0;
 
 	pr_debug("msic_set_selected_lineout_dev:%d\n", value);
@@ -268,29 +281,49 @@ static int msic_set_selected_lineout_dev(u8 value)
 		if (snd_msic_ops.pb_on)
 			retval = sst_sc_reg_access(lout_hs,
 					PMIC_READ_MODIFY, 2);
+			if (retval)
+				return retval;
+			retval = sst_sc_reg_access(pmode_disable,
+					PMIC_READ_MODIFY, 1);
 		break;
 	case IHF:
 		pr_debug("Selecting Lineout-IHF\n");
 		if (snd_msic_ops.pb_on)
 			retval = sst_sc_reg_access(lout_ihf,
 							PMIC_READ_MODIFY, 2);
+			if (retval)
+				return retval;
+			retval = sst_sc_reg_access(pmode_enable,
+					PMIC_READ_MODIFY, 1);
 		break;
 	case VIBRA1:
 		pr_debug("Selecting Lineout-Vibra1\n");
 		if (snd_msic_ops.pb_on)
 			retval = sst_sc_reg_access(lout_vibra1,
 							PMIC_READ_MODIFY, 2);
+			if (retval)
+				return retval;
+			retval = sst_sc_reg_access(pmode_disable,
+					PMIC_READ_MODIFY, 1);
 		break;
 	case VIBRA2:
 		pr_debug("Selecting Lineout-VIBRA2\n");
 		if (snd_msic_ops.pb_on)
 			retval = sst_sc_reg_access(lout_vibra2,
 							PMIC_READ_MODIFY, 2);
+			if (retval)
+				return retval;
+			retval = sst_sc_reg_access(pmode_disable,
+					PMIC_READ_MODIFY, 1);
 		break;
 	case NONE:
 		pr_debug("Selecting Lineout-NONE\n");
 			retval = sst_sc_reg_access(lout_def,
 							PMIC_WRITE, 1);
+			if (retval)
+				return retval;
+			retval = sst_sc_reg_access(pmode_disable,
+					PMIC_READ_MODIFY, 1);
 		break;
 	default:
 		return -EINVAL;
@@ -311,11 +344,12 @@ static int msic_power_up_pb(unsigned int device)
 	};
 	struct sc_reg_access vhs[] = {
 		/*  VHSP */
-		{0x0DC, 0xFF, 0},
+		{0x0DC, 0x3D, 0},
 		/*  VHSN */
 		{0x0DD, 0x3F, 0},
 	};
 	struct sc_reg_access hsdac[] = {
+		{0x382, 0x40, 0x40},
 		/*  disable driver */
 		{0x25D, 0x0, 0x43},
 		/* DAC CONFIG ; both HP, LP on */
@@ -401,7 +435,7 @@ static int msic_power_up_pb(unsigned int device)
 		snd_msic_ops.pbhs_on = 1;
 		if (snd_msic_ops.output_dev_id == STEREO_HEADPHONE) {
 			sst_sc_reg_access(vhs, PMIC_WRITE, 2);
-			sst_sc_reg_access(hsdac, PMIC_READ_MODIFY, 2);
+			sst_sc_reg_access(hsdac, PMIC_READ_MODIFY, 3);
 			sst_sc_reg_access(hs_filter, PMIC_WRITE, 2);
 			sst_sc_reg_access(hs_enable, PMIC_READ_MODIFY, 4);
 		} else {
@@ -555,6 +589,7 @@ static int msic_power_down_pb(unsigned int device)
 	struct sc_reg_access hs_off[] = {
 		{0x257, 0x00, 0x03},
 		{0x250, 0x00, 0x30},
+		{0x382, 0x00, 0x40},
 	};
 	struct sc_reg_access ihf_mute[] = {
 		{0x25B, 0x80, 0x80},
@@ -573,6 +608,9 @@ static int msic_power_down_pb(unsigned int device)
 	struct sc_reg_access lout_off[] = {
 		{0x25e, 0x66, 0x00},
 	};
+	struct sc_reg_access pmode_disable[] = {
+		{0x381, 0x00, 0x10},
+	};
 
 
 
@@ -583,7 +621,7 @@ static int msic_power_down_pb(unsigned int device)
 		sst_sc_reg_access(hs_mute, PMIC_READ_MODIFY, 3);
 		drv_enable[0].mask = 0x43;
 		sst_sc_reg_access(drv_enable, PMIC_READ_MODIFY, 1);
-		sst_sc_reg_access(hs_off, PMIC_READ_MODIFY, 2);
+		sst_sc_reg_access(hs_off, PMIC_READ_MODIFY, 3);
 		if (snd_msic_ops.lineout_dev_id == HEADSET)
 			sst_sc_reg_access(lout_off, PMIC_WRITE, 1);
 		break;
@@ -593,8 +631,10 @@ static int msic_power_down_pb(unsigned int device)
 		drv_enable[0].mask = 0x0C;
 		sst_sc_reg_access(drv_enable, PMIC_READ_MODIFY, 1);
 		sst_sc_reg_access(ihf_off, PMIC_READ_MODIFY, 2);
-		if (snd_msic_ops.lineout_dev_id == IHF)
+		if (snd_msic_ops.lineout_dev_id == IHF) {
 			sst_sc_reg_access(lout_off, PMIC_WRITE, 1);
+			sst_sc_reg_access(pmode_disable, PMIC_READ_MODIFY, 1);
+		}
 		break;
 
 	case SND_SST_DEVICE_VIBRA:
@@ -777,6 +817,210 @@ static int msic_get_vol(int dev_id, int *value)
 	return 0;
 }
 
+static int msic_set_headset_state(int state)
+{
+	struct sc_reg_access hs_enable[] = {
+		{0x25D, 0x03, 0x03},
+	};
+
+	if (state)
+		/*enable*/
+		sst_sc_reg_access(hs_enable, PMIC_READ_MODIFY, 1);
+	else {
+		hs_enable[0].value = 0;
+		sst_sc_reg_access(hs_enable, PMIC_READ_MODIFY, 1);
+	}
+	return 0;
+}
+
+static int msic_enable_mic_bias(void)
+{
+	struct sc_reg_access jack_interrupt_reg[] = {
+		{0x0DB, 0x07, 0x00},
+
+	};
+	struct sc_reg_access jack_bias_reg[] = {
+		{0x247, 0x0C, 0x0C},
+	};
+
+	sst_sc_reg_access(jack_interrupt_reg, PMIC_WRITE, 1);
+	sst_sc_reg_access(jack_bias_reg, PMIC_READ_MODIFY, 1);
+	return 0;
+}
+
+static int msic_disable_mic_bias(void)
+{
+	if (snd_msic_ops.jack_interrupt_status == true)
+		return 0;
+	if (!(snd_msic_ops.pb_on || snd_msic_ops.cap_on))
+		msic_power_down();
+	return 0;
+}
+
+static int msic_disable_jack_btn(void)
+{
+	struct sc_reg_access btn_disable[] = {
+		{0x26C, 0x00, 0x01}
+	};
+
+	if (!(snd_msic_ops.pb_on || snd_msic_ops.cap_on))
+		msic_power_down();
+	snd_msic_ops.jack_interrupt_status = false;
+	return sst_sc_reg_access(btn_disable, PMIC_READ_MODIFY, 1);
+}
+
+static int msic_enable_jack_btn(void)
+{
+	struct sc_reg_access btn_enable[] = {
+			{0x26b, 0x77, 0x00},
+			{0x26C, 0x01, 0x00},
+	};
+	return sst_sc_reg_access(btn_enable, PMIC_WRITE, 2);
+}
+static int msic_convert_adc_to_mvolt(unsigned int mic_bias)
+{
+	return (ADC_ONE_LSB_MULTIPLIER * mic_bias) / 1000;
+}
+int msic_get_headset_state(int mic_bias)
+{
+	struct sc_reg_access msic_hs_toggle[] = {
+		{0x070, 0x00, 0x01},
+	};
+	if (mic_bias >= 0 && mic_bias < 400) {
+
+		pr_debug("Detected Headphone!!!\n");
+		sst_sc_reg_access(msic_hs_toggle, PMIC_READ_MODIFY, 1);
+
+	} else if (mic_bias > 400 && mic_bias < 650) {
+
+		pr_debug("Detected American headset\n");
+		msic_hs_toggle[0].value = 0x01;
+		sst_sc_reg_access(msic_hs_toggle, PMIC_READ_MODIFY, 1);
+
+	} else if (mic_bias >= 650 && mic_bias < 2000) {
+
+		pr_debug("Detected Headset!!!\n");
+		sst_sc_reg_access(msic_hs_toggle, PMIC_READ_MODIFY, 1);
+		/*power on jack and btn*/
+		snd_msic_ops.jack_interrupt_status = true;
+		msic_enable_jack_btn();
+		msic_enable_mic_bias();
+		return SND_JACK_HEADSET;
+
+	} else
+		pr_debug("Detected Open Cable!!!\n");
+
+	return SND_JACK_HEADPHONE;
+}
+
+static int msic_get_mic_bias(void *arg)
+{
+	struct snd_intelmad *intelmad_drv = (struct snd_intelmad *)arg;
+	u16 adc_adr = intelmad_drv->adc_address;
+	u16 adc_val;
+	int ret;
+	struct sc_reg_access adc_ctrl3[2] = {
+			{0x1C2, 0x05, 0x0},
+	};
+
+	struct sc_reg_access audio_adc_reg1 = {0,};
+	struct sc_reg_access audio_adc_reg2 = {0,};
+
+	msic_enable_mic_bias();
+	/* Enable the msic for conversion before reading */
+	ret = sst_sc_reg_access(adc_ctrl3, PMIC_WRITE, 1);
+	if (ret)
+		return ret;
+	adc_ctrl3[0].value = 0x04;
+	/* Re-toggle the RRDATARD bit */
+	ret = sst_sc_reg_access(adc_ctrl3, PMIC_WRITE, 1);
+	if (ret)
+		return ret;
+
+	audio_adc_reg1.reg_addr = adc_adr;
+	/* Read the higher bits of data */
+	msleep(1000);
+	ret = sst_sc_reg_access(&audio_adc_reg1, PMIC_READ, 1);
+	if (ret)
+		return ret;
+	pr_debug("adc read value %x", audio_adc_reg1.value);
+
+	/* Shift bits to accomodate the lower two data bits */
+	adc_val = (audio_adc_reg1.value << 2);
+	adc_adr++;
+	audio_adc_reg2. reg_addr = adc_adr;
+	ret = sst_sc_reg_access(&audio_adc_reg2, PMIC_READ, 1);
+	if (ret)
+		return ret;
+	pr_debug("adc read value %x", audio_adc_reg2.value);
+
+	/* Adding lower two bits to the higher bits */
+	audio_adc_reg2.value &= 03;
+	adc_val += audio_adc_reg2.value;
+
+	pr_debug("ADC value 0x%x", adc_val);
+	msic_disable_mic_bias();
+	return adc_val;
+}
+
+static void msic_pmic_irq_cb(void *cb_data, u8 intsts)
+{
+	struct mad_jack *mjack = NULL;
+	unsigned int present = 0, jack_event_flag = 0, buttonpressflag = 0;
+	struct snd_intelmad *intelmaddata = cb_data;
+	int retval = 0;
+
+	pr_debug("value returned = 0x%x\n", intsts);
+
+	if (snd_msic_ops.card_status == SND_CARD_UN_INIT) {
+		retval = msic_init_card();
+		if (retval)
+			return;
+	  }
+
+	mjack = &intelmaddata->jack[0];
+	if (intsts & 0x1) {
+		pr_debug("MAD short_push detected\n");
+		present = SND_JACK_BTN_0;
+		jack_event_flag = buttonpressflag = 1;
+		mjack->jack.type = SND_JACK_BTN_0;
+		mjack->jack.key[0] = BTN_0 ;
+	}
+
+	if (intsts & 0x2) {
+		pr_debug(":MAD long_push detected\n");
+		jack_event_flag = buttonpressflag = 1;
+		mjack->jack.type = present = SND_JACK_BTN_1;
+		mjack->jack.key[1] = BTN_1;
+	}
+
+	if (intsts & 0x4) {
+		unsigned int mic_bias;
+		jack_event_flag = 1;
+		buttonpressflag = 0;
+		mic_bias = msic_get_mic_bias(intelmaddata);
+		pr_debug("mic_bias = %d\n", mic_bias);
+		mic_bias = msic_convert_adc_to_mvolt(mic_bias);
+		pr_debug("mic_bias after conversion = %d mV\n", mic_bias);
+		mjack->jack_dev_state = msic_get_headset_state(mic_bias);
+		mjack->jack.type = present = mjack->jack_dev_state;
+	}
+
+	if (intsts & 0x8) {
+		mjack->jack.type = mjack->jack_dev_state;
+		present = 0;
+		jack_event_flag = 1;
+		buttonpressflag = 0;
+		msic_disable_jack_btn();
+		msic_disable_mic_bias();
+	}
+	if (jack_event_flag)
+		sst_mad_send_jack_report(&mjack->jack,
+					buttonpressflag, present);
+}
+
+
+
 struct snd_pmic_ops snd_msic_ops = {
 	.set_input_dev	=	msic_set_selected_input_dev,
 	.set_output_dev =	msic_set_selected_output_dev,
@@ -795,5 +1039,9 @@ struct snd_pmic_ops snd_msic_ops = {
 	.power_up_pmic_cp =	msic_power_up_cp,
 	.power_down_pmic_pb =	msic_power_down_pb,
 	.power_down_pmic_cp =	msic_power_down_cp,
-	.power_down_pmic =	msic_power_down,
+	.power_down_pmic	=	msic_power_down,
+	.pmic_irq_cb	=	msic_pmic_irq_cb,
+	.pmic_jack_enable = msic_enable_mic_bias,
+	.pmic_get_mic_bias	= msic_get_mic_bias,
+	.pmic_set_headset_state = msic_set_headset_state,
 };
diff --git a/drivers/staging/intel_sst/intelmid_pvt.c b/drivers/staging/intel_sst/intelmid_pvt.c
index 3ba9daf..90e0e64 100644
--- a/drivers/staging/intel_sst/intelmid_pvt.c
+++ b/drivers/staging/intel_sst/intelmid_pvt.c
@@ -31,7 +31,6 @@
 #include <sound/core.h>
 #include <sound/control.h>
 #include <sound/pcm.h>
-#include "jack.h"
 #include "intel_sst.h"
 #include "intel_sst_ioctl.h"
 #include "intelmid_snd_control.h"
diff --git a/drivers/staging/intel_sst/intelmid_v0_control.c b/drivers/staging/intel_sst/intelmid_v0_control.c
index 964c412..b8dfdb9 100644
--- a/drivers/staging/intel_sst/intelmid_v0_control.c
+++ b/drivers/staging/intel_sst/intelmid_v0_control.c
@@ -30,9 +30,10 @@
 
 #include <linux/pci.h>
 #include <linux/file.h>
+#include <sound/control.h>
 #include "intel_sst.h"
 #include "intelmid_snd_control.h"
-
+#include "intelmid.h"
 
 enum _reg_v1 {
 	VOICEPORT1 = 0x180,
@@ -64,6 +65,7 @@ enum _reg_v1 {
 };
 
 int rev_id = 0x20;
+static bool jack_det_enabled;
 
 /****
  * fs_init_card - initialize the sound card
@@ -494,10 +496,7 @@ static int fs_set_selected_output_dev(u8 value)
 
 	}
 }
-static int fs_set_selected_lineout_dev(u8 value)
-{
-	return 0;
-}
+
 static int fs_set_mute(int dev_id, u8 value)
 {
 	struct sc_reg_access sc_access[6] = {{0,},};
@@ -756,10 +755,93 @@ static int fs_get_vol(int dev_id, int *value)
 	return retval;
 }
 
+static void fs_pmic_irq_enable(void *data)
+{
+	struct snd_intelmad *intelmaddata = data;
+	struct sc_reg_access sc_access[] = {
+				{0x187, 0x00, MASK7},
+				{0x188, 0x10, MASK4},
+				{0x18b, 0x10, MASK4},
+	};
+
+	struct sc_reg_access sc_access_write[] = {
+				{0x198, 0x00, 0x0},
+	};
+	pr_debug("Audio interrupt enable\n");
+	sst_sc_reg_access(sc_access, PMIC_READ_MODIFY, 3);
+	sst_sc_reg_access(sc_access_write, PMIC_WRITE, 1);
+
+	intelmaddata->jack[0].jack_status = 0;
+	/*intelmaddata->jack[1].jack_status = 0;*/
+
+	jack_det_enabled = true;
+	return;
+}
+
+static void fs_pmic_irq_cb(void *cb_data, u8 value)
+{
+	struct mad_jack *mjack = NULL;
+	struct snd_intelmad *intelmaddata = cb_data;
+	unsigned int present = 0, jack_event_flag = 0, buttonpressflag = 0;
+
+	mjack = &intelmaddata->jack[0];
+
+	if (value & 0x4) {
+		if (!jack_det_enabled)
+			fs_pmic_irq_enable(intelmaddata);
+
+		/* send headphone detect */
+		pr_debug(":MAD headphone %d\n", value & 0x4);
+		present = !(mjack->jack_status);
+		mjack->jack_status = present;
+		jack_event_flag = 1;
+		mjack->jack.type = SND_JACK_HEADPHONE;
+	}
+
+	if (value & 0x2) {
+		/* send short push */
+		pr_debug(":MAD short push %d\n", value & 0x2);
+		present = 1;
+		jack_event_flag = 1;
+		buttonpressflag = 1;
+		mjack->jack.type = MID_JACK_HS_SHORT_PRESS;
+	}
+
+	if (value & 0x1) {
+		/* send long push */
+		pr_debug(":MAD long push %d\n", value & 0x1);
+		present = 1;
+		jack_event_flag = 1;
+		buttonpressflag = 1;
+		mjack->jack.type = MID_JACK_HS_LONG_PRESS;
+	}
+
+	if (value & 0x8) {
+		if (!jack_det_enabled)
+			fs_pmic_irq_enable(intelmaddata);
+		/* send headset detect */
+		pr_debug(":MAD headset = %d\n", value & 0x8);
+		present = !(mjack->jack_status);
+		mjack->jack_status = present;
+		jack_event_flag = 1;
+		mjack->jack.type = SND_JACK_HEADSET;
+	}
+
+
+	if (jack_event_flag)
+		sst_mad_send_jack_report(&mjack->jack,
+						buttonpressflag, present);
+
+	return;
+}
+static int fs_jack_enable(void)
+{
+	return 0;
+}
+
 struct snd_pmic_ops snd_pmic_ops_fs = {
 	.set_input_dev = fs_set_selected_input_dev,
 	.set_output_dev = fs_set_selected_output_dev,
-	.set_lineout_dev = fs_set_selected_lineout_dev,
 	.set_mute = fs_set_mute,
 	.get_mute = fs_get_mute,
 	.set_vol = fs_set_vol,
@@ -769,9 +851,16 @@ struct snd_pmic_ops snd_pmic_ops_fs = {
 	.set_pcm_voice_params = fs_set_pcm_voice_params,
 	.set_voice_port = fs_set_voice_port,
 	.set_audio_port = fs_set_audio_port,
-	.power_up_pmic_pb = fs_power_up_pb,
-	.power_up_pmic_cp = fs_power_up_cp,
-	.power_down_pmic_pb = fs_power_down_pb,
-	.power_down_pmic_cp = fs_power_down_cp,
-	.power_down_pmic = fs_power_down,
+	.power_up_pmic_pb =	fs_power_up_pb,
+	.power_up_pmic_cp =	fs_power_up_cp,
+	.power_down_pmic_pb =	fs_power_down_pb,
+	.power_down_pmic_cp =	fs_power_down_cp,
+	.power_down_pmic	=	fs_power_down,
+	.pmic_irq_cb	=	fs_pmic_irq_cb,
+	/*
+	 * Jack detection enabling
+	 * need be delayed till first IRQ happen.
+	 */
+	.pmic_irq_enable =	NULL,
+	.pmic_jack_enable = fs_jack_enable,
 };
diff --git a/drivers/staging/intel_sst/intelmid_v1_control.c b/drivers/staging/intel_sst/intelmid_v1_control.c
index 4f2b34f..9d00728 100644
--- a/drivers/staging/intel_sst/intelmid_v1_control.c
+++ b/drivers/staging/intel_sst/intelmid_v1_control.c
@@ -32,7 +32,6 @@
 #include <linux/file.h>
 #include <asm/mrst.h>
 #include <sound/pcm.h>
-#include "jack.h"
 #include <sound/pcm_params.h>
 #include <sound/control.h>
 #include <sound/initval.h>
@@ -585,10 +584,6 @@ static int mx_set_selected_input_dev(u8 dev_id)
 	}
 	return sst_sc_reg_access(sc_access, PMIC_WRITE, num_reg);
 }
-static int mx_set_selected_lineout_dev(u8 dev_id)
-{
-	return 0;
-}
 
 static int mx_set_mute(int dev_id, u8 value)
 {
@@ -836,10 +831,132 @@ static int mx_get_vol(int dev_id, int *value)
 	return retval;
 }
 
+static u8 mx_get_jack_status(void)
+{
+	struct sc_reg_access sc_access_read = {0,};
+
+	sc_access_read.reg_addr = 0x201;
+	sst_sc_reg_access(&sc_access_read, PMIC_READ, 1);
+	pr_debug("value returned = 0x%x\n", sc_access_read.value);
+	return sc_access_read.value;
+}
+
+static void mx_pmic_irq_enable(void *data)
+{
+	struct snd_intelmad *intelmaddata = data;
+
+	intelmaddata->jack_prev_state = 0xc0;
+	return;
+}
+
+static void mx_pmic_irq_cb(void *cb_data, u8 intsts)
+{
+	u8 jack_cur_status, jack_prev_state = 0;
+	struct mad_jack *mjack = NULL;
+	unsigned int present = 0, jack_event_flag = 0, buttonpressflag = 0;
+	time_t  timediff;
+	struct snd_intelmad *intelmaddata = cb_data;
+
+	mjack = &intelmaddata->jack[0];
+	if (intsts & 0x2) {
+		jack_cur_status = mx_get_jack_status();
+		jack_prev_state = intelmaddata->jack_prev_state;
+		if ((jack_prev_state == 0xc0) && (jack_cur_status == 0x40)) {
+			/*headset insert detected. */
+			pr_debug("MAD headset inserted\n");
+			present = 1;
+			jack_event_flag = 1;
+			mjack->jack_status = 1;
+			mjack->jack.type = SND_JACK_HEADSET;
+		}
+
+		if ((jack_prev_state == 0xc0) && (jack_cur_status == 0x00)) {
+			/* headphone insert detected. */
+			pr_debug("MAD headphone inserted\n");
+			present = 1;
+			jack_event_flag = 1;
+			mjack->jack.type = SND_JACK_HEADPHONE;
+		}
+
+		if ((jack_prev_state == 0x40) && (jack_cur_status == 0xc0)) {
+			/* headset remove detected. */
+			pr_debug("MAD headset removed\n");
+
+			present = 0;
+			jack_event_flag = 1;
+			mjack->jack_status = 0;
+			mjack->jack.type = SND_JACK_HEADSET;
+		}
+
+		if ((jack_prev_state == 0x00) && (jack_cur_status == 0xc0)) {
+			/* headphone remove detected. */
+			pr_debug("MAD headphone removed\n");
+			present = 0;
+			jack_event_flag = 1;
+			mjack->jack.type = SND_JACK_HEADPHONE;
+		}
+
+		if ((jack_prev_state == 0x40) && (jack_cur_status == 0x00)) {
+			/* button pressed */
+			do_gettimeofday(&mjack->buttonpressed);
+			pr_debug("MAD button press detected\n");
+		}
+
+		if ((jack_prev_state == 0x00) && (jack_cur_status == 0x40)) {
+			if (mjack->jack_status) {
+				/*button pressed */
+				do_gettimeofday(
+					&mjack->buttonreleased);
+				/*button pressed */
+				pr_debug("MAD Button Released detected\n");
+				timediff = mjack->buttonreleased.tv_sec -
+					mjack->buttonpressed.tv_sec;
+				buttonpressflag = 1;
+
+				if (timediff > 1) {
+					pr_debug("MAD long press dtd\n");
+					/* send headphone detect/undetect */
+					present = 1;
+					jack_event_flag = 1;
+					mjack->jack.type =
+							MID_JACK_HS_LONG_PRESS;
+				} else {
+					pr_debug("MAD short press dtd\n");
+					/* send headphone detect/undetect */
+					present = 1;
+					jack_event_flag = 1;
+					mjack->jack.type =
+						MID_JACK_HS_SHORT_PRESS;
+				}
+			} else {
+				/***workaround for maxim
+				hw issue,0x00 t 0x40 is not
+				a valid transiton for Headset insertion */
+				/*headset insert detected. */
+				pr_debug("MAD headset inserted\n");
+				present = 1;
+				jack_event_flag = 1;
+				mjack->jack_status = 1;
+				mjack->jack.type = SND_JACK_HEADSET;
+			}
+		}
+		intelmaddata->jack_prev_state  = jack_cur_status;
+		pr_debug("mx_pmic_irq_cb prv_state= 0x%x\n",
+					intelmaddata->jack_prev_state);
+	}
+
+	if (jack_event_flag)
+		sst_mad_send_jack_report(&mjack->jack,
+						buttonpressflag, present);
+}
+static int mx_jack_enable(void)
+{
+	return 0;
+}
+
 struct snd_pmic_ops snd_pmic_ops_mx = {
 	.set_input_dev = mx_set_selected_input_dev,
 	.set_output_dev = mx_set_selected_output_dev,
-	.set_lineout_dev = mx_set_selected_lineout_dev,
 	.set_mute = mx_set_mute,
 	.get_mute = mx_get_mute,
 	.set_vol = mx_set_vol,
@@ -849,10 +966,13 @@ struct snd_pmic_ops snd_pmic_ops_mx = {
 	.set_pcm_voice_params = mx_set_pcm_voice_params,
 	.set_voice_port = mx_set_voice_port,
 	.set_audio_port = mx_set_audio_port,
-	.power_up_pmic_pb = mx_power_up_pb,
-	.power_up_pmic_cp = mx_power_up_cp,
-	.power_down_pmic_pb = mx_power_down_pb,
-	.power_down_pmic_cp = mx_power_down_cp,
-	.power_down_pmic =  mx_power_down,
+	.power_up_pmic_pb =	mx_power_up_pb,
+	.power_up_pmic_cp =	mx_power_up_cp,
+	.power_down_pmic_pb =	mx_power_down_pb,
+	.power_down_pmic_cp =	mx_power_down_cp,
+	.power_down_pmic =	mx_power_down,
+	.pmic_irq_cb	 =	mx_pmic_irq_cb,
+	.pmic_irq_enable =	mx_pmic_irq_enable,
+	.pmic_jack_enable =	mx_jack_enable,
 };
 
diff --git a/drivers/staging/intel_sst/intelmid_v2_control.c b/drivers/staging/intel_sst/intelmid_v2_control.c
index a0cd227..10762d7 100644
--- a/drivers/staging/intel_sst/intelmid_v2_control.c
+++ b/drivers/staging/intel_sst/intelmid_v2_control.c
@@ -31,8 +31,10 @@
 #include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/file.h>
+#include <sound/control.h>
 #include "intel_sst.h"
 #include "intelmid_snd_control.h"
+#include "intelmid.h"
 
 enum reg_v3 {
 	VAUDIOCNT = 0x51,
@@ -885,10 +887,7 @@ static int nc_set_selected_input_dev(u8 value)
 	}
 	return sst_sc_reg_access(sc_access, PMIC_READ_MODIFY, num_val);
 }
-static int nc_set_selected_lineout_dev(u8 dev_id)
-{
-	return 0;
-}
+
 static int nc_get_mute(int dev_id, u8 *value)
 {
 	int retval = 0, mask = 0;
@@ -990,10 +989,66 @@ static int nc_get_vol(int dev_id, int *value)
 	return retval;
 }
 
+static void nc_pmic_irq_cb(void *cb_data, u8 intsts)
+{
+	u8 value = 0;
+	struct mad_jack *mjack = NULL;
+	unsigned int present = 0, jack_event_flag = 0, buttonpressflag = 0;
+	struct snd_intelmad *intelmaddata = cb_data;
+	struct sc_reg_access sc_access_read = {0,};
+
+	sc_access_read.reg_addr = 0x132;
+	sst_sc_reg_access(&sc_access_read, PMIC_READ, 1);
+	value = (sc_access_read.value);
+	pr_debug("value returned = 0x%x\n", value);
+
+	mjack = &intelmaddata->jack[0];
+	if (intsts & 0x1) {
+		pr_debug("SST DBG:MAD headset detected\n");
+		/* send headset detect/undetect */
+		present = (value == 0x1) ? 1 : 0;
+		jack_event_flag = 1;
+		mjack->jack.type = SND_JACK_HEADSET;
+	}
+
+	if (intsts & 0x2) {
+		pr_debug(":MAD headphone detected\n");
+		/* send headphone detect/undetect */
+		present = (value == 0x2) ? 1 : 0;
+		jack_event_flag = 1;
+		mjack->jack.type = SND_JACK_HEADPHONE;
+	}
+
+	if (intsts & 0x4) {
+		pr_debug("MAD short push detected\n");
+		/* send short push */
+		present = 1;
+		jack_event_flag = 1;
+		buttonpressflag = 1;
+		mjack->jack.type = MID_JACK_HS_SHORT_PRESS;
+	}
+
+	if (intsts & 0x8) {
+		pr_debug(":MAD long push detected\n");
+		/* send long push */
+		present = 1;
+		jack_event_flag = 1;
+		buttonpressflag = 1;
+		mjack->jack.type = MID_JACK_HS_SHORT_PRESS;
+	}
+
+	if (jack_event_flag)
+		sst_mad_send_jack_report(&mjack->jack,
+					buttonpressflag, present);
+}
+static int nc_jack_enable(void)
+{
+	return 0;
+}
+
 struct snd_pmic_ops snd_pmic_ops_nc = {
 	.set_input_dev	=	nc_set_selected_input_dev,
 	.set_output_dev =	nc_set_selected_output_dev,
-	.set_lineout_dev =	nc_set_selected_lineout_dev,
 	.set_mute	=	nc_set_mute,
 	.get_mute	=	nc_get_mute,
 	.set_vol	=	nc_set_vol,
@@ -1007,5 +1062,7 @@ struct snd_pmic_ops snd_pmic_ops_nc = {
 	.power_up_pmic_cp =	nc_power_up_cp,
 	.power_down_pmic_pb =	nc_power_down_pb,
 	.power_down_pmic_cp =	nc_power_down_cp,
-	.power_down_pmic =	nc_power_down,
+	.power_down_pmic	=	nc_power_down,
+	.pmic_irq_cb	=	nc_pmic_irq_cb,
+	.pmic_jack_enable =	nc_jack_enable,
 };
diff --git a/drivers/staging/intel_sst/jack.h b/drivers/staging/intel_sst/jack.h
deleted file mode 100644
index 9a6e483..0000000
--- a/drivers/staging/intel_sst/jack.h
+++ /dev/null
@@ -1,10 +0,0 @@
-/* Temporary staging glue */
-
-#include <sound/jack.h>
-
-/* These want adding to jack.h as enum entries once approved */
-
-#define SND_JACK_HS_SHORT_PRESS 	(SND_JACK_HEADSET | 0x0020)
-#define	SND_JACK_HS_LONG_PRESS		(SND_JACK_HEADSET | 0x0040)
-
-

