Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070Ab1CXLO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 07:14:28 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:40779 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644Ab1CXLO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 07:14:26 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D8B27DF.5060608@cam.ac.uk>
Date: Thu, 24 Mar 2011 11:15:43 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Jon Brenner <jbrenner@TAOSinc.com>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.38-rc7]TAOS 258x: Device Driver
References: <1300131941.17298.17.camel@jonz-ubuntu> <4D87A1D6.2080306@cam.ac.uk> <B4B07CCC7B7A084E989CF9386538EA1D63A83B@exchsrvr.taosinc.com> <4D89D441.9030600@cam.ac.uk> <B4B07CCC7B7A084E989CF9386538EA1D63A93D@exchsrvr.taosinc.com>
In-Reply-To: <B4B07CCC7B7A084E989CF9386538EA1D63A93D@exchsrvr.taosinc.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/11 22:38, Jon Brenner wrote:
> Hi Jonathan,
> Below are a few comments/questions to your latest response.
> Any direction is greatly appreciated.
> 
> Jon
No chance you can persuade your email client to do conventional
indenting?  Ah well, I guess this works more or less.

>>
>> ----- snip ------------
>>> +	if ((ch0 >= chip->als_saturation) || (ch1 >= chip->als_saturation))
>> would be easier to read if you set ret to lux max here an avoid 
>> jumping into the if statement below.
>> NO - TSL258X_LUX_CALC_OVER_FLOW NEEDS TO PASSED UP.  
>> 	MUTEX NEEDS TO BE UNLOCKED. 
>> 	THEN RETURN.
> Sorry, should have said jump to out_unlock having set ret = LUX_CALC_OVER_FLOW;
> 
> Just makes for marginally cleaner program flow to my mind (though I don't really care about this one).
> 
> I UNDERSTAND BUT I FORGOT TO MENTION THAT IN ADDITION TO THE ABOVE, ALSO NEEDS TO UPDATE THE ALS_CUR_INFO STRUCT.
> SO, ALL SAID - EASIER TO SIMPLY JUMP TO RETURN_MAX, AS THIS IS ALL DONE THERE.
Fair enough.  Was just personal preference anyway!
...
> 
>>> +	/* NOW enable the ADC
>>
>>
>> ----- snip ------------
>> I still wonder if there isn't a way of avoiding this index issue.
>> It's horrible and really feels like something we ought to able to 
>> handle reasonably well...
>> BECAUSE THE CH0 AND CH1 DIVERGE AT HIGH GAINS -- INDEX IS BETTER THAN 
>> USING CHO OR CH1 VALUE ( AS EITHER ONE OVER THE OTHER WOULD BE WRONG 
>> :-{ )
> I can see your point to a certain extent.  The counter argument is that doing it with an index precludes ever touching this with any remotely general purpose user space code.  Given it's an internal gain anyway is the precise value that critical?  Basically is user space ever going to care about the difference between those those values?
> 
> Another option would be to have a gain for each channel as separate attributes (clearly writing to one would change the other).
> 
> I SEE YOUR POINT TOO - BUT WHAT ELSE CAN I DO (ASIDE FROM A SEPARATE GAIN FOR EACH CHANNEL - WHICH WOULD BE CONFUSING TO MANAGE)?
> I GUESS I COULD BUCKETIZE ANYTHING > GAIN 16 - BUT THAT SEEMS RATHER KLUDGED?
> AGAIN SEEMS LIKE MOST REASONABLE (FOR NOW ANYWAY) IS AN INDEX.
It may be reasonable, but it isn't generalizable which means it probably isn't viable
long term.  The parameter simply won't be used by anything that isn't custom coded
for this particular sensor.   Even Taos' next generation of sensors probably won't
have an index which has the same effect.

If it can be coherently blugeoned into existing interfaces, then we should do so.
There are quite a few other bits of IIO interface where changing one value will
effect others.  This means (and we could emphasise it more) that there are sets
of values user space MUST check after making a given change if it wants to know
the full device state.  Believe me, things are much more complex with devices
that do partial scans of channels only in some combinations!

>> Just to confirm, is this a frequency in Hz? If it is can we renaming 
>> it to taos_als_frequency_show to avoid confusing me?
>>
>> THIS IS THE INTERNAL ALS INTEGRATION TIME FOR THE ADC CHANNELS I SHOE 
>> HORNED IT INTO SAMPLING FREQUENCY TO HELP ALEVIATE THE ABI ANGST
> That's good but it does have to match the units specified in the ABI as well.
> 
> OK - MAYBE I'M MISSING SOME INFO.
> ALL I HAVE FOR THE ABI IS THIS:
> what:		/sys/bus/iio/devices/deviceX/sampling_frequency
> KernelVersion:	2.6.35
> Contact:	linux-iio@vger.kernel.org
> Description:
> 		Some devices have internal clocks.  This parameter sets the
> 		resulting sampling frequency.  In many devices this
> 		parameter has an effect on input filters etc rather than
> 		simply controlling when the input is sampled.  As this
> 		effects datardy triggers, hardware buffers and the sysfs
> 		direct access interfaces, it may be found in any of the
> 		relevant directories.  If it effects all of the above
> 		then it is to be found in the base device directory as here.
> 
> SO I AM UNSURE OF WHAT UNITS NEED TO MATCH?
Fair point. That documentation is clearly lacking. One for the TODO list.
Anyhow, it does say sampling frequency so the units can't be a measure of
time.  What it should say is 'in Hz' somewhere.
> 
>>
>>> +static ssize_t taos_als_time_show(struct device *dev,
>>> +    struct device_attribute *attr, char *buf) {
>>> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
>>> +	struct tsl2583_chip *chip = indio_dev->dev_data;
>>> +
>>> +	return sprintf(buf, "%d\n", chip->taos_settings.als_time); }
>>
>> ----- snip ------------
>> scale as a stand alone attribute isn't defined. Please document this.
>> Looking at what you do with it, it's another factor effecting the 
>> overal gain on the reading that reaches userspace.  Ideally you'd roll 
>> this into your calibscale parameter, but I can see that would get 
>> complex to manage. Will have a think about this. In devices with a 
>> simple conversion function (adc's etc) we handle this by leaving this 
>> software value be applied by userspace (and output it as in_scale). 
>> The issue here that as far as userspace is concerned both of your 
>> scales have been applied before it sees the data and at different more 
>> or less random looking points in the calculation.
>>
>> Actually, looking at the calculation you could output illuminance0_raw 
>> and let userspace apply a multiplier based on your trim value and 
>> offset
>> +0.5?  If you want to hold trim in driver then just implement
>> read and write to
>>
>> illuminance0_scale
>> and have read only
>> illuminance0_offset (rather tediously for this device, offset is 
>> applied before scale, so you'll need to divide 0.5 by whatever your trim is).
>>
>> We'll have to do pin down how to do this before moving out of staging 
>> so best to get it right now.
>>
>> CHANGED TO ILLUMINANCE0_SCALE
>>
>> LIFE WOULE BE NICE IF WE COULD JUST PASS THE RAW DATA UP TO USERSPACE 
>> BUT WE HAVE CUSTOMERS WHO REQUIRE IT TO COME UP CALCULATED WITH THE 
>> MULTIPLIER FACTORED IN
> Sure. It's a fiddly calculation so I can kind of see their point.
> These light sensors are all a pain :)
> SO - WE ARE OK?
Err. I've kind of lost track, but I think so.  Will take one last look
at your next revision!  Sounds like it may have some interesting new features
anyway given the other thread!
>>
>> ----- snip ------------
>>> +	for (i = 0; i < MAX_DEVICE_REGS; i++) {
>>> +		ret = i2c_smbus_write_byte(clientp,
>>> +				(TSL258X_CMD_REG | (TSL258X_CNTRL + i)));
>>> +		if (ret < 0) {
>>> +			dev_err(&clientp->dev, "i2c_smbus_write_byte() to cmd "
>>> +				"reg failed in taos_probe(), err = %d\n", ret);
>>> +			goto fail1;
>>> +		}
>>> +		buf[i] = i2c_smbus_read_byte(clientp);
>>   error handling for this read?
>> VALUE IS UNIMPORTANT - BUT MAKING SURE WE CAN JUST READ ALL 32 REGISTER LOCATIONS IS..
That's fine, but you haven't verified that if you don't check for a negative return
from that read.
>>
>> ----- snip ------------
>>
>>> +	}
>>> +	if (!taos_skate_device(buf)) {
>>> +		dev_info(&clientp->dev, "i2c device found but does not match "
>>> +			"expected id in taos_probe()\n");
>>> +		goto fail1;
>>> +	} else {
>> The sort of debug info you want to get rid of for production drivers.  
>> Doesn't tell anyone anything helpful.
>> NO - DO NOT AGREE - IF A CUSTOMER EXPECTS ONE DEVICE BUT HAS SOMEHOW 
>> INSTALLED A DIFFERENT ONE AT PRODUCTION TIME, THIS WILL HELP IDENTIFY THE ISSUE.
>> (IE. WANTED A TAOS ALS DEVICE BUT INSTALLED A TAOS PROX/ALS DEVICE) 
>> FIRST PART INDICATES THAT.  SECOND PART IS CONFIRMATION THAT DEVICE WAS IDENTIFIED TO SYSTEM.
> 
> I'm happy with the error one. Just don't see the point in saying 'everything is as expected'.
> The mere absence of the error indicates that just fine!
> AGREED - REMOVED 2ND PART (THE OK MESSAGE)
Cool

Coming together nicely.

Jonathan
