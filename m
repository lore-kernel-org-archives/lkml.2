Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab2AMGZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 01:25:34 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:26491
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752219Ab2AMGZc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 01:25:32 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz9371I542M1432Nzz1202hzz8275dhz2dhc1ahc1bh2a8h668h839h8e2h8e3h944hbe9k)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng-B29396 <B29396@freescale.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>, Liam Girdwood <lrg@ti.com>
CC: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/15] sound/soc/mxs/mxs-saif.c: add missing iounmap
Thread-Topic: [PATCH 1/15] sound/soc/mxs/mxs-saif.c: add missing iounmap
Thread-Index: AQHM0RBZzNF54ZRoAkC1q9fS0gh+y5YJ1Q3Q
Date: Fri, 13 Jan 2012 06:25:26 +0000
Message-ID: <7FE21149F4667147B645348EC605788508FBDB@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1326362117-29371-1-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1326362117-29371-1-git-send-email-Julia.Lawall@lip6.fr>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.242.198]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Julia Lawall
> Sent: Thursday, January 12, 2012 5:55 PM
> To: Liam Girdwood
> Cc: kernel-janitors@vger.kernel.org; Mark Brown; Jaroslav Kysela; Takashi Iwai;
> alsa-devel@alsa-project.org; linux-kernel@vger.kernel.org
> Subject: [PATCH 1/15] sound/soc/mxs/mxs-saif.c: add missing iounmap
> 
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Add missing iounmap in error handling code, in a case where the function already
> preforms iounmap on some other execution path.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression e;
> statement S,S1;
> int ret;
> @@
> e = \(ioremap\|ioremap_nocache\)(...)
> ... when != iounmap(e)
> if (<+...e...+>) S
> ... when any
>     when != iounmap(e)
> *if (...)
>    { ... when != iounmap(e)
>      return ...; }
> ... when any
> iounmap(e);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
>  sound/soc/mxs/mxs-saif.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/sound/soc/mxs/mxs-saif.c b/sound/soc/mxs/mxs-saif.c index
> 049e543..5ee0adb 100644
> --- a/sound/soc/mxs/mxs-saif.c
> +++ b/sound/soc/mxs/mxs-saif.c
> @@ -680,7 +680,7 @@ static int mxs_saif_probe(struct platform_device *pdev)
>  		ret = -ENODEV;
>  		dev_err(&pdev->dev, "failed to get dma resource: %d\n",
>  			ret);
> -		goto failed_ioremap;
> +		goto failed_get_resource;
>  	}
>  	saif->dma_param.chan_num = dmares->start;
> 
> @@ -739,6 +739,7 @@ failed_register:
>  failed_get_irq2:
>  	free_irq(saif->irq, saif);
>  failed_get_irq1:
> +failed_get_resource:
There's already a 'failed_get_resource' there, wouldn't your change break
The original code?

BTW, I guess a better way is that you can submit a patch to change the driver
To use devm_alloc_* and it's friend routines, then we do not need to fix
Such things any more.

Regards
Dong Aisheng
>  	iounmap(saif->base);
>  failed_ioremap:
>  	release_mem_region(iores->start, resource_size(iores));
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


