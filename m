Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761027Ab2EJRrQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:47:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52483 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760389Ab2EJReQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:34:16 -0400
Message-Id: <20120510173133.756170065@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 10 May 2012 10:31:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 09/52] ASoC: tlv312aic23: unbreak resume
In-Reply-To: <20120510173229.GA5678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Bénard <eric@eukrea.com>

commit e875c1e3e758447ba81ca450d89434b3b0496d37 upstream.

* commit f9dfbf9 "ASoC: tlv320aic23: convert to soc-cache" leads to
a bug preventing resumeof the codec as regmap expects a 9 bits data
register but 0xFFFF is passed in tlv320aic23_set_bias_level and this
values gets cached preventing any write to the TLV320AIC23_PWR
register as the final value produced by regmap is (register << 9) | value

* this patch solves the problem by only working on the 9 bits the
register contains.

Signed-off-by: Eric Bénard <eric@eukrea.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/tlv320aic23.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/codecs/tlv320aic23.c
+++ b/sound/soc/codecs/tlv320aic23.c
@@ -472,7 +472,7 @@ static int tlv320aic23_set_dai_sysclk(st
 static int tlv320aic23_set_bias_level(struct snd_soc_codec *codec,
 				      enum snd_soc_bias_level level)
 {
-	u16 reg = snd_soc_read(codec, TLV320AIC23_PWR) & 0xff7f;
+	u16 reg = snd_soc_read(codec, TLV320AIC23_PWR) & 0x17f;
 
 	switch (level) {
 	case SND_SOC_BIAS_ON:
@@ -491,7 +491,7 @@ static int tlv320aic23_set_bias_level(st
 	case SND_SOC_BIAS_OFF:
 		/* everything off, dac mute, inactive */
 		snd_soc_write(codec, TLV320AIC23_ACTIVE, 0x0);
-		snd_soc_write(codec, TLV320AIC23_PWR, 0xffff);
+		snd_soc_write(codec, TLV320AIC23_PWR, 0x1ff);
 		break;
 	}
 	codec->dapm.bias_level = level;


