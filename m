Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933036Ab2ASUBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 15:01:46 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57446 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932876Ab2ASUBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 15:01:41 -0500
From: Venkatesh Pallipadi <venki@google.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mike Travis <travis@sgi.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH] Avoid mask based num_possible_cpus and num_online_cpus
Date: Thu, 19 Jan 2012 12:01:11 -0800
Message-Id: <1327003271-11730-1-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <4F171B6B.2040303@gmail.com>
References: <4F171B6B.2040303@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does this look better? Will send separate patch to fix code
using num_possible_cpus() when they actually need nr_cpu_ids.



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
 include/linux/cpumask.h |   10 ++++++++--
 kernel/cpu.c            |    5 +++++
 kernel/smp.c            |    4 ++++
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 4f7a632..ac3113b 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -23,10 +23,14 @@ typedef struct cpumask { DECLARE_BITMAP(bits, NR_CPUS); } cpumask_t;
 
 #if NR_CPUS == 1
 #define nr_cpu_ids		1
+#define nr_possible_cpus	1
 #else
 extern int nr_cpu_ids;
+extern int nr_possible_cpus;
 #endif
 
+extern int nr_online_cpus;
+
 #ifdef CONFIG_CPUMASK_OFFSTACK
 /* Assuming NR_CPUS is huge, a runtime limit is more efficient.  Also,
  * not all bits may be allocated. */
@@ -81,8 +85,10 @@ extern const struct cpumask *const cpu_present_mask;
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
index 2060c6e..f179baa 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -622,6 +622,9 @@ static DECLARE_BITMAP(cpu_active_bits, CONFIG_NR_CPUS) __read_mostly;
 const struct cpumask *const cpu_active_mask = to_cpumask(cpu_active_bits);
 EXPORT_SYMBOL(cpu_active_mask);
 
+int nr_online_cpus __read_mostly;
+EXPORT_SYMBOL(nr_online_cpus);
+
 void set_cpu_possible(unsigned int cpu, bool possible)
 {
 	if (possible)
@@ -644,6 +647,8 @@ void set_cpu_online(unsigned int cpu, bool online)
 		cpumask_set_cpu(cpu, to_cpumask(cpu_online_bits));
 	else
 		cpumask_clear_cpu(cpu, to_cpumask(cpu_online_bits));
+
+	nr_online_cpus = cpumask_weight(cpu_online_mask);
 }
 
 void set_cpu_active(unsigned int cpu, bool active)
diff --git a/kernel/smp.c b/kernel/smp.c
index db197d6..106e519 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -658,10 +658,14 @@ early_param("maxcpus", maxcpus);
 int nr_cpu_ids __read_mostly = NR_CPUS;
 EXPORT_SYMBOL(nr_cpu_ids);
 
+int nr_possible_cpus __read_mostly = NR_CPUS;
+EXPORT_SYMBOL(nr_possible_cpus);
+
 /* An arch may set nr_cpu_ids earlier if needed, so this would be redundant */
 void __init setup_nr_cpu_ids(void)
 {
 	nr_cpu_ids = find_last_bit(cpumask_bits(cpu_possible_mask),NR_CPUS) + 1;
+	nr_possible_cpus = cpumask_weight(cpu_possible_mask);
 }
 
 /* Called by boot processor to activate the rest. */
-- 
1.7.7.3

