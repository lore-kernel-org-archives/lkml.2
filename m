Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab1GNM4E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 08:56:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50550 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754564Ab1GNM4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 08:56:01 -0400
Date: Thu, 14 Jul 2011 14:55:55 +0200
From: Michal Hocko <mhocko@suse.cz>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] memcg: make oom_lock 0 and 1 based rather than
 coutner
Message-ID: <20110714125555.GA27954@tiehlicka.suse.cz>
References: <50d526ee242916bbfb44b9df4474df728c4892c6.1310561078.git.mhocko@suse.cz>
 <20110714100259.cedbf6af.kamezawa.hiroyu@jp.fujitsu.com>
 <20110714115913.cf8d1b9d.kamezawa.hiroyu@jp.fujitsu.com>
 <20110714090017.GD19408@tiehlicka.suse.cz>
 <20110714183014.8b15e9b9.kamezawa.hiroyu@jp.fujitsu.com>
 <20110714095152.GG19408@tiehlicka.suse.cz>
 <20110714191728.058859cd.kamezawa.hiroyu@jp.fujitsu.com>
 <20110714110935.GK19408@tiehlicka.suse.cz>
 <20110714113009.GL19408@tiehlicka.suse.cz>
 <20110714205012.8b78691e.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110714205012.8b78691e.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 14-07-11 20:50:12, KAMEZAWA Hiroyuki wrote:
