Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113Ab2HPRqD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 13:46:03 -0400
Received: from mail.x86-64.org ([217.9.48.20]:52298 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756649Ab2HPRpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 13:45:33 -0400
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [RFC PATCH -v2 4/4] persistent test
Date: Thu, 16 Aug 2012 19:45:23 +0200
Message-Id: <1345139123-15212-5-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.11.rc1
In-Reply-To: <1345139123-15212-1-git-send-email-bp@amd64.org>
References: <1345139123-15212-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/mce.h       |  1 +
 arch/x86/kernel/cpu/mcheck/mce.c |  5 +++++
 kernel/events/persistent.c       | 41 +++++++++++++++++++++++++++++++++++++++-
 3 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index a3ac52b29cbf..e46b05dff64a 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -256,5 +256,6 @@ struct cper_sec_mem_err;
 extern void apei_mce_report_mem_error(int corrected,
 				      struct cper_sec_mem_err *mem_err);
 
+extern int perf_get_mce_event_id(void);
 #endif /* __KERNEL__ */
 #endif /* _ASM_X86_MCE_H */
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 292d0258311c..cacd45bfac01 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -2445,3 +2445,8 @@ static int __init mcheck_debugfs_init(void)
 }
 late_initcall(mcheck_debugfs_init);
 #endif
+
+int perf_get_mce_event_id(void)
+{
+	return event_mce_record.event.type;
+}
diff --git a/kernel/events/persistent.c b/kernel/events/persistent.c
index 33d45396dc02..edb07640d5f1 100644
--- a/kernel/events/persistent.c
+++ b/kernel/events/persistent.c
@@ -10,7 +10,7 @@
 
 #include <asm/mce.h>
 
-static int pers_open_generic(struct inode *inode, struct file *filp)
+int pers_open_generic(struct inode *inode, struct file *filp)
 {
 	filp->private_data = inode->i_private;
 	return 0;
@@ -127,3 +127,42 @@ void perf_rm_persistent_event(struct perf_event_desc *desc)
 
 	perf_event_release_kernel(event);
 }
+
+static struct perf_event_attr pattr = {
+	.type		= PERF_TYPE_TRACEPOINT,
+	.size		= sizeof(pattr),
+	.sample_type	= PERF_SAMPLE_RAW,
+	.persistent	= 1,
+};
+
+static struct perf_event_desc pdesc = {
+	.dir_name	= "mce_record",
+};
+
+static int __init pers_init(void)
+{
+	struct perf_event *event;
+	char *fname;
+	int cpu = 1;
+
+	fname = kzalloc(10 + 4, GFP_KERNEL);
+	if (!fname)
+		return -ENOMEM;
+
+	snprintf(fname, 14, "persistent%d", cpu);
+	pdesc.fname = fname;
+
+	pattr.config = perf_get_mce_event_id();
+	pattr.sample_period = 1;
+	pattr.wakeup_events = 1,
+	pdesc.pattr = &pattr;
+
+	event = perf_add_persistent_on_cpu(cpu, &pdesc, 4);
+	if (IS_ERR(event)) {
+		pr_err("%s: Error adding persistent event!\n", __func__);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+late_initcall(pers_init);
-- 
1.7.11.rc1

