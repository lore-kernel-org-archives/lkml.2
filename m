Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab2LULRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 06:17:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355Ab2LULQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 06:16:55 -0500
From: Anton Arapov <anton@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Anton Arapov <anton@redhat.com>
Subject: [RFC PATCH 5/6] uprobes: add bp_vaddr argument to consumer handler
Date: Fri, 21 Dec 2012 12:16:35 +0100
Message-Id: <1356088596-17858-6-git-send-email-anton@redhat.com>
In-Reply-To: <1356088596-17858-1-git-send-email-anton@redhat.com>
References: <1356088596-17858-1-git-send-email-anton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add argument to handler() to pass the breakpoint address(bp_vaddr). This makes
uprobes consistent, doesn't require users to calculate the pre-breakpoint
address themselves as well as remove uprobes.h import(see the cuts in
trace_event.c here). It also simplifies implementation of the return
probes(uretprobes).

I can't foresee whether anything else from the u[ret]probes should be exposed
the same way as breakpoint address and bet on it as unlikely, so I think
anything heavier than just a sufficient to pass an address variable is overkill.
Any input are welcome though.

Signed-off-by: Anton Arapov <anton@redhat.com>
---
 include/linux/uprobes.h     |  2 +-
 kernel/events/uprobes.c     |  9 +++++----
 kernel/trace/trace_uprobe.c | 20 +++++++++++---------
 3 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 1222a2c..741cc77 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -39,7 +39,7 @@ struct inode;
 #endif
 
 struct uprobe_consumer {
-	int (*handler)(struct uprobe_consumer *self, struct pt_regs *regs);
+	int (*handler)(struct uprobe_consumer *self, unsigned long bp_vaddr, struct pt_regs *regs);
 
 	struct uprobe_consumer *next;
 };
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index a3b3a60..d4016282 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -454,7 +454,8 @@ static struct uprobe *alloc_uprobe(struct inode *inode, loff_t offset)
 	return uprobe;
 }
 
-static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
+static void
+handler_chain(struct uprobe *uprobe, unsigned long bp_vaddr, struct pt_regs *regs)
 {
 	struct uprobe_consumer *uc;
 
@@ -463,7 +464,7 @@ static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
 		prepare_uretprobe(uprobe, regs);
 
 	for (uc = uprobe->consumers; uc; uc = uc->next)
-		uc->handler(uc, regs);
+		uc->handler(uc, bp_vaddr, regs);
 	up_read(&uprobe->register_rwsem);
 }
 
@@ -473,7 +474,7 @@ static void uretprobe_handler_chain(struct uprobe *uprobe, unsigned long bp_vadd
 
 	down_read(&uprobe->register_rwsem);
 	for (uc = uprobe->return_consumers; uc; uc = uc->next)
-		uc->handler(uc, regs);
+		uc->handler(uc, bp_vaddr, regs);
 	up_read(&uprobe->register_rwsem);
 }
 
@@ -1676,7 +1677,7 @@ static void handle_swbp(struct pt_regs *regs)
 			goto restart;
 	}
 
-	handler_chain(uprobe, regs);
+	handler_chain(uprobe, bp_vaddr, regs);
 	if (can_skip_sstep(uprobe, regs))
 		goto out;
 
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 920dfd0..999da12 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -20,7 +20,6 @@
 
 #include <linux/module.h>
 #include <linux/uaccess.h>
-#include <linux/uprobes.h>
 #include <linux/namei.h>
 #include <linux/string.h>
 
@@ -62,7 +61,7 @@ static void unregister_uprobe_event(struct trace_uprobe *tu);
 static DEFINE_MUTEX(uprobe_lock);
 static LIST_HEAD(uprobe_list);
 
-static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs);
+static int uprobe_dispatcher(struct uprobe_consumer *con, unsigned long bp_vaddr, struct pt_regs *regs);
 
 /*
  * Allocate new trace_uprobe and initialize it (including uprobes).
@@ -465,7 +464,8 @@ static const struct file_operations uprobe_profile_ops = {
 };
 
 /* uprobe handler */
-static void uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
+static void
+uprobe_trace_func(struct trace_uprobe *tu, unsigned long bp_vaddr, struct pt_regs *regs)
 {
 	struct uprobe_trace_entry_head *entry;
 	struct ring_buffer_event *event;
@@ -488,7 +488,7 @@ static void uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
 		return;
 
 	entry = ring_buffer_event_data(event);
-	entry->ip = uprobe_get_swbp_addr(task_pt_regs(current));
+	entry->ip = bp_vaddr;
 	data = (u8 *)&entry[1];
 	for (i = 0; i < tu->nr_args; i++)
 		call_fetch(&tu->args[i].fetch, regs, data + tu->args[i].offset);
@@ -642,7 +642,8 @@ static int set_print_fmt(struct trace_uprobe *tu)
 
 #ifdef CONFIG_PERF_EVENTS
 /* uprobe profile handler */
-static void uprobe_perf_func(struct trace_uprobe *tu, struct pt_regs *regs)
+static void
+uprobe_perf_func(struct trace_uprobe *tu, unsigned long bp_vaddr, struct pt_regs *regs)
 {
 	struct ftrace_event_call *call = &tu->call;
 	struct uprobe_trace_entry_head *entry;
@@ -663,7 +664,7 @@ static void uprobe_perf_func(struct trace_uprobe *tu, struct pt_regs *regs)
 	if (!entry)
 		goto out;
 
-	entry->ip = uprobe_get_swbp_addr(task_pt_regs(current));
+	entry->ip = bp_vaddr;
 	data = (u8 *)&entry[1];
 	for (i = 0; i < tu->nr_args; i++)
 		call_fetch(&tu->args[i].fetch, regs, data + tu->args[i].offset);
@@ -703,7 +704,8 @@ int trace_uprobe_register(struct ftrace_event_call *event, enum trace_reg type,
 	return 0;
 }
 
-static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs)
+static int
+uprobe_dispatcher(struct uprobe_consumer *con, unsigned long bp_vaddr, struct pt_regs *regs)
 {
 	struct uprobe_trace_consumer *utc;
 	struct trace_uprobe *tu;
@@ -714,11 +716,11 @@ static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs)
 		return 0;
 
 	if (tu->flags & TP_FLAG_TRACE)
-		uprobe_trace_func(tu, regs);
+		uprobe_trace_func(tu, bp_vaddr, regs);
 
 #ifdef CONFIG_PERF_EVENTS
 	if (tu->flags & TP_FLAG_PROFILE)
-		uprobe_perf_func(tu, regs);
+		uprobe_perf_func(tu, bp_vaddr, regs);
 #endif
 	return 0;
 }
-- 
1.8.0.2

