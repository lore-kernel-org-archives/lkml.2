Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235Ab1CXVi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 17:38:29 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63739 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756735Ab1CXVi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 17:38:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=K7adMBcb7b5/7B+SN3Zw1VQdYhWoMTS/UeYDEHuaaFj7XTm4P+56tqBYm+eHw+aOE5
         x+6ICQbajW/XETNG5AUpAFWV2wpc718kBnh8Cel+84yG0SljgfCEKYkewwXh6FiJM5+q
         xoDfHDR14wPL2JFnHEyZ1ROow7OFHn2MifSYI=
MIME-Version: 1.0
In-Reply-To: <20110324203523.GJ3130@pulham.picochip.com>
References: <1300980071-24645-1-git-send-email-jamie@jamieiles.com>
 <1300980071-24645-2-git-send-email-jamie@jamieiles.com> <AANLkTinJH46U=ueUPs2bnuTp16Vtn_ViwDCrhsAGPQvM@mail.gmail.com>
 <20110324203523.GJ3130@pulham.picochip.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 24 Mar 2011 17:33:25 -0400
X-Google-Sender-Auth: 359oAuv9pjCTz_RsAFvl3VUnjuE
Message-ID: <AANLkTi=pKfKeoQxB3Xb-kasfrs_aa2rqHyF9N0wR6H3z@mail.gmail.com>
Subject: Re: [RFC PATCHv2 1/4] drivers/otp: add initial support for OTP memory
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 16:35, Jamie Iles wrote:
> On Thu, Mar 24, 2011 at 02:32:41PM -0400, Mike Frysinger wrote:
>> On Thu, Mar 24, 2011 at 11:21, Jamie Iles wrote:
>> > +What:           /sys/bus/otp/devices/otp[a-z][0-9]*/format
>>
>> you have /sys/bus/otp[a-z]/ and /sys/bus/otp/devices/ ?  why not unify them ?
>>
>> what are each of these subdirs trying to represent ?
>
> They should all be in /sys/bus/otp/devices and otp[a-z] should be the
> actual otp device and otp[a-z][0-9]+ should be the regions.  I'll try
> and make that a bit clearer and maybe put an example in there.

hrm, i dont think that layout is terribly clean.  i dont think regions
from diff devices should be at the same level.  if we think of otp
regions as partitions, then we can use existing standards.

so, how about:
  /sys/bus/otp/devices/otp0/region0/
  /sys/bus/otp/devices/otp0/region1/
  /sys/bus/otp/devices/otp1/region0/
...

>> > +Description:
>> > +                The redundancy format of the region. Valid values are:
>> > +                       - single-ended (1 bit of storage per data bit).
>> > +                       - redundant (2 bits of storage, wire-OR'd per data
>> > +                         bit).
>> > +                       - differential (2 bits of storage, differential
>> > +                         voltage per data bit).
>> > +                       - differential-redundant (4 bits of storage, combining
>> > +                         redundant and differential).
>> > +               It is possible to increase redundancy of a region but care
>> > +               will be needed if there is data already in the region.
>>
>> where does ECC fit in ?  the Blackfin OTP is structured:
>>   - first 4 pages are write control bitfields for all other pages (so
>> blowing bit 5 of page 0 prevents further writing to page 5)
>>   - each 0x100 page region has 0x20 pages dedicated to ECC for the
>> other 0x80 pages ... this provides 1 bit error correction and 2 bits
>> of error detection (anymore and you're screwed!)
>
> How does the ECC correction work for bfin at the moment?  Does the user
> specify it manually when writing then check it themselves when reading
> back or does the hardware handle that?

it is taken care of by the layers below the Linux driver.  when we say
"read a half page", the 64bits are returned via pointer args, and the
function return value will tell us if the contents read are valid (ECC
passed), corrected (1 bit error), or there was a read error (too may
bit errors to recover).

> The way I was thinking that this sort of thing could be handled would be
> for the ECC to be transparent to the user.  Perhaps for bfin the OTP
> could be registered as 4 regions, otpa1-otpa4 which default to
> "single-ended".  Writing "ecc" as the format would generate the ecc and
> program it for that region then check the ECC when reading back.

reads and writes atm always have ECC enabled, and the driver restricts
writes to the full half page (64bits).  if you wanted to be crafty,
you could blow individual bits in a single half page over multiple
writes before writing out the final ECC, but that isnt supported, and
no one has complained.

>> > +static DEFINE_SEMAPHORE(otp_sem);
>> > +static int otp_we, otp_strict_programming;
>> > +static struct otp_device *otp;
>> > +static dev_t otp_devno;
>>
>> hrm, having these be global instead of per-device sounds like a really
>> bad idea ...
>
> So at the moment the only devices I'm aware of have a single OTP device
> so I figured the most important thing was to make sure that the sysfs
> and device node naming permitted for multiple OTP devices in the future
> without ABI breakage.  Having said that, these probably could be moved
> into the otp_device though so I'll have a go at that.

the ABI step is probably one of the most important pieces, but i dont
think moving these fields into the otp_device structure would take
long.

>> > +static inline struct otp_region *to_otp_region(struct device *dev)
>> > +{
>> > +       return dev ? container_of(dev, struct otp_region, dev) : NULL;
>> > +}
>> > +
>> > +static inline struct otp_device *to_otp_device(struct device *dev)
>> > +{
>> > +       return dev ? container_of(dev, struct otp_device, dev) : NULL;
>> > +}
>>
>> do you need the NULL checks ?  none of the callers of these funcs
>> check for NULL ...
>
> I think so, because at least that way if something does go wrong and you
> dereference the NULL later you should get a nice backtrace, but if you
> don't do the check then you could have container_of() yielding something
> like "NULL - 0x4" giving a potentially valid address.  If that's the
> wrong thing to do then I'm happy to change though.

ok, but the callers immediately dereference the return of this without
checking NULL, so i dont see the crash output being all that
different.  and if people are mapping the low page (by manually
tweaking mmap_min_addr), then this func wont really make a difference
...

so yes, i'd still say punt it.  there's no valid reason for a NULL dev
to be seen this low down.

>> > +static struct bus_type otp_bus_type = {
>> > +       .name           = "otp",
>> > +};
>>
>> can this be const ?
>
> No, I don't think so; bus_register() doesn't want a const bus_type.

stupid bus_register() needs updating then.  i certainly wont ask you
to do that though :).

