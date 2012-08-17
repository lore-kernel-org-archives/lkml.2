Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757793Ab2HQKlL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 06:41:11 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:24375 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757702Ab2HQKlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 06:41:07 -0400
Date: Fri, 17 Aug 2012 13:40:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Thorsten Nowak <not@iis.fhg.de>
Cc: Thorsten Nowak <thorsten.nowak@iis.fraunhofer.de>,
        Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] staging: iio: Integration gyroscope itg3200
Message-ID: <20120817104031.GM4559@mwanda>
References: <1345192038-5665-1-git-send-email-not@iis.fhg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345192038-5665-1-git-send-email-not@iis.fhg.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 10:27:18AM +0200, Thorsten Nowak wrote:

> +	/* Guaranteed to be aligned with 8 byte boundary */
> +	if (buffer->scan_timestamp)
> +		*(s64 *)(((phys_addr_t)st->rx + len
> +					+ sizeof(s64) - 1) & ~(sizeof(s64) - 1))
> +		= pf->timestamp;

It took me a while to figure this one out.  The indenting is wrong
and, in fact, the whole statement is horrible to look at.

[snip]

> +static int itg3200_ring_postenable(struct iio_dev *indio_dev)
> +{
> +	u8 t;
> +	int ret;
> +
> +	ret = itg3200_spi_read_reg_8(indio_dev,
> +				     ITG3200_REG_POWER_MANAGEMENT,
> +				     &t);
> +	if (ret)
> +		goto error_ret;
> +
> +	if (iio_scan_mask_query(indio_dev->ring, 1))
> +		t &= ~ITG3200_STANDBY_GYRO_X;
> +	else
> +		t |= ~ITG3200_STANDBY_GYRO_X;
> +

Should this be:
		t |= ITG3200_STANDBY_GYRO_X;
like the others?



> +	if (iio_scan_mask_query(indio_dev->ring, 2))
> +		t &= ~ITG3200_STANDBY_GYRO_Y;
> +	else
> +		t |= ITG3200_STANDBY_GYRO_Y;
> +
> +	if (iio_scan_mask_query(indio_dev->ring, 3))
> +		t &= ITG3200_STANDBY_GYRO_Z;
> +	else
> +		t |= ITG3200_STANDBY_GYRO_Z;
> +
> +	ret = itg3200_spi_write_reg_8(indio_dev,
> +				      ITG3200_REG_POWER_MANAGEMENT,
> +				      t);
> +	if (ret)
> +		goto error_ret;
> +
> +	return iio_triggered_ring_postenable(indio_dev);
> +error_ret:
> +	return ret;
> +}

[snip]

> +static ssize_t itg3200_write_frequency(struct device *dev,
> +		struct device_attribute *attr,
> +		const char *buf,
> +		size_t len)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	long val;
> +	int ret;
> +	u8 t;
> +
> +	ret = kstrtol(buf, 10, &val);
> +	if (ret)
> +		return ret;
> +
> +	mutex_lock(&indio_dev->mlock);
> +
> +	ret = itg3200_read_reg_8(indio_dev, ITG3200_REG_DLPF, &t);
> +	if (ret)
> +		goto err_ret;
> +
> +	t = ((t & ITG3200_DLPF_CFG_MASK) ? 1000 : 8000) / val - 1;


Potential divide by zero bug.  There may be others as well.

> +
> +	ret = itg3200_write_reg_8(indio_dev, ITG3200_REG_SAMPLE_RATE_DIV, t);
> +
> +err_ret:
> +	mutex_unlock(&indio_dev->mlock);
> +
> +	return ret ? ret : len;
> +}
> +

[snip]

> +static int itg3200_remove(struct i2c_client *client)
> +{
> +	/* int ret; */
> +	struct iio_dev *indio_dev = i2c_get_clientdata(client);
> +
> +	iio_device_unregister(indio_dev);
> +
> +	/*
> +	ret = itg3200_stop_device(indio_dev);
> +	if (ret)
> +		goto err_ret;

Remove these commented out bits before submitting.

> +	*/
> +
> +	if (client->irq && gpio_is_valid(irq_to_gpio(client->irq)) > 0)
                           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
gpio_is_valid() returns true or false so this should be:

	if (client->irq && gpio_is_valid(irq_to_gpio(client->irq)))


> +		itg3200_remove_trigger(indio_dev);
> +

regards,
dan carpenter
