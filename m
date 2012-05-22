Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634Ab2EVHN1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 03:13:27 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:47893 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab2EVHNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 03:13:24 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4FBB3C88.6040009@cam.ac.uk>
Date: Tue, 22 May 2012 08:13:12 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Johan Hovold <jhovold@gmail.com>
CC: Jonathan Cameron <jic23@kernel.org>, Rob Landley <rob@landley.net>,
        Richard Purdie <rpurdie@rpsys.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org,
        "Hennerich, Michael" <Michael.Hennerich@analog.com>
Subject: Re: [PATCH v4] iio: add LM3533 ambient-light-sensor driver
References: <1337100396-29024-1-git-send-email-jhovold@gmail.com> <1337346461-31220-1-git-send-email-jhovold@gmail.com> <4FB75E57.9020003@kernel.org> <20120521095010.GD21033@localhost> <4FBA6F37.4000609@kernel.org> <20120521220754.GA6659@localhost>
In-Reply-To: <20120521220754.GA6659@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/2012 11:07 PM, Johan Hovold wrote:
> On Mon, May 21, 2012 at 05:37:11PM +0100, Jonathan Cameron wrote:
>> Michael cc'd for comments on core support of some stuff that is also
>> in frequency drivers down the end of the email.
>>
>> On 05/21/2012 10:50 AM, Johan Hovold wrote:
>>> On Sat, May 19, 2012 at 09:48:23AM +0100, Jonathan Cameron wrote:
>>>> On 05/18/2012 02:07 PM, Johan Hovold wrote:
>>>>> Add sub-driver for the ambient-light-sensor interface on National
>>>>> Semiconductor / TI LM3533 lighting power chips.
>>>>>
>>>>> The sensor interface can be used to control the LEDs and backlights of
>>>>> the chip through defining five light zones and three sets of
>>>>> corresponding brightness target levels.
>>>>>
>>>>> The driver provides raw and mean adc readings along with the current
>>>>> light zone through sysfs. A threshold event can be generated on zone
>>>>> changes.
>>>>
>>>> Hi Johan,
>>>>
>>>> I hate to be a pain with this one, but it's a complex beast and I'd
>>>> really like to get the interface right first time - particularly as
>>>> you are going in after the move out of staging.
>>>>
>>>>
>>>> Queries for you.
>>>> 1) Ordering in the probe function. Normally expect iio_device_register
>>>> to be the last call. Why not here?
>>>> 2) Worth combining enable / disable into one as very similar functions?
>>>> 3) Suspicious code in als_set_input_mode
>>>>
>>>> Naming of the target values.  I think we can make the naming of these
>>>> fit in much better with the normal abi which is going to be all for the
>>>> good in the long run.  They are basically current output channels
>>>> with a controllable set of steps (where we don't have direct control
>>>> of which one we are in).  This is very similar to the frequency controls
>>>> on some of Analog's dds that we have a well defined interface for.
>>>>
>>>> More detail below, but in summary.
>>>>
>>>> out_currentX_currentY_raw for channel X value for zone Y.
>>>>
>>>> Jonathan
>>>>>
>>>>> Signed-off-by: Johan Hovold<jhovold@gmail.com>
>>>>> ---
>>>>>
>>>>> Note that addition of r_select to the platform data probably needs to go
>>>>> in via mfd.
>>>>>
>>>>>
>>>>> v2:
>>>>>   - reimplement using iio
>>>>>   - add sysfs-ABI documentation
>>>>> v3
>>>>>   - use indexed channel
>>>>>   - fix sysfs-ABI documentation typo and style
>>>>>   - replace gain attribute with in_illuminance0_calibscale
>>>>>   - add calibscale to platform data
>>>>>   - fix adc register definitions
>>>>>   - replace to_lm3533_dev_attr macro with inline function
>>>>>   - fix device used for error reporting at irq allocation
>>>>>   - use iio device for error reporting during setup/enable
>>>>>   - rebase on staging-next
>>>>>     - fix header include paths
>>>>>     - use dev_to_iio_dev
>>>>>     - add IIO_CHAN_INFO_RAW to info mask
>>>>>     - use iio_device_{alloc,free}
>>>>> v4
>>>>>   - move to driver/iio/light
>>>>>   - add events/in_illuminance0_threshY_hysteresis attributes
>>>>>   - fix device zone-boundary quirkiness
>>>>>   - clean up attribute handling
>>>>>   - replace calibscale with device-specific r_select attribute
>>>>>
>>>>>
>>>>>   .../ABI/testing/sysfs-bus-iio-light-lm3533-als     |   64 ++
>>>>>   drivers/iio/Kconfig                                |    1 +
>>>>>   drivers/iio/Makefile                               |    1 +
>>>>>   drivers/iio/light/Kconfig                          |   22 +
>>>>>   drivers/iio/light/Makefile                         |    5 +
>>>>>   drivers/iio/light/lm3533-als.c                     |  941 ++++++++++++++++++++
>>>>>   include/linux/mfd/lm3533.h                         |    1 +
>>>>>   7 files changed, 1035 insertions(+), 0 deletions(-)
>>>>>   create mode 100644 Documentation/ABI/testing/sysfs-bus-iio-light-lm3533-als
>>>>>   create mode 100644 drivers/iio/light/Kconfig
>>>>>   create mode 100644 drivers/iio/light/Makefile
>>>>>   create mode 100644 drivers/iio/light/lm3533-als.c
>>>>>
>>>>> diff --git a/Documentation/ABI/testing/sysfs-bus-iio-light-lm3533-als b/Documentation/ABI/testing/sysfs-bus-iio-light-lm3533-als
>>>>> new file mode 100644
>>>>> index 0000000..7ea1770
>>>>> --- /dev/null
>>>>> +++ b/Documentation/ABI/testing/sysfs-bus-iio-light-lm3533-als
>>>>> @@ -0,0 +1,64 @@
>>>>> +What:		/sys/bus/iio/devices/iio:deviceX/r_select
>>>>> +Date:		April 2012
>>>>> +KernelVersion:	3.5
>>>>> +Contact:	Johan Hovold<jhovold@gmail.com>
>>>>> +Description:
>>>>> +		Set the ALS internal pull-down resistor for analog input mode
>>>>> +		(1..127), such that,
>>>>> +
>>>>> +		R_als = 200000 / r_select	(ohm)
>>>>> +
>>>>> +		This setting is ignored in PWM-mode (input is always high
>>>>> +		impedance in PWM-mode).
>>>>> +
>>>>> +What:		/sys/.../events/in_illuminance0_thresh_either_en
>>>>> +Date:		April 2012
>>>>> +KernelVersion:	3.5
>>>>> +Contact:	Johan Hovold<jhovold@gmail.com>
>>>>> +Description:
>>>>> +		Event generated when channel passes one of the four thresholds
>>>>> +		in each direction (rising|falling) and a zone change occurs.
>>>>> +		The corresponding light zone can be read from
>>>>> +		in_illuminance0_zone.
>>>>> +
>>>>> +What:		/sys/.../events/in_illuminance0_threshY_hysteresis
>>>>> +Date:		May 2012
>>>>> +KernelVersion:	3.5
>>>>> +Contact:	Johan Hovold<jhovold@gmail.com>
>>>>> +Description:
>>>>> +		Get the hysteresis for thresholds Y, that is,
>>>>> +
>>>>> +		threshY_hysteresis = threshY_raising - threshY_falling
>>>>> +
>>>>> +What:		/sys/.../events/illuminance_threshY_falling_value
>>>>> +What:		/sys/.../events/illuminance_threshY_raising_value
>>>>> +Date:		April 2012
>>>>> +KernelVersion:	3.5
>>>>> +Contact:	Johan Hovold<jhovold@gmail.com>
>>>>> +Description:
>>>>> +		Specifies the value of threshold that the device is
>>>>> +		comparing against for the events enabled by
>>>>> +		in_illuminance0_thresh_either_en, where Y in 0..3.
>>>>> +
>>>>> +		Note that threshY_falling must be less than or equal to
>>>>> +		threshY_raising.
>>>>> +
>>>>> +		These thresholds correspond to the eight zone-boundary
>>>>> +		registers (boundaryY_{low,high}) and defines the five light
>>>>> +		zones.
>>>>> +
>>>>> +What:		/sys/bus/iio/devices/iio:deviceX/in_illuminance0_zone
>>>>> +Date:		April 2012
>>>>> +KernelVersion:	3.5
>>>>> +Contact:	Johan Hovold<jhovold@gmail.com>
>>>>> +Description:
>>>>> +		Get the current light zone (0..4) as defined by the
>>>>> +		in_illuminance0_threshY_{falling,rising} thresholds.
>>>>> +
>>>>> +What:		/sys/bus/iio/devices/iio:deviceX/targetY_Z
>>>>> +Date:		April 2012
>>>>> +KernelVersion:	3.5
>>>>> +Contact:	Johan Hovold<jhovold@gmail.com>
>>>>> +Description:
>>>>> +		Set the target brightness for ALS-mapper Y in light zone Z
>>>>> +		(0..255), where Y in 1..3 and Z in 0..4.
>>>>
>>>> What are the units of this?
>>>
>>> The datasheet reads "percent of the full-scale current" (actually depends
>>> somewhat on whether the als is in linear or exponential mode). When the
>>> leds or backlights are in PWM-mode (not the ALS necessarily), these
>>> values are interpreted as a scale factor which is applied to the output
>>> current determined by the PWM-signal.
>>>
>>> Either way it could indeed be considered a raw output current (which
>>> could be manipulated later by various factors).
>> Fine.... Theoretically if at all possible we'd want the conversion
>> factors to get it to an actual current (in amps) to be available though.
>> (tend to relax that if there are unknowable elements or they aren't
>> specified by board file etc).
>
> Hmmm. I'm starting to get a feeling that we're over-doing this. The ALS
> on the lm3533 isn't a general purpose sensor. It's simply a way to
> control the leds and backlights of that device. So what you do is to
> determine the full-scale current (max current at maximum brightness 0xff
> in this case -- set in board file). Then the ALS input range is divided
> in 5 zones, and for each zone you set a brightness as a percent of the
> full-scale current. You relly don't care about amps (except for the
> maximum determined by the setup).
Then no need to provide scale etc.
>
> The equation's for determining the current are available in the
> datasheets however, but they depend on which mapping mode (linear or
> exponential) and can also be effected by PWM-input duty cycle etc. For
> this particular device, I really don't see the point in trying to
> determine actual current in amps in all these settings.
We can always add it later if anyone cares.
>
> Note also that the actual output current cannot be determined in the
> ALS as the required factors are only set/known in the led/backlight
> devices (mapping mode, pwm-mode).
Could query it back if it was useful, but sounds like probably not.
If we don't provide the information it can't be wrong...

