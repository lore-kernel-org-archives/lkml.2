Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335Ab1GHQYt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 12:24:49 -0400
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:41019 "HELO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750783Ab1GHQYq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 12:24:46 -0400
MIME-Version: 1.0
In-Reply-To: <4E16E853.1060202@cam.ac.uk>
References: <1309486707-1658-1-git-send-email-nroyer@invensense.com>
	<4E0D8E94.5030604@cam.ac.uk>
	<4d61a92a11e5d83a1cb0094441ae5f5e@mail.gmail.com>
	<4E105284.7030209@cam.ac.uk>
	<20110704091658.0d4c8e3f@bob.linux.org.uk>
	<c2189246a279a0e5a1b8599edc94a79a@mail.gmail.com>
	<20110706115430.3745592c@bob.linux.org.uk>
	<592dafb95382604bd514687f7600cebd@mail.gmail.com>
	<20110707084026.4562ab94@lxorguk.ukuu.org.uk>
	<e02bd0691ed3d1e1390459018e79c8bc@mail.gmail.com>
	<4E16E853.1060202@cam.ac.uk>
Date: Fri, 8 Jul 2011 09:24:44 -0700
Message-ID: <CAGiMKzRruQXf3Kakf1zL051D-j3XQ5+4FMfKLpF3VoLxTHb3Mg@mail.gmail.com>
Subject: Re: [PATCH 01/11] misc: inv_mpu primary header file and README file.
From: Nathan Royer <nroyer@invensense.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Jiri Kosina <jkosina@suse.cz>,
        Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, Chris Hudson <chudson@kionix.com>,
        eric.andersson@unixphere.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Our MPL needs the platform data, mostly the orientation of each device.
>> The relevant information can be made available as iio sysfs attributes for
>> each device. ========================================
>> #define MPU_GET_EXT_SLAVE_PLATFORM_DATA       \
>>       _IOWR(MPU_IOCTL, 0x02, struct ext_slave_platform_data)
>> #define MPU_GET_MPU_PLATFORM_DATA     \
>>       _IOWR(MPU_IOCTL, 0x02, struct mpu_platform_data)
>> #define MPU_GET_EXT_SLAVE_DESCR       \
>>       _IOWR(MPU_IOCTL, 0x02, struct ext_slave_descr)
> Perfectly acceptable to have sysfs attributes with input devices to, so that
> doesn't matter so much.  Now there are issues with what they are.
> Why is platform data passed via sysfs? It's platform data, so it belongs
> in a board file or device tree.

Yes I agree, but user space needs to read that information, my plan
was to make the information in the platform data available as read
only attributes.  Is there a better way?

>>
>> These are simple register reads and register writes.  These can be
>> replaced with iio sysfs attributes for the gyro driver.
>> =======================================
>> #define MPU_READ              _IOWR(MPU_IOCTL, 0x10, struct
>> mpu_read_write)
>> #define MPU_WRITE             _IOW(MPU_IOCTL,  0x10, struct
>> mpu_read_write)
> Hmm. These really don't belong in sysfs. They are opaque and completely
> ungeneralizable.  If you have this of need to write general purpose stuff
> then perhaps consider some of the work going on for communications between
> asymmetric multiprocessor systems.

I think this particular interface is redundant with MPU_CFG_GYRO.
I'll need to look through our user space code, but I think 1 attribute
per register will remove the need for these general purpose i2c read
and write.

>> This was used to start or stop the system.  This can be replaced with iio
>> sysfs power mode attribute for each slave, and an additional one for the
>> MPU controller.
> Ideally this wants to be handled via runtime pm so that the dependencies
> are nicely handled.

Ok, I'll look into runtime pm.

