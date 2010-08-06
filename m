Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966Ab0HFOZV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 10:25:21 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:40112 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab0HFOZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 10:25:15 -0400
From: Borislav Petkov <bp@amd64.org>
To: <acme@infradead.org>, <fweisbec@gmail.com>, <mingo@elte.hu>,
        <peterz@infradead.org>, <rostedt@goodmis.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [RFC PATCH 4/9] mce: Add persistent events
Date: Fri,  6 Aug 2010 16:25:08 +0200
Message-Id: <1281104713-23141-5-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1281104713-23141-1-git-send-email-bp@amd64.org>
References: <1281104713-23141-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Add the required glue to enable the mce_record tracepoint on boot
thus simulating a persistent event with allocated buffers. Userspace
daemon will hook into it later when booting is done. Export mce buffer
read-only through debugfs.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |  135 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 135 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 1970ef9..cdff254 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -95,6 +95,7 @@ static char			*mce_helper_argv[2] = { mce_helper, NULL };
 
 static DECLARE_WAIT_QUEUE_HEAD(mce_wait);
 static DEFINE_PER_CPU(struct mce, mces_seen);
+static DEFINE_PER_CPU(struct perf_event *, mce_event);
 static int			cpu_missing;
 
 /*
@@ -2064,6 +2065,137 @@ static void __cpuinit mce_reenable_cpu(void *h)
 	}
 }
 
+struct perf_event_attr pattr = {
+	.type	     = PERF_TYPE_TRACEPOINT,
+	.size	     = sizeof(pattr),
+	.sample_type = PERF_SAMPLE_RAW | PERF_SAMPLE_CPU | PERF_SAMPLE_TIME,
+};
+
+static int mce_enable_perf_event_on_cpu(int cpu)
+{
+	struct perf_event *event;
+	struct perf_buffer *buffer;
+
+	if (!event_mce_record.event.type) {
+		printk(KERN_ERR "mce: Tracepoint not enumerated yet!\n");
+		return -EINVAL;
+	}
+	pattr.config = event_mce_record.event.type;
+	pattr.sample_period = ULLONG_MAX;
+
+	event = perf_event_create_kernel_counter(&pattr, cpu, -1, NULL);
+	if (IS_ERR(event))
+		return -EINVAL;
+
+	buffer = perf_buffer_alloc(128, 0, cpu, 0);
+	if (IS_ERR(buffer))
+		goto err;
+
+	rcu_assign_pointer(event->buffer, buffer);
+	per_cpu(mce_event, cpu) = event;
+
+	perf_event_enable(event);
+
+	return 0;
+
+err:
+	perf_event_release_kernel(event);
+	return -EINVAL;
+}
+
+static void mce_disable_perf_event_on_cpu(int cpu)
+{
+	struct perf_event *event = per_cpu(mce_event, cpu);
+
+	if (!event)
+		return;
+
+	perf_event_disable(event);
+
+	if (event->buffer) {
+		perf_buffer_put(event->buffer);
+		rcu_assign_pointer(event->buffer, NULL);
+	}
+
+	per_cpu(mce_event, cpu) = NULL;
+
+	perf_event_release_kernel(event);
+}
+
+static int mce_perf_open(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+
+	return 0;
+}
+
+static const struct file_operations perf_mce_fops = {
+	.llseek		= no_llseek,
+	.open		= mce_perf_open,
+	.poll		= perf_poll,
+	.unlocked_ioctl	= perf_ioctl,
+	.compat_ioctl	= perf_ioctl,
+	.mmap		= perf_mmap,
+	.fasync		= perf_fasync,
+	.release	= perf_release,
+};
+
+static int mce_add_perf_debugfs_entry(struct dentry *dmce, int cpu)
+{
+	struct dentry *fmce_record;
+	char buf[14];
+
+	sprintf(buf, "mce_record%d", cpu);
+
+	fmce_record = debugfs_create_file(buf, S_IRUGO, dmce,
+					  per_cpu(mce_event, cpu),
+					  &perf_mce_fops);
+
+	if (!fmce_record)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static int mcheck_init_perf_event(void)
+{
+	int cpu, err = 0;
+
+	get_online_cpus();
+
+	for_each_online_cpu(cpu) {
+		err = mce_enable_perf_event_on_cpu(cpu);
+		if (err) {
+			printk(KERN_ERR "mce: error initializing mce tracepoint"
+					" on cpu %d\n", cpu);
+			goto unwind;
+		}
+
+		err = mce_add_perf_debugfs_entry(mce_get_debugfs_dir(), cpu);
+		if (err) {
+			printk(KERN_ERR "mce: error adding debugfs entry"
+					"on cpu %d\n", cpu);
+			goto unwind;
+		}
+	}
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
+ * This has to run after after event_trace_init() which is an fs_initcall()
+ * currently
+ */
+device_initcall(mcheck_init_perf_event);
+
 /* Get notified when a cpu comes on/off. Be hotplug friendly. */
 static int __cpuinit
 mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
@@ -2077,6 +2209,7 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		mce_create_device(cpu);
 		if (threshold_cpu_callback)
 			threshold_cpu_callback(action, cpu);
+		mce_enable_perf_event_on_cpu(cpu);
 		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
@@ -2088,6 +2221,7 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	case CPU_DOWN_PREPARE_FROZEN:
 		del_timer_sync(t);
 		smp_call_function_single(cpu, mce_disable_cpu, &action, 1);
+		mce_disable_perf_event_on_cpu(cpu);
 		break;
 	case CPU_DOWN_FAILED:
 	case CPU_DOWN_FAILED_FROZEN:
@@ -2097,6 +2231,7 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 			add_timer_on(t, cpu);
 		}
 		smp_call_function_single(cpu, mce_reenable_cpu, &action, 1);
+		mce_enable_perf_event_on_cpu(cpu);
 		break;
 	case CPU_POST_DEAD:
 		/* intentionally ignoring frozen here */
-- 
1.7.1

