Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab0DTIWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 04:22:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64685 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753857Ab0DTIWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 04:22:46 -0400
Message-ID: <4BCD646B.1080206@cn.fujitsu.com>
Date: Tue, 20 Apr 2010 16:23:07 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>
CC: Eric Paris <eparis@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Eric Paris <eparis@parisplace.org>, Miles Lane <miles.lane@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] RCU: don't turn off lockdep when find suspicious rcu_dereference_check()
 usage
References: <a44ae5cd1003071726u1f94336h7ab6c7b80d16723b@mail.gmail.com> <20100311032843.GE6767@linux.vnet.ibm.com> <q2x7e0fb38c1004121144rb097e521hd2a7d8cea77c54b7@mail.gmail.com> <1271098032.4807.137.camel@twins> <1271242058.32749.19.camel@laptop> <1271701612.2972.5.camel@dhcp231-113.rdu.redhat.com> <20100419230136.GA16856@linux.vnet.ibm.com> <1271726729.2972.13.camel@dhcp231-113.rdu.redhat.com> <20100420030452.GB2905@linux.vnet.ibm.com>
In-Reply-To: <20100420030452.GB2905@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> On Mon, Apr 19, 2010 at 09:25:29PM -0400, Eric Paris wrote:
>> On Mon, 2010-04-19 at 16:01 -0700, Paul E. McKenney wrote:
>>
>>> Yep, different code path to the same location.  Does the following
>>> patch help?
>>>
>>> 							Thanx, Paul
>>>
>>> ------------------------------------------------------------------------
>>>
>>> commit 2836f18139267ea918ed2cf39023fb0eb38c4361
>>> Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>>> Date:   Mon Apr 19 15:59:50 2010 -0700
>>>
>>>     rcu: fix RCU lockdep splat on freezer_fork path
>>>     
>>>     Add an RCU read-side critical section to suppress this false positive.
>>>     
>>>     Located-by: Eric Paris <eparis@parisplace.org>
>>>     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>> That one is also fixed so feel free to add a tested or something from
>> me.  But we've got another, weeeee!  If there some way I could get all
>> of these at once?

This patch fits your requirement.

> 
> Sure!  I -think- that if you remove the first "if" statement in
> lockdep_rcu_dereference() in kernel/lockdep.c, you will get lots of them
> all at once.  Maybe more than your console log is able to hold...
> 
> So another approach would be to print only the first 100 or some such.
> 
> It -looks- to me that you could make __debug_locks_off() atomically
> decrement a counter rather than just setting it to zero, see
> include/linux/debug_locks.h.  I suspect that atomic_dec_not_zero()
> would work very well for you here.
> 

[PATCH] RCU: don't turn off lockdep when find suspicious rcu_dereference_check() usage

When suspicious rcu_dereference_check() usage is detected, lockdep is still
available actually, so we should not call debug_locks_off() in
lockdep_rcu_dereference().

For get rid of too much "suspicious rcu_dereference_check() usage"
output when the "if(!debug_locks_off())" statement is removed. This patch uses
static variable '__warned's for very usage of "rcu_dereference*()".

One variable per usage, so, Now, we can get multiple complaint
when we detect multiple different suspicious rcu_dereference_check() usage.

Requested-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 9f1ddfe..30b8d20 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -193,6 +193,15 @@ static inline int rcu_read_lock_sched_held(void)
 
 #ifdef CONFIG_PROVE_RCU
 
+#define __do_rcu_dereference_check(c)					\
+	do {								\
+		static bool __warned;					\
+		if (debug_lockdep_rcu_enabled() && !__warned && !(c)) {	\
+			__warned = true;				\
+			lockdep_rcu_dereference(__FILE__, __LINE__);	\
+		}							\
+	} while (0)
+
 /**
  * rcu_dereference_check - rcu_dereference with debug checking
  * @p: The pointer to read, prior to dereferencing
@@ -222,8 +231,7 @@ static inline int rcu_read_lock_sched_held(void)
  */
 #define rcu_dereference_check(p, c) \
 	({ \
-		if (debug_lockdep_rcu_enabled() && !(c)) \
-			lockdep_rcu_dereference(__FILE__, __LINE__); \
+		__do_rcu_dereference_check(c); \
 		rcu_dereference_raw(p); \
 	})
 
@@ -240,8 +248,7 @@ static inline int rcu_read_lock_sched_held(void)
  */
 #define rcu_dereference_protected(p, c) \
 	({ \
-		if (debug_lockdep_rcu_enabled() && !(c)) \
-			lockdep_rcu_dereference(__FILE__, __LINE__); \
+		__do_rcu_dereference_check(c); \
 		(p); \
 	})
 
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 78325f8..cc52ffe 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3788,8 +3788,6 @@ void lockdep_rcu_dereference(const char *file, const int line)
 {
 	struct task_struct *curr = current;
 
-	if (!debug_locks_off())
-		return;
 	printk("\n===================================================\n");
 	printk(  "[ INFO: suspicious rcu_dereference_check() usage. ]\n");
 	printk(  "---------------------------------------------------\n");
