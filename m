Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621Ab1JDMHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 08:07:15 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34277 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227Ab1JDMHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 08:07:13 -0400
Subject: [PATCH 1/2] ASoC: wm8994: Slightly optimize configure_clock
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Oct 2011 20:07:03 +0800
Message-ID: <1317730023.17783.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

snd_soc_update_bits() will only write new register value
if the old value is different from the new value.
In additional, snd_soc_update_bits() returns 0 for no change.
No need to read WM8994_CLOCKING_1 register before calling snd_soc_update_bits().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8994.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index e537267..4225e1f 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -208,7 +208,7 @@ static int configure_aif_clock(struct snd_soc_codec *codec, int aif)
 static int configure_clock(struct snd_soc_codec *codec)
 {
 	struct wm8994_priv *wm8994 = snd_soc_codec_get_drvdata(codec);
-	int old, new;
+	int change, new;
 
 	/* Bring up the AIF clocks first */
 	configure_aif_clock(codec, 0);
@@ -229,14 +229,11 @@ static int configure_clock(struct snd_soc_codec *codec)
 	else
 		new = 0;
 
-	old = snd_soc_read(codec, WM8994_CLOCKING_1) & WM8994_SYSCLK_SRC;
-
-	/* If there's no change then we're done. */
-	if (old == new)
+	change = snd_soc_update_bits(codec, WM8994_CLOCKING_1,
+				     WM8994_SYSCLK_SRC, new);
+	if (!change)
 		return 0;
 
-	snd_soc_update_bits(codec, WM8994_CLOCKING_1, WM8994_SYSCLK_SRC, new);
-
 	snd_soc_dapm_sync(&codec->dapm);
 
 	return 0;
-- 
1.7.4.1



