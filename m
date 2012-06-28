Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360Ab2F1GHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 02:07:37 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:37327 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab2F1GHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 02:07:35 -0400
X-AuditID: b753bd60-8f6bfba0000047ca-a7-4febf4a589f4
X-AuditID: b753bd60-8f6bfba0000047ca-a7-4febf4a589f4
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Subject: [RFC PATCH 01/18] x86: Split memory hotplug function from cpu_up() as
 cpu_memory_up()
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 28 Jun 2012 15:07:24 +0900
Message-ID: <20120628060724.19298.71602.stgit@localhost.localdomain>
In-Reply-To: <20120628060719.19298.43879.stgit@localhost.localdomain>
References: <20120628060719.19298.43879.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split memory hotplug function from cpu_up() as cpu_memory_up(), which will
be used for assigning memory area to off-lined cpus at following patch
in this series.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---

 include/linux/cpu.h |    9 +++++++++
 kernel/cpu.c        |   46 +++++++++++++++++++++++++++-------------------
 2 files changed, 36 insertions(+), 19 deletions(-)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 2e9b9eb..14d8e41 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -145,6 +145,15 @@ void notify_cpu_starting(unsigned int cpu);
 extern void cpu_maps_update_begin(void);
 extern void cpu_maps_update_done(void);
 
+#ifdef	CONFIG_MEMORY_HOTPLUG
+extern int cpu_memory_up(unsigned int cpu);
+#else
+static inline int cpu_memory_up(unsigned int cpu)
+{
+	return 0;
+}
+#endif
+
 #else	/* CONFIG_SMP */
 
 #define cpu_notifier(fn, pri)	do { (void)(fn); } while (0)
diff --git a/kernel/cpu.c b/kernel/cpu.c
index a4eb522..db3e33c 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -384,11 +384,6 @@ int __cpuinit cpu_up(unsigned int cpu)
 {
 	int err = 0;
 
-#ifdef	CONFIG_MEMORY_HOTPLUG
-	int nid;
-	pg_data_t	*pgdat;
-#endif
-
 	if (!cpu_possible(cpu)) {
 		printk(KERN_ERR "can't online cpu %d because it is not "
 			"configured as may-hotadd at boot time\n", cpu);
@@ -399,7 +394,32 @@ int __cpuinit cpu_up(unsigned int cpu)
 		return -EINVAL;
 	}
 
+	err = cpu_memory_up(cpu);
+	if (err)
+		return err;
+
+	cpu_maps_update_begin();
+
+	if (cpu_hotplug_disabled) {
+		err = -EBUSY;
+		goto out;
+	}
+
+	err = _cpu_up(cpu, 0);
+
+out:
+	cpu_maps_update_done();
+	return err;
+}
+EXPORT_SYMBOL_GPL(cpu_up);
+
 #ifdef	CONFIG_MEMORY_HOTPLUG
+int __cpuinit cpu_memory_up(unsigned int cpu)
+{
+	int err;
+	int nid;
+	pg_data_t	*pgdat;
+
 	nid = cpu_to_node(cpu);
 	if (!node_online(nid)) {
 		err = mem_online_node(nid);
@@ -419,22 +439,10 @@ int __cpuinit cpu_up(unsigned int cpu)
 		build_all_zonelists(NULL);
 		mutex_unlock(&zonelists_mutex);
 	}
-#endif
 
-	cpu_maps_update_begin();
-
-	if (cpu_hotplug_disabled) {
-		err = -EBUSY;
-		goto out;
-	}
-
-	err = _cpu_up(cpu, 0);
-
-out:
-	cpu_maps_update_done();
-	return err;
+	return 0;
 }
-EXPORT_SYMBOL_GPL(cpu_up);
+#endif
 
 #ifdef CONFIG_PM_SLEEP_SMP
 static cpumask_var_t frozen_cpus;


