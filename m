Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab1FPAM7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 20:12:59 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:36658 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752618Ab1FPAM6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 20:12:58 -0400
From: Kevin Hilman <khilman@ti.com>
To: Colin Cross <ccross@android.com>
Cc: "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Eric Miao <eric.y.miao@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Leif Lindholm <leif.lindholm@arm.com>
Subject: Re: [PATCH 1/3] ARM: Add cpu power management notifiers
Organization: Texas Instruments, Inc.
References: <1307925825-28566-1-git-send-email-ccross@android.com>
	<1307925825-28566-2-git-send-email-ccross@android.com>
	<87ips9fka2.fsf@ti.com>
	<BANLkTinnZtPFY1Aae=8uDbyt5sh9xAxiNw@mail.gmail.com>
Date: Wed, 15 Jun 2011 17:12:53 -0700
In-Reply-To: <BANLkTinnZtPFY1Aae=8uDbyt5sh9xAxiNw@mail.gmail.com> (Colin
	Cross's message of "Mon, 13 Jun 2011 23:15:58 -0700")
Message-ID: <87lix2y6pm.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Colin Cross <ccross@android.com> writes:

> On Mon, Jun 13, 2011 at 3:17 PM, Kevin Hilman <khilman@ti.com> wrote:
>> Colin Cross <ccross@android.com> writes:
>>
>>> During some CPU power modes entered during idle, hotplug and
>>> suspend, peripherals located in the CPU power domain, such as
>>> the GIC and VFP, may be powered down.  Add a notifier chain
>>> that allows drivers for those peripherals to be notified
>>> before and after they may be reset.
>>>
>>> Signed-off-by: Colin Cross <ccross@android.com>
>>
>> This is great, thanks!
>>
>> I had hacked up something OMAP-specific a while back to do something
>> similar, and have been meaning to make it more generic, so this is
>> perfect.  Also, if it is moved outside ARM, note that x86_64 has a
>> idle_notifier infrastructure that is somewhat similar, and if you're
>> motivated, it should probably be converted to this as well.  See
>> arch/x86/kernel/process_64.c.
>
> I'll take a look at x86
>
>> Also, for the sake of the comments/changelog, the usefulness of these
>> notifiers is not limited to low-power states where power is off and IP
>> blocks may be reset.  It could be considered as simply a generic
>> notification mechanism for any CPU PM transitions.
>>
>> On OMAP we have other peripherals (not in the CPU power domain) where we
>> need to control their PM transitions in relation to the CPU PM
>> transitions so the notifiers are useful for any low-power state
>> transition of the CPU(s).  The drivers for these peripherals use runtime
>> PM in their CPU PM notifiers to trigger the device PM transitions. (The
>> drivers must use the synchronous versions of the runtime PM get/put
>> calls with device in pm_runtime_irq_safe() mode.)
>
> Can you give a concrete example of this so I can describe it correctly?
>

One simple example is a clock controlling a thermal sensor.  The sensor
(and thus the functional clock) should be active whenever the CPU is
running, so the idle transition (clock gating) of this IP block should
be coordinated with any idle transitions of the CPU cluster.

Another example is any IP block that is not capable of waking up the CPU
(or $DEITY forbid, where said wakeups are broken.)  A CPU_PM_EXIT
notifier would be used to check for pending activity and take action.

>> In this series, I don't see any calls to cpu_[complex_]pm_[enter|exit]().
>> Based on that, I assume you prefer to leave it up to platform-specific
>> idle/PM code to place these calls.  Or, do you plan to have this
>> triggered by generic CPUidle, suspend/resume and/or hotplug code?  At
>> least on OMAP, I prefer having the calls in platform-specific code.
>
> I will post the Tegra code that uses this soon.  I expect that the
> decision on exactly when to call these functions will be unique to
> each platform, so I think it should start in the platform-specific
> code.

Agreed.

>> I have a minor enhancement request.  The notifier callbacks provide for
>> passing a void * through the notifier chain.  Could you add a way for a
>> void * to be registered at cpu_pm_register_notifier() time and that
>> would be passed through the notifier call chain?  This would allow using
>> the same struct notifier_block and callback for multiple instances of
>> the same IP, and the instances could be differentiated in the callback
>> using the void *.
>
> The void * passed to the notifier comes from the call to
> notifier_call_chain(), not from the call to register_notifier().  

I see now.

> You can get the behavior you want by putting the notifier_block inside
> your device struct and using container_of on the notifier_bock.

Yeah, that's the way I did it, but it requires a separate 'struct
notifier_block' for each device instance.  It's only a minor issue, but
being able to pass in the 'void *' at registration time would allow a
single struct notifier_block' for all instances of the device.

>> Also, FWIW I tested this on OMAP3 (Cortex-A8 UP) using
>> cpu_pm_enter/exit() in the code path shared between idle and suspend.  I
>> successfully triggered PM transitions in non-CPU power-domain
>> peripherals, and it worked great.
>
> Great!  Can I get a tested-by?

Sure, meant to add it the first time.

Tested-by: Kevin Hilman <khilman@ti.com>

Kevin

