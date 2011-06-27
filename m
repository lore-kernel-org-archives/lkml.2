Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab1F0UWH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 16:22:07 -0400
Received: from csmtp2.one.com ([91.198.169.22]:53331 "EHLO csmtp2.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754164Ab1F0UVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 16:21:51 -0400
Date: Mon, 27 Jun 2011 22:24:52 +0200
From: Eric Andersson <eric.andersson@unixphere.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhengguang.guo@bosch-sensortec.com,
        stefan.nilsson@unixphere.com,
        Albert Zhang <xu.zhang@bosch-sensortec.com>
Subject: Re: [PATCH v2 1/1] input: add driver for Bosch Sensortec's BMA150
 accelerometer
Message-ID: <20110627202452.GA7201@skinner.xfiles.lan>
References: <1308840027-10724-1-git-send-email-eric.andersson@unixphere.com>
 <1308840027-10724-2-git-send-email-eric.andersson@unixphere.com>
 <20110623163631.2c43671e@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110623163631.2c43671e@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16:36 Thu 23 Jun     , Alan Cox wrote:
> > +Description:	This is used to select the full scale acceleration range. The
> > +		values represent the range given as +/- G.
> > +		Possible values are: 2, 4, 8.
> > +
> > +		Reading: returns the current acceleration range.
> > +
> > +		Writing: sets a new acceleration range.
> 
> As there is no way to know the valid values I suspect it ought to pick
> nearest inclusive for others <=8 ?

Hmm.. I am not sure what you mean. The valid values can be retreived
with a "cat range". Could you please clarify what you mean?

> > +			normal - Sets the sensor in full running mode.
> > +			sleep  - Sets the sensor in deep sleep.
> > +			wakeup - Sets the sensor to low-power mode using
> > +				 sequential sleep period.
> > +
> > +		Reading: returns the current operational mode.
> > +
> > +		Writing: sets a new operational mode.
> 
> We have runtime_pm for this (and in fact to switch from the bma023 driver
> I posted to yours we'd need runtime pm)

Sure, that is probably a good idea.

> > +
> > +
> > +What:		/sys/bus/i2c/devices/<busnum>-<devaddr>/value
> > +Date:		May 2011
> > +Contact:	Eric Andersson <eric.andersson@unixphere.com>
> > +Description:	This is used to get the current acceleration values for each
> > +		axis. The values are represented as (x,y,z), where each axis can
> > +		hold a value between -512 and 511.
> > +
> > +		Reading: returns the current acceleration values.
> 
> This was nacked in the bma023 driver by the IIO folks - and Dmitry
> pointed out you can do this without a sysfs hack. The trick is to do an
> initial poll in input_open at which point the ioctl query for the
> position will have data that is current and open/ioctl/close works and
> providing we go nail that into other drivers that need that kind of use
> the API is generic and input event based.

Ok. Thanks for pointing that out and thanks Dmitry for the patch! I'll look in
to it!

> > +
> > +
> > +What:		/sys/bus/i2c/devices/<busnum>-<devaddr>/delay
> > +Date:		May 2011
> > +Contact:	Eric Andersson <eric.andersson@unixphere.com>
> > +Description:	This is used to select the polling rate of the driver. The
> > +		value is represented in ms and can be between 0 and 200. Any
> 
> 0-200 whats ?

The value is in milliseconds which is stated in the text, but I can rephrase
it to make it more apperent.

> 
> > +What:		/sys/bus/i2c/devices/<busnum>-<devaddr>/enable
> > +Date:		May 2011
> > +Contact:	Eric Andersson <eric.andersson@unixphere.com>
> > +Description:	This is used to enable and disable the chip. The chip will only
> > +		be disabled if there are no input device users.
> 
> How does this differ from the power one and why is it needed, why doesn't
> it disable when not in use ? How does this interact with runtime pm

This is to be able to put the chip to sleep by using sysfs. As you probably know there
are applications interfacing this driver only through sysfs by using the
value-parameter. Without this parameter one needs to open the input device for
the chip to be enabled. However, if one use the open/ioctl/close-functionality
you pointed out this is not needed anymore.

> >
> > +static int bma150_set_bandwidth(struct i2c_client *client, unsigned char bw)
> > +{
> > +	s32 ret;
> > +	unsigned char data;
> > +	struct bma150_data *bma150 = i2c_get_clientdata(client);
> > +
> > +	mutex_lock(&bma150->mutex);
> > +	ret = i2c_smbus_read_byte_data(client, BMA150_BANDWIDTH_REG);
> > +	if (ret < 0)
> > +		goto error;
> > +
> > +	data = (ret & ~BMA150_BANDWIDTH_MSK) |
> > +		((bw << BMA150_BANDWIDTH_POS) & BMA150_BANDWIDTH_MSK);
> > +
> > +	ret = i2c_smbus_write_byte_data(client, BMA150_BANDWIDTH_REG, data);
> > +error:
> > +	mutex_unlock(&bma150->mutex);
> > +	return ret;
> > +}
> 
> A lot of remarkably similar functions

I saw that you abstracted these methods in bma023. However, since you have a
lot more sysfs parameters I would prefer to keep it as is in this
version due to increased readability (IMHO).
 
> > +	mutex_lock(&bma150->mutex);
> > +	bma150->x = x;
> > +	bma150->y = y;
> > +	bma150->z = z;
> > +	mutex_unlock(&bma150->mutex);
> 
> This locking would go away if you dropped the un-needed sysfs node

I'll fix for v3.

> >
> > +static int bma150_open(struct input_dev *inputdev)
> > +{
> > +	struct bma150_data *dev = input_get_drvdata(inputdev);
> > +
> > +	if (!dev->sysfs_enable)
> > +		return bma150_start_polling(inputdev);
> > +
> > +	return 0;
> > +}
> 
> Most bma023 users will be IRQ based, so this driver would need chunks
> extracting from the other bma023 driver submission for that to be handled.

As mentioned in my previous patch, using IRQ might not be a good idea. The
reason for this is that the interrupt is triggered every 333 us which would
create a heavy load on the system.

I have also verified this with Bosch Sensortec who recommends to not use IRQ
for this chip driver.

> > +
> > +static void bma150_close(struct input_dev *inputdev)
> > +{
> > +	struct bma150_data *dev = input_get_drvdata(inputdev);
> > +
> > +	if (!dev->sysfs_enable)
> > +		bma150_stop_polling(inputdev);
> 
> What locks sysfs_enable ?

This will go away when the enable node is removed.

-- 
Best regards,
 Eric

http://www.unixphere.com
