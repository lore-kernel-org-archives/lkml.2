Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab1GAIw2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 04:52:28 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:45693 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646Ab1GAIw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 04:52:26 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E0D8CA8.5040208@cam.ac.uk>
Date: Fri, 01 Jul 2011 10:00:24 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Nathan Royer <nroyer@invensense.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Alan Cox <alan@linux.intel.com>,
        Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 01/11] misc: inv_mpu primary header file and README file.
References: <1309486707-1658-1-git-send-email-nroyer@invensense.com> <20110701030904.GA3748@suse.de>
In-Reply-To: <20110701030904.GA3748@suse.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/11 04:09, Greg KH wrote:
> On Thu, Jun 30, 2011 at 07:18:17PM -0700, Nathan Royer wrote:
>> This files defines the userspace interface and how to integrate it into a
>> platform.
>>
>> Signed-off-by: Nathan Royer <nroyer@invensense.com>
>> ---
>>
>> This is the first of many patch files for the inv_mpu driver in its current
>> state.  This is our first time submitting this driver, so I expect there to be
>> a lot wrong with it, and expect to need to fix many things.
>>
>> The inv_mpu driver attepts to implement a Motion Processing Unit interface.  As
>> a unit, an accelerometer, magnetometer, gyroscope, and/or altimiter data is
>> fused together to produce calibrated data and a quaternion.
>>
>> The inv_mpu driver interface is currently implemented as a misc device, but may
>> need to change to include both sysfs attributes and input devices.  I think
>> that we will continue to need the ioctl interface, but many of the ioctls can
>> be replace by attributes and/or input devices.
>>
>> The mpu3050 has an i2c master interface designed to control an accelerometer
>> and a Digital Motion Processor (DMP) used to perform sensor fusion on the
>> gyroscope and accelerometer.  This data is then read out of the mpu3050 fifo
>> and sent to userspace for distribution and optional propritary processing, such
>> as fusion with a compass to produce a 9 axis quaternion.
>>
>> Some question I have at the start are:
>> 1) Is there a master design or standard interface for Motion Processing
>> devices, specifically ones that do calibration, sensor fusion, and or have a
>> micro-controller to do some of this work.
Some of Analog's parts are doing a very basic form of this (bit of integration etc).
Ultimately in their case it is transparent, so they just look like additional data
channels.  Here it looks more sophisticated.

>> 2) Is there a standard way to integrate user space components with kernel side
>> components.
>> 3) Should data be pushed back to the driver from userspace, and made available
>> as an input device or should it remain as a character device.
Depends on the use case.  If you have to do userspace processing, then uinput
does this nicely.
>> 4) Can a 4 element quaternion be added to input.h:
>> ABS_QUATERNION_1 ABS_QUATERNION_I ABS_QUATERNION_J ABS_QUATERNION_K
>> for <1, i, j, k>
>> 5) Should we instead use a rotation vector as defined in the Android sensor:
>> http://developer.android.com/reference/android/hardware/SensorEvent.html
If you hardware is producing quaternions directly you are not going to want to
the necessary sin / cos in kernel. Trivial in userspace though.
>> 6) Are there any other major design concerns?
The big one Alan and Jean have commented on.  This device just has slave i2c devices
they should have their own drivers if at all possible.
> 
> Shouldn't you be using the iio subsystem for the kernel/user interface
> as I think it handles most of this for you already, right?
Few bits we haven't seen before, but nothing that can't be easily added.
We do have a usual question here of whether this is better as an input device
though. Dmitry, what is your view on this one?  Certainly doesn't want to end
up in misc.  Alan (in other branch) has highlighted an existing driver for the
mpu part.
> 
>> 7) Can an input device also have a character device interface for proprietary
>> customization.
> 
> What do you mean by this?
> 
> greg k-h
> 

