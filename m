Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab2DTUu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 16:50:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315Ab2DTUuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 16:50:25 -0400
Date: Fri, 20 Apr 2012 16:50:02 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] [media] rc: Postpone ISR registration
Message-ID: <20120420205002.GD17452@redhat.com>
References: <1334871437-26514-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334871437-26514-1-git-send-email-luis.henriques@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 10:37:17PM +0100, Luis Henriques wrote:
> An early registration of an ISR was causing a crash to several users (for
> example, with the ite-cir driver: http://bugs.launchpad.net/bugs/972723).
> The reason was that IRQs were being triggered before a driver
> initialisation was completed.
> 
> This patch fixes this by moving the invocation to request_irq() and to
> request_region() to a later stage on the driver probe function.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
> ---
>  drivers/media/rc/ene_ir.c      |   29 ++++++++++----------
>  drivers/media/rc/fintek-cir.c  |   17 ++++++------
>  drivers/media/rc/ite-cir.c     |   18 ++++++-------
>  drivers/media/rc/nuvoton-cir.c |   33 ++++++++++++-----------
>  drivers/media/rc/winbond-cir.c |   58 ++++++++++++++++++++--------------------
>  5 files changed, 79 insertions(+), 76 deletions(-)
> 
> diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
> index 860c112..b38c5c7 100644
> --- a/drivers/media/rc/ene_ir.c
> +++ b/drivers/media/rc/ene_ir.c
> @@ -1018,21 +1018,7 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
>  
>  	spin_lock_init(&dev->hw_lock);
>  
> -	/* claim the resources */
>  	error = -EBUSY;

In each of these, I believe the setting of retval to -EBUSY needs to be
moved as well, or you're passing along a success retval from another
operatoin between here and where the request_foo functions moved.


> -	dev->hw_io = pnp_port_start(pnp_dev, 0);
> -	if (!request_region(dev->hw_io, ENE_IO_SIZE, ENE_DRIVER_NAME)) {
> -		dev->hw_io = -1;
> -		dev->irq = -1;
> -		goto error;
> -	}
> -
> -	dev->irq = pnp_irq(pnp_dev, 0);
> -	if (request_irq(dev->irq, ene_isr,
> -			IRQF_SHARED, ENE_DRIVER_NAME, (void *)dev)) {
> -		dev->irq = -1;
> -		goto error;
> -	}
>  
>  	pnp_set_drvdata(pnp_dev, dev);
>  	dev->pnp_dev = pnp_dev;
> @@ -1086,6 +1072,21 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
>  	device_set_wakeup_capable(&pnp_dev->dev, true);
>  	device_set_wakeup_enable(&pnp_dev->dev, true);
>  
> +	/* claim the resources */
> +	dev->hw_io = pnp_port_start(pnp_dev, 0);
> +	if (!request_region(dev->hw_io, ENE_IO_SIZE, ENE_DRIVER_NAME)) {
> +		dev->hw_io = -1;
> +		dev->irq = -1;
> +		goto error;
> +	}
> +
> +	dev->irq = pnp_irq(pnp_dev, 0);
> +	if (request_irq(dev->irq, ene_isr,
> +			IRQF_SHARED, ENE_DRIVER_NAME, (void *)dev)) {
> +		dev->irq = -1;
> +		goto error;
> +	}
> +
>  	error = rc_register_device(rdev);
>  	if (error < 0)
>  		goto error;
> diff --git a/drivers/media/rc/fintek-cir.c b/drivers/media/rc/fintek-cir.c
> index 392d4be..c6273c5 100644
> --- a/drivers/media/rc/fintek-cir.c
> +++ b/drivers/media/rc/fintek-cir.c
> @@ -515,14 +515,6 @@ static int fintek_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id
>  	spin_lock_init(&fintek->fintek_lock);
>  
>  	ret = -EBUSY;
> -	/* now claim resources */
> -	if (!request_region(fintek->cir_addr,
> -			    fintek->cir_port_len, FINTEK_DRIVER_NAME))
> -		goto failure;
> -
> -	if (request_irq(fintek->cir_irq, fintek_cir_isr, IRQF_SHARED,
> -			FINTEK_DRIVER_NAME, (void *)fintek))
> -		goto failure;
>  
>  	pnp_set_drvdata(pdev, fintek);
>  	fintek->pdev = pdev;
> @@ -558,6 +550,15 @@ static int fintek_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id
>  	/* rx resolution is hardwired to 50us atm, 1, 25, 100 also possible */
>  	rdev->rx_resolution = US_TO_NS(CIR_SAMPLE_PERIOD);
>  
> +	/* now claim resources */
> +	if (!request_region(fintek->cir_addr,
> +			    fintek->cir_port_len, FINTEK_DRIVER_NAME))
> +		goto failure;
> +
> +	if (request_irq(fintek->cir_irq, fintek_cir_isr, IRQF_SHARED,
> +			FINTEK_DRIVER_NAME, (void *)fintek))
> +		goto failure;
> +
>  	ret = rc_register_device(rdev);
>  	if (ret)
>  		goto failure;
> diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
> index 682009d..d88b304 100644
> --- a/drivers/media/rc/ite-cir.c
> +++ b/drivers/media/rc/ite-cir.c
> @@ -1516,15 +1516,6 @@ static int ite_probe(struct pnp_dev *pdev, const struct pnp_device_id
>  	init_ir_raw_event(&itdev->rawir);
>  
>  	ret = -EBUSY;
> -	/* now claim resources */
> -	if (!request_region(itdev->cir_addr,
> -				dev_desc->io_region_size, ITE_DRIVER_NAME))
> -		goto failure;
> -
> -	if (request_irq(itdev->cir_irq, ite_cir_isr, IRQF_SHARED,
> -			ITE_DRIVER_NAME, (void *)itdev))
> -		goto failure;
> -
>  	/* set driver data into the pnp device */
>  	pnp_set_drvdata(pdev, itdev);
>  	itdev->pdev = pdev;
> @@ -1600,6 +1591,15 @@ static int ite_probe(struct pnp_dev *pdev, const struct pnp_device_id
>  	rdev->driver_name = ITE_DRIVER_NAME;
>  	rdev->map_name = RC_MAP_RC6_MCE;
>  
> +	/* now claim resources */
> +	if (!request_region(itdev->cir_addr,
> +				dev_desc->io_region_size, ITE_DRIVER_NAME))
> +		goto failure;
> +
> +	if (request_irq(itdev->cir_irq, ite_cir_isr, IRQF_SHARED,
> +			ITE_DRIVER_NAME, (void *)itdev))
> +		goto failure;
> +
>  	ret = rc_register_device(rdev);
>  	if (ret)
>  		goto failure;
> diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
> index 144f3f5..8afe549 100644
> --- a/drivers/media/rc/nuvoton-cir.c
> +++ b/drivers/media/rc/nuvoton-cir.c
> @@ -1022,22 +1022,6 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
>  	spin_lock_init(&nvt->tx.lock);
>  
>  	ret = -EBUSY;
> -	/* now claim resources */
> -	if (!request_region(nvt->cir_addr,
> -			    CIR_IOREG_LENGTH, NVT_DRIVER_NAME))
> -		goto failure;
> -
> -	if (request_irq(nvt->cir_irq, nvt_cir_isr, IRQF_SHARED,
> -			NVT_DRIVER_NAME, (void *)nvt))
> -		goto failure;
> -
> -	if (!request_region(nvt->cir_wake_addr,
> -			    CIR_IOREG_LENGTH, NVT_DRIVER_NAME))
> -		goto failure;
> -
> -	if (request_irq(nvt->cir_wake_irq, nvt_cir_wake_isr, IRQF_SHARED,
> -			NVT_DRIVER_NAME, (void *)nvt))
> -		goto failure;
>  
>  	pnp_set_drvdata(pdev, nvt);
>  	nvt->pdev = pdev;
> @@ -1085,6 +1069,23 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
>  	rdev->tx_resolution = XYZ;
>  #endif
>  
> +	/* now claim resources */
> +	if (!request_region(nvt->cir_addr,
> +			    CIR_IOREG_LENGTH, NVT_DRIVER_NAME))
> +		goto failure;
> +
> +	if (request_irq(nvt->cir_irq, nvt_cir_isr, IRQF_SHARED,
> +			NVT_DRIVER_NAME, (void *)nvt))
> +		goto failure;
> +
> +	if (!request_region(nvt->cir_wake_addr,
> +			    CIR_IOREG_LENGTH, NVT_DRIVER_NAME))
> +		goto failure;
> +
> +	if (request_irq(nvt->cir_wake_irq, nvt_cir_wake_isr, IRQF_SHARED,
> +			NVT_DRIVER_NAME, (void *)nvt))
> +		goto failure;
> +
>  	ret = rc_register_device(rdev);
>  	if (ret)
>  		goto failure;
> diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
> index b09c5fa..8e88c96 100644
> --- a/drivers/media/rc/winbond-cir.c
> +++ b/drivers/media/rc/winbond-cir.c
> @@ -991,35 +991,6 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
>  		"(w: 0x%lX, e: 0x%lX, s: 0x%lX, i: %u)\n",
>  		data->wbase, data->ebase, data->sbase, data->irq);
>  
> -	if (!request_region(data->wbase, WAKEUP_IOMEM_LEN, DRVNAME)) {
> -		dev_err(dev, "Region 0x%lx-0x%lx already in use!\n",
> -			data->wbase, data->wbase + WAKEUP_IOMEM_LEN - 1);
> -		err = -EBUSY;
> -		goto exit_free_data;
> -	}
> -
> -	if (!request_region(data->ebase, EHFUNC_IOMEM_LEN, DRVNAME)) {
> -		dev_err(dev, "Region 0x%lx-0x%lx already in use!\n",
> -			data->ebase, data->ebase + EHFUNC_IOMEM_LEN - 1);
> -		err = -EBUSY;
> -		goto exit_release_wbase;
> -	}
> -
> -	if (!request_region(data->sbase, SP_IOMEM_LEN, DRVNAME)) {
> -		dev_err(dev, "Region 0x%lx-0x%lx already in use!\n",
> -			data->sbase, data->sbase + SP_IOMEM_LEN - 1);
> -		err = -EBUSY;
> -		goto exit_release_ebase;
> -	}
> -
> -	err = request_irq(data->irq, wbcir_irq_handler,
> -			  IRQF_DISABLED, DRVNAME, device);
> -	if (err) {
> -		dev_err(dev, "Failed to claim IRQ %u\n", data->irq);
> -		err = -EBUSY;
> -		goto exit_release_sbase;
> -	}
> -
>  	led_trigger_register_simple("cir-tx", &data->txtrigger);
>  	if (!data->txtrigger) {
>  		err = -ENOMEM;
> @@ -1061,6 +1032,35 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
>  	data->dev->priv = data;
>  	data->dev->dev.parent = &device->dev;
>  
> +	if (!request_region(data->wbase, WAKEUP_IOMEM_LEN, DRVNAME)) {
> +		dev_err(dev, "Region 0x%lx-0x%lx already in use!\n",
> +			data->wbase, data->wbase + WAKEUP_IOMEM_LEN - 1);
> +		err = -EBUSY;
> +		goto exit_free_data;
> +	}
> +
> +	if (!request_region(data->ebase, EHFUNC_IOMEM_LEN, DRVNAME)) {
> +		dev_err(dev, "Region 0x%lx-0x%lx already in use!\n",
> +			data->ebase, data->ebase + EHFUNC_IOMEM_LEN - 1);
> +		err = -EBUSY;
> +		goto exit_release_wbase;
> +	}
> +
> +	if (!request_region(data->sbase, SP_IOMEM_LEN, DRVNAME)) {
> +		dev_err(dev, "Region 0x%lx-0x%lx already in use!\n",
> +			data->sbase, data->sbase + SP_IOMEM_LEN - 1);
> +		err = -EBUSY;
> +		goto exit_release_ebase;
> +	}
> +
> +	err = request_irq(data->irq, wbcir_irq_handler,
> +			  IRQF_DISABLED, DRVNAME, device);
> +	if (err) {
> +		dev_err(dev, "Failed to claim IRQ %u\n", data->irq);
> +		err = -EBUSY;
> +		goto exit_release_sbase;
> +	}
> +
>  	err = rc_register_device(data->dev);
>  	if (err)
>  		goto exit_free_rc;
> -- 
> 1.7.9.5
> 

-- 
Jarod Wilson
jarod@redhat.com

