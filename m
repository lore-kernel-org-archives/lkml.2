Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab2BWQTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 11:19:18 -0500
Received: from mga11.intel.com ([192.55.52.93]:24218 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753782Ab2BWQTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 11:19:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="120575101"
Date: Thu, 23 Feb 2012 17:19:14 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        alan@linux.intel.com, grant.likely@secretlab.ca,
        linus.walleij@stericsson.com
Subject: Re: [PATCH V2 1/2] mfd: Add driver for STA2X11 MFD block
Message-ID: <20120223161914.GJ24377@sortiz-mobl>
References: <cover.1329396583.git.rubini@gnudd.com>
 <8f360fc42e201ccc0ab64aa73ffe9671c9b8963f.1329396583.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f360fc42e201ccc0ab64aa73ffe9671c9b8963f.1329396583.git.rubini@gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alessandro,

A few minor comments, since it seems you're going to re-spin this one:

On Thu, Feb 16, 2012 at 02:00:40PM +0100, Alessandro Rubini wrote:
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -830,6 +830,12 @@ config MFD_INTEL_MSIC
>  	  Passage) chip. This chip embeds audio, battery, GPIO, etc.
>  	  devices used in Intel Medfield platforms.
>  
> +config MFD_STA2X11
> +	bool "STA2X11 multi function device support"
> +	depends on STA2X11
> +	select MFD_CORE
> +	select GPIO_STA2X11
I think it's better to have your GPIO driver depend on MFD_STA2X11. With the
above code, you could end up trying to build your GPIO driver with GPIOLIB not
being selected.


> +/*
> + * What follows is the PCI device that hosts the above two pdevs.
> + * Each logic block is 4kB and they are all consecutive: we use this info.
> + */
> +
> +/* Bar 0 */
> +enum bar0_cells {
> +	GPIO_0 = 0,
> +	GPIO_1,
> +	GPIO_2,
> +	GPIO_3,
> +	SCTL,
> +	SCR,
> +	TIME,
As Linus said, I'd protect that with a namespace.


> +static int __devinit sta2x11_mfd_probe(struct pci_dev *pdev,
> +				       const struct pci_device_id *pci_id)
> +{
> +	int err, i;
> +	struct sta2x11_gpio_pdata *gpio_data;
> +
> +	dev_info(&pdev->dev, "%s\n", __func__);
> +
> +	err = pci_enable_device(pdev);
> +	if (err) {
> +		dev_err(&pdev->dev, "Can't enable device.\n");
> +		return err;
> +	}
> +
> +	err = pci_enable_msi(pdev);
> +	if (err)
> +		dev_info(&pdev->dev, "Enable msi failed\n");
> +
> +	/* Read gpio config data as pci device's platform data */
> +	gpio_data = dev_get_platdata(&pdev->dev);
> +	if (!gpio_data)
> +		dev_warn(&pdev->dev, "no gpio configuration\n");
> +
> +#if 1
> +	dev_dbg(&pdev->dev, "%s, gpio_data = %p (%p)\n", __func__,
> +		gpio_data, &gpio_data);
> +#endif
You can get rid of the #if #endif here.


> +	dev_dbg(&pdev->dev, "%s, pdev = %p (%p)\n", __func__,
> +		pdev, &pdev);
> +
Extra line here


> +	/* platform data is the pci device for all of them */
> +	for (i = 0; i < ARRAY_SIZE(sta2x11_mfd_bar0); i++) {
> +		sta2x11_mfd_bar0[i].pdata_size = sizeof(pdev);
> +		sta2x11_mfd_bar0[i].platform_data = &pdev;
> +	}
> +	sta2x11_mfd_bar1[0].pdata_size = sizeof(pdev);
> +	sta2x11_mfd_bar1[0].platform_data = &pdev;
> +
> +	/* Record this pdev before mfd_add_devices: their probe looks for it */
> +	sta2x11_mfd_add(pdev, GFP_ATOMIC);
> +
> +
> +	err = mfd_add_devices(&pdev->dev, -1,
> +			      sta2x11_mfd_bar0,
> +			      ARRAY_SIZE(sta2x11_mfd_bar0),
> +			      &pdev->resource[0],
> +			      0);
> +	if (err) {
> +		dev_err(&pdev->dev, "mfd_add_devices[0] failed: %d\n", err);
> +		goto err_disable;
> +	}
> +
> +	err = mfd_add_devices(&pdev->dev, -1,
> +			      sta2x11_mfd_bar1,
> +			      ARRAY_SIZE(sta2x11_mfd_bar1),
> +			      &pdev->resource[1],
> +			      0);
> +	if (err) {
> +		dev_err(&pdev->dev, "mfd_add_devices[1] failed: %d\n", err);
> +		goto err_disable;
> +	}
> +
> +	return 0;
> +
> +err_disable:
> +	pci_disable_device(pdev);
> +	pci_disable_msi(pdev);
> +	/* mfd_remove(pdev); -- it is in an exit section, I can't call it */
Why can't you call mfd_remove_devices() here ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
