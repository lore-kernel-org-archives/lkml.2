Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768423Ab2KOQeZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 11:34:25 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7695 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768379Ab2KOQeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 11:34:24 -0500
X-Authority-Analysis: v=2.0 cv=RoZH3VaK c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=v5fOPXkIllYA:10 a=5SG0PmZfjMsA:10 a=meVymXHHAAAA:8 a=ixYdKLBgGroA:10 a=o-RHzntQwqEBh4fBt6UA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=6AgDQR8ta8Vxumq6:21 a=qUPmYXXoyZothu-F:21 a=iBNTGSllyEE1Yx3TxE4A:9 a=JFa3CwtW8oiR4lHl:21 a=E0lpJXrG-3t1vDRp:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1352997261.18025.103.camel@gandalf.local.home>
Subject: [PATCH RFC] irq_work: Flush work on CPU_DYING (was: Re: [PATCH 7/7]
 printk: Wake up klogd using irq_work)
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Thu, 15 Nov 2012 11:34:21 -0500
In-Reply-To: <CAFTL4hzzhd5__VwR7N+VKpq1C27xHGgi4vj87drbcLghJ+Od5g@mail.gmail.com>
References: <1352925457-15700-1-git-send-email-fweisbec@gmail.com>
	 <1352925457-15700-8-git-send-email-fweisbec@gmail.com>
	 <1352953617.18025.94.camel@gandalf.local.home>
	 <CAFTL4hzzhd5__VwR7N+VKpq1C27xHGgi4vj87drbcLghJ+Od5g@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-UVcIRQuXXn0dawUs+xgu"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-UVcIRQuXXn0dawUs+xgu
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit

