Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437Ab1ECRxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 13:53:52 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36881 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313Ab1ECRxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 13:53:00 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 14/23] sst: return correct output/input device id
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 03 May 2011 17:34:40 +0100
Message-ID: <20110503163438.24853.11533.stgit@bob.linux.org.uk>
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

Without this patch, the change of output/input device can't be reflected
correctly. The mismatch reflects insane design, and should be fixed when
switching to the ASoC framework.

Signed-off-by: Lu Guanqun <guanqun.lu@intel.com>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/intel_sst/intelmid_ctrl.c |   21 ++++++++++++++++++++-
 1 files changed, 20 insertions(+), 1 deletions(-)


diff --git a/drivers/staging/intel_sst/intelmid_ctrl.c b/drivers/staging/intel_sst/intelmid_ctrl.c
index 2c3ee94..af9e112 100644
--- a/drivers/staging/intel_sst/intelmid_ctrl.c
+++ b/drivers/staging/intel_sst/intelmid_ctrl.c
@@ -504,8 +504,8 @@ static int snd_intelmad_device_get(struct snd_kcontrol *kcontrol,
 	WARN_ON(!kcontrol);
 
 	intelmaddata = kcontrol->private_data;
+	scard_ops = intelmaddata->sstdrv_ops->scard_ops;
 	if (intelmaddata->cpu_id == CPU_CHIP_PENWELL) {
-		scard_ops = intelmaddata->sstdrv_ops->scard_ops;
 		if (kcontrol->id.numid == OUTPUT_SEL)
 			uval->value.enumerated.item[0] =
 					scard_ops->output_dev_id;
@@ -517,6 +517,25 @@ static int snd_intelmad_device_get(struct snd_kcontrol *kcontrol,
 					scard_ops->lineout_dev_id;
 		else
 			return -EINVAL;
+	} else if (intelmaddata->cpu_id == CPU_CHIP_LINCROFT) {
+		if (kcontrol->id.numid == OUTPUT_SEL)
+			/* There is a mismatch here.
+			 * ALSA expects 1 for internal speaker.
+			 * But internally, we may give 2 for internal speaker.
+			 */
+			if (scard_ops->output_dev_id == MONO_EARPIECE ||
+			    scard_ops->output_dev_id == INTERNAL_SPKR)
+				uval->value.enumerated.item[0] = MONO_EARPIECE;
+			else if (scard_ops->output_dev_id == STEREO_HEADPHONE)
+				uval->value.enumerated.item[0] =
+					STEREO_HEADPHONE;
+			else
+				return -EINVAL;
+		else if (kcontrol->id.numid == INPUT_SEL)
+			uval->value.enumerated.item[0] =
+					scard_ops->input_dev_id;
+		else
+			return -EINVAL;
 	} else
 	uval->value.enumerated.item[0] = kcontrol->private_value;
 	return 0;

