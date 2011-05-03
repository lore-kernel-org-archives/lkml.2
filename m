Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab1ECRxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 13:53:06 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36881 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab1ECRxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 13:53:04 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 07/23] intel_sst: DMIC routing
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 03 May 2011 17:33:01 +0100
Message-ID: <20110503163300.24853.62800.stgit@bob.linux.org.uk>
In-Reply-To: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
References: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sitanshu Nanavati <sitanshu.nanavati@intel.com>

This patch adds support for configuring and routing the
DMICs (assigned HW route to DMICs)

Signed-off-by: Sitanshu Nanavati <sitanshu.nanavati@intel.com>
Signed-off-by: Ramesh Babu K V <ramesh.babu@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/intel_sst/intel_sst.h             |    4 
 drivers/staging/intel_sst/intel_sst_stream.c      |    2 
 drivers/staging/intel_sst/intelmid.h              |   11 +
 drivers/staging/intel_sst/intelmid_ctrl.c         |  198 +++++++++++++++++++++
 drivers/staging/intel_sst/intelmid_msic_control.c |   58 ++++++
 5 files changed, 270 insertions(+), 3 deletions(-)


diff --git a/drivers/staging/intel_sst/intel_sst.h b/drivers/staging/intel_sst/intel_sst.h
index ea6cd97..c0d3156 100644
--- a/drivers/staging/intel_sst/intel_sst.h
+++ b/drivers/staging/intel_sst/intel_sst.h
@@ -33,6 +33,7 @@
 
 #define SST_CARD_NAMES "intel_mid_card"
 
