Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab1ECQx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 12:53:58 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45647 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab1ECQxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 12:53:55 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 21/23] intel_sst: add Master Volume
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 03 May 2011 17:38:18 +0100
Message-ID: <20110503163814.24853.57918.stgit@bob.linux.org.uk>
In-Reply-To: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
References: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lu Guanqun <guanqun.lu@intel.com>

With this patch, Master Volume will control AUDIOLVOL(0x10c) and
AUDIORVOL(0x10d); while PCM Volume will control HPLVOL(0x123) and
HPRVOL(0x124).

Signed-off-by: Lu Guanqun <guanqun.lu@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/intel_sst/intelmid.h             |    7 ++-
 drivers/staging/intel_sst/intelmid_ctrl.c        |   40 +++++++++++++++++-
 drivers/staging/intel_sst/intelmid_snd_control.h |    2 +
 drivers/staging/intel_sst/intelmid_v2_control.c  |   48 +++++++++++++++++-----
 4 files changed, 81 insertions(+), 16 deletions(-)


diff --git a/drivers/staging/intel_sst/intelmid.h b/drivers/staging/intel_sst/intelmid.h
index 3201d5a..14a7ba0 100644
--- a/drivers/staging/intel_sst/intelmid.h
+++ b/drivers/staging/intel_sst/intelmid.h
@@ -57,9 +57,9 @@
 #define MAX_CHANNEL_DMIC	5
 #define FIFO_SIZE		0 /* fifo not being used */
 #define INTEL_MAD		"Intel MAD"
-#define MAX_CTRL_MRST		7
+#define MAX_CTRL_MRST		8
 #define MAX_CTRL_MFLD		7
-#define MAX_CTRL		7
+#define MAX_CTRL		8
 #define MAX_VENDORS		4
 /* TODO +6 db */
 #define MAX_VOL		64
