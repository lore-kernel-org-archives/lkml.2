Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376Ab2H1KZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 06:25:21 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42510 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744Ab2H1KZT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 06:25:19 -0400
From: "Patil, Rachna" <rachna@ti.com>
To: Matthias Kaehlcke <matthias.list@kaehlcke.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Jonathan Cameron <jic23@cam.ac.uk>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: RE: [PATCH 2/5] MFD: ti_tscadc: Add support for TI's TSC/ADC
 MFDevice
Thread-Topic: [PATCH 2/5] MFD: ti_tscadc: Add support for TI's TSC/ADC
 MFDevice
Thread-Index: AQHNgR9K8DmVvSZm4k+XL7TPEqDyqZdnYVWAgAeqykA=
Date: Tue, 28 Aug 2012 10:25:04 +0000
Message-ID: <4CE347531D4CA947960AF71FF095B9323E94FA2D@DBDE01.ent.ti.com>
References: <1345718997-18304-1-git-send-email-rachna@ti.com>
 <20120823184830.GE27787@darwin>
In-Reply-To: <20120823184830.GE27787@darwin>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Aug 24, 2012 at 00:18:31, Matthias Kaehlcke wrote:
> Hi,
> 
> El Thu, Aug 23, 2012 at 04:19:57PM +0530 Patil, Rachna ha dit:
> 
> > Add the mfd core driver which supports touchscreen and ADC.
> > With this patch we are only adding infrastructure to support the MFD 
> > clients.
> > 
> > Signed-off-by: Patil, Rachna <rachna@ti.com>
> > ---
> > diff --git a/drivers/mfd/ti_tscadc.c b/drivers/mfd/ti_tscadc.c ...
> > +static	int __devinit ti_tscadc_probe(struct platform_device *pdev)
> > +{
> > +	struct ti_tscadc_dev		*tscadc;
> > +	int				err, ctrl;
> > +	int				clk_value, clock_rate;
> > +	struct resource			*res;
> > +	struct clk			*clk;
> > +
> > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	if (!res) {
> > +		dev_err(&pdev->dev, "no memory resource defined.\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	/* Allocate memory for device */
> > +	tscadc = kzalloc(sizeof(struct ti_tscadc_dev), GFP_KERNEL);
> > +	if (!tscadc) {
> > +		dev_err(&pdev->dev, "failed to allocate memory.\n");
> > +		return -ENOMEM;
> > +	}
> > +
> > +	res = request_mem_region(res->start, resource_size(res), pdev->name);
> > +	if (!res) {
> > +		dev_err(&pdev->dev, "failed to reserve registers.\n");
> > +		err = -EBUSY;
> > +		goto err_free_mem;
> > +	}
> > +
> > +	tscadc->tscadc_base = ioremap(res->start, resource_size(res));
> > +	if (!tscadc->tscadc_base) {
> > +		dev_err(&pdev->dev, "failed to map registers.\n");
> > +		err = -ENOMEM;
> > +		goto err_release_mem;
> > +	}
> > +
> > +	tscadc->irq = platform_get_irq(pdev, 0);
> > +	if (tscadc->irq < 0) {
> > +		dev_err(&pdev->dev, "no irq ID is specified.\n");
> > +		return -ENODEV;
> 
> goto err_iounmap_mem;

Yes. Will add this.

> 
> > ...
> > +err_fail:
> > +	pm_runtime_put_sync(&pdev->dev);
> > +	pm_runtime_disable(&pdev->dev);
> > +	iounmap(tscadc->tscadc_base);
> > +err_release_mem:
> > +	release_mem_region(res->start, resource_size(res));
> > +	mfd_remove_devices(tscadc->dev);
> > +err_free_mem:
> > +	platform_set_drvdata(pdev, NULL);
> 
> shouldn't be necessary as the platform device doesn't exist any longer

Ok. Will remove this.

> 
> > ...
> > +static int __devexit ti_tscadc_remove(struct platform_device *pdev) {
> > +	struct ti_tscadc_dev	*tscadc = platform_get_drvdata(pdev);
> > +	struct resource		*res;
> > +
> > +	tscadc_writel(tscadc, REG_SE, 0x00);
> > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	iounmap(tscadc->tscadc_base);
> > +	release_mem_region(res->start, resource_size(res));
> > +
> > +	pm_runtime_put_sync(&pdev->dev);
> > +	pm_runtime_disable(&pdev->dev);
> > +
> > +	mfd_remove_devices(tscadc->dev);
> > +	kfree(tscadc);
> > +
> > +	platform_set_drvdata(pdev, NULL);
> 
> same as above

Will correct this as well.

> 
> best regards
> 
> --
> Matthias Kaehlcke
> Embedded Linux Developer
> Amsterdam
> 
>          The only way to do great work is to love what you do
>                             (Steve Jobs)
>                                                                  .''`.
>     using free software / Debian GNU/Linux | http://debian.org  : :'  :
>                                                                 `. `'`
> gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
> 

Thanks & Regards,
Rachna
