Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759139Ab0I0Q5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 12:57:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:14481 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752196Ab0I0Q5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 12:57:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,243,1283756400"; 
   d="scan'208";a="661583624"
Date: Mon, 27 Sep 2010 18:57:38 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Daniel Drake <dsd@laptop.org>
Cc: linux-kernel@vger.kernel.org, laforge@gnumonks.org
Subject: Re: [PATCH] Add VIA VX855 multi-function device support
Message-ID: <20100927165737.GJ2560@sortiz-mobl>
References: <20100919172301.91EEA9D401B@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100919172301.91EEA9D401B@zog.reactivated.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Sun, Sep 19, 2010 at 06:23:01PM +0100, Daniel Drake wrote:
> From: Harald Welte <laforge@gnumonks.org>
> 
> Initially we add support for the south bridge GPIO lines via GPIOLIB
> as well as some skeleton for the SPI controllers.
> 
> This hardware can be found in the OLPC XO-1.5 laptop.
Some comments below:

 
> +static int vx855_client_dev_register(struct vx855 *vg, const char *name,
> +				     struct platform_device **pdev)
> +{
> +	struct vx855_subdev_pdata *subdev_pdata;
> +	int ret;
> +
> +	*pdev = platform_device_alloc(name, -1);
> +	if (!*pdev) {
> +		dev_err(&vg->pdev->dev, "Failed to allocate pdev %s\n", name);
> +		return -ENOMEM;
> +	}
> +
> +	subdev_pdata = kmalloc(sizeof(*subdev_pdata), GFP_KERNEL);
> +	if (!subdev_pdata) {
> +		platform_device_put(*pdev);
> +		return -ENOMEM;
> +	}
> +
> +	subdev_pdata->vx855 = vg;
> +	(*pdev)->dev.platform_data = subdev_pdata;
> +	(*pdev)->dev.parent = &vg->pdev->dev;
> +
> +	ret = platform_device_add(*pdev);
> +	if (ret) {
> +		dev_err(&vg->pdev->dev, "Failed to register pdev %s\n", name);
> +		kfree(subdev_pdata);
> +		platform_device_put(*pdev);
> +		*pdev = NULL;
> +		return ret;
> +	}
> +
> +	return 0;
> +}
We do have an MFD API for registering sub devices as platform devices. See
mfd_add_devices(). You'd have to define cells (statically or not) and set the
cell->platform_data pointer properly. I'd prefer to see this driver using this
API.
You will also need to depend on MFD_CORE.

> +static __devinit int vx855gpio_probe(struct platform_device *pdev)
> +{
> +	struct vx855_gpio *vg;
> +	struct vx855_subdev_pdata *pdata = pdev->dev.platform_data;
> +	u_int16_t io_offset;
> +	int ret;
> +
> +	vg = kzalloc(sizeof(*vg), GFP_KERNEL);
> +	if (!vg)
> +		return -ENOMEM;
> +
> +	vg->vx855 = pdata->vx855;
> +	platform_set_drvdata(pdev, vg);
> +
> +	ret = pci_read_config_word(vg->vx855->pdev,
> +				   VX855_CFG_PMIO_OFFSET, &io_offset);
So it seems the only thing you need from the parent device is the I/O region.
If that really is the case then you may want to pass it from the actual MFD
driver as a platform resource (you do the pci_read_config_word() from the MFD
driver). The drivers/mfd/lcp_sch.c driver is a good example for that.
The benefit you get from that design is that your sub devices drivers are
completely independent from the parent one, they don't even have to share any
data structure, you could get rid of vx855.h.


> +	if (ret) {
> +		ret = -EIO;
> +		goto out_free;
> +	}
> +
> +	if (!io_offset) {
> +		dev_warn(&pdev->dev, "BIOS did not assign PMIO base offset?!?\n");
> +		ret = -ENODEV;
> +		goto out_free;
> +	}
> +
> +	/* mask out the lowest seven bits, as they are always zero, but
> +	 * hardware returns them as 0x01 */
> +	io_offset &= 0xff80;
> +	io_offset += VX855_PMIO_GPPM;
> +
> +	dev_info(&pdev->dev, "found VX855 PMIO at base 0x%x\n", io_offset);
> +
> +	vg->io_base = io_offset;
> +	spin_lock_init(&vg->lock);
> +
> +	/* Typically the ACPI code will already have requested this
> +	 * region, so we have to skip requesting it.  If you run a
> +	 * system without ACPI, you should enable VX855GPIO_REQUEST_REGION */
> +#ifdef VX855GPIO_REQUEST_REGION
Is this something you want to define in Kconfig ?


> +static int __init via_spi_probe(struct platform_device *pdev)
> +{
> +	struct vx855_subdev_pdata *pdata = pdev->dev.platform_data;
> +	struct via_spi *vspi;
> +	struct spi_master *master;
> +	u_int32_t ctrlreg;
> +	int err;
> +
> +	vspi = kzalloc(sizeof(*vspi), GFP_KERNEL);
> +	if (!vspi)
> +		return -ENOMEM;
> +
> +	vspi->vx855 = pdata->vx855;
> +	platform_set_drvdata(pdev, vspi);
> +
> +	/* First we determine the MMIO base of the control registers */
> +	pci_read_config_dword(vspi->vx855->pdev, 0xbc, &vspi->ctrl.mmio_base);
Same comment applies to this SPI driver, it seems the onyl thing it needs from
the parent is the MMIO base address.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