>> > +static ssize_t otp_num_regions_show(struct device *dev,
>> > +                                   struct device_attribute *attr, char *buf)
>> > +{
>> > +       int nr_regions;
>> > +
>> > +       if (down_interruptible(&otp_sem))
>> > +               return -ERESTARTSYS;
>> > +
>> > +       nr_regions = otp->ops->get_nr_regions(otp);
>> > +
>> > +       up(&otp_sem);
>> > +
>> > +       if (nr_regions <= 0)
>> > +               return -EINVAL;
>> > +
>> > +       return sprintf(buf, "%u\n", nr_regions);
>> > +}
>>
>> i'm not sure returning -EINVAL here makes sense ... shouldnt it just
>> be showing the user the result of get_nr_regions() ?
>
> I guess so, but in that case we're saying that get_nr_regions()
> shouldn't fail in which case the return type for get_nr_regions() should
> probably be unsigned.

i'm ok with it returning an error if nr_regions is negative, but i
think 0 should be a valid value to show to userspace.

>> > +struct otp_device *otp_device_alloc(struct device *dev,
>> > +                                   const struct otp_device_ops *ops,
>> > +                                   size_t size)
>> > +{
>> > +       struct otp_device *otp_dev = NULL;
>> > +       int err = -EINVAL;
>> > +
>> > +       down(&otp_sem);
>> > +
>> > +       if (dev && !get_device(dev)) {
>> > +               err = -ENODEV;
>> > +               goto out;
>> > +       }
>>
>> should you really be allowing dev==NULL ?  does that setup make sense ?
>
> Originally I didn't have that but when I added the bfin driver this
> doesn't use a device structure so I made this change.  Perhaps the right
> approach is to require a parent device and make the bfin driver use a
> platform device?

i'm OK with that

>> > +static int __init otp_init(void)
>> > +{
>> > +       int err;
>> > +
>> > +       err = bus_register(&otp_bus_type);
>> > +       if (err)
>> > +               return err;
>> > +
>> > +       err = alloc_chrdev_region(&otp_devno, 0, 9, "otp");
>>
>> where'd that magic 9 come from ?
>
> Ok, that's not nice.  I'm not sure how to best handle this, perhaps
> register a chrdev region when allocating the initial otp device and have
> the backend specify the maximum number of regions?

i dont think there's an issue with dynamically allocating an entire
major # for yourself.  there's plenty available.

>> > +/*
>> > + * The OTP works in 64 bit words. When we are programming or reading,
>> > + * everything is done with 64 bit word addresses.
>> > + */
>> > +#define OTP_WORD_SIZE                  8
>>
>> should this be a per-device setting ?  or wait until someone who
>> doesnt have 64bit chunks show up ?
>
> I guess it probably should to be generic but then the read_word() and
> write_word() wrappers need to do some masking and shifting and I figured
> as it was something I couldn't test it I shouldn't do it.  Perhaps make
> this a per device setting and have a runtime check that only supports 64
> bit words for now?

using constants also lets gcc do nice optimizations where it otherwise
might need to call math funcs to do mult/div/etc... operations.  so
for now, simply adding an if() check to the register point and
returning -ENOSUP when the size isnt 8 bytes is OK.  Blackfin OTP min
transfer size is 64bits :).
-mike
