Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577Ab1F3HxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 03:53:22 -0400
Received: from webbox687.server-home.net ([195.149.74.151]:59774 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab1F3HxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 03:53:18 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: Re: [PATCH v3] pch_gpio: Support interrupt function
Date: Thu, 30 Jun 2011 09:53:15 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r6; KDE/4.6.3; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com
References: <1308631468-2376-1-git-send-email-tomoya-linux@dsn.okisemi.com> <4E0BDA54.2080007@dsn.okisemi.com>
In-Reply-To: <4E0BDA54.2080007@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Message-Id: <201106300953.16654.alexander.stein@systec-electronic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 June 2011 04:07:16 Tomoya MORINAGA wrote:
> Hi Grant,
> 
> If you don't have any concern, would you accept this patch ?
> 
> Thanks,
> 
> (2011/06/21 13:44), Tomoya MORINAGA wrote:
> > Support interrupt function using irq_chip_generic
> > 
> > Signed-off-by: Tomoya MORINAGA<tomoya-linux@dsn.okisemi.com>
> > ---
> > @@ -202,8 +345,36 @@ static int __devinit pch_gpio_probe(struct pci_dev
> > *pdev,
> > 
> >   		goto err_gpiochip_add;
> >   	
> >   	}
> > 
> > +	irq_base = irq_alloc_descs(-1, PCH_IRQ_BASE, GPIO_NUM_PINS,
> > GFP_KERNEL); +	if (irq_base<  0) {
> > +		dev_err(&pdev->dev, "PCH gpio: Failed to get IRQ base num\n");
> > +		goto err_irq_alloc_descs;
> > +	}
> > +	chip->irq_base = irq_base;
> > +
> > +	ret = request_irq(pdev->irq, pch_gpio_handler,
> > +			     IRQF_SHARED, KBUILD_MODNAME, chip);
> > +	if (ret != 0) {
> > +		dev_err(&pdev->dev,
> > +			"%s request_irq failed\n", __func__);
> > +		goto err_request_irq;
> > +	}
> > +
> > +	pch_gpio_alloc_generic_chip(chip, irq_base, GPIO_NUM_PINS);
> > +
> > +	/* Initialize interrupt ien register */
> > +	iowrite32(0,&chip->reg->ien);
> > +
> > 
> >   	return 0;
> > 
> > +err_request_irq:
> > +	irq_free_descs(irq_base, GPIO_NUM_PINS);
> > +
> > +err_irq_alloc_descs:
> > +	ret = gpiochip_remove(&chip->gpio);
> > +	if (ret)
> > +		dev_err(&pdev->dev, "%s gpiochip_remove failed\n", __func__);
> > +
> > 
> >   err_gpiochip_add:
> >   	pci_iounmap(pdev, chip->base);
> > 
> > @@ -224,6 +395,8 @@ static void __devexit pch_gpio_remove(struct pci_dev
> > *pdev)
> > 
> >   	int err;
> >   	struct pch_gpio *chip = pci_get_drvdata(pdev);
> > 
> > +	irq_free_descs(chip->irq_base, GPIO_NUM_PINS);
> > +

Is a free_irq missing here?

> > 
> >   	err = gpiochip_remove(&chip->gpio);
> >   	if (err)
> >   	
> >   		dev_err(&pdev->dev, "Failed gpiochip_remove\n");

Regards,
Alexander
