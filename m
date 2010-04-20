Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab0DTNwk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 09:52:40 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:36386 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073Ab0DTNwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 09:52:38 -0400
Date: Tue, 20 Apr 2010 06:52:27 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Miles Lane <miles.lane@gmail.com>
Cc: Eric Paris <eparis@redhat.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] RCU: don't turn off lockdep when find suspicious
 rcu_dereference_check() usage
Message-ID: <20100420135227.GC2628@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <q2x7e0fb38c1004121144rb097e521hd2a7d8cea77c54b7@mail.gmail.com>
 <1271098032.4807.137.camel@twins>
 <1271242058.32749.19.camel@laptop>
 <1271701612.2972.5.camel@dhcp231-113.rdu.redhat.com>
 <20100419230136.GA16856@linux.vnet.ibm.com>
 <1271726729.2972.13.camel@dhcp231-113.rdu.redhat.com>
 <20100420030452.GB2905@linux.vnet.ibm.com>
 <4BCD646B.1080206@cn.fujitsu.com>
 <1271766716.2972.16.camel@dhcp231-113.rdu.redhat.com>
 <j2ya44ae5cd1004200545q6be4ec82o18ae99d93e8c29c7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <j2ya44ae5cd1004200545q6be4ec82o18ae99d93e8c29c7@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 08:45:28AM -0400, Miles Lane wrote:
> Is there a patch set for 2.6.34-rc5 I can test?

I will be sending a patchset out later today after testing, but
please see below for a sneak preview collapsed into a single patch.

							Thanx, Paul

> On Tue, Apr 20, 2010 at 8:31 AM, Eric Paris <eparis@redhat.com> wrote:
> 
> > On Tue, 2010-04-20 at 16:23 +0800, Lai Jiangshan wrote:
> >
> > > [PATCH] RCU: don't turn off lockdep when find suspicious
> > rcu_dereference_check() usage
> > >
> > > When suspicious rcu_dereference_check() usage is detected, lockdep is
> > still
> > > available actually, so we should not call debug_locks_off() in
> > > lockdep_rcu_dereference().
> > >
> > > For get rid of too much "suspicious rcu_dereference_check() usage"
> > > output when the "if(!debug_locks_off())" statement is removed. This patch
> > uses
> > > static variable '__warned's for very usage of "rcu_dereference*()".
> > >
> > > One variable per usage, so, Now, we can get multiple complaint
> > > when we detect multiple different suspicious rcu_dereference_check()
> > usage.
> > >
> > > Requested-by: Eric Paris <eparis@redhat.com>
> > > Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> >
> > Although mine was a linux-next kernel and it doesn't appear that I have
> > rcu_dereference_protected() at all, so I dropped that bit of the patch,
> > it worked great!  I got 4 more complaints to harass people with.  Feel
> > free to add my tested by if you care to.
> >
> > Tested-by: Eric Paris <eparis@redhat.com>

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 07db2fe..ec9ab49 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -190,6 +190,15 @@ static inline int rcu_read_lock_sched_held(void)
 
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
@@ -219,8 +228,7 @@ static inline int rcu_read_lock_sched_held(void)
  */
 #define rcu_dereference_check(p, c) \
 	({ \
-		if (debug_lockdep_rcu_enabled() && !(c)) \
-			lockdep_rcu_dereference(__FILE__, __LINE__); \
+		__do_rcu_dereference_check(c); \
 		rcu_dereference_raw(p); \
 	})
 
@@ -237,8 +245,7 @@ static inline int rcu_read_lock_sched_held(void)
  */
 #define rcu_dereference_protected(p, c) \
 	({ \
-		if (debug_lockdep_rcu_enabled() && !(c)) \
-			lockdep_rcu_dereference(__FILE__, __LINE__); \
+		__do_rcu_dereference_check(c); \
 		(p); \
 	})
 
diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index da5e139..e5c0244 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -205,9 +205,12 @@ static void freezer_fork(struct cgroup_subsys *ss, struct task_struct *task)
 	 * No lock is needed, since the task isn't on tasklist yet,
 	 * so it can't be moved to another cgroup, which means the
 	 * freezer won't be removed and will be valid during this
-	 * function call.
+	 * function call.  Nevertheless, apply RCU read-side critical
+	 * section to suppress RCU lockdep false positives.
 	 */
+	rcu_read_lock();
 	freezer = task_freezer(task);
+	rcu_read_unlock();
 
 	/*
 	 * The root cgroup is non-freezable, so we can skip the
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 2594e1c..03dd1fa 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3801,8 +3801,6 @@ void lockdep_rcu_dereference(const char *file, const int line)
 {
 	struct task_struct *curr = current;
 
-	if (!debug_locks_off())
-		return;
 	printk("\n===================================================\n");
 	printk(  "[ INFO: suspicious rcu_dereference_check() usage. ]\n");
 	printk(  "---------------------------------------------------\n");
diff --git a/kernel/sched.c b/kernel/sched.c
index 6af210a..14c44ec 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -323,6 +323,15 @@ static inline struct task_group *task_group(struct task_struct *p)
 /* Change a task's cfs_rq and parent entity if it moves across CPUs/groups */
 static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
 {
+	/*
+	 * Strictly speaking this rcu_read_lock() is not needed since the
+	 * task_group is tied to the cgroup, which in turn can never go away
+	 * as long as there are tasks attached to it.
+	 *
+	 * However since task_group() uses task_subsys_state() which is an
+	 * rcu_dereference() user, this quiets CONFIG_PROVE_RCU.
+	 */
+	rcu_read_lock();
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	p->se.cfs_rq = task_group(p)->cfs_rq[cpu];
 	p->se.parent = task_group(p)->se[cpu];
@@ -332,6 +341,7 @@ static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
 	p->rt.rt_rq  = task_group(p)->rt_rq[cpu];
 	p->rt.parent = task_group(p)->rt_se[cpu];
 #endif
+	rcu_read_unlock();
 }
 
 #else
