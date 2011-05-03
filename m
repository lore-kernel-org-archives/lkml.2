Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab1ECQxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 12:53:23 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45625 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054Ab1ECQxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 12:53:09 -0400
X-Greylist: delayed 357 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 May 2011 12:52:53 EDT
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 05/23] intel_sst: Line out support
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 03 May 2011 17:32:38 +0100
Message-ID: <20110503163236.24853.21582.stgit@bob.linux.org.uk>
In-Reply-To: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
References: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dharageswari R <dharageswari.r@intel.com>

This patch adds the support for lineout. The
lineout input can be selected as any input channel
by using a new alsa mixer kcontrol.

Signed-off-by: Dharageswari R <dharageswari.r@intel.com>
Signed-off-by: Ramesh Babu K V <ramesh.babu@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/intel_sst/intel_sst.h              |    6 
 drivers/staging/intel_sst/intel_sst_common.h       |    4 
 .../staging/intel_sst/intel_sst_drv_interface.c    |    7 -
 drivers/staging/intel_sst/intel_sst_stream.c       |    2 
 drivers/staging/intel_sst/intelmid.c               |    3 
 drivers/staging/intel_sst/intelmid.h               |    8 -
 drivers/staging/intel_sst/intelmid_ctrl.c          |   46 +++-
 drivers/staging/intel_sst/intelmid_msic_control.c  |  254 +++++++++++++++++++-
 drivers/staging/intel_sst/intelmid_snd_control.h   |    7 +
 drivers/staging/intel_sst/intelmid_v0_control.c    |    6 
 drivers/staging/intel_sst/intelmid_v1_control.c    |    5 
 drivers/staging/intel_sst/intelmid_v2_control.c    |    6 
 12 files changed, 330 insertions(+), 24 deletions(-)


