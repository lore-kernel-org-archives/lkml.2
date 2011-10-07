Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759182Ab1JGHyh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 03:54:37 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60656 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab1JGHyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 03:54:36 -0400
Subject: [PATCH] ASoC: wm_hubs: Remove unneeded count variable in
 wait_for_dc_servo
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Oct 2011 15:54:25 +0800
Message-ID: <1317974065.16830.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The count variable is not required, decrement timeout in the while loop
can achieve the same effect.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm_hubs.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/wm_hubs.c b/sound/soc/codecs/wm_hubs.c
index 84f33d4..6e2e122 100644
--- a/sound/soc/codecs/wm_hubs.c
+++ b/sound/soc/codecs/wm_hubs.c
@@ -66,7 +66,6 @@ static void wait_for_dc_servo(struct snd_soc_codec *codec, unsigned int op)
 {
 	struct wm_hubs_data *hubs = snd_soc_codec_get_drvdata(codec);
 	unsigned int reg;
-	int count = 0;
 	int timeout;
 	unsigned int val;
 
@@ -83,7 +82,7 @@ static void wait_for_dc_servo(struct snd_soc_codec *codec, unsigned int op)
 		timeout = 400;
 
 	do {
-		count++;
+		timeout--;
 
 		if (hubs->dcs_done_irq)
 			wait_for_completion_timeout(&hubs->dcs_done,
@@ -93,9 +92,9 @@ static void wait_for_dc_servo(struct snd_soc_codec *codec, unsigned int op)
 
 		reg = snd_soc_read(codec, WM8993_DC_SERVO_0);
 		dev_dbg(codec->dev, "DC servo: %x\n", reg);
-	} while (reg & op && count < timeout);
+	} while ((reg & op) && timeout);
 
-	if (reg & op)
+	if (timeout == 0)
 		dev_err(codec->dev, "Timed out waiting for DC Servo %x\n",
 			op);
 }
-- 
1.7.4.1



