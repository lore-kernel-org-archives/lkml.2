Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab2EBNPh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 09:15:37 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:49037 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab2EBNPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 09:15:35 -0400
Message-ID: <4FA13352.4070303@linux.vnet.ibm.com>
Date: Wed, 02 May 2012 18:44:58 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Sameer Nanda <snanda@chromium.org>
CC: mingo@redhat.com, peterz@infradead.org, len.brown@intel.com, pavel@ucw.cz,
        rjw@sisk.pl, akpm@linux-foundation.org, dzickus@redhat.com,
        msb@chromium.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, olofj@chromium.org
Subject: Re: [PATCH] watchdog: fix for lockup detector breakage on resume
References: <1335550240-17765-1-git-send-email-snanda@chromium.org> <4F9E2D3D.3000000@linux.vnet.ibm.com> <CANMivWatpcxEern4B6ekxn2K1zvZVsF-WWq7nY5omq=91OYBYQ@mail.gmail.com>
In-Reply-To: <CANMivWatpcxEern4B6ekxn2K1zvZVsF-WWq7nY5omq=91OYBYQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12050213-2674-0000-0000-0000043E9F12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2012 02:40 AM, Sameer Nanda wrote:

> On Sun, Apr 29, 2012 at 11:12 PM, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> On 04/27/2012 11:40 PM, Sameer Nanda wrote:
>>
>>> On the suspend/resume path the boot CPU does not go though an
>>> offline->online transition.  This breaks the NMI detector
>>> post-resume since it depends on PMU state that is lost when
>>> the system gets suspended.
>>>
>>> Fix this by forcing a CPU offline->online transition for the
>>> lockup detector on the boot CPU during resume.
>>>
>>> Signed-off-by: Sameer Nanda <snanda@chromium.org>
>>> ---
>>> To provide more context, we enable NMI watchdog on
>>> Chrome OS.  We have seen several reports of systems freezing
>>> up completely which indicated that the NMI watchdog was not
>>> firing for some reason.
>>>
>>> Debugging further, we found a simple way of repro'ing system
>>> freezes -- issuing the command 'tasket 1 sh -c "echo nmilockup > /proc/breakme"'
>>> after the system has been suspended/resumed one or more times.
>>>
>>> With this patch in place, the system freeze result in panics,
>>> as expected.  These panics provide a nice stack trace for us
>>> to debug the actual issue causing the freeze.
>>>
>>>
>>>  include/linux/sched.h  |    4 ++++
>>>  kernel/power/suspend.c |    3 +++
>>>  kernel/watchdog.c      |   16 ++++++++++++++++
>>>  3 files changed, 23 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>>> index 81a173c..118cc38 100644
>>> --- a/include/linux/sched.h
>>> +++ b/include/linux/sched.h
>>> @@ -317,6 +317,7 @@ extern int proc_dowatchdog_thresh(struct ctl_table *table, int write,
>>>                                 size_t *lenp, loff_t *ppos);
>>>  extern unsigned int  softlockup_panic;
>>>  void lockup_detector_init(void);
>>> +void lockup_detector_bootcpu_resume(void);
>>>  #else
>>>  static inline void touch_softlockup_watchdog(void)
>>>  {
>>> @@ -330,6 +331,9 @@ static inline void touch_all_softlockup_watchdogs(void)
>>>  static inline void lockup_detector_init(void)
>>>  {
>>>  }
>>> +static inline void lockup_detector_bootcpu_resume(void)
>>> +{
>>> +}
>>>  #endif
>>>
>>>  #ifdef CONFIG_DETECT_HUNG_TASK
>>> diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
>>> index 396d262..0d262a8 100644
>>> --- a/kernel/power/suspend.c
>>> +++ b/kernel/power/suspend.c
>>> @@ -177,6 +177,9 @@ static int suspend_enter(suspend_state_t state, bool *wakeup)
>>>       arch_suspend_enable_irqs();
>>>       BUG_ON(irqs_disabled());
>>>
>>> +     /* Kick the lockup detector */
>>> +     lockup_detector_bootcpu_resume();
>>> +
>>>   Enable_cpus:
>>>       enable_nonboot_cpus();
>>>
>>> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
>>> index df30ee0..dd2ac93 100644
>>> --- a/kernel/watchdog.c
>>> +++ b/kernel/watchdog.c
>>> @@ -585,6 +585,22 @@ static struct notifier_block __cpuinitdata cpu_nfb = {
>>>       .notifier_call = cpu_callback
>>>  };
>>>
>>> +void lockup_detector_bootcpu_resume(void)
>>> +{
>>> +     void *cpu = (void *)(long)smp_processor_id();
>>> +
>>> +     /*
>>> +      * On the suspend/resume path the boot CPU does not go though the
>>> +      * offline->online transition. This breaks the NMI detector post
>>> +      * resume. Force an offline->online transition for the boot CPU on
>>> +      * resume.
>>> +      */
>>> +     cpu_callback(&cpu_nfb, CPU_DEAD, cpu);
>>> +     cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
>>> +
>>
>>
>> I have a couple of comments about this:
>>


[...]

>>
>> 3. How about hibernation? We don't hit this problem there?
> 
> I am not too familiar with hibernation path and don't have a setup to
> test it either so can't really answer this one.
> 


I tested this issue with hibernation, and I found that this problem doesn't occur
in that case! And since the paths (atleast related to CPU hotplug) are identical
in both the cases (suspend/hibernation), I decided to dig a bit more to understand
what is really happening underneath, just in case there is more to this problem
than what your patch addresses, or if the root cause is something different...

Anyway, I found a couple of things (see below), though I couldn't put them
together to fully explain the observed events.

1. perf_event_exit_cpu(boot-cpu) present in hibernation, missing in suspend path:
   ------------------------------------------------------------------------------

   In the case of hibernation, we ultimately power off the machine (noticeably
   different from suspend). And all the functions that lead to poweroff/halt/
   reboot, end up calling the callbacks registered with the reboot_notifier.
   (kernel/sys.c)

   And perf registers a callback to this, (perf_reboot(), kernel/events/core.c)
   which does:
	for_each_online_cpu(cpu)
		perf_event_exit_cpu(cpu);

   Note that we are doing this for *all* cpus, including the boot cpu. (In fact,
   if we come here from hibernate path, the only cpu online at the point is the
   boot cpu.)

   So calling perf_event_exit_cpu() for the boot cpu is one of the things that
   we miss in the suspend path. For the non-boot cpus, the CPU hotplug callback
   perf_cpu_notify() will call this function anyway.

   [By the way, I couldn't figure out where perf_event_init_cpu() is done for
   the boot cpu in the restore path of hibernation.]

2. perf_cpu_notify() has higher priority than watchdog's cpu_callback():
   --------------------------------------------------------------------

   Apart from the priority difference, the former listens to CPU_DOWN_PREPARE
   (early phase of CPU offline), but the latter listens to CPU_DEAD (later
   phase of CPU offline).

   And what all this means is that, for non-boot cpus, we call
   perf_event_exit_cpu() first, and only then call watchdog_disable()->
   watchdog_nmi_disable()->perf_event_disable().

   I don't know the implication of that ordering, but it did look a bit weird..


Do the above observations ring a bell to anyone?

Regards,
Srivatsa S. Bhat

