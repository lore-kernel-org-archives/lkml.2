Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758610Ab2CAIP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 03:15:29 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:48763 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756628Ab2CAIP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 03:15:26 -0500
Message-ID: <4F4F3014.50901@linux.vnet.ibm.com>
Date: Thu, 01 Mar 2012 13:45:16 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: sparclinux@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Nick Piggin <npiggin@kernel.dk>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "David S. Miller" <davem@davemloft.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/3] CPU hotplug: Fix issues with callback registration
References: <87ehtf3lqh.fsf@rustcorp.com.au> <20120227155338.7b5110cd.akpm@linux-foundation.org> <20120228084359.GJ21106@elte.hu> <20120228132719.f375071a.akpm@linux-foundation.org> <4F4DBB26.2060907@linux.vnet.ibm.com> <20120229091732.GA11505@elte.hu> <4F4E083A.2080304@linux.vnet.ibm.com> <4F4F2F7F.5040207@linux.vnet.ibm.com>
In-Reply-To: <4F4F2F7F.5040207@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12030108-9574-0000-0000-000001997D54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently, there are several intertwined problems with CPU hotplug callback
registration:

Code which needs to get notified of CPU hotplug events and additionally wants
to do something for each already online CPU, would typically do something like:

   register_cpu_notifier(&foobar_cpu_notifier);
				<============ "A"
   get_online_cpus();
   for_each_online_cpu(cpu) {
	/* Do something */
   }
   put_online_cpus();

At the point marked as "A", a CPU hotplug event could sneak in, leaving the
code confused. Moving the registration to after put_online_cpus() won't help
either, because we could be losing a CPU hotplug event between put_online_cpus()
and the callback registration. Also, doing the registration inside the
get/put_online_cpus() block is also not going to help, because it will lead to
ABBA deadlock with CPU hotplug, the 2 locks being cpu_add_remove_lock and
cpu_hotplug lock.

It is also to be noted that, at times, we might want to do different setups
or initializations depending on whether a CPU is coming online for the first
time (as part of booting) or whether it is being only soft-onlined at a later
point in time. To achieve this, doing something like the code shown above,
with the "Do something" being different than what the registered callback
does wouldn't work out, because of the race conditions mentioned above.

The solution to all this is to include "history replay upon request" within
the CPU hotplug callback registration code, while also providing an option
for a different callback to be invoked while replaying history.

Though the above mentioned race condition was mostly theoretical before, it
gets all real when things like asynchronous booting[1] come into the picture,
as shown by the PowerPC boot failure in [2]. So this fix is also a step forward
in getting cool things like asynchronous booting to work properly.

References:
[1]. https://lkml.org/lkml/2012/2/14/62

---

 include/linux/cpu.h |   15 +++++++++++++++
 kernel/cpu.c        |   49 ++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 61 insertions(+), 3 deletions(-)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 6e53b48..90a6d76 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -124,16 +124,25 @@ enum {
 #endif /* #else #if defined(CONFIG_HOTPLUG_CPU) || !defined(MODULE) */
 #ifdef CONFIG_HOTPLUG_CPU
 extern int register_cpu_notifier(struct notifier_block *nb);
+extern int register_allcpu_notifier(struct notifier_block *nb,
+			bool replay_history, int (*history_setup)(void));
 extern void unregister_cpu_notifier(struct notifier_block *nb);
 #else
 
 #ifndef MODULE
 extern int register_cpu_notifier(struct notifier_block *nb);
+extern int register_allcpu_notifier(struct notifier_block *nb,
+			bool replay_history, int (*history_setup)(void));
 #else
 static inline int register_cpu_notifier(struct notifier_block *nb)
 {
 	return 0;
 }
+static inline int register_allcpu_notifier(struct notifier_block *nb,
+			bool replay_history, int (*history_setup)(void))
+{
+	return 0;
+}
 #endif
 
 static inline void unregister_cpu_notifier(struct notifier_block *nb)
@@ -155,6 +164,12 @@ static inline int register_cpu_notifier(struct notifier_block *nb)
 	return 0;
 }
 
+static inline int register_allcpu_notifier(struct notifier_block *nb,
+			bool replay_history, int (*history_setup)(void))
+{
+	return 0;
+}
+
 static inline void unregister_cpu_notifier(struct notifier_block *nb)
 {
 }
diff --git a/kernel/cpu.c b/kernel/cpu.c
index d520d34..1564c1d 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -132,12 +132,56 @@ static void cpu_hotplug_done(void) {}
 /* Need to know about CPUs going up/down? */
 int __ref register_cpu_notifier(struct notifier_block *nb)
 {
-	int ret;
+	return register_allcpu_notifier(nb, false, NULL);
+}
+EXPORT_SYMBOL(register_cpu_notifier);
+
+int __ref register_allcpu_notifier(struct notifier_block *nb,
+			bool replay_history, int (*history_setup)(void))
+{
+	int cpu, ret = 0;
+
+	if (!replay_history && history_setup)
+		return -EINVAL;
+
 	cpu_maps_update_begin();
-	ret = raw_notifier_chain_register(&cpu_chain, nb);
+	/*
+	 * We don't race with CPU hotplug, because we just took the
+	 * cpu_add_remove_lock.
+	 */
+
+	if (!replay_history)
+		goto Register;
+
+	if (history_setup) {
+		/*
+		 * The caller has a special setup routine to rewrite
+		 * history as he desires. Just invoke it. Don't
+		 * proceed with callback registration if this setup is
+		 * unsuccessful.
+		 */
+		ret = history_setup();
+	} else {
+		/*
+		 * Fallback to the usual callback, if a special handler
+		 * for past CPU hotplug events is not specified.
+		 * In this case, we will replay only past CPU bring-up
+		 * events.
+		 */
+		for_each_online_cpu(cpu) {
+			nb->notifier_call(nb, CPU_UP_PREPARE, cpu);
+			nb->notifier_call(nb, CPU_ONLINE, cpu);
+		}
+	}
+
+ Register:
+	if (!ret)
+		ret = raw_notifier_chain_register(&cpu_chain, nb);
+
 	cpu_maps_update_done();
 	return ret;
 }
+EXPORT_SYMBOL(register_allcpu_notifier);
 
 static int __cpu_notify(unsigned long val, void *v, int nr_to_call,
 			int *nr_calls)
@@ -161,7 +205,6 @@ static void cpu_notify_nofail(unsigned long val, void *v)
 {
 	BUG_ON(cpu_notify(val, v));
 }
-EXPORT_SYMBOL(register_cpu_notifier);
 
 void __ref unregister_cpu_notifier(struct notifier_block *nb)
 {



