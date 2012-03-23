Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757721Ab2CWJB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 05:01:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:58578 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757250Ab2CWJBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 05:01:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="120821729"
Subject: [PATCH 2/2] enable dumpstack() to printk log level
From: "he, bo" <bo.he@intel.com>
To: akpm@linux-foudation.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
        rusty@rustcorp.com.au, william.douglas@intel.com,
        linux-kernel@vger.kernel.org
Cc: yanmin_zhang@linux.intel.com
In-Reply-To: <1332493027.2359.5.camel@hebo>
References: <1332493027.2359.5.camel@hebo>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Mar 2012 17:01:09 +0800
Message-ID: <1332493269.2359.9.camel@hebo>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: he bo <bo.he@intel.com>

Function dump_stack calls printk with default log level.
At some scenarios, we need dump the logs at special log level.
For example, Android aplog saves log at a low level to reduce
log storage. With __might_sleep checking, it just prints out
the warning source line with KERNE_ERR and Android saves it to aplog,
but later dump_stack log is not saved. We couldn’t see the
important information when developers check it.
the patch adds function dump_stack_log_lvl to support this capability.

Signed-off-by: he, bo <bo.he@intel.com>
Reviewed-by: zhang, yanmin <yanmin.zhang@intel.com>
---
 arch/x86/kernel/dumpstack.c |   19 ++++++++++++++-----
 include/linux/printk.h      |    1 +
 kernel/sched/core.c         |    2 +-
 lib/dump_stack.c            |    7 ++++++-
 4 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 4025fe4..7b2160c 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -177,20 +177,29 @@ void show_stack(struct task_struct *task, unsigned long *sp)
 }
 
 /*
- * The architecture-independent dump_stack generator
+ * The architecture-independent dump_stack_log_lvl generator
  */
-void dump_stack(void)
+void dump_stack_log_lvl(char *log_lvl)
 {
 	unsigned long bp;
 	unsigned long stack;
 
 	bp = stack_frame(current, NULL);
-	printk("Pid: %d, comm: %.20s %s %s %.*s\n",
-		current->pid, current->comm, print_tainted(),
+	printk("%sPid: %d, comm: %.20s %s %s %.*s\n",
+		log_lvl, current->pid, current->comm, print_tainted(),
 		init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
 		init_utsname()->version);
-	show_trace(NULL, NULL, &stack, bp);
+	show_trace_log_lvl(NULL, NULL, &stack, bp, log_lvl);
+}
+EXPORT_SYMBOL(dump_stack_log_lvl);
+
+/*
+ * The architecture-independent dump_stack generator
+ */
+void dump_stack(void)
+{
+	dump_stack_log_lvl("");
 }
 EXPORT_SYMBOL(dump_stack);
 
diff --git a/include/linux/printk.h b/include/linux/printk.h
index 0525927..2a13dd8 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -157,6 +157,7 @@ static inline void setup_log_buf(int early)
 #endif
 
 extern void dump_stack(void) __cold;
+extern void dump_stack_log_lvl(char *log_lvl) __cold;
 
 #ifndef pr_fmt
 #define pr_fmt(fmt) fmt
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 503d642..ab0dcdf 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7060,7 +7060,7 @@ void __might_sleep(const char *file, int line, int preempt_offset)
 	debug_show_held_locks(current);
 	if (irqs_disabled())
 		print_irqtrace_events(current);
-	dump_stack();
+	dump_stack_log_lvl(KERN_ERR);
 }
 EXPORT_SYMBOL(__might_sleep);
 #endif
diff --git a/lib/dump_stack.c b/lib/dump_stack.c
index 53bff4c..d44ca5e 100644
--- a/lib/dump_stack.c
+++ b/lib/dump_stack.c
@@ -11,5 +11,10 @@ void dump_stack(void)
 	printk(KERN_NOTICE
 		"This architecture does not implement dump_stack()\n");
 }
-
 EXPORT_SYMBOL(dump_stack);
+
+void dump_stack_log_lvl(char *log_lvl)
+{
+	dump_stack();
+}
+EXPORT_SYMBOL(dump_stack_log_lvl);
-- 
1.7.1




