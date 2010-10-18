Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140Ab0JROLG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:11:06 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42479 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104Ab0JROLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:11:04 -0400
Subject: Re: [PATCH 1/2] sound/soc/davinci/davinci-mcasp.c: Return error
 code in failure
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Julia Lawall <julia@diku.dk>
Cc: kernel-janitors@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
In-Reply-To: <1287411074-19825-1-git-send-email-julia@diku.dk>
References: <1287411074-19825-1-git-send-email-julia@diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Oct 2010 15:11:01 +0100
Message-ID: <1287411061.3303.211.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-18 at 16:11 +0200, Julia Lawall wrote:
> In this code, 0 is returned on failure, even though other
> failures return -ENOMEM or other similar values.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @a@
> identifier alloc;
> identifier ret;
> constant C;
> expression x;
> @@
> 
> x = alloc(...);
> if (x == NULL) { <+... \(ret = -C; \| return -C; \) ...+> }
> 
> @@
> identifier f, a.alloc;
> expression ret;
> expression x,e1,e2,e3;
> @@
> 
> ret = 0
> ... when != ret = e1
> *x = alloc(...)
> ... when != ret = e2
> if (x == NULL) { ... when != ret = e3
>   return ret;
> }
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
> Another call to platform_get_resource in the same function returns -ENODEV
> on error, so I have used that value.
> 
>  sound/soc/davinci/davinci-mcasp.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/sound/soc/davinci/davinci-mcasp.c b/sound/soc/davinci/davinci-mcasp.c
> index c8e97dc..86918ee 100644
> --- a/sound/soc/davinci/davinci-mcasp.c
> +++ b/sound/soc/davinci/davinci-mcasp.c
> @@ -898,6 +898,7 @@ static int davinci_mcasp_probe(struct platform_device *pdev)
>  	res = platform_get_resource(pdev, IORESOURCE_DMA, 0);
>  	if (!res) {
>  		dev_err(&pdev->dev, "no DMA resource\n");
> +		ret = -ENODEV;
>  		goto err_release_region;
>  	}
>  
> @@ -912,6 +913,7 @@ static int davinci_mcasp_probe(struct platform_device *pdev)
>  	res = platform_get_resource(pdev, IORESOURCE_DMA, 1);
>  	if (!res) {
>  		dev_err(&pdev->dev, "no DMA resource\n");
> +		ret = -ENODEV;
>  		goto err_release_region;
>  	}
>  
> 
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

