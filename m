Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118Ab1DHRtg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 13:49:36 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:56196 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756846Ab1DHRte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 13:49:34 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D9F4B0F.5070708@cam.ac.uk>
Date: Fri, 08 Apr 2011 18:51:11 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
CC: Ilkka Koskinen <ikoskine@nokia.com>,
        Ilkka Koskinen <ilkka.koskinen@nokia.com>, eric.piel@tremplin-utc.net,
        mjg@redhat.com, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, samu.p.onkalo@nokia.com,
        linux-input@vger.kernel.org,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Hemanth V <hemanthv@ti.com>
Subject: Re: [RFC PATCHv2 4/5] hwmon: lis3: Remove the referencies to the
 global variable in core driver
References: <1302014714-7334-1-git-send-email-ilkka.koskinen@nokia.com> <1302014714-7334-5-git-send-email-ilkka.koskinen@nokia.com> <20110405155007.GB2454@nautilus.holoscopio.com> <alpine.DEB.2.00.1104071448290.9511@tumpelo.nmp.nokia.com> <20110407215817.GB5065@nautilus.holoscopio.com>
In-Reply-To: <20110407215817.GB5065@nautilus.holoscopio.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/11 22:58, Thadeu Lima de Souza Cascardo wrote:
> On Thu, Apr 07, 2011 at 02:59:48PM +0300, Ilkka Koskinen wrote:
>>
>> Hi,
>>
>> Thanks for the comments!
>>
>> On Tue, 5 Apr 2011, ext Thadeu Lima de Souza Cascardo wrote:
>>> On Tue, Apr 05, 2011 at 05:45:13PM +0300, Ilkka Koskinen wrote:
>>>> Signed-off-by: Ilkka Koskinen <ilkka.koskinen@nokia.com>
>>>> ---
>>>> drivers/misc/lis3lv02d/lis3lv02d.c |  237 ++++++++++++++++++++----------------
>>>> drivers/misc/lis3lv02d/lis3lv02d.h |    3 +
>>>> 2 files changed, 135 insertions(+), 105 deletions(-)
>>
>>>> @@ -980,14 +1003,18 @@ int lis3lv02d_init_device(struct lis3lv02d *lis3)
>>>> 				thread_fn,
>>>> 				IRQF_TRIGGER_RISING | IRQF_ONESHOT |
>>>> 				irq_flags,
>>>> -				DRIVER_NAME, &lis3_dev);
>>>> +				DRIVER_NAME, lis3);
>>>>
>>>> 	if (err < 0) {
>>>> 		pr_err("Cannot get IRQ\n");
>>>> 		goto out;
>>>> 	}
>>>>
>>>> -	if (misc_register(&lis3lv02d_misc_device))
>>>> +	lis3->miscdev.minor	= MISC_DYNAMIC_MINOR;
>>>> +	lis3->miscdev.name	= "freefall";
>>>> +	lis3->miscdev.fops	= &lis3lv02d_misc_fops;
>>>> +
>>>> +	if (misc_register(&lis3->miscdev))
>>>> 		pr_err("misc_register failed\n");
>>>
>>> You should not use miscdevice in case there will be multiple devices.
>>> First, it will fail. There cannot be more than one device with the same
>>> name. Second, current dynamic minor devices is restricted to 64 devices.
>>> Since this is reserved to one-shot devices, freefall was OK as a misc
>>> device until you fixed it to allow multiple freefall devices.  :-)
>>
>> Ah, true :)
>>
>>> So, I'd recommend switching to a new device class, and have freefall0,
>>> freefall1, etc.
>>
>> I wonder if introducing a new class makes sense. I mean, I can
>> figure out use cases for several accelerometers but for several free
>> fall sensors? :/
>>
>> Would it be better to add a mechanism to tell to the core module if
>> the particular device is used for free fall detection or not?
>>
>> Cheers, Ilkka
>>
> 
> I would suggest an input handler or just letting userspace handle that
> using input events. Then, I checked out the code and realized that this
> is done by the hardware, using an interrupt. Should we handle said
> interrupt as a particular kind of event (perhaps a new misc event)?
> 
> I've written classmate-laptop driver, which has an accelerometer too
> (using ACPI). Should we start documenting how accelerometer drivers
> should be written? Input event devices are the best class, but I've seen
> cases where drivers use sysfs files. In fact, I've just checked and seen
> that lis3lv02d does that too, in the file position. But I've seen
> drivers out there that use one file per axis. I guess that's the way
> hwmon drivers usually do things, creating sysfs files.
sysfs is the quick and easy to handle option.  The single file per axis
is because you need a surprisingly complex description to explain the
contents of a 'scan' across all axis.  There are plenty of devices out
there that don't conform to the simple x y z coordinates.  If you do
it with one file per reading this is clearly handled in the naming.

