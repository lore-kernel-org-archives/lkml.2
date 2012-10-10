Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab2JJNkJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 09:40:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7014 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756334Ab2JJNio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 09:38:44 -0400
X-Authority-Analysis: v=2.0 cv=e+uEuNV/ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Uznudo2c6VkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=ICDzjrYLAOYA:10 a=VwQbUJbxAAAA:8 a=koDLa-P1KwdDXAu4Kc4A:9 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121010133843.211513401@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 10 Oct 2012 09:38:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 5/6] sched: Better debug output for might sleep
References: <20121010133801.331863565@goodmis.org>
Content-Disposition: inline; filename=0005-sched-Better-debug-output-for-might-sleep.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

might sleep can tell us where interrupts have been disabled, but we
have no idea what disabled preemption. Add some debug infrastructure.

Cc: stable-rt@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/sched.h |    4 ++++
 kernel/sched.c        |   23 +++++++++++++++++++++--
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8155129..a179dd0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1606,6 +1606,10 @@ struct task_struct {
 	int kmap_idx;
 	pte_t kmap_pte[KM_TYPE_NR];
 #endif
+
+#ifdef CONFIG_DEBUG_PREEMPT
+	unsigned long preempt_disable_ip;
+#endif
 };
 
 #ifdef CONFIG_PREEMPT_RT_FULL
diff --git a/kernel/sched.c b/kernel/sched.c
index ea235b6..38f9104 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4121,8 +4121,13 @@ void __kprobes add_preempt_count(int val)
 	DEBUG_LOCKS_WARN_ON((preempt_count() & PREEMPT_MASK) >=
 				PREEMPT_MASK - 10);
 #endif
-	if (preempt_count() == val)
-		trace_preempt_off(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
+	if (preempt_count() == val) {
+		unsigned long ip = get_parent_ip(CALLER_ADDR1);
+#ifdef CONFIG_DEBUG_PREEMPT
+		current->preempt_disable_ip = ip;
+#endif
+		trace_preempt_off(CALLER_ADDR0, ip);
+	}
 }
 EXPORT_SYMBOL(add_preempt_count);
 
@@ -4164,6 +4169,13 @@ static noinline void __schedule_bug(struct task_struct *prev)
 	print_modules();
 	if (irqs_disabled())
 		print_irqtrace_events(prev);
+#ifdef DEBUG_PREEMPT
+	if (in_atomic_preempt_off()) {
+		pr_err("Preemption disabled at:");
+		print_ip_sym(current->preempt_disable_ip);
+		pr_cont("\n");
+	}
+#endif
 
 	if (regs)
 		show_regs(regs);
@@ -8483,6 +8495,13 @@ void __might_sleep(const char *file, int line, int preempt_offset)
 	debug_show_held_locks(current);
 	if (irqs_disabled())
 		print_irqtrace_events(current);
+#ifdef DEBUG_PREEMPT
+	if (!preempt_count_equals(preempt_offset)) {
+		pr_err("Preemption disabled at:");
+		print_ip_sym(current->preempt_disable_ip);
+		pr_cont("\n");
+	}
+#endif
 	dump_stack();
 #endif
 }
-- 
1.7.10.4