I'd basically missunderstood where the division between the sensor and
the led/backlight drivers lay.  I think I'm happy now with where you 
have it.
>
>>>> Also arguably is it not the als that this is related to, but rather
>>>> the light source?
>>>
>>> Well, it would be a raw output, mapping the measured LUX.
>> Fair enough, though I wonder if we are stepping on led / backlight
>> classes stuff with this.
>
> Keeping the target sets and the mapper terminology could still be an
> option.
>
> ALS input mode is a special mode of the LEDs and backlights which
> overrides the direct current control. It's indeed a special-purpose
> device.
Yup, I understand you now!
>
>>>> A quick datasheet browse says that these are current targets? If so I
>>>> wonder if we can make that explicit...  Could treat them as 3 output
>>>> channels and have indexed values like we do for frequencies in dds
>>>> devices (where external hardware is controlling them.
>>>
>>> I think I like this.
>>>
>>>> Hmm. lets see.
>>>>
>>>> out_currentX_currentY_raw
>>>> (the double naming is a bit clunky but corresponds to frequency devices
>>>> where we have
>>>> out_altvoltageX_frequencyY_raw
>>>>
>>>> Hence we'd treat you 3 mapers as indexed channels 0,1,2 and the zones
>>>> as indexed values they can take 0,1,2,3,4
>>>> out_currentX_raw is not read only and gives you the current for whichever
>>>> zone the device is currently in.
>>>
>>> I take it you mean "out_currentX_raw is read only".
>> yes. I do indeed. oops.
>>>
>>>> This may seem convoluted but I'd really rather have something generalizable
>>>> for this if we possibly can.  We'd still need documentation to say what is
>>>> controlling these, but at least they'd fit within our more general abi.
>>>>
>>>> What do you think?
>>>
>>> I like it. From a user perspective it's mainly a change of names (and
>>> indexes). But conceptually it's perhaps more clear: the als maps it's
>>> input to an output current, which, just like a PWM-signal, could be used
>>> as an input to the LEDs and backlights to determine their outputs.
>>>
>>> I'd have to modify the LED and backlight interfaces somewhat to reflect
>>> the changed indexes and terminology (e.g. "output channel" rather
>>> than "ALS mapper"). Something like:
>>>
>>> 	als_en		-- enable als input mode (0,1)
>>> 	als_channel	-- which out_currentX to use as input (0..2) in
>>> 			   als input mode
>> Not entirely sure I'm happy with this. Would rather it was done
>> on a per channel basis, so in_illuminance0_ *
>>  From point of view of sensors I don't really care if it is an als or
>> measuring something active (hence inherently not ambient!)
>
> Not sure I understood that. What is it you don't like about it?
  You need
> to keep in mind what is actually there; three sets of target values per
> zone of which one set is dedicated to the first backlight device. That
> means, that the ALS mapper (or channel if we want to use that
> terminology) needs to be set in the actual devices and not the other way
> round. [ The als_en and als_channel attributes would belong to the
> led/backlight devices. ]
Ah. THat last bit in brackets is what I'd missed ;)  That's fine with me 
then.
>
> What did you mean by "per channel basis, so in_illuminance0_ *"?
>
> Again it's a special purpose device -- the lm3533 leds and backlights
> are controlled in hw by the on-chip als interface. We can't just use any
> generic iio device for this.
sure. Had missunderstood completely.
>
>> Silly question but how is the out_current related to the input in als
>> mode?
>
> 1. raw adc input is averaged
> 2. mean adc input is mapped to zone using zone registers ("thresholds")
> 3. zone is mapped to a percentage using ALS mapper registers, that is,
>     three sets of 8-bit values per zone. Which set is used can be set on
>     a per-device (led, backlight) basis
> 4. the percentage is applied to the per-device full-scale current to
>     determine the actual output. How this mapping is done depends on if
>     linear or exponential mapping mode is set (also per-device).
>
All makes sense now.  Thanks for the clarification.

> [ And things can get even more complicated if the devices are in
>    PWM-mode, but this is roughly the full picture. ]
>
> And all of the above is done in hw.
>
> So, we're only using out_current channels because it maybe fits iio
> better. For anyone familiar with the lm3533 this may even just confuse
> things.
I'm realy keen to do this primarily because we may well hit similar 
devices at a later stage and it's much nicer to generalize earlier
than go through supporting the old method in parallel for years...
What we have here is general enough to support a wide range of possible
devices so lets go with it.
>
> There are only the three tables of values that maps a zone to an output
> percentage (e.g. half brightness in zone 2).

One last question.  Are the als -> LEd /backlight mapping something a 
device user would ever change?  If not the most general option would be
to use the iio inkernel mapping interfaces to do the assignments. Gives
you a clean easy way to allow reading back of current brightness in the
led drivers etc...
>
>>> So to summarise, we get the following new sysfs-entries for the ALS
>>> (where the first set replace targetX_Y):
>>>
>>> 	out_currentX_currentY_raw	r/w, (0..255), X in 0..2, Y in 0..4
>>> 	out_currentX_raw		ro (0..255), X in 0..2
>>>
>>> Is there any support in core for the first set or should I simply
>>> rename my target attributes?
>> No support in the core yet for this sort of thing..
>> Michael, any thoughts on this? In a sense it's very similar to
>> out_altvoltageX_frequencyY_raw etc...
>>>
>>> Thanks,
>>> Johan
>>

