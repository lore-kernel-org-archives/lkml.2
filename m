Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466Ab1FIQKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 12:10:22 -0400
Received: from csmtp2.one.com ([91.198.169.22]:40395 "EHLO csmtp2.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080Ab1FIQKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 12:10:19 -0400
Date: Thu, 9 Jun 2011 18:12:29 +0200
From: Eric Andersson <eric.andersson@unixphere.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhengguang.guo@bosch-sensortec.com,
        stefan.nilsson@unixphere.com,
        Albert Zhang <xu.zhang@bosch-sensortec.com>
Subject: Re: [PATCH] input: add driver for Bosch Sensortec's BMA150
 accelerometer
Message-ID: <20110609161224.GA7098@skinner>
References: <1306857314-655-1-git-send-email-eric.andersson@unixphere.com>
 <20110531172320.0fcadfef@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110531172320.0fcadfef@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Once again, thanks for reviewing! See comments below.

On 17:23 Tue 31 May, Alan Cox wrote:
> See the driver I posted some time ago. It's in rather better state than
> this one and as it's been through most of the review process and also
> handles the BMA023 and SMB380 so I think would be a better place to start
> from. I'll report that driver in a moment.
I have confirmed with Bosch Sensortec that BMA150, SMB380 and BMA023 are all
fully compatible. BMA150 and SMB380 are the same chip and differs only in
packaging.
However, the name BMA023 is not an official product name and there is no public
datasheet available for this chip. Hence, the preferred name for this driver is
BMA150 (bma150.c).
I will make sure to state in the Kconfig that this driver supports both BMA150
and SMB380 for the next version.
 
> > +struct bma150acc {
> > +	s16	x,
> > +		y,
> > +		z;
> > +};
> 
> Why does this need to be a struct ?
It doesn't, but I see it as increased readability. Actually, you have the same
type of struct in the BMA023 driver you sent me. Anyways, I can remove it.

> > +	if ((mode != BMA150_MODE_NORMAL) &&
> > +	    (mode != BMA150_MODE_SLEEP) &&
> > +	    (mode != BMA150_MODE_WAKE_UP))
> > +		return -EINVAL;
> 
> How can any other mode get passed ?
They can't and shouldn't. See chapter 7 of the BMA150 datasheet.

> > +	data1 = i2c_smbus_read_byte_data(client, BMA150_WAKE_UP_REG);
> > +	if (data1 < 0)
> > +		return ret;
> > +
> > +	data1 = (data1 & ~BMA150_WAKE_UP_MSK) |
> > +		((mode << BMA150_WAKE_UP_POS) & BMA150_WAKE_UP_MSK);
> > +
> > +	data2 = i2c_smbus_read_byte_data(client, BMA150_SLEEP_REG);
> > +	if (data2 < 0)
> > +		return ret;
> > +
> > +	data2 = (data2 & ~BMA150_SLEEP_MSK) |
> > +		(((mode>>1) << BMA150_SLEEP_POS) & BMA150_SLEEP_MSK);
> > +
> > +	ret = i2c_smbus_write_byte_data(client, BMA150_WAKE_UP_REG, data1);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	ret = i2c_smbus_write_byte_data(client, BMA150_SLEEP_REG, data2);
> > +	if (ret < 0)
> > +		return ret;
> 
> What locks this SMBUS transaction against others
True! I will look over the locking for the next version.

> > +static int bma150_set_range(struct i2c_client *client, unsigned char range)
> > +{
> > +	int ret;
> > +	unsigned char data;
> > +
> > +	if (range > BMA150_RANGE_8G)
> > +		return -EINVAL;
> 
> This should be actual values not a register range
It is an actual value. See chapter 3.1.2 in the BMA150 datasheet where the
acceleration range values are defined.

> > +	data = i2c_smbus_read_byte_data(client, BMA150_RANGE_REG);
> > +	if (data < 0)
> > +		return ret;
> > +
> > +	data = (data & ~BMA150_RANGE_MSK) |
> > +		((range << BMA150_RANGE_POS) & BMA150_RANGE_MSK);
> > +
> > +	ret = i2c_smbus_write_byte_data(client, BMA150_RANGE_REG, data);
> 
> What locks this ?
I'll fix it!

> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	return 0;
> 
> Why this pointless if ?
Oops! I will fix this!

> > +static int bma150_get_range(struct i2c_client *client, unsigned char *range)
> > +{
> > +	int ret;
> > +	unsigned char data;
> > +
> > +	data = i2c_smbus_read_byte_data(client, BMA150_RANGE_REG);
> > +	if (data < 0)
> > +		return ret;
> > +
> > +	*range = (data & BMA150_RANGE_MSK) >> BMA150_RANGE_POS;
> > +	return 0;
> 
> See comments above
> 
> > +}
> > +
> > +static int bma150_set_bandwidth(struct i2c_client *client, unsigned char bw)
> 
> Similar problem
> 
> 
> > +static int bma150_read_accel_xyz(struct i2c_client *client,
> > +		struct bma150acc *acc)
> > +{
> > +	unsigned char data[6];
> > +	int ret = i2c_smbus_read_i2c_block_data(client,
> > +			BMA150_ACC_X_LSB_REG, 6, data);
> > +	if (ret != 6)
> > +		return -EIO;
> > +
> > +	acc->x = ((0xC0 & data[0]) >> 6) | (data[1] << 2);
> > +	acc->y = ((0xC0 & data[2]) >> 6) | (data[3] << 2);
> > +	acc->z = ((0xC0 & data[4]) >> 6) | (data[5] << 2);
> > +
> > +	/* sign extension */
> > +	acc->x = (s16) (acc->x << 6) >> 6;
> > +	acc->y = (s16) (acc->y << 6) >> 6;
> > +	acc->z = (s16) (acc->z << 6) >> 6;
> > +
> > +	return 0;
> 
> Why the separate function and struct
You are right! I will merge this with the worker function.

> > +}
> > +
> > +static void bma150_work_func(struct work_struct *work)
> > +{
> 
> Threaded IRQ ?
Actually no. The reason for this is that the interrupt is triggered every
333 us. This creates a pretty heavy load. By using delayed_work we can better
control the sampling rate and have it dynamically configured by using sysfs.
 
> > +static ssize_t bma150_mode_show(struct device *dev,
> > +		struct device_attribute *attr, char *buf)
> > +{
> > +	struct i2c_client *client = to_i2c_client(dev);
> > +	struct bma150_data *bma150 = i2c_get_clientdata(client);
> > +
> > +	return sprintf(buf, "%d\n", bma150->mode);
> 
> API definition ?
Roger that! I will add it to the next version.

> 
> > +	schedule_delayed_work(&data->work,
> > +			msecs_to_jiffies(atomic_read(&data->delay)));
> > +
> 
> Why the atomic read ?
Sure, I'll remove it.

> And there are a ton more issues unfixed in this driver
If you could be more precise I will be glad to fix any additional remarks!

I will send an updated version of the driver once I've fixed it!

Best regards,
 Eric

 http://www.unixphere.com

