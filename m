Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab1CYV61 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 17:58:27 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:51382 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148Ab1CYV6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 17:58:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=az+b7No8iAW5B6f+vdb5KS3M9Nc2rUvn0ZBWeMQGQvey/PRiRb3AbmFXBneJlRTuRq
         UEo8x8zCvK+TzO8SC5GgtiCyg/4MpYratBRr5JZFgL6GainDlBh8ibfBA+Hoe5uG1nmw
         S8UAYHvGLD6ahFSYx4hAPJZ98i6nsO6pQ79io=
MIME-Version: 1.0
In-Reply-To: <1301073283-30821-2-git-send-email-jamie@jamieiles.com>
References: <1301073283-30821-1-git-send-email-jamie@jamieiles.com> <1301073283-30821-2-git-send-email-jamie@jamieiles.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Fri, 25 Mar 2011 17:58:05 -0400
X-Google-Sender-Auth: 7S0nKFmw9Evrug6tTZiEshgGoqo
Message-ID: <AANLkTinLBbKaw=DwVFgORtQ=uA+zkF8QUUKj6uiqLaMw@mail.gmail.com>
Subject: Re: [RFC PATCHv3 1/4] drivers/otp: add initial support for OTP memory
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 13:14, Jamie Iles wrote:
> --- /dev/null
> +++ b/drivers/otp/Kconfig
> +         may have different characterstics.  This provides a character device

characterstics -> characteristics

> +if OTP
> +
> +config WRITE_ENABLE
> +       bool "Enable writing support of OTP pages"
> +       default n
> +       help

does this show correctly in the kconfig by putting this under "if otp"
instead of "depends otp" ?  it should show the write option indented
rather than at the same level.

> +/* We'll allow OTP devices to be named otpa-otpz. */
> +#define MAX_OTP_DEVICES                26

mmm is that still true ?

> +static unsigned long registered_otp_map[BITS_TO_LONGS(MAX_OTP_DEVICES)];
> +static DEFINE_MUTEX(otp_register_mutex);

do we really need this ?  if we let the minor number dictate
availability, then we can increment until that errors/wraps, and we
dont need to do any tracking ...

> +       if (fmt == OTP_REDUNDANCY_FMT_SINGLE_ENDED)
> +               fmt_string = "single-ended";
> +       else if (fmt == OTP_REDUNDANCY_FMT_REDUNDANT)
> +               fmt_string = "redundant";
> +       else if (fmt == OTP_REDUNDANCY_FMT_DIFFERENTIAL)
> +               fmt_string = "differential";
> +       else if (fmt == OTP_REDUNDANCY_FMT_DIFFERENTIAL_REDUNDANT)
> +               fmt_string = "differential-redundant";
> +       else if (fmt == OTP_REDUNDANCY_FMT_ECC)
> +               fmt_string = "ecc";
> +       else
> +               return -EINVAL;

i wonder if the code would be simpler if we had a local static array.
then the show/store funcs would simply walk that tree, and when you
add a new format in the future, you only have to update one place.

static const char * const otp_redundancy_str[] = {
	[OTP_REDUNDANCY_FMT_SINGLE_ENDED] = "single-ended",
	[OTP_REDUNDANCY_FMT_REDUNDANT] = "redundant",
	........
};

> +static ssize_t otp_num_regions_show(struct device *dev,
> +                                   struct device_attribute *attr, char *buf)
> +{
> +       int nr_regions;
> +
> +       nr_regions = otp_dev->ops->get_nr_regions(otp_dev);
> +
> +       if (nr_regions < 0)
> +               return (ssize_t)nr_regions;

we could make get_nr_regions() return a ssize_t ...

> +       err = alloc_chrdev_region(&otp_dev->devno, 0, max_regions, "otp");

hmm, i was thinking that we'd have 1 major for otp devices.  isnt this
how MTD does it ?

> --- /dev/null
> +++ b/include/linux/otp.h
> +/**
> + * enum otp_device_flags - Flags to indicate capabilities for the OTP device.
> + *
> + * @OTP_DEVICE_FNO_SUBWORD_WRITE:      only full word sized writes may be
> + *                                     performed.  Don't use
> + *                                     read-modify-write cycles for
> + *                                     performing unaligned writes.
> + */
> +enum otp_device_flags {
> +       OTP_DEVICE_FNO_SUBWORD_WRITE    = (1 << 0),
> +};

use OTP_CAPS_xxx instead ?
-mike
