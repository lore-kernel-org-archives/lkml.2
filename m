Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab1CQQqs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 12:46:48 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:43650 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895Ab1CQQqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 12:46:47 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D823B38.2020002@cam.ac.uk>
Date: Thu, 17 Mar 2011 16:47:52 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Kay Sievers <kay.sievers@vrfy.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
        Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: Re: IIO comments
References: <201103152215.20059.arnd@arndb.de> <201103161615.30799.arnd@arndb.de> <4D80D862.7080601@cam.ac.uk> <201103171424.07582.arnd@arndb.de>
In-Reply-To: <201103171424.07582.arnd@arndb.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...
>>>> The moment we put a route in for registering additional attributes
>>>> the out-of-tree argument is weakened.
>>>
>>> Would it help to have multiple types of interfaces (I suppose
>>> you already do), each with their own table?
>>>
>>> This way you could enforce that all drivers of one type use
>>> exactly the same specification, but also make it possible
>>> to have new types, even those that have only one driver by
>>> design.
>>
>> Sadly there are no clean definitions of types.  You'd be amazed what
>> downright weird sets end up in a given device.
>> Might be some way of breaking it down into a set of tables though
>> in a vaguely coherent way.  Each device would then have one or more
>> of these for which it would define one or more of the functions.
> 
> Right, or you could mandate that each device has exactly one of these,
> but that you could have multiple iio devices in a single hardware
> device.
That might lead to some very ugly largely false divides. I guess trying
it is the only way to find out. Some things will be really fiddly if
we make this divide, particularly buffering.  The hardware tends to
spit out 'scans' of a set of channels taken at more or less the same time.
If we split into multiple iio devices we'll need to split this data into
streams for each one.  The interactions between the available channels
can also be extremely complex, so we need to make it absolutely clear
which physical device they are on.  Note that you can only tell what
'scan' elements are configured by trying to set up what you want, then
reading back to see what you got.  In some cases you even end up with
more than you asked for.

Probably the only way to do work out how manageable this is will
be to list what would be in this table, with vaguely sane restrictions.
Some awkward corner cases include differential channels where we
at least in theory have a combinatorial explosion. (inX-inY_raw)
We also have to double to cover _raw and _input cases though these
could easily be a pair of tables or use some metadata for each channel.

Taking just the stuff in docs for the raw channel readings (and restricting
based on what I have to hand). Input devices only.

in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11,
in0-in1, in0-in1, in2-in3, in3-in2, in5-in4, in4-in5, in7-in6,
in8-in9, in9-in8, in10-in11, in11-in10
accel_x, accel_y, accel_z, accel_x_peak, accel_y_peak, accel_z_peak, accel_xyz_squared_peak,
temp, temp_x, temp_y, temp_z, gyro_x, gyro_y, gyro_z,
magn_x, magn_y, magn_z, incli_x, inci_y, incli_z,
illuminance0, proximity, intensity_infrared.

So a starting set of 46.  Also note that the really large tables will
be handling the event controls.  The only consistent way we have come
up with for that so far is to have the option of a separate value and
enable attribute for every channel and every type of event.  This would
definitely require more complex metadata to do.   I'd suggest a bitmap
specifying which are available.

The compound versions (accel_xyz_squared_peak etc) are relatively unusual.

We haven't covered energy meters or resolvers here as they don't have
documented interfaces yet.  It'll be about another 10 for them.

So all in all a flat table structure is going to be huge.  Given the
core won't operate on these things terribly often (basically setup
and tear down) rather than a table of things that may or may
not be set, we could have an association table which says what
is present.

It would be interesting to work out what the minumum structure
required to generate everything associated with a given channel
actually looks like...

struct CHAN {
       enum CHAN_TYPE type;
       int index;  (x = 0, y = 1 etc).
       long sharedmask;                   //which of the functions are shared
       	    				  //so can we do single accel_bias
					  //rather than accel_x_bias etc.. 
       long eventmask;                    //what events exist;
       bool scannable;
       etc.
}

Then set of callbacks to be registered:

read_val(type, index);
read_calibbais(type index);

etc.

This would keep the table reasonably short at the cost of a fair
number of function pointers.  Using the masks, the core can figure
out what attributes should exist and wire them up.


