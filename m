Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab0IBXKf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 19:10:35 -0400
Received: from ppsw-32.csi.cam.ac.uk ([131.111.8.132]:38810 "EHLO
	ppsw-32.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab0IBXKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 19:10:34 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4C80300C.1010300@cam.ac.uk>
Date: Fri, 03 Sep 2010 00:15:24 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100830 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andrew Chew <AChew@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: Re: [PATCH 1/1] iio: ak8975: Add Ak8975 magnetometer sensor
References: <1283463351-15816-1-git-send-email-achew@nvidia.com>	<20100902231942.21375cc0@lxorguk.ukuu.org.uk>	<643E69AA4436674C8F39DCC2C05F763816B85AD096@HQMAIL03.nvidia.com> <20100902234124.584b9bf7@lxorguk.ukuu.org.uk>
In-Reply-To: <20100902234124.584b9bf7@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before I dive blindly in please note I have only taken a quick look as away from
a computer with a decent size screen until tomorrow evening. I'll take a closer
look at the driver then.
On 09/02/10 23:41, Alan Cox wrote:
> On Thu, 2 Sep 2010 15:16:20 -0700
> Andrew Chew <AChew@nvidia.com> wrote:
> 
>>>> +static IIO_DEVICE_ATTR(mode, S_IRUGO | S_IWUSR, show_mode, 
>>> store_mode, 0);
>>>> +static IIO_DEVICE_ATTR(magn_x_calibscale, S_IRUGO, 
>>> show_calibscale, NULL, 0);
>>>> +static IIO_DEVICE_ATTR(magn_y_calibscale, S_IRUGO, 
>>> show_calibscale, NULL, 1);
>>>> +static IIO_DEVICE_ATTR(magn_z_calibscale, S_IRUGO, 
>>> show_calibscale, NULL, 2);
>>>> +static IIO_DEV_ATTR_MAGN_X(show_raw, AK8975_REG_HXL);
>>>> +static IIO_DEV_ATTR_MAGN_Y(show_raw, AK8975_REG_HYL);
>>>> +static IIO_DEV_ATTR_MAGN_Z(show_raw, AK8975_REG_HZL);
>>>
>>> This seems odd as an interface as it's raw when the maths to provide
>>> non-raw (and thus abstract and easy for user space) data is trivial
>>> enough to do in kernel
>>
>> IIO guys want to do normalization maths above the kernel-level magnetometer IIO layer. 
>>This interface came before me, so I'm just following current conventions.
> 
> That will make a generic IIO <-> input bridge very hard to do right. I
> can see why IIO wants to do that but you need both if so and this also
> needs discussion.

Note that, though there are few drivers using it (just the tsl2563 iirc)
we do allow the hwmon style _input syntax for values in the standard units
for the device type.  If you are going to use the raw option then,
assuming linear conversion, at the very least magn_scale should be provided
to tell userspace how to do the conversion.  If the bridge to input
is done in userspace then it is trivial to apply this before passing
into uinput.  For background info, the bridge approach currently
relies on implementation of the 'buffered' iio interface which uses
chrdevs rather than the hwmon like 'simple' interface provided here.
It would be a bit of a nightmare to bridge from sysfs (if it could
even be done?)  Typically all drivers start with the sysfs interface
and the buffered one is only added if needed by someone.

Note calibscale is meant for internally applied values.  That is ones applied
actually on the device (looking at what you have here, my choice of naming
wasn't ideal, anyone have a better naming suggestion).  The value used to do raw to
standard unit conversion in userspace is magn_x_scale or equivalent.
I think based on the comment in your code that you also need to provide
magn_x_offset.  Looks like our documentation could do to be a little clearer.
Rather tediously these are both computed floating point values here.  Perhaps
we will need to think further on that interface (this is the first time
we have hit this particular situation)

The raw option is principally there because we share the attributes with the
buffer access (there performance dictates doing as little as possible to the
data on the way through.) Admittedly our overheads are way too high at the
moment for other reasons but the intent is there.  If you are intending to
add this interface later then keeping to the _raw attributes makes for a
more consistent choice (though as long as the scale and bias are there for
the buffer you could use the processed value...)

Thanks,

Jonathan
