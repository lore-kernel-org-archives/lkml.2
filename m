Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab2JRH3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 03:29:18 -0400
Received: from smtp2.goneo.de ([212.90.139.82]:52758 "EHLO smtp2.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab2JRH3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 03:29:17 -0400
X-Spam-Flag: NO
X-Spam-Score: -1.753
From: Lars Poeschel <poeschel@lemonage.de>
To: "Lars-Peter Clausen" <lars@metafoo.de>
Subject: Re: [PATCH v2 1/4] mfd: add viperboard driver
Date: Thu, 18 Oct 2012 09:29:08 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-amd64; KDE/4.8.4; x86_64; ; )
Cc: Lars Poeschel <larsi@wh2.tu-dresden.de>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, jic23@cam.ac.uk, khali@linux-fr.org,
        ben-linux@fluff.org, w.sang@pengutronix.de, grant.likely@secretlab.ca,
        linus.walleij@linaro.org
References: <20120925085559.GL28670@sortiz-mobl> <201210161143.19619.poeschel@lemonage.de> <507D3DE8.3040003@metafoo.de>
In-Reply-To: <507D3DE8.3040003@metafoo.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210180929.08509.poeschel@lemonage.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 October 2012 at 12:58:48, Lars-Peter Clausen wrote:
> On 10/16/2012 11:43 AM, Lars Poeschel wrote:
> > On Tuesday 16 October 2012 at 10:40:26, Lars-Peter Clausen wrote:
> >> On 10/12/2012 04:34 PM, Lars Poeschel wrote:
> >> Btw. I'm wondering why is the extra platform device required? Can't you
> >> not just use the usb device as the parent device for the mfd cells?
> > 
> > This is what I first did, but this does not work. You can read about my
> > first thoughts why this is not working here: (To sum it up: The device
> > is housed in an usb_device, not a platform_device and This usb_device
> > has no mfd_cell member.)
> > 
> > https://lkml.org/lkml/2012/9/28/327
> > 
> > As I got a bit more deeper I also noticed, that mfd_add_devices
> > (obviously) adds the devices "as childs" to the parent device.
> > mfd_remove_devices then removes ALL "child" devices from the parent, not
> > only those added by mfd_add_devices before. This does not work in the
> > case of the usb parent device, because it has other childs that the usb
> > layer added before (some endpoints and stuff). So I had to construct an
> > "empty" (in sense of childs) mock platform_device between the usb and
> > mfd.
> 
> Ah, ok that makes sense. I was a bit confused, because there are other mfd
> drivers with for example i2c or spi devices as parents and these work fine,
> but I guess this is because non of them registers any additional child
> devices. I guess it makes sense to create a mfd cell device type and assign
> this type to newly created mfd cells and only unregister a device in
> mfd_remove_devices if it has the correct device type.
> 
> E.g. something along the lines of:
> 
> 
> --- a/drivers/mfd/mfd-core.c
> +++ b/drivers/mfd/mfd-core.c
> @@ -21,6 +21,10 @@
>  #include <linux/irqdomain.h>
>  #include <linux/of.h>
> 
> +static struct device_type mfd_device_type = {
> +	.name = "mfd-cell",
> +};
> +
>  int mfd_cell_enable(struct platform_device *pdev)
>  {
>  	const struct mfd_cell *cell = mfd_get_cell(pdev);
> @@ -91,6 +95,7 @@ static int mfd_add_device(struct device *parent, int id,
>  		goto fail_device;
> 
>  	pdev->dev.parent = parent;
> +	pdev->dev.type = &mfd_device_type;
> 
>  	if (parent->of_node && cell->of_compatible) {
>  		for_each_child_of_node(parent->of_node, np) {
> @@ -204,10 +209,16 @@ EXPORT_SYMBOL(mfd_add_devices);
> 
>  static int mfd_remove_devices_fn(struct device *dev, void *c)
>  {
> -	struct platform_device *pdev = to_platform_device(dev);
> -	const struct mfd_cell *cell = mfd_get_cell(pdev);
> +	struct platform_device *pdev;
> +	const struct mfd_cell *cell;
>  	atomic_t **usage_count = c;
> 
> +	if (dev->type != &mfd_device_type)
> +		return 0;
> +
> +	pdev = to_platform_device(dev);
> +	cell = mfd_get_cell(pdev);
> +
>  	/* find the base address of usage_count pointers (for freeing) */
>  	if (!*usage_count || (cell->usage_count < *usage_count))
>  		*usage_count = cell->usage_count;

I thought about this and I am not fully happy with it:
If we add the mfd devices to the usb_interface parent they are at the same 
level in the device tree as the usb endpoints and stuff. I would consider this 
logically wrong.
Is this something we should take care of ?
