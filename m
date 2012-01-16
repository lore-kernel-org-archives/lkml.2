Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033Ab2APWLd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 17:11:33 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:47237 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751245Ab2APWLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 17:11:32 -0500
Message-ID: <4F14A06F.90507@metafoo.de>
Date: Mon, 16 Jan 2012 23:10:55 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Peter Meerwald <pmeerw@pmeerw.net>
CC: linux-kernel@vger.kernel.org, rpurdie@rpsys.net, akpm@linux-foundation.org
Subject: Re: [PATCH] leds: add driver for PCA9663 I2C chip
References: <1326747861-10874-1-git-send-email-pmeerw@pmeerw.net>
In-Reply-To: <1326747861-10874-1-git-send-email-pmeerw@pmeerw.net>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2012 10:04 PM, Peter Meerwald wrote:
> From: Peter Meerwald <p.meerwald@bct-electronic.com>
> 
> simple driver for the PCA9633 I2C chip supporting four LEDs and
> 255 brightness levels


Looks good, just a few minor issues.

> 
> ---
>  drivers/leds/Kconfig        |    8 ++
>  drivers/leds/Makefile       |    1 +
>  drivers/leds/leds-pca9633.c |  219 +++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 228 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/leds/leds-pca9633.c
> [...]
> diff --git a/drivers/leds/leds-pca9633.c b/drivers/leds/leds-pca9633.c
> new file mode 100644
> index 0000000..68c30d7
> --- /dev/null
> +++ b/drivers/leds/leds-pca9633.c
> @@ -0,0 +1,219 @@
> +/*
> + * Copyright 2011 bct electronic GmbH
> + *
> + * Author: Peter Meerwald <p.meerwald@bct-electronic.com>
> + *
> + * Based on leds-pca955x.c
> + *
> + * This file is subject to the terms and conditions of version 2 of
> + * the GNU General Public License.  See the file COPYING in the main
> + * directory of this archive for more details.
> + *
> + * LED driver for the PCA9633 I2C LED driver (7-bit slave address 0x62)
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/delay.h>
> +#include <linux/string.h>
> +#include <linux/ctype.h>
> +#include <linux/leds.h>
> +#include <linux/err.h>
> +#include <linux/i2c.h>
> +#include <linux/workqueue.h>
> +#include <linux/slab.h>
> +
> +/* LED select registers determine the source that drives LED outputs */
> +#define PCA9633_LED_OFF		0x0	/* LED driver off */
> +#define PCA9633_LED_ON		0x1	/* LED driver on */
> +#define PCA9633_LED_PWM		0x2	/* Controlled through PWM */
> +#define PCA9633_LED_GRP_PWM	0x3	/* Controlled through PWM/GRPPWM */
> +
> +#define PCA9633_MODE1		0x00
> +#define PCA9633_MODE2		0x01
> +#define PCA9633_PWM_BASE	0x02
> +#define PCA9633_LEDOUT		0x08
> +
> +static const struct i2c_device_id pca9633_id[] = {
> +	{ "pca9633", 0 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, pca9633_id);
> +
> +struct pca9633_led {
> +	struct i2c_client *client;
> +	struct work_struct work;
> +	spinlock_t lock;
> +	enum led_brightness brightness;
> +	struct led_classdev led_cdev;
> +	int led_num; /* 0 .. 3 potentially */
> +	char name[32];
> +};
> +
> +static void pca9633_led_work(struct work_struct *work)
> +{
> +	struct pca9633_led *pca9633 = container_of(work,
> +		struct pca9633_led, work);
> +
> +	u8 ledout = i2c_smbus_read_byte_data(pca9633->client, PCA9633_LEDOUT);
> +	int shift = 2 * pca9633->led_num;
> +	u8 mask = 0x3 << shift;
> +
> +	switch (pca9633->brightness) {

Using led_cdev.brightness should work as well.

> +	case LED_FULL:
> +		i2c_smbus_write_byte_data(pca9633->client, PCA9633_LEDOUT,
> +			(ledout & ~mask) | (PCA9633_LED_ON << shift));
> +		break;
> +	case LED_OFF:
> +		i2c_smbus_write_byte_data(pca9633->client, PCA9633_LEDOUT,
> +			ledout & ~mask);
> +		break;
> +	default:
> +		i2c_smbus_write_byte_data(pca9633->client,
> +			PCA9633_PWM_BASE + pca9633->led_num,
> +			pca9633->brightness);
> +		i2c_smbus_write_byte_data(pca9633->client, PCA9633_LEDOUT,
> +			(ledout & ~mask) | (PCA9633_LED_PWM << shift));
> +		break;
> +	}
> +}
> +
> +static void pca9633_led_set(struct led_classdev *led_cdev,
> +	enum led_brightness value)
> +{
> +	struct pca9633_led *pca9633;
> +
> +	pca9633 = container_of(led_cdev, struct pca9633_led, led_cdev);
> +
> +	spin_lock(&pca9633->lock);

Does the spinlock actually protect against anything?

> +	pca9633->brightness = value;
> +
> +	/*
> +	 * Must use workqueue for the actual I/O since I2C operations
> +	 * can sleep.
> +	 */
> +	schedule_work(&pca9633->work);
> +
> +	spin_unlock(&pca9633->lock);
> +}
> +
> +static int __devinit pca9633_probe(struct i2c_client *client,
> +					const struct i2c_device_id *id)
> +{
> +	struct pca9633_led *pca9633;
> +	struct i2c_adapter *adapter;
> +	struct led_platform_data *pdata;
> +	int i, err;
> +
> +	adapter = to_i2c_adapter(client->dev.parent);
> +	pdata = client->dev.platform_data;
> +
> +	printk(KERN_INFO "leds-pca9633: LED driver at slave address 0x%02x\n",
> +		client->addr);

dev_info, but it probably wouldn't hurt either if the message is removed
altogether.

> +
> +	if (!i2c_check_functionality(adapter, I2C_FUNC_I2C))
> +		return -EIO;

You check for I2C functionality, but only ever use the smbus subset, which
should be supported by all adapters anyway, so you should be safe even without
the check.

> +
> +	if (pdata) {
> +		if (pdata->num_leds <= 0 || pdata->num_leds > 4) {
> +			dev_err(&client->dev, "board info must claim at most 4 LEDs");
> +			return -ENODEV;

-EINVAL?

> +		}
> +	}
> +
> +	pca9633 = kzalloc(sizeof(*pca9633) * 4, GFP_KERNEL);
> +	if (!pca9633)
> +		return -ENOMEM;
> +
> +	i2c_set_clientdata(client, pca9633);
> +
> +	for (i = 0; i < 4; i++) {
> +		pca9633[i].client = client;
> +		pca9633[i].led_num = i;
> +
> +		/* Platform data can specify LED names and default triggers */
> +		if (pdata && i < pdata->num_leds) {
> +			if (pdata->leds[i].name)
> +				snprintf(pca9633[i].name,
> +					 sizeof(pca9633[i].name), "pca9633:%s",
> +					 pdata->leds[i].name);

Why the prefix?

> +			if (pdata->leds[i].default_trigger)
> +				pca9633[i].led_cdev.default_trigger =
> +					pdata->leds[i].default_trigger;
> +		} else {
> +			snprintf(pca9633[i].name, sizeof(pca9633[i].name),
> +				 "pca9633:%d", i);
> +		}
> +
> +		spin_lock_init(&pca9633[i].lock);
> +
> +		pca9633[i].led_cdev.name = pca9633[i].name;
> +		pca9633[i].led_cdev.brightness_set = pca9633_led_set;
> +
> +		INIT_WORK(&pca9633[i].work, pca9633_led_work);
> +
> +		err = led_classdev_register(&client->dev, &pca9633[i].led_cdev);
> +		if (err < 0)
> +			goto exit;
> +	}
> +
> +	/* Disable LED all-call address and set normal mode */
> +	i2c_smbus_write_byte_data(client, PCA9633_MODE1, 0x00);
> +
> +	/* Turn off LEDs */
> +	i2c_smbus_write_byte_data(client, PCA9633_LEDOUT, 0x00);
> +
> +	return 0;
> +
> +exit:
> +	while (i--) {
> +		led_classdev_unregister(&pca9633[i].led_cdev);
> +		cancel_work_sync(&pca9633[i].work);
> +	}
> +
> +	kfree(pca9633);
> +
> +	return err;
> +}
> +
>[...]
> +
> +static int __init pca9633_leds_init(void)
> +{
> +	return i2c_add_driver(&pca9633_driver);
> +}
> +
> +static void __exit pca9633_leds_exit(void)
> +{
> +	i2c_del_driver(&pca9633_driver);
> +}
> +
> +module_init(pca9633_leds_init);
> +module_exit(pca9633_leds_exit);

Use the new module_i2c_driver macro.