>> =========================================
>> #define MPU_SUSPEND           _IOW(MPU_IOCTL, 0x30, __u32)
>> #define MPU_RESUME            _IOW(MPU_IOCTL, 0x31, __u32)
>>
>> Selecting on /dev/mpu will return a MPU_PM_EVENT_SUSPEND_PREPARE or
>> MPU_PM_EVENT_POST_SUSPEND allowing user space to decide if it wants to
>> leave anything powered on when suspended.  This in conjunction with the
>> IGNORE_SYSTEM_SUSPEND allows the DMP plus gyro and/or accel to continue
>> running while the main processor is suspended.  This can be used to wake
>> up the main processor on a particular motion event, or to record motion
>> events to be reported when the processor later wakes up.  This ioctl
>> signals that user space has finished configuring all sensors and the MPU
>> controller and that the MPU controller can continue.
>> =======================================
>> #define MPU_PM_EVENT_HANDLED  _IO(MPU_IOCTL, 0x32)
>>
>> Requested sensors is a common place to know which sensors are on, and to
>> specify which sensors to turn on the next time the system is started.
>> This can be removed since it is redundant with power mode attributes I'm
>> proposing be used by each slave and the MPU controller.
>> =======================================
>> #define MPU_GET_REQUESTED_SENSORS     _IOR(MPU_IOCTL, 0x40, __u8)
>> #define MPU_SET_REQUESTED_SENSORS     _IOW(MPU_IOCTL, 0x40, __u8)
>>
>> See my note on MPU_PM_EVENT_HANDLED above.  This can be made a SysFs
>> attribute of drivers/misc/inv_mpu
>> =======================================
>> #define MPU_GET_IGNORE_SYSTEM_SUSPEND _IOR(MPU_IOCTL, 0x41, __u8)
>> #define MPU_SET_IGNORE_SYSTEM_SUSPEND _IOW(MPU_IOCTL, 0x41, __u8)
> Is this supported in runtime pm?  If not, perhaps it is a usecase that should
> be.  Here we could disable the bus, but not for example relevant regulators.

User space needs a way to control if the chip is left powered or not.
In our use case we will load different firmware that keeps event
records in DMP memory, or generate an IRQ on event.  If nobody is user
land wants this feature enabled, then we completely sleep the chip.
I'll look to see if this is supported by runtime pm, not too familiar
with runtime pm... yet.

>> These are bitfield of how the MPU controller state.  Which devices are
>> currently suspended, which devices are running, if the i2c master is
>> bypassed, if the DMP is running.  This can be made a SysFs attribute, and
>> perhaps removed.
>> =======================================
>> #define MPU_GET_MLDL_STATUS           _IOR(MPU_IOCTL, 0x42, __u8)
> If sysfs, it should be one attribute per device, not a bitfield.

Ok, agreed.

>>
>> This is a bitfield showing the status of which of the master i2c channels
>> have been enabled.  The mpu3050 has 1 channel, and the mpu6050 has 5
>> channels.  This can become a sysfs attribute
>> =======================================
>> #define MPU_GET_I2C_SLAVES_ENABLED    _IOR(MPU_IOCTL, 0x43, __u8)
> I think this should be handled via some platform data / run time pm.
>
> If there is something there and it's being talked to it should be enabled.
> Otherwise not.

Correct,  this was actually never necessary.  I will just remove it.

>>
>> After all is said and done this is files that would be made available:
>> /dev/mpu
>>       Iotcl interface for memory and fifo reads writes, read for events
>> include pm events and irq events.
> Make sure it is numbered. Perfectly reasonable to have more than one of these!

If so I could get rid of the ioctl interface and replace it with
/dev/mpumem read() and write() and a /dev/mpufifo read() and write()
and /dev/mpupm read() for pm events if there isn't a better API for
runtime pm.  Which do you think would be better, several /dev devices
with read/write or a single /dev file with ioctl's?

>>
>> I'm not exactly sure of the details of what you are suggesting, but
>> somehow telling a slave that it is now being used in 'smart' mode is fine,
>> as long as the MPU controller can still read back the information it needs
>> to control it, for example setting up the mpu3050 i2c master.
> To my mind this should look a bit like the i2c bus multiplexers.  The only
> difference is that under some conditions, devices won't respond (the master
> has taken an exclusive lock on them).

I like that idea.  That means that certain interactions would return
-EBUSY if locked by the master.
