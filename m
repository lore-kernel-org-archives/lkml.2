Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab1CQScg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 14:32:36 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:52474 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916Ab1CQScd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 14:32:33 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D825402.5060400@cam.ac.uk>
Date: Thu, 17 Mar 2011 18:33:38 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Kay Sievers <kay.sievers@vrfy.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
        Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: Re: IIO comments
References: <201103152215.20059.arnd@arndb.de> <201103171424.07582.arnd@arndb.de> <4D823B38.2020002@cam.ac.uk> <201103171851.20759.arnd@arndb.de>
In-Reply-To: <201103171851.20759.arnd@arndb.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/11 17:51, Arnd Bergmann wrote:
> On Thursday 17 March 2011 17:47:52 Jonathan Cameron wrote:
> 
>>> Right, or you could mandate that each device has exactly one of these,
>>> but that you could have multiple iio devices in a single hardware
>>> device.
>>
>> That might lead to some very ugly largely false divides. I guess trying
>> it is the only way to find out. Some things will be really fiddly if
>> we make this divide, particularly buffering.  The hardware tends to
>> spit out 'scans' of a set of channels taken at more or less the same time.
>> If we split into multiple iio devices we'll need to split this data into
>> streams for each one.  The interactions between the available channels
>> can also be extremely complex, so we need to make it absolutely clear
>> which physical device they are on.  Note that you can only tell what
>> 'scan' elements are configured by trying to set up what you want, then
>> reading back to see what you got.  In some cases you even end up with
>> more than you asked for.
> 
> Ok, that makes sense. As you say, it's still possible to split
> the hardware streams into multiple streams on character devices,
> but it's less clear that this would simplify anything.
> 
> However, when you have devices that have separate hardware buffers
> for their channels, I think there is a much stronger incentive
> to model them as separate character devices. 
Agreed. I reserve the right to make rude noises at any hardware
manufacturers who have complex interactions between channels
spread across multiple hardware buffers.

> 
>> Probably the only way to do work out how manageable this is will
>> be to list what would be in this table, with vaguely sane restrictions.
>> Some awkward corner cases include differential channels where we
>> at least in theory have a combinatorial explosion. (inX-inY_raw)
>> We also have to double to cover _raw and _input cases though these
>> could easily be a pair of tables or use some metadata for each channel.
>>
>> Taking just the stuff in docs for the raw channel readings (and restricting
>> based on what I have to hand). Input devices only.
>>
>> in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11,
>> in0-in1, in0-in1, in2-in3, in3-in2, in5-in4, in4-in5, in7-in6,
>> in8-in9, in9-in8, in10-in11, in11-in10
>> accel_x, accel_y, accel_z, accel_x_peak, accel_y_peak, accel_z_peak, accel_xyz_squared_peak,
>> temp, temp_x, temp_y, temp_z, gyro_x, gyro_y, gyro_z,
>> magn_x, magn_y, magn_z, incli_x, inci_y, incli_z,
>> illuminance0, proximity, intensity_infrared.
>>
>> So a starting set of 46.  Also note that the really large tables will
>> be handling the event controls.  The only consistent way we have come
>> up with for that so far is to have the option of a separate value and
>> enable attribute for every channel and every type of event.  This would
>> definitely require more complex metadata to do.   I'd suggest a bitmap
>> specifying which are available.
> 
> I don't completely understand the notation. Regarding the various
> {in0, in1, in2, ...} inputs, is there a fundamental difference between
> them? In the code example I gave, a driver would simply list
> a set of inputs of the same type (IIO_CHAN_IN) and let the core
> enumerate them. What does "in0-in1" mean?
in0-in1 is a differential adc channel. Literally outputs value on
physical pin 1 subtracted from physical pin 2.
> 
> Also, the only table that would have to list all of them would be
> in the core, to list the names, and possibly a function point for
> pretty-printing the data, but many of these function pointers would
> point to the same few functions.
True.
> 
>> The compound versions (accel_xyz_squared_peak etc) are relatively unusual.
>>
>> We haven't covered energy meters or resolvers here as they don't have
>> documented interfaces yet.  It'll be about another 10 for them.
> 
> Fair enough.
> 
>> So all in all a flat table structure is going to be huge.  Given the
>> core won't operate on these things terribly often (basically setup
>> and tear down) rather than a table of things that may or may
>> not be set, we could have an association table which says what
>> is present.
> 
> Well, a driver only needs to list what it has, and that could
> be written in a rather compact way.
> 
>> It would be interesting to work out what the minumum structure
>> required to generate everything associated with a given channel
>> actually looks like...
>>
>> struct CHAN {
>>        enum CHAN_TYPE type;
>>        int index;  (x = 0, y = 1 etc).
> 
> Do you have drivers that have sparse indices? The core could simply
> enumerate them when it encounters channels of the same type for
> one device.
Sadly yes we do.  Some IMUs have 3D accelerometer and 2D gyros.

> 
>>        long sharedmask;                   //which of the functions are shared
>>        	    				  //so can we do single accel_bias
>> 					  //rather than accel_x_bias etc.. 
>>        long eventmask;                    //what events exist;
>>        bool scannable;
>>        etc.
>> }
> 
> Ok, I didn't think of other fields, but these seem to be needed,
> even if I don't understand them.
They basically provide information for the creation of the rest of abi apart form direct
reading attributes.  I merely want to avoid having lots of parallel tables.
> 
>> Then set of callbacks to be registered:
>>
>> read_val(type, index);
>> read_calibbais(type index);
>>
>> etc.
>>
>> This would keep the table reasonably short at the cost of a fair
>> number of function pointers.  Using the masks, the core can figure
>> out what attributes should exist and wire them up.
> 
> I don't think you need many function pointers. Having a function
> pointer in struct chan is may be a good idea, but if you have
> ten inputs that are all alike, they can all point to the same
> function, right?
Agreed. I had them in there originally but decided it was getting rather
clunky. In a sense this will look a little like taking the current
huge attribute tables and breaking them up into bits associated with
each channel.  We may want a certain amount of 'private_data' space
in the channel array as well to allow for things like addresses.  Not
sure on that yet though.
> 
>>>> Good point. We could just move the handling of these events into the
>>>> actual driver (this is only ever relevant for hardware buffers).  Thus
>>>> it could keep track of what it knows is there.  Note these devices don't
>>>> always provide any other way of knowing and yes you can read more data
>>>> from them than is actually there.  Whether you can tell this has happened
>>>> is very much device dependent.
>>>
>>> Can you give an example? I don't understand what you mean with "can read
>>> mode data [...] than is actually there".
>>
>> I might have the details of this wrong as I haven't checked everything
>> against the datasheets.
>> Lets take the sca3000 VTI accelerometers.
>>
>> They have 64 scan (read of x, y, z set) long hardware ring buffers.
>> There are two watershed events for how full the buffer is, 50% and 75%.
>> These result in a pin being raised if enabled.  This is routed through
>> a gpio on the host as an interrupt.  These thresholds are edge triggered
>> so will not retrigger unless the contents falls below the level then
>> rises past it again.
> 
> Ok, I see. So the hardware provides no way at all to find out how
> many events you are allowed to read, other than being allowed to
> read half the events if you got the 50% interrupt, right?
Yes, that's the nasty case.
'scans' in the terminology we are using (comes from that used in ADC
datasheets - have to be careful not to confuse the out of band stuff
which we are calling 'events' from the in band data flow).
> I wonder what the hardware people were thinking, there should at least
> be a way to find out whether the buffer is completely empty!
It actually makes sense on entirely interrupt driver embedded hardware.
In those case there are no pesky user controls allowing them to try
and read at the wrong time.

