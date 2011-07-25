Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358Ab1GYJRB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 05:17:01 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:57345 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab1GYJQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 05:16:55 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E2D348C.7020702@cam.ac.uk>
Date: Mon, 25 Jul 2011 10:17:00 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: Sysfs - export sysfs_create_subdir?
References: <4E29B6B1.2090107@cam.ac.uk> <20110724031804.GA16601@kroah.com>
In-Reply-To: <20110724031804.GA16601@kroah.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/11 04:18, Greg KH wrote:
> On Fri, Jul 22, 2011 at 06:43:13PM +0100, Jonathan Cameron wrote:
>> Hi All,
>>
>> I have a couple of cases in IIO where under some conditions
>> we end up using dummy attr_groups (no elements) to initialize
>> a sub directory before dynamically creating all of its attributes.
> 
> Ick, you really shouldn't do that.
Agreed :)
> 
>> Now having dummy groups in the IIO core is fine, but it does seem
>> a little messy.
>>
>> The obvious choice would be to put together a small wrapper function
>> for sysfs_create_subdir that also does sysfs_get on the result.
> 

The sysfs_get issue still exists if we are creating all the elements in
the base directory (which we are in a few drivers - most have something
that isn't handled by the channel spec though).

> That's why that function is not exported.  Creating subdirectories in
> sysfs is not a good idea, udev doesn't like it, and you don't get
> userspace notification for it very well either.
> 
> What specifically are you trying to do in sysfs that you are needing
> this?
We are using it purely for organisation.  Note that when I said dynamically
creating all the attributes I meant at probe of the device.  We aren't
talking about creating subdirectories under any other conditions.

The primary reason is that the attributes in IIO fall into a couple of nice
clean groups and there can be an awful lot of them.

Hence taking an adis16400 as an example (from memory). Note the naming is based
on some more abi tweaks that are in progress.  I've also for reference added
the events side of things which this driver doesn't currently have (last patches
for this have long since bit rotted beyond being useful!).  Note this is
a moderately complex example.  There are devices with more channels, but this
has the greatest mix of anything currently in tree.

We have the following structure currently

iio:deviceX/  // top level directory containing the basic read parameters
              // for the channels + conversion factors (offsets calibration stuff
              // etc) + stuff that effects everything such as sampling frequency.

In this device that contains the following created from the chan_spec
structures.

in_voltage0_supply_raw
in_voltage0_supply_scale
in_accel_x_raw
in_accel_y_raw
in_accel_z_raw
in_accel_scale
in_gyro_x_raw
in_gyro_y_raw
in_gyro_z_raw
in_gyro_scale
in_magn_x_raw
in_magn_y_raw
in_magn_z_raw
in_magn_scale
in_temp0_raw
in_temp0_scale
in_temp0_offset
in_voltage1_raw
in_voltage1_scale

in this case we also have the following.

sampling_frequency
sampling_frequency_available
reset

iio:deviceX/buffer // control elements for the buffer - these depend on the selected
                   // buffer implementation - right now this driver only uses ring_sw,
                   // but others support kfifo and ring_sw.
                   // Note the device driver has nothing to do with these, they are
                   // provided by the buffer implementation.  There is no known reason
                   // why a device driver would need to add anything to here.
contains

length
bytes_per_datum
enable

iio:deviceX/scan_elements  // Control and description of 'scans'. These are the mass
                           // data reads that are pushed to the buffer on a trigger.  

in_voltage0_supply_en
in_voltage0_supply_type
in_gyro_x_en
in_gyro_x_type
in_gyro_y_en
in_gyro_y_type
in_gyro_z_en
in_gyro_z_type
in_accel_x_en
in_accel_x_type
in_accel_y_en
in_accel_y_type
in_accel_z_en
in_accel_z_type
in_magn_x_en
in_magn_x_type
in_magn_z_en
in_magn_z_type
in_voltage0_en
in_voltage0_type
in_timestamp_en
in_timestamp_type

All of these are only of interest if you are using the buffer.

If the events were implemented we would have

iio:deviceX/events //control of events (thresholds basically)

in_voltage0_supply_thresh_rising_value
in_voltage0_supply_thresh_rising_en
in_voltage0_supply_thresh_falling_value
in_voltage0_supply_thresh_falling_en
in_voltage0_supply_roc_rising_value
in_voltage0_supply_roc_rising_en
in_voltage0_supply_roc_falling_value
in_voltage0_supply_roc_falling_en

in_gyro_x_supply_thresh_rising_value
in_gyro_x_supply_thresh_rising_en
in_gyro_x_supply_thresh_falling_value
in_gyro_x_supply_thresh_falling_en
in_gyro_x_supply_roc_rising_value
in_gyro_x_supply_roc_rising_en
in_gyro_x_supply_roc_falling_value
in_gyro_x_supply_roc_falling_en

etc for all the other channels so 88 attrs in here.

These are only relevant if you are interested in events.  There are
occasionaly reasons for other elements in this directory not created
from the channel spec (for example if the event monitoring sampling
frequency is separate from the main one), but in most cases this
directory is entirely created from our channel description structures.

Note as I said above all of these are created at probe time and
correspond directly to the equivalent:

static const attribute adis16400_event_attrs[] = {
};

static const attribute_group adis16400_event_group {
       .name = "events",
       .attrs = adis16400_event_attrs,
};

This is more obvious after the recent flattenning of our
tree as a result of combining the previous 3 chrdevs per
complex device into one.

(as an aside there is also a triggerX device for the adis16400
data ready, but that is nice and simple and conventional).

We could flattern everything into one directory and do everything
with appropriate prefixes but that is really ugly.

So how should we do this?

Thanks,

Jonathan

p.s. Having just grepped our tree for various things whilst writing this I've
noticed some 'interesting' drivers that were setting attributes up in a directory
with DRV_NAME as the directory name.  Patch will follow to get rid of those...
Actually we aren't the only ones.  There are a couple of examples in misc as well..
