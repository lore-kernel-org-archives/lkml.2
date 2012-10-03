Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976Ab2JCElg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 00:41:36 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:44465 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab2JCEld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 00:41:33 -0400
MIME-Version: 1.0
In-Reply-To: <25815442.471031349156505509.JavaMail.weblogic@epml02>
References: <25815442.471031349156505509.JavaMail.weblogic@epml02>
Date: Wed, 3 Oct 2012 10:11:32 +0530
Message-ID: <CA+Z25wXZstv8rb0s0O_SBb4-jrFhPYK-J_8m5_aHgtoCb3jP2g@mail.gmail.com>
Subject: Re: Re: [PATCH v3 1/3] devfreq: Core updates to support devices which
 can idle
From: Rajagopal Venkat <rajagopal.venkat@linaro.org>
To: myungjoo.ham@samsung.com
Cc: "mturquette@linaro.org" <mturquette@linaro.org>,
        =?UTF-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>,
        "rjw@sisk.pl" <rjw@sisk.pl>, "patches@linaro.org" <patches@linaro.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 October 2012 11:11, MyungJoo Ham <myungjoo.ham@samsung.com> wrote:
>> On 27 September 2012 13:50, MyungJoo Ham <myungjoo.ham@samsung.com> wrote:
>> >> Prepare devfreq core framework to support devices which
>> >> can idle. When device idleness is detected perhaps through
>> >> runtime-pm, need some mechanism to suspend devfreq load
>> >> monitoring and resume back when device is online. Present
>> >> code continues monitoring unless device is removed from
>> >> devfreq core.
>> >>
>> >> This patch introduces following design changes,
>> >>
>> >> - use per device work instead of global work to monitor device
>> >>   load. This enables suspend/resume of device devfreq and
>> >>   reduces monitoring code complexity.
>> >> - decouple delayed work based load monitoring logic from core
>> >>   by introducing helpers functions to be used by governors. This
>> >>   provides flexibility for governors either to use delayed work
>> >>   based monitoring functions or to implement their own mechanism.
>> >> - devfreq core interacts with governors via events to perform
>> >>   specific actions. These events include start/stop devfreq.
>> >>   This sets ground for adding suspend/resume events.
>> >>
>> >> The devfreq apis are not modified and are kept intact.
>> >>
>> >> Signed-off-by: Rajagopal Venkat <rajagopal.venkat@linaro.org>
>> >
>> > Hello,
>> >
>> >
>> > I'll do more through review tomorrow (sorry, I was occuppied by
>> > something other than Linux tasks for a while again); however,
>> > there are two concerns in this patch.
>> >
>> > 1. (minor but may bothersome in some rare but not-ignorable cases)
>> > Serialization issue between suspend/resume
>> > functions; this may happen with some failure or interrupts while entering STR or
>> > unexpected usage of the API at drivers.
>>
>> Regarding the invalid usage of suspend/resume apis, we can have
>> additional checks
>> something like,
>>
>> void devfreq_monitor_suspend(struct devfreq *devfreq)
>> {
>>         .....
>>         if (devfreq->stop_polling)
>>                 return;
>>         ......
>> }
>>
>> void devfreq_monitor_resume(struct devfreq *devfreq)
>> {
>>         .....
>>         if (!devfreq->stop_polling)
>>                 return;
>>         ......
>> }
>>
>> >
>> >   For example, if devfreq_monitor_suspend() and devfreq_montir_resume() are called
>> > almost simultaneously, we may execute 1) locked part of suspend, 2) locked part of
>> > resume, 3) cancel_delayed_work_sync of suspend.
>> >
>> >   Then, we may have stop_polling = false w/ cancel_delayed_work_sync() in effect.
>> >
>> >   Let's not assume that suspend() and resume() may called almost simultaneously,
>> > especially in subsystem core code.
>
> (sorry, I missed "not be" between "may" and "called" here)
>
>> >
>>
>> These devfreq_monitor_suspend() and devfreq_monitor_resume() functions are
>> executed when device idleness is detected. Perhaps,
>> - using runtime-pm: the runtime_suspend() and runtime_resume() are mutually
>> exclusive and is guaranteed not to run in parallel.
>> - driver may have its own mechanism: in my opinion, driver should ensure
>> suspend/resume are sequential even for it to know its devfreq status.
>>
>> Assuming even if above sequence occurs, I don't see any problem having
>> stop_polling = false w/ cancel_delayed_work_sync() in effect. Since the suspend
>> is the last one to complete, monitoring will not continue.
>
> Why don't you simply extend the mutex-locked context?
>
> I.e.,
> +       mutex_lock(&devfreq->lock);
> +       devfreq->stop_polling = true;
> +       mutex_unlock(&devfreq->lock);
> +       cancel_delayed_work_sync(&devfreq->work);
> -->
> +       mutex_lock(&devfreq->lock);
> +       devfreq->stop_polling = true;
> +       cancel_delayed_work_sync(&devfreq->work);
> +       mutex_unlock(&devfreq->lock);
>
Extending the mutex-locked context would cause deadlock.

Since scheduled work callback also needs mutex lock, calling
cancel_delayed_work_sync
with lock held, would cause deadlock.

> This serializes data-update and the execution based on the data-update,
> resolving any inconsistency issues with the queue-status and devfreq
> variable.
>
> It doesn't have a heavy overhead to extend it and we have the
> probably of inconsistency due to serialization issues.
>
>>
>> >
>> > 2. What if polling_ms = 0 w/ active governors (such as ondemand)?
>> >
>> >  Users may declare the initial polling_ms = 0 w/ simple-ondemand in order to
>> > pause sampling at boot-time and start sampling at run-time some time later.
>> >
>> > It appears that this patch will start forcibly at boot-time in such a case.
>>
>> Yes. This is a valid case which can be handled by
>>
>>  void devfreq_monitor_start(struct devfreq *devfreq)
>>  {
>>         INIT_DELAYED_WORK_DEFERRABLE(&devfreq->work, devfreq_monitor);
>> +       if (devfreq->profile->polling_ms)
>>                 queue_delayed_work(devfreq_wq, &devfreq->work,
>>                         msecs_to_jiffies(devfreq->profile->polling_ms));
>>  }
>
>
> Please add the checking statement to every queue_delayed_work() statement:
> resume and interval-update functions.
Done.
>
>
>
> Cheers!
> MyungJoo
>



-- 
Regards,
Rajagopal