VTI seem to have decided their hardware buffers were a dead end and the
newer entries in that field tend to be more sensible (analog has
quite a few parts with hardware buffers, though some are somewhat
esoteric to put it lightly - their vibration sensors are going
to require some 'interesting' drivers to put it lightly).
> 
>> Currently we pass that event straight up to userspace.  Userspace can
>> then know there is at least that much data in the buffer and hence
>> request that much data back.
>>
>> If user space attempts to read less data from the buffer than is there
>> it is all fine and assuming user space always reads at least 50% then
>> we will get a new event.    If only one of the 50% full or 75% full
>> events is enabled, then we don't need to read which one occurred. Thus
>> we cut out one transaction on the bus (given the bus is slow this
>> really can matter).  The delays around a transaction can be a significant
>> part of the time taken to do a transaction (so this isn't swamped by
>> the time taken to read 32*3*2 bytes).
> 
> To be honest, this sounds like a horrible user interface. The kernel
> should always try to shield the user from details of the hardware buffer
> and provide an interface that can be used like a pipe: If there is
> any data to read, let the user get it, otherwise block the reading
> process or return -EAGAIN (in case of O_NONBLOCK) and wait for the
> user to call poll() for notification.
> 
> The kernel probably can spare much more RAM for input data than
> the device, so the natural implementation in the kernel would
> register a handler for the interrupt that reads all available data
> into a kernel fifo buffer, which gets emptied on the next read
> from user space.
> 
>> There is a separate register for the number of samples in the buffer. Right
>> now we don't use it. On other parts this may not be present (as it
>> needn't ever be used. It was this case I was referring two.
>> I'd forgotten it existed till I checked just now.
> 
> Ok. I truely hope that most hardware has something like this, but
> we can probably work around it as explained above if not.
Yes. Though do beware. spi and i2c buses for some of these things
can be 'very' slow and often congested on the actual boards. Hence
we sometimes spend a lot of effort to avoid transactions.
> 
>> So options to clean up this case and avoid event escalation.
>>
>> 1) Allow only one watershead interrupt to be configured on the device
>> at a time. (issue is if we ever hit a device where we can't turn them off).
>>
>> 2) Burn a transaction reading the buffer count then make sure we don't read
>> more than is there.  The events then just become a use of poll - perhaps
>> different flags for 50% full or 75% full if they are both enabled.
>>
>> 3) Handle the two watershead events in the driver, basically holding state.
>> Things may get fiddly if an event shows up during a read.
>>
>> For simplicity of review I'm tempted to go with 1 and make the a
>> requirement of all drivers unless someone comes up with a very
>> good reason why we need this functionality.
> 
> I would argue for a combination of 1 & 2. Configuring which of the
> two interrupts you want would be determined by the real-time and/or
> power management requirements, but should not be visible to the
> application reading the data, only when setting up the device.
I'd prefer to allow some direct control. There are use cases where
for filtering purposes you are only interested in a particular
length block of data. Still, that control may be the exception
rather than rule.  Lets just turn on the 50% by default then
vast majority of users won't ever touch it!
> 
> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

