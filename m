Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab1CWBHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 21:07:34 -0400
Received: from 90-46-11-204.rar.beartech.net ([204.11.46.90]:44474 "EHLO
	exchsrvr.taosinc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752127Ab1CWBHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 21:07:32 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Subject: RE: [PATCH 2.6.38-rc7]TAOS 258x: Device Driver
Date: Tue, 22 Mar 2011 20:07:30 -0500
Message-ID: <B4B07CCC7B7A084E989CF9386538EA1D63A83B@exchsrvr.taosinc.com>
In-Reply-To: <4D87A1D6.2080306@cam.ac.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.38-rc7]TAOS 258x: Device Driver
Thread-Index: Acvn+v+7KMPzm+R0ROqNm7nnXv//ngA0w7gw
References: <1300131941.17298.17.camel@jonz-ubuntu> <4D87A1D6.2080306@cam.ac.uk>
From: "Jon Brenner" <jbrenner@TAOSinc.com>
To: "Jonathan Cameron" <jic23@cam.ac.uk>
Cc: "linux-iio" <linux-iio@vger.kernel.org>,
        "Linux Kernel" <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p2N17f4m009463

Jonathan, et al,

Again, thank you for taking the time to review the latest submission.
I have implemented all recommendations made (with the exceptions noted below).

I have also added two new functions (not seen here):
'taos_suspend', and 'taos_resume'

These changes and comments will be submitted in the next patch [PATCH V3] submission which I will submit shortly (after testing/verification). 

Respectfully,
Jon 

-----Original Message-----
As I pm'd you the other day, please remember to make version of patch clear in title, and include details of what has changed since previous version.
OK - NEXT PATCH WILL INDICATE VERSION 3

WILL REMOVE SENSORS_ PREFIX FROM KCONFIG & MAKEFILE

ADDED/MOVED/CREATED DOCUMENTATION AS RECOMMENDED

----- snip ------------
> +/*
> + * Provides initial operational parameter defaults.
> + * These defaults may be changed through the device's sysfs files.
> + */
How about pasing in taos_settings and making all of this func a bit more readable?
PREFER TO USE DEFAULTS METHOD

> +static void taos_defaults(struct tsl2583_chip *chip) {
> +	/* Operational parameters */
> +	chip->taos_settings.als_time = 450;
> +	/* must be a multiple of 50mS */
> +	chip->taos_settings.als_gain = 2;
> +	/* this is actually an index into the gain table */
> +	/* assume clear glass as default */
> +	chip->taos_settings.als_gain_trim = 1000;
> +	/* default gain trim to account for aperture effects */
> +	chip->taos_settings.als_cal_target = 130;
> +	/* Known external ALS reading used for calibration */ }
> +

----- snip ------------
> +	if ((ch0 >= chip->als_saturation) || (ch1 >= chip->als_saturation))
would be easier to read if you set ret to lux max here an avoid jumping into
the if statement below.
NO - TSL258X_LUX_CALC_OVER_FLOW NEEDS TO PASSED UP.  
	MUTEX NEEDS TO BE UNLOCKED. 
	THEN RETURN.
> +		goto return_max;

