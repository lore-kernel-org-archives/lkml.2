Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240Ab0GAPyR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 11:54:17 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:47044 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756851Ab0GAPyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 11:54:05 -0400
From: Borislav Petkov <bp@amd64.org>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/21] mce: Add persistent events
Date: Thu,  1 Jul 2010 17:55:44 +0200
Message-Id: <1277999763-20357-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277999763-20357-1-git-send-email-bp@amd64.org>
References: <1277999763-20357-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Add the required glue to enable the mce_record tracepoint on boot thus
simulating a persistent event with allocated buffers. Userspace daemon
will hook into it later when booting is done.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   89 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 89 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 18cc425..42d2808 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -95,6 +95,7 @@ static char			*mce_helper_argv[2] = { mce_helper, NULL };
 
 static DECLARE_WAIT_QUEUE_HEAD(mce_wait);
 static DEFINE_PER_CPU(struct mce, mces_seen);
+static DEFINE_PER_CPU(struct perf_event *, mce_event);
 static int			cpu_missing;
 
 /*
@@ -2063,6 +2064,91 @@ static void __cpuinit mce_reenable_cpu(void *h)
 	}
 }
 
+struct perf_event_attr pattr = {
+	.type	     = PERF_TYPE_TRACEPOINT,
+	.size	     = sizeof(pattr),
+	.sample_type = PERF_SAMPLE_RAW | PERF_SAMPLE_CPU | PERF_SAMPLE_TIME,
+};
+
+static int mcheck_enable_perf_event_on_cpu(int cpu)
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
+static void mcheck_disable_perf_event_on_cpu(int cpu)
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
+static int mcheck_init_perf_event(void)
+{
+	int cpu, i, err = 0;
+
+	get_online_cpus();
+
+	for_each_online_cpu(cpu) {
+		err = mcheck_enable_perf_event_on_cpu(cpu);
+		if (err) {
+			printk(KERN_ERR "mce: error initializing mce tracepoint"
+					" on cpu %d\n", cpu);
+
+			for (i = cpu - 1; i >= 0; i--)
+				mcheck_disable_perf_event_on_cpu(i);
+		}
+	}
+
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
@@ -2076,6 +2162,7 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		mce_create_device(cpu);
 		if (threshold_cpu_callback)
 			threshold_cpu_callback(action, cpu);
+		mcheck_enable_perf_event_on_cpu(cpu);
 		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
@@ -2087,6 +2174,7 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	case CPU_DOWN_PREPARE_FROZEN:
 		del_timer_sync(t);
 		smp_call_function_single(cpu, mce_disable_cpu, &action, 1);
+		mcheck_disable_perf_event_on_cpu(cpu);
 		break;
 	case CPU_DOWN_FAILED:
 	case CPU_DOWN_FAILED_FROZEN:
@@ -2096,6 +2184,7 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 			add_timer_on(t, cpu);
 		}
 		smp_call_function_single(cpu, mce_reenable_cpu, &action, 1);
+		mcheck_enable_perf_event_on_cpu(cpu);
 		break;
 	case CPU_POST_DEAD:
 		/* intentionally ignoring frozen here */
-- 
1.7.1

