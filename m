Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759655Ab1FWPeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 11:34:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33919 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759176Ab1FWPeO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 11:34:14 -0400
Date: Thu, 23 Jun 2011 16:36:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eric Andersson <eric.andersson@unixphere.com>
Cc: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhengguang.guo@bosch-sensortec.com,
        stefan.nilsson@unixphere.com,
        Albert Zhang <xu.zhang@bosch-sensortec.com>
Subject: Re: [PATCH v2 1/1] input: add driver for Bosch Sensortec's BMA150
 accelerometer
Message-ID: <20110623163631.2c43671e@lxorguk.ukuu.org.uk>
In-Reply-To: <1308840027-10724-2-git-send-email-eric.andersson@unixphere.com>
References: <1308840027-10724-1-git-send-email-eric.andersson@unixphere.com>
	<1308840027-10724-2-git-send-email-eric.andersson@unixphere.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +Description:	This is used to select the full scale acceleration range. The
> +		values represent the range given as +/- G.
> +		Possible values are: 2, 4, 8.
> +
> +		Reading: returns the current acceleration range.
> +
> +		Writing: sets a new acceleration range.

As there is no way to know the valid values I suspect it ought to pick
nearest inclusive for others <=8 ?

Similarly for the others

> +			normal - Sets the sensor in full running mode.
> +			sleep  - Sets the sensor in deep sleep.
> +			wakeup - Sets the sensor to low-power mode using
> +				 sequential sleep period.
> +
> +		Reading: returns the current operational mode.
> +
> +		Writing: sets a new operational mode.

We have runtime_pm for this (and in fact to switch from the bma023 driver
I posted to yours we'd need runtime pm)

> +
> +
> +What:		/sys/bus/i2c/devices/<busnum>-<devaddr>/value
> +Date:		May 2011
> +Contact:	Eric Andersson <eric.andersson@unixphere.com>
> +Description:	This is used to get the current acceleration values for each
> +		axis. The values are represented as (x,y,z), where each axis can
> +		hold a value between -512 and 511.
> +
> +		Reading: returns the current acceleration values.

This was nacked in the bma023 driver by the IIO folks - and Dmitry
pointed out you can do this without a sysfs hack. The trick is to do an
initial poll in input_open at which point the ioctl query for the
position will have data that is current and open/ioctl/close works and
providing we go nail that into other drivers that need that kind of use
the API is generic and input event based.

> +
> +
> +What:		/sys/bus/i2c/devices/<busnum>-<devaddr>/delay
> +Date:		May 2011
> +Contact:	Eric Andersson <eric.andersson@unixphere.com>
> +Description:	This is used to select the polling rate of the driver. The
> +		value is represented in ms and can be between 0 and 200. Any

0-200 whats ?


> +What:		/sys/bus/i2c/devices/<busnum>-<devaddr>/enable
> +Date:		May 2011
> +Contact:	Eric Andersson <eric.andersson@unixphere.com>
> +Description:	This is used to enable and disable the chip. The chip will only
> +		be disabled if there are no input device users.

How does this differ from the power one and why is it needed, why doesn't
it disable when not in use ? How does this interact with runtime pm


>
> +static int bma150_set_bandwidth(struct i2c_client *client, unsigned char bw)
> +{
> +	s32 ret;
> +	unsigned char data;
> +	struct bma150_data *bma150 = i2c_get_clientdata(client);
> +
> +	mutex_lock(&bma150->mutex);
> +	ret = i2c_smbus_read_byte_data(client, BMA150_BANDWIDTH_REG);
> +	if (ret < 0)
> +		goto error;
> +
> +	data = (ret & ~BMA150_BANDWIDTH_MSK) |
> +		((bw << BMA150_BANDWIDTH_POS) & BMA150_BANDWIDTH_MSK);
> +
> +	ret = i2c_smbus_write_byte_data(client, BMA150_BANDWIDTH_REG, data);
> +error:
> +	mutex_unlock(&bma150->mutex);
> +	return ret;
> +}

A lot of remarkably similar functions


> +	mutex_lock(&bma150->mutex);
> +	bma150->x = x;
> +	bma150->y = y;
> +	bma150->z = z;
> +	mutex_unlock(&bma150->mutex);

This locking would go away if you dropped the un-needed sysfs node

>
> +static int bma150_open(struct input_dev *inputdev)
> +{
> +	struct bma150_data *dev = input_get_drvdata(inputdev);
> +
> +	if (!dev->sysfs_enable)
> +		return bma150_start_polling(inputdev);
> +
> +	return 0;
> +}

Most bma023 users will be IRQ based, so this driver would need chunks
extracting from the other bma023 driver submission for that to be handled.

> +
> +static void bma150_close(struct input_dev *inputdev)
> +{
> +	struct bma150_data *dev = input_get_drvdata(inputdev);
> +
> +	if (!dev->sysfs_enable)
> +		bma150_stop_polling(inputdev);

What locks sysfs_enable ?


>From the Intel side to use your driver instead of bma023 we'd need IRQ
support and runtime pm but otherwise it looks basically ok. I really
don't see how to reconcile proper power management with all your sysfs
enables and power bits though ?



