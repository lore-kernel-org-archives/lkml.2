Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423Ab1ALATi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 19:19:38 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63988 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756392Ab1ALATg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 19:19:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=UvSvyXMjkaN+pibWdpibXbhjHg9S7WZqglsJevmIeVOU2b1r3Z+ZZDRw9rFAx2bf0v
         Y4cmkgHmZuA7MG1dLXzl4pdgyums8g7TU2V7xg56pXSKh3a6ZpvV5Zt0Uwa/vdda/irJ
         q3AouYaChbYCXzJQ2Blai/J1rnFWnFj3dHp0Q=
MIME-Version: 1.0
In-Reply-To: <1291726590.2760.3.camel@phoenix>
References: <1291726590.2760.3.camel@phoenix>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 11 Jan 2011 19:19:14 -0500
Message-ID: <AANLkTimkb4ic3G7rT-WiFtFdC+Sy5gVAikoQVXguVH4J@mail.gmail.com>
Subject: Re: [PATCH] ASoC: Fix resource leak if soc_register_ac97_dai_link failed
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p0C0JiT5022859

On Tue, Dec 7, 2010 at 07:56, Axel Lin wrote:
> --- a/sound/soc/soc-core.c
> +++ b/sound/soc/soc-core.c
> @@ -1619,12 +1619,14 @@ static void snd_soc_instantiate_card(struct snd_soc_card *card)
> Â #ifdef CONFIG_SND_SOC_AC97_BUS
> Â  Â  Â  Â /* register any AC97 codecs */
> Â  Â  Â  Â for (i = 0; i < card->num_rtd; i++) {
> - Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  ret = soc_register_ac97_dai_link(&card->rtd[i]);
> - Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  if (ret < 0) {
> - Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  printk(KERN_ERR "asoc: failed to register AC97 %s\n", card->name);
> - Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  goto probe_dai_err;
> - Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  }
> + Â  Â  Â  Â  Â  Â  Â  ret = soc_register_ac97_dai_link(&card->rtd[i]);
> + Â  Â  Â  Â  Â  Â  Â  if (ret < 0) {
> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  printk(KERN_ERR "asoc: failed to register AC97 %s\n", card->name);
> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  while (--i >= 0)
> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  soc_unregister_ac97_dai_link(&card->rtd[i]);
> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  goto probe_dai_err;
> Â  Â  Â  Â  Â  Â  Â  Â }
> + Â  Â  Â  }
> Â #endif

this isnt entirely correct.  soc_unregister_ac97_dai_link takes a
pointer to a codec which card->rtd[i] is not.
sound/soc/soc-core.c: In function â€˜snd_soc_instantiate_cardâ€™:
sound/soc/soc-core.c:1626: warning: passing argument 1 of
â€˜soc_unregister_ac97_dai_linkâ€™ from incompatible pointer type
-mike
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
