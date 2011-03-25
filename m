Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058Ab1CYWrb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 18:47:31 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36483 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab1CYWra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 18:47:30 -0400
Date: Fri, 25 Mar 2011 22:47:26 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        gregkh@suse.de
Subject: Re: [RFC PATCHv3 1/4] drivers/otp: add initial support for OTP memory
Message-ID: <20110325224726.GU3130@pulham.picochip.com>
References: <1301073283-30821-1-git-send-email-jamie@jamieiles.com>
 <1301073283-30821-2-git-send-email-jamie@jamieiles.com>
 <AANLkTinLBbKaw=DwVFgORtQ=uA+zkF8QUUKj6uiqLaMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinLBbKaw=DwVFgORtQ=uA+zkF8QUUKj6uiqLaMw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Fri, Mar 25, 2011 at 05:58:05PM -0400, Mike Frysinger wrote:
> On Fri, Mar 25, 2011 at 13:14, Jamie Iles wrote:
> > --- /dev/null
> > +++ b/drivers/otp/Kconfig
> > +         may have different characterstics.  This provides a character device
> 
> characterstics -> characteristics

Doh!

> > +if OTP
> > +
> > +config WRITE_ENABLE
> > +       bool "Enable writing support of OTP pages"
> > +       default n
> > +       help
> 
> does this show correctly in the kconfig by putting this under "if otp"
> instead of "depends otp" ?  it should show the write option indented
> rather than at the same level.

I think it's OK because it's a menuconfig thing so the toplevel OTP 
thing is at the same level as misc devices and staging drivers etc.

> > +/* We'll allow OTP devices to be named otpa-otpz. */
> > +#define MAX_OTP_DEVICES                26
> 
> mmm is that still true ?

I think so - the actual devices should be otpa-otpz, but when you 
register regions they could be otpa1, otpa2, otpb1, otpb2 etc.

> 
> > +static unsigned long registered_otp_map[BITS_TO_LONGS(MAX_OTP_DEVICES)];
> > +static DEFINE_MUTEX(otp_register_mutex);
> 
> do we really need this ?  if we let the minor number dictate
> availability, then we can increment until that errors/wraps, and we
> dont need to do any tracking ...

OK, so it would be nice to get rid of this but afaict we still need to 
do some accounting of available minor numbers in the range that we've 
allocated.  We could do a simple increment % 255 for the minor number 
but if OTP devices are removed at runtime then that may get fragmented 
and we would need to do retries of device_register() which feels a bit 
too easy to mess up.

Certainly allocating one major number for OTP devices then allocating 
the minors one by one would be much better than what I have now.

We probably also want it so that if you remove the OTP device that has 
had regions called otpaN then reinsert it they doesn't suddenly become 
otpbN.

> 
> > +       if (fmt == OTP_REDUNDANCY_FMT_SINGLE_ENDED)
> > +               fmt_string = "single-ended";
> > +       else if (fmt == OTP_REDUNDANCY_FMT_REDUNDANT)
> > +               fmt_string = "redundant";
> > +       else if (fmt == OTP_REDUNDANCY_FMT_DIFFERENTIAL)
> > +               fmt_string = "differential";
> > +       else if (fmt == OTP_REDUNDANCY_FMT_DIFFERENTIAL_REDUNDANT)
> > +               fmt_string = "differential-redundant";
> > +       else if (fmt == OTP_REDUNDANCY_FMT_ECC)
> > +               fmt_string = "ecc";
> > +       else
> > +               return -EINVAL;
> 
> i wonder if the code would be simpler if we had a local static array.
> then the show/store funcs would simply walk that tree, and when you
> add a new format in the future, you only have to update one place.
> 
> static const char * const otp_redundancy_str[] = {
> 	[OTP_REDUNDANCY_FMT_SINGLE_ENDED] = "single-ended",
> 	[OTP_REDUNDANCY_FMT_REDUNDANT] = "redundant",
> 	........
> };

Yes, that would be a lot cleaner.

> > +static ssize_t otp_num_regions_show(struct device *dev,
> > +                                   struct device_attribute *attr, char *buf)
> > +{
> > +       int nr_regions;
> > +
> > +       nr_regions = otp_dev->ops->get_nr_regions(otp_dev);
> > +
> > +       if (nr_regions < 0)
> > +               return (ssize_t)nr_regions;
> 
> we could make get_nr_regions() return a ssize_t ...

OK, will do.

> 
> > +       err = alloc_chrdev_region(&otp_dev->devno, 0, max_regions, "otp");
> 
> hmm, i was thinking that we'd have 1 major for otp devices.  isnt this
> how MTD does it ?
> 
> > --- /dev/null
> > +++ b/include/linux/otp.h
> > +/**
> > + * enum otp_device_flags - Flags to indicate capabilities for the OTP device.
> > + *
> > + * @OTP_DEVICE_FNO_SUBWORD_WRITE:      only full word sized writes may be
> > + *                                     performed.  Don't use
> > + *                                     read-modify-write cycles for
> > + *                                     performing unaligned writes.
> > + */
> > +enum otp_device_flags {
> > +       OTP_DEVICE_FNO_SUBWORD_WRITE    = (1 << 0),
> > +};
> 
> use OTP_CAPS_xxx instead ?

Sounds like a plan!  Thanks again for the review!

Jamie