> 
>>> is to have an ioctl function that returns structured
>>> data, while the regular read function returns the buffered
>>> input stream.
>>
>> That would work, but it is it really worth it to kill off the chrdev?
> 
> I don't know.
> 
>> Note we still need most of the underlying structure just to keep the
>> various attributes well categorized.
> 
> The hardest part of interface design is always to find the simplest
> possible way that can cover all the corner cases. I'm trying to
> come up with possible simplifications, but I don't know all the
> requirements that get in the way.
Sure.  Most of these suggestions are going to be a case of suck it
and see.  We could analyse ever case we have in there now, but
a new one we haven't considered could come along tomorrow.  That's
partly why the subsystem has kept up a high rate of changes whilst
it's been in staging.
> 
>>>>> Doesn't epoll handle the event escalation with its edge triggered
>>>>> mode? Basically you can get notified every time that there is
>>>>> more to be read.
>>>> We also need to know how much more this is to be read.  So at the
>>>> moment, if a 50% full turns up and isn't picked up by userspace
>>>> before a 75% full event, the 50% is escalated to become a 75%
>>>> event which userspace then receives.  To be honest I'm tempted,
>>>> for now at least to drop this functionality.  It has few users
>>>> and makes the events system considerably more complex.  We can
>>>> think about how / whether to introduce it later.
>>>
>>> Yes, good point. I also don't get the use case of this. Why would
>>> user space not just always read all data that is available?
>> Good point. We could just move the handling of these events into the
>> actual driver (this is only ever relevant for hardware buffers).  Thus
>> it could keep track of what it knows is there.  Note these devices don't
>> always provide any other way of knowing and yes you can read more data
>> from them than is actually there.  Whether you can tell this has happened
>> is very much device dependent.
> 
> Can you give an example? I don't understand what you mean with "can read
> mode data [...] than is actually there".

I might have the details of this wrong as I haven't checked everything
against the datasheets.
Lets take the sca3000 VTI accelerometers.

They have 64 scan (read of x, y, z set) long hardware ring buffers.
There are two watershed events for how full the buffer is, 50% and 75%.
These result in a pin being raised if enabled.  This is routed through
a gpio on the host as an interrupt.  These thresholds are edge triggered
so will not retrigger unless the contents falls below the level then
rises past it again.

Currently we pass that event straight up to userspace.  Userspace can
then know there is at least that much data in the buffer and hence
request that much data back.

If user space attempts to read less data from the buffer than is there
it is all fine and assuming user space always reads at least 50% then
we will get a new event.    If only one of the 50% full or 75% full
events is enabled, then we don't need to read which one occurred. Thus
we cut out one transaction on the bus (given the bus is slow this
really can matter).  The delays around a transaction can be a significant
part of the time taken to do a transaction (so this isn't swamped by
the time taken to read 32*3*2 bytes).

There is a separate register for the number of samples in the buffer. Right
now we don't use it. On other parts this may not be present (as it
needn't ever be used. It was this case I was referring two.
I'd forgotten it existed till I checked just now.

So options to clean up this case and avoid event escalation.

1) Allow only one watershead interrupt to be configured on the device
at a time. (issue is if we ever hit a device where we can't turn them off).

2) Burn a transaction reading the buffer count then make sure we don't read
more than is there.  The events then just become a use of poll - perhaps
different flags for 50% full or 75% full if they are both enabled.

3) Handle the two watershead events in the driver, basically holding state.
Things may get fiddly if an event shows up during a read.

For simplicity of review I'm tempted to go with 1 and make the a
requirement of all drivers unless someone comes up with a very
good reason why we need this functionality.

> 
>>>> Yup, the dynamic route to creation is what I favour.  As you say
>>>> this needs fixing up before going out of staging.  We definitely
>>>> need these for a bridge to input to implement polled input devices.
>>>>
>>>> I'll put a todo in place for that element in staging so we don't
>>>> forget.
>>>
>> Note I have quite a few changes currently queued up so might be a little while
>> before I get to trying out the more complex stuff you have suggested.
> 
> Ok, no problem. Just take your time.

Thanks again for your advice. You've certainly made me think about some
areas I haven't considered for quite a while!

Jonathan

