Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab1CHMlI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 07:41:08 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36590 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab1CHMlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 07:41:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=c5B5M4Hwl38DNx2EV6lnXbUHy3uGD6tFzsGemNMaHYSsRvZsf8LTjnPPkEdp0OYc9C
         uUww8iwue1IFW+KlYQv1JGdkOw/8QHhCm2Dp4xpVyIhq1E0jjblfIb9kp1ARJEvLyh77
         1MDCj2PNvNWwjZ8U9kWE44vc0aH7WpsiJaaWY=
MIME-Version: 1.0
Date: Tue, 8 Mar 2011 15:41:04 +0300
Message-ID: <AANLkTi=Abkovmq5nNGTgas2tu516y0pdrYZHov3m0onw@mail.gmail.com>
Subject: Sound on developer board Mini2440
From: Ilya Averyanov <esta1ien@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the new kernels for some reason the sound does not work in dev kit
[www.friendlyarm.net]

Tried to understand, but something does not work.

static struct platform_driver s3c24xx_uda134x_driver = {
	.probe  = s3c24xx_uda134x_probe,
	.remove = s3c24xx_uda134x_remove,
	.driver = {
		.name = "s3c24xx_uda134x",
		.owner = THIS_MODULE,
	},
};

static int __init s3c24xx_uda134x_init(void)
{
	return platform_driver_register(&s3c24xx_uda134x_driver);
}

Here everything is ok. s3c24xx_uda134x_probe called. Comes to
snd_soc_instantiate_card (which in linux-2.6 \ sound \ sos \
soc-core.c)
But it comes up here

for (i = 0; i < card->num_links; i++)
		soc_bind_dai_link(card, i);

//soc_bind_dai_link
....
find_platform:
	/* do we already have the CODEC DAI for this link ? */
	if (rtd->platform) {
		goto out;
	}
	/* no, then find CPU DAI from registered DAIs*/
	list_for_each_entry(platform, &platform_list, list) {
		if (!strcmp(platform->name, dai_link->platform_name)) {
			rtd->platform = platform;
			goto out;
		}
	}
...

And here's the problem. platform_list empty. began to look like
filled, found the file linux-2.6 \ sound \ soc \ samsung \ dma.c there

.....
static int __devinit samsung_asoc_platform_probe (struct platform_device * pdev)
{
/ / This function is no longer executes.
	return snd_soc_register_platform(&pdev->dev, &samsung_asoc_platform);
}

static int __devexit samsung_asoc_platform_remove(struct platform_device *pdev)
{
	snd_soc_unregister_platform(&pdev->dev);
	return 0;
}

static struct platform_driver asoc_dma_driver = {
	.driver = {
		.name = "samsung-audio",
		.owner = THIS_MODULE,
	},

	.probe = samsung_asoc_platform_probe,
	.remove = __devexit_p(samsung_asoc_platform_remove),
};

static int __init samsung_asoc_init(void)
{
//But this is performed
	return platform_driver_register(&asoc_dma_driver);
}
module_init(samsung_asoc_init);
....

Where to look the problem?
