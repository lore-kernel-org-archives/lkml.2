Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab2ARCIM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 21:08:12 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64018 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756495Ab2ARCIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 21:08:11 -0500
From: Venkatesh Pallipadi <venki@google.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mike Travis <travis@sgi.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH] Avoid mask based num_possible_cpus and num_online_cpus
Date: Tue, 17 Jan 2012 18:07:34 -0800
Message-Id: <1326852454-26117-1-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel's notion of possible cpus (from include/linux/cpumask.h)
 *     cpu_possible_mask- has bit 'cpu' set iff cpu is populatable

 *  The cpu_possible_mask is fixed at boot time, as the set of CPU id's
 *  that it is possible might ever be plugged in at anytime during the
 *  life of that system boot.

 #define num_possible_cpus()     cpumask_weight(cpu_possible_mask)

and on x86 cpumask_weight() calls hweight64 and hweight64 (on older kernels
and systems with !X86_FEATURE_POPCNT) or a popcnt based alternative.

i.e, We needlessly go through this mask based calculation everytime
num_possible_cpus() is called.

The problem is there with cpu_online_mask() as well, which is fixed value at
boot time in !CONFIG_HOTPLUG_CPU case and should not change that often even
in HOTPLUG case.

Though most of the callers of these two routines are init time (with few
exceptions of runtime calls), it is cleaner to use variables
and not go through this repeated mask based calculation.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 include/linux/cpumask.h |    8 ++++++--
 kernel/cpu.c            |    9 +++++++++
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 4f7a632..2eb04dd 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -80,9 +80,13 @@ extern const struct cpumask *const cpu_online_mask;
 extern const struct cpumask *const cpu_present_mask;
 extern const struct cpumask *const cpu_active_mask;
 
+extern int nr_online_cpus;
+
 #if NR_CPUS > 1
-#define num_online_cpus()	cpumask_weight(cpu_online_mask)
-#define num_possible_cpus()	cpumask_weight(cpu_possible_mask)
+
+#define num_online_cpus()	(nr_online_cpus)
+#define num_possible_cpus()	(nr_cpu_ids)
+
 #define num_present_cpus()	cpumask_weight(cpu_present_mask)
 #define num_active_cpus()	cpumask_weight(cpu_active_mask)
 #define cpu_online(cpu)		cpumask_test_cpu((cpu), cpu_online_mask)
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 2060c6e..eed2169 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -622,6 +622,13 @@ static DECLARE_BITMAP(cpu_active_bits, CONFIG_NR_CPUS) __read_mostly;
 const struct cpumask *const cpu_active_mask = to_cpumask(cpu_active_bits);
 EXPORT_SYMBOL(cpu_active_mask);
 
+#ifdef CONFIG_HOTPLUG_CPU
+int nr_online_cpus;
+#else
+int nr_online_cpus __read_mostly;
+#endif
+EXPORT_SYMBOL(nr_online_cpus);
+
 void set_cpu_possible(unsigned int cpu, bool possible)
 {
 	if (possible)
@@ -644,6 +651,8 @@ void set_cpu_online(unsigned int cpu, bool online)
 		cpumask_set_cpu(cpu, to_cpumask(cpu_online_bits));
 	else
 		cpumask_clear_cpu(cpu, to_cpumask(cpu_online_bits));
+
+	nr_online_cpus = cpumask_weight(cpu_online_mask);
 }
 
 void set_cpu_active(unsigned int cpu, bool active)
-- 
1.7.7.3

