Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029Ab1DUHDf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 03:03:35 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45008 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab1DUHDe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 03:03:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Gspa7pcHFcxfYlC9woIa1ZkKmUDUpqm4HiwsLKBUnvhiIhOeJ54sEvV4QyRc8YX4pS
         0TGlENL5AsnoXZYxR86OzxSC1PS5GPynSxBgaSP/OaLih8+GqXjbZR3ZtQKghU6jMSi0
         R6uWs+q0N2Yq/Cho4oYGxNg/BplReQtKij7EM=
MIME-Version: 1.0
In-Reply-To: <201104202228.00514.rjw@sisk.pl>
References: <1303288106-2965-1-git-send-email-myungjoo.ham@samsung.com>
	<201104202228.00514.rjw@sisk.pl>
Date: Thu, 21 Apr 2011 16:03:32 +0900
X-Google-Sender-Auth: GVOt-CLz-Cc7FUm-S0QETe51eVg
Message-ID: <BANLkTimUdS5PKy7QwMhiXDN2Pw4_Bmv9AA@mail.gmail.com>
Subject: Re: [RFC PATCH] PM / Core: suspend_again cb for syscore_ops
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, kyungmin.park@samsung.com,
        MyungJoo Ham <myungjoo.ham@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/21 Rafael J. Wysocki <rjw@sisk.pl>:
> On Wednesday, April 20, 2011, MyungJoo Ham wrote:
>> A system or a device may need to control suspend/wakeup events. It may
>> want to wakeup the system after a predefined amount of time or at a
>> predefined event decided while entering suspend for polling or delayed
>> work. Then, it may want to enter suspend again if its predefined wakeup
>> condition is the only wakeup reason and there is no outstanding events;
>> thus, it does not wakeup the userspace unnecessary and keeps suspended
>> as long as possible (saving the power).
>>
>> Enabling a system to wakeup after a specified time can be easily
>> achieved by using RTC. However, to enter suspend again immediately
>> without invoking userland, we need additional features in the
>> suspend framework.
>>
>> Such need comes from:
>>
>> 1. Monitoring a critical device status without interrupts that can
>> wakeup the system. (in-suspend polling)
>>  An example is ambient temperature monitoring that needs to shut down
>> the system or a specific device function if it is too hot or cold. The
>> temperature of a specific device may be needed to be monitored as well;
>> e.g., a charger monitors battery temperature in order to stop charging
>> if overheated.
>>
>> 2. Execute critical "delayed work" at suspend.
>>  A driver or a system/board may have a delayed work (or any similar
>> things) that it wants to execute at the requested time.
>>  For example, some chargers want to check the battery voltage some
>> time (e.g., 30 seconds) after the battery is fully charged and the
>> charger stops. Then, the charger restarts charging if the voltage has
>> dropped more than a threshold, which is smaller than "restart-charger"
>> voltage, which is a threshold to restart charging regardless of the
>> time passed.
>>
>> This patch allows a system or a device to provide "suspend_again"
>> callback with syscore_ops. With suspend_again callbacks registered,
>> the suspend framework (kernel/power/suspend.c) tries to enter suspend
>> again if conditions are met.
>
> syscore_ops are defined to be executed on one CPU and with interrupts off.
> I don't think your new callback matches this definition.

Yes, this "suspend-again" is not meant to be that close to suspended
state and is placed near "end()".
Do you think it would be better fitted if it is included as device
driver's pm_ops along with other "suspend", "suspend_noirq", and such?

>
>> The system enters the suspend again if and only if all of the following
>> conditions are met:
>> 1. None of suspend_again ops returned "I want to stop suspend"
>> (suspend_again returns SUSPEND_AGAIN_STOP).
>> 2. At least one of suspend_again ops returned "I want to suspend again"
>> (suspend_again returns SUSPEND_AGAIN_CONTINUE)
>>
>> suspend_again ops may return "I do not care. This wakeup is not related
>> with me." (SUSPEND_AGAIN_NC, which is 0).
>>
>> Use SUSPEND_AGAIN_STOP in order to override other devices'
>> SUSPEND_AGAIN_CONTINUE and to wakeup fully. For devices that poll
>> sensors during suspend may need this if any outstanding status is found.
>> For conventional suspend wakeup sources, SUSPEND_AGAIN_STOP may be used
>> to override SUSPEND_AGAIN devices.
>>
>> Anyway, the following features may need to be added later:
>> 1. An API to allow devices to express next desired wakeup-time. Then,
>> the framework will combine them and setup RTC alarm accordingly and
>> save/restore previously registered RTC alarms.
>> 2. Create a method to declare a specific instance of delayed-work is to
>> be executed in suspend by waking up the system in the middle of
>> suspend. Then, let the framework handle those "critical" delayed-work
>> in suspend.
>> 3. If a device says SUSPEND_AGAIN_CONTINUE and there is another wakeup
>> source pending (e.g., power button) without suspend_again ops, the
>> system will enter suspend again. In such a case, the system should not
>> suspend again. We may need to see if irqs that are enabled by
>> set_irq_wake() (and not related to suspend_ops devices)
>> are pending at syscore_suspend_again(). Maybe we need to add
>> something like "set_irq_wake_with_suspend_again" so that IRQs with
>> suspend_again ops implemented are ignored for the
>> "override-suspend-again-continue" checking.
>>
>> For the initial release, I have set the point of "suspend-again" after
>> suspend_ops->end(). However, I'm not so sure about where to set the
>> suspend-again point. Because in-suspend polling, which may require
>> I/O with other devices, is supposed to be executed at suspend-again ops,
>> the suspend-again point is configured to be as late as possible in
>> suspend_devices_and_enter(). In order to reduce the number of devices
>> waked up, we may need to set the suspend-again point ealier.
>>
>> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>
> The idea seems to be sane, but I don't like the implementation.
>
> First off, why do you thing it's a good thing to put the callback into
> struct syscore_ops?

