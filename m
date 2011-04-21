Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab1DUBoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 21:44:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63641 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab1DUBnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 21:43:03 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=vhdKIqpQuCYA:10 a=58hwMgPliyoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=z4OR4_r0SnS5XWO7l0MA:9 a=Yz5IEebebUY4-NlWmPwA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110421014259.643930104@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Apr 2011 21:41:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/7] lockdep: Print a nice description of simple deadlock
References: <20110421014153.126662477@goodmis.org>
Content-Disposition: inline; filename=0003-lockdep-Print-a-nice-description-of-simple-deadlock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The lockdep output can be pretty cryptic, having a nice output
can save a lot of head scratching. When a simple deadlock scenario
is detected by lockdep (lock A -> lock A) we get the following output:

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&(lock)->rlock);
  lock(&(lock)->rlock);

 *** DEADLOCK ***

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/lockdep.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 1039008..a0f253b 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -1664,6 +1664,26 @@ static inline void inc_chains(void)
 
 #endif
 
+static void
+print_deadlock_scenario(struct held_lock *nxt,
+			     struct held_lock *prv)
+{
+	struct lock_class *next = hlock_class(nxt);
+	struct lock_class *prev = hlock_class(prv);
+
+	printk(" Possible unsafe locking scenario:\n\n");
+	printk("       CPU0\n");
+	printk("       ----\n");
+	printk("  lock(");
+	__print_lock_name(prev);
+	printk(");\n");
+	printk("  lock(");
+	__print_lock_name(next);
+	printk(");\n");
+	printk("\n *** DEADLOCK ***\n\n");
+	printk(" May be due to missing lock nesting notation\n\n");
+}
+
 static int
 print_deadlock_bug(struct task_struct *curr, struct held_lock *prev,
 		   struct held_lock *next)
@@ -1682,6 +1702,7 @@ print_deadlock_bug(struct task_struct *curr, struct held_lock *prev,
 	print_lock(prev);
 
 	printk("\nother info that might help us debug this:\n");
+	print_deadlock_scenario(next, prev);
 	lockdep_print_held_locks(curr);
 
 	printk("\nstack backtrace:\n");
-- 
1.7.2.3


