Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab0IRMUj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 08:20:39 -0400
Received: from ppsw-33.csi.cam.ac.uk ([131.111.8.133]:39028 "EHLO
	ppsw-33.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab0IRMUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 08:20:37 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4C94AFCC.1050101@jic23.retrosnub.co.uk>
Date: Sat, 18 Sep 2010 13:25:48 +0100
From: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100909 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: Manuel Stahl <manuel.stahl@iis.fraunhofer.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Jean Delvare <khali@linux-fr.org>, Greg KH <greg@kroah.com>,
        Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [IIO] Proposal for sysfs attributes
References: <4C84A93B.2050507@iis.fraunhofer.de> <4C84E64D.4040600@jic23.retrosnub.co.uk>
In-Reply-To: <4C84E64D.4040600@jic23.retrosnub.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manuel,

Unfortunately this thread wandered off in a different direction, so let us
draw it back to the actual questions it brings up.
>> there were some sysfs userspace questions on linux-iio where we would like to get some more comments on.
>>
>> First thing, there are some attributes describing the layout of a
>> ring buffer that can be read out via a char device. The buffer
>> contains several entries with each containing so called scan
>> elements. All entries have the same layout. It is described in a
>> directory scan_elements (see below) that contains three attributes
>> per scan element.
>>
>>> OK, no packed buffers for now, but we should implement variable
>>> sample sizes for standard types. Indeed we already have this for
>>> the timestamp, which is always 64 bit.
>>>
>>> To be compatible with future extensions we could have:
>>>    |- /sys/bus/iio/device0/buffer0/scan_elements/
>>>       |- accel_x_en    (0 or 1)
>>>       |- accel_x_type  (i.e. s14/16, see *)
>>>       |- accel_x_index (position inside the buffer entry)
>>>
>>> * s14/16 means signed 14 bits, stored in 16 bits, right aligned.
>>>   If it's left aligned we can just modify the scale attribute and
>>>   give the 16 bit interpretation in <channel>_raw.
>>
>> Is the 's14/16' self explaining or should we use some other format?
>> Is 'type' a good postfix for the attribute?
> 
> One additional point here.  What we currently have that the enable
> parameters are currently [m]_accel_x_en etc with m being an indicator
> of the position of a parameter within the buffer.  Note not all channels
> are enabled at a time.  For all devices we have so far, the ordering
> is fixed, so this naming is constant.  Basically we roll the accel_x_index
> attribute into the naming of the enable attribute.  Manuel, could you summarize
> what you have against that approach? (I'm not particularly tied to it, but
> it is in place and it does work).
Any response to this question Manuel?  Basically this question asks whether
we want to explicitly tell userspace what the ordering is, or instead provide
it with sufficient info to trivially figure it out itself.  I'm inclined to leave
this job to user space.

Anyway, I'd like to see the addition of you type field asap (as I need it for some
stuff I'm doing today ;)  So do you want to propose the relevant abi docs patch
or shall I?  I'll start adding the parameter to my test driver set asap.
>>
>>
>> Next question: how strictly we want to resamble the hwmon ABI?
>>
>> To sum up the discussion:
>> Hwmon has files with the postfix _input to read values scaled to
>> reasonable units for fixed point representation. So the units are
>> sometimes scaled down to 'millis' e.g. millivolt, millidegree Celsius.
>> We agreed that we want to keep this, whenever we use the _input postfix.
>> For IIO there is also the postfix triple _raw, _scale and _offset,
>> where the final value is calculated by (_raw + _offset) * _scale.
>> Floating point values are allowed for any of these files.
> (other than _raw obviously!)
>>
>> The question in place was:
>> Do we want to resemble the 'milli' units or should we stick to
>> standard SI units (radians, kelvin, etc.) as floating point math is
>> necessary anyway.
> I've cc'd a few people who have contributed to previous abi discussions
> for IIO in ways that make me think they may have opinions on this.
> 
To express my personal view, I think we have to keep to the units of hwmon.
If we do so for the 'input' attributes and not the combined raw + scale version
things will just be rather confusing.  Ultimately I don't really care, as long
as we pick one option or the other!

A nice as kelvin sounds I don't think that is worth doing.  Lets just stick to
the Celcius choice of hwmon.  If you really want kelvin in a given device, feel
free to use the _offset parameter to just say it is offset appropriately from
Celsius!

Jonathan

