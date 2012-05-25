Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177Ab2EYPYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 11:24:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:23485 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752745Ab2EYPYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 11:24:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="148433893"
Message-ID: <4FBFA3DD.10308@linux.intel.com>
Date: Fri, 25 May 2012 08:23:09 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "lkml, " <linux-kernel@vger.kernel.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>,
        Carmine Iascone <carmine.iascone@st.com>,
        Matteo Dameno <matteo.dameno@st.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: LIS331DLH accelerometer driver, IIO or not?
References: <4FBF0AC1.6030406@linux.intel.com> <20120525051051.GA3135@kroah.com> <4FBF387D.4020107@cam.ac.uk>
In-Reply-To: <4FBF387D.4020107@cam.ac.uk>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/25/2012 12:45 AM, Jonathan Cameron wrote:
> Added Dmitry to the cc to get input on input side of things.
>> On Thu, May 24, 2012 at 09:29:53PM -0700, Darren Hart wrote:
>>> I'm working to enable the LIS331DLH accelerometer on the Fish River
>>> Island II embedded atom development kit.
>>>
>>> http://www.st.com/internet/analog/product/218132.jsp
>>>
>>> http://us.kontron.com/products/systems+and+platforms/m2m/m2m+smart+services+developer+kit.html
>>>
>>> This device is attached to an i2c bus implemented in a CPLD (complex
>>> programmable logic device) integrated on the compute module. I found an
>>> IIO driver for the device written for 2.6.34. I've rewritten most of the
>>> driver to work with the 3.2 kernel's IIO subsystem (and had planned to
>>> next port it all the way to git HEAD and push it upstream).
>>>
>>> However, I've since stumbled across a couple of things which cloud the
>>> issue for me.
>>>
>>> First, Carmine Iascone submitted a driver (driver/misc, not iio) for the
>>> LIS331DLH back in Nov 2010.
>>>
>>> http://lkml.org/lkml/2010/11/9/369
>>>
>>> It was suggested that this driver be merged with the existing lis3lv02d
>>> driver which listed support for a similar chip in the header, LIS331DL,
>>> but it also lists LIS331DLF as not supported. The current git HEAD still
>>> does not list LIS331DLH, and there is not a compatible register map in
>>> the header.
>>>
>>> Second, I came across the following TI document for porting the
>>> LIS331DLH driver for Android:
>>>
>>> http://processors.wiki.ti.com/index.php/TI-Android-GingerBread-2.3.4-DevKit-2.1_PortingGuides
>>>
>>> This references a lis331dlh.c driver which I do not find in Linus' git
>>> repository nor in linux-next.
>>>
>>> So there are 3 ways I can go about this, and I'd appreciate any
>>> direction on which would be the most acceptable for merging upstream.
>>>
>>> 1) Continue with my IIO version. This subsystem seems well suited to the
>>> accelerometer. The iio_chan_spec simplifies the task of exposing the
>>> event capabilities of the device, which the drivers/misc/lis3lv02d
>>> driver mostly glosses over. It only supports events on free-fall for
>>> example, while with IIO it is straight forward to enable interrupts for
>>> rising and/or falling thresholds for each axis independently.
>>>
>>> 2) Attempt to merge Carmine's drivers/misc/lis331dlh driver with the
>>> existing lis3lv02d driver as suggested in the thread mentioned above.
>>> This driver isn't as fully functional.
>>>
>>> 3) Try and dig up the lis331dlh driver referenced in the TI document and
>>> work to get that upstream. Like option 2, this driver is not likely to
>>> be as configurable as the IIO driver.
>>>
>>> I am more interested in enabling people to do bizarre and interesting
>>> things with the device, so I'm leaning toward continuing with my IIO
>>> implementation.
>>
>> Make it an IIO driver and then we can delete the misc driver, which
>> shouldn't have snuck in there in the first place :)
> Agreed. That would be what I'd suggest long term,

Sure, but you're biased ;-)

