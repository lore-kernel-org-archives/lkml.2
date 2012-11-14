Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359Ab2KNGBB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:01:01 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55139 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751723Ab2KNFuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:50:40 -0500
Message-Id: <20121114053941.459089122@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:40:28 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel J Blueman <daniel@quora.org>, Takashi Iwai <tiwai@suse.de>
Subject: [ 55/82] ALSA: HDA: Fix digital microphone on CS420x
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/patch_cirrus.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/sound/pci/hda/patch_cirrus.c
+++ b/sound/pci/hda/patch_cirrus.c
@@ -93,8 +93,8 @@ enum {
 #define CS420X_VENDOR_NID	0x11
 #define CS_DIG_OUT1_PIN_NID	0x10
 #define CS_DIG_OUT2_PIN_NID	0x15
-#define CS_DMIC1_PIN_NID	0x12
-#define CS_DMIC2_PIN_NID	0x0e
+#define CS_DMIC1_PIN_NID	0x0e
+#define CS_DMIC2_PIN_NID	0x12
 
 /* coef indices */
 #define IDX_SPDIF_STAT		0x0000
@@ -1088,14 +1088,18 @@ static void init_input(struct hda_codec
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
 	}
 }
 