diff --git a/drivers/staging/intel_sst/intel_sst.h b/drivers/staging/intel_sst/intel_sst.h
index bf0f9e2..ea6cd97 100644
--- a/drivers/staging/intel_sst/intel_sst.h
+++ b/drivers/staging/intel_sst/intel_sst.h
@@ -82,12 +82,14 @@ struct snd_pmic_ops {
 	int num_channel;
 	int input_dev_id;
 	int mute_status;
-	int pb_on;
+	int pb_on, pbhs_on;
 	int cap_on;
 	int output_dev_id;
+	int lineout_dev_id, line_out_names_cnt;
+	int prev_lineout_dev_id;
 	int (*set_input_dev) (u8 value);
 	int (*set_output_dev) (u8 value);
-
+	int (*set_lineout_dev) (u8 value);
 	int (*set_mute) (int dev_id, u8 value);
 	int (*get_mute) (int dev_id, u8 *value);
 
diff --git a/drivers/staging/intel_sst/intel_sst_common.h b/drivers/staging/intel_sst/intel_sst_common.h
index 0f48838..9aff1a3 100644
--- a/drivers/staging/intel_sst/intel_sst_common.h
+++ b/drivers/staging/intel_sst/intel_sst_common.h
@@ -28,8 +28,8 @@
  *  Common private declarations for SST
  */
 
-#define SST_DRIVER_VERSION "1.2.11"
-#define SST_VERSION_NUM 0x1211
+#define SST_DRIVER_VERSION "1.2.14"
+#define SST_VERSION_NUM 0x1214
 
 /* driver names */
 #define SST_DRV_NAME "intel_sst_driver"
diff --git a/drivers/staging/intel_sst/intel_sst_drv_interface.c b/drivers/staging/intel_sst/intel_sst_drv_interface.c
index a47e382..1e8c056 100644
--- a/drivers/staging/intel_sst/intel_sst_drv_interface.c
+++ b/drivers/staging/intel_sst/intel_sst_drv_interface.c
@@ -110,9 +110,14 @@ void free_stream_context(unsigned int str_id)
 		if (stream->ops == STREAM_OPS_PLAYBACK ||
 				stream->ops == STREAM_OPS_PLAYBACK_DRM) {
 			sst_drv_ctx->pb_streams--;
-			if (sst_drv_ctx->pb_streams == 0)
+			if (sst_drv_ctx->pci_id == SST_MFLD_PCI_ID)
 				sst_drv_ctx->scard_ops->power_down_pmic_pb(
 						stream->device);
+			else {
+				if (sst_drv_ctx->pb_streams == 0)
+					sst_drv_ctx->scard_ops->
+					power_down_pmic_pb(stream->device);
+			}
 		} else if (stream->ops == STREAM_OPS_CAPTURE) {
 			sst_drv_ctx->cp_streams--;
 			if (sst_drv_ctx->cp_streams == 0)
diff --git a/drivers/staging/intel_sst/intel_sst_stream.c b/drivers/staging/intel_sst/intel_sst_stream.c
index 55a561c..dd9c530 100644
--- a/drivers/staging/intel_sst/intel_sst_stream.c
+++ b/drivers/staging/intel_sst/intel_sst_stream.c
@@ -73,6 +73,8 @@ int sst_check_device_type(u32 device, u32 num_chan, u32 *pcm_slot)
 			*pcm_slot = 0x07;
 		else if (device == SND_SST_DEVICE_CAPTURE && num_chan == 4)
 			*pcm_slot = 0x0F;
+		else if (device == SND_SST_DEVICE_CAPTURE && num_chan > 4)
+			*pcm_slot = 0x1F;
 		else {
 			pr_debug("No condition satisfied.. ret err\n");
 			return -EINVAL;
diff --git a/drivers/staging/intel_sst/intelmid.c b/drivers/staging/intel_sst/intelmid.c
index 0925a88..ee070e3 100644
--- a/drivers/staging/intel_sst/intelmid.c
+++ b/drivers/staging/intel_sst/intelmid.c
@@ -187,7 +187,7 @@ static int snd_intelmad_pcm_prepare(struct snd_pcm_substream *substream)
 		return ret_val;
 	}
 
-	 ret_val = snd_intelmad_alloc_stream(substream);
+	ret_val = snd_intelmad_alloc_stream(substream);
 	if (ret_val < 0)
 		return ret_val;
 	stream->dbg_cum_bytes = 0;
@@ -797,6 +797,7 @@ static int __devinit snd_intelmad_sst_register(
 		intelmaddata->sstdrv_ops->scard_ops->input_dev_id = DMIC;
 		intelmaddata->sstdrv_ops->scard_ops->output_dev_id =
 							STEREO_HEADPHONE;
+		intelmaddata->sstdrv_ops->scard_ops->lineout_dev_id = NONE;
 	}
 
 	/* registering with SST driver to get access to SST APIs to use */
diff --git a/drivers/staging/intel_sst/intelmid.h b/drivers/staging/intel_sst/intelmid.h
index e77da87..4ed4a94 100644
--- a/drivers/staging/intel_sst/intelmid.h
+++ b/drivers/staging/intel_sst/intelmid.h
@@ -53,11 +53,11 @@
 #define STEREO_CNTL		2
 #define MIN_CHANNEL		1
 #define MAX_CHANNEL_AMIC	2
-#define MAX_CHANNEL_DMIC	4
+#define MAX_CHANNEL_DMIC	5
 #define FIFO_SIZE		0 /* fifo not being used */
 #define INTEL_MAD		"Intel MAD"
 #define MAX_CTRL_MRST		7
-#define MAX_CTRL_MFLD		2
+#define MAX_CTRL_MFLD		3
 #define MAX_CTRL		7
 #define MAX_VENDORS		4
 /* TODO +6 db */
@@ -116,6 +116,7 @@ struct snd_intelmad {
 	void __iomem *int_base;
 	int output_sel;
 	int input_sel;
+	int lineout_sel;
 	int master_mute;
 	struct mad_jack jack[4];
 	int playback_cnt;
@@ -163,6 +164,9 @@ enum _widget_ctrl {
 	CAPTURE_MUTE,
 	MASTER_MUTE
 };
+enum _widget_ctrl_mfld {
+	LINEOUT_SEL_MFLD = 3,
+};
 
 void period_elapsed(void *mad_substream);
 int snd_intelmad_alloc_stream(struct snd_pcm_substream *substream);
diff --git a/drivers/staging/intel_sst/intelmid_ctrl.c b/drivers/staging/intel_sst/intelmid_ctrl.c
index 69af070..3036928 100644
--- a/drivers/staging/intel_sst/intelmid_ctrl.c
+++ b/drivers/staging/intel_sst/intelmid_ctrl.c
@@ -40,6 +40,11 @@ static char *out_names_mrst[] = {"Headphones",
 static char *in_names_mrst[] = {"AMIC",
 				"DMIC",
 				"HS_MIC"};
+static char *line_out_names_mfld[] = {"Headset",
+				"IHF    ",
+				"Vibra1 ",
+				"Vibra2 ",
+				"NONE   "};
 static char *out_names_mfld[] = {"Headset ",
 				"EarPiece  "};
 static char *in_names_mfld[] = {"AMIC",
@@ -179,13 +184,27 @@ static int snd_intelmad_device_info_mrst(struct snd_kcontrol *kcontrol,
 static int snd_intelmad_device_info_mfld(struct snd_kcontrol *kcontrol,
 					struct snd_ctl_elem_info *uinfo)
 {
+	struct snd_pmic_ops *scard_ops;
+	struct snd_intelmad *intelmaddata;
+
 	WARN_ON(!kcontrol);
 	WARN_ON(!uinfo);
+
+	intelmaddata = kcontrol->private_data;
+
+	WARN_ON(!intelmaddata->sstdrv_ops);
+
+	scard_ops = intelmaddata->sstdrv_ops->scard_ops;
 	/* setup device select as drop down controls with different values */
 	if (kcontrol->id.numid == OUTPUT_SEL)
 		uinfo->value.enumerated.items = ARRAY_SIZE(out_names_mfld);
-	else
+	else if (kcontrol->id.numid == INPUT_SEL)
 		uinfo->value.enumerated.items = ARRAY_SIZE(in_names_mfld);
+	else if (kcontrol->id.numid == LINEOUT_SEL_MFLD) {
+		uinfo->value.enumerated.items = ARRAY_SIZE(line_out_names_mfld);
+		scard_ops->line_out_names_cnt = uinfo->value.enumerated.items;
+	} else
+		return -EINVAL;
 	uinfo->count = MONO_CNTL;
 	uinfo->type = SNDRV_CTL_ELEM_TYPE_ENUMERATED;
 
@@ -195,10 +214,16 @@ static int snd_intelmad_device_info_mfld(struct snd_kcontrol *kcontrol,
 		strncpy(uinfo->value.enumerated.name,
 			out_names_mfld[uinfo->value.enumerated.item],
 			sizeof(uinfo->value.enumerated.name)-1);
-	else
+	else if (kcontrol->id.numid == INPUT_SEL)
 		strncpy(uinfo->value.enumerated.name,
 			in_names_mfld[uinfo->value.enumerated.item],
 			sizeof(uinfo->value.enumerated.name)-1);
+	else if (kcontrol->id.numid == LINEOUT_SEL_MFLD)
+		strncpy(uinfo->value.enumerated.name,
+			line_out_names_mfld[uinfo->value.enumerated.item],
+			sizeof(uinfo->value.enumerated.name)-1);
+	else
+		return -EINVAL;
 	return 0;
 }
 
@@ -472,6 +497,9 @@ static int snd_intelmad_device_get(struct snd_kcontrol *kcontrol,
 		else if (kcontrol->id.numid == INPUT_SEL)
 			uval->value.enumerated.item[0] =
 					scard_ops->input_dev_id;
+		else if (kcontrol->id.numid == LINEOUT_SEL_MFLD)
+			uval->value.enumerated.item[0] =
+					scard_ops->lineout_dev_id;
 		else
 			return -EINVAL;
 	} else
@@ -534,6 +562,11 @@ static int snd_intelmad_device_set(struct snd_kcontrol *kcontrol,
 				uval->value.enumerated.item[0]);
 		intelmaddata->input_sel = uval->value.enumerated.item[0];
 		break;
+	case LINEOUT_SEL_MFLD:
+		ret_val = scard_ops->set_lineout_dev(
+					uval->value.enumerated.item[0]);
+		intelmaddata->lineout_sel = uval->value.enumerated.item[0];
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -627,5 +660,14 @@ snd_intelmad_controls_mfld[MAX_CTRL_MFLD] __devinitdata = {
 	.put		=	snd_intelmad_device_set,
 	.private_value	=	0,
 },
+{
+	.iface		=	SNDRV_CTL_ELEM_IFACE_MIXER,
+	.name		=	"Line out",
+	.access		=	SNDRV_CTL_ELEM_ACCESS_READWRITE,
+	.info		=	snd_intelmad_device_info_mfld,
+	.get		=	snd_intelmad_device_get,
+	.put		=	snd_intelmad_device_set,
+	.private_value	=	0,
+},
 };
 
diff --git a/drivers/staging/intel_sst/intelmid_msic_control.c b/drivers/staging/intel_sst/intelmid_msic_control.c
index bbe9ab2..10073c5 100644
--- a/drivers/staging/intel_sst/intelmid_msic_control.c
+++ b/drivers/staging/intel_sst/intelmid_msic_control.c
@@ -54,11 +54,8 @@ static int msic_init_card(void)
 		/*TI vibra w/a settings*/
 		{0x384, 0x80, 0},
 		{0x385, 0x80, 0},
-		/*vibra settings*/
 		{0x267, 0x00, 0},
-		{0x26A, 0x10, 0},
 		{0x261, 0x00, 0},
-		{0x264, 0x10, 0},
 		/* pcm port setting */
 		{0x278, 0x00, 0},
 		{0x27B, 0x01, 0},
@@ -80,14 +77,221 @@ static int msic_init_card(void)
 		{0x1e, 0x00, 0x00},
 	};
 	snd_msic_ops.card_status = SND_CARD_INIT_DONE;
-	sst_sc_reg_access(sc_access, PMIC_WRITE, 30);
+	sst_sc_reg_access(sc_access, PMIC_WRITE, 28);
 	snd_msic_ops.pb_on = 0;
+	snd_msic_ops.pbhs_on = 0;
 	snd_msic_ops.cap_on = 0;
 	snd_msic_ops.input_dev_id = DMIC; /*def dev*/
 	snd_msic_ops.output_dev_id = STEREO_HEADPHONE;
 	pr_debug("msic init complete!!\n");
 	return 0;
 }
+static int msic_line_out_restore(u8 value)
+{
+	struct sc_reg_access hs_drv_en[] = {
+		{0x25d, 0x03, 0x03},
+	};
+	struct sc_reg_access ep_drv_en[] = {
+		{0x25d, 0x40, 0x40},
+	};
+	struct sc_reg_access ihf_drv_en[] = {
+		{0x25d, 0x0c, 0x0c},
+	};
+	struct sc_reg_access vib1_drv_en[] = {
+		{0x25d, 0x10, 0x10},
+	};
+	struct sc_reg_access vib2_drv_en[] = {
+		{0x25d, 0x20, 0x20},
+	};
+	int retval = 0;
+
+	pr_debug("msic_lineout_restore_lineout_dev:%d\n", value);
+
+	switch (value) {
+	case HEADSET:
+		pr_debug("Selecting Lineout-HEADSET-restore\n");
+		if (snd_msic_ops.output_dev_id == STEREO_HEADPHONE)
+			retval = sst_sc_reg_access(hs_drv_en,
+							PMIC_READ_MODIFY, 1);
+		else
+			retval = sst_sc_reg_access(ep_drv_en,
+							PMIC_READ_MODIFY, 1);
+		break;
+	case IHF:
+		pr_debug("Selecting Lineout-IHF-restore\n");
+		retval = sst_sc_reg_access(ihf_drv_en, PMIC_READ_MODIFY, 1);
+		break;
+	case VIBRA1:
+		pr_debug("Selecting Lineout-Vibra1-restore\n");
+		retval = sst_sc_reg_access(vib1_drv_en, PMIC_READ_MODIFY, 1);
+		break;
+	case VIBRA2:
+		pr_debug("Selecting Lineout-VIBRA2-restore\n");
+		retval = sst_sc_reg_access(vib2_drv_en, PMIC_READ_MODIFY, 1);
+		break;
+	case NONE:
+		pr_debug("Selecting Lineout-NONE-restore\n");
+		break;
+	default:
+		return -EINVAL;
+	}
+	return retval;
+}
+static int msic_get_lineout_prvstate(void)
+{
+	struct sc_reg_access hs_ihf_drv[2] = {
+		{0x257, 0x0, 0x0},
+		{0x25d, 0x0, 0x0},
+	};
+	struct sc_reg_access vib1drv[2] = {
+		{0x264, 0x0, 0x0},
+		{0x25D, 0x0, 0x0},
+	};
+	struct sc_reg_access vib2drv[2] = {
+		{0x26A, 0x0, 0x0},
+		{0x25D, 0x0, 0x0},
+	};
+	int retval = 0, drv_en, dac_en, dev_id, mask;
+	for (dev_id = 0; dev_id < snd_msic_ops.line_out_names_cnt; dev_id++) {
+		switch (dev_id) {
+		case HEADSET:
+			pr_debug("msic_get_lineout_prvs_state: HEADSET\n");
+			sst_sc_reg_access(hs_ihf_drv, PMIC_READ, 2);
+
+			mask = (MASK0|MASK1);
+			dac_en = (hs_ihf_drv[0].value) & mask;
+
+			mask = ((MASK0|MASK1)|MASK6);
+			drv_en = (hs_ihf_drv[1].value) & mask;
+
+			if (dac_en && (!drv_en)) {
+				snd_msic_ops.prev_lineout_dev_id = HEADSET;
+				return retval;
+			}
+			break;
+		case IHF:
+			pr_debug("msic_get_lineout_prvstate: IHF\n");
+			sst_sc_reg_access(hs_ihf_drv, PMIC_READ, 2);
+
+			mask = (MASK2 | MASK3);
+			dac_en = (hs_ihf_drv[0].value) & mask;
+
+			mask = (MASK2 | MASK3);
+			drv_en = (hs_ihf_drv[1].value) & mask;
+
+			if (dac_en && (!drv_en)) {
+				snd_msic_ops.prev_lineout_dev_id = IHF;
+				return retval;
+			}
+			break;
+		case VIBRA1:
+			pr_debug("msic_get_lineout_prvstate: vibra1\n");
+			sst_sc_reg_access(vib1drv, PMIC_READ, 2);
+
+			mask = MASK1;
+			dac_en = (vib1drv[0].value) & mask;
+
+			mask = MASK4;
+			drv_en = (vib1drv[1].value) & mask;
+
+			if (dac_en && (!drv_en)) {
+				snd_msic_ops.prev_lineout_dev_id = VIBRA1;
+				return retval;
+			}
+			break;
+		case VIBRA2:
+			pr_debug("msic_get_lineout_prvstate: vibra2\n");
+			sst_sc_reg_access(vib2drv, PMIC_READ, 2);
+
+			mask = MASK1;
+			dac_en = (vib2drv[0].value) & mask;
+
+			mask = MASK5;
+			drv_en = ((vib2drv[1].value) & mask);
+
+			if (dac_en && (!drv_en)) {
+				snd_msic_ops.prev_lineout_dev_id = VIBRA2;
+				return retval;
+			}
+			break;
+		case NONE:
+			pr_debug("msic_get_lineout_prvstate: NONE\n");
+			snd_msic_ops.prev_lineout_dev_id = NONE;
+			return retval;
+		default:
+			pr_debug("Invalid device id\n");
+			snd_msic_ops.prev_lineout_dev_id = NONE;
+			return -EINVAL;
+		}
+	}
+	return retval;
+}
+static int msic_set_selected_lineout_dev(u8 value)
+{
+	struct sc_reg_access lout_hs[] = {
+		{0x25e, 0x33, 0xFF},
+		{0x25d, 0x0, 0x43},
+	};
+	struct sc_reg_access lout_ihf[] = {
+		{0x25e, 0x55, 0xff},
+		{0x25d, 0x0, 0x0c},
+	};
+	struct sc_reg_access lout_vibra1[] = {
+
+		{0x25e, 0x61, 0xff},
+		{0x25d, 0x0, 0x10},
+	};
+	struct sc_reg_access lout_vibra2[] = {
+
+		{0x25e, 0x16, 0xff},
+		{0x25d, 0x0, 0x20},
+	};
+	struct sc_reg_access lout_def[] = {
+		{0x25e, 0x66, 0x0},
+	};
+	int retval = 0;
+
+	pr_debug("msic_set_selected_lineout_dev:%d\n", value);
+	msic_get_lineout_prvstate();
+	msic_line_out_restore(snd_msic_ops.prev_lineout_dev_id);
+	snd_msic_ops.lineout_dev_id = value;
+
+	switch (value) {
+	case HEADSET:
+		pr_debug("Selecting Lineout-HEADSET\n");
+		if (snd_msic_ops.pb_on)
+			retval = sst_sc_reg_access(lout_hs,
+					PMIC_READ_MODIFY, 2);
+		break;
+	case IHF:
+		pr_debug("Selecting Lineout-IHF\n");
+		if (snd_msic_ops.pb_on)
+			retval = sst_sc_reg_access(lout_ihf,
+							PMIC_READ_MODIFY, 2);
+		break;
+	case VIBRA1:
+		pr_debug("Selecting Lineout-Vibra1\n");
+		if (snd_msic_ops.pb_on)
+			retval = sst_sc_reg_access(lout_vibra1,
+							PMIC_READ_MODIFY, 2);
+		break;
+	case VIBRA2:
+		pr_debug("Selecting Lineout-VIBRA2\n");
+		if (snd_msic_ops.pb_on)
+			retval = sst_sc_reg_access(lout_vibra2,
+							PMIC_READ_MODIFY, 2);
+		break;
+	case NONE:
+		pr_debug("Selecting Lineout-NONE\n");
+			retval = sst_sc_reg_access(lout_def,
+							PMIC_WRITE, 1);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return retval;
+}
+
 
 static int msic_power_up_pb(unsigned int device)
 {
@@ -161,12 +365,12 @@ static int msic_power_up_pb(unsigned int device)
 	struct sc_reg_access vib1_en[] = {
 		/* enable driver, ADC */
 		{0x25D, 0x10, 0x10},
-		{0x264, 0x02, 0x02},
+		{0x264, 0x02, 0x82},
 	};
 	struct sc_reg_access vib2_en[] = {
 		/* enable driver, ADC */
 		{0x25D, 0x20, 0x20},
-		{0x26A, 0x02, 0x02},
+		{0x26A, 0x02, 0x82},
 	};
 	struct sc_reg_access pcm2_en[] = {
 		/* enable pcm 2 */
@@ -187,6 +391,8 @@ static int msic_power_up_pb(unsigned int device)
 	msleep(1);
 	switch (device) {
 	case SND_SST_DEVICE_HEADSET:
+		snd_msic_ops.pb_on = 1;
+		snd_msic_ops.pbhs_on = 1;
 		if (snd_msic_ops.output_dev_id == STEREO_HEADPHONE) {
 			sst_sc_reg_access(vhs, PMIC_WRITE, 2);
 			sst_sc_reg_access(hsdac, PMIC_READ_MODIFY, 2);
@@ -197,22 +403,31 @@ static int msic_power_up_pb(unsigned int device)
 			sst_sc_reg_access(hs_filter, PMIC_WRITE, 2);
 			sst_sc_reg_access(ep_enable, PMIC_READ_MODIFY, 3);
 		}
-		snd_msic_ops.pb_on = 1;
+		if (snd_msic_ops.lineout_dev_id == HEADSET)
+			msic_set_selected_lineout_dev(HEADSET);
 		break;
-
 	case SND_SST_DEVICE_IHF:
+		snd_msic_ops.pb_on = 1;
 		sst_sc_reg_access(vihf, PMIC_WRITE, 1);
 		sst_sc_reg_access(ihf_filter, PMIC_READ_MODIFY, 3);
 		sst_sc_reg_access(ihf_en, PMIC_READ_MODIFY, 1);
 		sst_sc_reg_access(ihf_unmute, PMIC_READ_MODIFY, 2);
+		if (snd_msic_ops.lineout_dev_id == IHF)
+			msic_set_selected_lineout_dev(IHF);
 		break;
 
 	case SND_SST_DEVICE_VIBRA:
+		snd_msic_ops.pb_on = 1;
 		sst_sc_reg_access(vib1_en, PMIC_READ_MODIFY, 2);
+		if (snd_msic_ops.lineout_dev_id == VIBRA1)
+			msic_set_selected_lineout_dev(VIBRA1);
 		break;
 
 	case SND_SST_DEVICE_HAPTIC:
+		snd_msic_ops.pb_on = 1;
 		sst_sc_reg_access(vib2_en, PMIC_READ_MODIFY, 2);
+		if (snd_msic_ops.lineout_dev_id == VIBRA2)
+			msic_set_selected_lineout_dev(VIBRA2);
 		break;
 
 	default:
@@ -310,6 +525,7 @@ static int msic_power_down(void)
 	};
 
 	pr_debug("powering dn msic\n");
+	snd_msic_ops.pbhs_on = 0;
 	snd_msic_ops.pb_on = 0;
 	snd_msic_ops.cap_on = 0;
 	sst_sc_reg_access(power_dn, PMIC_WRITE, 3);
@@ -348,15 +564,22 @@ static int msic_power_down_pb(unsigned int device)
 	struct sc_reg_access vib2_off[] = {
 		{0x26A, 0x00, 0x82},
 	};
+	struct sc_reg_access lout_off[] = {
+		{0x25e, 0x66, 0x00},
+	};
+
+
 
 	pr_debug("powering dn pb for device %d\n", device);
 	switch (device) {
 	case SND_SST_DEVICE_HEADSET:
-		snd_msic_ops.pb_on = 0;
+		snd_msic_ops.pbhs_on = 0;
 		sst_sc_reg_access(hs_mute, PMIC_READ_MODIFY, 3);
 		drv_enable[0].mask = 0x43;
 		sst_sc_reg_access(drv_enable, PMIC_READ_MODIFY, 1);
 		sst_sc_reg_access(hs_off, PMIC_READ_MODIFY, 2);
+		if (snd_msic_ops.lineout_dev_id == HEADSET)
+			sst_sc_reg_access(lout_off, PMIC_WRITE, 1);
 		break;
 
 	case SND_SST_DEVICE_IHF:
@@ -364,18 +587,24 @@ static int msic_power_down_pb(unsigned int device)
 		drv_enable[0].mask = 0x0C;
 		sst_sc_reg_access(drv_enable, PMIC_READ_MODIFY, 1);
 		sst_sc_reg_access(ihf_off, PMIC_READ_MODIFY, 2);
+		if (snd_msic_ops.lineout_dev_id == IHF)
+			sst_sc_reg_access(lout_off, PMIC_WRITE, 1);
 		break;
 
 	case SND_SST_DEVICE_VIBRA:
-		sst_sc_reg_access(vib1_off, PMIC_READ_MODIFY, 2);
+		sst_sc_reg_access(vib1_off, PMIC_READ_MODIFY, 1);
 		drv_enable[0].mask = 0x10;
 		sst_sc_reg_access(drv_enable, PMIC_READ_MODIFY, 1);
+		if (snd_msic_ops.lineout_dev_id == VIBRA1)
+			sst_sc_reg_access(lout_off, PMIC_WRITE, 1);
 		break;
 
 	case SND_SST_DEVICE_HAPTIC:
-		sst_sc_reg_access(vib2_off, PMIC_READ_MODIFY, 2);
+		sst_sc_reg_access(vib2_off, PMIC_READ_MODIFY, 1);
 		drv_enable[0].mask = 0x20;
 		sst_sc_reg_access(drv_enable, PMIC_READ_MODIFY, 1);
+		if (snd_msic_ops.lineout_dev_id == VIBRA2)
+			sst_sc_reg_access(lout_off, PMIC_WRITE, 1);
 		break;
 	}
 	return 0;
@@ -414,7 +643,7 @@ static int msic_set_selected_output_dev(u8 value)
 
 	pr_debug("msic set selected output:%d\n", value);
 	snd_msic_ops.output_dev_id = value;
-	if (snd_msic_ops.pb_on)
+	if (snd_msic_ops.pbhs_on)
 		msic_power_up_pb(SND_SST_DEVICE_HEADSET);
 	return retval;
 }
@@ -494,6 +723,7 @@ static int msic_get_vol(int dev_id, int *value)
 struct snd_pmic_ops snd_msic_ops = {
 	.set_input_dev	=	msic_set_selected_input_dev,
 	.set_output_dev =	msic_set_selected_output_dev,
+	.set_lineout_dev =	msic_set_selected_lineout_dev,
 	.set_mute	=	msic_set_mute,
 	.get_mute	=	msic_get_mute,
 	.set_vol	=	msic_set_vol,
diff --git a/drivers/staging/intel_sst/intelmid_snd_control.h b/drivers/staging/intel_sst/intelmid_snd_control.h
index a4565f3..c7e9f16 100644
--- a/drivers/staging/intel_sst/intelmid_snd_control.h
+++ b/drivers/staging/intel_sst/intelmid_snd_control.h
@@ -80,6 +80,13 @@ enum SND_INPUT_DEVICE {
 	HS_MIC,
 	IN_UNDEFINED
 };
+enum SND_LINE_OUT_DEVICE {
+	HEADSET,
+	IHF,
+	VIBRA1,
+	VIBRA2,
+	NONE,
+};
 
 enum SND_OUTPUT_DEVICE {
 	STEREO_HEADPHONE,
diff --git a/drivers/staging/intel_sst/intelmid_v0_control.c b/drivers/staging/intel_sst/intelmid_v0_control.c
index 6cf5901..964c412 100644
--- a/drivers/staging/intel_sst/intelmid_v0_control.c
+++ b/drivers/staging/intel_sst/intelmid_v0_control.c
@@ -494,7 +494,10 @@ static int fs_set_selected_output_dev(u8 value)
 
 	}
 }
-
+static int fs_set_selected_lineout_dev(u8 value)
+{
+	return 0;
+}
 static int fs_set_mute(int dev_id, u8 value)
 {
 	struct sc_reg_access sc_access[6] = {{0,},};
@@ -756,6 +759,7 @@ static int fs_get_vol(int dev_id, int *value)
 struct snd_pmic_ops snd_pmic_ops_fs = {
 	.set_input_dev = fs_set_selected_input_dev,
 	.set_output_dev = fs_set_selected_output_dev,
+	.set_lineout_dev = fs_set_selected_lineout_dev,
 	.set_mute = fs_set_mute,
 	.get_mute = fs_get_mute,
 	.set_vol = fs_set_vol,
diff --git a/drivers/staging/intel_sst/intelmid_v1_control.c b/drivers/staging/intel_sst/intelmid_v1_control.c
index 445e0fb..4f2b34f 100644
--- a/drivers/staging/intel_sst/intelmid_v1_control.c
+++ b/drivers/staging/intel_sst/intelmid_v1_control.c
@@ -585,6 +585,10 @@ static int mx_set_selected_input_dev(u8 dev_id)
 	}
 	return sst_sc_reg_access(sc_access, PMIC_WRITE, num_reg);
 }
+static int mx_set_selected_lineout_dev(u8 dev_id)
+{
+	return 0;
+}
 
 static int mx_set_mute(int dev_id, u8 value)
 {
@@ -835,6 +839,7 @@ static int mx_get_vol(int dev_id, int *value)
 struct snd_pmic_ops snd_pmic_ops_mx = {
 	.set_input_dev = mx_set_selected_input_dev,
 	.set_output_dev = mx_set_selected_output_dev,
+	.set_lineout_dev = mx_set_selected_lineout_dev,
 	.set_mute = mx_set_mute,
 	.get_mute = mx_get_mute,
 	.set_vol = mx_set_vol,
diff --git a/drivers/staging/intel_sst/intelmid_v2_control.c b/drivers/staging/intel_sst/intelmid_v2_control.c
index 28754a5..a0cd227 100644
--- a/drivers/staging/intel_sst/intelmid_v2_control.c
+++ b/drivers/staging/intel_sst/intelmid_v2_control.c
@@ -885,7 +885,10 @@ static int nc_set_selected_input_dev(u8 value)
 	}
 	return sst_sc_reg_access(sc_access, PMIC_READ_MODIFY, num_val);
 }
-
+static int nc_set_selected_lineout_dev(u8 dev_id)
+{
+	return 0;
+}
 static int nc_get_mute(int dev_id, u8 *value)
 {
 	int retval = 0, mask = 0;
@@ -990,6 +993,7 @@ static int nc_get_vol(int dev_id, int *value)
 struct snd_pmic_ops snd_pmic_ops_nc = {
 	.set_input_dev	=	nc_set_selected_input_dev,
 	.set_output_dev =	nc_set_selected_output_dev,
+	.set_lineout_dev =	nc_set_selected_lineout_dev,
 	.set_mute	=	nc_set_mute,
 	.get_mute	=	nc_get_mute,
 	.set_vol	=	nc_set_vol,

