Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab1AXOWW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 09:22:22 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:58974 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025Ab1AXOWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 09:22:21 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: "'Jean Delvare'" <khali@linux-fr.org>
Cc: <ben-linux@fluff.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <01d101cbba22$d8071bb0$88155310$@mprc.pku.edu.cn> <20110124101843.5041be6e@endymion.delvare>
In-Reply-To: <20110124101843.5041be6e@endymion.delvare>
Subject: RE: [PATCH] unicore32: add i2c bus driver for PKUnity SoC
Date: Mon, 24 Jan 2011 22:21:44 +0800
Message-ID: <010001cbbbd2$08310e30$18932a90$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
thread-index: AQLkRk+FtgtRnvkCwqzS1+SxEy2puQHnuihzkZ/MXfA=
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jean Delvare [mailto:khali@linux-fr.org]
> Sent: Monday, January 24, 2011 5:19 PM
> To: Guan Xuetao
> Cc: ben-linux@fluff.org; linux-i2c@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] unicore32: add i2c bus driver for PKUnity SoC
> 
> Hi Guan,
> 
> On Sat, 22 Jan 2011 18:55:09 +0800, Guan Xuetao wrote:
> > From: Guan Xuetao <gxt@mprc.pku.edu.cn>
> >
> > This patch adds framebuffer driver for unigfx engine in PKUnity SoC.
> 
> While I don't have the time for a full review, I would like to at least
> sort out the integration issues. Framebuffer driver, really? I doubt
> it. If this is a copy-and-paste mistake, and this is actually an I2C
> system bus driver, you will have to change the driver name (see below.)
> If what you actually meant is that this is a driver for the I2C/DDC
> channels on a graphics chip, then you have to move this driver to the
> same directory the framebuffer driver lives in, as all other
> framebuffer drivers do.
Yes, it's an I2C system bus driver. Sorry for my mistake.

> 
> > Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
> > ---
> >  drivers/i2c/busses/Kconfig    |    5 +
> >  drivers/i2c/busses/Makefile   |    1 +
> >  drivers/i2c/busses/puv3_i2c.c |  300 +++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 306 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> > index 3a6321c..20d328c 100644
> > --- a/drivers/i2c/busses/Kconfig
> > +++ b/drivers/i2c/busses/Kconfig
> > @@ -236,6 +236,11 @@ config I2C_VIAPRO
> >  	  This driver can also be built as a module.  If so, the module
> >  	  will be called i2c-viapro.
> >
> > +config I2C_PUV3
> > +	tristate "PKUnity v3 I2C bus support"
> > +	depends on I2C && UNICORE32 && ARCH_PUV3
> 
> The whole menu depends on I2C, so you don't have to repeat it.
Ok.

> 
> > +	select I2C_ALGOBIT
> 
> Where is the description of what the driver is for? All other entries
> have it, yours is no exception.
A description block is added.

> > diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
> > index 84cb16a..cb4a097 100644
> > --- a/drivers/i2c/busses/Makefile
> > +++ b/drivers/i2c/busses/Makefile
> > @@ -61,6 +61,7 @@ obj-$(CONFIG_I2C_STU300)	+= i2c-stu300.o
> >  obj-$(CONFIG_I2C_VERSATILE)	+= i2c-versatile.o
> >  obj-$(CONFIG_I2C_OCTEON)	+= i2c-octeon.o
> >  obj-$(CONFIG_I2C_XILINX)	+= i2c-xiic.o
> > +obj-$(CONFIG_I2C_PUV3)		+= puv3_i2c.o
> 
> Assuming that this is the right place for your driver, then the name is
> NOT correct. As you can see, all drivers are names i2c-*, so your
> driver should be too. And the it should be inserted in alphabetical
> order.
Ok.

> 
> See also my comments below related to the probe() and remove()
> functions.
> 
> >
> >  # External I2C/SMBus adapter drivers
> >  obj-$(CONFIG_I2C_PARPORT)	+= i2c-parport.o
> > diff --git a/drivers/i2c/busses/puv3_i2c.c b/drivers/i2c/busses/puv3_i2c.c
> > +
> > +static int i2c_reg = -1;
> 
> Please allocate and use per-device data structure for device state
> tracking. Global variables are evil (for this use case at least.)
Yes, i2c_reg is replaced by local variables.

> > +
> > +/*
> > + * Main initialization routine.
> > + */
> > +static int __devinit puv3_i2c_probe(struct platform_device *pdev)
> > +{
> > +	struct i2c_adapter *adapter;
> > +	struct resource *res;
> > +	int rc;
> > +
> > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	if (!res)
> > +		return -ENXIO;
> 
> -ENODEV would seem more appropriate.
Ok.

> > +	adapter = kzalloc(sizeof(struct i2c_adapter), GFP_KERNEL);
> > +	if (adapter == NULL) {
> > +		dev_err(&pdev->dev, "can't allocate inteface!\n");
> > +		rc = -ENOMEM;
> > +		goto fail2;
> > +	}
> > +	snprintf(adapter->name, sizeof(adapter->name), "PUV3");
> 
> Please include some uniqueness in the name. The address of the mem
> region would be a good candidate:
> 
> 	snprintf(adapter->name, sizeof(adapter->name), "PUV3 at 0x%08x",
> 		 res->start);
> 
> This lets user-space differentiate between the adapters if there are
> more than one.
Ok.

> > +
> > +	platform_set_drvdata(pdev, adapter);
> > +
> > +	rc = i2c_add_numbered_adapter(adapter);
> 
> You can't call i2c_add_numbered_adapter() if you haven't set
> adapter->nr first.
Corrected.

> 
> > +	if (rc) {
> > +		dev_err(&pdev->dev, "Adapter %s registration failed\n",
> > +				adapter->name);
> 
> Quotes around %s would be welcome.
Ok.

> 
> > +		goto fail3;
> > +	}
> > +
> > +	dev_info(&pdev->dev, "PKUnity v3 i2c bus driver.\n");
> 
> Wrong message. You have just registered a device, not a driver.
Corrected.

> 
> > +	return 0;
> > +
> > +fail3:
> 
> Please use descriptive labels, otherwise it's easy to mess up and jump
> to the wrong one.
Ok.

> 
> > +	platform_set_drvdata(pdev, NULL);
> > +	kfree(adapter);
> > +fail2:
> > +	release_mem_region(res->start, resource_size(res));
> > +
> > +	return rc;
> > +}
> > +
> > +static int puv3_i2c_remove(struct platform_device *pdev)
> 
> Missing __devexit.
Added.

> 
> > +{
> > +	struct i2c_adapter *adapter = platform_get_drvdata(pdev);
> > +	struct resource *res;
> > +	int rc;
> > +
> > +	rc = i2c_del_adapter(adapter);
> > +	platform_set_drvdata(pdev, NULL);
> > +
> > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	release_mem_region(res->start, resource_size(res));
> > +
> > +	return rc;
> 
> The logic in this function doesn't make sense. If i2c_del_adapter()
> fails, you must exit immediately. Freeing the resources while the
> adapter is still registered can only lead to a crash.
> 
> Additionally, you are leaking memory in the success case, as adapter is
> never freed.
Above two are corrected.

> 
> --
> Jean Delvare

Thanks Jean.

Guan Xuetao

