Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933272Ab1BPBF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:05:27 -0500
Received: from kroah.org ([198.145.64.141]:45871 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933188Ab1BPAuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:50:08 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:09 2011
Message-Id: <20110216002109.776207006@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:21:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [patch 107/176] ASoC: Handle low measured DC offsets for wm_hubs devices
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 20a4e7fc7e213365ea3771d7bf1e10a6bab853be upstream.

The DC servo codes are actually signed numbers so need to be treated as
such.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm_hubs.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/sound/soc/codecs/wm_hubs.c
+++ b/sound/soc/codecs/wm_hubs.c
@@ -92,6 +92,7 @@ static void wait_for_dc_servo(struct snd
 static void calibrate_dc_servo(struct snd_soc_codec *codec)
 {
 	struct wm_hubs_data *hubs = snd_soc_codec_get_drvdata(codec);
+	s8 offset;
 	u16 reg, reg_l, reg_r, dcs_cfg;
 
 	/* Set for 32 series updates */
@@ -130,16 +131,14 @@ static void calibrate_dc_servo(struct sn
 		dev_dbg(codec->dev, "DCS input: %x %x\n", reg_l, reg_r);
 
 		/* HPOUT1L */
-		if (reg_l + hubs->dcs_codes > 0 &&
-		    reg_l + hubs->dcs_codes < 0xff)
-			reg_l += hubs->dcs_codes;
-		dcs_cfg = reg_l << WM8993_DCS_DAC_WR_VAL_1_SHIFT;
+		offset = reg_l;
+		offset += hubs->dcs_codes;
+		dcs_cfg = (u8)offset << WM8993_DCS_DAC_WR_VAL_1_SHIFT;
 
 		/* HPOUT1R */
-		if (reg_r + hubs->dcs_codes > 0 &&
-		    reg_r + hubs->dcs_codes < 0xff)
-			reg_r += hubs->dcs_codes;
-		dcs_cfg |= reg_r;
+		offset = reg_r;
+		offset += hubs->dcs_codes;
+		dcs_cfg |= (u8)offset;
 
 		dev_dbg(codec->dev, "DCS result: %x\n", dcs_cfg);
 


