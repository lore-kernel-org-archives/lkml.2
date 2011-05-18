Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab1ERIWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 04:22:47 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47294 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225Ab1ERIWp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 04:22:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=QnkLQn+vsaYtyta4Y1RM7E2itRIiwDVMSY5Xrt4TevCpsnDFd0UMzei/Wc3UIGfz3S
         6GuMl2yeTeQTHRpdGo1HnjYLcH2WeA+pVBw229fnDUtgbONp8pZz7zW0c7ozWl5yk8wP
         vM5t/gCsxMigG6LujxF7xhhXXOovBGmj21uro=
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <201105180036.03836.rjw@sisk.pl>
References: <1305100723-29161-1-git-send-email-myungjoo.ham@samsung.com>
	<201105180036.03836.rjw@sisk.pl>
Date: Wed, 18 May 2011 17:22:43 +0900
X-Google-Sender-Auth: eM6-m39is0nkb2zTIxEFswkVPSk
Message-ID: <BANLkTi=_1DJPS+6goLA-UvdHJXEoPWBF2w@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] PM: Introduce DEVFREQ: generic DVFS framework with
 device-specific OPPs
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Mark Brown <broonie@sirena.org.uk>, Jiejing Zhang <kzjeef@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Colin Cross <ccross@google.com>,
        Nishanth Menon <nm@ti.com>, Thomas Gleixner <tglx@linutronix.de>,
        Len Brown <len.brown@intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/18 Rafael J. Wysocki <rjw@sisk.pl>:
> Hi,
>
> On Wednesday, May 11, 2011, MyungJoo Ham wrote:
[]
>> +/*
>> + * devfreq_work periodically (given by DEVFREQ_INTERVAL) monitors every
>> + * registered device.
>> + */
>
> I'm not sure what that means.  Does it happen only if monitoring is 'true'?
> If so, perhaps it could be called 'polling'?
>

Yes, it is correct. I'll change the name to polling.

