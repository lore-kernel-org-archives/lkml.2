Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186Ab1FQIgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 04:36:21 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:33462 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756825Ab1FQIgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 04:36:10 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4DFB13E1.5050908@cam.ac.uk>
Date: Fri, 17 Jun 2011 09:44:17 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Bryan Freed <bfreed@chromium.org>
CC: linux-kernel@vger.kernel.org, Jon Brenner <jbrenner@taosinc.com>,
        gregkh@suse.de, arnd@arndb.de,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Amit Kucheria <amit.kucheria@verdurent.com>
Subject: Re: [PATCH 1/2] light sensor: Add a calibration file to the isl29018
 driver.
References: <1307737580-14131-1-git-send-email-bfreed@chromium.org>	<4DF5D0DC.5090205@cam.ac.uk>	<BANLkTinPg158f7A7BSZ7v=M3QecZ-1HYLujq5sOjDa32oVDCkg@mail.gmail.com>	<4DF9C853.80305@cam.ac.uk> <BANLkTikJ++PDyW2q6H0OiWVuGRgGqzCPg=0giBxEANgHO_n-0Q@mail.gmail.com>
In-Reply-To: <BANLkTikJ++PDyW2q6H0OiWVuGRgGqzCPg=0giBxEANgHO_n-0Q@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/11 01:17, Bryan Freed wrote:
> Comments inline...
> Again, thanks for the response.
> 
> On Thu, Jun 16, 2011 at 2:09 AM, Jonathan Cameron <jic23@cam.ac.uk <mailto:jic23@cam.ac.uk>> wrote:
> 
>     On 06/16/11 00:49, Bryan Freed wrote:
>     > Hi Jon.  Thanks for the feedback.
>     >
>     > So I took a look at sysfs-bus-iio documentation.
>     > *_calibscale is supposed to be "Hardware applied calibration scale factor."
>     > But what I want is software applied calibration scaling.
>     Yes an no.  That description could do with expanding.  What it really means is
>     a factor applied somewhere before the reading being available to userspace.
>     On most devices this indeed in hardware.  With the light sensors as you have
>     observed it serves much the same role but is applied in software.  Still
>     userspace doesn't care where it occurs, just that it can in theory fiddle
>     with it.
> 
> 
> Cool.  I think I see that now.
>  
> 
>     >
>     > tsl2563 provides this with (apparently undocumented) intensity0_both_calibgain,
>     oops.  That was an ancient form of naming. Needs updating to current abi.
> 
>     > and tsl2583 provides this (incorrectly, according to documentation) with illuminance0_calibbias.
>     Indeed. I'm waiting for Jon to have time to take a look at that (and fix it ;)  Sorry, that one
>     slipped past me when I reviewed the driver.
>     >
>     > As for the iio_chan_spec interface, we are a bit behind you guys in
>     > source drops. We are at 2.6.38, and that appears to be added in
>     > 2.6.39 just before the switch to 3.0.
>     Yup, it went in during the most recent merge window.  If you have to work with
>     2.6.38 I suggest lifting some of the code form the core and putting it in the
>     driver to interpret a fixed point decimal input for calibscale.  It'll need
>     a few minor changes as you move forward (and there will be major code reductions
>     if you do move to newer interfaces, but there is no requirement to do so).
> 
> 

