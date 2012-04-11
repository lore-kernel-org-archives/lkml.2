Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab2DKIHv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 04:07:51 -0400
Received: from mga03.intel.com ([143.182.124.21]:22651 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922Ab2DKIHm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 04:07:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="129534377"
From: "Tu, Xiaobing" <xiaobing.tu@intel.com>
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "Zuo, Jiao" <jiao.zuo@intel.com>
Subject: [RFC 1/2] kernel patch for dump user space stack tool
Thread-Topic: [RFC 1/2] kernel patch for dump user space stack tool
Thread-Index: Ac0XskWlaD7yFSDNT9mu3HsJv3yBEQAAahrQAAGA81A=
Importance: high
X-Priority: 1
Date: Wed, 11 Apr 2012 08:07:07 +0000
Message-ID: <EE928378561BF1449699C96571234A740FCE3704@SHSMSX102.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: xiaobing tu <xiaobing.tu@intel.com> 

Here is the kernel patch for this tool, The idea is to output user space stack call-chain from /proc/xxx/stack, currently, /proc/xxx/stack only output kernel stack call chain. We extend it to output user space call chain in hex format

Signed-off-by: yanmin zhang <yanmin_zhang@linux.intel.com>
Signed-off-by: xiaobing tu <xiaobing.tu@intel.com>
---
 arch/x86/kernel/stacktrace.c |   55 ++++++++++++++++++++++++++++++++++++++++++
 fs/proc/base.c               |   19 +++++++++++++-
 include/linux/stacktrace.h   |    5 +++-
 3 files changed, 77 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c index fdd0c64..d802f05 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -7,6 +7,7 @@
 #include <linux/stacktrace.h>
 #include <linux/module.h>
 #include <linux/uaccess.h>
+#include <linux/mm.h>
 #include <asm/stacktrace.h>
 
 static int save_stack_stack(void *data, char *name) @@ -144,3 +145,57 @@ void save_stack_trace_user(struct stack_trace *trace)
 		trace->entries[trace->nr_entries++] = ULONG_MAX;  }
 
+static inline void __save_stack_trace_user_task(struct task_struct *task,
+		struct stack_trace *trace)
+{
+	const struct pt_regs *regs = task_pt_regs(task);
+	const void __user *fp;
+	unsigned long addr;
+
+	if (task != current && task->state == TASK_RUNNING && task->on_cpu) {
+		/* To trap into kernel at least once */
+		smp_send_reschedule(task_cpu(task));
+	}
+
+	fp = (const void __user *)regs->bp;
+	if (trace->nr_entries < trace->max_entries)
+		trace->entries[trace->nr_entries++] = regs->ip;
+
+	while (trace->nr_entries < trace->max_entries) {
+		struct stack_frame_user frame;
+
+		frame.next_fp = NULL;
+		frame.ret_addr = 0;
+
+		addr = (unsigned long)fp;
+		if (!access_process_vm(task, addr, (void *)&frame,
+				sizeof(frame), 0))
+			break;
+		if ((unsigned long)fp < regs->sp)
+			break;
+		if (frame.ret_addr) {
+			trace->entries[trace->nr_entries++] =
+				frame.ret_addr;
+		}
+		if (fp == frame.next_fp)
+			break;
+		fp = frame.next_fp;
+	}
+}
+
+void save_stack_trace_user_task(struct task_struct *task,
+		struct stack_trace *trace)
+{
+	if (task == current || !task) {
+		save_stack_trace_user(trace);
+		return;
+	}
+
+	if (task->mm)
+		__save_stack_trace_user_task(task, trace);
+
+	if (trace->nr_entries < trace->max_entries)
+		trace->entries[trace->nr_entries++] = ULONG_MAX; } 
+EXPORT_SYMBOL_GPL(save_stack_trace_user_task);
+
diff --git a/fs/proc/base.c b/fs/proc/base.c index d4548dd..603e708 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -327,8 +327,25 @@ static int proc_pid_stack(struct seq_file *m, struct pid_namespace *ns,
 			seq_printf(m, "[<%pK>] %pS\n",
 				   (void *)entries[i], (void *)entries[i]);
 		}
-		unlock_trace(task);
+	} else
+		goto out;
+
+	trace.nr_entries	= 0;
+	trace.max_entries	= MAX_STACK_TRACE_DEPTH;
+	trace.entries		= entries;
+	trace.skip		= 0;
+
+	seq_printf(m, "userspace\n");
+
+	save_stack_trace_user_task(task, &trace);
+
+	for (i = 0; i < trace.nr_entries; i++) {
+		if (entries[i] != ULONG_MAX)
+			seq_printf(m, "%p\n", (void *)entries[i]);
 	}
+	unlock_trace(task);
+
+out:
 	kfree(entries);
 
 	return err;
diff --git a/include/linux/stacktrace.h b/include/linux/stacktrace.h index 115b570..65e9ae4 100644
--- a/include/linux/stacktrace.h
+++ b/include/linux/stacktrace.h
@@ -23,8 +23,11 @@ extern void print_stack_trace(struct stack_trace *trace, int spaces);
 
 #ifdef CONFIG_USER_STACKTRACE_SUPPORT
 extern void save_stack_trace_user(struct stack_trace *trace);
+extern void save_stack_trace_user_task(struct task_struct *task,
+		struct stack_trace *trace);
 #else
-# define save_stack_trace_user(trace)              do { } while (0)
+# define save_stack_trace_user(trace)			do { } while (0)
+# define save_stack_trace_user_task(task, trace)	do { } while (0)
 #endif
 
 #else
--
1.7.6
