Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934558Ab1KJDZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:25:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42154 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934015Ab1KJDZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:25:24 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:11 2011
Message-Id: <20111109212711.185660254@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:27:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [105/262] ASoC: Remove direct register cache accesses from WM8962 driver
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 38f3f31a0a797bdbcc0cdb12553bbecc2f9a91c4 upstream.

Also fix return values for speaker switch updates.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm8962.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -2018,7 +2018,6 @@ static int wm8962_put_spk_sw(struct snd_
 			    struct snd_ctl_elem_value *ucontrol)
 {
 	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
-	u16 *reg_cache = codec->reg_cache;
 	int ret;
 
 	/* Apply the update (if any) */
@@ -2027,16 +2026,19 @@ static int wm8962_put_spk_sw(struct snd_
 		return 0;
 
 	/* If the left PGA is enabled hit that VU bit... */
-	if (reg_cache[WM8962_PWR_MGMT_2] & WM8962_SPKOUTL_PGA_ENA)
-		return snd_soc_write(codec, WM8962_SPKOUTL_VOLUME,
-				     reg_cache[WM8962_SPKOUTL_VOLUME]);
+	ret = snd_soc_read(codec, WM8962_PWR_MGMT_2);
+	if (ret & WM8962_SPKOUTL_PGA_ENA) {
+		snd_soc_write(codec, WM8962_SPKOUTL_VOLUME,
+			      snd_soc_read(codec, WM8962_SPKOUTL_VOLUME));
+		return 1;
+	}
 
 	/* ...otherwise the right.  The VU is stereo. */
-	if (reg_cache[WM8962_PWR_MGMT_2] & WM8962_SPKOUTR_PGA_ENA)
-		return snd_soc_write(codec, WM8962_SPKOUTR_VOLUME,
-				     reg_cache[WM8962_SPKOUTR_VOLUME]);
+	if (ret & WM8962_SPKOUTR_PGA_ENA)
+		snd_soc_write(codec, WM8962_SPKOUTR_VOLUME,
+			      snd_soc_read(codec, WM8962_SPKOUTR_VOLUME));
 
-	return 0;
+	return 1;
 }
 
 static const char *cap_hpf_mode_text[] = {
@@ -2336,7 +2338,6 @@ static int out_pga_event(struct snd_soc_
 			 struct snd_kcontrol *kcontrol, int event)
 {
 	struct snd_soc_codec *codec = w->codec;
-	u16 *reg_cache = codec->reg_cache;
 	int reg;
 
 	switch (w->shift) {
@@ -2359,7 +2360,7 @@ static int out_pga_event(struct snd_soc_
 
 	switch (event) {
 	case SND_SOC_DAPM_POST_PMU:
-		return snd_soc_write(codec, reg, reg_cache[reg]);
+		return snd_soc_write(codec, reg, snd_soc_read(codec, reg));
 	default:
 		BUG();
 		return -EINVAL;


