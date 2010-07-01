Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457Ab0GACHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 22:07:46 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46039 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab0GACHp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 22:07:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UTUwE3HeLTf3VEXKY8i1pnn5vNingsNspVRRy5hMOq60l6sYz+JJPzApg8uAZqiwfz
         Qwl/Aght7kX90BhwRoz4usVG8XZQ6yWl9HGvmdXrkiYK2NLhLeXGrJzCmUwKdy7S78dG
         zzhTx1Qf3kzCJmW7REmGTXyRFq6iCLbq0rfQ4=
MIME-Version: 1.0
In-Reply-To: <20100630163130.GD5832@sirena.org.uk>
References: <3495EC08FA53E94AAA00CC4743D5BA7E013FA7ED@pandora.diasemi.com>
	<20100630163130.GD5832@sirena.org.uk>
Date: Thu, 1 Jul 2010 10:07:44 +0800
Message-ID: <AANLkTinzt-OtIh1rqVjuzV4-2030MJ2VEBFdPvHT05c4@mail.gmail.com>
Subject: Re: [rtc-linux] Re: [PATCHv1 3/11] RTC: Removal of redundant 
	comments, printk
From: Wan ZongShun <mcuos.com@gmail.com>
To: rtc-linux@googlegroups.com
Cc: David Dajun Chen <Dajun.Chen@diasemi.com>, p_gortmaker@yahoo.com,
       linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't get your patch in RTC mail list, but I google it.
Some minior comments:

2010/7/1 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Tue, Jun 29, 2010 at 02:16:55PM +0100, David Dajun Chen wrote:
>> RTC module of the device driver for DA9052 PMIC device from Dialog
>> Semiconductor.
>
> Adding Alessandro and the RTC list.  As you have been reminded
> repeatedly you should CC all the relevant maintainers and lists on
> patches.
>
>> +config RTC_DRV_DA9052
>> +     tristate "Support RTC on Dialog Semiconductor DA9052 PMIC"
>> +     depends on PMIC_DA9052
>> +     help
>> +       Say y here to support the RTC found on
>> +       Dialog Semiconductor DA9052 PMIC.
>
> Kconfig and Makefile entries should be sorted.
>
>> +     if (msg.data & DA9052_ALARMMI_ALARMTYPE)
>> +             printk(KERN_INFO "RTC: TIMER ALARM\n");
>> +     else
>> +             printk(KERN_INFO "RTC: TICK ALARM\n");
>
> This logging seems inappropriate - you should be notifying the RTC
> subsystem of the events rather than logging them (loudly).
>
>> +static int da9052_rtc_validate_parameters(struct rtc_time *rtc_tm)
>> +{
>> +
>> +     if (rtc_tm->tm_sec > DA9052_RTC_SECONDS_LIMIT)
>> +             return DA9052_RTC_INVALID_SECONDS;
>
> Are these limits different to those enforced by rtc_valid_tm()?
> If there are any additional restrictions it'd be better to call that and
> only implement the additional checks that are required by the specific
> chip.  If checks apply to all times then adding them to rtc_valid_tm()
> would be better.

I have checked your validate_parameters codes, and why you limit
rtc_tm->tm_year
larger than '63'? , anyway, there is no need to implement this
function, except the years lmit.

In addition, in all the set time functions(set alarm or set time), you
don't need to
check your 'rtc_tm' again, since the checking action has done in rtc subsystem.
In all read time functions(read time or read alarm), it is much better
to hire 'rtc_valid_tm'
to ensure the correct returning time value for you.

In read_alarm function, tell your alarm->enabled to caller would be fine.

>
>> +     if (ENABLE == flag)
>> +             msg.data = msg.data | DA9052_ALARMY_ALARMON;
>> +     else if (DISABLE == flag)
>> +             msg.data = msg.data & ~(DA9052_ALARMY_ALARMON);
>
> This can just be written as
>
>        if (flag)
>                ...
>        else
>                ...
>
> which is much more idiomatic.
>
>> +     da9052_lock(da9052);
>> +     ret = da9052->read(da9052, &ssc_msg);
>> +     if (ret) {
>> +             da9052_unlock(da9052);
>> +             return ret;
>> +     }
>> +     da9052_unlock(da9052);
>> +
>> +     data = ret;
>> +
>> +     ssc_msg.data = data &= ~DA9052_IRQMASKA_MALRAM;
>> +
>> +     da9052_lock(da9052);
>> +     ret = da9052->write(da9052, &ssc_msg);
>> +     da9052_unlock(da9052);
>
> This has the locking problem with read/modify/write sequences I
> mentioned in reply to the regulator driver.
>
>> +static int da9052_rtc_class_ops_settime(struct device *dev, struct
>> rtc_time *tm)
>> +{
>> +     int ret;
>> +     struct da9052_rtc *priv = dev_get_drvdata(dev);
>> +
>> +     ret = da9052_rtc_settime(priv->da9052, tm);
>> +
>> +     return ret;
>> +}
>
> Separating the class operations and the actual implementations like this
> looks a bit odd - what does it add?
>
>> +/* Months */
>> +#define FEBRUARY                                     (2)
>> +#define APRIL                                                (4)
>> +#define JUNE                                         (6)
>> +#define      SEPTEMBER                                       (9)
>> +#define NOVEMBER                                     (11)
>
> These are *very* generic things to be defining in a driver specific
> header with no namespacing, and it seems odd that you'd need them at
> all.
>
>> +/* RTC error codes */
>> +#define DA9052_RTC_INVALID_SECONDS                   (3)
>> +#define DA9052_RTC_INVALID_MINUTES                   (4)
>> +#define DA9052_RTC_INVALID_HOURS                     (5)
>> +#define DA9052_RTC_INVALID_DAYS                              (6)
>> +#define DA9052_RTC_INVALID_MONTHS                    (7)
>> +#define DA9052_RTC_INVALID_YEARS                     (8)
>> +#define DA9052_RTC_INVALID_EVENT                     (9)
>> +#define DA9052_RTC_INVALID_IOCTL                     (10)
>> +#define DA9052_RTC_INVALID_SETTING                   (11)
>> +#define DA9052_RTC_EVENT_ALREADY_REGISTERED          (12)
>> +#define DA9052_RTC_EVENT_UNREGISTERED                        (13)
>> +#define DA9052_RTC_EVENT_REGISTRATION_FAILED         (14)
>> +#define DA9052_RTC_EVENT_UNREGISTRATION_FAILED               (15)
>
> Rather than defining custom error codes you should use standard Linux
> error codes.  These also overlap with the standard Linux codes.
>
> --
> You received this message because you are subscribed to "rtc-linux".
> Membership options at http://groups.google.com/group/rtc-linux .
> Please read http://groups.google.com/group/rtc-linux/web/checklist
> before submitting a driver.



-- 
*linux-arm-kernel mailing list
mail addr:linux-arm-kernel@lists.infradead.org
you can subscribe by:
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

* linux-arm-NUC900 mailing list
mail addr:NUC900@googlegroups.com
main web: https://groups.google.com/group/NUC900
you can subscribe it by sending me mail:
mcuos.com@gmail.com
