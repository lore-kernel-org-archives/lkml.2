Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379Ab0IFOMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 10:12:55 -0400
Received: from ppsw-32.csi.cam.ac.uk ([131.111.8.132]:33830 "EHLO
	ppsw-32.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab0IFOMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 10:12:48 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4C84F80C.2050702@cam.ac.uk>
Date: Mon, 06 Sep 2010 15:17:48 +0100
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
References: <4C84A93B.2050507@iis.fraunhofer.de>	<4C84E64D.4040600@jic23.retrosnub.co.uk> <20100906143256.6b49825d@lxorguk.ukuu.org.uk>
In-Reply-To: <20100906143256.6b49825d@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

>>> Do we want to resemble the 'milli' units or should we stick to
>>> standard SI units (radians, kelvin, etc.) as floating point math is
>>> necessary anyway.
>> I've cc'd a few people who have contributed to previous abi discussions
>> for IIO in ways that make me think they may have opinions on this.
> 
> FP isn't needed you can let the drivers do fixed point quite happily -
> the Intel compass driver intentionally does this.
True.
> 
> Using milli is asking for problems. There are lots of units where "milli"
> is actually quite big (millifarad, millihenry) and others where its
> stupendously small (eV for example). It works for hwmon because hwmon
> covers such a narrow range of devices and units.
Agreed, but as has been suggested before, we want to minimize the number
of interfaces in kernel.  I have no issue at all in using SI units for
things that haven't turned up before (and IIO does).  For the processed
inputs (like your compass driver or light sensors with nasty conversion
functions) we have _input parameters as per hwmon.  Given it was their
interface first we want to keep to their units where they apply.
The question Manuel was raising is do we extend this (for consistency)
to the _raw and _scale combination (as per your option 2).
> 
> So I'd favour FP because I think there are three choices
> 
> 1.	Encode the value, define the scaling factor in the ABI (not
> 	future proof)
> 
> 2.	Encode the value and scaling factor as two fields in the ABI
> 	(more future proof)
That's what we are currently doing.  Mainly for exactly the reason
you suggest below.  We want to use the same logic for the buffered
and direct (e.g. sysfs attribute) reads. Basically we need to export
the scale factor anyway so why not use it for both and keep the driver
as simple as possible.  Userspace can almost always just cache the scale
value anyway (it won't change in any current device unless userspace
tells it to do so).  I guess we might have an autoranging device to
deal with in the future.  Perhaps we just mandate that such a device
gives _input style outputs.  For buffer route on that it is going to
require an extension to the interface anyway.
> 
> 3.	As 2 but use the normal encoding for this which involves
> 	putting a "." in the right place and using one field (ie FP)
> 
> Drivers are simply going to end up doing this with sysfs values
> 
> 	snprintf(buf, sizeof(buf), "%d.%02d", v/100, v%100);
> 
> or similar - or in many cases
> 
> 	snprintf(buf, sizeof(buf), "%d0000000000", v);
> 
> neither of which is a big cost.
> 
> For a ring buffer you probably need to encode the scaling factor and
> field width in some sort of interface description query and the values in
> the bitstream.
Agreed.  Bitstream doesn't change format (without userspace telling it to
do so), hence sysfs attrs are perfect for doing this.
> 
> Which raises an interesting question. The natural way to deal with sysfs
> is decimal fixed point internally. If drivers are going to do both
> sysfs and rings then really you want to be able to encode powers of 10
> shifts not just bitshifts.
I'm afraid I have lost you here.  Why restrict to powers of 10?  The buffered
route is going to ship whatever the chip actually produces. We don't want to
touch them at all in kernel.  The scale factor could then be pretty much anything.
Typically for sysfs route we don't care how much we have to do to the data
so we could do your option 3, but given it is trivial for userspace to deal
with option 2 I'm more inclined to keep things consistent across the two interfaces
and go with that.

Thanks,

Jonathan


