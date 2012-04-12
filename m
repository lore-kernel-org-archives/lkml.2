Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965915Ab2DLTyi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 15:54:38 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:11506 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784Ab2DLTyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 15:54:36 -0400
Date: Thu, 12 Apr 2012 21:54:34 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: alsa-devel@alsa-project.org, Vinod Koul <vinod.koul@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Brian Austin <brian.austin@cirrus.com>, Axel Lin <axel.lin@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, joe@nucleusys.com,
        brian.austin@cirrus.com
Subject: [PATCH] ASoC: cs42l73: don't use negative array index
Message-ID: <alpine.LNX.2.00.1204122152340.7553@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If cs42l73_get_mclkx_coeff() returns < 0 (which it can) in
sound/soc/codecs/cs42l73.c::cs42l73_set_mclk(), then we'll be using
the (negative) return value as array index on the very next line of
code - that's bad.

Catch the negative return value and propagate it to the caller (which
checks for it) and things are a bit more sane :-)

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 sound/soc/codecs/cs42l73.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/codecs/cs42l73.c b/sound/soc/codecs/cs42l73.c
index 78979b3..07c44b7 100644
--- a/sound/soc/codecs/cs42l73.c
+++ b/sound/soc/codecs/cs42l73.c
@@ -929,6 +929,8 @@ static int cs42l73_set_mclk(struct snd_soc_dai *dai, unsigned int freq)
 
 	/* MCLKX -> MCLK */
 	mclkx_coeff = cs42l73_get_mclkx_coeff(freq);
+	if (mclkx_coeff < 0)
+		return mclkx_coeff;
 
 	mclk = cs42l73_mclkx_coeffs[mclkx_coeff].mclkx /
 		cs42l73_mclkx_coeffs[mclkx_coeff].ratio;
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