>> +static bool monitoring;
[]
>> +                     devfreq = tmp_devfreq;
>
> Well, it looks like you could simply do "return tmp_devfreq" here
> (then you'd only need one local pointer).
>
>> +     return devfreq;
>
> And return ERR_PTR(-ENODEV) here.

Good. I'll do that.

>
>> +}
>> +
>> +#define dev_dbg_once(dev, fmt, ...)                          \
>> +     if (!once) {                                            \
>> +             once = 1;                                       \
>> +             dev_dbg(dev, pr_fmt(fmt), ##__VA_ARGS__);       \
>> +     }
>
> Why do you need this?
>

This devfreq_do is going to be called periodically; thus, I want to
print a message if there is an error, but not too many messages with
the repeated calls.

Besides, I'd change the macro like this:

#define dev_dbg_once(dev, fmt, ...)                          \
     {                                                                \
             static int once;                                   \
             if (!once) {                                            \
                     once = 1;                                       \
                     dev_dbg(dev, pr_fmt(fmt), ##__VA_ARGS__);       \
             }                                                 \
     }

so that "static int once;" in functions can be removed.


>> +     static int once;
>
> No, please.  Either make it a part of the macro, or remove the macro
> entirely.
>
>> +
>> +     err = devfreq->governor->get_target_freq(devfreq, &freq);
>> +     if (err) {
>> +             dev_dbg_once(devfreq->dev, "%s: get_target_freq error(%d)\n",
>> +                          __func__, err);
>> +             return err;
>> +     }
>> +
>> +     opp = opp_find_freq_ceil(devfreq->dev, &freq);
>> +     if (opp == ERR_PTR(-ENODEV))
>> +             opp = opp_find_freq_floor(devfreq->dev, &freq);
>> +
>> +     if (IS_ERR(opp)) {
>> +             dev_dbg_once(devfreq->dev, "%s: Cannot find opp with %luHz.\n",
>> +                          __func__, freq);
>> +             return PTR_ERR(opp);
>> +     }
>> +
>> +     freq = opp_get_freq(opp);
>> +     if (devfreq->previous_freq != freq) {
>> +             err = devfreq->profile->target(devfreq->dev, opp);
>> +             if (!err)
>> +                     devfreq->previous_freq = freq;
>
> I'd do
>
>    if (devfreq->previous_freq == freq)
>        return 0;
>
>    err = devfreq->profile->target(devfreq->dev, opp);
>    if (err) {
>       print message or something;
>       return err;
>    }
>
>    devfreq->previous_freq = freq;
>    return 0;
>

Good. That looks more pretty. I'll take that form.

>> +     }
>> +
>> +     if (err)
>> +             dev_dbg_once(devfreq->dev, "%s: Cannot set %luHz/%luuV\n",
>> +                          __func__, opp_get_freq(opp), opp_get_voltage(opp));
>> +     return err;
>> +}
>> +
>> +/**
>> + * devfreq_monitor() - Regularly run devfreq_do() and support device DEVFREQ tickle.
>> + * @work: the work struct used to run devfreq_monitor periodically.
>> + */
>> +static void devfreq_monitor(struct work_struct *work)
>> +{
>> +     struct devfreq *devfreq;
>> +     int error;
>> +     int reserved = 0;
>> +     static int once;
>> +
>> +     mutex_lock(&devfreq_list_lock);
>> +
>> +     list_for_each_entry(devfreq, &devfreq_list, node) {
>> +             if (devfreq->next_polling == 0)
>> +                     continue;
>> +
>> +             reserved++;
>
> Why is the variable called 'reserved'?

The variable reserves the next devfreq_monitor call. If there is no
one reserves, we stop monitoring.

However, I've found a bug in this routine (not affecting "reserved++"
directly though) that a tickled device without polling governor may
not return to its original frequency. It is easily addressed by adding
one more condition to the if statement before reserved++;. I'll fix
that in the next revision.

>
>> +
>> +             if (devfreq->tickle) {
>> +                     devfreq->tickle--;
>> +                     continue;
>> +             }
>
> I'd put a coment above that explaining what's going on here.

Ok.

>
>> +             if (devfreq->next_polling == 1) {
>> +                     error = devfreq_do(devfreq);
>> +                     if (error && !once) {
>> +                             once = 1;
>> +                             dev_err(devfreq->dev, "devfreq_do error(%d)\n",
>> +                                     error);
>
> Hmm.  I'm not sure, but wouldn't it make sense to drop the device from
> the list if devfreq_do() returns error code?

Umm... yeah.. that option (calling devfreq_remove_device() for errors)
is also possible, which will also remove the need for the macro you've
mentioned.

However, when the error is temporary or the device has blocked
changing frequencies temporarily from target callback or governor, it
could be not so desirable.

So, I'm considering to call devfreq_remove_device() at error if the
error is not "EAGAIN". That will also remove the need for the macro
and debug messages above. How about that?

[]
>> +int devfreq_update(struct device *dev, bool may_not_exist)
>> +{
>> +     struct devfreq *devfreq;
>> +     int err = 0;
>> +
>> +     mutex_lock(&devfreq_list_lock);
>> +
>> +     devfreq = find_device_devfreq(dev);
>> +     if (IS_ERR(devfreq)) {
>> +             if (may_not_exist && PTR_ERR(devfreq) == -EINVAL)
>> +                     goto out;
>> +
>
> This is kind of strange.  Why don't you simply pass -ENODEV to the caller
> so that it can decide?

Ewww.. Indeed. I'll remove that lines.

>
>> +             err = PTR_ERR(devfreq);
>> +             goto out;
>> +     }
>> +
>> +     if (devfreq->tickle) {
>> +             unsigned long freq = devfreq->profile->max_freq;
>> +             struct opp *opp = opp_find_freq_floor(devfreq->dev, &freq);
>> +
>> +             if (!IS_ERR(opp) && devfreq->previous_freq != freq) {
>> +                     err = devfreq->profile->target(devfreq->dev, opp);
>> +                     if (!err)
>> +                             devfreq->previous_freq = opp_get_freq(opp);
>> +             }
>
> This looks like a code duplication from devfreq_do().  Would it make sense
> to put it into a separate function?

devfreq_do() does not handle tickling. In devfreq_monitor(), it also
calls devfreq_do only when it is not being tickled.

>
>> +     } else {
>> +             err = devfreq_do(devfreq);
>> +     }
>> +
[]
>> +int devfreq_tickle_device(struct device *dev, unsigned long duration_ms)
>> +{
>> +     struct devfreq *devfreq;
>> +     struct opp *opp;
>> +     unsigned long freq;
>> +     int err = 0;
>> +
>> +     mutex_lock(&devfreq_list_lock);
>> +     devfreq = find_device_devfreq(dev);
>
> I think we should return here if the device hasn't been found.
> Do you want to set 'monitoring' unconditionally and schedule the work item
> unconditionally in this function and if so, why not to do that at the
> beginning?

Uhhh.. yes, this part required some cleaning. In fact, the cleaning is
done with the "add sysfs interface" patch, which added sysfs interface
to tickle. I'll restructure the patches and move the cleaned part from
the "add sysfs interface" patch.

[]
>> diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
>> index 4603f08..e5d2e36 100644
>> --- a/kernel/power/Kconfig
>> +++ b/kernel/power/Kconfig
>> @@ -225,3 +225,28 @@ config PM_OPP
>>         representing individual voltage domains and provides SOC
>>         implementations a ready to use framework to manage OPPs.
>>         For more information, read <file:Documentation/power/opp.txt>
>> +
>> +config PM_DEVFREQ
>> +     bool "Generic Dynamic Voltage and Frequency Scaling (DVFS) Framework"
>> +     depends on PM_OPP
>
> This assumes the user will know if his/her platform uses that code.
> It may be a good idea to make it depend on a user-invisible option that
> can be selected by the platform.

I think that like CPUFREQ, users will want to enable and disable
DEVFREQ feature by choice although they cannot choose the governor
directly. I'm also considering to allow users to set governors
forcibly and globally at menuconfig (like CPUFREQ does). With CPUFREQ,
such options helped a lot in troubleshooting of CPU related issues.

Do you think it'd be better to have DEVFREQ enabled unconditionally
(if PM_OPP is available) nonetheless?

>>
>
> Thanks,
> Rafael
>


Cheers!

- MyungJoo
-- 
MyungJoo Ham (함명주), Ph.D.
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: 82-10-6714-2858
