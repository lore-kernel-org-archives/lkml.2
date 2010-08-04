Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653Ab0HDLdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 07:33:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932357Ab0HDLdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 07:33:01 -0400
Message-ID: <4C5950B6.5010503@redhat.com>
Date: Wed, 04 Aug 2010 13:36:22 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Giel van Schijndel <me@mortis.eu>
CC: Laurens Leemans <laurens@signips.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Randy Dunlap <rdunlap@xenotime.net>, Jean Delvare <khali@linux-fr.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] hwmon: f71882fg: Add support for the Fintek F71808E
References: <20100801132226.GE3711@salidar.me.mortis.eu> <1280669402-31213-1-git-send-email-me@mortis.eu>
In-Reply-To: <1280669402-31213-1-git-send-email-me@mortis.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I know I've reviewed this patch before, but now I have a datasheet
so this time I've been a bit more thorough and I've found 2 small
issues and 1 bigger one.

Andrew can you please drop this patch from -mm until this is resolved?

On 08/01/2010 03:30 PM, Giel van Schijndel wrote:
> Allow device probing to recognise the Fintek F71808E.
>
> Sysfs interface:
>   * Fan/pwm control is the same as for F71889FG

My datasheet strongly disagrees with this the F71889FG has 5 pwm zones
each with their own speed divided by 4 boundary temps, where as
the F71808E has 3 pwm zones divided by 2 boundary temps. So it is much
more like the F71862FG, which also has 2 boundary temps, and 3 pwm zones,
*but* the F71862FG has one pwm zone hardwired to 100%.

So it looks like you need to create a new f71808e_auto_pwm_attr array
esp. for this model, as well as a special case for reading the
auto pwm attr in f71882fg_update_device.

Also the auto pwm of the F71808E allows following of digital temps
read to peci / amdsi / ibex rather then following a directly connected
temp diode like the F71889FG, which the driver does not support, so
you should check if this is enabled and if so disable the auto pwm
attr entirely. Code for this is already in place for the F71889FG,
you simply need to make it trigger when the chip is a F71808E too.

>   * Temperature and voltage sensor handling is largely the same as for
>     the F71889FG
>    - Has one temperature sensor less (doesn't have temp3)
>    - Misses one voltage sensor (doesn't have V6, thus in6_input refers to
>      what in7_input refers for F71889FG)
>
> For the purpose of the sysfs interface fxxxx_in_temp_attr[] is split up
> such that it can largely be reused.

There is a problem here though, the new fxxxx_temp_attr contains
attributes for temp#_max_beep and temp#_crit_beep, but the F71808E
lacks that function. So I think that the new fxxxx_temp_attr
need to be split into fxxxx_temp_attr and fxxxx_temp_beep_attr,
like is already done with fxxxx_fan_attr.

Also while making changes, I must say I don't like the splitting
of fxxxx_temp_attr into fxxxx_temp_attr and f71862_temp_attr just because
the number of sensors differs. I think it would be better to instead
make fxxxx_temp_attr a 2 dimensional array like fxxxx_fan_attr and like
with fxxxx_fan_attr register as many sensor attr blocks as the specific
model has.

> Signed-off-by: Giel van Schijndel<me@mortis.eu>
> ---
>   Documentation/hwmon/f71882fg |    4 ++
>   drivers/hwmon/Kconfig        |    6 ++--
>   drivers/hwmon/f71882fg.c     |   83 ++++++++++++++++++++++++++++++++++++++----
>   3 files changed, 82 insertions(+), 11 deletions(-)
>
> diff --git a/Documentation/hwmon/f71882fg b/Documentation/hwmon/f71882fg
> index a7952c2..1a07fd6 100644
> --- a/Documentation/hwmon/f71882fg
> +++ b/Documentation/hwmon/f71882fg
> @@ -2,6 +2,10 @@ Kernel driver f71882fg
>   ======================
>
>   Supported chips:
> +  * Fintek F71808E
> +    Prefix: 'f71808fg'

This is wrong, as you already indicate and the datasheet as well this
chip in question is an f71808e not an f71808fg, also note that there is
an f71808a model as well which is different (and has a different super io
chip id).

One last request in the second switch case in f71882fg_remove()
there is a default label which contains a comment which models it applies
to, please add the f71808e to that comment.

Regards,

Hans
