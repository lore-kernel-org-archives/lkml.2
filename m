Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab1AUPHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 10:07:42 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:58465 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940Ab1AUPHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 10:07:39 -0500
From: Borislav Petkov <bp@amd64.org>
To: <peterz@infradead.org>, <mingo@elte.hu>
Cc: <tony.luck@intel.com>, <acme@infradead.org>, <rostedt@goodmis.org>,
        <fweisbec@gmail.com>, <linux-edac@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 03/12] x86, mce: Add persistent MCE event
Date: Fri, 21 Jan 2011 16:09:26 +0100
Message-Id: <1295622575-18607-4-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1295622575-18607-1-git-send-email-bp@amd64.org>
References: <1295622575-18607-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Add the necessary glue to enable the mce_record tracepoint on boot,
turning it into a persistent event. This exports the MCE buffer to a
userspace daemon which will hook into it through debugfs when booting is
finished.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/mce.h       |    8 ++++
 arch/x86/kernel/cpu/mcheck/mce.c |   86 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 94 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index eb16e94..eae0e29 100644
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
index 7a35b72..56dc10d 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -95,6 +95,7 @@ static char			*mce_helper_argv[2] = { mce_helper, NULL };
 
 static DECLARE_WAIT_QUEUE_HEAD(mce_wait);
 static DEFINE_PER_CPU(struct mce, mces_seen);
+static DEFINE_PER_CPU(struct mce_tp_desc, mce_event);
 static int			cpu_missing;
 
 /*
@@ -2053,6 +2054,90 @@ static void __cpuinit mce_reenable_cpu(void *h)
 	}
 }
 
+struct perf_event_attr pattr = {
+	.type		= PERF_TYPE_TRACEPOINT,
+	.size		= sizeof(pattr),
+	.sample_type	= PERF_SAMPLE_RAW,
+	.persistent	= 1,
+};
+
+static struct dentry *mce_add_event_debugfs(struct perf_event *event, int cpu)
+{
+	char buf[14];
+
+	sprintf(buf, "mce_record%d", cpu);
+
+	return debugfs_create_file(buf, S_IRUGO | S_IWUSR,
+				   mce_get_debugfs_dir(),
+				   event, &perf_pers_fops);
+}
+
+#define PERF_MMAP_PAGES 128
+static int mce_enable_perf_event_on_cpu(int cpu)
+{
+	struct mce_tp_desc *d = &per_cpu(mce_event, cpu);
+	int err = -EINVAL;
+
+	pattr.sample_period = 1;
+
+	d->event = perf_enable_persistent_event(&pattr, cpu, PERF_MMAP_PAGES);
+	if (IS_ERR(d->event)) {
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
+	debugfs_remove(d->debugfs_entry);
+	perf_disable_persistent_event(d->event, cpu);
+}
+
+static __init int mcheck_init_persistent_event(void)
+{
+	int cpu, err = 0;
+
+	get_online_cpus();
+
+	pattr.config = event_mce_record.event.type;
+
+	for_each_online_cpu(cpu)
+		if (mce_enable_perf_event_on_cpu(cpu))
+			goto err_unwind;
+
+	goto unlock;
+
+err_unwind:
+	err = -EINVAL;
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
 /* Get notified when a cpu comes on/off. Be hotplug friendly. */
 static int __cpuinit
 mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
@@ -2066,6 +2151,7 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		mce_create_device(cpu);
 		if (threshold_cpu_callback)
 			threshold_cpu_callback(action, cpu);
+		mce_enable_perf_event_on_cpu(cpu);
 		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-- 
1.7.4.rc2

