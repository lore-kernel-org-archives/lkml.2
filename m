Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371Ab2BQAkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 19:40:33 -0500
Received: from gate.crashing.org ([63.228.1.57]:52952 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756297Ab2BQAkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 19:40:32 -0500
Message-ID: <1329439216.2892.36.camel@pasglop>
Subject: Re: [PATCH V2 RESEND] fsl-sata: I/O load balancing
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Qiang Liu <qiang.liu@freescale.com>
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Fri, 17 Feb 2012 11:40:16 +1100
In-Reply-To: <1329284944-17943-1-git-send-email-qiang.liu@freescale.com>
References: <1329284944-17943-1-git-send-email-qiang.liu@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-15 at 13:49 +0800, Qiang Liu wrote:
]
> diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
> index 0120b0d..d6577b9 100644
> --- a/drivers/ata/sata_fsl.c
> +++ b/drivers/ata/sata_fsl.c
> @@ -6,7 +6,7 @@
>   * Author: Ashish Kalra <ashish.kalra@freescale.com>
>   * Li Yang <leoli@freescale.com>
>   *
> - * Copyright (c) 2006-2007, 2011 Freescale Semiconductor, Inc.
> + * Copyright (c) 2006-2007, 2011-2012 Freescale Semiconductor, Inc.
>   *
>   * This program is free software; you can redistribute  it and/or modify it
>   * under  the terms of  the GNU General  Public License as published by the
> @@ -26,6 +26,15 @@
>  #include <asm/io.h>
>  #include <linux/of_platform.h>
> 
> +static unsigned int intr_coalescing_count;
> +module_param(intr_coalescing_count, int, S_IRUGO);
> +MODULE_PARM_DESC(intr_coalescing_count,
> +				 "INT coalescing count threshold (1..31)");
> +
> +static unsigned int intr_coalescing_ticks;
> +module_param(intr_coalescing_ticks, int, S_IRUGO);
> +MODULE_PARM_DESC(intr_coalescing_ticks,
> +				 "INT coalescing timer threshold in AHB ticks");

You don't seem to provide very useful defaults... for example,
intr_coalescing_count starts at 0 which isn't even in range
(the code fixes that up but still...).

I tried a debian install on the p5020ds here and I find SATA to be
extremely slow, generating millions of interrupts. I think the defaults
should be a lot more aggressive at coalescing.

Cheers,
Ben.

