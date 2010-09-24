Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab0IXLxq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 07:53:46 -0400
Received: from ppsw-32.csi.cam.ac.uk ([131.111.8.132]:37598 "EHLO
	ppsw-32.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391Ab0IXLxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 07:53:44 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4C9C927B.1010500@cam.ac.uk>
Date: Fri, 24 Sep 2010 12:58:51 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100909 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: Hemanth V <hemanthv@ti.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, Dmitry Torokhov <dtor@mail.ru>,
        Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
        Jean Delvare <khali@linux-fr.org>, Greg KH <greg@kroah.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>, drivers@analog.com,
        achew@nvidia.com, Donggeun Kim <dg77.kim@samsung.com>
Subject: Re: Sensor event related attribute naming.
References: <4C98C7FE.4050305@cam.ac.uk> <03d301cb5bd4$152287d0$LocalHost@wipblrx0099946>
In-Reply-To: <03d301cb5bd4$152287d0$LocalHost@wipblrx0099946>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/10 11:34, Hemanth V wrote:
> ----- Original Message ----- From: "Jonathan Cameron" <jic23@cam.ac.uk>
> <snip>
>>
>> We have had naming conventions in IIO for a while but they have not
>> yet been terribly satisfactory. Our latest suggestion, which I'm
>> finally happy is general enough whilst remaining clear to be found
>> in  http://marc.info/?l=linux-iio&m=128394796116223&w=2
>>
>> Manuel Stahl pointed out that the following summary covers what was
>> proposed in a clearer fashion.
>>
>> <channel>_<limit>_<dir>_<attr>, where
>> <channel>: name of the channel, i.e. accel_x0
>> <limit>:   thresh, mag, roc
>> <dir>:     rising, falling
>> <attr>:    en, value, period, mean_period
>>
> 
> Jonathan, I am trying to understand howto apply this to cma3000. I
> have few parameters like below. Would you be able to suggest how
> the sysfs entries should look like for the below parameters or are these
> still to be defined.
Hi Hemanth,

> 
> grange:  2000, 8000 mg sampling frequency  : 40, 100, 400 Hz
These weren't covered by this discussion at all. However, I am happy to at
least tell you how these are handled in IIO.  Firstly instead of defining
ranges we define _scale attributes.  This decision has a lot to do with
our approach of using raw data. To process that data, userspace needs to
know how to scale it appropriately. It really doesn't directly care what the
limits are.  If there is a particular use case for these limits directly then
we could propose adding say accel_mag_max. Such a parameter would clearly
interact with the alternate setting mechanism of accel_scale and maintaining
that relationship would be a job for the driver.

Note that if the multiplication is handled in driver (and hence to userspace
looks like the device was doing it) then any sysfs based output is obtained
via accel_x_input and the associated scale would be in accel_calibgain.
accel_calibgain_available would give a space separated list of available gains.

Also note that we always stick to SI units, so accelerations are measured in
m/s^2 rather that g, so there are some factors to be taken into account.
We are against making an exception for accelerometers because that will then
make the units for a given sensor type very unpredictable.

Frequency is controlled via sampling_frequency (in Hz) with a space
separated list of available options in sampling_frequency_available

Things are a little fiddly for some parts as the available range can be
mode dependant - lower frequencies are often used for motion detection.
For example, when motion detection is enabled on the cma3000 the sampling
frequency and the measurement range change (10Hz and 8g) so this should be
reflected in any reads of these attributes.

> Modes : Motion detect, Measurement, Free fall
Based on our sca3000 driver and the cma3000 data sheet.

The device starts up in Measurement mode - this is the mode it is always
in if neither of the others are enabled.  It's up to userspace to switch to
one of the other modes.  If sysfs direct read attributes are supplied and the
current mode does not allow values to be obtained then we simply return -EBUSY.

We then have two event enable attributes.  The names of these are up for
discussion (and part of what this thread was meant to address).  Let us for
now call them:
accel_freefall_en and accel_motiondetect_en

The will have accompanying parameters

accel_motiondetect_period (MDTMR[3:0] -> in seconds, a pain to do, but it's the
			only way we will have a consistent interface, for cases
			like this with few options,
			 accel_motiondetect_period_available could provide a
			 list of options)
accel_motiondetect_value (MDTHR[6:0] -> in either raw units or processed.
			 Whether we need to make this choice explicit in
			 the naming is one of the questions I was hoping this
			 thread might answer) Perhaps
			 accel_motiondetect_value_input for processed values
			 and accel_motiondetect_value_raw for raw sensor units
			 (adc counts).

accel_freefall_period (FFTMR[3:0] -> again in seconds)
accel_freefall_value (FFTMR[3:0])

In our event code structure (not yet posted) we actually allow another option
which leads to a more logical and general description of these two detectors
which I am keen on because we do have parts that allow weird subsets and
devices other than accelerometers that actually perform very similar combined
axis boolean combinations. Basically freefall and motiondetect don't really
generalise to anything other than 3d accelerometers.

For motion detection:

accel_x|y|z_thresh_rising_en (the | characters are part of the name,
			     not indicating options for naming!)

accel_x|y|z_thresh_rising_period, accel_x|y|z_thresh_rising_value

for freefall:

accel_x&y&z_thresh_falling_en
accel_x&y&z_thresh_falling_value
accel_x&y&z_thresh_falling_period

These generalize to other forms of sensor far better than the magic 'freefall'
but do not easily allow for more sophisticated free fall detectors. From an IIO
point of view I would actually like to distinguish how these detectors are
working but fully appreciate that your average user on a mobile phone doesn't
care!

I also know of some parts that do more complex arithmetic to detect free fall
such as applying the detector on the sum squared value. I haven't as yet worked
out how to name that one! Perhaps, accel_sum^2_thresh_falling_en?  One for
another day I think.

Anyhow for your part you would need to make the attributes mutually exclusive
(I think).  Thus we only guarantee that an interrupt will remain enabled as long
as no userspace interactions occur with the attributes.  Hence if one enabled
freefall first then motion detection, userspace gets to find out they are
mutually exclusive by reading back the values when it is done setting up what it
would like.  Providing the 'mode' type option you suggested unfortunately does
not generalize. For the cma3000 for example, how do you indicate that full rate
data (more or less as if you were in measurement mode) is available when in free
fall mode, but not when in motion detection mode? (on the sca3000 to take this
futher, motion detecton mode completely disables any direct reading of the
acceleration values) Also, the mode approach breaks down the moment you have
a device that can do 2 out of n forms of detection at the same time.  This is
very common (see Analog devices adis parts which have 2 general purpose alarms
which can detect various things on one channel each where there may be 10 or
more channels).

For these special cases, I am perfectly willing to accept that simply labelling
them free fall and motion detect is fine. I may map the resulting codes in IIO
to the same as for the above alternate forms, but that doesn't matter for this
discussion.

Thanks,

Jonathan
