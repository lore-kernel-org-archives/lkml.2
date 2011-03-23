Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab1CWWit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 18:38:49 -0400
Received: from 90-46-11-204.rar.beartech.net ([204.11.46.90]:3290 "EHLO
	exchsrvr.taosinc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756705Ab1CWWis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 18:38:48 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Subject: RE: [PATCH 2.6.38-rc7]TAOS 258x: Device Driver
Date: Wed, 23 Mar 2011 17:38:47 -0500
Message-ID: <B4B07CCC7B7A084E989CF9386538EA1D63A93D@exchsrvr.taosinc.com>
In-Reply-To: <4D89D441.9030600@cam.ac.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.38-rc7]TAOS 258x: Device Driver
Thread-Index: AcvpSjkQCyyEjTL4RM+hMaAr64+UVgASlOZg
References: <1300131941.17298.17.camel@jonz-ubuntu> <4D87A1D6.2080306@cam.ac.uk> <B4B07CCC7B7A084E989CF9386538EA1D63A83B@exchsrvr.taosinc.com> <4D89D441.9030600@cam.ac.uk>
From: "Jon Brenner" <jbrenner@TAOSinc.com>
To: "Jonathan Cameron" <jic23@cam.ac.uk>
Cc: <linux-iio@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p2NMd2DG015847

Hi Jonathan,
Below are a few comments/questions to your latest response.
Any direction is greatly appreciated.

Jon


-----Original Message-----
From: Jonathan Cameron [mailto:jic23@cam.ac.uk] 
Sent: Wednesday, March 23, 2011 6:07 AM
To: Jon Brenner
Cc: linux-iio; Linux Kernel
Subject: Re: [PATCH 2.6.38-rc7]TAOS 258x: Device Driver

On 03/23/11 01:07, Jon Brenner wrote:
> Jonathan, et al,
> 
> Again, thank you for taking the time to review the latest submission.
> I have implemented all recommendations made (with the exceptions noted below).
> 
> I have also added two new functions (not seen here):
> 'taos_suspend', and 'taos_resume'
> 
> These changes and comments will be submitted in the next patch [PATCH V3] submission which I will submit shortly (after testing/verification). 
> 
> Respectfully,
> Jon
> 
> -----Original Message-----
> As I pm'd you the other day, please remember to make version of patch clear in title, and include details of what has changed since previous version.
> OK - NEXT PATCH WILL INDICATE VERSION 3
> 
> WILL REMOVE SENSORS_ PREFIX FROM KCONFIG & MAKEFILE
> 
> ADDED/MOVED/CREATED DOCUMENTATION AS RECOMMENDED
> 
> ----- snip ------------
>> +/*
>> + * Provides initial operational parameter defaults.
>> + * These defaults may be changed through the device's sysfs files.
>> + */
> How about pasing in taos_settings and making all of this func a bit more readable?
> PREFER TO USE DEFAULTS METHOD
Ah, I didn't make clear what I meant here. It was simply an observation that having

static void taos_defaults(struct taos_settings *settings) {
	settings->als_time = 450;
etc.
} 

would be easier to read.
> 
>> +static void taos_defaults(struct tsl2583_chip *chip) {
>> +	/* Operational parameters */
>> +	chip->taos_settings.als_time = 450;
>> +	/* must be a multiple of 50mS */
>> +	chip->taos_settings.als_gain = 2;
>> +	/* this is actually an index into the gain table */
>> +	/* assume clear glass as default */
>> +	chip->taos_settings.als_gain_trim = 1000;
>> +	/* default gain trim to account for aperture effects */
>> +	chip->taos_settings.als_cal_target = 130;
>> +	/* Known external ALS reading used for calibration */ }
>> +
> 
> ----- snip ------------
>> +	if ((ch0 >= chip->als_saturation) || (ch1 >= chip->als_saturation))
> would be easier to read if you set ret to lux max here an avoid 
> jumping into the if statement below.
> NO - TSL258X_LUX_CALC_OVER_FLOW NEEDS TO PASSED UP.  
> 	MUTEX NEEDS TO BE UNLOCKED. 
> 	THEN RETURN.
Sorry, should have said jump to out_unlock having set ret = LUX_CALC_OVER_FLOW;

