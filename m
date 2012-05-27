Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307Ab2E0IcZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 04:32:25 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:40982 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab2E0IcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 04:32:18 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4FC1F4A2.7000401@cam.ac.uk>
Date: Sun, 27 May 2012 10:32:18 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Darren Hart <dvhart@linux.intel.com>
CC: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "lkml, " <linux-kernel@vger.kernel.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Carmine Iascone <carmine.iascone@st.com>,
        Matteo Dameno <matteo.dameno@st.com>
Subject: Re: LIS331DLH accelerometer driver, IIO or not?
References: <4FBF0AC1.6030406@linux.intel.com> <20120525051051.GA3135@kroah.com> <4FC0C422.8080605@tremplin-utc.net> <4FC1159F.7090606@cam.ac.uk> <4FC19C0B.8080809@linux.intel.com>
In-Reply-To: <4FC19C0B.8080809@linux.intel.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2012 04:14 AM, Darren Hart wrote:
> 
> 
> On 05/26/2012 10:40 AM, Jonathan Cameron wrote:
>> On 05/26/2012 12:53 PM, Éric Piel wrote:
>>> On 25-05-12 07:10, Greg Kroah-Hartman wrote:
>>>> On Thu, May 24, 2012 at 09:29:53PM -0700, Darren Hart wrote:
>>>>> I'm working to enable the LIS331DLH accelerometer on the Fish River
>>>>> Island II embedded atom development kit.
>>>>>
>>>>> I am more interested in enabling people to do bizarre and interesting
>>>>> things with the device, so I'm leaning toward continuing with my IIO
>>>>> implementation.
>>>>
>>>> Make it an IIO driver and then we can delete the misc driver, which
>>>> shouldn't have snuck in there in the first place :)
>>>>
>>>
>>> To be more fair to the misc driver, I wouldn't say it snucked in there,
>>> but more "it ended up there as the least worse place" ;-) Actually, the
>>> main problem is that there seemed to be no maintainer interested in
>>> taking care of accelerometer devices. Now that the IIO subsystem is out
>>> of staging, it might be a right place. That said, I don't know much
>>> about the user interface to IIO. I know that I liked the idea of having
>>> an joystick device created for an accelerometer because that allows to
>>> get many programs to access the device almost without any modifications.
>> I agree that this sort of device should have an input interface. Not
>> sure if a joystick is the right option, but that's more one for Dmitry
>> to comment on.
>>>
>>> I'd happy to help merge the lis3lv02d driver into IIO. IMHO, the main
>>> steps are:
>>>  * make sure all the various buses are supported (e.g., I²C, SPI, and
>>> also "ACPI-HP")
>>>  * ensure the various versions of the accelerometer are supported (there
>>> are 3 supported currently)
>>>  * check that the driver is automatically loaded on HP laptops (via ACPI
>>> entry)
>>>  * for each of the current interfaces decide if they should be ported or
>>> dropped (/dev/js*, /dev/freefall, sysfs...)
>>>
>>> What do you think Jonathan?
>> You've laid it out extremely clearly.  Thanks, I agree with these steps,
>> though they may occur from a slightly different angle given Darren is
>> interested in a part that is not (I believe) currently supported by
>> your existing driver.   Hence he may initially want to do a separate
>> driver with that (keeping in mind the aim of mergining in the existing
>> driver).  I have an ancient driver for the lis3l02dq alone (in
>> iio from the start) that will also get eaten up by Daren's new driver
>> (and the ability to test on that part on spi).
>> staging/iio/accel/lis3l02dq*.c
> 
> I think I should start with getting the lis331dlh support completed, if
> for no other reason than to keep the scope manageable as I write my
> first real driver. From that I would like to merge in Jonathan's IIO
> lis3l02dq driver to get the multi-chip support part right. Then we
> should look at expanding the scope of the interface and finally merging
> with misc/lis3102dq. I believe that should meet with everyone's suggestions.
> 
> One thing I would like to understand better is what sort of interface
> does userspace current expect. Phone Gap, for example, provides a very
> high level interface to applications in m/s^2 for each axis. Is there
> some interface we should ensure all accelerometer driver's implement?
> 
> I suspect a /dev/accel interface that reads out xyz values in ms/s^2
> would make sense. We would need to ensure that allows for polled as well
> as event driven. Thoughts?

Immediate comment is don't call it /dev/accel.  That's just taken out
using it for all the combined gyro/ accel units out there.
Also doing scaling in kernel is expensive, fiddly and inefficient
(no floating point - and lots of users don't actually care about
absolute scale).  Then we get the question of what this gains us over
existing options (input or /dev/iio/iio:device0) beyond a memorable
location?  Maybe we leave this question for now...
> 
> 

