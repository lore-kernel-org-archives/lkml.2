Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223Ab2CZBhL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 21:37:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:44402 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754567Ab2CZBgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 21:36:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="123138381"
Subject: [PATCH_V2 2/2] enable dumpstack() to printk log level
From: "he, bo" <bo.he@intel.com>
To: Ingo Molnar <mingo@kernel.org>, akpm@linux-foudation.org, mingo@elte.hu,
        rusty@rustcorp.com.au, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, william.douglas@intel.com
Cc: yanmin_zhang@linux.intel.com
In-Reply-To: <20120323122208.GB13920@gmail.com>
References: <1332493027.2359.5.camel@hebo> <1332493269.2359.9.camel@hebo>
	 <20120323122208.GB13920@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Mar 2012 09:36:30 +0800
Message-ID: <1332725790.2359.28.camel@hebo>
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
index 4025fe4..2ffa890 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -177,20 +177,29 @@ void show_stack(struct task_struct *task, unsigned long *sp)
 }
 
 /*
- * The architecture-independent dump_stack generator
+ * The architecture-dependent dump_stack_log_lvl generator
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
+EXPORT_SYMBOL_GPL(dump_stack_log_lvl);
+
+/*
+ * The architecture-dependent dump_stack generator
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
index 53bff4c..fd14940 100644
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
+EXPORT_SYMBOL_GPL(dump_stack_log_lvl);
-- 
1.7.1



