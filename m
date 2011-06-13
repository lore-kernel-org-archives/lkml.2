Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416Ab1FMUtN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 16:49:13 -0400
Received: from mga03.intel.com ([143.182.124.21]:57790 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156Ab1FMUtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 16:49:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,360,1304319600"; 
   d="scan'208";a="12101410"
Subject: Re: [patch v4 1/2] stop_machine: enable __stop_machine() to be
 called from the cpu online path
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "trenn@novell.com" <trenn@novell.com>,
        "prarit@redhat.com" <prarit@redhat.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Song, Youquan" <youquan.song@intel.com>,
        "stable@kernel.org" <stable@kernel.org>
In-Reply-To: <20110613195613.GA11196@elte.hu>
References: <20110613175832.331826123@sbsiddha-MOBL3.sc.intel.com>
	 <20110613175915.504721985@sbsiddha-MOBL3.sc.intel.com>
	 <20110613195613.GA11196@elte.hu>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 13 Jun 2011 13:49:18 -0700
Message-Id: <1307998158.2682.33.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-13 at 12:56 -0700, Ingo Molnar wrote:
> * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> 
> >  include/linux/stop_machine.h |   11 +++--
> >  kernel/stop_machine.c        |   91 ++++++++++++++++++++++++++++++++++++++++---
> >  2 files changed, 93 insertions(+), 9 deletions(-)
> 
> Btw., this is *way* too risky for a -stable backport.
> 

Ingo, we can have a smaller patch (appended) for the -stable. How do you
want to go ahead? Take this small patch for both mainline and -stable
and the two code cleanup/consolidation patches for -tip (to go into
3.1?). Thanks.

---
From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86, mtrr: lock stop machine during MTRR rendezvous sequence

MTRR rendezvous sequence using stop_one_cpu_nowait() can potentially
happen in parallel with another system wide rendezvous using
stop_machine(). This can lead to deadlock (The order in which
works are queued can be different on different cpu's. Some cpu's
will be running the first rendezvous handler and others will be running
the second rendezvous handler. Each set waiting for the other set to join
for the system wide rendezvous, leading to a deadlock).

MTRR rendezvous sequence is not implemented using stop_machine() as this
gets called both from the process context aswell as the cpu online paths
(where the cpu has not come online and the interrupts are disabled etc).
stop_machine() works with only online cpus.

For now, take the stop_cpus mutex in the MTRR rendezvous sequence that
prevents the above mentioned deadlock. If this gets called in the cpu
online path, then we loop using try_lock. Otherwise we wait till the
mutex is available.

    TBD: Extend the stop_machine() infrastructure to handle the case where
         the calling cpu is still not online and use this for MTRR rendezvous
         sequence (rather than implementing own stop machine using
         stop_one_cpu_nowait()). This will consolidate the code.

fixes: https://bugzilla.novell.com/show_bug.cgi?id=672008
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: stable@kernel.org    # v2.6.35 - v2.6.39
---
 arch/x86/kernel/cpu/mtrr/main.c |   15 ++++++++++++++-
 include/linux/stop_machine.h    |   17 +++++++++++++++++
 kernel/stop_machine.c           |   15 +++++++++++++++
 3 files changed, 46 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 929739a..1e99048 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -244,9 +244,21 @@ static inline int types_compatible(mtrr_type type1, mtrr_type type2)
 static void
 set_mtrr(unsigned int reg, unsigned long base, unsigned long size, mtrr_type type)
 {
+	int cpu = raw_smp_processor_id();
+	int online = cpu_online(cpu);
 	struct set_mtrr_data data;
 	unsigned long flags;
-	int cpu;
+
+	/*
+	 * If we are not yet online, then loop using the try lock, as we
+	 * can't sleep.
+	 */
+	if (online) {
+		lock_stop_cpus();
+	} else {
+		while (!try_lock_stop_cpus())
+			cpu_relax();
+	}
 
 	preempt_disable();
 
@@ -330,6 +342,7 @@ set_mtrr(unsigned int reg, unsigned long base, unsigned long size, mtrr_type typ
 
 	local_irq_restore(flags);
 	preempt_enable();
+	unlock_stop_cpus();
 }
 
 /**
diff --git a/include/linux/stop_machine.h b/include/linux/stop_machine.h
index 092dc9b..8a28d4c 100644
--- a/include/linux/stop_machine.h
+++ b/include/linux/stop_machine.h
@@ -33,6 +33,10 @@ void stop_one_cpu_nowait(unsigned int cpu, cpu_stop_fn_t fn, void *arg,
 int stop_cpus(const struct cpumask *cpumask, cpu_stop_fn_t fn, void *arg);
 int try_stop_cpus(const struct cpumask *cpumask, cpu_stop_fn_t fn, void *arg);
 
+void lock_stop_cpus(void);
+int try_lock_stop_cpus(void);
+void unlock_stop_cpus(void);
+
 #else	/* CONFIG_SMP */
 
 #include <linux/workqueue.h>
@@ -88,6 +92,19 @@ static inline int try_stop_cpus(const struct cpumask *cpumask,
 	return stop_cpus(cpumask, fn, arg);
 }
 
+static inline void lock_stop_cpus(void)
+{
+}
+
+static inline try_lock_stop_cpus(void)
+{
+	return 1;
+}
+
+static inline void unlock_stop_cpus(void)
+{
+}
+
 #endif	/* CONFIG_SMP */
 
 /*
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index e3516b2..d239a48 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -136,6 +136,21 @@ void stop_one_cpu_nowait(unsigned int cpu, cpu_stop_fn_t fn, void *arg,
 static DEFINE_MUTEX(stop_cpus_mutex);
 static DEFINE_PER_CPU(struct cpu_stop_work, stop_cpus_work);
 
+void lock_stop_cpus(void)
+{
+	mutex_lock(&stop_cpus_mutex);
+}
+
+int try_lock_stop_cpus(void)
+{
+	return mutex_trylock(&stop_cpus_mutex);
+}
+
+void unlock_stop_cpus(void)
+{
+	mutex_unlock(&stop_cpus_mutex);
+}
+
 int __stop_cpus(const struct cpumask *cpumask, cpu_stop_fn_t fn, void *arg)
 {
 	struct cpu_stop_work *work;


