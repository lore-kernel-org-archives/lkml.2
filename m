Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751252Ab1KEGt2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 02:49:28 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61733 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab1KEGt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 02:49:27 -0400
Message-ID: <1320475761.8360.3.camel@phoenix>
Subject: [PATCH 2/2] ASoC: wm9081: Don't write WM9081_BIAS_ENA bit to
 WM9081_VMID_CONTROL register
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Date: Sat, 05 Nov 2011 14:49:21 +0800
In-Reply-To: <1320475639.8360.1.camel@phoenix>
References: <1320475639.8360.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WM9081_BIAS_ENA is the bit[1] of WM9081_BIAS_CONTROL_1 register (05h).
Current code incorrectly write it to WM9081_VMID_CONTROL(04h) register.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm9081.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/wm9081.c b/sound/soc/codecs/wm9081.c
index fe65618..4a398c3 100644
--- a/sound/soc/codecs/wm9081.c
+++ b/sound/soc/codecs/wm9081.c
@@ -807,7 +807,6 @@ static int wm9081_set_bias_level(struct snd_soc_codec *codec,
 			mdelay(100);
 
 			/* Normal bias enable & soft start off */
-			reg |= WM9081_BIAS_ENA;
 			reg &= ~WM9081_VMID_RAMP;
 			snd_soc_write(codec, WM9081_VMID_CONTROL, reg);
 
@@ -830,14 +829,15 @@ static int wm9081_set_bias_level(struct snd_soc_codec *codec,
 		break;
 
 	case SND_SOC_BIAS_OFF:
-		/* Startup bias source */
+		/* Startup bias source and disable bias */
 		reg = snd_soc_read(codec, WM9081_BIAS_CONTROL_1);
 		reg |= WM9081_BIAS_SRC;
+		reg &= ~WM9081_BIAS_ENA;
 		snd_soc_write(codec, WM9081_BIAS_CONTROL_1, reg);
 
-		/* Disable VMID and biases with soft ramping */
+		/* Disable VMID with soft ramping */
 		reg = snd_soc_read(codec, WM9081_VMID_CONTROL);
-		reg &= ~(WM9081_VMID_SEL_MASK | WM9081_BIAS_ENA);
+		reg &= ~WM9081_VMID_SEL_MASK;
 		reg |= WM9081_VMID_RAMP;
 		snd_soc_write(codec, WM9081_VMID_CONTROL, reg);
 
-- 
1.7.5.4



