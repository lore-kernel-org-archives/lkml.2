Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab1I3JRR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 05:17:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59010 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab1I3JRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 05:17:15 -0400
Date: Fri, 30 Sep 2011 11:14:31 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Josh Wu <josh.wu@atmel.com>
cc: linux-media@vger.kernel.org, plagnioj@jcrosoft.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        nicolas.ferre@atmel.com, s.nawrocki@samsung.com
Subject: Re: [PATCH v3 1/2][media] Add code to enable/disable ISI_MCK clock.
In-Reply-To: <1316664661-11383-1-git-send-email-josh.wu@atmel.com>
Message-ID: <Pine.LNX.4.64.1109301105480.1888@axis700.grange>
References: <1316664661-11383-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:1ogILvBzBX49n00u3lJerQ0J8C8D31X4HAfDYcLPbpj
 cyvFPBSYR2TlfIDl55XOrDm8UHUIF853mJOJH9h4MzvTQz+aOB
 iOr+rIfjd9B6zlj7TXjgYQExr0nEGeq0xNgdfxOP1DqBPpMsqc
 PSwIcB/Ki9KA5wfRp1a+t9gVcxl15RO9lFe82b3F2EGBd3RC8B
 CrlaaNvKEhCnCc4a23E8vai4aZXBTRgHpPHrZNDvYJ31UWsalr
 hZsVwKJERbWTqFkM2fHaSKn4WauRFTB5OIK5s4yt42zZwpnCg3
 0rMh5z9i6QiWT7lyoipxEOuy9mqkhUW5hEpzAxMH6fMj+CBdch
 P06iPfAYmNr1tlGfT6nm6uLHJ9IpemVhO0QCW2ySQDkDF233qD
 1uFGWE7n36mZA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Sep 2011, Josh Wu wrote:

> This patch add code to enable/disable ISI_MCK clock when add/remove soc 
> camera device.it also set ISI_MCK frequence before using it.

Ok, the fact, that noone more comments on the clk API use in this patch 
confirms my impression, that it's now mostly done right:-) But, as I 
mentioned in my reply to patch 2/2, I think, you shouldn't be getting and 
manipulating isi_mck unconditionally in this driver.

Actually, I think, this code

+	/* ISI_MCK, which is provided by programmable clock(PCK1) */
+	CLKDEV_CON_DEV_ID("isi_mck", "atmel_isi.0", &pck1),

in your other patch (sorry for cross-referencing), isn't quite correct. 
This is not an ISI specific clock, this is a PCK1 clock, which might as 
well be used for ISI, but can also be used for a different purpose. At 
least this doesn't seem a generic sam9g45 feature to me. You, probably, 
want to move this clock lookup registration to your board (sam9g45ek) 
file, which does indeed wire PCK1 to the camera sensor, installed on it.

Thanks
Guennadi

