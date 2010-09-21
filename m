Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab0IUOxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 10:53:06 -0400
Received: from ppsw-30.csi.cam.ac.uk ([131.111.8.130]:49356 "EHLO
	ppsw-30.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab0IUOxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 10:53:03 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4C98C7FE.4050305@cam.ac.uk>
Date: Tue, 21 Sep 2010 15:58:06 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100909 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Dmitry Torokhov <dtor@mail.ru>, Hemanth V <hemanthv@ti.com>,
        Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
        Jean Delvare <khali@linux-fr.org>, Greg KH <greg@kroah.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>, drivers@analog.com,
        achew@nvidia.com, Donggeun Kim <dg77.kim@samsung.com>
Subject: RFC: Sensor event related attribute naming.
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I afraid this is a fairly dense email to start the discussion.
There is a lot to cover and I wanted to start with a reasonably
thorough description for what I want to get the communities
opinions on.

The types of events this discussion is meant to cover are
those that are produced by 'smart' sensors.  These sensors
have on device implementations of various simple algorithms
to derive conditions such as free fall.

To provide a quick idea of the sort of sensors we are considering:
* Accelerometers
* Gyroscopes
* Generic ADCs
* Magnetometers
* Light sensors
* Proximity sensors

Now lets start to form a list of what events exist (please add
anything else you have seen with an example of a device that does it!)

threshold interrupts -  (a boundary is crossed, either by
	rising value or falling value)
	adis16350 and numerous others (IIO - IMU so most sensor types)
	tsl2563 (iio -light),
	tmd2771x (iio - light)

rate of change interrupts (a boundary in the rate of change
	is crossed either by rising above a particular value
	or falling below it)
	adis16350 (IIO) and lots of other Analog devices parts.

magnitude interrupts -
	same as threshold for unsigned measurements (hence not used
	in that case). If signed then abs(value) is compared with the
	threshold.  Common on accelerometers (often couched as either
	free fall or motion detector though these can be more complex)
	 
free fall detector - (often no parameters for this one)
	in some cases these are simple low magnitude thresholds,
	but AND across all directions.
	on all axes.
	adxl345 (input - accel)
	sca3000 (IIO - accel)
	cma3000 (input shortly - accel) - partly blocked pending this
		discussion.

Motion detector
	in some cases these are simple high magnitude thresholds,
	but OR on all directions
	adxl345 (input - accel)
	sca3000 (IIO - accel)
	cma3000 (input shortly - accel)
	kxsd9 (IIO - accel)

Some more specific types provide:
Click detection
Double click detection
Orientation change detection

A number of discussions have highlighted the advantages of
a consistent naming structure for attributes relating to such
events. To pull out one recent case of a driver being blocked
by the lack of agreement on naming conventions.

[PATCH] input: CMA3000 Accelerometer Driver http://lkml.org/lkml/2010/9/8/21

Currently there are a few related attributes in various drivers:

For example hwmon implements some 'alarms'.
To pull out those for temperature sensors
temp[1-*]_alarm
temp[1-*]_min_alarm
temp[1-*]_max_alarm
temp[1-*]_crit_alarm
temp[1-*]_fault

These clearly cover the important cases for hardware monitoring
but I don't think they generalize well to more general sensor types.

We have had naming conventions in IIO for a while but they have not
yet been terribly satisfactory. Our latest suggestion, which I'm
finally happy is general enough whilst remaining clear to be found
in  http://marc.info/?l=linux-iio&m=128394796116223&w=2

Manuel Stahl pointed out that the following summary covers what was
proposed in a clearer fashion.

<channel>_<limit>_<dir>_<attr>, where
 <channel>: name of the channel, i.e. accel_x0
 <limit>:   thresh, mag, roc
 <dir>:     rising, falling
 <attr>:    en, value, period, mean_period

<channel> tells us which device channel.  Our naming convention is an
  extension of that of hwmon.  So we have types:
  in, accel, gyro, magn, illuminance etc

  All of these can be modified to be more specific, either with a number
  or a label. So we can have accel7, accel_x, accel_x2 etc if appropriate.
  More general interrupts, such as those on any axis can be specified by
  dropping the modifier. So accel_thresh_rising_value will apply to all
  axes.	

  It's not unusual to have a device where the  threshold value is
  shared across all axes, but they an be enabled independently. Thus some
  attributes may be shared whilst others are not.  We also allow attributes
  to interact. So if a threshold is shared across x and y, but not z axes
  we would have accel_x_thresh_value and accel_y_thresh_value both reading
  the same underlying value.  The naming convention just gets too complex
  if we don't allow this. This is particularly true with devices that support
  say 2 alarms that can then be attached to any of a much larger set of
  channels. In these cases the userspace code attempt to write what it wants.
  The driver is responsible for providing the 'best' available set (so first
  in first out if there aren't enough alarms) then user space must read back
  the attributes to find out what it actually set up. We may add some
  'hint' attributes at a later date to save some complexity in userspace
  by say indicating that only 2 alarms are usable at a time.

  Other modifiers will be needed in future to cover things like sum squared
  thresholds.  Some events may have their own label (not matching a channel).
  For example, orientation detector events aren't linked to any single sensor.

<limit> describes the type of event.
  Options in IIO so far:
  * thresh - signed threshold interrupt
  * mag - theshold on abs(value)
  * roc - rate of change
  This list can be extended to include freefall, orientation etc

<dir> describes the direction of the interrupt.
  Options in IIO so far:
  *  - leaving this out means it is on both directions (or not relevant to
	the event type)
  * rising
  * falling

<attr> is used in the above summary to indicate the types of event
   related attributes we actually have. So far we have defined: 

  en - enable / disable the event.
  value - the value associated with the event. In our case whether
	this is a raw (adc counts) or processed (SI units) value
	can be established from other non event attributes. Perhaps
	we should make this explicit in the naming.
  period - a period for which the event is true before the devices
	sends an interrupt to the host.
  mean_period - a moving average is compared to the threshold and	
	this parameters sets the window width.  More complex filters
	exist (such as FIR low pass filters) but we haven't explicitly
 	set an interface for these as yet.  Filtering on these units
	is a complex mess and we simply don't have enough device
	drivers implementing them explicitly to pin down a unified
	interface for these as yet.

  This list is no where near comprehensive. It is just based on what
  we needed to cover the vast majority of our current driver set.

Naturally having come up with the IIO interface spec (with assistance
from members of that community), I'm in favour every one picking that up :)

However, we are still in staging and that gives us some leeway to get this
right. The purpose of this RFC is to get opinions from the wider community,
with the intent that we can not only get a naming convention that meets our
needs, but hopefully one of more general utility. The ideal would be to
come up with a convention that suits everyone with a similar problem.

Thanks for reading this far and sorry again for not being able to
introduce the question more succinctly.

Please add any relevant questions I have forgotten.

All opinions on this topic welcomed!

Jonathan 

p.s. As ever please cc anyone who may want to contribute - this list above
is either people who have been vocal on similar issues in the past, or
submitted drivers recently where these questions are relevant.
