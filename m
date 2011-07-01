Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354Ab1GARRx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 13:17:53 -0400
Received: from 50.23.254.54-static.reverse.softlayer.com ([50.23.254.54]:48092
	"EHLO softlayer.compulab.co.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754855Ab1GARRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 13:17:51 -0400
Message-ID: <4E0E0138.8060400@compulab.co.il>
Date: Fri, 01 Jul 2011 20:17:44 +0300
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en; rv:1.9.2.13) Gecko/20101211 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Christian Gmeiner <christian.gmeiner@gmail.com>
CC: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca
Subject: Re: pca953x: support working w/o platform data
References: <BANLkTimSkDEzPvRMmX1O0YjjpoPzQt6_+w@mail.gmail.com>
In-Reply-To: <BANLkTimSkDEzPvRMmX1O0YjjpoPzQt6_+w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/11 14:33, Christian Gmeiner wrote:

> Provide defaults for pca953x, so the driver can be used w/o
> providing platform data.

Wouldn't it be better to provide a default pdata structure inside the driver
and use it in case no pdata supplied, so you will not have to patch the
driver all around checking each time if pdata is valid?

> Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
> ---
>  pca953x.c |   21 +++++++++++----------
>  1 file changed, 11 insertions(+), 10 deletions(-)
> diff -Nur linux-3.0-rc5/drivers/gpio//pca953x.c
> linux-3.0-rc5__patched/drivers/gpio//pca953x.c
> --- linux-3.0-rc5/drivers/gpio//pca953x.c	2011-06-28 04:12:22.000000000 +0200
> +++ linux-3.0-rc5__patched/drivers/gpio//pca953x.c	2011-07-01
> 13:19:08.369130336 +0200
> @@ -452,7 +452,7 @@
>  	struct pca953x_platform_data *pdata = client->dev.platform_data;
>  	int ret, offset = 0;
>
> -	if (pdata->irq_base != -1
> +	if (pdata && pdata->irq_base != -1
>  			&& (id->driver_data & PCA_INT)) {
>  		int lvl;
>
> @@ -524,7 +524,7 @@
>  	struct i2c_client *client = chip->client;
>  	struct pca953x_platform_data *pdata = client->dev.platform_data;
>
> -	if (pdata->irq_base != -1 && (id->driver_data & PCA_INT))
> +	if (pdata && pdata->irq_base != -1 && (id->driver_data & PCA_INT))
>  		dev_warn(&client->dev, "interrupt support not compiled in\n");
>
>  	return 0;
> @@ -643,6 +643,7 @@
>  	struct pca953x_platform_data *pdata;
>  	struct pca953x_chip *chip;
>  	int ret = 0;
> +	int invert = 0;
>
>  	chip = kzalloc(sizeof(struct pca953x_chip), GFP_KERNEL);
>  	if (chip == NULL)
> @@ -660,15 +661,13 @@
>
>  	if (pdata == NULL) {
>  		dev_dbg(&client->dev, "no platform data\n");
> -		ret = -EINVAL;
> -		goto out_failed;
>  	}
>
>  	chip->client = client;
>
> -	chip->gpio_start = pdata->gpio_base;
> +	chip->gpio_start = pdata ? pdata->gpio_base : -1;
>
> -	chip->names = pdata->names;
> +	chip->names = pdata ? pdata->names : NULL;
>  	chip->chip_type = id->driver_data & (PCA953X_TYPE | PCA957X_TYPE);
>
>  	mutex_init(&chip->i2c_lock);
> @@ -678,10 +677,12 @@
>  	 */
>  	pca953x_setup_gpio(chip, id->driver_data & PCA_GPIO_MASK);
>
> +	invert = pdata ? pdata->invert : 0;
> +
>  	if (chip->chip_type == PCA953X_TYPE)
> -		device_pca953x_init(chip, pdata->invert);
> +		device_pca953x_init(chip, invert);
>  	else if (chip->chip_type == PCA957X_TYPE)
> -		device_pca957x_init(chip, pdata->invert);
> +		device_pca957x_init(chip, invert);
>  	else
>  		goto out_failed;
>
> @@ -693,7 +694,7 @@
>  	if (ret)
>  		goto out_failed_irq;
>
> -	if (pdata->setup) {
> +	if (pdata && pdata->setup) {
>  		ret = pdata->setup(client, chip->gpio_chip.base,
>  				chip->gpio_chip.ngpio, pdata->context);
>  		if (ret < 0)
> @@ -717,7 +718,7 @@
>  	struct pca953x_chip *chip = i2c_get_clientdata(client);
>  	int ret = 0;
>
> -	if (pdata->teardown) {
> +	if (pdata && pdata->teardown) {
>  		ret = pdata->teardown(client, chip->gpio_chip.base,
>  				chip->gpio_chip.ngpio, pdata->context);
>  		if (ret < 0) {
> ---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

-- 
Regards,
Igor.

