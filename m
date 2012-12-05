Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095Ab2LEUPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 15:15:49 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:48525 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277Ab2LEUPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 15:15:47 -0500
Message-ID: <50BFAB17.3090603@linux.vnet.ibm.com>
Date: Thu, 06 Dec 2012 01:44:15 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: tj@kernel.org, oleg@redhat.com
CC: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, tglx@linutronix.de,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org, sbw@mit.edu,
        amit.kucheria@linaro.org, rostedt@goodmis.org, rjw@sisk.pl,
        wangyun@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 01/10] CPU hotplug: Provide APIs for "light" atomic
 readers to prevent CPU offline
References: <20121205184041.3750.64945.stgit@srivatsabhat.in.ibm.com> <20121205184258.3750.31879.stgit@srivatsabhat.in.ibm.com> <50BF96DF.3000500@linux.vnet.ibm.com> <50BF979A.50304@linux.vnet.ibm.com> <50BF982D.7090704@linux.vnet.ibm.com> <50BF98F7.3030600@linux.vnet.ibm.com> <50BF999C.6030707@linux.vnet.ibm.com>
In-Reply-To: <50BF999C.6030707@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120520-2000-0000-0000-00000A251315
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Replaying what Tejun wrote:
> 
> Hello, Oleg.
> 
>> Replaying what Oleg wrote:
>>> Replacing get_online_cpus() w/ percpu_rwsem is great but this thread
>>> is about replacing preempt_disable with something finer grained and
>>> less heavy on the writer side
>>
>> If only I understood why preempt_disable() is bad ;-)
>>
>> OK, I guess "less heavy on the writer side" is the hint, and in the
>> previous email you mentioned that "stop_machine() itself is extremely
>> heavy".
>>
>> Looks like, you are going to remove stop_machine() from cpu_down ???
>>
> 
> Yeah, that's what Srivatsa is trying to do.  The problem seems to be
> that cpu up/down is very frequent on certain mobile platforms for
> power management and as currently implemented cpu hotplug is too heavy
> and latency-inducing.
>   
>>> The problem seems that we don't have percpu_rwlock yet.  It shouldn't
>>> be too difficult to implement, right?
>>>
>>
>> Oh, I am not sure... unless you simply copy-and-paste the lglock code
>> and replace spinlock_t with rwlock_t.
>>
> 
> Ah... right, so that's where brlock ended up.  So, lglock is the new
> thing and brlock is a wrapper around it.
> 
>> We probably want something more efficient, but I bet we can't avoid
>> the barriers on the read side.
>>
>> And somehow we should avoid the livelocks. Say, we can't simply add
>> the per_cpu_reader_counter, _read_lock should spin if the writer is
>> active. But at the same time _read_lock should be recursive.
>>
> 
> I think we should just go with lglock.  It does involve local atomic
> ops but atomic ops themselves aren't that expensive and it's not like
> we can avoid memory barriers.  Also, that's the non-sleeping
> counterpart of percpu_rwsem.  If it's not good enough for some reason,
> we should improve it rather than introducing something else.
> 

While working on the v2 yesterday, I had actually used rwlocks for
the light readers and atomic ops for the full-readers. (Later I changed
both to rwlocks while posting this v2). Anyway, the atomic ops version
looked something like shown below.

I'll take a look at lglocks and see if that helps in our case.

Regards,
Srivatsa S. Bhat


---

 include/linux/cpu.h |    4 ++
 kernel/cpu.c        |   98 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 102 insertions(+)


diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index c64b6ed..5011c7d 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -177,6 +177,8 @@ extern void get_online_cpus(void);
 extern void put_online_cpus(void);
 extern void get_online_cpus_stable_atomic(void);
 extern void put_online_cpus_stable_atomic(void);
+extern void get_online_cpus_atomic(void);
+extern void put_online_cpus_atomic(void);
 #define hotcpu_notifier(fn, pri)	cpu_notifier(fn, pri)
 #define register_hotcpu_notifier(nb)	register_cpu_notifier(nb)
 #define unregister_hotcpu_notifier(nb)	unregister_cpu_notifier(nb)
@@ -202,6 +204,8 @@ static inline void cpu_hotplug_driver_unlock(void)
 #define put_online_cpus()	do { } while (0)
 #define get_online_cpus_stable_atomic()	do { } while (0)
 #define put_online_cpus_stable_atomic()	do { } while (0)
+#define get_online_cpus_atomic()	do { } while (0)
+#define put_online_cpus_atomic()	do { } while (0)
 #define hotcpu_notifier(fn, pri)	do { (void)(fn); } while (0)
 /* These aren't inline functions due to a GCC bug. */
 #define register_hotcpu_notifier(nb)	({ (void)(nb); 0; })
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 8c9eecc..76b07f7 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -19,6 +19,7 @@
 #include <linux/mutex.h>
 #include <linux/gfp.h>
 #include <linux/suspend.h>
