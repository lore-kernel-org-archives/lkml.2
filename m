Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913Ab2CBAdw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 19:33:52 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51857 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756069Ab2CBAdu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 19:33:50 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of venki@google.com designates 10.50.178.106 as permitted sender) smtp.mail=venki@google.com; dkim=pass header.i=venki@google.com
MIME-Version: 1.0
In-Reply-To: <20120223075027.GB15306@elte.hu>
References: <1329957415-15239-1-git-send-email-venki@google.com>
	<20120223075027.GB15306@elte.hu>
Date: Thu, 1 Mar 2012 16:33:49 -0800
Message-ID: <CABeCy1YeGjTAGKRwwaryY9bx9UwMq9nhGAsVV-o2QEjPH=4ErA@mail.gmail.com>
Subject: Re: [PATCH] Extend mwait idle to optimize away CAL and RES interrupts
 to an idle CPU -v1
From: Venki Pallipadi <venki@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Aaron Durbin <adurbin@google.com>, Paul Turner <pjt@google.com>,
        Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 11:50 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Venkatesh Pallipadi <venki@google.com> wrote:
>
>> * Do we need some accounting for these wakeups exported for powertop?
>
> If then tracepoints.
>
>> * We can also eliminate TS_POLLING flag in favor of this. But, that will have
>>   a lot more touchpoints and better done as a standlone change.
>
> Should most definitely be done for this series to be acceptble -
> as a preparatory patch in the series, with the feature at the
> end of the series.
>
>> +DECLARE_PER_CPU(atomic_t *, idle_task_ti_flags);
>
> That's ugly, we should access the idle task's ti flags directly.
>
> To have efficient percpu access to the idle threads another
> clean-up is needed: we should turn idle_thread_array into a
> full-structure PER_CPU area.
>
> For that we need a small variant of fork_idle(), which does not
> dup the init thread - pretty trivial.

OK. I looked a bit deeper into this and I understand what you suggested above.

>
> fork_idle() should also make sure it does not schedule the child
> thread: thus we'd also be able to further simplify smpboot.c and
> get rid of all that extremely ugly 'struct create_idle'
> gymnastics in smpboot.c.

But not this. I am not sure where fork_idle results in resched of the child.
As I saw it, fork_idle calls init_idle and that sets the affinity of
idle_task to target CPU. So, reschedule should not be a problem. What
am I missing here?

Also, I tried this silly test patch (Cut and paste... Sorry) and it
seemed to work fine both with and without CPU hotplug.

Thanks,
Venki

---
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 66d250c..36b80ef 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -686,7 +686,7 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu)
                .done   = COMPLETION_INITIALIZER_ONSTACK(c_idle.done),
        };

-       INIT_WORK_ONSTACK(&c_idle.work, do_fork_idle);
+       // INIT_WORK_ONSTACK(&c_idle.work, do_fork_idle);

        alternatives_smp_switch(1);

@@ -703,12 +703,13 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu)
                goto do_rest;
        }

-       schedule_work(&c_idle.work);
-       wait_for_completion(&c_idle.done);
+       // schedule_work(&c_idle.work);
+       // wait_for_completion(&c_idle.done);
+       c_idle.idle = fork_idle(cpu);

        if (IS_ERR(c_idle.idle)) {
                printk("failed fork for CPU %d\n", cpu);
-               destroy_work_on_stack(&c_idle.work);
+               // destroy_work_on_stack(&c_idle.work);
                return PTR_ERR(c_idle.idle);
        }

@@ -831,7 +832,7 @@ do_rest:
                smpboot_restore_warm_reset_vector();
        }

-       destroy_work_on_stack(&c_idle.work);
+       // destroy_work_on_stack(&c_idle.work);
        return boot_error;
 }

---

>
> Thanks,
>
>        Ingo
