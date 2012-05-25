Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab2EYHpJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 03:45:09 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:52623 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab2EYHpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 03:45:07 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4FBF387D.4020107@cam.ac.uk>
Date: Fri, 25 May 2012 08:45:01 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Darren Hart <dvhart@linux.intel.com>,
        "lkml, " <linux-kernel@vger.kernel.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>,
        Carmine Iascone <carmine.iascone@st.com>,
        Matteo Dameno <matteo.dameno@st.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: LIS331DLH accelerometer driver, IIO or not?
References: <4FBF0AC1.6030406@linux.intel.com> <20120525051051.GA3135@kroah.com>
In-Reply-To: <20120525051051.GA3135@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added Dmitry to the cc to get input on input side of things.
> On Thu, May 24, 2012 at 09:29:53PM -0700, Darren Hart wrote:
>> I'm working to enable the LIS331DLH accelerometer on the Fish River
>> Island II embedded atom development kit.
>>
>> http://www.st.com/internet/analog/product/218132.jsp
>>
>> http://us.kontron.com/products/systems+and+platforms/m2m/m2m+smart+services+developer+kit.html
>>
>> This device is attached to an i2c bus implemented in a CPLD (complex
>> programmable logic device) integrated on the compute module. I found an
>> IIO driver for the device written for 2.6.34. I've rewritten most of the
>> driver to work with the 3.2 kernel's IIO subsystem (and had planned to
>> next port it all the way to git HEAD and push it upstream).
>>
>> However, I've since stumbled across a couple of things which cloud the
>> issue for me.
>>
>> First, Carmine Iascone submitted a driver (driver/misc, not iio) for the
>> LIS331DLH back in Nov 2010.
>>
>> http://lkml.org/lkml/2010/11/9/369
>>
>> It was suggested that this driver be merged with the existing lis3lv02d
>> driver which listed support for a similar chip in the header, LIS331DL,
>> but it also lists LIS331DLF as not supported. The current git HEAD still
>> does not list LIS331DLH, and there is not a compatible register map in
>> the header.
>>
>> Second, I came across the following TI document for porting the
>> LIS331DLH driver for Android:
>>
>> http://processors.wiki.ti.com/index.php/TI-Android-GingerBread-2.3.4-DevKit-2.1_PortingGuides
>>
>> This references a lis331dlh.c driver which I do not find in Linus' git
>> repository nor in linux-next.
>>
>> So there are 3 ways I can go about this, and I'd appreciate any
>> direction on which would be the most acceptable for merging upstream.
>>
>> 1) Continue with my IIO version. This subsystem seems well suited to the
>> accelerometer. The iio_chan_spec simplifies the task of exposing the
>> event capabilities of the device, which the drivers/misc/lis3lv02d
>> driver mostly glosses over. It only supports events on free-fall for
>> example, while with IIO it is straight forward to enable interrupts for
>> rising and/or falling thresholds for each axis independently.
>>
>> 2) Attempt to merge Carmine's drivers/misc/lis331dlh driver with the
>> existing lis3lv02d driver as suggested in the thread mentioned above.
>> This driver isn't as fully functional.
>>
>> 3) Try and dig up the lis331dlh driver referenced in the TI document and
>> work to get that upstream. Like option 2, this driver is not likely to
>> be as configurable as the IIO driver.
>>
>> I am more interested in enabling people to do bizarre and interesting
>> things with the device, so I'm leaning toward continuing with my IIO
>> implementation.
>
> Make it an IIO driver and then we can delete the misc driver, which
> shouldn't have snuck in there in the first place :)
Agreed. That would be what I'd suggest long term, particularly when you
refer to 'bizarre and interesting'.  There are however some missing 
elements.  Note that none of these should stop you writing an iio
driver particularly as the current one doesn't support your part.
If you fancy pulling my lis3l02dq driver in as well (not sure how
close it is though ;) then feel free!

lis3lv02d driver provides (I'm sure people are more familiar with this
than me, but it's helpful to lay it out).

/dev/freefall
joystick emulation through input. (looks like polled only? - guessing 
the rates for interrupt driven were too high for general use)
Some x, y and z button inputs?
A couple of sysfs attributes we'd probably have to support in parallel
to new ones for compatability reasons (for a few kernel cycles anyway).

The one bit that doesn't map well at the moment is the click stuff.
I've been trying to avoid special purpose events like that by mapping
everything to the underlying real motion (these might be rate of
change of acceleration thresholds, but I doubt we'll find that in the
data sheets!)  Also right now we have no in kernel interface for
getting events - will require an extra layer and a demuxer similar
(but simpler) to the buffer one. Note as well that the buffer based
in kernel stuff is still under review (I'll try and get a rebased 
version out tomorrow).

So what are your bizarre and interesting then? (feel free not
to answer, but comments like that make me curious ;)
Also any links to info on the fish river island II?
Google is failing me and I'm curious ;)

Also, I'd almost have been inclinded to say this device should go
in input, with a few 'additional' interfaces, but sounds like you
want stuff input can't provide?

>
> greg k-h

