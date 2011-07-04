Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab1GDGnx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 02:43:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38863 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab1GDGnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 02:43:51 -0400
Date: Mon, 4 Jul 2011 00:43:47 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Igor Grinberg <grinberg@compulab.co.il>
Cc: Christian Gmeiner <christian.gmeiner@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: pca953x: support working w/o platform data
Message-ID: <20110704064347.GL15152@ponder.secretlab.ca>
References: <BANLkTimSkDEzPvRMmX1O0YjjpoPzQt6_+w@mail.gmail.com>
 <4E0E0138.8060400@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E0E0138.8060400@compulab.co.il>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 01, 2011 at 08:17:44PM +0300, Igor Grinberg wrote:
> On 07/01/11 14:33, Christian Gmeiner wrote:
> 
> > Provide defaults for pca953x, so the driver can be used w/o
> > providing platform data.
> 
> Wouldn't it be better to provide a default pdata structure inside the driver
> and use it in case no pdata supplied, so you will not have to patch the
> driver all around checking each time if pdata is valid?

I would agree.  However, you will need to adjust the structure of the
driver somewhat to do so.  Once a device is registered, the data
pointed to by platform_device->dev.platform_data must be treated as
immutable by the driver, otherwise driver unbind/rebind can become
horribly broken.

I often solve this by keeping a full copy of the pdata structure in
the driver's private data structure, and always referencing the 'safe'
local copy instead of dereferencing dev->platform_data every time.

g.

> 
> > Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
> > ---
> >  pca953x.c |   21 +++++++++++----------
> >  1 file changed, 11 insertions(+), 10 deletions(-)
> > diff -Nur linux-3.0-rc5/drivers/gpio//pca953x.c
> > linux-3.0-rc5__patched/drivers/gpio//pca953x.c
> > --- linux-3.0-rc5/drivers/gpio//pca953x.c	2011-06-28 04:12:22.000000000 +0200
> > +++ linux-3.0-rc5__patched/drivers/gpio//pca953x.c	2011-07-01
> > 13:19:08.369130336 +0200
> > @@ -452,7 +452,7 @@
> >  	struct pca953x_platform_data *pdata = client->dev.platform_data;
> >  	int ret, offset = 0;
> >
> > -	if (pdata->irq_base != -1
> > +	if (pdata && pdata->irq_base != -1
> >  			&& (id->driver_data & PCA_INT)) {
> >  		int lvl;
> >
> > @@ -524,7 +524,7 @@
> >  	struct i2c_client *client = chip->client;
> >  	struct pca953x_platform_data *pdata = client->dev.platform_data;
> >
> > -	if (pdata->irq_base != -1 && (id->driver_data & PCA_INT))
> > +	if (pdata && pdata->irq_base != -1 && (id->driver_data & PCA_INT))
> >  		dev_warn(&client->dev, "interrupt support not compiled in\n");
> >
> >  	return 0;
> > @@ -643,6 +643,7 @@
> >  	struct pca953x_platform_data *pdata;
> >  	struct pca953x_chip *chip;
> >  	int ret = 0;
> > +	int invert = 0;
> >
> >  	chip = kzalloc(sizeof(struct pca953x_chip), GFP_KERNEL);
> >  	if (chip == NULL)
> > @@ -660,15 +661,13 @@
> >
> >  	if (pdata == NULL) {
> >  		dev_dbg(&client->dev, "no platform data\n");
> > -		ret = -EINVAL;
> > -		goto out_failed;
> >  	}
> >
> >  	chip->client = client;
> >
> > -	chip->gpio_start = pdata->gpio_base;
> > +	chip->gpio_start = pdata ? pdata->gpio_base : -1;
> >
> > -	chip->names = pdata->names;
> > +	chip->names = pdata ? pdata->names : NULL;
> >  	chip->chip_type = id->driver_data & (PCA953X_TYPE | PCA957X_TYPE);
> >
> >  	mutex_init(&chip->i2c_lock);
> > @@ -678,10 +677,12 @@
> >  	 */
> >  	pca953x_setup_gpio(chip, id->driver_data & PCA_GPIO_MASK);
> >
> > +	invert = pdata ? pdata->invert : 0;
> > +
> >  	if (chip->chip_type == PCA953X_TYPE)
> > -		device_pca953x_init(chip, pdata->invert);
> > +		device_pca953x_init(chip, invert);
> >  	else if (chip->chip_type == PCA957X_TYPE)
> > -		device_pca957x_init(chip, pdata->invert);
> > +		device_pca957x_init(chip, invert);
> >  	else
> >  		goto out_failed;
> >
> > @@ -693,7 +694,7 @@
> >  	if (ret)
> >  		goto out_failed_irq;
> >
> > -	if (pdata->setup) {
> > +	if (pdata && pdata->setup) {
> >  		ret = pdata->setup(client, chip->gpio_chip.base,
> >  				chip->gpio_chip.ngpio, pdata->context);
> >  		if (ret < 0)
> > @@ -717,7 +718,7 @@
> >  	struct pca953x_chip *chip = i2c_get_clientdata(client);
> >  	int ret = 0;
> >
> > -	if (pdata->teardown) {
> > +	if (pdata && pdata->teardown) {
> >  		ret = pdata->teardown(client, chip->gpio_chip.base,
> >  				chip->gpio_chip.ngpio, pdata->context);
> >  		if (ret < 0) {
> > ---
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
> -- 
> Regards,
> Igor.
> 
