Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751183Ab2KDFUX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 01:20:23 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50661 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab2KDFUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 01:20:22 -0400
From: Daniel J Blueman <daniel@quora.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Jaroslav Kysela <perex@perex.cz>, linux-kernel@vger.kernel.org,
        Daniel J Blueman <daniel@quora.org>
Subject: [PATCH 1/2] HDA: Fix digital microphone on CS420x
Date: Sun,  4 Nov 2012 13:19:03 +0800
Message-Id: <1352006344-3378-1-git-send-email-daniel@quora.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correctly enable the digital microphones with the right bits in the right coeffecient
registers on Cirrus CS4206/7 codecs. It also prevents misconfiguring ADC1/2.

This fixes the digital mic on the Macbook Pro 10,1/Retina.

Based-on-patch-by: Alexander Stein <alexander.stein@systec-electronic.com>
Signed-off-by: Daniel J Blueman <daniel@quora.org>
---
 sound/pci/hda/patch_cirrus.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/sound/pci/hda/patch_cirrus.c b/sound/pci/hda/patch_cirrus.c
index 61a7113..859a119 100644
--- a/sound/pci/hda/patch_cirrus.c
+++ b/sound/pci/hda/patch_cirrus.c
@@ -101,8 +101,8 @@ enum {
 #define CS420X_VENDOR_NID	0x11
 #define CS_DIG_OUT1_PIN_NID	0x10
 #define CS_DIG_OUT2_PIN_NID	0x15
-#define CS_DMIC1_PIN_NID	0x12
-#define CS_DMIC2_PIN_NID	0x0e
+#define CS_DMIC1_PIN_NID	0x0e
+#define CS_DMIC2_PIN_NID	0x12
 
 /* coef indices */
 #define IDX_SPDIF_STAT		0x0000
@@ -1079,14 +1079,18 @@ static void init_input(struct hda_codec *codec)
 			cs_automic(codec, NULL);
 
 		coef = 0x000a; /* ADC1/2 - Digital and Analog Soft Ramp */
+		cs_vendor_coef_set(codec, IDX_ADC_CFG, coef);
+
+		coef = cs_vendor_coef_get(codec, IDX_BEEP_CFG);
 		if (is_active_pin(codec, CS_DMIC2_PIN_NID))
-			coef |= 0x0500; /* DMIC2 2 chan on, GPIO1 off */
+			coef |= 1 << 4; /* DMIC2 2 chan on, GPIO1 off */
 		if (is_active_pin(codec, CS_DMIC1_PIN_NID))
-			coef |= 0x1800; /* DMIC1 2 chan on, GPIO0 off
+			coef |= 1 << 3; /* DMIC1 2 chan on, GPIO0 off
 					 * No effect if SPDIF_OUT2 is
 					 * selected in IDX_SPDIF_CTL.
 					*/
-		cs_vendor_coef_set(codec, IDX_ADC_CFG, coef);
+
+		cs_vendor_coef_set(codec, IDX_BEEP_CFG, coef);
 	} else {
 		if (spec->mic_detect)
 			cs_automic(codec, NULL);
-- 
1.7.10.4

