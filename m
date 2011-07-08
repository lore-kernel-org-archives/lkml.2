Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab1GHLOJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 07:14:09 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:54207 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab1GHLOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 07:14:06 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E16E853.1060202@cam.ac.uk>
Date: Fri, 08 Jul 2011 12:21:55 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Nathan Royer <nroyer@invensense.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Jiri Kosina <jkosina@suse.cz>,
        Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, Chris Hudson <chudson@kionix.com>,
        eric.andersson@unixphere.com
Subject: Re: [PATCH 01/11] misc: inv_mpu primary header file and README file.
References: <1309486707-1658-1-git-send-email-nroyer@invensense.com>	<4E0D8E94.5030604@cam.ac.uk>	<4d61a92a11e5d83a1cb0094441ae5f5e@mail.gmail.com>	<4E105284.7030209@cam.ac.uk>	<20110704091658.0d4c8e3f@bob.linux.org.uk>	<c2189246a279a0e5a1b8599edc94a79a@mail.gmail.com>	<20110706115430.3745592c@bob.linux.org.uk>	<592dafb95382604bd514687f7600cebd@mail.gmail.com> <20110707084026.4562ab94@lxorguk.ukuu.org.uk> <e02bd0691ed3d1e1390459018e79c8bc@mail.gmail.com>
In-Reply-To: <e02bd0691ed3d1e1390459018e79c8bc@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/11 02:25, Nathan Royer wrote:
>> Its hard to judge with what has been explained so far but the device
>> appears to be very different in the two operating modes so it might
>> make
>> sense to have it as two drivers (or one driver with two very distinct
>> modes)
> 
> I'm thinking two distinct drivers.  One we should call the MPU controller
> and the other the gyro driver.
> 
> Comparing it to the i2c architecture.  In the board file, each i2c bus is
> initialized with information about each device on the bus.  An i2c_client
> is created for each device and their probe functions called allowing the
> driver to use the i2c_client to communicate with the device.
> 
> For the MPU controller, it would be similar registration, but the slaves
> would be given to the MPU controller to control.  In the board file the
> MPU controller would be initialized with which devices that it should
> control.  The MPU controller would then probe each device for the
> interface used to control it.  If that device is not probed then it should
> act alone, otherwise it should allow the MPU controller to control it.
> 
> Regarding the interface, I'm still confused on how to resolve the
> iio/input decision.  Should the devices use both?  I think the final
> interface would be a combination of possibly all 3 interfaces, misc,
> input, and iio.
> 
> Below is a discussion of the IOCTL's, how they are currently used, and how
> I'm thinking about mapping them in between the 3 interfaces.
> 
> Our MPL needs the platform data, mostly the orientation of each device.
> The relevant information can be made available as iio sysfs attributes for
> each device. ========================================
> #define MPU_GET_EXT_SLAVE_PLATFORM_DATA	\
> 	_IOWR(MPU_IOCTL, 0x02, struct ext_slave_platform_data)
> #define MPU_GET_MPU_PLATFORM_DATA	\
> 	_IOWR(MPU_IOCTL, 0x02, struct mpu_platform_data)
> #define MPU_GET_EXT_SLAVE_DESCR	\
> 	_IOWR(MPU_IOCTL, 0x02, struct ext_slave_descr)
Perfectly acceptable to have sysfs attributes with input devices to, so that
doesn't matter so much.  Now there are issues with what they are.
Why is platform data passed via sysfs? It's platform data, so it belongs
in a board file or device tree.
> 
> These are simple register reads and register writes.  These can be
> replaced with iio sysfs attributes for the gyro driver.
> =======================================
> #define MPU_READ		_IOWR(MPU_IOCTL, 0x10, struct
> mpu_read_write)
> #define MPU_WRITE		_IOW(MPU_IOCTL,  0x10, struct
> mpu_read_write)
Hmm. These really don't belong in sysfs. They are opaque and completely
ungeneralizable.  If you have this of need to write general purpose stuff
then perhaps consider some of the work going on for communications between
asymmetric multiprocessor systems. 
> 
> The following is used to interact at runtime with the DMP.  These will
> need to remain as ioctls to drivers/misc/inv_mpu
> ========================================
> #define MPU_READ_MEM		_IOWR(MPU_IOCTL, 0x11, struct
> mpu_read_write)
> #define MPU_WRITE_MEM		_IOW(MPU_IOCTL,  0x11, struct
> mpu_read_write)
> #define MPU_READ_FIFO		_IOWR(MPU_IOCTL, 0x12, struct
> mpu_read_write)
> #define MPU_WRITE_FIFO		_IOW(MPU_IOCTL,  0x12, struct
> mpu_read_write)
These look fine.
> 
> These were used for reading raw data from each slave.  These can be
> replaced by an appropriate IIO interface for raw data, implemented
> separately by each slave driver.  Input can be then used for calibrated
> data and can be fed back via uinput from user space.
> ========================================
> #define MPU_READ_COMPASS	_IOR(MPU_IOCTL, 0x12, __u8)
> #define MPU_READ_ACCEL		_IOR(MPU_IOCTL, 0x13, __u8)
> #define MPU_READ_PRESSURE	_IOR(MPU_IOCTL, 0x14, __u8)
Those are fine.
> 
> These are used to configure each slave.  These can be replaced by sysfs
> attributes implemented by each slave driver in iio.
> ========================================================
> #define MPU_CONFIG_GYRO		_IOW(MPU_IOCTL, 0x20, struct
> ext_slave_config)
> #define MPU_CONFIG_ACCEL	_IOW(MPU_IOCTL, 0x21, struct
> ext_slave_config)
> #define MPU_CONFIG_COMPASS	_IOW(MPU_IOCTL, 0x22, struct
> ext_slave_config)
> #define MPU_CONFIG_PRESSURE	_IOW(MPU_IOCTL, 0x23, struct
> ext_slave_config)
> 
> #define MPU_GET_CONFIG_GYRO	_IOWR(MPU_IOCTL, 0x20, struct
> ext_slave_config)
> #define MPU_GET_CONFIG_ACCEL	_IOWR(MPU_IOCTL, 0x21, struct
> ext_slave_config)
> #define MPU_GET_CONFIG_COMPASS	_IOWR(MPU_IOCTL, 0x22, struct
> ext_slave_config)
> #define MPU_GET_CONFIG_PRESSURE	_IOWR(MPU_IOCTL, 0x23, struct
> ext_slave_config)
>
Again all fine.
 
