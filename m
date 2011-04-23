Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243Ab1DWQ31 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 12:29:27 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:35058 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927Ab1DWQ3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 12:29:18 -0400
From: Borislav Petkov <bp@amd64.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 03/18] x86, mce: Add persistent MCE event
Date: Sat, 23 Apr 2011 18:28:05 +0200
Message-Id: <1303576100-425-4-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1303576100-425-1-git-send-email-bp@amd64.org>
References: <1303576100-425-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Add the necessary glue to enable the mce_record tracepoint on boot,
turning it into a persistent event. This exports the MCE buffer through
a debugfs per-CPU file which a userspace daemon can read and process the
error data further.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/mce.h       |    8 +++
 arch/x86/kernel/cpu/mcheck/mce.c |   89 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 97 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index eb16e94..81f5545 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -115,6 +115,14 @@ struct mce_log {
 
 #ifdef __KERNEL__
 
+/*
+ * a per-cpu descriptor of the persistent MCE tracepoint
+ */
+struct mce_tp_desc {
+	struct perf_event *event;
+	struct dentry *debugfs_entry;
+};
+
 extern struct atomic_notifier_head x86_mce_decoder_chain;
 
 #include <linux/percpu.h>
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 3385ea2..9589ebf 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -96,6 +96,7 @@ static char			*mce_helper_argv[2] = { mce_helper, NULL };
 
 static DECLARE_WAIT_QUEUE_HEAD(mce_wait);
 static DEFINE_PER_CPU(struct mce, mces_seen);
+static DEFINE_PER_CPU(struct mce_tp_desc, mce_event);
 static int			cpu_missing;
 
 /*
@@ -2055,6 +2056,91 @@ static void __cpuinit mce_reenable_cpu(void *h)
 	}
 }
 
+static struct perf_event_attr pattr = {
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
+#define MCE_BUF_PAGES	4
+
+static int mce_enable_perf_event_on_cpu(int cpu)
+{
+	struct mce_tp_desc *d = &per_cpu(mce_event, cpu);
+	int err = -EINVAL;
+
+	d->event = perf_enable_persistent_event(&pattr, cpu, MCE_BUF_PAGES);
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
+	pattr.sample_period = 1;
+	pattr.wakeup_events = 1;
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
@@ -2068,6 +2154,7 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		mce_create_device(cpu);
 		if (threshold_cpu_callback)
 			threshold_cpu_callback(action, cpu);
+		mce_enable_perf_event_on_cpu(cpu);
 		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
@@ -2077,6 +2164,7 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		break;
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
+		mce_disable_perf_event_on_cpu(cpu);
 		del_timer_sync(t);
 		smp_call_function_single(cpu, mce_disable_cpu, &action, 1);
 		break;
@@ -2088,6 +2176,7 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 			add_timer_on(t, cpu);
 		}
 		smp_call_function_single(cpu, mce_reenable_cpu, &action, 1);
+		mce_enable_perf_event_on_cpu(cpu);
 		break;
 	case CPU_POST_DEAD:
 		/* intentionally ignoring frozen here */
-- 
1.7.4.rc2

