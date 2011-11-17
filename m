Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab1KQUkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 15:40:46 -0500
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:53740 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab1KQUkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 15:40:45 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4EC5714D.7000008@cam.ac.uk>
Date: Thu, 17 Nov 2011 20:40:45 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111108 Thunderbird/8.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.drivers.sensors
To: MyungJoo Ham <myungjoo.ham@gmail.com>
CC: Ben Hutchings <bhutchings@solarflare.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>, dg77.kim@samsung.com,
        kyungmin.park@samsung.com
Subject: Re: [RFC PATCH 0/2] HWMON: add in-kernel interfaces to read sensor
 values.
References: <1320389433-1671-1-git-send-email-myungjoo.ham@samsung.com> <1321044403.2757.23.camel@bwh-desktop> <CAJ0PZbQsTYZvoVMgZ_L5uPUxCTbzH72zzUqUkvXNnmqiDOGY=g@mail.gmail.com> <4EC1444E.5080108@cam.ac.uk> <CAJ0PZbR=8PPKNNREOBXL1U8To+jjp9=gkQz_NKUVKU8DhyWPJQ@mail.gmail.com>
In-Reply-To: <CAJ0PZbR=8PPKNNREOBXL1U8To+jjp9=gkQz_NKUVKU8DhyWPJQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2011 08:22 AM, MyungJoo Ham wrote:
> On Tue, Nov 15, 2011 at 1:39 AM, Jonathan Cameron <jic23@cam.ac.uk> wrote:
>> On 11/14/2011 01:31 AM, MyungJoo Ham wrote:
>>> On Sat, Nov 12, 2011 at 5:46 AM, Ben Hutchings
>>> <bhutchings@solarflare.com> wrote:
>>>> On Fri, 2011-11-04 at 15:50 +0900, MyungJoo Ham wrote:
>>>>> We have been reading hwmon values (TMU, the SoC-core temperature sensor,
>>>>> and NTC, the ambient or battery surface temperature sensor) for
>>>>> Charger-Manager. However, because hwmon does not have in-kernel interface,
>>>>> we have been using undesired method, including "../../../fs/*.h".
>>>>>
>>>>> This patch is to provide in-kernel interface for hwmon:
>>>>> hwmon_get_value and hwmon_set_value. In order to use these two functions,
>>>>> the hwmon driver should provide its sysfs attributes to hwmon framework
>>>>> as well. If the hwmon driver does not provide (by providing NULL), the users
>>>>> of the hwmon won't be able to use hwmon_get/set_value();
>>>>> The sysfs attribute (struct attribuyte_group *) is provided with
>>>>> hwmon_device_register; adding the second parameter to hwmon_device_register().
>>>>> The 2/2 patch shows the changes in device drivers due to this.
>>>> [...]
>>>>
>>>> This is an improvement, but I don't think it is quite enough.  As I
>>>> understand the hwmon sysfs interface, all sensor values should be
>>>> integers.  So the in-kernel interface should also work with integers,
>>>> not strings.
>>>>
>>>> As a first implementation you could perhaps parse the strings back to
>>>> integers.  However in the longer term the driver API should be changed
>>>> so that hwmon drivers fully describe their sensors to the core and the
>>>> core takes care of exposing them through sysfs and the in-kernel API.
>>>
>>> I agree.
>>>
>>> I'll let it the in-kernel interfaces provide integer value although it will
>>> simply parse strings as you've addressed until we have some other
>>> interfaces for sysfs entries in hwmon device drivers.
>>>
>>>
>> To throw another option into the mix, you could make it an IIO driver
>> and sit hwmon on top of that (there is already a simple driver for
>> doing this) - IIO has in kernel interfaces of the type
>> you want.  Not everything is there yet though.
>>
>> Jonathan
> 
> Yes, we may alter the HWMON drivers to be IIO drivers as well.
> 
> However, to me, at least for the HWMON devices I've been looking, IIO
> seems to be an overkill and more complex than needed for the target
> devices.
It should (at least in theory) be very simple for anything like a simple
hwmon device on which one wants to do polled reads.

All you do is allocate an iio_dev, set up the channel descriptions,
register it with the core.  Then a map is used to match supplied
channels to their consumers in kernel.

There is a simple hwmon driver that then takes one of these maps if
you want conventional hwmon interfaces.  Other interested drivers can
have their own maps.

Anyhow, IIO is complex for some devices, but pretty simple for simple
things (at least it should be!)

Jonathan
