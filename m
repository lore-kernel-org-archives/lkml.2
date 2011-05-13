Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933156Ab1EMSZs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 14:25:48 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44425 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932580Ab1EMSZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 14:25:46 -0400
Date: Fri, 13 May 2011 19:27:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Chris@vger.kernel.org, Hudson@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Hudson <chudson@kionix.com>
Subject: Re: [PATCH 1/1] input: Add support for Kionix KXTJ9 accelerometer
Message-ID: <20110513192710.5b4791ca@lxorguk.ukuu.org.uk>
In-Reply-To: <1305310406-9870-2-git-send-email-chudson@kionix.com>
References: <1305310406-9870-1-git-send-email-chudson@kionix.com>
	<1305310406-9870-2-git-send-email-chudson@kionix.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> + * The following table lists the maximum appropriate poll interval for each
> + * available output data rate.

Surely this can be static const

> + */
> +struct {
> +	unsigned int cutoff;
> +	u8 mask;
> +} kxtj9_odr_table[] = {
> +	{

> +static int kxtj9_i2c_read(struct kxtj9_data *tj9, u8 addr, u8 *data, int len)
> +{
> +	int err;
> +
> +	struct i2c_msg msgs[] = {
> +		{
> +		 .addr = tj9->client->addr,
> +		 .flags = tj9->client->flags,
> +		 .len = 1,
> +		 .buf = &addr,
> +		 },
> +		{
> +		 .addr = tj9->client->addr,
> +		 .flags = tj9->client->flags | I2C_M_RD,
> +		 .len = len,
> +		 .buf = data,
> +		 },
> +	};
> +	err = i2c_transfer(tj9->client->adapter, msgs, 2);
> +
> +	if (err != 2)
> +		dev_err(&tj9->client->dev, "read transfer error\n");

Just return ret and check it with < 0 meaning error


> +static int kxtj9_i2c_write(struct kxtj9_data *tj9, u8 addr, u8 *data, int len)
> +{
> +	int err;
> +	int i;
> +	u8 buf[len + 1];
> +
> +	struct i2c_msg msgs[] = {
> +		{
> +		 .addr = tj9->client->addr,
> +		 .flags = tj9->client->flags,
> +		 .len = len + 1,
> +		 .buf = buf,
> +		 },
> +	};
> +
> +	buf[0] = addr;
> +	for (i = 0; i < len; i++)
> +		buf[i + 1] = data[i];

memcpy is quite useful and the kernel one inlines nicely


> +int kxtj9_update_g_range(struct kxtj9_data *tj9, u8 new_g_range)
> +{
> +	int err;
> +	u8 shift;
> +	u8 buf;
> +	u8 out;
> +
> +	switch (new_g_range) {
> +	case KXTJ9_G_2G:
> +		shift = SHIFT_ADJ_2G;
> +		break;
> +	case KXTJ9_G_4G:
> +		shift = SHIFT_ADJ_4G;
> +		break;
> +	case KXTJ9_G_8G:
> +		shift = SHIFT_ADJ_8G;
> +		break;
> +	default:
> +		dev_err(&tj9->client->dev, "invalid g range request\n");
> +		return -EINVAL;

So a user can fill the system log ? not good

> +	}
> +
> +	out = (tj9->resume[RES_CTRL_REG1] & 0xE7) | new_g_range;
> +	if (shift != tj9->pdata->shift_adj) {
> +		if (atomic_read(&tj9->enabled)) {
> +			buf = 0;
> +			err = kxtj9_i2c_write(tj9, CTRL_REG1, &buf, 1);
> +			if (err < 0)
> +				return err;
> +			err = kxtj9_i2c_write(tj9, CTRL_REG1, &out, 1);
> +			if (err < 0)
> +				return err;
> +		}

You seem to have no locking on parallel actions and a rather meaningles
atomic

> +	}
> +
> +	tj9->resume[RES_CTRL_REG1] = out;
> +	tj9->pdata->shift_adj = shift;

and unlocked too

In fact the locking seems to be utterly busted everywhere in the driver.



> +static void kxtj9_device_power_off(struct kxtj9_data *tj9)
> +{
> +	int err;
> +	u8 buf;
> +
> +	buf = tj9->resume[RES_CTRL_REG1] & PC1_OFF;
> +	err = kxtj9_i2c_write(tj9, CTRL_REG1, &buf, 1);
> +	if (err < 0)
> +		dev_err(&tj9->client->dev, "soft power off failed\n");
> +	disable_irq(tj9->irq);

What if the IRQ is shared ?


> +static irqreturn_t kxtj9_isr(int irq, void *dev)
> +{
> +	struct kxtj9_data *tj9 = dev;
> +
> +	disable_irq_nosync(irq);
> +	schedule_work(&tj9->irq_work);
> +
> +	return IRQ_HANDLED;
> +}

Threaded irq will sort this lot out for you



> +static ssize_t kxtj9_enable_store(struct device *dev,
> +					struct device_attribute *attr,
> +						const char *buf, size_t count)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct kxtj9_data *tj9 = i2c_get_clientdata(client);
> +	int val = simple_strtoul(buf, NULL, 10);
> +	if (val)
> +		kxtj9_enable(tj9);
> +	else
> +		kxtj9_disable(tj9);

You seem to have no locking on this either

> +	return count;
> +}

> +static DEVICE_ATTR(delay, S_IRUGO|S_IWUSR, kxtj9_delay_show, kxtj9_delay_store);
> +static DEVICE_ATTR(enable, S_IRUGO|S_IWUSR, kxtj9_enable_show,
> +							kxtj9_enable_store);
> +static DEVICE_ATTR(res, S_IRUGO|S_IWUSR, kxtj9_res_show, kxtj9_res_store);
> +static DEVICE_ATTR(drdyenable, S_IRUGO|S_IWUSR, NULL, kxtj9_drdyenable_store);
> +static DEVICE_ATTR(grange, S_IRUGO|S_IWUSR, kxtj9_grange_show,
> +							kxtj9_grange_store);

These should probably come from platform data


> +static int __devinit kxtj9_probe(struct i2c_client *client,
> +						const struct i2c_device_id *id)
> +{
> +	int err = -1;
> +	struct kxtj9_data *tj9 = kzalloc(sizeof(*tj9), GFP_KERNEL);
> +	if (tj9 == NULL) {
> +		dev_err(&client->dev,
> +			"failed to allocate memory for module data\n");
> +		err = -ENOMEM;
> +		goto err0;
> +	}
> +	if (client->dev.platform_data == NULL) {
> +		dev_err(&client->dev, "platform data is NULL; exiting\n");
> +		err = -ENODEV;
> +		goto err0;

Leaks memory

> +	}
> +	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
> +		dev_err(&client->dev, "client not i2c capable\n");
> +		err = -ENODEV;

Ditto


> +	memcpy(tj9->pdata, client->dev.platform_data, sizeof(*tj9->pdata));
> +	if (tj9->pdata->init) {
> +		err = tj9->pdata->init();
> +		if (err < 0)
> +			goto err2;
> +	}
> +
> +	tj9->irq = gpio_to_irq(tj9->pdata->gpio);

What if it's not on a gpio. Probably better any gpio and irq conversion is
done by the platform callback/init code


And the sysfs nodes need documentation.


Overall it looks like a lot of input drivers that get posted here

- Nobody has considered locking between actions and sysfs (or multiple
  sysfs actions in parallel)
- Enable/disable is implemented in blissful ignorance of what happens if
  a disable occurs during a sysfs or other action

Most of the rest looks like it just needs a good polish.
