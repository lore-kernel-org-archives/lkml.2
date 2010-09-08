Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599Ab0IHLcj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 07:32:39 -0400
Received: from ppsw-33.csi.cam.ac.uk ([131.111.8.133]:39347 "EHLO
	ppsw-33.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab0IHLch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 07:32:37 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4C877584.7000902@jic23.retrosnub.co.uk>
Date: Wed, 08 Sep 2010 12:37:40 +0100
From: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100830 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Hemanth V <hemanthv@ti.com>
CC: linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH V3 1/2] input: CMA3000 Accelerometer driver
References: <61033.10.24.255.18.1283926671.squirrel@dbdmail.itg.ti.com>
In-Reply-To: <61033.10.24.255.18.1283926671.squirrel@dbdmail.itg.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hemanth,

I know this is rather late in the process, but I thought I'd just like
to make a few suggestions in for possibly clearer interfaces (sysfs) -
platform data is fine as is because a board designer can look up the 
data sheet or documentation.

I'm not particularly bothered if you do anything about these now, it's
just that they may be worth considering in future (we can support the
current ones as well).  Oddly enough I've run into lots of issues with
trying to come up with generic names for various sysfs parameters as
part of IIO design work (some things you have here we still haven't
pinned down).

...
> +
> +Sysfs entries
> +-------------
> +
> +mode:
> +	0: power down mode
> +	1: 100 Hz Measurement mode
> +	2: 400 Hz Measurement mode
> +	3: 40 Hz Measurement mode
> +	4: Motion Detect mode (default)
> +	5: 100 Hz Free fall mode
> +	6: 40 Hz Free fall mode
> +	7: Power off mode
Could break this internal parameter up into a couple of attributes to make
it easier to understand (and get rid of the magic numbers.  The brackets
are used to indicate what mode we are currently in.

mode: 
	powerdown [measurement] motiondetect freefall poweroff
frequency:
	400 [100] 40

 (prevent it changing to 400 if we are in free fall mode or even better don't
  list it as an option. - if people want to configure motion detection, they may
   have to elect to power down first make relevant settings and power up again)

Yes there are nasty corner cases with this approach, but it does get rid of the
magic numbers in the original interface.

> +
> +grange:
> +	2000: 2000 mg or 2G Range
> +	8000: 8000 mg or 8G Range
> +
> +mdthr:
> +	X: X * 71mg (8G Range)
> +	X: X * 18mg (2G Range)
Sometimes saving characters in a name is a bad idea.
motion_detector_threshold would make things clearer.
I'd also personally loose the magic multipliers and make
it in milli g like your grange above.  Obviously things
will get a little fiddly if the grange changes.
> +
> +mdfftmr:
> +	X: (X & 0x70) * 100 ms (MDTMR)
> +	   (X & 0x0F) * 2.5 ms (FFTMR 400 Hz)
> +	   (X & 0x0F) * 10 ms  (FFTMR 100 Hz)
detector_period or something like that and again it would be
much nicer to have this in say milliseconds.  Again you'd probably
need an in driver cache and to update things appropriately if the
frequency is changed.  I have no idea if this interpreted the same
for freefall and motion detection.  If it isn't make it two separate
attributes to reduce confusion.  (with appropriate caching in driver
to ensure the right one is written before a mode change).
> +
> +ffthr:
> +       X: (X >> 2) * 18mg (2G Range)
> +       X: (X & 0x0F) * 71 mg (8G Range)
Again, this would be better in milli g.  

...

Just some suggestions.

I still think the driver is more or less fine as is, but if Dmitry is going
to take more accelerometer drivers some of these interfaces will want to be
more easily generalized. 

Naturally I'm biased and think what we have for IIO is the one true way :)
Note that we have to cover a much wider range of devices so some of our choices
are more complex / involved than may be needed for a narrow set of devices.
Note the event naming is currently in flux (as few of our drivers have supported
these elements we have be concentrating on other parts). I'll be proposing a clearer scheme
shortly (including the mag variant given here). In that case you would have.

grange->accel_calibscale + accel_calibscale_available (to tell you what is valid).
(there is some debate on whether to use the list approach I suggested above for a 
restricted case like this).

mdthr->accel_mag_rising_value

ffthr-> free_fall_value? (we don't have this one yet - would need to think about this,
        it might correspond to accel_mag_falling_value)

mdfftmr-> accel_mag_rising_period, free_fall_period
 
mode would be effectively covered by whether the following are enabled (and enabling
one will disable the other).
accel_mag_rising_en
free_fall_en
sampling_frequency
(with sampling_frequency_available)

The power down and power off modes are device specific - either runtime power management,
or a non standard attribute.

This may all seem overly complex, but it does give us an interface we can generalize
to pretty much any similar device in a consistent manor (so far!)

I'm happy to see your driver go in as it is currently, what bothers me is that we will end
up with incompatible interfaces for all the accelerometers Dmitry takes!

Jonathan
