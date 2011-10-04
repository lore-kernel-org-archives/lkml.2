Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab1JDMIM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 08:08:12 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52152 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166Ab1JDMIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 08:08:11 -0400
Subject: [PATCH 2/2] ASoC: wm8995: Slightly optimize configure_clock
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
In-Reply-To: <1317730023.17783.2.camel@phoenix>
References: <1317730023.17783.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Oct 2011 20:08:04 +0800
Message-ID: <1317730084.17783.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

snd_soc_update_bits() will only write new register value
if the old value is different from the new value.
In additional, snd_soc_update_bits() returns 0 for no change.
No need to read WM8995_CLOCKING_1 register before calling snd_soc_update_bits().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8995.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/sound/soc/codecs/wm8995.c b/sound/soc/codecs/wm8995.c
index e05ee79..78eeb21 100644
--- a/sound/soc/codecs/wm8995.c
+++ b/sound/soc/codecs/wm8995.c
@@ -485,7 +485,7 @@ static int configure_aif_clock(struct snd_soc_codec *codec, int aif)
 static int configure_clock(struct snd_soc_codec *codec)
 {
 	struct wm8995_priv *wm8995;
-	int old, new;
+	int change, new;
 
 	wm8995 = snd_soc_codec_get_drvdata(codec);
 
@@ -509,15 +509,11 @@ static int configure_clock(struct snd_soc_codec *codec)
 	else
 		new = 0;
 
-	old = snd_soc_read(codec, WM8995_CLOCKING_1) & WM8995_SYSCLK_SRC;
-
-	/* If there's no change then we're done. */
-	if (old == new)
+	change = snd_soc_update_bits(codec, WM8995_CLOCKING_1,
+				     WM8995_SYSCLK_SRC_MASK, new);
+	if (!change)
 		return 0;
 
-	snd_soc_update_bits(codec, WM8995_CLOCKING_1,
-			    WM8995_SYSCLK_SRC_MASK, new);
-
 	snd_soc_dapm_sync(&codec->dapm);
 
 	return 0;
-- 
1.7.4.1