@@ -145,6 +145,8 @@ struct snd_control_val {
 	int	playback_vol_min;
 	int	capture_vol_max;
 	int	capture_vol_min;
+	int	master_vol_max;
+	int	master_vol_min;
 };
 
 struct mad_stream_pvt {
@@ -175,6 +177,7 @@ enum _widget_ctrl {
 	PLAYBACK_MUTE,
 	CAPTURE_VOL,
 	CAPTURE_MUTE,
+	MASTER_VOL,
 	MASTER_MUTE
 };
 enum _widget_ctrl_mfld {
diff --git a/drivers/staging/intel_sst/intelmid_ctrl.c b/drivers/staging/intel_sst/intelmid_ctrl.c
index af9e112..19ec474 100644
--- a/drivers/staging/intel_sst/intelmid_ctrl.c
+++ b/drivers/staging/intel_sst/intelmid_ctrl.c
@@ -80,9 +80,11 @@ struct snd_control_val intelmad_ctrl_val[MAX_VENDORS] = {
 	},
 	{
 		.playback_vol_max = 0,
-		.playback_vol_min = -126,
+		.playback_vol_min = -31,
 		.capture_vol_max = 0,
 		.capture_vol_min = -31,
+		.master_vol_max = 0,
+		.master_vol_min = -126,
 	},
 };
 
@@ -159,6 +161,15 @@ static int snd_intelmad_playback_volume_info(struct snd_kcontrol *kcontrol,
 	return 0;
 }
 
+static int snd_intelmad_master_volume_info(struct snd_kcontrol *kcontrol,
+					struct snd_ctl_elem_info *uinfo)
+{
+	snd_intelmad_volume_info(uinfo, STEREO_CNTL,
+		intelmad_ctrl_val[sst_card_vendor_id].master_vol_max,
+		intelmad_ctrl_val[sst_card_vendor_id].master_vol_min);
+	return 0;
+}
+
 /**
 * snd_intelmad_device_info_mrst - provides information about the devices available
 *
@@ -281,6 +292,11 @@ static int snd_intelmad_volume_get(struct snd_kcontrol *kcontrol,
 	case CAPTURE_VOL:
 		cntl_list[0] = PMIC_SND_CAPTURE_VOL;
 		break;
+
+	case MASTER_VOL:
+		cntl_list[0] = PMIC_SND_RIGHT_MASTER_VOL;
+		cntl_list[1] = PMIC_SND_LEFT_MASTER_VOL;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -291,7 +307,8 @@ static int snd_intelmad_volume_get(struct snd_kcontrol *kcontrol,
 	if (ret_val)
 		return ret_val;
 
-	if (kcontrol->id.numid == PLAYBACK_VOL) {
+	if (kcontrol->id.numid == PLAYBACK_VOL ||
+		kcontrol->id.numid == MASTER_VOL) {
 		ret_val = scard_ops->get_vol(cntl_list[1], &value);
 		uval->value.integer.value[1] = value;
 	}
@@ -399,6 +416,12 @@ static int snd_intelmad_volume_set(struct snd_kcontrol *kcontrol,
 	case CAPTURE_VOL:
 		cntl_list[0] = PMIC_SND_CAPTURE_VOL;
 		break;
+
+	case MASTER_VOL:
+		cntl_list[0] = PMIC_SND_LEFT_MASTER_VOL;
+		cntl_list[1] = PMIC_SND_RIGHT_MASTER_VOL;
+		break;
+
 	default:
 		return -EINVAL;
 	}
@@ -408,7 +431,8 @@ static int snd_intelmad_volume_set(struct snd_kcontrol *kcontrol,
 	if (ret_val)
 		return ret_val;
 
-	if (kcontrol->id.numid == PLAYBACK_VOL)
+	if (kcontrol->id.numid == PLAYBACK_VOL ||
+		kcontrol->id.numid == MASTER_VOL)
 		ret_val = scard_ops->set_vol(cntl_list[1],
 				uval->value.integer.value[1]);
 	return ret_val;
@@ -753,7 +777,6 @@ static int snd_intelmad_device_dmic_info_mfld(struct snd_kcontrol *kcontrol,
 	return 0;
 }
 
-
 struct snd_kcontrol_new snd_intelmad_controls_mrst[MAX_CTRL] __devinitdata = {
 {
 	.iface		=	SNDRV_CTL_ELEM_IFACE_MIXER,
@@ -811,6 +834,15 @@ struct snd_kcontrol_new snd_intelmad_controls_mrst[MAX_CTRL] __devinitdata = {
 },
 {
 	.iface		=	SNDRV_CTL_ELEM_IFACE_MIXER,
+	.name		=	"Master Playback Volume",
+	.access		=	SNDRV_CTL_ELEM_ACCESS_READWRITE,
+	.info		=	snd_intelmad_master_volume_info,
+	.get		=	snd_intelmad_volume_get,
+	.put		=	snd_intelmad_volume_set,
+	.private_value	=	0,
+},
+{
+	.iface		=	SNDRV_CTL_ELEM_IFACE_MIXER,
 	.name		=	"Master Playback Switch",
 	.access		=	SNDRV_CTL_ELEM_ACCESS_READWRITE,
 	.info		=	snd_intelmad_mute_info,
diff --git a/drivers/staging/intel_sst/intelmid_snd_control.h b/drivers/staging/intel_sst/intelmid_snd_control.h
index c7e9f16..06ad3a1 100644
--- a/drivers/staging/intel_sst/intelmid_snd_control.h
+++ b/drivers/staging/intel_sst/intelmid_snd_control.h
@@ -111,6 +111,8 @@ enum pmic_controls {
 	PMIC_SND_RIGHT_SPEAKER_MUTE =		0x0015,
 	PMIC_SND_RECEIVER_VOL =			0x0016,
 	PMIC_SND_RECEIVER_MUTE =		0x0017,
+	PMIC_SND_LEFT_MASTER_VOL =		0x0018,
+	PMIC_SND_RIGHT_MASTER_VOL =		0x0019,
 /* Other controls */
 	PMIC_SND_MUTE_ALL =			0x0020,
 	PMIC_MAX_CONTROLS =			0x0020,
diff --git a/drivers/staging/intel_sst/intelmid_v2_control.c b/drivers/staging/intel_sst/intelmid_v2_control.c
index 5e61fe8..b19f51e 100644
--- a/drivers/staging/intel_sst/intelmid_v2_control.c
+++ b/drivers/staging/intel_sst/intelmid_v2_control.c
@@ -788,9 +788,8 @@ static int nc_set_vol(int dev_id, int value)
 	case PMIC_SND_LEFT_PB_VOL:
 		pr_debug("PMIC_SND_LEFT_HP_VOL %d\n", value);
 		sc_access[0].value = -value;
-		sc_access[0].reg_addr  = AUDIOLVOL;
-		sc_access[0].mask =
-			(MASK0|MASK1|MASK2|MASK3|MASK4|MASK5|MASK6);
+		sc_access[0].reg_addr  = HPLVOL;
+		sc_access[0].mask = (MASK0|MASK1|MASK2|MASK3|MASK4);
 		entries = 1;
 		break;
 
@@ -798,15 +797,32 @@ static int nc_set_vol(int dev_id, int value)
 		pr_debug("PMIC_SND_RIGHT_HP_VOL value %d\n", value);
 		if (snd_pmic_ops_nc.num_channel == 1) {
 			sc_access[0].value = 0x04;
-		    sc_access[0].reg_addr = RMUTE;
+			sc_access[0].reg_addr = RMUTE;
 			sc_access[0].mask = MASK2;
 		} else {
+			sc_access[0].value = -value;
+			sc_access[0].reg_addr  = HPRVOL;
+			sc_access[0].mask = (MASK0|MASK1|MASK2|MASK3|MASK4);
+		}
+		entries = 1;
+		break;
+
+	case PMIC_SND_LEFT_MASTER_VOL:
+		pr_debug("PMIC_SND_LEFT_MASTER_VOL value %d\n", value);
+		sc_access[0].value = -value;
+		sc_access[0].reg_addr = AUDIOLVOL;
+		sc_access[0].mask =
+			(MASK0|MASK1|MASK2|MASK3|MASK4|MASK5|MASK6);
+		entries = 1;
+		break;
+
+	case PMIC_SND_RIGHT_MASTER_VOL:
+		pr_debug("PMIC_SND_RIGHT_MASTER_VOL value %d\n", value);
 		sc_access[0].value = -value;
-		sc_access[0].reg_addr  = AUDIORVOL;
+		sc_access[0].reg_addr = AUDIORVOL;
 		sc_access[0].mask =
 				(MASK0|MASK1|MASK2|MASK3|MASK4|MASK5|MASK6);
 		entries = 1;
-		}
 		break;
 
 	default:
