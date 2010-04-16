Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250Ab0DPLrN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 07:47:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757929Ab0DPLrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 07:47:11 -0400
Date: Fri, 16 Apr 2010 13:45:57 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-rt-users@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Clark Williams <williams@redhat.com>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC: PATCH] lockdep: Make MAX_STACK_TRACE_ENTRIES configurable.
Message-ID: <alpine.LFD.2.00.1004161329030.11320@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch was created against v2.6.33.2-rt13 but is also intended for 
mainline.

Certain debug configurations tend to go over the MAX_STACK_TRACE_ENTRIES
limit without there really being any problem.

This patch keeps the old default, but allows the user to configure a 
higher value if desired.

I tend to bump this value up for real-time debug configurations for 
example. This is preferrable to indiscriminately turning off the locking 
correctness validator.

There have been some attempts to increase the default value in the past, 
that were met with resistance by some, because of the legitimate concern 
that this was growing too large and that we need to understand why. By 
making it configurable, I hope to satisfy both sets of people - those who 
believe they need to set it larger under special circumstances, and those 
who want a reasonably small default.

>From 57479e7620d312353f5f5b173742e011896a9c74 Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Fri, 16 Apr 2010 13:24:02 +0200
Subject: [RFC: PATCH] lockdep: Make MAX_STACK_TRACE_ENTRIES configurable.

Certain configurations that have LOCKDEP turned on, run into the limit
where the MAX_STACK_TRACE_ENTRIES are too small. Rather than simply
turning of the locking correctness validator let the user configure this
value to something reasonable for their system.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 kernel/lockdep.c           |    8 ++++----
 kernel/lockdep_internals.h |    6 ------
 lib/Kconfig.debug          |    9 +++++++++
 3 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 1199bda..6030521 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -368,12 +368,12 @@ static int verbose(struct lock_class *class)
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
@@ -395,11 +395,11 @@ static int save_trace(struct stack_trace *trace)
 
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
index a2ee95a..6887711 100644
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
 
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index cbf6e02..ad35402 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -509,6 +509,15 @@ config LOCKDEP
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

