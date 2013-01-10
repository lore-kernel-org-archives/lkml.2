Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab3AJR1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 12:27:32 -0500
Received: from mail-vb0-f53.google.com ([209.85.212.53]:41010 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab3AJR1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 12:27:31 -0500
MIME-Version: 1.0
In-Reply-To: <20130110140215.GP88797@redhat.com>
References: <1357783059-13923-1-git-send-email-ccross@android.com>
	<20130110140215.GP88797@redhat.com>
Date: Thu, 10 Jan 2013 09:27:28 -0800
X-Google-Sender-Auth: QOFXfKIs8YxUROYUGWWvgDHCESk
Message-ID: <CAMbhsRT7q+DSKOdPMtUqtPZJrB_z-ixmv09TkT2ZweUJGXjkYg@mail.gmail.com>
Subject: Re: [PATCH] hardlockup: detect hard lockups without NMIs using
 secondary cpus
From: Colin Cross <ccross@android.com>
To: Don Zickus <dzickus@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        liu chuansheng <chuansheng.liu@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 6:02 AM, Don Zickus <dzickus@redhat.com> wrote:
> On Wed, Jan 09, 2013 at 05:57:39PM -0800, Colin Cross wrote:
>> Emulate NMIs on systems where they are not available by using timer
>> interrupts on other cpus.  Each cpu will use its softlockup hrtimer
>> to check that the next cpu is processing hrtimer interrupts by
>> verifying that a counter is increasing.
>>
>> This patch is useful on systems where the hardlockup detector is not
>> available due to a lack of NMIs, for example most ARM SoCs.
>
> I have seen other cpus, like Sparc I think, create a 'virtual NMI' by
> reserving an IRQ line as 'special' (can not be masked).  Not sure if that
> is something worth looking at here (or even possible).
>
>> Without this patch any cpu stuck with interrupts disabled can
>> cause a hardware watchdog reset with no debugging information,
>> but with this patch the kernel can detect the lockup and panic,
>> which can result in useful debugging info.
>
> <SNIP>
>> +#ifdef CONFIG_HARDLOCKUP_DETECTOR_OTHER_CPU
>> +static int is_hardlockup_other_cpu(int cpu)
>> +{
>> +     unsigned long hrint = per_cpu(hrtimer_interrupts, cpu);
>> +
>> +     if (per_cpu(hrtimer_interrupts_saved, cpu) == hrint)
>> +             return 1;
>> +
>> +     per_cpu(hrtimer_interrupts_saved, cpu) = hrint;
>> +     return 0;
>
> Will this race with the other cpu you are checking?  For example if cpuA
> just updated its hrtimer_interrupts_saved and cpuB goes to check cpuA's
> hrtimer_interrupts_saved, it seems possible that cpuB could falsely assume
> cpuA is stuck?

cpuA doesn't update its own hrtimer_interrupts_saved, cpuB does.
However, there may be a similar race condition during hotplug if cpuB
updates hrtimer_interrupts_saved for cpuA, then goes offline, then
cpuC may try to check cpuA and see that hrtimer_interrupts_saved ==
hrtimer_interrupts.  I think this can be solved by setting
watchdog_nmi_touch for the next cpu when a cpu goes online or offline.

>> +}
>> +
>> +static void watchdog_check_hardlockup_other_cpu(void)
>> +{
>> +     int cpu;
>> +     cpumask_t cpus = watchdog_cpus;
>> +
>> +     /*
>> +      * Test for hardlockups every 3 samples.  The sample period is
>> +      *  watchdog_thresh * 2 / 5, so 3 samples gets us back to slightly over
>> +      *  watchdog_thresh (over by 20%).
>> +      */
>> +     if (__this_cpu_read(hrtimer_interrupts) % 3 != 0)
>> +             return;
>> +
>> +     /* check for a hardlockup on the next cpu */
>> +     cpu = cpumask_next(smp_processor_id(), &cpus);
>> +     if (cpu >= nr_cpu_ids)
>> +             cpu = cpumask_first(&cpus);
>> +     if (cpu == smp_processor_id())
>> +             return;
>> +
>> +     smp_rmb();
>> +
>> +     if (per_cpu(watchdog_nmi_touch, cpu) == true) {
>> +             per_cpu(watchdog_nmi_touch, cpu) = false;
>> +             return;
>> +     }
>
> Same race here.  Usually touch_nmi_watchdog is reserved for those
> functions that plan on disabling interrupts for a while.  cpuB could set
> cpuA's watchdog_nmi_touch to false here expecting not to revisit this
> variable for another couple of seconds.  While cpuA could read this
> variable milliseconds later after cpuB sets it and falsely assume there is
> a lockup?
>
> Perhaps I am misreading the code?

Again, cpuA won't ever read its own watchdog_nmi_touch variable, only
cpuB will.  The only variables cpuA updates for itself is
hrtimer_interrupts or setting watchdog_nmi_touch to true.
hrtimer_interrupts_saved and setting watchdog_nmi_touch to false are
done by the cpu watching over cpuA, so the only races here are when a
cpu goes offline and a different cpu starts watching over cpuA.

> If not, I don't have a good idea on how to solve those races off the top of my
> head unfortunately.
>
> Cheers,
> Don
