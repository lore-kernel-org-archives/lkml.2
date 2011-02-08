Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab1BHRj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 12:39:57 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:37866 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705Ab1BHRj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 12:39:56 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=89lbRuzEqs8A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=QaratO7z86VihbQettAA:9 a=HvH_Ka8dJg4-BIMekAQA:7 a=2vLzxS1meb_2QgNHRB-1EI4esYoA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [PATCH] lockdep/timers: Explain in detail the locking problems
 del_timer_sync() may cause
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Yong Zhang <yong.zhang0@gmail.com>, Nick Bowler <nbowler@elliptictech.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1297184127.13327.142.camel@laptop>
References: <20110203031943.GA8910@elliptictech.com>
	 <20110203091227.GA1603@zhy> <1296725440.26581.354.camel@laptop>
	 <20110203101739.GA1551@zhy> <1296729184.26581.361.camel@laptop>
	 <20110203114218.GA1809@zhy>  <1297184127.13327.142.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 08 Feb 2011 12:39:54 -0500
Message-ID: <1297186794.23343.19.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Twice I had to explain the output about why lockdep gives an error with
locks in IRQ context and with del_timer_sync(). Might as well write it
up and place it in the comments above the code in del_timer_sync().
Perhaps the next time this lockdep dump triggers people will understand
the issues.

It is a ticky issue and very subtle, explaining it in detail in the code
may help others understand the issue when they stumble upon the bug
again.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/timer.c b/kernel/timer.c
index d53ce66..d748321 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -964,6 +964,25 @@ EXPORT_SYMBOL(try_to_del_timer_sync);
  * add_timer_on(). Upon exit the timer is not queued and the handler is
  * not running on any CPU.
  *
+ * Note: You must not hold locks that are held in interrupt context
+ *   while calling this function. Even if the lock has nothing to do
+ *   with the timer in question.  Here's why:
+ *
+ *    CPU0                             CPU1
+ *    ----                             ----
+ *                                   <SOFTIRQ>
+ *                                   call_timer_fn();
+ *                                     base->running_timer = mytimer;
+ *  spin_lock_irq(somelock);
+ *                                     <IRQ>
+ *                                        spin_lock(somelock);
+ *  del_timer_sync(mytimer);
+ *   while (base->running_timer == mytimer);
+ *
+ * Now del_timer_sync() will never return and never release somelock.
+ * The interrupt on the other CPU is waiting to grab somelock but
+ * it has interrupted the softirq that CPU0 is waiting to finish.
+ *
  * The function returns whether it has deactivated a pending timer or not.
  */
 int del_timer_sync(struct timer_list *timer)
@@ -971,6 +990,10 @@ int del_timer_sync(struct timer_list *timer)
 #ifdef CONFIG_LOCKDEP
 	unsigned long flags;
 
+	/*
+	 * If lockdep gives a backtrace here, please reference
+	 * the synchronization rules above.
+	 */
 	raw_local_irq_save(flags);
 	local_bh_disable();
 	lock_map_acquire(&timer->lockdep_map);