> 
> Signed-off-by: Josh Wu <josh.wu@atmel.com>
> ---
>  drivers/media/video/atmel-isi.c |   30 ++++++++++++++++++++++++++++--
>  include/media/atmel-isi.h       |    2 ++
>  2 files changed, 30 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/atmel-isi.c b/drivers/media/video/atmel-isi.c
> index 7b89f00..888234a 100644
> --- a/drivers/media/video/atmel-isi.c
> +++ b/drivers/media/video/atmel-isi.c
> @@ -90,7 +90,10 @@ struct atmel_isi {
>  	struct isi_dma_desc		dma_desc[MAX_BUFFER_NUM];
>  
>  	struct completion		complete;
> +	/* ISI peripherial clock */
>  	struct clk			*pclk;
> +	/* ISI_MCK, provided by Programmable clock */
> +	struct clk			*mck;
>  	unsigned int			irq;
>  
>  	struct isi_platform_data	*pdata;
> @@ -763,6 +766,12 @@ static int isi_camera_add_device(struct soc_camera_device *icd)
>  	if (ret)
>  		return ret;
>  
> +	ret = clk_enable(isi->mck);
> +	if (ret) {
> +		clk_disable(isi->pclk);
> +		return ret;
> +	}
> +
>  	isi->icd = icd;
>  	dev_dbg(icd->parent, "Atmel ISI Camera driver attached to camera %d\n",
>  		 icd->devnum);
> @@ -776,6 +785,7 @@ static void isi_camera_remove_device(struct soc_camera_device *icd)
>  
>  	BUG_ON(icd != isi->icd);
>  
> +	clk_disable(isi->mck);
>  	clk_disable(isi->pclk);
>  	isi->icd = NULL;
>  
> @@ -897,6 +907,7 @@ static int __devexit atmel_isi_remove(struct platform_device *pdev)
>  			isi->fb_descriptors_phys);
>  
>  	iounmap(isi->regs);
> +	clk_put(isi->mck);
>  	clk_put(isi->pclk);
>  	kfree(isi);
>  
> @@ -915,7 +926,7 @@ static int __devinit atmel_isi_probe(struct platform_device *pdev)
>  	struct isi_platform_data *pdata;
>  
>  	pdata = dev->platform_data;
> -	if (!pdata || !pdata->data_width_flags) {
> +	if (!pdata || !pdata->data_width_flags || !pdata->isi_mck_hz) {
>  		dev_err(&pdev->dev,
>  			"No config available for Atmel ISI\n");
>  		return -EINVAL;
> @@ -944,6 +955,19 @@ static int __devinit atmel_isi_probe(struct platform_device *pdev)
>  	INIT_LIST_HEAD(&isi->video_buffer_list);
>  	INIT_LIST_HEAD(&isi->dma_desc_head);
>  
> +	/* Get ISI_MCK, which is provided by Programmable clock */
> +	isi->mck = clk_get(dev, "isi_mck");
> +	if (IS_ERR(isi->mck)) {
> +		dev_err(dev, "Failed to get isi_mck\n");
> +		ret = PTR_ERR(isi->mck);
> +		goto err_alloc_descriptors;
> +	}
> +
> +	/* Set ISI_MCK's frequency, it should be faster than pixel clock */
> +	ret = clk_set_rate(isi->mck, pdata->isi_mck_hz);
> +	if (ret < 0)
> +		goto err_set_mck_rate;
> +
>  	isi->p_fb_descriptors = dma_alloc_coherent(&pdev->dev,
>  				sizeof(struct fbd) * MAX_BUFFER_NUM,
>  				&isi->fb_descriptors_phys,
> @@ -951,7 +975,7 @@ static int __devinit atmel_isi_probe(struct platform_device *pdev)
>  	if (!isi->p_fb_descriptors) {
>  		ret = -ENOMEM;
>  		dev_err(&pdev->dev, "Can't allocate descriptors!\n");
> -		goto err_alloc_descriptors;
> +		goto err_set_mck_rate;
>  	}
>  
>  	for (i = 0; i < MAX_BUFFER_NUM; i++) {
> @@ -1013,6 +1037,8 @@ err_alloc_ctx:
>  			sizeof(struct fbd) * MAX_BUFFER_NUM,
>  			isi->p_fb_descriptors,
>  			isi->fb_descriptors_phys);
> +err_set_mck_rate:
> +	clk_put(isi->mck);
>  err_alloc_descriptors:
>  	kfree(isi);
>  err_alloc_isi:
> diff --git a/include/media/atmel-isi.h b/include/media/atmel-isi.h
> index 26cece5..a0229a6 100644
> --- a/include/media/atmel-isi.h
> +++ b/include/media/atmel-isi.h
> @@ -114,6 +114,8 @@ struct isi_platform_data {
>  	u32 data_width_flags;
>  	/* Using for ISI_CFG1 */
>  	u32 frate;
> +	/* Using for ISI_MCK, provided by Programmable clock */
> +	u32 isi_mck_hz;
>  };
>  
>  #endif /* __ATMEL_ISI_H__ */
> -- 
> 1.6.3.3
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
