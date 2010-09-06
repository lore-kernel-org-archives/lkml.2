Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab0IFO62 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 10:58:28 -0400
Received: from ppsw-33.csi.cam.ac.uk ([131.111.8.133]:37264 "EHLO
	ppsw-33.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab0IFO6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 10:58:23 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4C8502BB.4070509@cam.ac.uk>
Date: Mon, 06 Sep 2010 16:03:23 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100830 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Jean Delvare <khali@linux-fr.org>, Greg KH <greg@kroah.com>,
        Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [IIO] Proposal for sysfs attributes
References: <4C84A93B.2050507@iis.fraunhofer.de>	<4C84E64D.4040600@jic23.retrosnub.co.uk>	<20100906143256.6b49825d@lxorguk.ukuu.org.uk>	<4C84F80C.2050702@cam.ac.uk> <20100906154800.53522fc7@lxorguk.ukuu.org.uk>
In-Reply-To: <20100906154800.53522fc7@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,
>> I'm afraid I have lost you here.  Why restrict to powers of 10?  The buffered
>> route is going to ship whatever the chip actually produces.
> 
> Then I don't see the point of IIO over a million random misc API's of the
> week. Giving 50,000 interfaces the same name doesn't actually achieve
> anything or solve any real problems.
> 
> The job of the OS is to provide an *abstraction*. If IIO won't do that I
> don't see the point of IIO.
Sorry, I think we are talking at cross purposes here. IIO does provide an abstraction.
Otherwise as you say it would be pointless.

The values in the buffer are raw data off the chip. It tends to be already in the most
compact form and we guarantee no loss of accuracy this way.  How accurate you make
further processing is in the hands of the userspace code.

The abstraction comes in combination with the sysfs attributes that describe
what that format raw format is and tell userspace how to convert it to a standard
format. The combination of the two (and a suitable userspace library, perhaps provided
by us, perhaps by someone else), give you the nice consistent interface you desire.
Manuel is working on such a library and hence has been finding all the inconsistencies
and missing information in the current abi.

The second question Manuel raised was about exactly how we describe this data stream.
The current abi has proven cumbersome and hasn't covered all cases, so he was seeking
to propose a slight adjustment to fix this.

For sysfs attributes, (accel_x_raw + accel_x_offset) * accel_x_scale will always give
you a value in m/s^2.  accel_x_input is also in m/s^2 if that is provided instead.
With accelerometers and many other sensor, accel_x_offset is often 0 and hence we
don't bother providing it.  The offset and scale are fixed values unless userspace
has intervened to change them (e.g. in multirange sensors).  Thus they need only be
read once at start up.  If it proves necessary we can use the sysfs select stuff
to allow userspace to be notified of a change caused by other userspace code.

With the buffer and Manuel's proposal:  The data corresponding to accel_x_raw is
extracted in binary form using the type attributes (of it and all previous elements
in the capture).  This can then be converted in exactly the same way as the above
sysfs approach.  Hence my favouring of what I understood by your option 2.
If what you are interested in doing is brute force logging, or an algorithm that
can be performed in the raw data space, then you don't want to do this conversion at all.
The cost of converting this data may seem minor to you, but take into account that
some of the devices within the scope of IIO produce a 'lot' of data.

Obviously we are currently limiting the _raw approach to devices with linear conversions
to SI units. What we do about high speed devices with more complex conversion functions
is still and open question.  Right now no one has suggested adding any.  We'll deal
with that when it becomes relevant.

> 
> The current situation is
> 
> 	Random gadget added with own API
> 	Qt sensors module is written for said gadget
> 
> IIO is offering no improvement if it won't abstract in a controlled
> fashion.
I agree that would be the case, but the whole point is to provide this
abstraction!

Jonathan


