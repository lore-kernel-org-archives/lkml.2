Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751313Ab1BNGIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 01:08:41 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:53708 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911Ab1BNGIi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 01:08:38 -0500
From: "Janorkar, Mayuresh" <mayur@ti.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
CC: Thomas Winischhofer <thomas@winischhofer.net>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 14 Feb 2011 11:38:24 +0530
Subject: RE: [PATCH 1/6] sisfb: POST should fail if R/W test fails
Thread-Topic: [PATCH 1/6] sisfb: POST should fail if R/W test fails
Thread-Index: AcvLy+P/WNcsLIMpTfqHh9TgvqlqNgAQUqtQ
Message-ID: <EAF47CD23C76F840A9E7FCE10091EFAB0323A959C3@dbde02.ent.ti.com>
References: <1297635088-13224-1-git-send-email-aaro.koskinen@iki.fi>
 <1297635088-13224-2-git-send-email-aaro.koskinen@iki.fi>
In-Reply-To: <1297635088-13224-2-git-send-email-aaro.koskinen@iki.fi>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-fbdev-owner@vger.kernel.org [mailto:linux-fbdev-
> owner@vger.kernel.org] On Behalf Of Aaro Koskinen
> Sent: Monday, February 14, 2011 3:41 AM
> To: linux-fbdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Cc: Thomas Winischhofer
> Subject: [PATCH 1/6] sisfb: POST should fail if R/W test fails
> 
> Currently there is no indication if R/W test fails during POST. This can
> happen e.g. when user plugs in a card with unsupported type of memory.
> Since the driver will be unusable, it's better to fail the whole POST
> if the memory cannot be configured properly.
> 
> Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> Cc: Thomas Winischhofer <thomas@winischhofer.net>
> ---
>  drivers/video/sis/sis_main.c |   22 +++++++++++++++++-----
>  1 files changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/video/sis/sis_main.c b/drivers/video/sis/sis_main.c
> index 2fb8c5a..2c5de66 100644
> --- a/drivers/video/sis/sis_main.c
> +++ b/drivers/video/sis/sis_main.c
> @@ -4627,11 +4627,11 @@ sisfb_post_xgi_rwtest(struct sis_video_info
> *ivideo, int starta,
>  	return 1;
>  }
> 
> -static void __devinit
> +static int __devinit
>  sisfb_post_xgi_ramsize(struct sis_video_info *ivideo)
>  {
>  	unsigned int buswidth, ranksize, channelab, mapsize;
> -	int i, j, k, l;
> +	int i, j, k, l, status;
>  	u8 reg, sr14;
>  	static const u8 dramsr13[12 * 5] = {
>  		0x02, 0x0e, 0x0b, 0x80, 0x5d,
> @@ -4673,7 +4673,7 @@ sisfb_post_xgi_ramsize(struct sis_video_info
> *ivideo)
>  		SiS_SetReg(SISSR, 0x13, 0x35);
>  		SiS_SetReg(SISSR, 0x14, 0x41);
>  		/* TODO */
> -		return;
> +		return -ENOMEM;
>  	}
> 
>  	/* Non-interleaving */
> @@ -4835,6 +4835,7 @@ bail_out:
> 
>  	j = (ivideo->chip == XGI_20) ? 5 : 9;
>  	k = (ivideo->chip == XGI_20) ? 12 : 4;
> +	status = -EIO;

How about assigning this value during variable declaration?

> 
>  	for(i = 0; i < k; i++) {
> 
> @@ -4868,11 +4869,15 @@ bail_out:
>  		SiS_SetRegANDOR(SISSR, 0x14, 0x0f, (reg & 0xf0));
>  		sisfb_post_xgi_delay(ivideo, 1);
> 
> -		if(sisfb_post_xgi_rwtest(ivideo, j, ((reg >> 4) + channelab -
> 2 + 20), mapsize))
> +		if (sisfb_post_xgi_rwtest(ivideo, j, ((reg >> 4) + channelab -
> 2 + 20), mapsize)) {
> +			status = 0;
>  			break;
> +		}
>  	}
> 
>  	iounmap(ivideo->video_vbase);
> +
> +	return status;
>  }
> 
>  static void __devinit
> @@ -5648,6 +5653,7 @@ sisfb_post_xgi(struct pci_dev *pdev)
>  		SiS_SetReg(SISSR, 0x14, bios[regb + 0xe0 + 8]);
> 
>  	} else {
> +		int err;
> 
>  		/* Set default mode, don't clear screen */
>  		ivideo->SiS_Pr.SiS_UseOEM = false;
> @@ -5661,10 +5667,16 @@ sisfb_post_xgi(struct pci_dev *pdev)
> 
>  		/* Disable read-cache */
>  		SiS_SetRegAND(SISSR, 0x21, 0xdf);
> -		sisfb_post_xgi_ramsize(ivideo);
> +		err = sisfb_post_xgi_ramsize(ivideo);
>  		/* Enable read-cache */
>  		SiS_SetRegOR(SISSR, 0x21, 0x20);
> 
> +		if (err) {
> +			dev_err(&pdev->dev,
> +				"%s: RAM size detection failed: %d\n",
> +				__func__, err);
> +			return 0;


Are you sure you wish to return 0 when there is an error?

> +		}
>  	}
> 
>  #if 0
> --
> 1.5.6.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