I put the callback to syscore_ops as it appeared that the
suspend_again callback may be required by a device, a sysdev, or a
platform/machine (that calls suspend_set_ops() ). In other words, a
specific device or sysdev may want to use the feature while the board
itself may want it.

However, I think it's good to have the callback at pm_dev_ops for
devices and let subsystems handle it. In such a case, starting only
with platform_device would be fine.

>
>> ---
>>  drivers/base/syscore.c      |   36 +++++++++++++++++++++++++++
>>  include/linux/syscore_ops.h |    7 +++++
>>  kernel/power/suspend.c      |   57 +++++++++++++++++++++++-------------------
>>  3 files changed, 74 insertions(+), 26 deletions(-)
>>
>> diff --git a/drivers/base/syscore.c b/drivers/base/syscore.c
>> index 90af294..1a7e08d 100644
>> --- a/drivers/base/syscore.c
>> +++ b/drivers/base/syscore.c
>> @@ -95,6 +95,42 @@ void syscore_resume(void)
>>                               "Interrupts enabled after %pF\n", ops->resume);
>>               }
>>  }
>> +
>> +/**
>> + * syscore_suspend_again - Execute all the registeres system core suspend_again
>> + *                   callbacks. If at least one returns
>> + *                   SUSPEND_AGAIN_CONTINUE and no one returns
>> + *                   SUSPEND_AGAIN_STOP, syscore_suspend_again let the system
>> + *                   enter suspend again.
>> + */
>
> That causes the ->suspend_again() callbacks to be quite complicated.  I'm not
> sure this is necessary in general.

For "suspend-again" feature, the callback has the ability to return
the following 3,
"I want to suspend again" (CONTINUE),
"I want to resume." or "There is an exception or an error." (STOP);
overriding CONTINUE
"I do not care." (NC); default.

That comment is about how these conditions are met in the view of
syscore framework side.

>
[]
>
> All of those goto statements from the inside of the loop don't really look
> good.  Isn't there any way to avoid them?

Fine. I will reform suspend_devices_and_enter's structure in the next revision.

>
[]
>> +             if (suspend_ops->end)
>> +                     suspend_ops->end();
>> +             trace_machine_suspend(PWR_EVENT_EXIT);
>> +     } while (syscore_suspend_again() && !error && !recover);
>
> Why exactly do you think that the next automatic suspend should occur at
> this particular point?

The intention was to allow most devices to use the feature.

Because any actions (e.g., sensor polling, executing delayed work,
...) that are intended to use/require automatic suspend will be
executed at the syscore_suspend_again, we have to guarantee that the
required devices are available at that point except for userland
stuff.

It makes to set the point after "dpm_resume_end(PMSG_RESUME);".

Another consideration was that if we keep it looping without console
enabled, we may have too many logs accumulated while the console is
disabled; thus, the point is further pushed lower to
"resume_console()".

Putting the point after "trace_machine_suspend(PWR_EVENT_EXIT)" was to
allow tracer to track each instance of suspend_again.

>
[]
>>
>
> To summarize:
> * I don't think struct syscore_ops is the right place for the new callback.

Then, what about dev_pm_ops (although, then, it will depend on subsystems)?

> * The necessity to take care of the possibly many different return values
>  with different meanings have a potential to introduce unnecessary
>  complications into the subsystems implementing the new callback.

Aren't three values (CONTINUE / STOP / NotCare) simple enough?
I thought of two values at first (CONTINUE / STOP); however, in that
way, if no one has an error or failure (requiring urgent wake up),
we'd have infinite loop of suspend.

Or maybe we can implement in this way,
if there is a pending interrupt of IRQ with set_irq_wake on unless the
IRQ is specified to be handled by one of suspend_again callbacks, it
is assumed to have STOP equivalent return and we allow only "CONTINUE"
and "STOP" (or simply return 0 to continue, return -ERRNO to stop)

> * It isn't particularly clear to me why the new suspend should occur at the
>  point you want it to.

Please read the above.

>
> Moreover, what's wrong with thawing user space processes and _then_
> automatically suspending again?  Why do you want to do that from the inside
> of the kernel?

If we let user space processes to decide whether to enter suspend
again or not, every user process will wake up and user processes, not
device drivers should take the responsibility to monitor the status
and handle device driver specific tasks (some of delayed work of
device drivers mentioned earlier).

When it is for simple sensor polling and executing critical (but
simple) kernel delayed work,
a) waking up the whole user processes is too heavy (for power
consumption and suspend/wakeup latency),
b) some of kernel device drivers are depending on user processes
(using user process's features at device driver), and
c) user processes expect that the system wakes up when it is now free
to move on, not wanting to sleep again. (waked up by "power button
press", "user defined alarm", "some important messages from
kernel/device", and such)

>
> Rafael
>

Thank you.


Cheers!

- MyungJoo

-- 
MyungJoo Ham (함명주), Ph.D.
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: 82-10-6714-2858