----- snip ------------
&taos_device_lux[0] perhaps?
NO - CAST MAKES IT MORE OBVIOUS - at least to me ;-)
> +	for (p = (struct taos_lux *) taos_device_lux;

----- snip ------------
> +
If not time critical lest make that a sleep.
NO - TIME IS REQUIRED FOR DEVICE TO SETTLE BETWEEN POWERON AND ADC ENABLE - DON'T WANT TO MAKE IT ANY LONGER THAN NECESSARY.
> +	mdelay(3);
> +	/* NOW enable the ADC


----- snip ------------
I still wonder if there isn't a way of avoiding this index issue.
It's horrible and really feels like something we ought to able
to handle reasonably well...
BECAUSE THE CH0 AND CH1 DIVERGE AT HIGH GAINS -- INDEX IS BETTER THAN USING CHO OR CH1 VALUE 
( AS EITHER ONE OVER THE OTHER WOULD BE WRONG :-{ )
> +	if (value > 3) {
> +		dev_err(dev, "Invalid Gain Index: Enter 0-3\n");
> +		return -1;
> +	} else {
> +		chip->taos_settings.als_gain = value;
> +	}
> +	return len;
> +}

----- snip ------------
Just to confirm, is this a frequency in Hz? If it is
can we renaming it to taos_als_frequency_show to
avoid confusing me?

THIS IS THE INTERNAL ALS INTEGRATION TIME FOR THE ADC CHANNELS
I SHOE HORNED IT INTO SAMPLING FREQUENCY TO HELP ALEVIATE THE ABI ANGST

> +static ssize_t taos_als_time_show(struct device *dev,
> +    struct device_attribute *attr, char *buf)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct tsl2583_chip *chip = indio_dev->dev_data;
> +
> +	return sprintf(buf, "%d\n", chip->taos_settings.als_time);
> +}

----- snip ------------
scale as a stand alone attribute isn't defined. Please document this.
Looking at what you do with it, it's another factor effecting the overal
gain on the reading that reaches userspace.  Ideally you'd roll this
into your calibscale parameter, but I can see that would get complex
to manage. Will have a think about this. In devices with a simple conversion
function (adc's etc) we handle this by leaving this software value
be applied by userspace (and output it as in_scale). The issue here that
as far as userspace is concerned both of your scales have been applied before
it sees the data and at different more or less random looking points in
the calculation.

Actually, looking at the calculation you could output illuminance0_raw
and let userspace apply a multiplier based on your trim value and offset
+0.5?  If you want to hold trim in driver then just implement
read and write to

illuminance0_scale
and have read only
illuminance0_offset (rather tediously for this device, offset is applied
before scale, so you'll need to divide 0.5 by whatever your trim is).

We'll have to do pin down how to do this before moving out of staging
so best to get it right now.

CHANGED TO ILLUMINANCE0_SCALE

LIFE WOULE BE NICE IF WE COULD JUST PASS THE RAW DATA UP TO USERSPACE
BUT WE HAVE CUSTOMERS WHO REQUIRE IT TO COME UP CALCULATED WITH
THE MULTIPLIER FACTORED IN

----- snip ------------
> +	for (i = 0; i < MAX_DEVICE_REGS; i++) {
> +		ret = i2c_smbus_write_byte(clientp,
> +				(TSL258X_CMD_REG | (TSL258X_CNTRL + i)));
> +		if (ret < 0) {
> +			dev_err(&clientp->dev, "i2c_smbus_write_byte() to cmd "
> +				"reg failed in taos_probe(), err = %d\n", ret);
> +			goto fail1;
> +		}
> +		buf[i] = i2c_smbus_read_byte(clientp);
  error handling for this read?
VALUE IS UNIMPORTANT - BUT MAKING SURE WE CAN JUST READ ALL 32 REGISTER LOCATIONS IS..

----- snip ------------

> +	}
> +	if (!taos_skate_device(buf)) {
> +		dev_info(&clientp->dev, "i2c device found but does not match "
> +			"expected id in taos_probe()\n");
> +		goto fail1;
> +	} else {
The sort of debug info you want to get rid of for production drivers.  Doesn't
tell anyone anything helpful.
NO - DO NOT AGREE - IF A CUSTOMER EXPECTS ONE DEVICE BUT HAS SOMEHOW INSTALLED A DIFFERENT ONE
AT PRODUCTION TIME, THIS WILL HELP IDENTIFY THE ISSUE.  
(IE. WANTED A TAOS ALS DEVICE BUT INSTALLED A TAOS PROX/ALS DEVICE)
FIRST PART INDICATES THAT.  SECOND PART IS CONFIRMATION THAT DEVICE WAS IDENTIFIED TO SYSTEM.



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