Obviously if you want high frequency data with the samples grouped
across various axes, the single attribute per axis isn't all that
helpful.  However if you want this you are likely to want to use input
(if appropriate) or perhaps IIO see below but basically we are interested
in a wide range of sensors including some that are quicker than ever
makes sense for input devices and hence have a much simpler path to
userspace.  (different aims = different solution!) 
> 
> Should we start standardizing these drivers? I think input devices are
> good enough to report the data, including for 2-axis devices (I have one
> SPI "inclinometer" here - how those should be distinguished?). sysfs
> files would be nice for setting parameters. classmate-laptop, for
> example, has a sensitivity parameter. Besides freefall, lis3 seems to
> have a selftest function and a rate setting.
Quite a few discussions have taken place on standardizing this in the past.
I've cc'd Hemanth and IIO to cover the main contributors (IIRC).

The general view is that if it really is used primarily for 'input' e.g.
a human deliberately doing stuff with it to manipulate software, then it
should be via input.  Other forms of accelerometer and uses such as freefall
are more dubious.  Freefall definitely isn't deliberate user input (most
of the time ;).  There are plenty of accelerometers that do nothing else
such as those in hard disks.  Even if we have multiple sensors why on
earth would a userspace app want to treat them independently? Hence
a single chrdev seems more than adequate to me

We have a lot of the more interesting devices in iio (staging/iio/accel).
Fun things such as vibration sensors (extremely high frequency short period
sampling) an impact sensors alongside some conventional accelerometers.
Free fall is an area we don't have well covered though.  Actually
it's handled as a generic all axis low value threshold (which is what they
typically actually are up to some filtering - handling description of
filtering is still on the todo list!).  Note we are covering a much
wider range of sensors that just accelerometers so needed something
that generalized. On that front we have a lot of relatively tightly
defined interfaces that cover most things I've seen on these sensors.

As we are still in staging, we are mostly happy to discuss any new
proposals, but note that if we change anything for accelerometers we will
also have to change it for every other sensor type so that is the angle
I for one will be approaching new discussions from.
Consistency is a pain sometimes!

Anyhow, some references to previous related discussions:
https://lkml.org/lkml/2010/9/21/167 (iio sysfs event control attribute naming -
docs in tree are more up to date drivers/staging/iio/Documentation/sysfs-bus-iio)

https://lkml.org/lkml/2010/5/21/30 (Hemanth's CMA3000 accelerometer driver).


> 
> One last email in linux-input and pdx lists has requested a new MISC
> event to report a change in direction for some devices. Although I think
> freefall and change in direction could be computed using the
> accelerometer values in userspace, these devices do it directly. How
> should we handle them in a standard way?
Change of direction is much more likely to be deliberate human interaction
than freefall. I'm not convinced the same solutions will apply.
> 
> I would like to gather some opinions before writing a draft of
> recommendations for writing such drivers. Is linux-input the best forum
> for this?
Probably, though please cc linux-iio as it's clearly relevant there as well
and a heads up to lkml that the discussion is starting might also bring
in a few others.

Good to see someone else is trying to start a discussion around this.
I hope you get more input than some of the previous ones have had!

Jonathan
