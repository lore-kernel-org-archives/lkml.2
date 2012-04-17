Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab2DQR4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 13:56:41 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35502 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab2DQR4j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 13:56:39 -0400
MIME-Version: 1.0
In-Reply-To: <4F8D5B09.8080309@nvidia.com>
References: <1334652631-21032-1-git-send-email-ldewangan@nvidia.com>
	<4F8D5506.6070105@cam.ac.uk>
	<4F8D5B09.8080309@nvidia.com>
Date: Tue, 17 Apr 2012 10:56:37 -0700
X-Google-Sender-Auth: hIXuS47Iqn3c8ssBps2LZ8pJbws
Message-ID: <CAEYUcX3TbXFmKYCvfz00tpJ3K0bSExnQxV1R==dP=+vsK54KPQ@mail.gmail.com>
Subject: Re: [PATCH] staging: iio: light: isl29018: use regmap for register access
From: Bryan Freed <bfreed@chromium.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "max@stro.at" <max@stro.at>,
        "jbrenner@taosinc.com" <jbrenner@taosinc.com>,
        "lars@metafoo.de" <lars@metafoo.de>,
        "grundler@chromium.org" <grundler@chromium.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Laxman, Jonathan.

The regmap is pretty new to me.  In looking at it, I see
_regmap_write() will regcache_write() before attempting to write to
the device.
This effectively updates the cached value even when the device write
fails, which is the opposite of the current isl29018 cache policy.

It looks like we tried to change the policy back in August and got
this response:
  > I did change one basic behavior that I think was also broken: cache
  > the value regardless of if the transaction completed successfully or
  > not.
  Don't do that.  That means userspace will get an invalid value if it reads
  in the meantime. If you have an error on a hardware bus - tell userspace about
  it and don't 'guess' what is in the register.
See http://driverdev.linuxdriverproject.org/pipermail/devel/2011-August/020256.html
for details.

The result is likely to be that after a failed write to one field of a
register, the next successful write to another field of that register
will update them both.

bryan.

On Tue, Apr 17, 2012 at 4:59 AM, Laxman Dewangan <ldewangan@nvidia.com> wrote:
>
> HI Jonathan,
>
> Thanks for fast review.
>
>
> On Tuesday 17 April 2012 05:03 PM, Jonathan Cameron wrote:
>>
>> On 4/17/2012 9:50 AM, Laxman Dewangan wrote:
>>>
>>> Using regmap for accessing register through i2c bus. This will
>>> remove the code for caching registers, read-modify-write logics.
>>> Also it will provide the debugfs feature to dump register
>>> through regmap debugfs.
>>
>> I'd prefer the intial tab fixup for the kconfig file as a separate
>> patch, but other than that
>> all looks good.
>>
>
> Yes, this make sense. I will create fist patch for fixing this and then next
> patch for actual my change.
>
>
>> This will probably cause issues alongside the series I sent to Greg the
>> other day though
>> so you may want to sit on it for a day or two and rebase.
>
>
> I will wait for your change to be in linux-next and then I will create next
> patches.
>
>
>>> Signed-off-by: Laxman Dewangan<ldewangan@nvidia.com>
>>
>> Acked-by: Jonathan Cameron<jic23@kernel.org>
>>>
>>> ---
>>>   drivers/staging/iio/light/Kconfig    |   19 ++--
>>>   drivers/staging/iio/light/isl29018.c |  176
>>> +++++++++++++++++-----------------
>>>   2 files changed, 99 insertions(+), 96 deletions(-)
>>>
>>> diff --git a/drivers/staging/iio/light/Kconfig
>>> b/drivers/staging/iio/light/Kconfig
>>> index 53b49f7..fd39f72 100644
>>> --- a/drivers/staging/iio/light/Kconfig
>>> +++ b/drivers/staging/iio/light/Kconfig
>>> @@ -4,15 +4,16 @@
>>>   menu "Light sensors"
>>>
>>>   config SENSORS_ISL29018
>>> -        tristate "ISL 29018 light and proximity sensor"
>>> -        depends on I2C
>>> -        default n
>>> -        help
>>> -         If you say yes here you get support for ambient light sensing
>>> and
>>> -         proximity infrared sensing from Intersil ISL29018.
>>> -         This driver will provide the measurements of ambient light
>>> intensity
>>> -         in lux, proximity infrared sensing and normal infrared sensing.
>>> -         Data from sensor is accessible via sysfs.
>>> +     tristate "ISL 29018 light and proximity sensor"
>>> +     depends on I2C
>>> +     select REGMAP_I2C
>>> +     default n
>>> +     help
>>> +      If you say yes here you get support for ambient light sensing and
>>> +      proximity infrared sensing from Intersil ISL29018.
>>> +      This driver will provide the measurements of ambient light
>>> intensity
>>> +      in lux, proximity infrared sensing and normal infrared sensing.
>>> +      Data from sensor is accessible via sysfs.
>>
>> Down to here is a valid but unconnected change.  Can you break this out
>> to a separate patch?
>
>
> Sure, I will do.
