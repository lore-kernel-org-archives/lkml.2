Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759054Ab1FBAGh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 20:06:37 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:58477 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757000Ab1FBAGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 20:06:34 -0400
From: Kevin Hilman <khilman@ti.com>
To: Keshava Munegowda <keshava_mgowda@ti.com>
Cc: <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <balbi@ti.com>, <gadiyar@ti.com>,
        <sameo@linux.intel.com>, <parthab@india.ti.com>, <tony@atomide.com>,
        <b-cousson@ti.com>, <paul@pwsan.com>,
        Keshava Munegowda <Keshava_mgowda@ti.com>
Subject: Re: [PATCH 4/4] mfd: global Suspend and resume support of ehci and ohci
Organization: Texas Instruments, Inc.
References: <1306934847-6098-1-git-send-email-keshava_mgowda@ti.com>
	<1306934847-6098-2-git-send-email-keshava_mgowda@ti.com>
	<1306934847-6098-3-git-send-email-keshava_mgowda@ti.com>
	<1306934847-6098-4-git-send-email-keshava_mgowda@ti.com>
	<1306934847-6098-5-git-send-email-keshava_mgowda@ti.com>
Date: Wed, 01 Jun 2011 17:06:29 -0700
In-Reply-To: <1306934847-6098-5-git-send-email-keshava_mgowda@ti.com> (Keshava
	Munegowda's message of "Wed, 1 Jun 2011 18:57:27 +0530")
Message-ID: <87d3ix5c6y.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keshava Munegowda <keshava_mgowda@ti.com> writes:

> From: Keshava Munegowda <Keshava_mgowda@ti.com>
>
> The global suspend and resume functions for usbhs core driver
> are implemented.These routine are called when the global suspend
> and resume occurs. Before calling these functions, the
> bus suspend and resume of ehci and ohci drivers are called
> from runtime pm.
>
> Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>

First, from what I can see, this is only a partial implementation of
runtime PM.  What I mean is that the runtime PM methods are used only
during the suspend path.  The rest of the time the USB host IP block is
left enabled, even when nothing is connected.

I tested this on my 3530/Overo board, and verified that indeed the
usbhost powerdomain hits retention on suspend, but while idle, when
nothing is connected, I would expect the driver could be clever enough
to use runtime PM (probably using autosuspend timeouts) to disable the
hardware as well.

> ---
>  drivers/mfd/omap-usb-host.c |  103 +++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 103 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
> index 43de12a..32d19e2 100644
> --- a/drivers/mfd/omap-usb-host.c
> +++ b/drivers/mfd/omap-usb-host.c
> @@ -146,6 +146,10 @@
>  #define is_ehci_hsic_mode(x)	(x == OMAP_EHCI_PORT_MODE_HSIC)
>  
>  
> +/* USBHS state bits */
> +#define OMAP_USBHS_INIT		0
> +#define OMAP_USBHS_SUSPEND	4

These additional state bits don't seem to be necessary.

For suspend, just check 'pm_runtime_is_suspended()'

The init flag is only used in the suspend/resume hooks, but the need for
it is a side effect of not correctly using the runtime PM callbacks.

Remember that the runtime PM get/put hooks have usage counting.  Only
when the usage count transitions to/from zero is the actual
hardware-level enable/disable (via omap_hwmod) being done.   

The current code is making the assumption that every call to get/put is
going to result in an enable/disable of the hardware.

Instead, all of the code that needs to be run only upon actual
enable/disable of the hardware should be done in the driver's
runtime_suspend/runtime_resume callbacks.  These are only called when
the hardware actually changes state.   

Not knowing that much about the EHCI block, upon first glance, it looks
like mmuch of what is done in usbhs_enable() should actually be done in
the ->runtime_resume() callback, and similarily, much of what is done in
usbhs_disable() should be done in the ->runtime_suspend() callback.

Another thing to be aware of is that runtime PM can be disabled from
userspace.  For example, try this:

   echo on > /sys/devices/platform/omap/usbhs_omap/power/control

This disables runtime PM for the device.  After doing this and
suspending, you'll notice that usbhost powerdomain no longer hits
retention on suspend.  Setting it back to 'auto' allows it to work
again.

Because of this, you can not simply call pm_runtime_put() from the
static suspend callback.  You should check pm_runtime_is_suspended().
If it is, there's nothing to do.  If not, the runtime PM callbacks for
the subsystem need to manually be called.  See drivers/i2c/i2c-omap.c
for an example (and check the version in my PM branch, which has a fix
required starting with kernel v3.0.)

While I'm preaching on runtime PM here, some other things that should be
cleaned up because they duplicate what other frameworks are doing:

- drivers should not be touching their SYSCONFIG register.  This
  is managed by omap_hwmod
- current driver is doing usage counting, but runtime PM core is
  already handling usage counting.

My apologies for not reviewing the runtime PM work in this driver
earlier.  Some of the problems above come from code that's already in
mainline (which I should've reviewed earlier), and some are added with
this series.  All of them should be cleaned up before merging this.

Kevin

>  struct usbhs_hcd_omap {
>  	struct clk			*xclk60mhsp1_ck;
>  	struct clk			*xclk60mhsp2_ck;
> @@ -165,6 +169,7 @@ struct usbhs_hcd_omap {
>  	u32				usbhs_rev;
>  	spinlock_t			lock;
>  	int				count;
> +	unsigned long			state;
>  };
>  /*-------------------------------------------------------------------------*/
>  
> @@ -809,6 +814,8 @@ static int usbhs_enable(struct device *dev)
>  				(pdata->ehci_data->reset_gpio_port[1], 1);
>  	}
>  
> +	set_bit(OMAP_USBHS_INIT, &omap->state);
> +
>  end_count:
>  	omap->count++;
>  	spin_unlock_irqrestore(&omap->lock, flags);
> @@ -897,6 +904,7 @@ static void usbhs_disable(struct device *dev)
>  	}
>  
>  	pm_runtime_put_sync(dev);
> +	clear_bit(OMAP_USBHS_INIT, &omap->state);
>  
>  	/* The gpio_free migh sleep; so unlock the spinlock */
>  	spin_unlock_irqrestore(&omap->lock, flags);
> @@ -926,10 +934,105 @@ void omap_usbhs_disable(struct device *dev)
>  }
>  EXPORT_SYMBOL_GPL(omap_usbhs_disable);
>  
> +#ifdef	CONFIG_PM
> +
> +static int usbhs_resume(struct device *dev)
> +{
> +	struct usbhs_hcd_omap		*omap = dev_get_drvdata(dev);
> +	struct usbhs_omap_platform_data	*pdata = &omap->platdata;
> +	unsigned long			flags = 0;
> +
> +	dev_dbg(dev, "Resuming TI HSUSB Controller\n");
> +
> +	if (!pdata) {
> +		dev_dbg(dev, "missing platform_data\n");
> +		return  -ENODEV;
> +	}
> +
> +	spin_lock_irqsave(&omap->lock, flags);
> +
> +	if (!test_bit(OMAP_USBHS_INIT, &omap->state) ||
> +		!test_bit(OMAP_USBHS_SUSPEND, &omap->state))
> +			goto end_resume;
> +
> +	pm_runtime_get_sync(dev);
> +
> +	if (is_omap_usbhs_rev2(omap)) {
> +		if (is_ehci_tll_mode(pdata->port_mode[0])) {
> +			clk_enable(omap->usbhost_p1_fck);
> +			clk_enable(omap->usbtll_p1_fck);
> +		}
> +		if (is_ehci_tll_mode(pdata->port_mode[1])) {
> +			clk_enable(omap->usbhost_p2_fck);
> +			clk_enable(omap->usbtll_p2_fck);
> +		}
> +		clk_enable(omap->utmi_p1_fck);
> +		clk_enable(omap->utmi_p2_fck);
> +	}
> +	clear_bit(OMAP_USBHS_SUSPEND, &omap->state);
> +
> +end_resume:
> +	spin_unlock_irqrestore(&omap->lock, flags);
> +	return 0;
> +}
> +
> +
> +static int usbhs_suspend(struct device *dev)
> +{
> +	struct usbhs_hcd_omap		*omap = dev_get_drvdata(dev);
> +	struct usbhs_omap_platform_data	*pdata = &omap->platdata;
> +	unsigned long			flags = 0;
> +
> +	dev_dbg(dev, "Suspending TI HSUSB Controller\n");
> +
> +	if (!pdata) {
> +		dev_dbg(dev, "missing platform_data\n");
> +		return  -ENODEV;
> +	}
> +
> +	spin_lock_irqsave(&omap->lock, flags);
> +
> +	if (!test_bit(OMAP_USBHS_INIT, &omap->state) ||
> +		test_bit(OMAP_USBHS_SUSPEND, &omap->state))
> +			goto end_suspend;
> +
> +	if (is_omap_usbhs_rev2(omap)) {
> +		if (is_ehci_tll_mode(pdata->port_mode[0])) {
> +			clk_disable(omap->usbhost_p1_fck);
> +			clk_disable(omap->usbtll_p1_fck);
> +		}
> +		if (is_ehci_tll_mode(pdata->port_mode[1])) {
> +			clk_disable(omap->usbhost_p2_fck);
> +			clk_disable(omap->usbtll_p2_fck);
> +		}
> +		clk_disable(omap->utmi_p2_fck);
> +		clk_disable(omap->utmi_p1_fck);
> +	}
> +
> +	set_bit(OMAP_USBHS_SUSPEND, &omap->state);
> +	pm_runtime_put_sync(dev);
> +
> +end_suspend:
> +	spin_unlock_irqrestore(&omap->lock, flags);
> +	return 0;
> +}
> +
> +
> +static const struct dev_pm_ops usbhsomap_dev_pm_ops = {
> +	.suspend	= usbhs_suspend,
> +	.resume		= usbhs_resume,
> +};
> +
> +#define USBHS_OMAP_DEV_PM_OPS (&usbhsomap_dev_pm_ops)
> +#else
> +#define	USBHS_OMAP_DEV_PM_OPS	NULL
> +#endif
> +
>  static struct platform_driver usbhs_omap_driver = {
>  	.driver = {
>  		.name		= (char *)usbhs_driver_name,
>  		.owner		= THIS_MODULE,
> +		.pm		= USBHS_OMAP_DEV_PM_OPS,
>  	},
>  	.remove		= __exit_p(usbhs_omap_remove),
>  };
