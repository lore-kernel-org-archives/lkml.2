Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442Ab1EaQVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 12:21:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54703 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757091Ab1EaQVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 12:21:42 -0400
Date: Tue, 31 May 2011 17:23:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eric Andersson <eric.andersson@unixphere.com>
Cc: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhengguang.guo@bosch-sensortec.com,
        stefan.nilsson@unixphere.com,
        Albert Zhang <xu.zhang@bosch-sensortec.com>
Subject: Re: [PATCH] input: add driver for Bosch Sensortec's BMA150
 accelerometer
Message-ID: <20110531172320.0fcadfef@lxorguk.ukuu.org.uk>
In-Reply-To: <1306857314-655-1-git-send-email-eric.andersson@unixphere.com>
References: <1306857314-655-1-git-send-email-eric.andersson@unixphere.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See the driver I posted some time ago. It's in rather better state than
this one and as it's been through most of the review process and also
handles the BMA023 and SMB380 so I think would be a better place to start
from. I'll report that driver in a moment.

Alan


Some of the first immediately obvious questions though - in particular
the lack of clear locking ...


> +struct bma150acc {
> +	s16	x,
> +		y,
> +		z;
> +};

Why does this need to be a struct ?

> +	if ((mode != BMA150_MODE_NORMAL) &&
> +	    (mode != BMA150_MODE_SLEEP) &&
> +	    (mode != BMA150_MODE_WAKE_UP))
> +		return -EINVAL;

How can any other mode get passed ?

> +
> +	data1 = i2c_smbus_read_byte_data(client, BMA150_WAKE_UP_REG);
> +	if (data1 < 0)
> +		return ret;
> +
> +	data1 = (data1 & ~BMA150_WAKE_UP_MSK) |
> +		((mode << BMA150_WAKE_UP_POS) & BMA150_WAKE_UP_MSK);
> +
> +	data2 = i2c_smbus_read_byte_data(client, BMA150_SLEEP_REG);
> +	if (data2 < 0)
> +		return ret;
> +
> +	data2 = (data2 & ~BMA150_SLEEP_MSK) |
> +		(((mode>>1) << BMA150_SLEEP_POS) & BMA150_SLEEP_MSK);
> +
> +	ret = i2c_smbus_write_byte_data(client, BMA150_WAKE_UP_REG, data1);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = i2c_smbus_write_byte_data(client, BMA150_SLEEP_REG, data2);
> +	if (ret < 0)
> +		return ret;

What locks this SMBUS transaction against others

> +static int bma150_set_range(struct i2c_client *client, unsigned char range)
> +{
> +	int ret;
> +	unsigned char data;
> +
> +	if (range > BMA150_RANGE_8G)
> +		return -EINVAL;

This should be actual values not a register range

> +
> +	data = i2c_smbus_read_byte_data(client, BMA150_RANGE_REG);
> +	if (data < 0)
> +		return ret;
> +
> +	data = (data & ~BMA150_RANGE_MSK) |
> +		((range << BMA150_RANGE_POS) & BMA150_RANGE_MSK);
> +
> +	ret = i2c_smbus_write_byte_data(client, BMA150_RANGE_REG, data);

What locks this ?

> +	if (ret < 0)
> +		return ret;
> +
> +	return 0;

Why this pointless if ?

> +}
> +
> +static int bma150_get_range(struct i2c_client *client, unsigned char *range)
> +{
> +	int ret;
> +	unsigned char data;
> +
> +	data = i2c_smbus_read_byte_data(client, BMA150_RANGE_REG);
> +	if (data < 0)
> +		return ret;
> +
> +	*range = (data & BMA150_RANGE_MSK) >> BMA150_RANGE_POS;
> +	return 0;

See comments above

> +}
> +
> +static int bma150_set_bandwidth(struct i2c_client *client, unsigned char bw)

Similar problem


> +static int bma150_read_accel_xyz(struct i2c_client *client,
> +		struct bma150acc *acc)
> +{
> +	unsigned char data[6];
> +	int ret = i2c_smbus_read_i2c_block_data(client,
> +			BMA150_ACC_X_LSB_REG, 6, data);
> +	if (ret != 6)
> +		return -EIO;
> +
> +	acc->x = ((0xC0 & data[0]) >> 6) | (data[1] << 2);
> +	acc->y = ((0xC0 & data[2]) >> 6) | (data[3] << 2);
> +	acc->z = ((0xC0 & data[4]) >> 6) | (data[5] << 2);
> +
> +	/* sign extension */
> +	acc->x = (s16) (acc->x << 6) >> 6;
> +	acc->y = (s16) (acc->y << 6) >> 6;
> +	acc->z = (s16) (acc->z << 6) >> 6;
> +
> +	return 0;

Why the separate function and struct

> +}
> +
> +static void bma150_work_func(struct work_struct *work)
> +{

Threaded IRQ ?


> +static ssize_t bma150_mode_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct bma150_data *bma150 = i2c_get_clientdata(client);
> +
> +	return sprintf(buf, "%d\n", bma150->mode);

API definition ?


> +	schedule_delayed_work(&data->work,
> +			msecs_to_jiffies(atomic_read(&data->delay)));
> +

Why the atomic read ?


And there are a ton more issues unfixed in this driver