Just makes for marginally cleaner program flow to my mind (though I don't really care about this one).

I UNDERSTAND BUT I FORGOT TO MENTION THAT IN ADDITION TO THE ABOVE, ALSO NEEDS TO UPDATE THE ALS_CUR_INFO STRUCT.
SO, ALL SAID - EASIER TO SIMPLY JUMP TO RETURN_MAX, AS THIS IS ALL DONE THERE.

>> +		goto return_max;
> 
> ----- snip ------------
> &taos_device_lux[0] perhaps?
> NO - CAST MAKES IT MORE OBVIOUS - at least to me ;-)
>> +	for (p = (struct taos_lux *) taos_device_lux;
> 
> ----- snip ------------
>> +
> If not time critical lest make that a sleep.
> NO - TIME IS REQUIRED FOR DEVICE TO SETTLE BETWEEN POWERON AND ADC ENABLE - DON'T WANT TO MAKE IT ANY LONGER THAN NECESSARY.
But do you want to spin the processor during this time instead of getting on with something useful?
I guess it depends on how critical speed is in the taos_chip_on function. I'd say this device is slow enough that a possible extra delay doesn't really matter.
>> +	mdelay(3);

AGREED - CHANGED TO MSLEEP(3);


>> +	/* NOW enable the ADC
> 
> 
> ----- snip ------------
> I still wonder if there isn't a way of avoiding this index issue.
> It's horrible and really feels like something we ought to able to 
> handle reasonably well...
> BECAUSE THE CH0 AND CH1 DIVERGE AT HIGH GAINS -- INDEX IS BETTER THAN 
> USING CHO OR CH1 VALUE ( AS EITHER ONE OVER THE OTHER WOULD BE WRONG 
> :-{ )
I can see your point to a certain extent.  The counter argument is that doing it with an index precludes ever touching this with any remotely general purpose user space code.  Given it's an internal gain anyway is the precise value that critical?  Basically is user space ever going to care about the difference between those those values?

Another option would be to have a gain for each channel as separate attributes (clearly writing to one would change the other).

I SEE YOUR POINT TOO - BUT WHAT ELSE CAN I DO (ASIDE FROM A SEPARATE GAIN FOR EACH CHANNEL - WHICH WOULD BE CONFUSING TO MANAGE)?
I GUESS I COULD BUCKETIZE ANYTHING > GAIN 16 - BUT THAT SEEMS RATHER KLUDGED?
AGAIN SEEMS LIKE MOST REASONABLE (FOR NOW ANYWAY) IS AN INDEX.


>> +	if (value > 3) {
>> +		dev_err(dev, "Invalid Gain Index: Enter 0-3\n");
>> +		return -1;
>> +	} else {
>> +		chip->taos_settings.als_gain = value;
>> +	}
>> +	return len;
>> +}
> 
> ----- snip ------------
> Just to confirm, is this a frequency in Hz? If it is can we renaming 
> it to taos_als_frequency_show to avoid confusing me?
> 
> THIS IS THE INTERNAL ALS INTEGRATION TIME FOR THE ADC CHANNELS I SHOE 
> HORNED IT INTO SAMPLING FREQUENCY TO HELP ALEVIATE THE ABI ANGST
That's good but it does have to match the units specified in the ABI as well.

OK - MAYBE I'M MISSING SOME INFO.
ALL I HAVE FOR THE ABI IS THIS:
what:		/sys/bus/iio/devices/deviceX/sampling_frequency
KernelVersion:	2.6.35
Contact:	linux-iio@vger.kernel.org
Description:
		Some devices have internal clocks.  This parameter sets the
		resulting sampling frequency.  In many devices this
		parameter has an effect on input filters etc rather than
		simply controlling when the input is sampled.  As this
		effects datardy triggers, hardware buffers and the sysfs
		direct access interfaces, it may be found in any of the
		relevant directories.  If it effects all of the above
		then it is to be found in the base device directory as here.

SO I AM UNSURE OF WHAT UNITS NEED TO MATCH?

> 
>> +static ssize_t taos_als_time_show(struct device *dev,
>> +    struct device_attribute *attr, char *buf) {
>> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
>> +	struct tsl2583_chip *chip = indio_dev->dev_data;
>> +
>> +	return sprintf(buf, "%d\n", chip->taos_settings.als_time); }
> 
> ----- snip ------------
> scale as a stand alone attribute isn't defined. Please document this.
> Looking at what you do with it, it's another factor effecting the 
> overal gain on the reading that reaches userspace.  Ideally you'd roll 
> this into your calibscale parameter, but I can see that would get 
> complex to manage. Will have a think about this. In devices with a 
> simple conversion function (adc's etc) we handle this by leaving this 
> software value be applied by userspace (and output it as in_scale). 
> The issue here that as far as userspace is concerned both of your 
> scales have been applied before it sees the data and at different more 
> or less random looking points in the calculation.
> 
> Actually, looking at the calculation you could output illuminance0_raw 
> and let userspace apply a multiplier based on your trim value and 
> offset
> +0.5?  If you want to hold trim in driver then just implement
> read and write to
> 
> illuminance0_scale
> and have read only
> illuminance0_offset (rather tediously for this device, offset is 
> applied before scale, so you'll need to divide 0.5 by whatever your trim is).
> 
> We'll have to do pin down how to do this before moving out of staging 
> so best to get it right now.
> 
> CHANGED TO ILLUMINANCE0_SCALE
> 
> LIFE WOULE BE NICE IF WE COULD JUST PASS THE RAW DATA UP TO USERSPACE 
> BUT WE HAVE CUSTOMERS WHO REQUIRE IT TO COME UP CALCULATED WITH THE 
> MULTIPLIER FACTORED IN
Sure. It's a fiddly calculation so I can kind of see their point.
These light sensors are all a pain :)
SO - WE ARE OK?
> 
> ----- snip ------------
>> +	for (i = 0; i < MAX_DEVICE_REGS; i++) {
>> +		ret = i2c_smbus_write_byte(clientp,
>> +				(TSL258X_CMD_REG | (TSL258X_CNTRL + i)));
>> +		if (ret < 0) {
>> +			dev_err(&clientp->dev, "i2c_smbus_write_byte() to cmd "
>> +				"reg failed in taos_probe(), err = %d\n", ret);
>> +			goto fail1;
>> +		}
>> +		buf[i] = i2c_smbus_read_byte(clientp);
>   error handling for this read?
> VALUE IS UNIMPORTANT - BUT MAKING SURE WE CAN JUST READ ALL 32 REGISTER LOCATIONS IS..
> 
> ----- snip ------------
> 
>> +	}
>> +	if (!taos_skate_device(buf)) {
>> +		dev_info(&clientp->dev, "i2c device found but does not match "
>> +			"expected id in taos_probe()\n");
>> +		goto fail1;
>> +	} else {
> The sort of debug info you want to get rid of for production drivers.  
> Doesn't tell anyone anything helpful.
> NO - DO NOT AGREE - IF A CUSTOMER EXPECTS ONE DEVICE BUT HAS SOMEHOW 
> INSTALLED A DIFFERENT ONE AT PRODUCTION TIME, THIS WILL HELP IDENTIFY THE ISSUE.
> (IE. WANTED A TAOS ALS DEVICE BUT INSTALLED A TAOS PROX/ALS DEVICE) 
> FIRST PART INDICATES THAT.  SECOND PART IS CONFIRMATION THAT DEVICE WAS IDENTIFIED TO SYSTEM.

I'm happy with the error one. Just don't see the point in saying 'everything is as expected'.
The mere absence of the error indicates that just fine!
AGREED - REMOVED 2ND PART (THE OK MESSAGE)

Jonathan

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
