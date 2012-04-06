Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab2DFKQy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 06:16:54 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:34660 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835Ab2DFKQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 06:16:52 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4F7EC289.50405@cam.ac.uk>
Date: Fri, 06 Apr 2012 11:16:41 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120314 Thunderbird/11.0
MIME-Version: 1.0
To: Jon Brenner <jbrenner@TAOSinc.com>
CC: jic23@kernel.org, linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        dg77.kim@samsung.com
Subject: Re: tsl2x7x driver Sampling frequency
References: <B4B07CCC7B7A084E989CF9386538EA1D0120B9AB@exchsrvr.taosinc.com> <4F7C82A6.80706@cam.ac.uk> <B4B07CCC7B7A084E989CF9386538EA1D01255E9B@exchsrvr.taosinc.com>
In-Reply-To: <B4B07CCC7B7A084E989CF9386538EA1D01255E9B@exchsrvr.taosinc.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2012 09:54 PM, Jon Brenner wrote:
> Jonathon,
> So are you saying that I should change (remove) the sampling_frequency
> ABI, and implement 2 new (to this driver) ABIs called:
> in_intensity0_thresh_period, and in_proximity0_thresh_period?
yes.
> 
> Since the minimum H/W filter time (based on an minimum ALS or Prox
> integration resolution) we're working with here is 2.7ms, and a maximum
> filter time of  up to 162ms (60 out of range * 2.7), the value is
> adjusted in milliseconds  (Khz).
> Is this acceptable?
Nope, seconds with INT_PLUS_MICRO as the iio unit type (which effecively
means that you'll always have 0 in val and you ms value
* 1000 in the val2 parameter of the callback.
> 
> What about _thresh_period_available?
> 
> I guess I could simply use the simple computed value of [ X = Atime *
> Integration] and display the values from minimum up to [60 * X] - but
> that seems kind of silly.
> Could simply a min and a max period be presented?
We've never defined an interface for it, but it probably would be
useful... Usually when it gets non obvious like this we just drop the
available attribute entirely.
> 
> Caveat:  A or P integration times could be changed 'post' selection of
> the _thresh_period which would of course then impact the _thresh_period.
Yes. Hence what you do is take any value that is written and cache it.
A read gives the current actual value. When the other parameters change
you work out what the new nearest value to that requested is and switch
to that one alongside the other parameter changing.  Thus if a true set
of possible parameters is possible you will always get it, otherwise you
will fall back to the best that can be done.
> 
> Oh what a tangled web..
Yup, common problem though with the various parameters!
> 
> Jon
> 
>> -----Original Message-----
>> From: Jonathan Cameron [mailto:jic23@cam.ac.uk]
>> Sent: Wednesday, April 04, 2012 12:20 PM
>> To: Jon Brenner
>> Cc: jic23@kernel.org; linux-iio@vger.kernel.org;
> linux-kernel@vger.kernel.org;
>> dg77.kim@samsung.com
>> Subject: Re: tsl2x7x driver Sampling frequency
>>
>> On 04/04/2012 05:40 PM, Jon Brenner wrote:
>>> Jonathon,
>>>
>>> You wrote;
>>> <snip>
>>> Units don't look right for sampling frequency.  Sorry, but that's an
>>> abi
>>>
>>> issue so even if it is
>>> fiddly to do the conversion to Hz it needs to be done.
>>> </snip>
>>>
>>> Need some help here.
>>> In the tsl2x7x driver sampling frequency is being used for setting
>>> "persistence register".
>>> It's actually a H/W filter.
>> Gah, you mentioned this before and I meant to look back at the
> previous times
>> we have hit this particular type of control (it's pretty common!)
>>
>>> Here is an abstract from the data sheet:
>>> --
>>> Persistence Register (0x0C)
>>> The persistence register controls the filtering interrupt
> capabilities
>>> of the device. Configurable filtering is provided to allow
> interrupts
>>> to be generated after each ADC integration cycle or if the ADC
>>> integration has produced a result that is outside of the values
>>> specified by threshold register for some specified amount of time.
>>> Separate filtering is provided for proximity and ALS functions. ALS
>>> interrupts are generated using C0DATA.
>>> --
>>> The value provided here by the ABI is actually the number of
>>> 'consecutive values out of range'.
>>>
>>> The H/W takes care of counting the consecutive values out of range
> and
>>> issues and interrupt when reached.
>>>
>>> The timing (or frequency) of these out of range values are based on
>>> the ALS or Prox integration time (determined by that respective
> setting).
>>> That being the case a fixed table of sampling "frequencies" cannot
> be
>>> reasonably defined - as the frequency can vary widely, based on
> other
>>> settings.
>>>
>>> So the register really is set to the desired number of 'values out
> of
>>> range'.
>>> To add another slight twist, the value (number of out of range)
>>> increases by 1 until 5, then by 5 until 60 - with the caveat that a
>>> value of 0 generates an interrupt every ALS or Prox integration
> cycle .
>>>
>>> Since the sysfs-bus-iio doc contained a close match with respect to
>>> the
>>> operation:
>>> Description:
>>> 		Some devices have internal clocks.  This parameter sets
> the
>>> 		resulting sampling frequency.  In many devices this
>>> 		parameter has an effect on input filters etc rather than
>>> 		simply controlling when the input is sampled.  As this
>>> 		effects datardy triggers, hardware buffers and the sysfs
>>> 		direct access interfaces, it may be found in any of the
>>> 		relevant directories.  If it effects all of the above
>>> 		then it is to be found in the base device directory.
>>>
>>> Thus we used "sampling_frequency" - but now I am wondering if it
>>> should be something else.
>>>
>>> If this is better suited for a different ABI please tell me what
> that
>>> would be.
>> I'd argue this should really be sampling frequency anyway.  It's
> actually a
>> common enough thing to see.
>> I was sure we'd hit this before and indeed we did with the
>> tmd277711 driver back in 2010 (hit the mailing list archives for that
> one).
>> Dongguen Kim was the author (cc'd).  Actually grep shows that my own
> sca3000
>> driver has this too (it's been a while!)
>>
>> It's actually made it through in the abi docs for all sorts of event
> types though I
>> think the only correct user is the sca3000 accelerometer.
>> Description is...
>> 	Period of time (in seconds) for which the condition must be
>> 	met before an event is generated. If direction is not
>> 	specified then this period applies to both directions.
>>
>> I know it is annoying that this parameter in side the device is very
> heavily
>> dependent on other controls (often the case with this sort of
>> thing) but to have a remotely consistent interface we have to define a
> standard
>> unit.  Hence the 'right' way to handle this is to have a cached value
> in seconds
>> and then work out the nearest possible setting when ever anything else
> that
>> effects it is changed. Fiddly, but we are playing this game all over
> the place in
>> other drivers.
>>
>> So here you are going to have
>>
>> in_intensity0_thresh_period and in_proximity0_thresh_period
>>
>> Both probably taking values as INT_PLUS_MICRO.
>>
>> Note that we have other filters controls for events such as hysterisis
> which is
>> common on raw adc's.
>>
>>
>> Jonathan
>>>
>>> Please help!
>>>
>>> Jon
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-iio"
>>> in the body of a message to majordomo@vger.kernel.org More majordomo
>>> info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

