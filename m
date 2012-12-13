Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab2LMPAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:00:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44199 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756162Ab2LMOD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:03:56 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel J Blueman <daniel@quora.org>, Takashi Iwai <tiwai@suse.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 052/241] ALSA: HDA: Fix digital microphone on CS420x
Date: Thu, 13 Dec 2012 11:56:57 -0200
Message-Id: <1355407206-17100-53-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel J Blueman <daniel@quora.org>

commit 16337e028a6dae9fbdd718c0d42161540a668ff3 upstream.

Correctly enable the digital microphones with the right bits in the
right coeffecient registers on Cirrus CS4206/7 codecs. It also
prevents misconfiguring ADC1/2.

This fixes the digital mic on the Macbook Pro 10,1/Retina.

Based-on-patch-by: Alexander Stein <alexander.stein@systec-electronic.com>
Signed-off-by: Daniel J Blueman <daniel@quora.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ herton: unfuzz patch ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 sound/pci/hda/patch_cirrus.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/sound/pci/hda/patch_cirrus.c b/sound/pci/hda/patch_cirrus.c
index d31497f..f61c6c3 100644
--- a/sound/pci/hda/patch_cirrus.c
+++ b/sound/pci/hda/patch_cirrus.c
@@ -96,8 +96,8 @@ enum {
 #define CS420X_VENDOR_NID	0x11
 #define CS_DIG_OUT1_PIN_NID	0x10
 #define CS_DIG_OUT2_PIN_NID	0x15
-#define CS_DMIC1_PIN_NID	0x12
-#define CS_DMIC2_PIN_NID	0x0e
+#define CS_DMIC1_PIN_NID	0x0e
+#define CS_DMIC2_PIN_NID	0x12
 
 /* coef indices */
 #define IDX_SPDIF_STAT		0x0000
@@ -1074,14 +1074,18 @@ static void init_input(struct hda_codec *codec)
 			cs_automic(codec);
 
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
 			cs_automic(codec);
-- 
1.7.9.5

