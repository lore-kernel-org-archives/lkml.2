Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab1DUBoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 21:44:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:44714 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab1DUBnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 21:43:03 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=vhdKIqpQuCYA:10 a=WTyJFprZ8DsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=B71dHHKBpCslSe7RwOkA:9 a=DWbFT3_Ls2HuZX-TEggA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110421014300.436140880@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Apr 2011 21:41:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 6/7] lockdep: Print a nice description of simple irq inversion
References: <20110421014153.126662477@goodmis.org>
Content-Disposition: inline; filename=0006-lockdep-Print-a-nice-description-of-simple-irq-inver.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The lockdep output can be pretty cryptic, having a nice output
can save a lot of head scratching. When a simple irq inversion scenario
is detected by lockdep (lock A taken in interrupt context but also in
thread context without disabling interrupts) we get the following output:

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(lockA);
  <Interrupt>
    lock(lockA);

 *** DEADLOCK ***

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/lockdep.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index b531c66..3b1ac92 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2158,6 +2158,24 @@ static void check_chain_key(struct task_struct *curr)
 #endif
 }
 
+static void
+print_usage_bug_scenario(struct held_lock *lock)
+{
+	struct lock_class *class = hlock_class(lock);
+
+	printk(" Possible unsafe locking scenario:\n\n");
+	printk("       CPU0\n");
+	printk("       ----\n");
+	printk("  lock(");
+	__print_lock_name(class);
+	printk(");\n");
+	printk("  <Interrupt>\n");
+	printk("    lock(");
+	__print_lock_name(class);
+	printk(");\n");
+	printk("\n *** DEADLOCK ***\n\n");
+}
+
 static int
 print_usage_bug(struct task_struct *curr, struct held_lock *this,
 		enum lock_usage_bit prev_bit, enum lock_usage_bit new_bit)
@@ -2186,6 +2204,8 @@ print_usage_bug(struct task_struct *curr, struct held_lock *this,
 
 	print_irqtrace_events(curr);
 	printk("\nother info that might help us debug this:\n");
+	print_usage_bug_scenario(this);
+
 	lockdep_print_held_locks(curr);
 
 	printk("\nstack backtrace:\n");
-- 
1.7.2.3


