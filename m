Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933549Ab1CXSd1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 14:33:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48005 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933392Ab1CXSdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 14:33:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=XCUt/yuLSou1dFpSvtfB128Pg+uJ09sUCOWi1LiIPlQ7dD1hv8pBJ5vKH08fGcpq9y
         nWV2Lkw1875kU6R5dsqUhAr0GS/2ebiwzyHxFNu0ywrxhY3KvOb/8BDB5sJIHjaRSieD
         KBbERgzbKdrFXq8IHaHKufubekXPjanrkdEjM=
MIME-Version: 1.0
In-Reply-To: <1300980071-24645-2-git-send-email-jamie@jamieiles.com>
References: <1300980071-24645-1-git-send-email-jamie@jamieiles.com> <1300980071-24645-2-git-send-email-jamie@jamieiles.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 24 Mar 2011 14:32:41 -0400
X-Google-Sender-Auth: eLow2bbTElYu6e3rb6w8jCk2oRE
Message-ID: <AANLkTinJH46U=ueUPs2bnuTp16Vtn_ViwDCrhsAGPQvM@mail.gmail.com>
Subject: Re: [RFC PATCHv2 1/4] drivers/otp: add initial support for OTP memory
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 11:21, Jamie Iles wrote:
> +What:           /sys/bus/otp/
> +Description:
> +                The otp bus presents a number of devices where each
> +               device represents a region or device in the SoC.

is it limited to OTP devices inside of SoCs ?  cant OTP devices be on
other busses like I2C or SPI ?

spurious space before "The" ...

> +Contact:        Jamie Iles <jamie@jamieiles.com>
> +Contact:       "Jamie Iles" <jamie@jamieiles.com>

sometimes you quote and sometimes you dont ... seems like quotes are
useless here

> +What:          /sys/bus/otp[a-z]/write_enable

what's with the [a-z] ?  how about using otp# like most other people
are doing now ?  [a-z] can be a bit limited/confusing ...

> +What:          /sys/bus/otp[a-z]/strict_programming
> +Description:
> +               This file indicates whether all words in a redundant format
> +               must be programmed correctly to indicate success.  Disabling
> +               this will mean that programming will be considered a success
> +               if the word can be read back correctly in it's redundant
> +               format.

i dont really grok what this is trying to say ...

"it's" -> "its"

> +What:           /sys/bus/otp/devices/otp[a-z][0-9]*/format

you have /sys/bus/otp[a-z]/ and /sys/bus/otp/devices/ ?  why not unify them ?

what are each of these subdirs trying to represent ?

> +Description:
> +                The redundancy format of the region. Valid values are:
> +                       - single-ended (1 bit of storage per data bit).
> +                       - redundant (2 bits of storage, wire-OR'd per data
> +                         bit).
> +                       - differential (2 bits of storage, differential
> +                         voltage per data bit).
> +                       - differential-redundant (4 bits of storage, combining
> +                         redundant and differential).
> +               It is possible to increase redundancy of a region but care
> +               will be needed if there is data already in the region.

where does ECC fit in ?  the Blackfin OTP is structured:
  - first 4 pages are write control bitfields for all other pages (so
blowing bit 5 of page 0 prevents further writing to page 5)
  - each 0x100 page region has 0x20 pages dedicated to ECC for the
