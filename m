Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab0LGKUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 05:20:41 -0500
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:36781 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190Ab0LGKUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 05:20:39 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4CFE0C03.3010405@cam.ac.uk>
Date: Tue, 07 Dec 2010 10:27:15 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101123 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
CC: "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Drivers <Drivers@analog.com>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>
Subject: Re: [RFC 1/3] IIO: Direct digital synthesis abi documentation
References: <1291292489-32362-1-git-send-email-michael.hennerich@analog.com> <1291292489-32362-2-git-send-email-michael.hennerich@analog.com> <4CF8CED9.9060306@cam.ac.uk> <544AC56F16B56944AEC3BD4E3D591771312F0E1BB3@LIMKCMBX1.ad.analog.com>
In-Reply-To: <544AC56F16B56944AEC3BD4E3D591771312F0E1BB3@LIMKCMBX1.ad.analog.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/10 05:18, Hennerich, Michael wrote:
>> Jonathan Cameron wrote on 2010-12-03:
>> On 12/02/10 12:21, michael.hennerich@analog.com wrote:
>>> From: Michael Hennerich <michael.hennerich@analog.com>
>>>
>>> Proposed ABI documentation
>>>
>> Hi Michael,
>>
>> Couple of comments inline.
>>
>> I've raised a few questions that I don't have a clear answer two.
>>
>> The other comments are nitpicks about exact ordering of the elements
>> of the attribute names.
>>
>>> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
>>> ---
>>>  .../staging/iio/Documentation/sysfs-bus-iio-dds    |  103
>> ++++++++++++++++++++
>>>  1 files changed, 103 insertions(+), 0 deletions(-)
>>>  create mode 100644 drivers/staging/iio/Documentation/sysfs-bus-iio-
>> dds
>>>
>>> diff --git a/drivers/staging/iio/Documentation/sysfs-bus-iio-dds
>> b/drivers/staging/iio/Documentation/sysfs-bus-iio-dds
>>> new file mode 100644
>>> index 0000000..2c99889
>>> --- /dev/null
>>> +++ b/drivers/staging/iio/Documentation/sysfs-bus-iio-dds
>>> @@ -0,0 +1,103 @@
>>> +
>>> +What:              /sys/bus/iio/devices/device[n]/ddsX_freqY
>> Here we deviate a little from what we did with input channels.
>> In that case there was the existing interface (from hwmon) to match
>> so we already had an _input designation to tell us that the number
>> was in the relevant base units (here it would be Hz).  Hence we added
>> a _raw label to say it wasn't and tell userspace to apply scale and
>> offset.
>> This is stretching a point somewhat, but looking at the hwmon docs,
>> they
>> have pwmX_freq as a value in Hz. That's obviously going to make
>> consistency
>> rather tricky to achieve!
>>
>> Do you think we should leave all _freq without modifier as being in Hz
>> and
>> have ddsX_freqY_raw. Or should we rely on userspace verifying if there
>> are
>> appropriate scale / offset parameters to be applied and hence working
>> out
>> for itself whether the value in ddsX_freqY is in Hz or not?
>>
>> I'm think I marginally favour leaving it as you have it here but others
>> may
>> have different opinions.
> 
> Offset is not likely to be used here - but
> these devices actually provide sub Hertz resolution. It's very likely to occur,
> that we want to have scale being 1000 and the user writes frequency in mHz.
> I might even consider using mHz for the sample driver as well.
I guess it's a question of whether doing the fixed point arithmetic in kernel
is cheap enough to use Hz but allow for a decimal point?  That would remove the
need for the _scale parameter which would simplify the user interface slightly.

