Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab3ADNYX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 08:24:23 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:60998 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab3ADNYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 08:24:21 -0500
MIME-Version: 1.0
In-Reply-To: <1356938303.16700.23.camel@ThinkPad-T5421.cn.ibm.com>
References: <1356799386-4212-1-git-send-email-fweisbec@gmail.com>
	<1356799386-4212-7-git-send-email-fweisbec@gmail.com>
	<1356938303.16700.23.camel@ThinkPad-T5421.cn.ibm.com>
Date: Fri, 4 Jan 2013 14:24:19 +0100
Message-ID: <CAFTL4hympKcagG5hzat6emwbGOVRzvUN=pKq-UjpZ+bojFzzNw@mail.gmail.com>
Subject: Re: [PATCH 06/27] nohz: Basic full dynticks interface
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/31 Li Zhong <zhong@linux.vnet.ibm.com>:
> On Sat, 2012-12-29 at 17:42 +0100, Frederic Weisbecker wrote:
>> Start with a very simple interface to define full dynticks CPU:
>> use a boot time option defined cpumask through the "full_nohz="
>> kernel parameter.
>>
>> Make sure you keep at least one CPU outside this range to handle
>> the timekeeping.
>>
>> Also full_nohz= must match rcu_nocb= value.
>>
>> Suggested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: Alessio Igor Bogani <abogani@kernel.org>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Chris Metcalf <cmetcalf@tilera.com>
>> Cc: Christoph Lameter <cl@linux.com>
>> Cc: Geoff Levand <geoff@infradead.org>
>> Cc: Gilad Ben Yossef <gilad@benyossef.com>
>> Cc: Hakan Akkan <hakanakkan@gmail.com>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> ---
>>  include/linux/tick.h     |    7 +++++++
>>  kernel/time/Kconfig      |    9 +++++++++
>>  kernel/time/tick-sched.c |   23 +++++++++++++++++++++++
>>  3 files changed, 39 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/tick.h b/include/linux/tick.h
>> index 553272e..2d4f6f0 100644
>> --- a/include/linux/tick.h
>> +++ b/include/linux/tick.h
>> @@ -157,6 +157,13 @@ static inline u64 get_cpu_idle_time_us(int cpu, u64 *unused) { return -1; }
>>  static inline u64 get_cpu_iowait_time_us(int cpu, u64 *unused) { return -1; }
>>  # endif /* !NO_HZ */
>>
>> +#ifdef CONFIG_NO_HZ_FULL
>> +int tick_nohz_full_cpu(int cpu);
>> +#else
>> +static inline int tick_nohz_full_cpu(int cpu) { return 0; }
>> +#endif
>> +
>> +
>>  # ifdef CONFIG_CPU_IDLE_GOV_MENU
>>  extern void menu_hrtimer_cancel(void);
>>  # else
>> diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
>> index 8601f0d..dc6381d 100644
>> --- a/kernel/time/Kconfig
>> +++ b/kernel/time/Kconfig
>> @@ -70,6 +70,15 @@ config NO_HZ
>>         only trigger on an as-needed basis both when the system is
>>         busy and when the system is idle.
>>
>> +config NO_HZ_FULL
>> +       bool "Full tickless system"
>> +       depends on NO_HZ && RCU_USER_QS && VIRT_CPU_ACCOUNTING_GEN && RCU_NOCB_CPU && SMP
>
> Does that mean for archs like PPC64, which HAVE_VIRT_CPU_ACCOUNTING, to
> get NO_HZ_FULL supported, we need to use VIRT_CPU_ACCOUTING_GEN instead
> of VIRT_CPU_ACCOUNTING_NATIVE? ( I think the two, *_NATIVE and *_GEN,
> shouldn't be both enabled at the same time? )

Indeed! This sounds  silly in the first place but _GEN does a context
tracking that _NATIVE doesn't perform. And this context tracking must
also be well ordered and serialized against the cputime snapshots.
This is important when we remotely fix up the time from the read side.
ie: if we read the cputime of a task that runs tickless for some time,
we need to know where it runs (user or kernel) then pick either
tsk->utime or tsk->stime as a result and add to it the delta of time
it has been running tickless.

This fixup is performed in task_cputime() using seqlock() for
ordering/serializing. And the write side use seqlocks too from vtime
accounting APIs. But this is not handled by _NATIVE.

>
> When I tried it on a ppc64 machine, it seems that after I select
> VIRT_CPU_ACCOUNTING, VIRT_CPU_ACCOUNTING_NATIVE is automatically
> selected. And I have no way to enable VIRT_CPU_ACCOUTING_GEN, or disable
> VIRT_CPU_ACCOUNTING_NATIVE. It seems that's because these two don't have
> a configuration name (input prompt).

Yeah I need to fix that. The user should be able to choose between
VIRT_CPU_ACCOUTING_GEN and VIRT_CPU_ACCOUNTING_NATIVE.

I'll fix that for the next release.

>
>> +       select CONTEXT_TRACKING_FORCE
>> +       help
>> +         Try to be tickless everywhere, not just in idle. (You need
>> +      to fill up the full_nohz_mask boot parameter).
>
> Maybe it is better to use the name of the boot parameter full_nohz here
> than the name of the mask variable used in the code?
>

Right!

Thanks for your reviews!
