Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab1I1XPO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:15:14 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38274 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610Ab1I1XPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 19:15:10 -0400
Message-ID: <4E83AA77.9040700@gmail.com>
Date: Thu, 29 Sep 2011 09:15:03 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Lightning/1.0b2 Thunderbird/3.1.13
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org, Peter Hsiang <peter.hsiang@maxim-ic.com>,
        Jesse Marroquin <jesse.marroquin@maxim-ic.com>
Subject: Re: [PATCH 1/2] ASoC: Add BUG() assertion if max98088_get_channel
 returns -EINVAL
References: <1317218471.8008.3.camel@phoenix>
In-Reply-To: <1317218471.8008.3.camel@phoenix>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/09/11 00:01, Axel Lin wrote:
> The callers use the return value of max98088_get_channel as array index to
> access max98088->dai[] array.
> Add BUG() assertion for out of bound access of max98088->dai[] array.

BUG() is pretty heavy handed for a driver. Why not fix the problem
properly in the callers?

----
Check the return value of max98088_get_channel in the callers and
propagate any errors up.

Signed-off-by: Ryan Mallon <rmallon@gmail.com>
---

diff --git a/sound/soc/codecs/max98088.c b/sound/soc/codecs/max98088.c
index ac65a2d..e07700e 100644
--- a/sound/soc/codecs/max98088.c
+++ b/sound/soc/codecs/max98088.c
@@ -1811,6 +1811,9 @@ static int max98088_put_eq_enum(struct snd_kcontrol *kcontrol,
        struct max98088_cdata *cdata;
        int sel = ucontrol->value.integer.value[0];
 
+       if (channel < 0)
+	       return channel;
+
        cdata = &max98088->dai[channel];
 
        if (sel >= pdata->eq_cfgcnt)
@@ -1838,6 +1841,9 @@ static int max98088_get_eq_enum(struct snd_kcontrol *kcontrol,
        int channel = max98088_get_channel(kcontrol->id.name);
        struct max98088_cdata *cdata;
 
+       if (channel < 0)
+	       return channel;
+
        cdata = &max98088->dai[channel];
        ucontrol->value.enumerated.item[0] = cdata->eq_sel;
        return 0;


