Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab0DSQwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 12:52:24 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:64926 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab0DSQwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 12:52:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=MacLG75UwkEyStupFrjvwzNqocQl+fRC4hKjbd8iv6bqb5N6j0Jpl/EAu+PF7GrGr4
         TbXO2f81bHE0t4QDTJpmVO/snxynrz/p19siWNbO6vHPfMPjTpCeAf2NQsw5aK8Bi+8y
         /Eey0+Z2nZmA9z3XakWq0Oa6B/Q7VNiOOzLSs=
Date: Mon, 19 Apr 2010 18:51:57 +0200 (CEST)
From: John Kacur <jkacur@gmail.com>
X-X-Sender: jkacur@localhost
To: John Kacur <jkacur@redhat.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-rt-users@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Clark Williams <williams@redhat.com>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC: PATCH v2] lockdep: Make MAX_STACK_TRACE_ENTRIES
 configurable.
In-Reply-To: <alpine.LFD.2.00.1004161727000.11320@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1004191841230.6259@localhost>
References: <alpine.LFD.2.00.1004161329030.11320@localhost.localdomain> <alpine.LFD.2.00.1004161727000.11320@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, since nobody responded to my RFC, I am assuming that the change
is not controversial, would you please consider pulling this into tip
for 2.6.35?

What followed is v2 of the patch regenerated against the latest
tip/master

Thanks
John

>From b47fcc543e55b6d1a89c5cdf0f3f7501728bb8e1 Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Fri, 16 Apr 2010 13:24:02 +0200
Subject: [PATCH] lockdep: Make MAX_STACK_TRACE_ENTRIES configurable.
Cc: Ingo Molnar <mingo@elte.hu>,
    Peter Zijlstra <a.p.zijlstra@chello.nl>,
    Thomas Gleixner <tglx@linutronix.de>,
    Clark Williams <williams@redhat.com>,
    Luis Claudio R. Goncalves <lgoncalv@redhat.com>,
    Andrew Morton <akpm@linux-foundation.org>

Certain configurations that have LOCKDEP turned on, run into the limit
where the MAX_STACK_TRACE_ENTRIES are too small. Rather than simply
turning of the locking correctness validator let the user configure this
value to something reasonable for their system.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 kernel/lockdep.c           |    8 ++++----
 kernel/lockdep_internals.h |    6 ------
 kernel/lockdep_proc.c      |    2 +-
 lib/Kconfig.debug          |    9 +++++++++
 4 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 78325f8..2acc25d 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -369,12 +369,12 @@ static int verbose(struct lock_class *class)
  * addresses. Protected by the graph_lock.
  */
 unsigned long nr_stack_trace_entries;
-static unsigned long stack_trace[MAX_STACK_TRACE_ENTRIES];
+static unsigned long stack_trace[CONFIG_MAX_STACK_TRACE_ENTRIES];
 
 static int save_trace(struct stack_trace *trace)
 {
 	trace->nr_entries = 0;
-	trace->max_entries = MAX_STACK_TRACE_ENTRIES - nr_stack_trace_entries;
+	trace->max_entries = CONFIG_MAX_STACK_TRACE_ENTRIES - nr_stack_trace_entries;
 	trace->entries = stack_trace + nr_stack_trace_entries;
 
 	trace->skip = 3;
@@ -396,11 +396,11 @@ static int save_trace(struct stack_trace *trace)
 
 	nr_stack_trace_entries += trace->nr_entries;
 
-	if (nr_stack_trace_entries >= MAX_STACK_TRACE_ENTRIES-1) {
+	if (nr_stack_trace_entries >= CONFIG_MAX_STACK_TRACE_ENTRIES-1) {
 		if (!debug_locks_off_graph_unlock())
 			return 0;
 
-		printk("BUG: MAX_STACK_TRACE_ENTRIES too low!\n");
+		printk("BUG: CONFIG_MAX_STACK_TRACE_ENTRIES = %d too low!\n", CONFIG_MAX_STACK_TRACE_ENTRIES);
 		printk("turning off the locking correctness validator.\n");
 		dump_stack();
 
diff --git a/kernel/lockdep_internals.h b/kernel/lockdep_internals.h
index 8d7d4b6..e2585ff 100644
--- a/kernel/lockdep_internals.h
+++ b/kernel/lockdep_internals.h
@@ -61,12 +61,6 @@ enum {
 
 #define MAX_LOCKDEP_CHAIN_HLOCKS (MAX_LOCKDEP_CHAINS*5)
 
-/*
- * Stack-trace: tightly packed array of stack backtrace
- * addresses. Protected by the hash_lock.
- */
-#define MAX_STACK_TRACE_ENTRIES	262144UL
-
 extern struct list_head all_lock_classes;
 extern struct lock_chain lock_chains[];
 
diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index 59b76c8..924e0e9 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -306,7 +306,7 @@ static int lockdep_stats_show(struct seq_file *m, void *v)
 	seq_printf(m, " in-process chains:             %11u\n",
 			nr_process_chains);
 	seq_printf(m, " stack-trace entries:           %11lu [max: %lu]\n",
-			nr_stack_trace_entries, MAX_STACK_TRACE_ENTRIES);
+			nr_stack_trace_entries, CONFIG_MAX_STACK_TRACE_ENTRIES);
 	seq_printf(m, " combined max dependencies:     %11u\n",
 			(nr_hardirq_chains + 1) *
 			(nr_softirq_chains + 1) *
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 0bbd5c7..38d3bf3 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -533,6 +533,15 @@ config LOCKDEP
 	select KALLSYMS
 	select KALLSYMS_ALL
 
+config MAX_STACK_TRACE_ENTRIES
+	int "MAX_STACK_TRACE_ENTRIES for LOCKDEP"
+	depends on LOCKDEP
+	default 262144
+	help
+	   This option allows you to change the default MAX_STACK_TRACE_ENTRIES
+	   used for LOCKDEP. Warning, increasing this number will increase the
+	   size of the stack_trace array, and thus the kernel size too.
+
 config LOCK_STAT
 	bool "Lock usage statistics"
 	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
-- 
1.6.6.1

