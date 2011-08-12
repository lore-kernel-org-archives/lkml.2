Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab1HLVc1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 17:32:27 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:2706 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416Ab1HLVcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 17:32:23 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Message-ID: <4E459BDB.7020000@broadcom.com>
Date: Fri, 12 Aug 2011 14:32:11 -0700
From: "Jiandong Zheng" <jdzheng@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624
 Thunderbird/5.0
MIME-Version: 1.0
To: "Julia Lawall" <julia@diku.dk>
cc: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "Scott Branden" <sbranden@broadcom.com>,
        "David Woodhouse" <dwmw2@infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] drivers/mtd/nand/bcm_umi_nand.c: clean up error
 handling code
References: <1312964054-25266-1-git-send-email-julia@diku.dk>
In-Reply-To: <1312964054-25266-1-git-send-email-julia@diku.dk>
X-WSS-ID: 625B429F3KO5306351-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/10/2011 1:14 AM, Julia Lawall wrote:
> From: Julia Lawall<julia@diku.dk>
>
> Convert error handling code to use gotos.  At the same time, this adds
> calls to kfree and iounmap in a few cases where they were overlooked.
>
> Signed-off-by: Julia Lawall<julia@diku.dk>
>
> ---
>   drivers/mtd/nand/bcm_umi_nand.c |   33 ++++++++++++++++++---------------
>   1 file changed, 18 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/mtd/nand/bcm_umi_nand.c b/drivers/mtd/nand/bcm_umi_nand.c
> index a8ae898..46b58d6 100644
> --- a/drivers/mtd/nand/bcm_umi_nand.c
> +++ b/drivers/mtd/nand/bcm_umi_nand.c
> @@ -374,16 +374,18 @@ static int __devinit bcm_umi_nand_probe(struct platform_device *pdev)
>
>   	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>
> -	if (!r)
> -		return -ENXIO;
> +	if (!r) {
> +		err = -ENXIO;
> +		goto out_free;
> +	}
>
>   	/* map physical address */
>   	bcm_umi_io_base = ioremap(r->start, resource_size(r));
>
>   	if (!bcm_umi_io_base) {
>   		printk(KERN_ERR "ioremap to access BCM UMI NAND chip failed\n");
> -		kfree(board_mtd);
> -		return -EIO;
> +		err = -EIO;
> +		goto out_free;
>   	}
>
>   	/* Get pointer to private data */
> @@ -399,9 +401,8 @@ static int __devinit bcm_umi_nand_probe(struct platform_device *pdev)
>   	/* Initialize the NAND hardware.  */
>   	if (bcm_umi_nand_inithw()<  0) {
>   		printk(KERN_ERR "BCM UMI NAND chip could not be initialized\n");
> -		iounmap(bcm_umi_io_base);
> -		kfree(board_mtd);
> -		return -EIO;
> +		err = -EIO;
> +		goto out_unmap;
>   	}
>
>   	/* Set address of NAND IO lines */
> @@ -434,7 +435,7 @@ static int __devinit bcm_umi_nand_probe(struct platform_device *pdev)
>   #if USE_DMA
>   	err = nand_dma_init();
>   	if (err != 0)
> -		return err;
> +		goto out_unmap;
>   #endif
>
>   	/* Figure out the size of the device that we have.
> @@ -445,9 +446,7 @@ static int __devinit bcm_umi_nand_probe(struct platform_device *pdev)
>   	err = nand_scan_ident(board_mtd, 1, NULL);
>   	if (err) {
>   		printk(KERN_ERR "nand_scan failed: %d\n", err);
> -		iounmap(bcm_umi_io_base);
> -		kfree(board_mtd);
> -		return err;
> +		goto out_unmap;
>   	}
>
>   	/* Now that we know the nand size, we can setup the ECC layout */
> @@ -466,7 +465,8 @@ static int __devinit bcm_umi_nand_probe(struct platform_device *pdev)
>   		{
>   			printk(KERN_ERR "NAND - Unrecognized pagesize: %d\n",
>   					 board_mtd->writesize);
> -			return -EINVAL;
> +			err = -EINVAL;
> +			goto out_unmap;
>   		}
>   	}
>
> @@ -483,9 +483,7 @@ static int __devinit bcm_umi_nand_probe(struct platform_device *pdev)
>   	err = nand_scan_tail(board_mtd);
>   	if (err) {
>   		printk(KERN_ERR "nand_scan failed: %d\n", err);
> -		iounmap(bcm_umi_io_base);
> -		kfree(board_mtd);
> -		return err;
> +		goto out_unmap;
>   	}
>
>   	/* Register the partitions */
> @@ -494,6 +492,11 @@ static int __devinit bcm_umi_nand_probe(struct platform_device *pdev)
>
>   	/* Return happy */
>   	return 0;
> +out_unmap:
> +	iounmap(bcm_umi_io_base);
> +out_free:
> +	kfree(board_mtd);
> +	return err;
>   }
>
>   static int bcm_umi_nand_remove(struct platform_device *pdev)
>
>
Acked-by: Jiandong Zheng <jdzheng@broadcom.com>