On Thu, 2012-11-15 at 16:25 +0100, Frederic Weisbecker wrote:
> 2012/11/15 Steven Rostedt <rostedt@goodmis.org>:
> > On Wed, 2012-11-14 at 21:37 +0100, Frederic Weisbecker wrote:
> >> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> >> index f249e8c..822d757 100644
> >> --- a/kernel/time/tick-sched.c
> >> +++ b/kernel/time/tick-sched.c
> >> @@ -289,7 +289,7 @@ static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
> >>               time_delta = timekeeping_max_deferment();
> >>       } while (read_seqretry(&xtime_lock, seq));
> >>
> >> -     if (rcu_needs_cpu(cpu, &rcu_delta_jiffies) || printk_needs_cpu(cpu) ||
> >> +     if (rcu_needs_cpu(cpu, &rcu_delta_jiffies) ||
> >
> > If the CPU is going offline, the printk_tick() would be executed here.
> > But now that printk_tick() is done with the irq_work code, it wont be
> > executed till the next tick.  Could this cause a missed printk because
> > of this, if the cpu is going offline?
> >
> > Actually, how does irq_work in general handle cpu offline work?
> 
> Good point, and that's not trivial to solve.
> 
> The hotplug down sequence does:
> 
> ----->
> CPU that offilines                                          CPU offlining
> -----------------
> ---------------------
> cpu_down() {
>     __stop_machine(take_cpu_down)
> 
> take_cpu_down() {
> 
> __cpu_disable() {
> 
>     * disable irqs in hw
> 
>     * clear from online mask
>                                                                        }
> 
> move all tasks somewhere
>                                                                    }
> while (!idle_cpu(offlining))
>     cpu_relax()
> 
> cpu_die();
> <---------
> 
> So the offlining CPU goes to idle in the end once irqs are disabled in
> the apic level. Does that include the timer tick? If so then the last
> resort to offline without irq works in the queue is to make
> take_cpu_down() ask for a retry if there are pending irq works during
> its execution.
> 
> Now if we have printk() calls between __cpu_disable() and the idle
> loop, they will be lost until the next onlining. Unless we do an
> explicit call to printk_tick() from the idle loop if the CPU is
> offline.
> 
> Note that !CONFIG_NO_HZ doesn't seem to handle that. Which makes me
> wonder if the tick is really part of the whole IRQ disablement done in
> __cpu_disable().


How about flushing all irq_work from CPU_DYING. The notifier is called
by stop_machine on the CPU that is going down. Grant you, the code will
not be called from irq context (so things like get_irq_regs() wont work)
but I'm not sure what the requirements are for irq_work in that regard
(Peter?). But irqs are disabled and the CPU is about to go offline.
Might as well flush the work.

I ran this against my stress_cpu_hotplug script (attached) and it seemed
to work fine. I even did a:

  perf record ./stress-cpu-hotplug

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-rt.git/kernel/irq_work.c
===================================================================
--- linux-rt.git.orig/kernel/irq_work.c
+++ linux-rt.git/kernel/irq_work.c
@@ -14,6 +14,7 @@
 #include <linux/irqflags.h>
 #include <linux/sched.h>
 #include <linux/tick.h>
+#include <linux/cpu.h>
 #include <asm/processor.h>
 
 
@@ -105,11 +106,7 @@ bool irq_work_needs_cpu(void)
 	return true;
 }
 
-/*
- * Run the irq_work entries on this cpu. Requires to be ran from hardirq
- * context with local IRQs disabled.
- */
-void irq_work_run(void)
+static void __irq_work_run(void)
 {
 	unsigned long flags;
 	struct irq_work *work;
@@ -128,7 +125,6 @@ void irq_work_run(void)
 	if (llist_empty(this_list))
 		return;
 
-	BUG_ON(!in_irq());
 	BUG_ON(!irqs_disabled());
 
 	llnode = llist_del_all(this_list);
@@ -155,8 +151,23 @@ void irq_work_run(void)
 		(void)cmpxchg(&work->flags, flags, flags & ~IRQ_WORK_BUSY);
 	}
 }
+
+/*
+ * Run the irq_work entries on this cpu. Requires to be ran from hardirq
+ * context with local IRQs disabled.
+ */
+void irq_work_run(void)
+{
+	BUG_ON(!in_irq());
+	__irq_work_run();
+}
 EXPORT_SYMBOL_GPL(irq_work_run);
 
+static void irq_work_run_cpu_down(void)
+{
+	__irq_work_run();
+}
+
 /*
  * Synchronize against the irq_work @entry, ensures the entry is not
  * currently in use.
@@ -169,3 +180,35 @@ void irq_work_sync(struct irq_work *work
 		cpu_relax();
 }
 EXPORT_SYMBOL_GPL(irq_work_sync);
+
+#ifdef CONFIG_HOTPLUG_CPU
+static int irq_work_cpu_notify(struct notifier_block *self,
+			       unsigned long action, void *hcpu)
+{
+	long cpu = (long)hcpu;
+
+	switch (action) {
+	case CPU_DYING:
+		/* Called from stop_machine */
+		if (WARN_ON_ONCE(cpu != smp_processor_id()))
+			break;
+		irq_work_run_cpu_down();
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block cpu_notify;
+
+static __init int irq_work_init_cpu_notifier(void)
+{
+	cpu_notify.notifier_call = irq_work_cpu_notify;
+	cpu_notify.priority = 0;
+	register_cpu_notifier(&cpu_notify);
+	return 0;
+}
+device_initcall(irq_work_init_cpu_notifier);
+
+#endif /* CONFIG_HOTPLUG_CPU */


--=-UVcIRQuXXn0dawUs+xgu
Content-Type: application/x-shellscript; name="stress-cpu-hotplug"
Content-Disposition: attachment; filename="stress-cpu-hotplug"
Content-Transfer-Encoding: 7bit

#!/bin/bash

MAXCPUS=12

# find cpus

CPUS=`ls -d /sys/devices/system/cpu/cpu[1-9]*`
NR=`echo $CPUS | wc -w`

let x=0
for cpu in $CPUS; do
    file=$cpu/online
    CPUONLINE[$x]=$file
    ENB[$x]=`cat $file`
    CPU[$x]=`basename $cpu`
    let x=$x+1
done

let MAXCNT=$x

MSKCNT=$MAXCNT

if [ $MAXCNT -gt $MAXCPUS ]; then
    MSKCNT=$MAXCPUS
fi

let MSKCNT=2**$MSKCNT

hotplug() {
    MSK=$1
    ECHO="$MSK"
    CMD=""
    x=0
    while [ $MSK -gt 0 ]; do
	let bit=$MSK'&'1
	if [ $bit -eq 1 ]; then
	    if [ ${ENB[$x]} -eq 1 ]; then
		cmd="disabling"
		ENB[$x]=0
		num=0
	    else
		cmd="enabling"
		ENB[$x]=1
		num=1
	    fi
	    CMD="$CMD echo $num > ${CPUONLINE[$x]};"
	    ECHO="$ECHO $cmd ${CPU[$x]}"
	fi
	let x=$x+1
	let MSK=$MSK'>>'1
    done
    echo $ECHO
    eval $CMD
}

let MSKCNT=$MSKCNT-1
for i in `seq $MSKCNT`; do
    hotplug $i
done
for i in `seq $MSKCNT`; do
    hotplug $i
done

exit 0

--=-UVcIRQuXXn0dawUs+xgu--