+#define MFLD_MAX_HW_CH 4
 /* control list Pmic & Lpe */
 /* Input controls */
 enum port_status {
@@ -108,6 +109,9 @@ struct snd_pmic_ops {
 	int (*power_down_pmic_pb) (unsigned int device);
 	int (*power_down_pmic_cp) (unsigned int device);
 	int (*power_down_pmic) (void);
+	unsigned int hw_dmic_map[MFLD_MAX_HW_CH];
+	unsigned int available_dmics;
+	int (*set_hw_dmic_route) (u8 index);
 };
 
 struct intel_sst_pcm_control {
diff --git a/drivers/staging/intel_sst/intel_sst_stream.c b/drivers/staging/intel_sst/intel_sst_stream.c
index dd9c530..be4565e 100644
--- a/drivers/staging/intel_sst/intel_sst_stream.c
+++ b/drivers/staging/intel_sst/intel_sst_stream.c
@@ -48,7 +48,7 @@
  */
 int sst_check_device_type(u32 device, u32 num_chan, u32 *pcm_slot)
 {
-	if (device > MAX_NUM_STREAMS_MFLD) {
+	if (device >= MAX_NUM_STREAMS_MFLD) {
 		pr_debug("device type invalid %d\n", device);
 		return -EINVAL;
 	}
diff --git a/drivers/staging/intel_sst/intelmid.h b/drivers/staging/intel_sst/intelmid.h
index 4ed4a94..7b3dbf6 100644
--- a/drivers/staging/intel_sst/intelmid.h
+++ b/drivers/staging/intel_sst/intelmid.h
@@ -28,6 +28,7 @@
 #define __INTELMID_H
 
 #include <linux/time.h>
+#include <sound/jack.h>
 
 #define DRIVER_NAME_MFLD "msic_audio"
 #define DRIVER_NAME_MRST "pmic_audio"
@@ -43,7 +44,7 @@
 #define MAX_BUFFER		(800*1024) /* for PCM */
 #define MIN_BUFFER		(800*1024)
 #define MAX_PERIODS		(1024*2)
-#define MIN_PERIODS		1
+#define MIN_PERIODS		2
 #define MAX_PERIOD_BYTES MAX_BUFFER
 #define MIN_PERIOD_BYTES 32
 /*#define MIN_PERIOD_BYTES 160*/
@@ -57,7 +58,7 @@
 #define FIFO_SIZE		0 /* fifo not being used */
 #define INTEL_MAD		"Intel MAD"
 #define MAX_CTRL_MRST		7
-#define MAX_CTRL_MFLD		3
+#define MAX_CTRL_MFLD		7
 #define MAX_CTRL		7
 #define MAX_VENDORS		4
 /* TODO +6 db */
@@ -167,6 +168,12 @@ enum _widget_ctrl {
 enum _widget_ctrl_mfld {
 	LINEOUT_SEL_MFLD = 3,
 };
+enum hw_chs {
+	HW_CH0 = 0,
+	HW_CH1,
+	HW_CH2,
+	HW_CH3
+};
 
 void period_elapsed(void *mad_substream);
 int snd_intelmad_alloc_stream(struct snd_pcm_substream *substream);
diff --git a/drivers/staging/intel_sst/intelmid_ctrl.c b/drivers/staging/intel_sst/intelmid_ctrl.c
index 3036928..dbe29c3 100644
--- a/drivers/staging/intel_sst/intelmid_ctrl.c
+++ b/drivers/staging/intel_sst/intelmid_ctrl.c
@@ -35,6 +35,22 @@
 #include "intelmid_snd_control.h"
 #include "intelmid.h"
 
+#define HW_CH_BASE 4
+
+
+#define HW_CH_0	"Hw1"
+#define HW_CH_1	"Hw2"
+#define HW_CH_2	"Hw3"
+#define HW_CH_3	"Hw4"
+
+static char *router_dmics[] = {	"DMIC1",
+				"DMIC2",
+				"DMIC3",
+				"DMIC4",
+				"DMIC5",
+				"DMIC6"
+				};
+
 static char *out_names_mrst[] = {"Headphones",
 				"Internal speakers"};
 static char *in_names_mrst[] = {"AMIC",
@@ -574,6 +590,152 @@ static int snd_intelmad_device_set(struct snd_kcontrol *kcontrol,
 	return ret_val;
 }
 
+static int snd_intelmad_device_dmic_get(struct snd_kcontrol *kcontrol,
+					struct snd_ctl_elem_value *uval)
+{
+	struct snd_intelmad *intelmaddata;
+	struct snd_pmic_ops *scard_ops;
+
+	WARN_ON(!uval);
+	WARN_ON(!kcontrol);
+
+	intelmaddata = kcontrol->private_data;
+	scard_ops = intelmaddata->sstdrv_ops->scard_ops;
+
+	if (scard_ops->input_dev_id != DMIC) {
+		pr_debug("input dev = 0x%x\n", scard_ops->input_dev_id);
+		return 0;
+	}
+
+	if (intelmaddata->cpu_id == CPU_CHIP_PENWELL)
+		uval->value.enumerated.item[0] = kcontrol->private_value;
+	else
+		pr_debug(" CPU id = 0x%xis invalid.\n",
+			intelmaddata->cpu_id);
+	return 0;
+}
+
+void msic_set_bit(u8 index, unsigned int *available_dmics)
+{
+	*available_dmics |= (1 << index);
+}
+
+void msic_clear_bit(u8 index, unsigned int *available_dmics)
+{
+	*available_dmics &= ~(1 << index);
+}
+
+int msic_is_set_bit(u8 index, unsigned int *available_dmics)
+{
+	int ret_val;
+
+	ret_val = (*available_dmics & (1 << index));
+	return ret_val;
+}
+
+static int snd_intelmad_device_dmic_set(struct snd_kcontrol *kcontrol,
+					struct snd_ctl_elem_value *uval)
+{
+	struct snd_intelmad *intelmaddata;
+	struct snd_pmic_ops *scard_ops;
+	int i, dmic_index;
+	unsigned int available_dmics;
+	int jump_count;
+	int max_dmics = ARRAY_SIZE(router_dmics);
+
+	WARN_ON(!uval);
+	WARN_ON(!kcontrol);
+
+	intelmaddata = kcontrol->private_data;
+	WARN_ON(!intelmaddata->sstdrv_ops);
+
+	scard_ops = intelmaddata->sstdrv_ops->scard_ops;
+	WARN_ON(!scard_ops);
+
+	if (scard_ops->input_dev_id != DMIC) {
+		pr_debug("input dev = 0x%x\n", scard_ops->input_dev_id);
+		return 0;
+	}
+
+	available_dmics = scard_ops->available_dmics;
+
+	if (kcontrol->private_value > uval->value.enumerated.item[0]) {
+		pr_debug("jump count -1.\n");
+		jump_count = -1;
+	} else {
+		pr_debug("jump count 1.\n");
+		jump_count = 1;
+	}
+
+	dmic_index =  uval->value.enumerated.item[0];
+	pr_debug("set function. dmic_index = %d, avl_dmic = 0x%x\n",
+			 dmic_index, available_dmics);
+	for (i = 0; i < max_dmics; i++) {
+		pr_debug("set function. loop index = 0x%x.  dmic_index = 0x%x\n",
+			 i, dmic_index);
+		if (!msic_is_set_bit(dmic_index, &available_dmics)) {
+			msic_clear_bit(kcontrol->private_value,
+						&available_dmics);
+			msic_set_bit(dmic_index, &available_dmics);
+			kcontrol->private_value = dmic_index;
+			scard_ops->available_dmics = available_dmics;
+			scard_ops->hw_dmic_map[kcontrol->id.numid-HW_CH_BASE] =
+				kcontrol->private_value;
+			scard_ops->set_hw_dmic_route
+				(kcontrol->id.numid-HW_CH_BASE);
+			return 0;
+		}
+
+		dmic_index += jump_count;
+
+		if (dmic_index > (max_dmics - 1) && jump_count == 1) {
+			pr_debug("Resettingthe dmic index to 0.\n");
+			dmic_index = 0;
+		} else if (dmic_index == -1 && jump_count == -1) {
+			pr_debug("Resetting the dmic index to 5.\n");
+			dmic_index = max_dmics - 1;
+		}
+	}
+
+	return -EINVAL;
+}
+
+static int snd_intelmad_device_dmic_info_mfld(struct snd_kcontrol *kcontrol,
+					struct snd_ctl_elem_info *uinfo)
+{
+	struct snd_intelmad *intelmaddata;
+	struct snd_pmic_ops *scard_ops;
+
+	uinfo->count                  = MONO_CNTL;
+	uinfo->type                   = SNDRV_CTL_ELEM_TYPE_ENUMERATED;
+	uinfo->value.enumerated.items = ARRAY_SIZE(router_dmics);
+
+	intelmaddata = kcontrol->private_data;
+	WARN_ON(!intelmaddata->sstdrv_ops);
+
+	scard_ops = intelmaddata->sstdrv_ops->scard_ops;
+	WARN_ON(!scard_ops);
+
+	if (uinfo->value.enumerated.item >= uinfo->value.enumerated.items)
+		uinfo->value.enumerated.item =
+			uinfo->value.enumerated.items - 1;
+
+	strncpy(uinfo->value.enumerated.name,
+	router_dmics[uinfo->value.enumerated.item],
+	sizeof(uinfo->value.enumerated.name)-1);
+
+
+	msic_set_bit(kcontrol->private_value, &scard_ops->available_dmics);
+	pr_debug("info function. avl_dmic = 0x%x",
+		scard_ops->available_dmics);
+
+	scard_ops->hw_dmic_map[kcontrol->id.numid-HW_CH_BASE] =
+		kcontrol->private_value;
+
+	return 0;
+}
+
+
 struct snd_kcontrol_new snd_intelmad_controls_mrst[MAX_CTRL] __devinitdata = {
 {
 	.iface		=	SNDRV_CTL_ELEM_IFACE_MIXER,
@@ -669,5 +831,41 @@ snd_intelmad_controls_mfld[MAX_CTRL_MFLD] __devinitdata = {
 	.put		=	snd_intelmad_device_set,
 	.private_value	=	0,
 },
+{
+	.iface		=	SNDRV_CTL_ELEM_IFACE_MIXER,
+	.name		=	HW_CH_0,
+	.access		=	SNDRV_CTL_ELEM_ACCESS_READWRITE,
+	.info		=	snd_intelmad_device_dmic_info_mfld,
+	.get		=	snd_intelmad_device_dmic_get,
+	.put		=	snd_intelmad_device_dmic_set,
+	.private_value	=	0
+},
+{
+	.iface		=	SNDRV_CTL_ELEM_IFACE_MIXER,
+	.name		=	HW_CH_1,
+	.access		=	SNDRV_CTL_ELEM_ACCESS_READWRITE,
+	.info		=	snd_intelmad_device_dmic_info_mfld,
+	.get		=	snd_intelmad_device_dmic_get,
+	.put		=	snd_intelmad_device_dmic_set,
+	.private_value	=	1
+},
+{
+	.iface		=	SNDRV_CTL_ELEM_IFACE_MIXER,
+	.name		=	HW_CH_2,
+	.access		=	SNDRV_CTL_ELEM_ACCESS_READWRITE,
+	.info		=	snd_intelmad_device_dmic_info_mfld,
+	.get		=	snd_intelmad_device_dmic_get,
+	.put		=	snd_intelmad_device_dmic_set,
+	.private_value	=	2
+},
+{
+	.iface		=	SNDRV_CTL_ELEM_IFACE_MIXER,
+	.name		=	HW_CH_3,
+	.access		=	SNDRV_CTL_ELEM_ACCESS_READWRITE,
+	.info		=	snd_intelmad_device_dmic_info_mfld,
+	.get		=	snd_intelmad_device_dmic_get,
+	.put		=	snd_intelmad_device_dmic_set,
+	.private_value	=	3
+}
 };
 
diff --git a/drivers/staging/intel_sst/intelmid_msic_control.c b/drivers/staging/intel_sst/intelmid_msic_control.c
index 10073c5..976091b 100644
--- a/drivers/staging/intel_sst/intelmid_msic_control.c
+++ b/drivers/staging/intel_sst/intelmid_msic_control.c
@@ -29,8 +29,14 @@
 #include <linux/pci.h>
 #include <linux/file.h>
 #include <linux/delay.h>
+#include <sound/control.h>
 #include "intel_sst.h"
+#include <linux/input.h>
 #include "intelmid_snd_control.h"
+#include "intelmid.h"
+
+#define AUDIOMUX12  0x24c
+#define AUDIOMUX34  0x24d
 
 static int msic_init_card(void)
 {
@@ -680,6 +686,57 @@ static int msic_set_selected_input_dev(u8 value)
 	return retval;
 }
 
+static int msic_set_hw_dmic_route(u8 hw_ch_index)
+{
+	struct sc_reg_access sc_access_router;
+	int    retval = -EINVAL;
+
+	switch (hw_ch_index) {
+	case HW_CH0:
+		sc_access_router.reg_addr = AUDIOMUX12;
+		sc_access_router.value    = snd_msic_ops.hw_dmic_map[0];
+		sc_access_router.mask     = (MASK2 | MASK1 | MASK0);
+		pr_debug("hw_ch0.  value = 0x%x\n",
+				sc_access_router.value);
+		retval = sst_sc_reg_access(&sc_access_router,
+				PMIC_READ_MODIFY, 1);
+		break;
+
+	case HW_CH1:
+		sc_access_router.reg_addr = AUDIOMUX12;
+		sc_access_router.value    = (snd_msic_ops.hw_dmic_map[1]) << 4;
+		sc_access_router.mask     = (MASK6 | MASK5 | MASK4);
+		pr_debug("### hw_ch1.  value = 0x%x\n",
+				sc_access_router.value);
+		retval = sst_sc_reg_access(&sc_access_router,
+				PMIC_READ_MODIFY, 1);
+		break;
+
+	case HW_CH2:
+		sc_access_router.reg_addr = AUDIOMUX34;
+		sc_access_router.value    = snd_msic_ops.hw_dmic_map[2];
+		sc_access_router.mask     = (MASK2 | MASK1 | MASK0);
+		pr_debug("hw_ch2.  value = 0x%x\n",
+				sc_access_router.value);
+		retval = sst_sc_reg_access(&sc_access_router,
+				PMIC_READ_MODIFY, 1);
+		break;
+
+	case HW_CH3:
+		sc_access_router.reg_addr = AUDIOMUX34;
+		sc_access_router.value    = (snd_msic_ops.hw_dmic_map[3]) << 4;
+		sc_access_router.mask     = (MASK6 | MASK5 | MASK4);
+		pr_debug("hw_ch3.  value = 0x%x\n",
+				sc_access_router.value);
+		retval = sst_sc_reg_access(&sc_access_router,
+				PMIC_READ_MODIFY, 1);
+		break;
+	}
+
+	return retval;
+}
+
+
 static int msic_set_pcm_voice_params(void)
 {
 	return 0;
@@ -724,6 +781,7 @@ struct snd_pmic_ops snd_msic_ops = {
 	.set_input_dev	=	msic_set_selected_input_dev,
 	.set_output_dev =	msic_set_selected_output_dev,
 	.set_lineout_dev =	msic_set_selected_lineout_dev,
+	.set_hw_dmic_route =    msic_set_hw_dmic_route,
 	.set_mute	=	msic_set_mute,
 	.get_mute	=	msic_get_mute,
 	.set_vol	=	msic_set_vol,

