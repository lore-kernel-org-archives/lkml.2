Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab0KDPi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 11:38:58 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:41912 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab0KDPiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 11:38:51 -0400
From: Borislav Petkov <bp@amd64.org>
To: <acme@infradead.org>, <fweisbec@gmail.com>, <mingo@elte.hu>,
        <peterz@infradead.org>, <rostedt@goodmis.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 03/20] x86, mce: Add persistent MCE event
Date: Thu,  4 Nov 2010 16:36:39 +0100
Message-Id: <1288885016-18295-4-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1288885016-18295-1-git-send-email-bp@amd64.org>
References: <1288885016-18295-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Add the necessary glue to enable the mce_record tracepoint on boot
turning it into a persistent event. This exports the MCE buffer
read-only to a userspace daemon which will hook into it through debugfs
when booting is finished.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/mce.h       |    8 ++++
 arch/x86/kernel/cpu/mcheck/mce.c |   84 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 92 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index c62c13c..c248038 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -91,6 +91,14 @@ struct mce_log {
 	struct mce entry[MCE_LOG_LEN];
 };
 
+/*
+ * a per-cpu descriptor of the persistent MCE tracepoint
+ */
+struct mce_tp_desc {
+	struct perf_event *event;
+	struct dentry *debugfs_entry;
+};
+
 #define MCE_OVERFLOW 0		/* bit 0 in flags means overflow */
 
 #define MCE_LOG_SIGNATURE	"MACHINECHECK"
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index ed41562..5ce3e72 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -95,8 +95,11 @@ static char			*mce_helper_argv[2] = { mce_helper, NULL };
 
 static DECLARE_WAIT_QUEUE_HEAD(mce_wait);
 static DEFINE_PER_CPU(struct mce, mces_seen);
+static DEFINE_PER_CPU(struct mce_tp_desc, mce_event);
 static int			cpu_missing;
 
+
+
 /*
  * CPU/chipset specific EDAC code can register a notifier call here to print
  * MCE errors in a human-readable form.
@@ -2052,6 +2055,86 @@ static void __cpuinit mce_reenable_cpu(void *h)
 	}
 }
 
+struct perf_event_attr pattr = {
+	.type		= PERF_TYPE_TRACEPOINT,
+	.size		= sizeof(pattr),
+	.sample_type	= PERF_SAMPLE_RAW,
+};
+
+static struct dentry *mce_add_event_debugfs(struct perf_event *event, int cpu)
+{
+	char buf[14];
+
+	sprintf(buf, "mce_record%d", cpu);
+
+	return debugfs_create_file(buf, S_IRUGO, mce_get_debugfs_dir(),
+				   event, &perf_pers_fops);
+}
+
+static int mce_enable_perf_event_on_cpu(int cpu)
+{
+	struct mce_tp_desc *d = &per_cpu(mce_event, cpu);
+	int err = 0;
+
+	err = perf_enable_persistent_event(&d->event, &pattr, cpu, 128);
+	if (err) {
+		printk(KERN_ERR "MCE: Error enabling event on cpu %d\n", cpu);
+		goto ret;
+	}
+
+	d->debugfs_entry = mce_add_event_debugfs(d->event, cpu);
+	if (!d->debugfs_entry) {
+		printk(KERN_ERR "MCE: Error adding event debugfs entry on cpu %d\n", cpu);
+		goto disable;
+	}
+
+	return 0;
+
+disable:
+	perf_disable_persistent_event(d->event, cpu);
+
+ret:
+	return err;
+}
+
+static void mce_disable_perf_event_on_cpu(int cpu)
+{
+	struct mce_tp_desc *d = &per_cpu(mce_event, cpu);
+	perf_disable_persistent_event(d->event, cpu);
+	debugfs_remove(d->debugfs_entry);
+}
+
+static __init int mcheck_init_persistent_event(void)
+{
+	int cpu, err = 0;
+
+	get_online_cpus();
+
+	pattr.config = event_mce_record.event.type;
+	pattr.sample_period = ULLONG_MAX;
+
+	for_each_online_cpu(cpu)
+		if (mce_enable_perf_event_on_cpu(cpu))
+			goto unwind;
+
+	goto unlock;
+
+unwind:
+	for (--cpu; cpu >= 0; cpu--)
+		mce_disable_perf_event_on_cpu(cpu);
+
+unlock:
+	put_online_cpus();
+
+	return err;
+}
+
+/*
+ * This has to run after event_trace_init()
+ */
+device_initcall(mcheck_init_persistent_event);
+
+
 /* Get notified when a cpu comes on/off. Be hotplug friendly. */
 static int __cpuinit
 mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
@@ -2065,6 +2148,7 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		mce_create_device(cpu);
 		if (threshold_cpu_callback)
 			threshold_cpu_callback(action, cpu);
+		mce_enable_perf_event_on_cpu(cpu);
 		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-- 
1.7.3.1

