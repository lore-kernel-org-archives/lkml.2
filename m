Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab2EZInn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 04:43:43 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45795 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab2EZInj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 04:43:39 -0400
Date: Sat, 26 May 2012 09:43:28 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org, Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>, x86@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 6/6] serial: add amba-pl011-pci
Message-ID: <20120526084328.GE24149@n2100.arm.linux.org.uk>
References: <cover.1337959750.git.rubini@gnudd.com> <b166cb0fce2a67b24da5808604553b4196258f45.1337959750.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b166cb0fce2a67b24da5808604553b4196258f45.1337959750.git.rubini@gnudd.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 05:48:57PM +0200, Alessandro Rubini wrote:
> diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
> index 070b442..e5e5ef6 100644
> --- a/drivers/tty/serial/Kconfig
> +++ b/drivers/tty/serial/Kconfig
> @@ -39,14 +39,22 @@ config SERIAL_AMBA_PL010_CONSOLE
>  config SERIAL_AMBA_PL011
>  	tristate "ARM AMBA PL011 serial port support"
>  	depends on ARM_AMBA
> +	default y if STA2X11

I don't think we want to encourage an ever growing list of platforms
here.  If we did this on ARM, this would be hellishly long.

> +/* This is a template, copied every time a new pci device appears */
> +static AMBA_APB_DEVICE(pl011_pci_template, "pl011-pci", 0,
> +		       0 /* base */, {0} /* irqs */, NULL /* data */);
> +
> +static int __devinit pl011_pci_probe(struct pci_dev *pdev,
> +				     const struct pci_device_id *id)
> +{
> +	struct amba_device *adev;
> +	struct amba_pl011_data *data;
> +	int ret;
> +
> +	/* Simply build an amba device and register it */
> +	adev = kmemdup(&pl011_pci_template_device,
> +			 sizeof(pl011_pci_template_device), GFP_KERNEL);

NAK.  We have interfaces in the AMBA code for dynamically allocating
AMBA devices now - please use them instead of coding your own.  They
avoid bugs.

> +	/* change name */
> +	adev->dev.init_name = kasprintf(GFP_ATOMIC, "pl011-pci-%02x:%04x",
> +				       pdev->bus->number, pdev->devfn);
> +
> +	printk(KERN_INFO "%s %i\n", __func__, __LINE__);

This looks like debugging.

> +	if ((ret = amba_device_register(adev, &pdev->resource[0])) < 0) {
> +		kfree(adev);
> +		return ret;
> +	}
> +	return 0;
> +};
> +
> +static void __devexit pl011_pci_remove(struct pci_dev *pdev)
> +{
> +	struct amba_device *adev = pci_get_drvdata(pdev);
> +	amba_device_unregister(adev);
> +	kfree(adev->dev.platform_data);
> +	kfree(adev);

This comes nowhere close to being sane with the driver model.  This is
an oops waiting to happen.  You can't guarantee that 'adev' will be
unused by the time amba_device_unregister() (or in fact any such call
into the driver model) returns.

This is because these suckers (and all devices) are refcounted.  If you
use the correct interfaces, the devices will be freed for you automatically
at the correct time.

The only thing that won't be is adev->dev.platform_data - the correct way
to do this is the following along with the correct allocation interfaces:

	struct amba_device *adev = pci_get_drvdata(pdev);
	void *priv = adev->dev.platform_data;

	amba_device_unregister(adev);
	kfree(priv);

In other words, save off the platform data pointer, unregister the struct
device, and then free the platform data (it will not be used at that point.)