> Ok, I see the effect of the interface change now. Sysfs filenames no
> longer come from the individual iio drivers with IIO_DEVICE_ATTR()
> and DEVICE_ATTR() calls that specify separate set and show functions.
> Now they come from the
> industrialio-core.c:iio_chan_type_name_spec_shared basic names as
> selected by the type field of each iio_chan_spec entry provided by a
> driver, and they are updated by the channel, modified, and channel2
> fields in __iio_build_postfix() and __iio_device_attr_init(). And the
> read/write call now goes through iio_read/write_channel_info() to the
> driver's combined read/write_raw() function instead of an attribute
> specific show/set function.
Yup.
>     > I have not found what you mean by pseudo floating point.  Still working on it.
>     For reading and writing values are passed in two ints.  val and val2 (iirc).
>     There is also a type specification.  For reading from devices this is returned by
>     read_raw callback, for writing it can be queried (if no callback is supplied then
>     it assumed to be int for _raw attributes and int + micro for everything else.
> 
> 
> Ok, I see the pseudo floating point stuff now.  Thanks.
> 
> 
>     Michael added a IIO_VAL_INT_PLUS_NANO version as he had a 24bit adc that required a
>     very small value for in_scale.
> 
> 
> Uhh...  I do not think I need that level of granularity.
>  
> 
> 
>     We have had some discussions about extending this further, but have left that for
>     when we actually have a user.  Right now you can have:
> 
>     IIO_VAL_INT, IIO_VAL_INT_PLUS_MICRO and IIO_VAL_INT_PLUS_NANO.
>     > For Mike's changes, are you referring to 8a27a023f8f66a8361c5e3d8160a690f480479ec in particular?  He has quite a few in there.
>     Greg KH hasn't picked it up yet (I think Michael has sent it on).
>     On mailing list, patches in question are:
> 
>     http://marc.info/?l=linux-iio&m=130734563905574&w=2 <http://marc.info/?l=linux-iio&m=130734563905574&w=2> (for the read raw)
>     http://marc.info/?l=linux-iio&m=130754290631769&w=2 <http://marc.info/?l=linux-iio&m=130754290631769&w=2> (for the write raw and fmt querying callback)
> 
> 
>     >
>     > I see tsl2563 has been updated to use iio_chan_spec.  But the software gain is still provided by the old intensity0_both_calibgain file.
>     Really? Chanspec is:
> 
> 
> My mistake.
> The variables are all still there, and the math is the same.
> But the filename is no longer provided by the driver.  It comes from iio.
Yup. Results in a substantial reduction in boilerplate code and in theory
enforces abi matching rather better.

>     static const struct iio_chan_spec tsl2563_channels[] = {
>            IIO_CHAN(IIO_LIGHT, 0, 1, 1, NULL, 0, 0, 0, 0, 0, {}, 0),
>            IIO_CHAN(IIO_INTENSITY, 1, 1, 0, "both", 0,
>                     (1 << IIO_CHAN_INFO_CALIBSCALE_SEPARATE), 0, 0, 0, {},
>                     IIO_EV_BIT(IIO_EV_TYPE_THRESH, IIO_EV_DIR_RISING) |
>                     IIO_EV_BIT(IIO_EV_TYPE_THRESH, IIO_EV_DIR_FALLING)),
>            IIO_CHAN(IIO_INTENSITY, 1, 1, 0, "ir", 1,
>                     (1 << IIO_CHAN_INFO_CALIBSCALE_SEPARATE), 0, 0, 0, {},
>                     0)
>     };
> 
>     The both bit is referring to the light spectrum (that sensor has a ir + visible sensor and an ir only one).
>     ir should indeed be infrared. Don't think this driver has a huge number of users so probably
>     can fix that up quickly (Jon, Amit, do you guys know anyone who would be effected by that?)
>     We changed the threshold control naming recently anyway and no one has shouted about it yet!
> 
>     We don't actually have the equivalent of 'both' in the documentation. The only reason
>     we have this readable form userspace is that thresholding on that part is done on the
>     underlying value of this adc.  If someone cares to move the gain control into the driver
>     then I'd be happy to see this go (as long as no one is using the threshold events for anything
>     else.)  We could probably come up with a better naming convention it not.
> 
>     > Should we be moving away from this interface?
>     Yes to calibgain. That should be long gone.  For a while we accidentally had both calibscale
>     and calibgain in the tree so we eventually went with one and in theory standardized on it.
>     Just took a while to propagate through (grep tells me there are no users left now).
> 
> 
> Ok, I have a good idea what to do.
> By the way, I am not a big fan of the IIO_CHAN() macros passing 12 parameters.  It is hard to follow and prone to errors.
> In looking at the tsl2563 IIO_INTENSITY channels, it looks like the mask is passed incorrectly at parameter 7 (_chan2) instead of parameter 8 (_inf_mask).
> I will fix that if I can verify it, though I see the write_raw function does not check the mask.  Hmm...
For once I actually have a part for this driver, so I'll test it if you want to make changes.  write_raw
should indeed be in general checking the mask, but in this particularly case it doesn't actually matter
as all the information parameters have the same mask anyway.  Better to clean this up now than have
it bite someone in the future though (particularly as this sort of code tends to get cut and pasted!)

On this note, it is perfectly acceptable to assign the elements of the chan_spec structure as:

static const struct iio_chan_spec tsl2563_channels[] = {
	{
		.type = IIO_LIGHT,
		.indexed = 1,
		.processed_val = 1,
		.channel = 0,
	}, {
		.type = IIO_INTENSITY,
		.modified = 1,
		.indexed = 1,
		.channel = 0,
		.extend_name = "both",
		.info_mask = (1 << IIO_CHAN_INFO_CALIBSCALE_SEPARATE),
		.event_mask = IIO_EV_BIT(IIO_EV_TYPE_THRESH, IIO_EV_DIR_RISING) |
			      IIO_EV_BIT(IIO_EV_TYPE_THRESH, IIO_EV_DIR_FALLING)
	}, {
		.type = IIO_INTENSITY,
		.modified = 1,
		.indexed = 1,
		.channel = 1,
		.extend_name = "infrared",
		.info_mask = (1 << IIO_CHAN_INFO_CALIBSCALE_SEPARATE),
		.event_mask = IIO_EV_BIT(IIO_EV_TYPE_THRESH, IIO_EV_DIR_RISING) |
			      IIO_EV_BIT(IIO_EV_TYPE_THRESH, IIO_EV_DIR_FALLING)
	}
};

The macro is just a convenient shortcut...
> 
> And the IIO_INTENSITY channels are still normalized at 1000 (the default calib0 value) instead of 1.000000.  Do you think I should fix that, as well?
Hmm. This one is an odd one, because it really doesn't correspond to a true 'scaling'.
The value is only useful as part of the calculation to illuminance0_input.

Were this device to output illuminance0_raw then we would expect that scale to be such that
doubling it would result in the _raw output being double.  In the case of light sensors, the
hideously non linear transform pretty much wrecks this.  Hence, though the base of 1000 is
'unusual' it isn't really a problem.

(conceptually, if the conversion was linear and we were exporting the value via illuminance0_raw
then have illuminance0_scale applied in userspace and that can reverse the effect of any random
scaling occuring 'on chip' - anywhere before userspace sees it a value.  

Thanks for looking at this stuff and good catch on that bug!

Jonathan