Lets go with what you originally suggested. It works and with clear documentation
the difference between it and some of our other 'frequency' elements shouldn't
confuse anyone.
> 
>>> +KernelVersion:     2.6.37
>>> +Contact:   linux-iio@vger.kernel.org
>>> +Description:
>>> +           Stores frequency into tuning word register Y.
>>> +           There can be more than one ddsX_freqY file, which allows
>> for
>>> +           pin controlled FSK Frequency Shift Keying
>>> +           (ddsX_pincontrol_freq_en is active) or the user can control
>>> +           the desired active tuning word by writing Y to the
>>> +           ddsX_freqsymbol file.
>>> +
>>> +What:              /sys/bus/iio/devices/device[n]/ddsX_freq_scaleY
>> Would the association be clearer if we went with ddsX_freqY_scale?  I
>> think
>> that is more consistent with what we have elsewhere in IIO (though this
>> particular
>> double index case hasn't happened before)
> 
> Well - I thought use ddsX_freqY_scale whenever scale is different upon Y.
> And leave without index if it is common between ddsX_freqY.
> The Y after scale is just a typo.
Cool, without the Y it is just fine.  We can document the Y case if/when it
turns up in a driver.
> 
>>> +KernelVersion:     2.6.37
>>> +Contact:   linux-iio@vger.kernel.org
>>> +Description:
>>> +           Scale to be applied to ddsX_freqY in order to obtain the
>>> +           desired value in Hz. If shared across all frequency
>> registers
>>> +           Y is not present.
>> Please add that it is also possible X is not present if shared across
>> all channels.  In weird cases X might not be present whilst Y is...
> 
> ok
> 
>>> +
>>> +What:              /sys/bus/iio/devices/device[n]/ddsX_freqsymbol
>>> +KernelVersion:     2.6.37
>>> +Contact:   linux-iio@vger.kernel.org
>>> +Description:
>>> +           Specifies the active output frequency tuning word. The
>> value
>>> +           corresponds to the Y in ddsX_freqY. To exit this mode the
>> user
>>> +           can write ddsX_pincontrol_freq_en or ddsX_out_disable file.
>>> +
>>> +What:              /sys/bus/iio/devices/device[n]/ddsX_phaseY
>>> +KernelVersion:     2.6.37
>>> +Contact:   linux-iio@vger.kernel.org
>>> +Description:
>>> +           Stores phase into phase register Y.
>>> +           There can be more than one ddsX_phaseY file, which allows
>> for
>>> +           pin controlled PSK Phase Shift Keying
>>> +           (ddsX_pincontrol_phase_en is active) or the user can
>>> +           control the desired phase Y which is added to the phase
>>> +           accumulator output by writing Y to the en_phase file.
>>> +
>>> +What:              /sys/bus/iio/devices/device[n]/ddsX_phase_scaleY
>> Same reordering suggestion as per the frequency one above.
>>> +KernelVersion:     2.6.37
>>> +Contact:   linux-iio@vger.kernel.org
>>> +Description:
>>> +           Scale to be applied to ddsX_phaseY in order to obtain the
>>> +           desired value in rad. If shared across all phase registers
>>> +           Y is not present.
>>> +
>>> +What:              /sys/bus/iio/devices/device[n]/ddsX_phasesymbol
>>> +KernelVersion:     2.6.37
>>> +Contact:   linux-iio@vger.kernel.org
>>> +Description:
>>> +           Specifies the active phase Y which is added to the phase
>>> +           accumulator output. The value corresponds to the Y in
>>> +           ddsX_phaseY. To exit this mode the user can write
>>> +           ddsX_pincontrol_phase_en or disable file.
>>> +
>>
>> It might make sense to group the next three by having multiple What
>> lines
>> and then an explanation covering all three.
> 
> Makes sense, thanks.
> 
>>> +What:              /sys/bus/iio/devices/device[n]/ddsX_pincontrol_en
>>> +KernelVersion:     2.6.37
>>> +Contact:   linux-iio@vger.kernel.org
>>> +Description:
>>> +           Both, the active frequency and phase is controlled by the
>>> +           respective phase and frequency control inputs.
>>> +
>>> +What:
>>       /sys/bus/iio/devices/device[n]/ddsX_pincontrol_freq_en
>>> +KernelVersion:     2.6.37
>>> +Contact:   linux-iio@vger.kernel.org
>>> +Description:
>>> +           The active frequency is controlled by the respective
>>> +           frequency control/select inputs.
>>> +
>>> +What:
>>       /sys/bus/iio/devices/device[n]/ddsX_pincontrol_phase_en
>>> +KernelVersion:     2.6.37
>>> +Contact:   linux-iio@vger.kernel.org
>>> +Description:
>>> +           The active phase is controlled by the respective
>>> +           phase control/select inputs.
>>> +
>> Could group the next two sections of documentation into one and
>> describe
>> both versions together.  See how it's done in the latest main IIO docs.
>> I think it tends to make it apparent when there are multiple very
>> similar
>> attributes that may affect the same signals.
> 
> ok
> 
>>> +What:              /sys/bus/iio/devices/device[n]/ddsX_out_disable
>>> +KernelVersion:     2.6.37
>>> +Contact:   linux-iio@vger.kernel.org
>>> +Description:
>>> +           Disables any signal generation on all outputs.
>> With the X in there you need to say for dds X.
>> On everything else so far we have tended to go with enable attributes
>> rather than
>> this way around.  Why do it as disable here?
> 
> We can change the logic. The sample driver enables the output once the
> ddsX_outY_wavetype file is written.
Is that a good idea? What if a device is dependant on having a very particular
frequency fed to it and the user not knowing that wavetype turns things on might
set that before the frequency? The semantics don't make it clear that one must set the
wavetype last.  I would think separating the configuration from enable/disable
might be more intuitive. 
> 
>>> +
>>> +What:              /sys/bus/iio/devices/device[n]/ddsX_outY_disable
>>> +KernelVersion:     2.6.37
>>> +Contact:   linux-iio@vger.kernel.org
>>> +Description:
>>> +           Disables any signal generation on output Y.
>>> +
>>> +What:              /sys/bus/iio/devices/device[n]/ddsX_outY_wavetype
>>> +KernelVersion:     2.6.37
>>> +Contact:   linux-iio@vger.kernel.org
>>> +Description:
>>> +           Specifies the output waveform.
>>> +           (sine, triangle, ramp, square, ...)
>>> +           For a list of available output waveform options read
>>> +           available_output_modes.
>>> +
>>> +What:
>>       /sys/bus/iio/devices/device[n]/ddsX_outY_available_wavetypes
>> Convention so far in IIO (because it's easy to handle in code) would
>> make this
>> ddsX_outY_wavetype_available.
> 
> ok
> 
>>> +KernelVersion:     2.6.37
>>> +Contact:   linux-iio@vger.kernel.org
>>> +Description:
>>> +           Lists all available output waveform options.
>>> --
>>> 1.6.0.2
> 
> Thanks for your review.
You are welcome,

Jonathan
 

