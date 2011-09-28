Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab1I1XTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:19:18 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56132 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932Ab1I1XTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 19:19:12 -0400
Message-ID: <4E83AB6A.1090203@gmail.com>
Date: Thu, 29 Sep 2011 09:19:06 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Lightning/1.0b2 Thunderbird/3.1.13
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org, Peter Hsiang <peter.hsiang@maxim-ic.com>,
        Jesse Marroquin <jesse.marroquin@maxim-ic.com>
Subject: Re: [PATCH 2/2] ASoC: Add BUG() assertion if max98095_get_bq_channel
 returns -EINVAL
References: <1317218471.8008.3.camel@phoenix> <1317218530.8008.4.camel@phoenix>
In-Reply-To: <1317218530.8008.4.camel@phoenix>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/09/11 00:02, Axel Lin wrote:
> The callers use the return value of max98095_get_bq_channel as array index to
> access max98095->dai[] array.
> Add BUG() assertion for out of bound access of max98095->dai[] array.

Same here, fix the problem in the callers.

----
Check the return value of max98095_get_bq_channel in the callers and
propagate any errors up. Remove the BUG_ON(channel > 1) since
max98095_get_bq_channel never returns a value larger than 1.

Signed-off-by: Ryan Mallon <rmallon@gmail.com>
---

diff --git a/sound/soc/codecs/max98095.c b/sound/soc/codecs/max98095.c
index 668434d..55eccea 100644
--- a/sound/soc/codecs/max98095.c
+++ b/sound/soc/codecs/max98095.c
@@ -2014,7 +2014,8 @@ static int max98095_put_bq_enum(struct snd_kcontrol *kcontrol,
 	int fs, best, best_val, i;
 	int regmask, regsave;
 
-	BUG_ON(channel > 1);
+	if (channel < 0)
+		return channel;
 
 	if (!pdata || !max98095->bq_textcnt)
 		return 0;
@@ -2069,6 +2070,9 @@ static int max98095_get_bq_enum(struct snd_kcontrol *kcontrol,
 	int channel = max98095_get_bq_channel(kcontrol->id.name);
 	struct max98095_cdata *cdata;
 
+	if (channel < 0)
+		return channel;
+
 	cdata = &max98095->dai[channel];
 	ucontrol->value.enumerated.item[0] = cdata->bq_sel;
 

