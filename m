Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758967Ab2HHRKJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 13:10:09 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:33732 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758943Ab2HHRKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 13:10:07 -0400
From: Kevin Hilman <khilman@ti.com>
To: Tarun Kanti DebBarma <tarun.kanti@ti.com>
Cc: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Rajendra Nayak <rnayak@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "Cousson\, Benoit" <b-cousson@ti.com>, Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH v2] gpio/omap: add *remove* callback in platform_driver
Organization: Texas Instruments, Inc.
References: <1344434316-21141-1-git-send-email-tarun.kanti@ti.com>
Date: Wed, 08 Aug 2012 10:10:07 -0700
In-Reply-To: <1344434316-21141-1-git-send-email-tarun.kanti@ti.com> (Tarun
	Kanti DebBarma's message of "Wed, 8 Aug 2012 19:28:36 +0530")
Message-ID: <87k3x9wbrk.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tarun Kanti DebBarma <tarun.kanti@ti.com> writes:

> Add *remove* callback so that necessary cleanup operations are
> performed when device is unregistered. The device is deleted
> from the list and associated clock handle is released by
> calling clk_put() and irq descriptor is released using the
> irq_free_desc() api.
>
> Signed-off-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>
> Reported-by: Paul Walmsley <paul@pwsan.com>
> Reviewed-by: Jon Hunter <jon-hunter@ti.com>
> Cc: Kevin Hilman <khilman@ti.com>
> Cc: Rajendra Nayak <rnayak@ti.com>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Cousson, Benoit <b-cousson@ti.com>
> Cc: Paul Walmsley <paul@pwsan.com>
> ---
> v2:
> Baseline: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> Commit: 0d7614f09c1ebdbaa1599a5aba7593f147bf96ee (Linux 3.6-rc1)
>
> (1) Use irq_free_descs() instead of irq_free_desc().
>     Besides, irq_free_desc() was using wrong parameter,
>     irq_base, instead of bank->irq.
> (2) irq_free_descs() moved outside spin_lock/unlock_*()
>     in order to avoid exception warnings.
>
> (3) pm_runtime_disable() added so that bind can happen successfully
>
> Test Detail:
> Step 1: Unbind gpio.5 device in order to invoke the *remove* callback.
> #echo "omap_gpio.5" > sys/bus/platform/drivers/omap_gpio/unbind
>
> Step 2: Bind gpio.5 device and confirm probe() for the device succeeds.
> #echo "omap_gpio.5" > sys/bus/platform/drivers/omap_gpio/bind
>
> Step 3: Execute read/write GPIO test case.

What happens when GPIOs are in use (requested)?   

Kevin

>  drivers/gpio/gpio-omap.c |   35 +++++++++++++++++++++++++++++++++++
>  1 files changed, 35 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
> index e6efd77..50de875 100644
> --- a/drivers/gpio/gpio-omap.c
> +++ b/drivers/gpio/gpio-omap.c
> @@ -1152,6 +1152,40 @@ static int __devinit omap_gpio_probe(struct platform_device *pdev)
>  	return ret;
>  }
>  
> +/**
> + * omap_gpio_remove - cleanup a registered gpio device
> + * @pdev:       pointer to current gpio platform device
> + *
> + * Called by driver framework whenever a gpio device is unregistered.
> + * GPIO is deleted from the list and associated clock handle freed.
> + */
> +static int __devexit omap_gpio_remove(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct gpio_bank *bank;
> +	unsigned long flags;
> +	int ret = -EINVAL;
> +
> +	list_for_each_entry(bank, &omap_gpio_list, node) {
> +		spin_lock_irqsave(&bank->lock, flags);
> +		if (bank->dev == dev) {
> +			clk_put(bank->dbck);
> +			list_del(&bank->node);
> +			ret = 0;
> +			spin_unlock_irqrestore(&bank->lock, flags);
> +			break;
> +		}
> +		spin_unlock_irqrestore(&bank->lock, flags);
> +	}
> +
> +	if (!ret) {
> +		pm_runtime_disable(bank->dev);
> +		irq_free_descs(bank->irq_base, bank->width);
> +	}
> +
> +	return ret;
> +}
> +
>  #ifdef CONFIG_ARCH_OMAP2PLUS
>  
>  #if defined(CONFIG_PM_RUNTIME)
> @@ -1478,6 +1512,7 @@ MODULE_DEVICE_TABLE(of, omap_gpio_match);
>  
>  static struct platform_driver omap_gpio_driver = {
>  	.probe		= omap_gpio_probe,
> +	.remove = __devexit_p(omap_gpio_remove),
>  	.driver		= {
>  		.name	= "omap_gpio",
>  		.pm	= &gpio_pm_ops,