> This was used to start or stop the system.  This can be replaced with iio
> sysfs power mode attribute for each slave, and an additional one for the
> MPU controller.
Ideally this wants to be handled via runtime pm so that the dependencies
are nicely handled.
> =========================================
> #define MPU_SUSPEND		_IOW(MPU_IOCTL, 0x30, __u32)
> #define MPU_RESUME		_IOW(MPU_IOCTL, 0x31, __u32)
> 
> Selecting on /dev/mpu will return a MPU_PM_EVENT_SUSPEND_PREPARE or
> MPU_PM_EVENT_POST_SUSPEND allowing user space to decide if it wants to
> leave anything powered on when suspended.  This in conjunction with the
> IGNORE_SYSTEM_SUSPEND allows the DMP plus gyro and/or accel to continue
> running while the main processor is suspended.  This can be used to wake
> up the main processor on a particular motion event, or to record motion
> events to be reported when the processor later wakes up.  This ioctl
> signals that user space has finished configuring all sensors and the MPU
> controller and that the MPU controller can continue.
> =======================================
> #define MPU_PM_EVENT_HANDLED	_IO(MPU_IOCTL, 0x32)
> 
> Requested sensors is a common place to know which sensors are on, and to
> specify which sensors to turn on the next time the system is started.
> This can be removed since it is redundant with power mode attributes I'm
> proposing be used by each slave and the MPU controller.
> =======================================
> #define MPU_GET_REQUESTED_SENSORS	_IOR(MPU_IOCTL, 0x40, __u8)
> #define MPU_SET_REQUESTED_SENSORS	_IOW(MPU_IOCTL, 0x40, __u8)
> 
> See my note on MPU_PM_EVENT_HANDLED above.  This can be made a SysFs
> attribute of drivers/misc/inv_mpu
> =======================================
> #define MPU_GET_IGNORE_SYSTEM_SUSPEND	_IOR(MPU_IOCTL, 0x41, __u8)
> #define MPU_SET_IGNORE_SYSTEM_SUSPEND	_IOW(MPU_IOCTL, 0x41, __u8)
Is this supported in runtime pm?  If not, perhaps it is a usecase that should
be.  Here we could disable the bus, but not for example relevant regulators.