@@ -971,18 +987,30 @@ static int nc_get_vol(int dev_id, int *value)
 		mask = (MASK0|MASK1|MASK2|MASK3|MASK4|MASK5);
 		break;
 
-	case PMIC_SND_RIGHT_PB_VOL:
-		pr_debug("GET_VOLUME_PMIC_LEFT_HP_VOL\n");
+	case PMIC_SND_LEFT_MASTER_VOL:
+		pr_debug("GET_VOLUME_PMIC_LEFT_MASTER_VOL\n");
 		sc_access.reg_addr = AUDIOLVOL;
 		mask = (MASK0|MASK1|MASK2|MASK3|MASK4|MASK5|MASK6);
 		break;
 
-	case PMIC_SND_LEFT_PB_VOL:
-		pr_debug("GET_VOLUME_PMIC_RIGHT_HP_VOL\n");
+	case PMIC_SND_RIGHT_MASTER_VOL:
+		pr_debug("GET_VOLUME_PMIC_RIGHT_MASTER_VOL\n");
 		sc_access.reg_addr = AUDIORVOL;
 		mask = (MASK0|MASK1|MASK2|MASK3|MASK4|MASK5|MASK6);
 		break;
 
+	case PMIC_SND_RIGHT_PB_VOL:
+		pr_debug("GET_VOLUME_PMIC_RIGHT_HP_VOL\n");
+		sc_access.reg_addr = HPRVOL;
+		mask = (MASK0|MASK1|MASK2|MASK3|MASK4);
+		break;
+
+	case PMIC_SND_LEFT_PB_VOL:
+		pr_debug("GET_VOLUME_PMIC_LEFT_HP_VOL\n");
+		sc_access.reg_addr = HPLVOL;
+		mask = (MASK0|MASK1|MASK2|MASK3|MASK4);
+		break;
+
 	default:
 		return -EINVAL;
 

