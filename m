Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353Ab0DVUQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:16:23 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:34722 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065Ab0DVUQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:16:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=xtMm+iheOfQ2VP4/2Vh2llOZDTUYeBjaHhk56owxpODb6Ct7fhY1jQdD3roViKzsjt
         rZv5yiOhhBA2E9l9VeU/bb3g4PRjXmu1r7qKON6SJh49Jqeu78hOUrSHGseQc0t46zQu
         RklGgPhJ+pBdbUzA5e3DvXp36mkwi4frmyBDU=
Date: Thu, 22 Apr 2010 22:15:48 +0200 (CEST)
From: John Kacur <jkacur@gmail.com>
X-X-Sender: jkacur@localhost
To: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
       Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
       Clark Williams <williams@redhat.com>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH] lockdep: Add nr_save_trace_invocations counter
Message-ID: <alpine.LFD.2.00.1004222208310.3155@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NOT FOR INCLUSION

I created this patch as a result of Peter Zilstra's request to get more 
info from lockdep. This patch is not for inclusion, at least in its 
present form, because it adds some redunant info to /proc/lockdep_stats

However, some of the fields are new, and it is worth examining, and / or 
applying if you are looking at the MAX_STACK_TRACE_ENTRIES too big 
problem.

I generated this patch against a recent tip/master but it applies without 
conflicts to the latest rt kernel as well. Comments are welcome, in fact 
they are appreciated.

>From 5181c0296dd1549e4e706ff25a4cd81a1d90137d Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Thu, 22 Apr 2010 17:02:42 +0200
Subject: [PATCH] lockdep: Add nr_save_trace_invocations counter

Add the nr_save_trace_invocations counter which counts the number of
time save_trace() is invoked when relevant for trace enteries.

This means, those invocations from mark_lock() and add_lock_to_list()

When called from mark_lock() we break it down into LOCKSTATE categories.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 kernel/lockdep.c           |   20 ++++++++++++++++++++
 kernel/lockdep_internals.h |    2 ++
 kernel/lockdep_proc.c      |   23 +++++++++++++++++++++++
 3 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 78325f8..f921576 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -371,6 +371,10 @@ static int verbose(struct lock_class *class)
 unsigned long nr_stack_trace_entries;
 static unsigned long stack_trace[MAX_STACK_TRACE_ENTRIES];
 
+/* Calls to save_trace() from mark_lock() and add_lock_to_list() only*/
+unsigned long nr_save_trace_invocations;
+unsigned long nr_save_trace_invocations_type[LOCK_USAGE_STATES];
+
 static int save_trace(struct stack_trace *trace)
 {
 	trace->nr_entries = 0;
@@ -410,6 +414,19 @@ static int save_trace(struct stack_trace *trace)
 	return 1;
 }
 
+/*
+ * This function is only called from mark_lock() and add_lock_to_list()
+ * which are only called when holding the graph_lock. This counter
+ * piggybacks off of that lock
+ */
+static void inc_save_trace_invocations(enum lock_usage_bit new_bit)
+{
+	nr_save_trace_invocations++;
+	if (WARN_ON(new_bit >= LOCK_USAGE_STATES))
+		return;
+	nr_save_trace_invocations_type[new_bit]++;
+}
+
 unsigned int nr_hardirq_chains;
 unsigned int nr_softirq_chains;
 unsigned int nr_process_chains;
@@ -449,6 +466,7 @@ static const char *usage_str[] =
 #define LOCKDEP_STATE(__STATE) __USAGE(__STATE)
 #include "lockdep_states.h"
 #undef LOCKDEP_STATE
+#undef __USAGE
 	[LOCK_USED] = "INITIAL USE",
 };
 
@@ -816,6 +834,7 @@ static int add_lock_to_list(struct lock_class *class, struct lock_class *this,
 	if (!entry)
 		return 0;
 
+	nr_save_trace_invocations++;
 	if (!save_trace(&entry->trace))
 		return 0;
 
@@ -2615,6 +2634,7 @@ static int mark_lock(struct task_struct *curr, struct held_lock *this,
 
 	hlock_class(this)->usage_mask |= new_mask;
 
+	inc_save_trace_invocations(new_bit);
 	if (!save_trace(hlock_class(this)->usage_traces + new_bit))
 		return 0;
 
diff --git a/kernel/lockdep_internals.h b/kernel/lockdep_internals.h
index 8d7d4b6..6149358 100644
--- a/kernel/lockdep_internals.h
+++ b/kernel/lockdep_internals.h
@@ -84,6 +84,8 @@ extern unsigned long nr_list_entries;
 extern unsigned long nr_lock_chains;
 extern int nr_chain_hlocks;
 extern unsigned long nr_stack_trace_entries;
+extern unsigned long nr_save_trace_invocations;
+extern unsigned long nr_save_trace_invocations_type[LOCK_USAGE_STATES];
 
 extern unsigned int nr_hardirq_chains;
 extern unsigned int nr_softirq_chains;
diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index 59b76c8..ef5f372 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -215,8 +215,24 @@ static void lockdep_stats_debug_show(struct seq_file *m)
 #endif
 }
 
+#define __USAGE(__STATE)	\
+[LOCK_USED_IN_##__STATE] = "LOCK_USED_IN_"__stringify(__STATE),	\
+[LOCK_ENABLED_##__STATE] = "LOCK_ENABLED_"__stringify(__STATE), \
+[LOCK_USED_IN_##__STATE##_READ] = "LOCK_USED_IN_"__stringify(__STATE)"_READ", \
+[LOCK_ENABLED_##__STATE##_READ] = "LOCK_ENABLED_"__stringify(__STATE)"_READ",
+
+static const char *lockstate_tostr[] =
+{
+#define LOCKDEP_STATE(__STATE) __USAGE(__STATE)
+#include "lockdep_states.h"
+#undef LOCKDEP_STATE
+#undef __USAGE
+	[LOCK_USED] = "LOCK_USED",
+};
+
 static int lockdep_stats_show(struct seq_file *m, void *v)
 {
+	int bit;
 	struct lock_class *class;
 	unsigned long nr_unused = 0, nr_uncategorized = 0,
 		      nr_irq_safe = 0, nr_irq_unsafe = 0,
@@ -307,6 +323,13 @@ static int lockdep_stats_show(struct seq_file *m, void *v)
 			nr_process_chains);
 	seq_printf(m, " stack-trace entries:           %11lu [max: %lu]\n",
 			nr_stack_trace_entries, MAX_STACK_TRACE_ENTRIES);
+	seq_printf(m, " stack-trace invocations: %lu\n",
+			nr_save_trace_invocations);
+
+	for (bit=0; bit < LOCK_USAGE_STATES; bit++)
+		seq_printf(m, "\t%s: %lu\n", lockstate_tostr[bit],
+			       nr_save_trace_invocations_type[bit]);	
+
 	seq_printf(m, " combined max dependencies:     %11u\n",
 			(nr_hardirq_chains + 1) *
 			(nr_softirq_chains + 1) *
-- 
1.6.6.1

