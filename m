Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414Ab1GAR4B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 13:56:01 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:50793 "HELO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756486Ab1GARz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 13:55:59 -0400
From: Nathan Royer <nroyer@invensense.com>
References: <1309486707-1658-1-git-send-email-nroyer@invensense.com> <1309486707-1658-5-git-send-email-nroyer@invensense.com>
In-Reply-To: <1309486707-1658-5-git-send-email-nroyer@invensense.com>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
thread-index: Acw3lUmEmb3qjbeKQ9GiWxqRPGZXRgAfDr8g
Date: Fri, 1 Jul 2011 10:55:56 -0700
Message-ID: <ccc4b7a8a3186c130a97bcf5f11ee9ff@mail.gmail.com>
Subject: RE: [PATCH 05/11] misc: MPU3050 and slave device configuration.
To: Nathan Royer <nroyer@invensense.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jonathan Cameron <jic23@cam.ac.uk>, Jiri Kosina <jkosina@suse.cz>,
        Alan Cox <alan@linux.intel.com>, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Chris Wolfe <cwolfe@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regarding the secondary slave, I've decided to explain it in more detail
in this patch thread since this is where the high level configuration
happens.  I've clipped a number of the details to highlight just the high
level activity.  For the 3050 master i2c, configuration only occurs with
the accelerometer, but with the 6050 (not included in this patch), it can
support both an accel (external or internal), and compass, and pressure.

The first function here sets the bypass mode.  When in bypass mode, the
device master I2C of the mpu3050 is off and the slave chip (accelerometer
for the 3050) can be accessed directly on the same bus as the mpu3050.
When enable is set to false, the slave is disconnected from the bus, and
at that point the only operation that can occur is for the mpu3050 master
i2c to do a block read into the memory of the DMP.  The DMP then makes
this data available through its FIFO after some processing with the gyro
data.

Because of the bypass functionality, we designed all acces to the slave to
be through the MPU driver instead of stand alone.  That way we can first
put the mpu3050 into bypass before calling any of the slave functions that
will communicate directly with the chip.  For example the config functions
with apply == false do not enable bypass mode.
> +/**
> + *  @brief  enables/disables the I2C bypass to an external device
> + *          connected to MPU's secondary I2C bus.
> + *  @param  enable
> + *              Non-zero to enable pass through.
> + *  @return INV_SUCCESS if successful, a non-zero error code
> otherwise.
> + */
> +static int mpu_set_i2c_bypass(struct mldl_cfg *mldl_cfg,
> +			      void *mlsl_handle, unsigned char enable)
> +{
> +	return mpu3050_set_i2c_bypass(mldl_cfg, mlsl_handle, enable);
> +}
> +

This next function sets up the before mentioned block read, by setting the
slave I2C address, the slave I2C starting register, and the size of the
read.

> +
> +static int mpu_set_slave(struct mldl_cfg *mldl_cfg,
> +			 void *gyro_handle,
> +			 struct ext_slave_descr *slave,
> +			 struct ext_slave_platform_data *slave_pdata,
> +			 int slave_id)
> +{
> +	return mpu_set_slave_mpu3050(mldl_cfg, gyro_handle, slave,
> +				     slave_pdata, slave_id);
> +}

The rest of the work happens in the suspend and resume functions:

> +int inv_mpu_resume(struct mldl_cfg *mldl_cfg,
> +		   void *gyro_handle,
> +		   void *accel_handle,
> +		   void *compass_handle,
> +		   void *pressure_handle,
> +		   unsigned long sensors)
> +{

...

> +	for (ii = 0; ii < EXT_SLAVE_NUM_TYPES; ii++) {
> +		if (!mldl_cfg->slave[ii] ||
> +		    !mldl_cfg->pdata_slave[ii] ||
> +		    !resume_slave[ii] ||
> +		    !(mldl_cfg->inv_mpu_state->status & (1 << ii)))
> +			continue;
> +

This loop is intended to also support the mpu6050 where multiple slaves
can be on the secondary bus, so each slave is checked to see if it is on
the secondary bus.  If it is, switch to bypass mode and resume the device.

> +		if (EXT_SLAVE_BUS_SECONDARY ==
> +		    mldl_cfg->pdata_slave[ii]->bus) {
> +			result = mpu_set_i2c_bypass(mldl_cfg, gyro_handle,
> +						    true);
> +			if (result) {
> +				LOG_RESULT_LOCATION(result);
> +				return result;
> +			}
> +		}
> +		result = mldl_cfg->slave[ii]->resume(slave_handle[ii],
> +						mldl_cfg->slave[ii],
> +
mldl_cfg->pdata_slave[ii]);
> +		if (result) {
> +			LOG_RESULT_LOCATION(result);
> +			return result;
> +		}
> +		mldl_cfg->inv_mpu_state->status &= ~(1 << ii);
> +	}

Here is where the slave is set up.

> +	for (ii = 0; ii < EXT_SLAVE_NUM_TYPES; ii++) {
> +		if (resume_dmp &&
> +		    !(mldl_cfg->inv_mpu_state->status & (1 << ii)) &&
> +		    mldl_cfg->pdata_slave[ii] &&
> +		    EXT_SLAVE_BUS_SECONDARY == mldl_cfg->pdata_slave[ii]-
> >bus) {
> +			result = mpu_set_slave(mldl_cfg,
> +					gyro_handle,
> +					mldl_cfg->slave[ii],
> +					mldl_cfg->pdata_slave[ii],
> +					mldl_cfg->slave[ii]->type);
> +			if (result) {
> +				LOG_RESULT_LOCATION(result);
> +				return result;
> +			}
> +		}
> +	}
> +
> +	/* Turn on the master i2c iterface if necessary */
> +	if (resume_dmp) {

Here is where the bypass mode removed if the DMP needs the data.  If this
is done access to the slave cannot occur unless the mpu3050 is first
bypassed.

> +		result = mpu_set_i2c_bypass(
> +			mldl_cfg, gyro_handle,
> +			!(mldl_cfg->inv_mpu_state->i2c_slaves_enabled));
> +		if (result) {
> +			LOG_RESULT_LOCATION(result);
> +			return result;
> +		}
> +
> +		/* Now start */
> +		result = dmp_start(mldl_cfg, gyro_handle);
> +		if (result) {
> +			LOG_RESULT_LOCATION(result);
> +			return result;
> +		}
> +	}
> +	mldl_cfg->inv_mpu_cfg->requested_sensors = sensors;
> +
> +	return result;
> +}

We weren't interested in standalone drivers at the time we started writing
the driver, but I think now is the time to start thinking about how to
merge the two sets of requirements.  We currently support each sensor in a
standalone fashion, but in our own unique way, I just need to figure out
the right way.

The feedback I've seen so far suggest that the iio layer is where this
driver belongs and how the standalone interface should look.  Today was
the first I heard of the iio layer, so I have some significant research to
do on how to do this.  From my brief look this morning, it looks like
there is a lot of stuff already in place that we can make use of.

Again, everybody thank you for the feedback.  Very helpful!