Joking aside, you and Greg made my day. I was afraid I had wasted
several days grokking the 2.6.34 to 3.2 IIO subsystem changes!

 particularly when you
> refer to 'bizarre and interesting'.  There are however some missing 
> elements.  Note that none of these should stop you writing an iio
> driver particularly as the current one doesn't support your part.
> If you fancy pulling my lis3l02dq driver in as well (not sure how
> close it is though ;) then feel free!

I think I am going to start with a very simple lis331dlh only driver
which supports sysfs polling. I'm working on the interrupt and smbalert
interface currently, but I need something very soon. It would be good to
get the simple stuff right and in tree so it doesn't bitrot as I work on
the rest. Although, with the IIO core now in-tree and out of staging,
hopefully things have settled down some?

> 
> lis3lv02d driver provides (I'm sure people are more familiar with this
> than me, but it's helpful to lay it out).
> 
> /dev/freefall
> joystick emulation through input. (looks like polled only? - guessing 
> the rates for interrupt driven were too high for general use)
> Some x, y and z button inputs?
> A couple of sysfs attributes we'd probably have to support in parallel
> to new ones for compatability reasons (for a few kernel cycles anyway).
> 
> The one bit that doesn't map well at the moment is the click stuff.
> I've been trying to avoid special purpose events like that by mapping
> everything to the underlying real motion (these might be rate of
> change of acceleration thresholds, but I doubt we'll find that in the
> data sheets!) 

The data sheets are rather sparse. I'm not sure what you mean by "rate
of change of acceleration thresholds", but as the thresholds for this
device are per-interrupt (not axis nor direction) and only 6 bits (while
the axis values are s16... I'm not sure what they are, and the datasheet
makes no attempt to clarify the issue.

> Also right now we have no in kernel interface for
> getting events - will require an extra layer and a demuxer similar
> (but simpler) to the buffer one. Note as well that the buffer based
> in kernel stuff is still under review (I'll try and get a rebased 
> version out tomorrow).
> 
> So what are your bizarre and interesting then? (feel free not
> to answer, but comments like that make me curious ;)

Intel gave away vouchers for FRI2 devices to several attendees to the
2012 ELC conference this year. We asked participants to do something
cool and interesting with the device. I'm hoping some of them are more
creative than I am! So the answer to your question is "I don't know",
which is why I want to make it as configurable as possible to enable
others to be bizarre and interesting :-)

> Also any links to info on the fish river island II?
> Google is failing me and I'm curious ;)

Of course:
http://us.kontron.com/products/systems+and+platforms/m2m/m2m+smart+services+developer+kit.html

I'm developing the board support package for the Yocto Project for this
device.

http://www.yoctoproject.org/

> 
> Also, I'd almost have been inclinded to say this device should go
> in input, with a few 'additional' interfaces, but sounds like you
> want stuff input can't provide?

I think bizarre and interesting things could certainly be done with the
input system, but I'd prefer to expose the lower level features of the
chip and not dictate how the chip is used. As you say, an input wrapper
could be provided.

One of the things I'm struggling with right now are having two interrupt
lines. This device wires one to SMBALERT# and the other to a GPIO chip.
I suppose this should be addressed using a custom platform_data struct
which I haven't implemented yet. My experimental i2c bus platform init
code doesn't seem to work as expected... still working on that.

While I have you Jon, I've run into an issue with the iio_chan_spec
sysfs interface. I mark the modified bit and set IIO_MOD_X in channel2
per the iio_chan_spec comments. But, iio_device_add_event_sysfs()
ignores channel2 if chan->modified, so my event_code demuxer can't find
the modifer and can't determine which axis I'm reading or writing event
config for. I'm currently setting channel to IIO_MOD_X (or Y or Z) as a
workaround, but I think I'm missing something.

The code is a bit of a mess right now as it is the result of my slowly
rewriting it from a 2.6.34 version for 3.2 and fixing and enhancing as I
go. I will try to clean it up and get it out for an RFC soon as this is
my first real driver, I'm sure your input would be helpful.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
