Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab2BAARn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 19:17:43 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47792 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab2BAARl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 19:17:41 -0500
From: Venkatesh Pallipadi <venki@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mike Travis <travis@sgi.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH] Avoid mask based num_possible_cpus and num_online_cpus -v5
Date: Tue, 31 Jan 2012 16:17:19 -0800
Message-Id: <1328055439-9441-1-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <CABeCy1aPp4=v90v_wAsw-KWDwNs59CwwYSJ-36+4t8kMuCaK0w@mail.gmail.com>
References: <CABeCy1aPp4=v90v_wAsw-KWDwNs59CwwYSJ-36+4t8kMuCaK0w@mail.gmail.com>
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
Acked-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/linux/cpumask.h |    9 +++++++--
 kernel/cpu.c            |   13 +++++++++++++
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 4f7a632..930e255 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -27,6 +27,9 @@ typedef struct cpumask { DECLARE_BITMAP(bits, NR_CPUS); } cpumask_t;
 extern int nr_cpu_ids;
 #endif
 
+extern unsigned int nr_online_cpus;
+extern unsigned int nr_possible_cpus;
+
 #ifdef CONFIG_CPUMASK_OFFSTACK
 /* Assuming NR_CPUS is huge, a runtime limit is more efficient.  Also,
  * not all bits may be allocated. */
@@ -81,8 +84,10 @@ extern const struct cpumask *const cpu_present_mask;
 extern const struct cpumask *const cpu_active_mask;
 
 #if NR_CPUS > 1
-#define num_online_cpus()	cpumask_weight(cpu_online_mask)
-#define num_possible_cpus()	cpumask_weight(cpu_possible_mask)
+
+#define num_online_cpus()	(nr_online_cpus)
+#define num_possible_cpus()	(nr_possible_cpus)
+
 #define num_present_cpus()	cpumask_weight(cpu_present_mask)
 #define num_active_cpus()	cpumask_weight(cpu_active_mask)
 #define cpu_online(cpu)		cpumask_test_cpu((cpu), cpu_online_mask)
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 2060c6e..d520d34 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -604,9 +604,13 @@ EXPORT_SYMBOL(cpu_all_bits);
 #ifdef CONFIG_INIT_ALL_POSSIBLE
 static DECLARE_BITMAP(cpu_possible_bits, CONFIG_NR_CPUS) __read_mostly
 	= CPU_BITS_ALL;
+unsigned int nr_possible_cpus __read_mostly = CONFIG_NR_CPUS;
 #else
 static DECLARE_BITMAP(cpu_possible_bits, CONFIG_NR_CPUS) __read_mostly;
+unsigned int nr_possible_cpus __read_mostly;
 #endif
+EXPORT_SYMBOL(nr_possible_cpus);
+
 const struct cpumask *const cpu_possible_mask = to_cpumask(cpu_possible_bits);
 EXPORT_SYMBOL(cpu_possible_mask);
 
@@ -614,6 +618,9 @@ static DECLARE_BITMAP(cpu_online_bits, CONFIG_NR_CPUS) __read_mostly;
 const struct cpumask *const cpu_online_mask = to_cpumask(cpu_online_bits);
 EXPORT_SYMBOL(cpu_online_mask);
 
+unsigned int nr_online_cpus __read_mostly;
+EXPORT_SYMBOL(nr_online_cpus);
+
 static DECLARE_BITMAP(cpu_present_bits, CONFIG_NR_CPUS) __read_mostly;
 const struct cpumask *const cpu_present_mask = to_cpumask(cpu_present_bits);
 EXPORT_SYMBOL(cpu_present_mask);
@@ -628,6 +635,8 @@ void set_cpu_possible(unsigned int cpu, bool possible)
 		cpumask_set_cpu(cpu, to_cpumask(cpu_possible_bits));
 	else
 		cpumask_clear_cpu(cpu, to_cpumask(cpu_possible_bits));
+
+	nr_possible_cpus = cpumask_weight(cpu_possible_mask);
 }
 
 void set_cpu_present(unsigned int cpu, bool present)
@@ -644,6 +653,8 @@ void set_cpu_online(unsigned int cpu, bool online)
 		cpumask_set_cpu(cpu, to_cpumask(cpu_online_bits));
 	else
 		cpumask_clear_cpu(cpu, to_cpumask(cpu_online_bits));
+
+	nr_online_cpus = cpumask_weight(cpu_online_mask);
 }
 
 void set_cpu_active(unsigned int cpu, bool active)
@@ -662,9 +673,11 @@ void init_cpu_present(const struct cpumask *src)
 void init_cpu_possible(const struct cpumask *src)
 {
 	cpumask_copy(to_cpumask(cpu_possible_bits), src);
+	nr_possible_cpus = cpumask_weight(cpu_possible_mask);
 }
 
 void init_cpu_online(const struct cpumask *src)
 {
 	cpumask_copy(to_cpumask(cpu_online_bits), src);
+	nr_online_cpus = cpumask_weight(cpu_online_mask);
 }
-- 
1.7.7.3

