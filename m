Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab1ECQxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 12:53:10 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45625 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab1ECQxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 12:53:07 -0400
X-Greylist: delayed 357 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 May 2011 12:52:53 EDT
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 02/23] intel_sst: MSIC codec power optimisation
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 03 May 2011 17:32:01 +0100
Message-ID: <20110503163200.24853.6842.stgit@bob.linux.org.uk>
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

This patch adds power optimization for the msic codec and ensure
codec is completely powered off when codec is idle.

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Ramesh Babu K V <ramesh.babu@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/intel_sst/intel_sst.h              |    4 
 .../staging/intel_sst/intel_sst_drv_interface.c    |   10 -
 drivers/staging/intel_sst/intelmid_msic_control.c  |  275 ++++++++++++++------
 drivers/staging/intel_sst/intelmid_v0_control.c    |    4 
 drivers/staging/intel_sst/intelmid_v1_control.c    |    4 
 drivers/staging/intel_sst/intelmid_v2_control.c    |    4 
 6 files changed, 201 insertions(+), 100 deletions(-)


diff --git a/drivers/staging/intel_sst/intel_sst.h b/drivers/staging/intel_sst/intel_sst.h
index cb03ff7..bf0f9e2 100644
--- a/drivers/staging/intel_sst/intel_sst.h
+++ b/drivers/staging/intel_sst/intel_sst.h
@@ -103,8 +103,8 @@ struct snd_pmic_ops {
 
 	int (*power_up_pmic_pb) (unsigned int port);
 	int (*power_up_pmic_cp) (unsigned int port);
-	int (*power_down_pmic_pb) (void);
-	int (*power_down_pmic_cp) (void);
+	int (*power_down_pmic_pb) (unsigned int device);
+	int (*power_down_pmic_cp) (unsigned int device);
 	int (*power_down_pmic) (void);
 };
 
diff --git a/drivers/staging/intel_sst/intel_sst_drv_interface.c b/drivers/staging/intel_sst/intel_sst_drv_interface.c
index 78ee44d..a47e382 100644
--- a/drivers/staging/intel_sst/intel_sst_drv_interface.c
+++ b/drivers/staging/intel_sst/intel_sst_drv_interface.c
@@ -105,21 +105,23 @@ void free_stream_context(unsigned int str_id)
 	if (!sst_validate_strid(str_id)) {
 		/* str_id is valid, so stream is alloacted */
 		stream = &sst_drv_ctx->streams[str_id];
+		if (sst_free_stream(str_id))
+			sst_clean_stream(&sst_drv_ctx->streams[str_id]);
 		if (stream->ops == STREAM_OPS_PLAYBACK ||
 				stream->ops == STREAM_OPS_PLAYBACK_DRM) {
 			sst_drv_ctx->pb_streams--;
 			if (sst_drv_ctx->pb_streams == 0)
-				sst_drv_ctx->scard_ops->power_down_pmic_pb();
+				sst_drv_ctx->scard_ops->power_down_pmic_pb(
+						stream->device);
 		} else if (stream->ops == STREAM_OPS_CAPTURE) {
 			sst_drv_ctx->cp_streams--;
 			if (sst_drv_ctx->cp_streams == 0)
-				sst_drv_ctx->scard_ops->power_down_pmic_cp();
+				sst_drv_ctx->scard_ops->power_down_pmic_cp(
+						stream->device);
 		}
 		if (sst_drv_ctx->pb_streams == 0
 				&& sst_drv_ctx->cp_streams == 0)
 			sst_drv_ctx->scard_ops->power_down_pmic();
-		if (sst_free_stream(str_id))
-			sst_clean_stream(&sst_drv_ctx->streams[str_id]);
 	}
 }
 
diff --git a/drivers/staging/intel_sst/intelmid_msic_control.c b/drivers/staging/intel_sst/intelmid_msic_control.c
index da093ed..bbe9ab2 100644
--- a/drivers/staging/intel_sst/intelmid_msic_control.c
+++ b/drivers/staging/intel_sst/intelmid_msic_control.c
@@ -28,8 +28,8 @@
 
 #include <linux/pci.h>
 #include <linux/file.h>
+#include <linux/delay.h>
 #include "intel_sst.h"
-#include "intel_sst_ioctl.h"
 #include "intelmid_snd_control.h"
 
 static int msic_init_card(void)
