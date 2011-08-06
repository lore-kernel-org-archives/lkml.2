Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab1HFHCz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 03:02:55 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:57303 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab1HFHCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 03:02:53 -0400
From: Rabin Vincent <rabin@rab.in>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Rabin Vincent <rabin@rab.in>,
        x86@kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH] stop_machine: build unconditionally if SMP
Date: Sat,  6 Aug 2011 12:31:13 +0530
Message-Id: <1312614073-11516-1-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stop_machine() is built for "(SMP && MODULE_UNLOAD) || HOTPLUG_CPU", but
is also used by the timekeeping code, the mm code, ftrace, and couple of
things in arch/*.  Just build it if we're using SMP, like it's already
the case on x86.

Cc: x86@kernel.org
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 arch/x86/Kconfig             |    1 -
 include/linux/stop_machine.h |    6 +++---
 init/Kconfig                 |    7 -------
 kernel/stop_machine.c        |    4 ----
 4 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6a47bb2..bb1b397 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2132,7 +2132,6 @@ config HAVE_ATOMIC_IOMAP
 
 config HAVE_TEXT_POKE_SMP
 	bool
-	select STOP_MACHINE if SMP
 
 source "net/Kconfig"
 
diff --git a/include/linux/stop_machine.h b/include/linux/stop_machine.h
index 2d04ea9..37bf3ff 100644
--- a/include/linux/stop_machine.h
+++ b/include/linux/stop_machine.h
@@ -96,7 +96,7 @@ static inline int try_stop_cpus(const struct cpumask *cpumask,
  * grabbing every spinlock (and more).  So the "read" side to such a
  * lock is anything which disables preemption.
  */
-#if defined(CONFIG_STOP_MACHINE) && defined(CONFIG_SMP)
+#ifdef CONFIG_SMP
 
 /**
  * stop_machine: freeze the machine on all CPUs and run this function
@@ -127,7 +127,7 @@ int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus);
 int stop_machine_from_inactive_cpu(int (*fn)(void *), void *data,
 				   const struct cpumask *cpus);
 
-#else	 /* CONFIG_STOP_MACHINE && CONFIG_SMP */
+#else	 /* CONFIG_SMP */
 
 static inline int __stop_machine(int (*fn)(void *), void *data,
 				 const struct cpumask *cpus)
@@ -152,5 +152,5 @@ static inline int stop_machine_from_inactive_cpu(int (*fn)(void *), void *data,
 	return __stop_machine(fn, data, cpus);
 }
 
-#endif	/* CONFIG_STOP_MACHINE && CONFIG_SMP */
+#endif	/* CONFIG_SMP */
 #endif	/* _LINUX_STOP_MACHINE */
diff --git a/init/Kconfig b/init/Kconfig
index d627783..c32bbfa 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1382,13 +1382,6 @@ config INIT_ALL_POSSIBLE
 	  it was better to provide this option than to break all the archs
 	  and have several arch maintainers pursuing me down dark alleys.
 
-config STOP_MACHINE
-	bool
-	default y
-	depends on (SMP && MODULE_UNLOAD) || HOTPLUG_CPU
-	help
-	  Need stop_machine() primitive.
-
 source "block/Kconfig"
 
 config PREEMPT_NOTIFIERS
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index ba5070c..708bdad 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -390,8 +390,6 @@ static int __init cpu_stop_init(void)
 }
 early_initcall(cpu_stop_init);
 
-#ifdef CONFIG_STOP_MACHINE
-
 /* This controls the threads on each CPU. */
 enum stopmachine_state {
 	/* Dummy starting state for thread. */
@@ -554,5 +552,3 @@ int stop_machine_from_inactive_cpu(int (*fn)(void *), void *data,
 	mutex_unlock(&stop_cpus_mutex);
 	return ret ?: done.ret;
 }
-
-#endif	/* CONFIG_STOP_MACHINE */
-- 
1.7.5.4

