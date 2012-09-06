Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933Ab2IFLaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 07:30:52 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:59328 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab2IFL3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 07:29:44 -0400
X-AuditID: b753bd60-9395fba000007c38-ee-504888a301ac
X-AuditID: b753bd60-9395fba000007c38-ee-504888a301ac
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Subject: [RFC v2 PATCH 01/21] x86: Split memory hotplug function from cpu_up()
 as cpu_memory_up()
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 06 Sep 2012 20:27:23 +0900
Message-ID: <20120906112723.13320.29299.stgit@kvmdev>
In-Reply-To: <20120906112718.13320.8231.stgit@kvmdev>
References: <20120906112718.13320.8231.stgit@kvmdev>
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
index ce7a074..8395ac9 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -146,6 +146,15 @@ void notify_cpu_starting(unsigned int cpu);
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
index 14d3258..5df8f36 100644
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
 		build_all_zonelists(NULL, NULL);
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