> 
> These are bitfield of how the MPU controller state.  Which devices are
> currently suspended, which devices are running, if the i2c master is
> bypassed, if the DMP is running.  This can be made a SysFs attribute, and
> perhaps removed.
> =======================================
> #define MPU_GET_MLDL_STATUS		_IOR(MPU_IOCTL, 0x42, __u8)
If sysfs, it should be one attribute per device, not a bitfield.
> 
> This is a bitfield showing the status of which of the master i2c channels
> have been enabled.  The mpu3050 has 1 channel, and the mpu6050 has 5
> channels.  This can become a sysfs attribute
> =======================================
> #define MPU_GET_I2C_SLAVES_ENABLED	_IOR(MPU_IOCTL, 0x43, __u8)
I think this should be handled via some platform data / run time pm.

If there is something there and it's being talked to it should be enabled.
Otherwise not.
> 
> After all is said and done this is files that would be made available:
> /dev/mpu
> 	Iotcl interface for memory and fifo reads writes, read for events
> include pm events and irq events.
Make sure it is numbered. Perfectly reasonable to have more than one of these!
> 
> /sys/bus/iio/devices/device[ACCEL]/power_state
> /sys/bus/iio/devices/device[ACCEL]/accel_x_raw
> /sys/bus/iio/devices/device[ACCEL]/accel_y_raw
> /sys/bus/iio/devices/device[ACCEL]/accel_z_raw
> /sys/bus/iio/devices/device[ACCEL]/<other attributes as appropriate>
> 
> /sys/bus/iio/devices/device[MAGN]/power_state
> /sys/bus/iio/devices/device[MAGN]/magn_x_raw
> /sys/bus/iio/devices/device[MAGN]/magn_y_raw
> /sys/bus/iio/devices/device[MAGN]/magn_z_raw
> /sys/bus/iio/devices/device[MAGN]/<other attributes as appropriate>
> 
> /sys/bus/iio/devices/device[GYRO]/power_state
> /sys/bus/iio/devices/device[GYRO]/gyro_x_raw
> /sys/bus/iio/devices/device[GYRO]/gyro_y_raw
> /sys/bus/iio/devices/device[GYRO]/gyro_z_raw
> /sys/bus/iio/devices/device[GYRO]/<other attributes as appropriate>
> 
> Then for input ABS_X, ABS_Y and ABS_Z for each of the sensors containing
> calibrated data.  There are a number of other computed data values we
> would want to make available, but these can also be made available in user
> space by the MPL if necessary.
> 
>> Can the slave interface appears to be an i瞔 bus too or is the
>> interface
>> too different (ie could the smart mode create an i瞔 bus that it uses
>> to
>> talk to the drivers to configure them for 'smart' mode)
> 
> I'm not exactly sure of the details of what you are suggesting, but
> somehow telling a slave that it is now being used in 'smart' mode is fine,
> as long as the MPU controller can still read back the information it needs
> to control it, for example setting up the mpu3050 i2c master.
To my mind this should look a bit like the i2c bus multiplexers.  The only
difference is that under some conditions, devices won't respond (the master
has taken an exclusive lock on them).
> 
>> I'm not entirely sure at this point I understand quite how all the
>> pieces
>> fit together.
> 
> It is a fairly complicated system, and why I want to get a good idea of
> what we want long term before working on further changes.
Very sensible
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

