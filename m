Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288Ab1ACPNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 10:13:34 -0500
Received: from imr4.ericy.com ([198.24.6.8]:57899 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932229Ab1ACPNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 10:13:33 -0500
Date: Mon, 3 Jan 2011 07:12:42 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Urs Fleisch <urs.fleisch@gmail.com>
CC: Jonathan Cameron <jic23@cam.ac.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LM Sensors <lm-sensors@lm-sensors.org>,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH V3] hwmon: driver for Sensirion SHT21 humidity and
 temperature sensor
Message-ID: <20110103151242.GC25600@ericsson.com>
References: <20101229134511.cc466ac0.urs.fleisch@gmail.com>
 <4D1DF097.1080200@cam.ac.uk>
 <20110103081448.f96c413e.urs.fleisch@gmail.com>
 <4D21ADCB.4070206@cam.ac.uk>
 <20110103150134.e4858844.urs.fleisch@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110103150134.e4858844.urs.fleisch@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 03, 2011 at 09:01:34AM -0500, Urs Fleisch wrote:
> Hi Jonathan,
> 
> > Is there actualy a use case that means these can't both be set
> > by platform data?  Also, if these are acceptable, should they have
> > some means of indicating which combination of values are available?
> 
> I can imagine a use case where an embedded device wants to operate in a
> low-power mode while still monitoring humidity and/or temperature. Measurement
> time and thus power consumption of the SHT21 are significantly smaller when
> using a low resolution. Or you can use a low resolution while waiting for a
> significant change in humidity and/or temperature and then switch to a higher
> resolution to actually report the measurement values.
> 
> > Rely on platform data to get this right rather than an adhoc test that
> > might well pass on some random devices.
> 
> I removed that probing stuff. As read and write addresses for the user
> register are different, it would probably not pass on another device, but it
> could disturb another device.
> 
> > Sorry to say I missed some error handling issues the first time around.
> > Please always provide userspace with the most detailed and correct error
> > possible. Normally this is the one comming up from the bus subsystem.
> 
> All error codes should now be passed up to userspace.
> 
> Thanks again,
> Urs
> 
> Signed-off-by: Urs Fleisch <urs.fleisch@sensirion.com>

All the above shows up in the commit log if the patch is applied. Just adds
additional work for the maintainers.

> ---
[ ...] 
> +
> +/**
> + * sht21_show_temperature() - show temperature measurement value in sysfs
> + * @dev: device
> + * @attr: device attribute
> + * @buf: sysfs buffer (PAGE_SIZE) where measurement values are written to
> + *
> + * Will be called on read access to temp1_input sysfs attribute.
> + * Returns number of bytes written into buffer, negative errno on error.
> + */
> +static ssize_t sht21_show_temperature(struct device *dev,
> +       struct device_attribute *attr,
> +       char *buf)
> +{
> +       struct i2c_client *client = to_i2c_client(dev);
> +       int result = sht21_update_measurements(client);
> +       if (result >= 0) {
> +               struct sht21 *sht21 = i2c_get_clientdata(client);
> +
> +               return sprintf(buf, "%d\n", sht21->temperature);
> +       }
> +       return result;

Highly unusual way of detecting and returning errors. Common would be

	if (result < 0)
		return result;
	/* other code */

ie keep the code flow intact. Makes the code much easier to read.

Guenter
