Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966711Ab2EOUBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 16:01:00 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:43770 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966685Ab2EOUAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 16:00:55 -0400
Message-ID: <4FB2B5EE.6080009@kernel.org>
Date: Tue, 15 May 2012 21:00:46 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120314 Thunderbird/11.0
MIME-Version: 1.0
To: Johan Hovold <jhovold@gmail.com>
CC: Jonathan Cameron <jic23@cam.ac.uk>, Rob Landley <rob@landley.net>,
        Richard Purdie <rpurdie@rpsys.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH v2 2/4] iio: add LM3533 ambient light sensor driver
References: <1334935826-12527-1-git-send-email-jhovold@gmail.com> <1336040799-18433-1-git-send-email-jhovold@gmail.com> <1336040799-18433-3-git-send-email-jhovold@gmail.com> <4FA26E9A.8080209@cam.ac.uk> <20120503163617.GD15752@localhost> <4FA923E7.6050707@cam.ac.uk> <20120515164456.GB15632@localhost>
In-Reply-To: <20120515164456.GB15632@localhost>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2012 05:44 PM, Johan Hovold wrote:
> On Tue, May 08, 2012 at 02:47:19PM +0100, Jonathan Cameron wrote:
>> On 5/3/2012 5:36 PM, Johan Hovold wrote:
>>> On Thu, May 03, 2012 at 12:40:10PM +0100, Jonathan Cameron wrote:
>>>> On 5/3/2012 11:26 AM, Johan Hovold wrote:
>>>>> Add sub-driver for the ambient light sensor interface on National
>>>>> Semiconductor / TI LM3533 lighting power chips.
>>>>>
>>>>> The sensor interface can be used to control the LEDs and backlights of
>>>>> the chip through defining five light zones and three sets of
>>>>> corresponding brightness target levels.
>>>>>
>>>>> The driver provides raw and mean adc readings along with the current
>>>>> light zone through sysfs. A threshold event can be generated on zone
>>>>> changes.
>>>> Code is fine.  Pretty much all my comments are to do with the interface.
>>> [...]
>>>
>>>>> diff --git a/drivers/staging/iio/Documentation/sysfs-bus-iio-light-lm3533-als b/drivers/staging/iio/Documentation/sysfs-bus-iio-light-lm3533-als
>>>>> new file mode 100644
>>>>> index 0000000..9849d14
>>>>> --- /dev/null
>>>>> +++ b/drivers/staging/iio/Documentation/sysfs-bus-iio-light-lm3533-als
>>>>> @@ -0,0 +1,62 @@
>>>>> +What:		/sys/bus/iio/devices/iio:deviceX/gain
>>>>> +Date:		April 2012
>>>>> +KernelVersion:	3.5
>>>>> +Contact:	Johan Hovold<jhovold@gmail.com>
>>>>> +Description:
>>>>> +		Set the ALS gain-resistor setting (0..127) for analog input
>>>>> +		mode, where
>>>>> +
>>>>> +		0000000 - ALS input is high impedance
>>>>> +		0000001 - 200kOhm (10uA at 2V full-scale)
>>>>> +		0000010 - 100kOhm (20uA at 2V full-scale)
>>>>> +		...
>>>>> +		1111110 - 1.587kOhm (1.26mA at 2V full-scale)
>>>>> +		1111111 - 1.575kOhm (1.27mA at 2V full-scale)
>>>>> +
>>>>> +		R_als = 2V / (10uA * gain)	(gain>   0)
>>>> Firstly, no magic numbers.  These are definitely magic.
>>> Not that magic as they're clearly documented (in code and public
>>> datasheets), right? What would you prefer instead?
>> The numbers on the right of the - look good to me though then this isn't
>> a gain.  (200kohm) and the infinite element is annoying.  Why not
>> compute the actual gains?
>> Gain = (Rals*10e-6)/2  and use those values?  Yes you will have to do
>> a bit of fixed point maths in the driver but the advantage is you'll
>> have real values that are standardizable across multiple devices
>> and hence allow your device to be operated by generic userspace
>> code.  Welcome to standardising interfaces - my favourite occupation ;)
>>
>>>> Secondly see in_illuminance0_scale for a suitable existing attribute.
>>> I didn't consider scale to be appropriate given the following
>>> documentation (e.g, for in_voltageY_scale):
>> sorry  I just did this to someone else in another review (so I'm 
>> consistently wrong!)
>>
>> in_voltageY_calibscale is what I should have said.  That one applies a
>> scaling before the raw reading is generated (so in hardware).
> 
> Ok, then calibscale is the appropriate attribute for the resistor
> setting. But as this is a device-specific hardware-calibration setting
> I would suggest using the following interface:
> 
> What:		/sys/bus/iio/devices/iio:deviceX/in_illuminance_calibscale
> Description:
> 		Set the ALS calibration scale (internal resistors) for
> 		analog input mode, where the scale factor is the current in uA
> 		at 2V full-scale (10..1270, 10uA step), that is,
> 
> 		R_als = 2V / in_illuminance_calibscale
> 
> 		This setting is ignored in PWM mode.
This is a generic element that really ought to just fit in with the
equivalent in sysfs-bus-iio for calibscan.  It's a ratio, so it should
be unit free for starters.
> 
> [...]
> 
>>>>> +What:		/sys/bus/iio/devices/iio:deviceX/target[m]_[n]
>>>>> +Date:		April 2012
>>>>> +KernelVersion:	3.5
>>>>> +Contact:	Johan Hovold<jhovold@gmail.com>
>>>>> +Description:
>>>>> +		Set the target brightness for ALS-mapper m in light zone n
>>>>> +		(0..255), where m in 1..3 and n in 0..4.
>>>> Don't suppose you could do a quick summary of what these zones are
>>>> and why there are 3 ALS-mappers?  I'm not getting terribly far on a
>>>> quick look at the datasheet!
>>> Of course. The average adc readings are mapped to five light zones using
>>> eight zone boundary registers (4 boundaries with hysteresis) and a set
>>> of rules.
>> This is going to be fun.  We'll need the boundaries and attached 
>> hysteresis attributes to fully specify these (nothing would indicate
>> that hysterisis is involved otherwise).
> 
> You can't define the hysteresis explicitly with the lm3533 register
> interface, rather it's is defined implicitly in case threshY_falling is
> less than threshY_rasising.
> 
> So the raising/falling attributes should be enough, right?
Nope, because they don't tell a general userspace application what is
going on.  Without hysterisis attributes it has no way of knowing there
is hysterisis present.  Feel free to make them read only though.
> 
>>> To simplify somewhat (by ignoring some of the rules): If the average
>>> adc input drops below boundary0_low, the zone register reads 0; if it
>>> drops below boundary1_low, it reads 1, and so on. If the input it
>>> increases over boundary3_high, the zone register return 4; if it
>>> increases passed boundary2_high, it returns zone 3, etc.
>>>
>>> That is, roughly something like (we get 8-bits of input from the ADC):
>>>
>>> 	zone 0
>>>
>>> boundary0_low	51
>>> boundary0_high	53
>>>
>>> 	zone 1
>>>
>>> boundary1_low	102
>>> boundary1_high	106
>>>
>>> 	zone 2
>>>
>>> boundary2_low	153
>>> boundary2_high	161
>>>
>>> 	zone 3
>>>
>>> boundary3_low	204
>>> boundary3_high	220
>>>
>>> 	zone 4
>>>
>>> [ Figure 6 on page 20 in the datasheets should make it clear. ]
>>>
>>> The ALS interface and it's zone concept can then be used to control the
>>> LEDs and backlights of the chip, by determining the target brightness for
>>> each zone, e.g., set brightness to 52 when in zone 0.
>>>
>>> To complicate things further (and it is complicated), there are three
>>> such sets of target brightness values: ALSM1, ALSM2, ALSM3.
>>>
>>> So for each LED or backlight you can set ALS-input control mode, by
>>> saying that the device should get it's brightness levels from target set
>>> 1, 2, or 3.
>>>
>>> [ And it gets even more complicated, as ALSM1 can only control
>>>    backlight0, where as ALSM2 and ALSM3 can control any of the remaining
>>>    devices, but that's irrelevant here. ]
>>>
>>> Initially, I thought this interface to be too esoteric to be worth
>>> generalising, but it sort of fits with event thresholds so I gave it a
>>> try.
>> Glad you did and it pretty much fits, be it with a few extensions being 
>> necessary.
>>> The biggest conceptual problem, I think, is that the zone
>>> boundaries can be used to control the other devices, even when the event
>>> is not enabled (or even an irq line not configured). That is, I find it
>>> a bit awkward that the event thresholds also defines the zones (a sort of
>>> discrete scaling factor).
>> That is indeed awkward. I'm not sure how we handle this either.  If we 
>> need to control these from the other devices (e.g. the back light
>> driver) then we'll have to get them into chan_spec and use the
>> inkernel interfaces to do it.  Not infeasible but I was hoping to
>> avoid that until we have had a few months to see what similar devices
>> show up (on basis nothing in this world is a one off for long ;)
> 
> I don't think the control bits can or should be generalised at this
> point. The same ALS-target values may be used to control more than one
> device, so they need to be set from the als rather from the controlled
> device (otherwise, changing the target value of led1 could change that
> of the other three leds without the user realising that this can be a
> side effect).
Good point.  Nasty little device to write an interface for :)
> 
>>> Perhaps simply keeping the attributes outside of events (e.g. named
>>> boundary[n]_{low,high}) and having a custom event enabled (e.g.
>>> in_illuminance_zone_change_en) is the best solution?
>> Maybe, but it's ugly and as you have said, they do correspond pretty well to
>> thresholds so I'd rather you went with that.
>> The core stuff for registering events clearly needs a rethink.... For 
>> now doing it as you describe above (with the addition fo hysteresis
>> attributes) should be fine.  Just document the 'quirks'.
> 
> Ok, I'll keep the event/zone interface as it stands for now and we'll
> see if it can be generalised later. [ See my comment on the hysteresis
> above: there are only the rising/falling thresholds (low/high
> boundaries) and no boundary or hysteresis settings. ]
On that, just to reiterate, to have anything generalizable, userspace
needs to know that hysterisis exists on the individual thresholds
(though it is clearly a function of the neighbouring one).
> 
> Thanks,
> Johan