other 0x80 pages ... this provides 1 bit error correction and 2 bits
of error detection (anymore and you're screwed!)

> --- /dev/null
> +++ b/drivers/otp/Kconfig
> @@ -0,0 +1,10 @@
> +#
> +# Character device configuration
> +#

old comment

> +menuconfig OTP
> +       bool "OTP memory support"
> +       help
> +         Say y here to support OTP memory found in some embedded devices.
> +         This memory can commonly be used to store boot code, cryptographic
> +         keys and other persistent data.

is this limited to embedded devices ?  i guess TPM keys and such are
already handled by the TPM layers ...

"y" -> "Y"

> --- /dev/null
> +++ b/drivers/otp/otp.c
> +#undef DEBUG

dead code

> +static int otp_open(struct inode *inode, struct file *filp);
> +static int otp_release(struct inode *inode, struct file *filp);
> +static ssize_t otp_write(struct file *filp, const char __user *buf,
> +                        size_t len, loff_t *offs);
> +static ssize_t otp_read(struct file *filp, char __user *buf, size_t len,
> +                       loff_t *offs);
> +static loff_t otp_llseek(struct file *filp, loff_t offs, int origin);
> +
> +static const struct file_operations otp_fops = {
> +       .owner      = THIS_MODULE,
> +       .open       = otp_open,
> +       .release    = otp_release,
> +       .write      = otp_write,
> +       .read       = otp_read,
> +       .llseek     = otp_llseek,
> +};

if you moved the fops down to where it is used, you wouldnt need the
redundant func prototypes

> +static DEFINE_SEMAPHORE(otp_sem);
> +static int otp_we, otp_strict_programming;
> +static struct otp_device *otp;
> +static dev_t otp_devno;

hrm, having these be global instead of per-device sounds like a really
bad idea ...

> +/*
> + * Given a device for one of the otpN devices, get the corresponding
> + * otp_region.
> + */
> +static inline struct otp_region *to_otp_region(struct device *dev)
> +{
> +       return dev ? container_of(dev, struct otp_region, dev) : NULL;
> +}
> +
> +static inline struct otp_device *to_otp_device(struct device *dev)
> +{
> +       return dev ? container_of(dev, struct otp_device, dev) : NULL;
> +}

do you need the NULL checks ?  none of the callers of these funcs
check for NULL ...

> +static ssize_t otp_format_show(struct device *dev,
> +                              struct device_attribute *attr, char *buf)
> +{
> +       struct otp_region *region = to_otp_region(dev);
> +       enum otp_redundancy_fmt fmt;
> +       const char *fmt_string;
> +
> +       if (down_interruptible(&otp_sem))
> +               return -ERESTARTSYS;
> +
> +       if (region->ops->get_fmt(region))
> +               fmt = region->ops->get_fmt(region);
> +       else
> +               fmt = OTP_REDUNDANCY_FMT_SINGLE_ENDED;
> +
> +       up(&otp_sem);

why are you using a semaphore when it looks like you're simply
treating it as a mutex ?  make more sense to use a proper mutex
wouldnt it ?

> +       if (OTP_REDUNDANCY_FMT_SINGLE_ENDED == fmt)
> +               fmt_string = "single-ended";
> +       else if (OTP_REDUNDANCY_FMT_REDUNDANT == fmt)
> +               fmt_string = "redundant";
> +       else if (OTP_REDUNDANCY_FMT_DIFFERENTIAL == fmt)
> +               fmt_string = "differential";
> +       else if (OTP_REDUNDANCY_FMT_DIFFERENTIAL_REDUNDANT == fmt)
> +               fmt_string = "differential-redundant";
> +       else
> +               fmt_string = NULL;
> +
> +       return fmt_string ? sprintf(buf, "%s\n", fmt_string) : -EINVAL;

i'm pretty sure printf in the kernel can handle NULL with %s, so the
NULL check can probably be punted

> +static struct bus_type otp_bus_type = {
> +       .name           = "otp",
> +};

can this be const ?

> +struct attribute *region_attrs[] = {
> +       &dev_attr_format.attr,
> +       &dev_attr_size.attr,
> +       NULL,
> +};
> +
> +const struct attribute_group region_attr_group = {
> +       .attrs          = region_attrs,
> +};
> +
> +const struct attribute_group *region_attr_groups[] = {
> +       &region_attr_group,
> +       NULL,
> +};
> +
> +struct device_type region_type = {
> +       .name           = "region",
> +       .groups         = region_attr_groups,
> +};

should these be static ?

> +/*
> + * Show the current write enable state of the OTP. Users can only program the
> + * OTP when this shows 'enabled'.
> + */
> +static ssize_t otp_we_show(struct device *dev, struct device_attribute *attr,
> +                          char *buf)
> +{
> +       int ret;

this func has a ssize_t type but you're using int here.  seems to come
up a few times in this patch.

> +/*
> + * Set the write enable state of the OTP. 'enabled' will enable programming
> + * and 'disabled' will prevent further programming from occuring. On loading

"occuring" -> "occurring"

> + * the module, this will default to 'disabled'.
> + */
> +static ssize_t otp_we_store(struct device *dev, struct device_attribute *attr,
> +                           const char *buf, size_t len)
> +{
> +       int err = 0;
> +
> +       if (down_interruptible(&otp_sem))
> +               return -ERESTARTSYS;
> +
> +       if (sysfs_streq(buf, "enabled"))
> +               otp_we = 1;
> +       else if (sysfs_streq(buf, "disabled"))
> +               otp_we = 0;
> +       else
> +               err = -EINVAL;
> +
> +       up(&otp_sem);
> +
> +       return err ?: len;
> +}
> +static DEVICE_ATTR(write_enable, S_IRUSR | S_IWUSR, otp_we_show, otp_we_store);

you output and accept "enabled" and "disabled" for multiple values.
how about unifying these ?
    return otp_attr_store_enabled(buf, len, &otp_we);

> +static ssize_t otp_num_regions_show(struct device *dev,
> +                                   struct device_attribute *attr, char *buf)
> +{
> +       int nr_regions;
> +
> +       if (down_interruptible(&otp_sem))
> +               return -ERESTARTSYS;
> +
> +       nr_regions = otp->ops->get_nr_regions(otp);
> +
> +       up(&otp_sem);
> +
> +       if (nr_regions <= 0)
> +               return -EINVAL;
> +
> +       return sprintf(buf, "%u\n", nr_regions);
> +}

i'm not sure returning -EINVAL here makes sense ... shouldnt it just
be showing the user the result of get_nr_regions() ?

> +struct attribute *otp_attrs[] = {
> +       &dev_attr_strict_programming.attr,
> +       &dev_attr_num_regions.attr,
> +       &dev_attr_write_enable.attr,
> +       NULL,
> +};
> +
> +const struct attribute_group otp_attr_group = {
> +       .attrs          = otp_attrs,
> +};
> +
> +const struct attribute_group *otp_attr_groups[] = {
> +       &otp_attr_group,
> +       NULL,
> +};
> +
> +struct device_type otp_type = {
> +       .name           = "otp",
> +       .groups         = otp_attr_groups,
> +};

static ?

> +static void otp_dev_release(struct device *dev)
> +{
> +       struct otp_device *otp = to_otp_device(dev);
> +
> +       kfree(otp);
> +       otp = NULL;
> +}

setting to NULL here is pointless when the pointer is on the stack

> +struct otp_device *otp_device_alloc(struct device *dev,
> +                                   const struct otp_device_ops *ops,
> +                                   size_t size)
> +{
> +       struct otp_device *otp_dev = NULL;
> +       int err = -EINVAL;
> +
> +       down(&otp_sem);
> +
> +       if (dev && !get_device(dev)) {
> +               err = -ENODEV;
> +               goto out;
> +       }

should you really be allowing dev==NULL ?  does that setup make sense ?

> +       if (otp) {
> +               pr_warning("an otp device already registered\n");
> +               err = -EBUSY;
> +               goto out_put;
> +       }

you can only register one OTP device in the whole system ??

> +void otp_region_unregister(struct otp_region *region)
> +{
> +       device_unregister(&region->dev);
> +}
> +EXPORT_SYMBOL_GPL(otp_region_unregister);

wonder if it'd be better to simply #define this in the global otp.h header

> +static ssize_t otp_write(struct file *filp, const char __user *buf, size_t len,
> +                        loff_t *offs)
> +{
> +       unsigned pos = (unsigned)*offs;
> +
> +       len = min(len, region->ops->get_size(region) - (unsigned)*offs);

what's with the unsigned cast ?  defeats the point of using loff_t doesnt it ?

> +       /*
> +        * We're now aligned to an 8 byte boundary so we can simply copy words
> +        * from userspace and write them into the OTP.
> +        */
> +       /*
> +        * We might have less than 8 bytes left so we'll need to do another
> +        * read-modify-write.
> +        */
> +       while (len >= OTP_WORD_SIZE) {

i think "8 byte" should be "necessary byte" ?

> +               if (region->ops->read_word(region, pos / OTP_WORD_SIZE,
> +                                          &word)) {
> +                       ret = -EIO;
> +                       goto out;
> +               }
> +
> +               if (region->ops->write_word(region, pos / OTP_WORD_SIZE,
> +                                           word)) {
> +                       ret = -EIO;
> +                       goto out;
> +               }

shouldnt you pass the ret value up from read/write word ?  this would
allow the lower layers to better describe the issue than just -EIO
wouldnt it ?

last three comments apply to the read func as well ...

> +static int __init otp_init(void)
> +{
> +       int err;
> +
> +       err = bus_register(&otp_bus_type);
> +       if (err)
> +               return err;
> +
> +       err = alloc_chrdev_region(&otp_devno, 0, 9, "otp");

where'd that magic 9 come from ?

> +MODULE_DESCRIPTION("OTP interface driver");

i think this is also a bus driver ?

> +/*
> + * The OTP works in 64 bit words. When we are programming or reading,
> + * everything is done with 64 bit word addresses.
> + */
> +#define OTP_WORD_SIZE                  8

should this be a per-device setting ?  or wait until someone who
doesnt have 64bit chunks show up ?

> + * struct otp_device - a picoxcell OTP device.
> + * otp_device_alloc - create a new picoxcell OTP device.

this is no longer picoxcell-specific

> + * otp_device_unregister - deregister an existing struct otp_device.

"deregister" -> "unregister"
-mike