> On Thu, 14 Jul 2011 13:30:09 +0200
> Michal Hocko <mhocko@suse.cz> wrote:
[...]
> >  static bool mem_cgroup_oom_lock(struct mem_cgroup *mem)
> >  {
> > -	int x, lock_count = 0;
> > -	struct mem_cgroup *iter;
> > +	int x, lock_count = -1;
> > +	struct mem_cgroup *iter, *failed = NULL;
> > +	bool cond = true;
> >  
> > -	for_each_mem_cgroup_tree(iter, mem) {
> > -		x = atomic_inc_return(&iter->oom_lock);
> > -		lock_count = max(x, lock_count);
> > +	for_each_mem_cgroup_tree_cond(iter, mem, cond) {
> > +		x = !!atomic_add_unless(&iter->oom_lock, 1, 1);
> > +		if (lock_count == -1)
> > +			lock_count = x;
> > +		else if (lock_count != x) {
> > +			/*
> > +			 * this subtree of our hierarchy is already locked
> > +			 * so we cannot give a lock.
> > +			 */
> > +			lock_count = 0;
> > +			failed = iter;
> > +			cond = false;
> > +		}
> >  	}
> 
> Hm ? assuming B-C-D is locked and a new thread tries a lock on A-B-C-D-E.
> And for_each_mem_cgroup_tree will find groups in order of A->B->C->D->E.
> Before lock
>   A  0
>   B  1
>   C  1
>   D  1
>   E  0
> 
> After lock
>   A  1
>   B  1
>   C  1
>   D  1
>   E  0
> 
> here, failed = B, cond = false. Undo routine will unlock A.
> Hmm, seems to work in this case.
> 
> But....A's oom_lock==0 and memcg_oom_wakeup() at el will not able to
> know "A" is in OOM. wakeup processes in A which is waiting for oom recover..

Hohm, we need to have 2 different states. lock and mark_oom.
oom_recovert would check only the under_oom.

> 
> Will this work ?

No it won't because the rest of the world has no idea that A is
under_oom as well.

> ==
>  # cgcreate -g memory:A
>  # cgset -r memory.use_hierarchy=1 A
>  # cgset -r memory.oom_control=1   A
>  # cgset -r memory.limit_in_bytes= 100M
>  # cgset -r memory.memsw.limit_in_bytes= 100M
>  # cgcreate -g memory:A/B
>  # cgset -r memory.oom_control=1 A/B
>  # cgset -r memory.limit_in_bytes=20M
>  # cgset -r memory.memsw.limit_in_bytes=20M
> 
>  Assume malloc XXX is a program allocating XXX Megabytes of memory.
> 
>  # cgexec -g memory:A/B malloc 30  &    #->this will be blocked by OOM of group B
>  # cgexec -g memory:A   malloc 80  &    #->this will be blocked by OOM of group A
> 
> 
> Here, 2 procs are blocked by OOM. Here, relax A's limitation and clear OOM.
> 
>  # cgset -r memory.memsw.limit_in_bytes=300M A
>  # cgset -r memory.limit_in_bytes=300M A
> 
>  malloc 80 will end.

What about yet another approach? Very similar what you proposed, I
guess. Again not tested and needs some cleanup just to illustrate.
What do you think?
--- 
>From 964158e226555a7a6a4d946062461d2b97c1c539 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Wed, 13 Jul 2011 13:05:49 +0200
Subject: [PATCH] memcg: make oom_lock 0 and 1 based rather than coutner

867578cb "memcg: fix oom kill behavior" introduced oom_lock counter
which is incremented by mem_cgroup_oom_lock when we are about to handle
memcg OOM situation. mem_cgroup_handle_oom falls back to a sleep if
oom_lock > 1 to prevent from multiple oom kills at the same time.
The counter is then decremented by mem_cgroup_oom_unlock called from the
same function.

This works correctly but it can lead to serious starvations when we
have many processes triggering OOM.

Consider a process (call it A) which gets the oom_lock (the first one
that got to mem_cgroup_handle_oom and grabbed memcg_oom_mutex). All
other processes are blocked on the mutex.
While A releases the mutex and calls mem_cgroup_out_of_memory others
will wake up (one after another) and increase the counter and fall into
sleep (memcg_oom_waitq). Once A finishes mem_cgroup_out_of_memory it
takes the mutex again and decreases oom_lock and wakes other tasks (if
releasing memory of the killed task hasn't done it yet).
The main problem here is that everybody still race for the mutex and
there is no guarantee that we will get counter back to 0 for those
that got back to mem_cgroup_handle_oom. In the end the whole convoy
in/decreases the counter but we do not get to 1 that would enable
killing so nothing useful is going on.
The time is basically unbounded because it highly depends on scheduling
and ordering on mutex.

This patch replaces the counter by a simple {un}lock semantic. We are
using only 0 and 1 to distinguish those two states.
As mem_cgroup_oom_{un}lock works on the a subtree of a hierarchy we have
to make sure that nobody else races with us which is guaranteed by the
memcg_oom_mutex. All other consumers just read the value atomically for
a single group which is sufficient because we set the value atomically.
mem_cgroup_oom_lock has to be really careful because we might be in
higher in a hierarchy than already oom locked subtree of the same
hierarchy:
          A
        /   \
       B     \
      /\      \
     C  D     E

B - C - D tree might be already locked. While we want to enable locking E
subtree because OOM situations cannot influence each other we definitely
do not want to allow locking A.
Therefore we have to refuse lock if any subtree is already locked and
clear up the lock for all nodes that have been set up to the failure
point.
On the other hand we have to make sure the rest of the world will
recognize that the group is under OOM even though it doesn't have a
lock. Therefore we have to introduce under_oom variable which is
incremented and decremented for whole subtree when we enter resp. leave
mem_cgroup_handle_oom.

Unlock path is then very easy because we always unlock only that subtree
we have locked previously.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c |   81 ++++++++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 65 insertions(+), 16 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e013b8e..a278188 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -246,7 +246,8 @@ struct mem_cgroup {
 	 * Should the accounting and control be hierarchical, per subtree?
 	 */
 	bool use_hierarchy;
-	atomic_t	oom_lock;
+	bool		oom_lock;
+	atomic_t	under_oom;
 	atomic_t	refcnt;
 
 	unsigned int	swappiness;
@@ -1803,37 +1804,82 @@ static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
 /*
  * Check OOM-Killer is already running under our hierarchy.
  * If someone is running, return false.
+ * Has to be called with memcg_oom_mutex
  */
 static bool mem_cgroup_oom_lock(struct mem_cgroup *mem)
 {
-	int x, lock_count = 0;
-	struct mem_cgroup *iter;
+	int lock_count = -1;
+	struct mem_cgroup *iter, *failed = NULL;
+	bool cond = true;
 
-	for_each_mem_cgroup_tree(iter, mem) {
-		x = atomic_inc_return(&iter->oom_lock);
-		lock_count = max(x, lock_count);
+	for_each_mem_cgroup_tree_cond(iter, mem, cond) {
+		bool locked = iter->oom_lock;
+		iter->oom_lock = true;
+		if (lock_count == -1)
+			lock_count = iter->oom_lock;
+		else if (lock_count != locked) {
+			/*
+			 * this subtree of our hierarchy is already locked
+			 * so we cannot give a lock.
+			 */
+			lock_count = 0;
+			failed = iter;
+			cond = false;
+		}
 	}
 
-	if (lock_count == 1)
-		return true;
-	return false;
+	if (!failed)
+		goto done;
+
+	/*
+	 * OK, we failed to lock the whole subtree so we have to clean up
+	 * what we set up to the failing subtree
+	 */
+	cond = true;
+	for_each_mem_cgroup_tree_cond(iter, mem, cond) {
+		if (iter == failed) {
+			cond = false;
+			continue;
+		}
+		iter->oom_lock = false;
+	}
+done:
+	return lock_count;
 }
 
+/*
+ * Has to be called with memcg_oom_mutex
+ */
 static int mem_cgroup_oom_unlock(struct mem_cgroup *mem)
 {
 	struct mem_cgroup *iter;
 
+	for_each_mem_cgroup_tree(iter, mem)
+		iter->oom_lock = false;
+	return 0;
+}
+
+static void mem_cgroup_mark_under_oom(struct mem_cgroup *mem)
+{
+	struct mem_cgroup *iter;
+
+	for_each_mem_cgroup_tree(iter, mem)
+		atomic_inc(&iter->under_oom);
+}
+
+static void mem_cgroup_unmark_under_oom(struct mem_cgroup *mem)
+{
+	struct mem_cgroup *iter;
+
 	/*
 	 * When a new child is created while the hierarchy is under oom,
 	 * mem_cgroup_oom_lock() may not be called. We have to use
 	 * atomic_add_unless() here.
 	 */
 	for_each_mem_cgroup_tree(iter, mem)
-		atomic_add_unless(&iter->oom_lock, -1, 0);
-	return 0;
+		atomic_add_unless(&iter->under_oom, -1, 0);
 }
 
-
 static DEFINE_MUTEX(memcg_oom_mutex);
 static DECLARE_WAIT_QUEUE_HEAD(memcg_oom_waitq);
 
@@ -1875,7 +1921,7 @@ static void memcg_wakeup_oom(struct mem_cgroup *mem)
 
 static void memcg_oom_recover(struct mem_cgroup *mem)
 {
-	if (mem && atomic_read(&mem->oom_lock))
+	if (mem && atomic_read(&mem->under_oom))
 		memcg_wakeup_oom(mem);
 }
 
@@ -1896,6 +1942,7 @@ bool mem_cgroup_handle_oom(struct mem_cgroup *mem, gfp_t mask)
 	/* At first, try to OOM lock hierarchy under mem.*/
 	mutex_lock(&memcg_oom_mutex);
 	locked = mem_cgroup_oom_lock(mem);
+	mem_cgroup_mark_under_oom(mem);
 	/*
 	 * Even if signal_pending(), we can't quit charge() loop without
 	 * accounting. So, UNINTERRUPTIBLE is appropriate. But SIGKILL
@@ -1916,7 +1963,9 @@ bool mem_cgroup_handle_oom(struct mem_cgroup *mem, gfp_t mask)
 		finish_wait(&memcg_oom_waitq, &owait.wait);
 	}
 	mutex_lock(&memcg_oom_mutex);
-	mem_cgroup_oom_unlock(mem);
+	if (locked)
+		mem_cgroup_oom_unlock(mem);
+	mem_cgroup_unmark_under_oom(mem);
 	memcg_wakeup_oom(mem);
 	mutex_unlock(&memcg_oom_mutex);
 
@@ -4584,7 +4633,7 @@ static int mem_cgroup_oom_register_event(struct cgroup *cgrp,
 	list_add(&event->list, &memcg->oom_notify);
 
 	/* already in OOM ? */
-	if (atomic_read(&memcg->oom_lock))
+	if (atomic_read(&memcg->under_oom))
 		eventfd_signal(eventfd, 1);
 	mutex_unlock(&memcg_oom_mutex);
 
@@ -4619,7 +4668,7 @@ static int mem_cgroup_oom_control_read(struct cgroup *cgrp,
 
 	cb->fill(cb, "oom_kill_disable", mem->oom_kill_disable);
 
-	if (atomic_read(&mem->oom_lock))
+	if (atomic_read(&mem->under_oom))
 		cb->fill(cb, "under_oom", 1);
 	else
 		cb->fill(cb, "under_oom", 0);
-- 
1.7.5.4


-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