>  /* Controller information */
>  enum {
>  	SATA_FSL_QUEUE_DEPTH	= 16,
> @@ -83,6 +92,16 @@ enum {
>  };
> 
>  /*
> + * Interrupt Coalescing Control Register bitdefs  */
> +enum {
> +	ICC_MIN_INT_COUNT_THRESHOLD	= 1,
> +	ICC_MAX_INT_COUNT_THRESHOLD	= ((1 << 5) - 1),
> +	ICC_MIN_INT_TICKS_THRESHOLD	= 0,
> +	ICC_MAX_INT_TICKS_THRESHOLD	= ((1 << 19) - 1),
> +	ICC_SAFE_INT_TICKS		= 1,
> +};
> +
> +/*
>  * Host Controller command register set - per port
>  */
>  enum {
> @@ -263,8 +282,65 @@ struct sata_fsl_host_priv {
>  	void __iomem *csr_base;
>  	int irq;
>  	int data_snoop;
> +	struct device_attribute intr_coalescing;
>  };
> 
> +static void fsl_sata_set_irq_coalescing(struct ata_host *host,
> +		unsigned int count, unsigned int ticks)
> +{
> +	struct sata_fsl_host_priv *host_priv = host->private_data;
> +	void __iomem *hcr_base = host_priv->hcr_base;
> +
> +	if (count > ICC_MAX_INT_COUNT_THRESHOLD)
> +		count = ICC_MAX_INT_COUNT_THRESHOLD;
> +	else if (count < ICC_MIN_INT_COUNT_THRESHOLD)
> +		count = ICC_MIN_INT_COUNT_THRESHOLD;
> +
> +	if (ticks > ICC_MAX_INT_TICKS_THRESHOLD)
> +		ticks = ICC_MAX_INT_TICKS_THRESHOLD;
> +	else if ((ICC_MIN_INT_TICKS_THRESHOLD == ticks) &&
> +			(count > ICC_MIN_INT_COUNT_THRESHOLD))
> +		ticks = ICC_SAFE_INT_TICKS;
> +
> +	spin_lock(&host->lock);
> +	iowrite32((count << 24 | ticks), hcr_base + ICC);
> +
> +	intr_coalescing_count = count;
> +	intr_coalescing_ticks = ticks;
> +	spin_unlock(&host->lock);
> +
> +	DPRINTK("intrrupt coalescing, count = 0x%x, ticks = %x\n",
> +			intr_coalescing_count, intr_coalescing_ticks);
> +	DPRINTK("ICC register status: (hcr base: 0x%x) = 0x%x\n",
> +			hcr_base, ioread32(hcr_base + ICC));
> +}
> +
> +static ssize_t fsl_sata_intr_coalescing_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	return sprintf(buf, "%d	%d\n",
> +			intr_coalescing_count, intr_coalescing_ticks);
> +}
> +
> +static ssize_t fsl_sata_intr_coalescing_store(struct device *dev,
> +		struct device_attribute *attr,
> +		const char *buf, size_t count)
> +{
> +	unsigned int coalescing_count,	coalescing_ticks;
> +
> +	if (sscanf(buf, "%d%d",
> +				&coalescing_count,
> +				&coalescing_ticks) != 2) {
> +		printk(KERN_ERR "fsl-sata: wrong parameter format.\n");
> +		return -EINVAL;
> +	}
> +
> +	fsl_sata_set_irq_coalescing(dev_get_drvdata(dev),
> +			coalescing_count, coalescing_ticks);
> +
> +	return strlen(buf);
> +}
> +
>  static inline unsigned int sata_fsl_tag(unsigned int tag,
>  					void __iomem *hcr_base)
>  {
> @@ -346,10 +422,10 @@ static unsigned int sata_fsl_fill_sg(struct ata_queued_cmd *qc, void *cmd_desc,
>  			(unsigned long long)sg_addr, sg_len);
> 
>  		/* warn if each s/g element is not dword aligned */
> -		if (sg_addr & 0x03)
> +		if (unlikely(sg_addr & 0x03))
>  			ata_port_err(qc->ap, "s/g addr unaligned : 0x%llx\n",
>  				     (unsigned long long)sg_addr);
> -		if (sg_len & 0x03)
> +		if (unlikely(sg_len & 0x03))
>  			ata_port_err(qc->ap, "s/g len unaligned : 0x%x\n",
>  				     sg_len);
> 
> @@ -1245,6 +1321,13 @@ static int sata_fsl_init_controller(struct ata_host *host)
>  	iowrite32(0x00000FFFF, hcr_base + CE);
>  	iowrite32(0x00000FFFF, hcr_base + DE);
> 
> + 	/*
> +	 * reset the number of command complete bits which will cause the
> +	 * interrupt to be signaled
> +	 */
> +	fsl_sata_set_irq_coalescing(host, intr_coalescing_count,
> +			intr_coalescing_ticks);
> +
>  	/*
>  	 * host controller will be brought on-line, during xx_port_start()
>  	 * callback, that should also initiate the OOB, COMINIT sequence
> @@ -1309,7 +1392,7 @@ static int sata_fsl_probe(struct platform_device *ofdev)
>  	void __iomem *csr_base = NULL;
>  	struct sata_fsl_host_priv *host_priv = NULL;
>  	int irq;
> -	struct ata_host *host;
> +	struct ata_host *host = NULL;
>  	u32 temp;
> 
>  	struct ata_port_info pi = sata_fsl_port_info[0];
> @@ -1356,6 +1439,10 @@ static int sata_fsl_probe(struct platform_device *ofdev)
> 
>  	/* allocate host structure */
>  	host = ata_host_alloc_pinfo(&ofdev->dev, ppi, SATA_FSL_MAX_PORTS);
> +	if (!host) {
> +		retval = -ENOMEM;
> +		goto error_exit_with_cleanup;
> +	}
> 
>  	/* host->iomap is not used currently */
>  	host->private_data = host_priv;
> @@ -1373,10 +1460,24 @@ static int sata_fsl_probe(struct platform_device *ofdev)
> 
>  	dev_set_drvdata(&ofdev->dev, host);
> 
> +	host_priv->intr_coalescing.show = fsl_sata_intr_coalescing_show;
> +	host_priv->intr_coalescing.store = fsl_sata_intr_coalescing_store;
> +	sysfs_attr_init(&host_priv->intr_coalescing.attr);
> +	host_priv->intr_coalescing.attr.name = "intr_coalescing";
> +	host_priv->intr_coalescing.attr.mode = S_IRUGO | S_IWUSR;
> +	retval = device_create_file(host->dev, &host_priv->intr_coalescing);
> +	if (retval)
> +		goto error_exit_with_cleanup;
> +
>  	return 0;
> 
>  error_exit_with_cleanup:
> 
> +	if (host) {
> +		dev_set_drvdata(&ofdev->dev, NULL);
> +		ata_host_detach(host);
> +	}
> +
>  	if (hcr_base)
>  		iounmap(hcr_base);
>  	if (host_priv)
> @@ -1390,6 +1491,8 @@ static int sata_fsl_remove(struct platform_device *ofdev)
>  	struct ata_host *host = dev_get_drvdata(&ofdev->dev);
>  	struct sata_fsl_host_priv *host_priv = host->private_data;
> 
> +	device_remove_file(&ofdev->dev, &host_priv->intr_coalescing);
> +
>  	ata_host_detach(host);
> 
>  	dev_set_drvdata(&ofdev->dev, NULL);
> --
> 1.6.4
> 
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev


