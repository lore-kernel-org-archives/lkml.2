Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031247Ab2CUOfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 10:35:14 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:42166 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030929Ab2CUOfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 10:35:01 -0400
From: Borislav Petkov <bp@amd64.org>
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 2/2] x86, mce: Add persistent MCE event
Date: Wed, 21 Mar 2012 15:34:56 +0100
Message-Id: <1332340496-21658-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.9.3.362.g71319
In-Reply-To: <1332340496-21658-1-git-send-email-bp@amd64.org>
References: <1332340496-21658-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Add the necessary glue to enable the mce_record tracepoint on boot,
turning it into a persistent event. This exports the MCE buffer through
a debugfs per-CPU file which a userspace daemon can read and then
process the received error data further.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   53 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 5a11ae2e9e91..791c4633d771 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -95,6 +95,13 @@ static DECLARE_WAIT_QUEUE_HEAD(mce_chrdev_wait);
 static DEFINE_PER_CPU(struct mce, mces_seen);
 static int			cpu_missing;
 
+static struct perf_event_attr pattr = {
+	.type           = PERF_TYPE_TRACEPOINT,
+	.size           = sizeof(pattr),
+	.sample_type    = PERF_SAMPLE_RAW,
+	.persistent     = 1,
+};
+
 /* MCA banks polled by the period polling timer for corrected events */
 DEFINE_PER_CPU(mce_banks_t, mce_poll_banks) = {
 	[0 ... BITS_TO_LONGS(MAX_NR_BANKS)-1] = ~0UL
@@ -102,6 +109,8 @@ DEFINE_PER_CPU(mce_banks_t, mce_poll_banks) = {
 
 static DEFINE_PER_CPU(struct work_struct, mce_work);
 
+static DEFINE_PER_CPU(struct pers_event_desc, mce_ev);
+
 /*
  * CPU/chipset specific EDAC code can register a notifier call here to print
  * MCE errors in a human-readable form.
@@ -2109,6 +2118,50 @@ static void __cpuinit mce_reenable_cpu(void *h)
 	}
 }
 
+static __init int mcheck_init_persistent_event(void)
+{
+
+#define MCE_RECORD_FNAME_SZ 14
+#define MCE_BUF_PAGES 4
+
+	int cpu, err = 0;
+	char buf[MCE_RECORD_FNAME_SZ];
+
+	pattr.config = event_mce_record.event.type;
+	pattr.sample_period = 1;
+	pattr.wakeup_events = 1;
+
+	get_online_cpus();
+
+	for_each_online_cpu(cpu) {
+		struct pers_event_desc *d = &per_cpu(mce_ev, cpu);
+
+		snprintf(buf, MCE_RECORD_FNAME_SZ, "mce_record%d", cpu);
+		d->dfs_name = buf;
+		d->pattr = &pattr;
+
+		if (perf_add_persistent_on_cpu(cpu, d, mce_get_debugfs_dir(),
+					       MCE_BUF_PAGES))
+			goto err_unwind;
+	}
+	goto unlock;
+
+err_unwind:
+	err = -EINVAL;
+	for (--cpu; cpu >= 0; cpu--)
+		perf_rm_persistent_on_cpu(cpu, &per_cpu(mce_ev, cpu));
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
-- 
1.7.9.3.362.g71319

