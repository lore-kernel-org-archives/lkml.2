Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977Ab1K2VhF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 16:37:05 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:39457 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756964Ab1K2VhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 16:37:01 -0500
Subject: Re: [PATCH v2] Integrated Flash Controller support
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: b35362@freescale.com
Cc: dwmw2@infradead.org, Artem.Bityutskiy@nokia.com, r58472@freescale.com,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        scottwood@freescale.com, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org
Date: Tue, 29 Nov 2011 23:36:52 +0200
In-Reply-To: <1320053901-23801-1-git-send-email-b35362@freescale.com>
References: <1320053901-23801-1-git-send-email-b35362@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1322602615.2150.7.camel@koala>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-31 at 17:38 +0800, b35362@freescale.com wrote:
> +/*
> + * fsl_ifc_ctrl_probe
> + *
> + * called by device layer when it finds a device matching
> + * one our driver can handled. This code allocates all of
> + * the resources needed for the controller only.  The
> + * resources for the NAND banks themselves are allocated
> + * in the chip probe function.
> +*/
> +static int __devinit fsl_ifc_ctrl_probe(struct platform_device *dev)
> +{
> +	int ret = 0;
> +
> +

... snip ...

I am concerned about the error path in this function

> +	init_waitqueue_head(&fsl_ifc_ctrl_dev->nand_wait);
> +
> +	ret = request_irq(fsl_ifc_ctrl_dev->irq, fsl_ifc_ctrl_irq, IRQF_SHARED,
> +			  "fsl-ifc", fsl_ifc_ctrl_dev);
> +	if (ret != 0) {
> +		dev_err(&dev->dev, "failed to install irq (%d)\n",
> +			fsl_ifc_ctrl_dev->irq);
> +		goto err;
> +	}

irq_dispose_mapping() on error path?

> +
> +	ret = request_irq(fsl_ifc_ctrl_dev->nand_irq, fsl_ifc_nand_irq, 0,
> +			  "fsl-ifc-nand", fsl_ifc_ctrl_dev);
> +	if (ret != 0) {
> +		dev_err(&dev->dev, "failed to install irq (%d)\n",
> +			fsl_ifc_ctrl_dev->nand_irq);
> +		goto err;

free_irq() on error path?
> +	}
> +
> +	return 0;
> +
> +err:
> +	return ret;
> +}


> +static __init int fsl_ifc_init(void)
> +{
> +	int ret;
> +
> +	ret = platform_driver_register(&fsl_ifc_ctrl_driver);
> +	if (ret)
> +		printk(KERN_ERR "fsl-ifc: Failed to register platform"
> +				"driver\n");
> +
> +	return ret;
> +}
> +
> +static void __exit fsl_ifc_exit(void)
> +{
> +	platform_driver_unregister(&fsl_ifc_ctrl_driver);
> +}
> +
> +module_init(fsl_ifc_init);
> +module_exit(fsl_ifc_exit);

How about using module_platform_driver() instead?


