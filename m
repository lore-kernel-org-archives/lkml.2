Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab2AaA2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 19:28:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52479 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab2AaA2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 19:28:51 -0500
Date: Mon, 30 Jan 2012 16:28:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Meerwald <pmeerw@pmeerw.net>
Cc: linux-kernel@vger.kernel.org, lars@metafoo.de, rpurdie@rpsys.net
Subject: Re: [PATCH v2] add LED driver for PCA9663 I2C chip
Message-Id: <20120130162849.635c83a9.akpm@linux-foundation.org>
In-Reply-To: <1326916289-19004-1-git-send-email-pmeerw@pmeerw.net>
References: <1326916289-19004-1-git-send-email-pmeerw@pmeerw.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jan 2012 20:51:29 +0100
Peter Meerwald <pmeerw@pmeerw.net> wrote:

> From: Peter Meerwald <p.meerwald@bct-electronic.com>
> 
> v2: address Lars-Peter's comments
> * remove unnecessary spinlock
> * remove printk()
> * change return code to EINVAL for invalid platform data
> * use module_i2c_driver()

The patch is missing its changelog and has no signed-off-by:. 
Documentation/SubmittingPatches discusses these things.

>
> ...
>
> +static void pca9633_led_work(struct work_struct *work)
> +{
> +	struct pca9633_led *pca9633 = container_of(work,
> +		struct pca9633_led, work);
> +

Unneeded newline here.

> +	u8 ledout = i2c_smbus_read_byte_data(pca9633->client, PCA9633_LEDOUT);
> +	int shift = 2 * pca9633->led_num;
> +	u8 mask = 0x3 << shift;
> +
> +	switch (pca9633->brightness) {
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
>
> ...
>
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
> +	if (pdata) {
> +		if (pdata->num_leds <= 0 || pdata->num_leds > 4) {
> +			dev_err(&client->dev, "board info must claim at most 4 LEDs");
> +			return -EINVAL;
> +		}
> +	}
> +
> +	pca9633 = kzalloc(sizeof(*pca9633) * 4, GFP_KERNEL);

Could use kcalloc() here, although that's rather a pointless change.

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
> +			if (pdata->leds[i].default_trigger)
> +				pca9633[i].led_cdev.default_trigger =
> +					pdata->leds[i].default_trigger;
> +		} else {
> +			snprintf(pca9633[i].name, sizeof(pca9633[i].name),
> +				 "pca9633:%d", i);
> +		}
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

This (untested!) loop has an off-by-one error.  You want

	do {
		...
	} while (i--);


> +	kfree(pca9633);
> +
> +	return err;
> +}
> +
>
> ...
>