+#include <linux/atomic.h>
 
 #include "smpboot.h"
 
@@ -104,6 +105,58 @@ void put_online_cpus_stable_atomic(void)
 }
 EXPORT_SYMBOL_GPL(put_online_cpus_stable_atomic);
 
+static DEFINE_PER_CPU(atomic_t, atomic_reader_refcount);
+
+#define writer_active(v)	((v) < 0)
+#define reader_active(v)	((v) > 0)
+
+/*
+ * Invoked by hotplug reader, to prevent CPUs from going offline.
+ * Increments its per-cpu 'atomic_reader_refcount' to mark itself as being
+ * active.
+ *
+ * If 'atomic_reader_refcount' is negative, it means that a CPU offline
+ * operation is in progress (hotplug writer). Wait for it to complete
+ * and then mark your presence (increment the count) and return.
+ *
+ * You can call this recursively, because it doesn't hold any locks.
+ *
+ * Returns with preemption disabled.
+ */
+void get_online_cpus_atomic(void)
+{
+	int c, old;
+
+	preempt_disable();
+	read_lock(&hotplug_rwlock);
+
+	for (;;) {
+		c = atomic_read(&__get_cpu_var(atomic_reader_refcount));
+		if (unlikely(writer_active(c))) {
+			cpu_relax();
+			continue;
+		}
+
+		old = atomic_cmpxchg(&__get_cpu_var(atomic_reader_refcount),
+				     c, c + 1);
+
+		if (likely(old == c))
+			break;
+
+		c = old;
+	}
+}
+EXPORT_SYMBOL_GPL(get_online_cpus_atomic);
+
+void put_online_cpus_atomic(void)
+{
+	atomic_dec(&__get_cpu_var(atomic_reader_refcount));
+	smp_mb__after_atomic_dec();
+	read_unlock(&hotplug_rwlock);
+	preempt_enable();
+}
+EXPORT_SYMBOL_GPL(put_online_cpus_atomic);
+
 static struct {
 	struct task_struct *active_writer;
 	struct mutex lock; /* Synchronizes accesses to refcount, */
@@ -292,6 +345,42 @@ static inline void check_for_tasks(int cpu)
 	write_unlock_irq(&tasklist_lock);
 }
 
+/*
+ * Invoked by hotplug writer, in preparation to take a CPU offline.
+ * Decrements the per-cpu 'atomic_reader_refcount' to mark itself as being
+ * active.
+ *
+ * If 'atomic_reader_refcount' is positive, it means that there are active
+ * hotplug readers (those that prevent hot-unplug). Wait for them to complete
+ * and then mark your presence (decrement the count) and return.
+ */
+static void disable_atomic_reader(unsigned int cpu)
+{
+	int c, old;
+
+	for (;;) {
+		c = atomic_read(&per_cpu(atomic_reader_refcount, cpu));
+		if (likely(reader_active(c))) {
+			cpu_relax();
+			continue;
+		}
+
+		old = atomic_cmpxchg(&per_cpu(atomic_reader_refcount, cpu),
+				     c, c - 1);
+
+		if (likely(old == c))
+			break;
+
+		c = old;
+	}
+}
+
+static void enable_atomic_reader(unsigned int cpu)
+{
+	atomic_inc(&per_cpu(atomic_reader_refcount, cpu));
+	smp_mb__after_atomic_inc();
+}
+
 struct take_cpu_down_param {
 	unsigned long mod;
 	void *hcpu;
@@ -302,6 +391,7 @@ static int __ref take_cpu_down(void *_param)
 {
 	struct take_cpu_down_param *param = _param;
 	unsigned long flags;
+	unsigned int cpu;
 	int err;
 
 	/*
@@ -317,6 +407,10 @@ static int __ref take_cpu_down(void *_param)
 		return err;
 	}
 
+	/* Disable the atomic hotplug readers who need full synchronization */
+	for_each_online_cpu(cpu)
+		disable_atomic_reader(cpu);
+
 	/*
 	 * We have successfully removed the CPU from the cpu_online_mask.
 	 * So release the lock, so that the light-weight atomic readers (who care
@@ -330,6 +424,10 @@ static int __ref take_cpu_down(void *_param)
 
 	cpu_notify(CPU_DYING | param->mod, param->hcpu);
 
+	/* Enable the atomic hotplug readers who need full synchronization */
+	for_each_online_cpu(cpu)
+		enable_atomic_reader(cpu);
+
 	local_irq_restore(flags);
 	return 0;
 }