@@ -64,17 +64,17 @@ static int msic_init_card(void)
 		{0x27B, 0x01, 0},
 		{0x27C, 0x0a, 0},
 		/* Set vol HSLRVOLCTRL, IHFVOL */
-		{0x259, 0x04, 0},
-		{0x25A, 0x04, 0},
-		{0x25B, 0x04, 0},
-		{0x25C, 0x04, 0},
+		{0x259, 0x08, 0},
+		{0x25A, 0x08, 0},
+		{0x25B, 0x08, 0},
+		{0x25C, 0x08, 0},
 		/* HSEPRXCTRL  Enable the headset left and right FIR filters  */
 		{0x250, 0x30, 0},
 		/* HSMIXER */
 		{0x256, 0x11, 0},
 		/* amic configuration */
-		{0x249, 0x09, 0x0},
-		{0x24A, 0x09, 0x0},
+		{0x249, 0x01, 0x0},
+		{0x24A, 0x01, 0x0},
 		/* unmask ocaudio/accdet interrupts */
 		{0x1d, 0x00, 0x00},
 		{0x1e, 0x00, 0x00},
@@ -91,79 +91,84 @@ static int msic_init_card(void)
 
 static int msic_power_up_pb(unsigned int device)
 {
-	struct sc_reg_access sc_access1[] = {
+	struct sc_reg_access vaud[] = {
 		/* turn on the audio power supplies */
-		{0x0DB, 0x05, 0},
+		{0x0DB, 0x07, 0},
+	};
+	struct sc_reg_access pll[] = {
+		/* turn on PLL */
+		{0x240, 0x20, 0},
+	};
+	struct sc_reg_access vhs[] = {
 		/*  VHSP */
 		{0x0DC, 0xFF, 0},
 		/*  VHSN */
 		{0x0DD, 0x3F, 0},
-		/* turn on PLL */
-		{0x240, 0x21, 0},
 	};
-	struct sc_reg_access sc_access2[] = {
+	struct sc_reg_access hsdac[] = {
 		/*  disable driver */
 		{0x25D, 0x0, 0x43},
 		/* DAC CONFIG ; both HP, LP on */
 		{0x257, 0x03, 0x03},
 	};
-	struct sc_reg_access sc_access3[] = {
+	struct sc_reg_access hs_filter[] = {
 		/* HSEPRXCTRL  Enable the headset left and right FIR filters  */
 		{0x250, 0x30, 0},
 		/* HSMIXER */
 		{0x256, 0x11, 0},
 	};
-	struct sc_reg_access sc_access4[] = {
+	struct sc_reg_access hs_enable[] = {
 		/* enable driver */
 		{0x25D, 0x3, 0x3},
+		{0x26C, 0x0, 0x2},
 		/* unmute the headset */
 		{ 0x259, 0x80, 0x80},
 		{ 0x25A, 0x80, 0x80},
 	};
-	struct sc_reg_access sc_access_vihf[] = {
+	struct sc_reg_access vihf[] = {
 		/*  VIHF ON */
-		{0x0C9, 0x2D, 0x00},
+		{0x0C9, 0x27, 0x00},
 	};
-	struct sc_reg_access sc_access22[] = {
+	struct sc_reg_access ihf_filter[] = {
 		/*  disable driver */
 		{0x25D, 0x00, 0x0C},
 		/*Filer DAC enable*/
 		{0x251, 0x03, 0x03},
 		{0x257, 0x0C, 0x0C},
 	};
-	struct sc_reg_access sc_access32[] = {
+	struct sc_reg_access ihf_en[] = {
 		/*enable drv*/
 		{0x25D, 0x0C, 0x0c},
 	};
-	struct sc_reg_access sc_access42[] = {
+	struct sc_reg_access ihf_unmute[] = {
 		/*unmute headset*/
 		{0x25B, 0x80, 0x80},
 		{0x25C, 0x80, 0x80},
 	};
-	struct sc_reg_access sc_access23[] = {
+	struct sc_reg_access epdac[] = {
 		/*  disable driver */
 		{0x25D, 0x0, 0x43},
 		/* DAC CONFIG ; both HP, LP on */
 		{0x257, 0x03, 0x03},
 	};
-	struct sc_reg_access sc_access43[] = {
+	struct sc_reg_access ep_enable[] = {
 		/* enable driver */
 		{0x25D, 0x40, 0x40},
 		/* unmute the headset */
 		{ 0x259, 0x80, 0x80},
 		{ 0x25A, 0x80, 0x80},
 	};
-	struct sc_reg_access sc_access_vib[] = {
+	struct sc_reg_access vib1_en[] = {
 		/* enable driver, ADC */
 		{0x25D, 0x10, 0x10},
 		{0x264, 0x02, 0x02},
 	};
-	struct sc_reg_access sc_access_hap[] = {
+	struct sc_reg_access vib2_en[] = {
 		/* enable driver, ADC */
 		{0x25D, 0x20, 0x20},
 		{0x26A, 0x02, 0x02},
 	};
-	struct sc_reg_access sc_access_pcm2[] = {
+	struct sc_reg_access pcm2_en[] = {
 		/* enable pcm 2 */
 		{0x27C, 0x1, 0x1},
 	};
@@ -176,89 +181,84 @@ static int msic_power_up_pb(unsigned int device)
 	}
 
 	pr_debug("powering up pb.... Device %d\n", device);
-	sst_sc_reg_access(sc_access1, PMIC_WRITE, 4);
+	sst_sc_reg_access(vaud, PMIC_WRITE, 1);
+	msleep(1);
+	sst_sc_reg_access(pll, PMIC_WRITE, 1);
+	msleep(1);
 	switch (device) {
 	case SND_SST_DEVICE_HEADSET:
 		if (snd_msic_ops.output_dev_id == STEREO_HEADPHONE) {
-			sst_sc_reg_access(sc_access2, PMIC_READ_MODIFY, 2);
-			sst_sc_reg_access(sc_access3, PMIC_WRITE, 2);
-			sst_sc_reg_access(sc_access4, PMIC_READ_MODIFY, 3);
+			sst_sc_reg_access(vhs, PMIC_WRITE, 2);
+			sst_sc_reg_access(hsdac, PMIC_READ_MODIFY, 2);
+			sst_sc_reg_access(hs_filter, PMIC_WRITE, 2);
+			sst_sc_reg_access(hs_enable, PMIC_READ_MODIFY, 4);
 		} else {
-			sst_sc_reg_access(sc_access23, PMIC_READ_MODIFY, 2);
-			sst_sc_reg_access(sc_access3, PMIC_WRITE, 2);
-			sst_sc_reg_access(sc_access43, PMIC_READ_MODIFY, 3);
+			sst_sc_reg_access(epdac, PMIC_READ_MODIFY, 2);
+			sst_sc_reg_access(hs_filter, PMIC_WRITE, 2);
+			sst_sc_reg_access(ep_enable, PMIC_READ_MODIFY, 3);
 		}
 		snd_msic_ops.pb_on = 1;
 		break;
 
 	case SND_SST_DEVICE_IHF:
-		sst_sc_reg_access(sc_access_vihf, PMIC_WRITE, 1);
-		sst_sc_reg_access(sc_access22, PMIC_READ_MODIFY, 3);
-		sst_sc_reg_access(sc_access32, PMIC_READ_MODIFY, 1);
-		sst_sc_reg_access(sc_access42, PMIC_READ_MODIFY, 2);
+		sst_sc_reg_access(vihf, PMIC_WRITE, 1);
+		sst_sc_reg_access(ihf_filter, PMIC_READ_MODIFY, 3);
+		sst_sc_reg_access(ihf_en, PMIC_READ_MODIFY, 1);
+		sst_sc_reg_access(ihf_unmute, PMIC_READ_MODIFY, 2);
 		break;
 
 	case SND_SST_DEVICE_VIBRA:
-		sst_sc_reg_access(sc_access_vib, PMIC_READ_MODIFY, 2);
+		sst_sc_reg_access(vib1_en, PMIC_READ_MODIFY, 2);
 		break;
 
 	case SND_SST_DEVICE_HAPTIC:
-		sst_sc_reg_access(sc_access_hap, PMIC_READ_MODIFY, 2);
+		sst_sc_reg_access(vib2_en, PMIC_READ_MODIFY, 2);
 		break;
 
 	default:
 		pr_warn("Wrong Device %d, selected %d\n",
 			       device, snd_msic_ops.output_dev_id);
 	}
-	return sst_sc_reg_access(sc_access_pcm2, PMIC_READ_MODIFY, 1);
+	return sst_sc_reg_access(pcm2_en, PMIC_READ_MODIFY, 1);
 }
 
 static int msic_power_up_cp(unsigned int device)
 {
-	struct sc_reg_access sc_access[] = {
+	struct sc_reg_access vaud[] = {
 		/* turn on the audio power supplies */
-		{0x0DB, 0x05, 0},
-		/*  VHSP */
-		{0x0DC, 0xFF, 0},
-		/*  VHSN */
-		{0x0DD, 0x3F, 0},
+		{0x0DB, 0x07, 0},
+	};
+	struct sc_reg_access pll[] = {
 		/* turn on PLL */
-		{0x240, 0x21, 0},
-
-		/*  Turn on DMIC supply  */
-		{0x247, 0xA0, 0x0},
-		{0x240, 0x21, 0x0},
-		{0x24C, 0x10, 0x0},
-
+		{0x240, 0x20, 0},
+	};
+	struct sc_reg_access dmic_bias[] = {
+		/*  Turn on AMIC supply  */
+		{0x247, 0xA0, 0xA0},
+	};
+	struct sc_reg_access dmic[] = {
 		/* mic demux enable */
-		{0x245, 0x3F, 0x0},
-		{0x246, 0x7, 0x0},
+		{0x245, 0x3F, 0x3F},
+		{0x246, 0x07, 0x07},
 
 	};
-	struct sc_reg_access sc_access_amic[] = {
-		/* turn on the audio power supplies */
-		{0x0DB, 0x05, 0},
-		/*  VHSP */
-		{0x0DC, 0xFF, 0},
-		/*  VHSN */
-		{0x0DD, 0x3F, 0},
-		/* turn on PLL */
-		{0x240, 0x21, 0},
-		/*ADC EN*/
-		{0x248, 0x05, 0x0},
-		{0x24C, 0x76, 0x0},
-		/*MIC EN*/
-		{0x249, 0x09, 0x0},
-		{0x24A, 0x09, 0x0},
+	struct sc_reg_access amic_bias[] = {
 		/*  Turn on AMIC supply  */
-		{0x247, 0xFC, 0x0},
+		{0x247, 0xFC, 0xFC},
+	};
+	struct sc_reg_access amic[] = {
+		/*MIC EN*/
+		{0x249, 0x01, 0x01},
+		{0x24A, 0x01, 0x01},
+		/*ADC EN*/
+		{0x248, 0x05, 0x0F},
 
 	};
-	struct sc_reg_access sc_access2[] = {
+	struct sc_reg_access pcm2[] = {
 		/* enable pcm 2 */
 		{0x27C, 0x1, 0x1},
 	};
-	struct sc_reg_access sc_access3[] = {
+	struct sc_reg_access tx_on[] = {
 		/*wait for mic to stabalize before turning on audio channels*/
 		{0x24F, 0x3C, 0x0},
 	};
@@ -271,42 +271,141 @@ static int msic_power_up_cp(unsigned int device)
 	}
 
 	pr_debug("powering up cp....%d\n", snd_msic_ops.input_dev_id);
-	sst_sc_reg_access(sc_access2, PMIC_READ_MODIFY, 1);
+	sst_sc_reg_access(vaud, PMIC_WRITE, 1);
+	msleep(500);/*FIXME need optimzed value here*/
+	sst_sc_reg_access(pll, PMIC_WRITE, 1);
+	msleep(1);
 	snd_msic_ops.cap_on = 1;
-	if (snd_msic_ops.input_dev_id == AMIC)
-		sst_sc_reg_access(sc_access_amic, PMIC_WRITE, 9);
-	else
-		sst_sc_reg_access(sc_access, PMIC_WRITE, 9);
-	return sst_sc_reg_access(sc_access3, PMIC_WRITE, 1);
-
+	if (snd_msic_ops.input_dev_id == AMIC) {
+		sst_sc_reg_access(amic_bias, PMIC_READ_MODIFY, 1);
+		msleep(1);
+		sst_sc_reg_access(amic, PMIC_READ_MODIFY, 3);
+	} else {
+		sst_sc_reg_access(dmic_bias, PMIC_READ_MODIFY, 1);
+		msleep(1);
+		sst_sc_reg_access(dmic, PMIC_READ_MODIFY, 2);
+	}
+	msleep(1);
+	sst_sc_reg_access(tx_on, PMIC_WRITE, 1);
+	return sst_sc_reg_access(pcm2, PMIC_READ_MODIFY, 1);
 }
 
 static int msic_power_down(void)
 {
-	int retval = 0;
+	struct sc_reg_access power_dn[] = {
+		/*  VHSP */
+		{0x0DC, 0xC4, 0},
+		/*  VHSN */
+		{0x0DD, 0x04, 0},
+		/*  VIHF */
+		{0x0C9, 0x24, 0},
+	};
+	struct sc_reg_access pll[] = {
+		/* turn off PLL*/
+		{0x240, 0x00, 0x0},
+	};
+	struct sc_reg_access vaud[] = {
+		/* turn off VAUD*/
+		{0x0DB, 0x04, 0},
+	};
 
 	pr_debug("powering dn msic\n");
 	snd_msic_ops.pb_on = 0;
 	snd_msic_ops.cap_on = 0;
-	return retval;
+	sst_sc_reg_access(power_dn, PMIC_WRITE, 3);
+	msleep(1);
+	sst_sc_reg_access(pll, PMIC_WRITE, 1);
+	msleep(1);
+	sst_sc_reg_access(vaud, PMIC_WRITE, 1);
+	return 0;
 }
 
-static int msic_power_down_pb(void)
+static int msic_power_down_pb(unsigned int device)
 {
-	int retval = 0;
+	struct sc_reg_access drv_enable[] = {
+		{0x25D, 0x00, 0x00},
+	};
+	struct sc_reg_access hs_mute[] = {
+		{0x259, 0x80, 0x80},
+		{0x25A, 0x80, 0x80},
+		{0x26C, 0x02, 0x02},
+	};
+	struct sc_reg_access hs_off[] = {
+		{0x257, 0x00, 0x03},
+		{0x250, 0x00, 0x30},
+	};
+	struct sc_reg_access ihf_mute[] = {
+		{0x25B, 0x80, 0x80},
+		{0x25C, 0x80, 0x80},
+	};
+	struct sc_reg_access ihf_off[] = {
+		{0x257, 0x00, 0x0C},
+		{0x251, 0x00, 0x03},
+	};
+	struct sc_reg_access vib1_off[] = {
+		{0x264, 0x00, 0x82},
+	};
+	struct sc_reg_access vib2_off[] = {
+		{0x26A, 0x00, 0x82},
+	};
 
-	pr_debug("powering dn pb....\n");
-	snd_msic_ops.pb_on = 0;
-	return retval;
+	pr_debug("powering dn pb for device %d\n", device);
+	switch (device) {
+	case SND_SST_DEVICE_HEADSET:
+		snd_msic_ops.pb_on = 0;
+		sst_sc_reg_access(hs_mute, PMIC_READ_MODIFY, 3);
+		drv_enable[0].mask = 0x43;
+		sst_sc_reg_access(drv_enable, PMIC_READ_MODIFY, 1);
+		sst_sc_reg_access(hs_off, PMIC_READ_MODIFY, 2);
+		break;
+
+	case SND_SST_DEVICE_IHF:
+		sst_sc_reg_access(ihf_mute, PMIC_READ_MODIFY, 2);
+		drv_enable[0].mask = 0x0C;
+		sst_sc_reg_access(drv_enable, PMIC_READ_MODIFY, 1);
+		sst_sc_reg_access(ihf_off, PMIC_READ_MODIFY, 2);
+		break;
+
+	case SND_SST_DEVICE_VIBRA:
+		sst_sc_reg_access(vib1_off, PMIC_READ_MODIFY, 2);
+		drv_enable[0].mask = 0x10;
+		sst_sc_reg_access(drv_enable, PMIC_READ_MODIFY, 1);
+		break;
+
+	case SND_SST_DEVICE_HAPTIC:
+		sst_sc_reg_access(vib2_off, PMIC_READ_MODIFY, 2);
+		drv_enable[0].mask = 0x20;
+		sst_sc_reg_access(drv_enable, PMIC_READ_MODIFY, 1);
+		break;
+	}
+	return 0;
 }
 
-static int msic_power_down_cp(void)
+static int msic_power_down_cp(unsigned int device)
 {
-	int retval = 0;
+	struct sc_reg_access dmic[] = {
+		{0x247, 0x00, 0xA0},
+		{0x245, 0x00, 0x38},
+		{0x246, 0x00, 0x07},
+	};
+	struct sc_reg_access amic[] = {
+		{0x248, 0x00, 0x05},
+		{0x249, 0x00, 0x01},
+		{0x24A, 0x00, 0x01},
+		{0x247, 0x00, 0xA3},
+	};
+	struct sc_reg_access tx_off[] = {
+		{0x24F, 0x00, 0x3C},
+	};
 
 	pr_debug("powering dn cp....\n");
 	snd_msic_ops.cap_on = 0;
-	return retval;
+	sst_sc_reg_access(tx_off, PMIC_READ_MODIFY, 1);
+	if (snd_msic_ops.input_dev_id == DMIC)
+		sst_sc_reg_access(dmic, PMIC_READ_MODIFY, 3);
+	else
+		sst_sc_reg_access(amic, PMIC_READ_MODIFY, 4);
+	return 0;
 }
 
 static int msic_set_selected_output_dev(u8 value)
diff --git a/drivers/staging/intel_sst/intelmid_v0_control.c b/drivers/staging/intel_sst/intelmid_v0_control.c
index 7756f8f..6cf5901 100644
--- a/drivers/staging/intel_sst/intelmid_v0_control.c
+++ b/drivers/staging/intel_sst/intelmid_v0_control.c
@@ -157,7 +157,7 @@ static int fs_power_up_pb(unsigned int port)
 	return fs_enable_audiodac(UNMUTE);
 }
 
-static int fs_power_down_pb(void)
+static int fs_power_down_pb(unsigned int device)
 {
 	struct sc_reg_access sc_access[] = {
 		{POWERCTRL1, 0x00, 0xC6},
@@ -195,7 +195,7 @@ static int fs_power_up_cp(unsigned int port)
 	return sst_sc_reg_access(sc_access, PMIC_READ_MODIFY, 2);
 }
 
-static int fs_power_down_cp(void)
+static int fs_power_down_cp(unsigned int device)
 {
 	struct sc_reg_access sc_access[] = {
 		{POWERCTRL2, 0x00, 0x03},
diff --git a/drivers/staging/intel_sst/intelmid_v1_control.c b/drivers/staging/intel_sst/intelmid_v1_control.c
index 1ea8142..445e0fb 100644
--- a/drivers/staging/intel_sst/intelmid_v1_control.c
+++ b/drivers/staging/intel_sst/intelmid_v1_control.c
@@ -212,7 +212,7 @@ static int mx_power_up_pb(unsigned int port)
 	return mx_enable_audiodac(UNMUTE);
 }
 
-static int mx_power_down_pb(void)
+static int mx_power_down_pb(unsigned int device)
 {
 	struct sc_reg_access sc_access[3];
 	int retval = 0;
@@ -255,7 +255,7 @@ static int mx_power_up_cp(unsigned int port)
 	return sst_sc_reg_access(sc_access, PMIC_READ_MODIFY, 2);
 }
 
-static int mx_power_down_cp(void)
+static int mx_power_down_cp(unsigned int device)
 {
 	struct sc_reg_access sc_access[] = {
 		{ENABLE_OPDEV_CTRL, 0x00, MASK1|MASK0},
diff --git a/drivers/staging/intel_sst/intelmid_v2_control.c b/drivers/staging/intel_sst/intelmid_v2_control.c
index 3c6b3ab..28754a5 100644
--- a/drivers/staging/intel_sst/intelmid_v2_control.c
+++ b/drivers/staging/intel_sst/intelmid_v2_control.c
@@ -316,7 +316,7 @@ static int nc_power_down(void)
 	return nc_enable_audiodac(UNMUTE);
 }
 
-static int nc_power_down_pb(void)
+static int nc_power_down_pb(unsigned int device)
 {
 
 	int retval = 0;
@@ -360,7 +360,7 @@ static int nc_power_down_pb(void)
 
 }
 
-static int nc_power_down_cp(void)
+static int nc_power_down_cp(unsigned int device)
 {
 	struct sc_reg_access sc_access[] = {
 		{POWERCTRL1, 0x00, 0xBE},

