Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751075Ab0EGEUO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 00:20:14 -0400
Received: from ozlabs.org ([203.10.76.45]:35562 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783Ab0EGEUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 00:20:12 -0400
Date: Fri, 7 May 2010 14:20:10 +1000
From: Tony Breeds <tony@bakeyournoodle.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Tony Breeds <tonyb@au1.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH/RFC] mutex: Fix optimistic spinning vs. BKL
Message-ID: <20100507042010.GR12389@ozlabs.org>
Mail-Followup-To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Tony Breeds <tonyb@au1.ibm.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <1272429513.24542.83.camel@pasglop>
 <201004281406.04080.arnd@arndb.de>
 <1272494121.24542.113.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1272494121.24542.113.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 29, 2010 at 08:35:21AM +1000, Benjamin Herrenschmidt wrote:
> On Wed, 2010-04-28 at 14:06 +0200, Arnd Bergmann wrote:
> > 
> > This needs to use time_before() to avoid problems on jiffies
> > wraparound.
> 
> Ah right, forgot about that, been a while I didn't use jiffies for
> anything :-)
> 
> I'll respin later today.

Like thie perhaps?  If this looks good it would be great to get this in .34

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 70abfd3..991d86f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -351,7 +351,8 @@ extern signed long schedule_timeout_killable(signed long timeout);
 extern signed long schedule_timeout_uninterruptible(signed long timeout);
 asmlinkage void __schedule(void);
 asmlinkage void schedule(void);
-extern int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner);
+extern int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner,
+                               unsigned long timeout);
 
 struct nsproxy;
 struct user_namespace;
diff --git a/kernel/mutex.c b/kernel/mutex.c
index 947b3ad..fcf2573 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -145,6 +145,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	struct task_struct *task = current;
 	struct mutex_waiter waiter;
 	unsigned long flags;
+	unsigned long timeout;
 
 	preempt_disable();
 	mutex_acquire(&lock->dep_map, subclass, 0, ip);
@@ -168,15 +169,22 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	 * to serialize everything.
 	 */
 
-	for (;;) {
+	for (timeout = jiffies + 2; time_before(jiffies, timeout);) {
 		struct thread_info *owner;
 
 		/*
+		 * If we own the BKL, then don't spin. The owner of the mutex
+		 * might be waiting on us to release the BKL.
+		 */
+		if (current->lock_depth >= 0)
+			break;
+
+		/*
 		 * If there's an owner, wait for it to either
 		 * release the lock or go to sleep.
 		 */
 		owner = ACCESS_ONCE(lock->owner);
-		if (owner && !mutex_spin_on_owner(lock, owner))
+		if (owner && !mutex_spin_on_owner(lock, owner, timeout))
 			break;
 
 		if (atomic_cmpxchg(&lock->count, 1, 0) == 1) {
diff --git a/kernel/sched.c b/kernel/sched.c
index 663a1d0..ef58dc0 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5523,7 +5523,8 @@ EXPORT_SYMBOL(schedule);
  * Look out! "owner" is an entirely speculative pointer
  * access and not reliable.
  */
-int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner)
+int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner,
+			unsigned long timeout)
 {
 	unsigned int cpu;
 	struct rq *rq;
@@ -5559,7 +5560,7 @@ int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner)
 
 	rq = cpu_rq(cpu);
 
-	for (;;) {
+	while (time_before(jiffies, timeout)) {
 		/*
 		 * Owner changed, break to re-assess state.
 		 */

Yours Tony
