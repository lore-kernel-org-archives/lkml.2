Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806Ab1BPSMW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 13:12:22 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37905 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab1BPSMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 13:12:18 -0500
Message-ID: <4D5C1326.2010101@ru.mvista.com>
Date: Wed, 16 Feb 2011 21:10:46 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Vasiliy Kulikov <segooon@gmail.com>, Jeff Garzik <jgarzik@pobox.com>
CC: kernel-janitors@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Rupjyoti Sarmah <rsarmah@appliedmicro.com>,
        Prodyut Hazarika <phazarika@appliedmicro.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: sata_dwc_460ex: fix error path
References: <1284317830-5022-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1284317830-5022-1-git-send-email-segooon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Vasiliy Kulikov wrote:

> Free all allocated resources on error path.

> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> ---
>  I cannot compile this driver at all, so it is not tested.

    I can at least compile-test the patch...

>  drivers/ata/sata_dwc_460ex.c |   21 ++++++++++++++-------
>  1 files changed, 14 insertions(+), 7 deletions(-)

> diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
> index 6cf57c5..ad0535f 100644
> --- a/drivers/ata/sata_dwc_460ex.c
> +++ b/drivers/ata/sata_dwc_460ex.c
> @@ -727,11 +727,15 @@ static int dma_dwc_xfer_setup(struct scatterlist *sg, int num_elems,
>  static void dma_dwc_exit(struct sata_dwc_device *hsdev)
>  {
>  	dev_dbg(host_pvt.dwc_dev, "%s:\n", __func__);
> -	if (host_pvt.sata_dma_regs)
> +	if (host_pvt.sata_dma_regs) {
>  		iounmap(host_pvt.sata_dma_regs);
> +		host_pvt.sata_dma_regs = NULL;
> +	}
>  
> -	if (hsdev->irq_dma)
> +	if (hsdev->irq_dma) {
>  		free_irq(hsdev->irq_dma, hsdev);
> +		hsdev->irq_dma = 0;
> +	}
>  }

    Are those changes really necessary, i.e. is dma_dwc_exit() called more than 
once?

> @@ -1606,7 +1610,7 @@ static int sata_dwc_probe(struct platform_device *ofdev,
>  	if (hsdev == NULL) {
>  		dev_err(&ofdev->dev, "kmalloc failed for hsdev\n");
>  		err = -ENOMEM;
> -		goto error_out;
> +		goto error;

    Why not just:

		return err;

>  	}
>  	memset(hsdev, 0, sizeof(*hsdev));
>  
> @@ -1616,7 +1620,7 @@ static int sata_dwc_probe(struct platform_device *ofdev,
>  		dev_err(&ofdev->dev, "ioremap failed for SATA register"
>  			" address\n");
>  		err = -ENODEV;
> -		goto error_out;
> +		goto error_kmalloc;
>  	}
>  	hsdev->reg_base = base;
>  	dev_dbg(&ofdev->dev, "ioremap done for SATA register address\n");
> @@ -1629,7 +1633,7 @@ static int sata_dwc_probe(struct platform_device *ofdev,
>  	if (!host) {
>  		dev_err(&ofdev->dev, "ata_host_alloc_pinfo failed\n");
>  		err = -ENOMEM;
> -		goto error_out;
> +		goto error_iomap;
>  	}
>  
>  	host->private_data = hsdev;
> @@ -1697,8 +1701,11 @@ error_out:
>  	/* Free SATA DMA resources */
>  	dma_dwc_exit(hsdev);
>  
> -	if (base)
> -		iounmap(base);
> +error_iomap:
> +	iounmap(base);
> +error_kmalloc:
> +	kfree(hsdev);
> +error:
>  	return err;
>  }

    Jeff, what's become with this patch? Will you queue it? And will you queue 
my 4 fixes (and 1 cleanup)?

WBR, Sergei
