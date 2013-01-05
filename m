Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab3AERwf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 12:52:35 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:52758 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816Ab3AERtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 12:49:19 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 04/14] rcu: Provide compile-time control for no-CBs CPUs
Date: Sat,  5 Jan 2013 09:48:54 -0800
Message-Id: <1357408144-15830-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1357408144-15830-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130105174844.GA14172@linux.vnet.ibm.com>
 <1357408144-15830-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010517-7408-0000-0000-00000B9539BC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Currently, the only way to specify no-CBs CPUs is via the rcu_nocbs
kernel command-line parameter.  This is inconvenient in some cases,
particularly for randconfig testing, so this commit adds a new
RCU_NOCB_CPU_DEFAULT kernel configuration parameter.  Setting this
new parameter to zero (the default) retains the old behavior, setting
it to one offloads callback processing from CPU 0 (along with any
other CPUs specified by the rcu_nocbs boot-time parameter), and setting
it to two offloads callback processing from all CPUs.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 init/Kconfig            |   13 +++++++++++++
 kernel/rcutree_plugin.h |   13 +++++++++++++
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index fc6a3ca..35dcedb 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -676,6 +676,19 @@ config RCU_NOCB_CPU
 	  Say Y here if you want to help to debug reduced OS jitter.
 	  Say N here if you are unsure.
 
+config RCU_NOCB_CPU_DEFAULT
+	int "Offload RCU callback processing from compile-selected CPUs"
+	depends on RCU_NOCB_CPU
+	range 0 2
+	default 0
+	help
+	  Set this option to zero to only offload RCU callback processing
+	  from those CPUs specified by the boot-time rcu_nocbs kernel
+	  parameter.  Set it to one to offload processing from CPU 0
+	  in addition to any CPUs specified at boot time.  Set it to
+	  two to offload processing from all CPUs, regardless of the
+	  setting of the boot-time rcu_nocbs kernel parameter.
+
 endmenu # "RCU Subsystem"
 
 config IKCONFIG
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 37750bc..eb9b473 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -86,6 +86,19 @@ static void __init rcu_bootup_announce_oddness(void)
 	if (nr_cpu_ids != NR_CPUS)
 		printk(KERN_INFO "\tRCU restricting CPUs from NR_CPUS=%d to nr_cpu_ids=%d.\n", NR_CPUS, nr_cpu_ids);
 #ifdef CONFIG_RCU_NOCB_CPU
+#if CONFIG_RCU_NOCB_CPU_DEFAULT != 0
+	if (!have_rcu_nocb_mask) {
+		alloc_bootmem_cpumask_var(&rcu_nocb_mask);
+		have_rcu_nocb_mask = true;
+	}
+#if CONFIG_RCU_NOCB_CPU_DEFAULT == 1
+	pr_info("\tExperimental no-CBs CPU 0\n");
+	cpumask_set_cpu(0, rcu_nocb_mask);
+#else /* #if CONFIG_RCU_NOCB_CPU_DEFAULT == 1 */
+	pr_info("\tExperimental no-CBs for all CPUs\n");
+	cpumask_setall(rcu_nocb_mask);
+#endif /* #else #if CONFIG_RCU_NOCB_CPU_DEFAULT == 1 */
+#endif /* #if CONFIG_RCU_NOCB_CPU_DEFAULT != 0 */
 	if (have_rcu_nocb_mask) {
 		cpulist_scnprintf(nocb_buf, sizeof(nocb_buf), rcu_nocb_mask);
 		pr_info("\tExperimental no-CBs CPUs: %s.\n", nocb_buf);
-- 
1.7.8

