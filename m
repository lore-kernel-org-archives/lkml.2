Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab0H1NkL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 09:40:11 -0400
Received: from ppsw-33.csi.cam.ac.uk ([131.111.8.133]:49595 "EHLO
	ppsw-33.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab0H1NkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 09:40:09 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4C7912A7.5020008@jic23.retrosnub.co.uk>
Date: Sat, 28 Aug 2010 14:44:07 +0100
From: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100808 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Onkalo Samu <samu.p.onkalo@nokia.com>,
        ext Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [PATCH 1/3] drivers: misc: ak8974 / ami305 magnetometer driver
References: <1282910083-8629-1-git-send-email-samu.p.onkalo@nokia.com> <1282910083-8629-2-git-send-email-samu.p.onkalo@nokia.com> <20100827133109.1eb974ed@lxorguk.ukuu.org.uk> <1282928353.2194.27.camel@noppispoppis.nmp.nokia.com> <20100827180837.GB13154@core.coreip.homeip.net>
In-Reply-To: <20100827180837.GB13154@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/10 19:08, Dmitry Torokhov wrote:
> On Fri, Aug 27, 2010 at 07:59:13PM +0300, Onkalo Samu wrote:
>>>
>>>> +static ssize_t ak8974_misc_read(struct file *file, char __user *buf,
>>>> +			size_t count, loff_t *offset)
>>>> +{
>>>> +	struct ak8974_chip *chip = container_of(file->private_data,
>>>> +						struct ak8974_chip,
>>>> +						miscdev);
>>>> +	struct ak8974_data data;
>>>
>>> So we have a different API to the ak8975 just posted and to the other
>>> existing devices. This needs sorting out across the devices before there
>>> is a complete disaster. Right now we have a mix of submissions pending
>>> which variously use
>>>
>>> 	misc + sysfs
>>> 	sysfs
>>> 	input (reporting X Y Z etc axes)
>>>
>>
>> About year ago I send driver for the same chip with input-device
>> interface. During that time I asked from Dmitry Torokhov that is that a
>> correct interface for this kind of driver. I understood that input
>> should not be used for this kind of sensors.
>>
>> sysfs is quite handy interface for small sensors. However, one problem
>> is that the driver doesn't know when the interface is in use.
>> I ended up to misc device to get information about the usercount for PM
>> purposes.
>>
>> Dmitry, what is your opinion about using input device interface for this
>> kind of sensors?
>>
> 
> This is really hard question and I am going back and forth myself.
> 
> When considering using input subsystem try answering the following
> question - is the device's main purpose is indeed to be a human
> interface device or do you want to use input subystem because evdev
> interface is convenient? If the answer is former- then it should be in
> input (or available through input - let's say IIO-to-input bridge
> module). If the answer is latter then input is not the right place for
> the device.
The iio to input bridge is still on the todo list.  Unfortunately none
of the core developers are particularly interested in that so it isn't
a high priority.  Of course we would welcome someone working on it!
If not it we will get to it.
> 
> Lately I was persuaded that 3-axis accelerometers are mainly used as
> input devices so I took adxl driver in and I need to get back and review
> cma3000 patch...
> 
>>> Someone needs to decide on a single API before it's too late.
>>>
>>
>> That is definitely true. Could it be IIO?
>>
I'm in favour ;)

We already have one straight magnetometer and one imu which includes
a magnetometer.  I'd love to see more and would certainly welcome this
driver.
> 
> I was hpoing that IIO would take care of "unnamed" sensors. Here I mean
> sensors that measure something and only user/application know exactly
> what it is; the same device might measure different things depending on
> setup. Take a temperature sensor - ambient temperature, temperature of
> some technological process, patient temperature - it is hard for the
> kernel to know which one it would be.
> 
> This is in contrast with input system that tries to classify
> events so that the event has the same meaning regarless of which device
> emitted it - KEY_A means the same regardless of keybord; we may route
> them differently (multiseat for example), but the meaning is the same.
> 
That's certainly our intent.  

The down side of going with IIO is that it is taking a while to cleanup
the userspace abi (and the core code for that matter!).
Manuel Stahl has been recently pinning down a few issues made apparent via
the generic userspace code he has been working on, so there will be patches
relating to that over the next week.  Ultimately the lack of interface stability
is on reason IIO is still in staging.  All help on this and more general code
review of IIO is welcomed!

For the sysfs devices I'd request that people either match our naming convention
or that of hwmon (which the IIO one extends).  By this I mean the individual
attributes, not the directory naming etc.  That way whatever the resulting
subsystems of the future, we will at least have one naming convention!

The chrdev end of things are more complex. (I'm happy to go into why we have two
types etc but that's a much larger discussion)  As a quick note though, the
structure you have used is obviously very much device (or at least narrow class of)
device specific.  Our approach to this is a description of the format via a set of
sysfs params. Much as you have done we need to maintain the linkage between a 'scan'
of the channels and this approach allows us to do this.

Jonathan
