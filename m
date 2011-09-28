Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab1I1NHh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 09:07:37 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45122 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752894Ab1I1NHg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 09:07:36 -0400
Subject: [PATCH] kmemleak: Show where early_log issues come from
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@google.com>, Steven Rostedt <rostedt@goodmis.org>
Date: Wed, 28 Sep 2011 14:07:22 +0100
Message-ID: <20110928130553.8707.82034.stgit@e102109-lin.cambridge.arm.com>
User-Agent: StGit/0.15-118-g0cb4
MIME-Version: 1.0
X-OriginalArrivalTime: 28 Sep 2011 13:07:30.0666 (UTC) FILETIME=[9454B4A0:01CC7DDF]
X-MC-Unique: 111092814073303801
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on initial patch by Steven Rostedt.

Early kmemleak warnings did not show where the actual kmemleak API had
been called from but rather just a backtrace to the kmemleak_init()
function. By having all early kmemleak logs record the stack_trace, we
can have kmemleak_init() write exactly where the problem occurred. This
patch adds the setting of the kmemleak_warning variable every time a
kmemleak warning is issued. The kmemleak_init() function checks this
variable during early log replaying and prints the log trace if there
was any warning.

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@google.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---

Steven, a simpler implementation of your idea. Basically we have
kmemleak_warn() called in several places where errors actually occur. We
can just reuse this for printing the early log information rather than
changing the function prototypes to return an error code.

 mm/kmemleak.c |   37 ++++++++++++++++++++++++++++---------
 1 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index d6880f5..573152e 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -196,7 +196,9 @@ static atomic_t kmemleak_enabled = ATOMIC_INIT(0);
 static atomic_t kmemleak_initialized = ATOMIC_INIT(0);
 /* enables or disables early logging of the memory operations */
 static atomic_t kmemleak_early_log = ATOMIC_INIT(1);
-/* set if a fata kmemleak error has occurred */
+/* set if a kmemleak warning was issued */
+static atomic_t kmemleak_warning = ATOMIC_INIT(0);
+/* set if a fatal kmemleak error has occurred */
 static atomic_t kmemleak_error = ATOMIC_INIT(0);
 
 /* minimum and maximum address that may be valid pointers */
@@ -259,9 +261,10 @@ static void kmemleak_disable(void);
 /*
  * Print a warning and dump the stack trace.
  */
-#define kmemleak_warn(x...)	do {	\
-	pr_warning(x);			\
-	dump_stack();			\
+#define kmemleak_warn(x...)	do {		\
+	pr_warning(x);				\
+	dump_stack();				\
+	atomic_set(&kmemleak_warning, 1);	\
 } while (0)
 
 /*
@@ -403,8 +406,8 @@ static struct kmemleak_object *lookup_object(unsigned long ptr, int alias)
 		object = prio_tree_entry(node, struct kmemleak_object,
 					 tree_node);
 		if (!alias && object->pointer != ptr) {
-			pr_warning("Found object by alias at 0x%08lx\n", ptr);
-			dump_stack();
+			kmemleak_warn("Found object by alias at 0x%08lx\n",
+				      ptr);
 			dump_object_info(object);
 			object = NULL;
 		}
@@ -811,8 +814,7 @@ static void __init log_early(int op_type, const void *ptr, size_t size,
 	log->ptr = ptr;
 	log->size = size;
 	log->min_count = min_count;
-	if (op_type == KMEMLEAK_ALLOC)
-		log->trace_len = __save_stack_trace(log->trace);
+	log->trace_len = __save_stack_trace(log->trace);
 	crt_early_log++;
 	local_irq_restore(flags);
 }
@@ -1659,6 +1661,17 @@ static int kmemleak_boot_config(char *str)
 }
 early_param("kmemleak", kmemleak_boot_config);
 
+static void __init print_log_trace(struct early_log *log)
+{
+	struct stack_trace trace;
+
+	trace.nr_entries = log->trace_len;
+	trace.entries = log->trace;
+
+	pr_notice("Early log backtrace:\n");
+	print_stack_trace(&trace, 2);
+}
+
 /*
  * Kmemleak initialization.
  */
@@ -1720,7 +1733,13 @@ void __init kmemleak_init(void)
 			kmemleak_no_scan(log->ptr);
 			break;
 		default:
-			WARN_ON(1);
+			kmemleak_warn("Unknown early log operation: %d\n",
+				      log->op_type);
+		}
+
+		if (atomic_read(&kmemleak_warning)) {
+			print_log_trace(log);
+			atomic_set(&kmemleak_warning, 0);
 		}
 	}
 }


