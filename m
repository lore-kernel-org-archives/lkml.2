Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab1GNLaO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 07:30:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45364 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503Ab1GNLaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 07:30:12 -0400
Date: Thu, 14 Jul 2011 13:30:09 +0200
From: Michal Hocko <mhocko@suse.cz>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] memcg: make oom_lock 0 and 1 based rather than
 coutner
Message-ID: <20110714113009.GL19408@tiehlicka.suse.cz>
References: <cover.1310561078.git.mhocko@suse.cz>
 <50d526ee242916bbfb44b9df4474df728c4892c6.1310561078.git.mhocko@suse.cz>
 <20110714100259.cedbf6af.kamezawa.hiroyu@jp.fujitsu.com>
 <20110714115913.cf8d1b9d.kamezawa.hiroyu@jp.fujitsu.com>
 <20110714090017.GD19408@tiehlicka.suse.cz>
 <20110714183014.8b15e9b9.kamezawa.hiroyu@jp.fujitsu.com>
 <20110714095152.GG19408@tiehlicka.suse.cz>
 <20110714191728.058859cd.kamezawa.hiroyu@jp.fujitsu.com>
 <20110714110935.GK19408@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110714110935.GK19408@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 14-07-11 13:09:35, Michal Hocko wrote:
> On Thu 14-07-11 19:17:28, KAMEZAWA Hiroyuki wrote:
> > On Thu, 14 Jul 2011 11:51:52 +0200
> > Michal Hocko <mhocko@suse.cz> wrote:
> > 
> > > On Thu 14-07-11 18:30:14, KAMEZAWA Hiroyuki wrote:
> > > > On Thu, 14 Jul 2011 11:00:17 +0200
> > > > Michal Hocko <mhocko@suse.cz> wrote:
> > > > 
> > > > > On Thu 14-07-11 11:59:13, KAMEZAWA Hiroyuki wrote:
> > > > > > On Thu, 14 Jul 2011 10:02:59 +0900
> > > > > > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> [...]
> > > > ==
> > > >  	for_each_mem_cgroup_tree(iter, mem) {
> > > > -		x = atomic_inc_return(&iter->oom_lock);
> > > > -		lock_count = max(x, lock_count);
> > > > +		x = !!atomic_add_unless(&iter->oom_lock, 1, 1);
> > > > +		if (lock_count == -1)
> > > > +			lock_count = x;
> > > > +
> > > > +		/* New child can be created but we shouldn't race with
> > > > +		 * somebody else trying to oom because we are under
> > > > +		 * memcg_oom_mutex
> > > > +		 */
> > > > +		BUG_ON(lock_count != x);
> > > >  	}
> > > > ==
> > > > 
> > > > When, B,D,E is under OOM,  
> > > > 
> > > >    A oom_lock = 0
> > > >    B oom_lock = 1
> > > >    C oom_lock = 0
> > > >    D oom_lock = 1
> > > >    E oom_lock = 1
> > > > 
> > > > Here, assume A enters OOM.
> > > > 
> > > >    A oom_lock = 1 -- (*)
> > > >    B oom_lock = 1
> > > >    C oom_lock = 1
> > > >    D oom_lock = 1
> > > >    E oom_lock = 1
> > > > 
> > > > because of (*), mem_cgroup_oom_lock() will return lock_count=1, true.
> > > > 
> > > > Then, a new oom-killer will another oom-kiiler running in B-D-E.
> > > 
> > > OK, does this mean that for_each_mem_cgroup_tree doesn't lock the whole
> > > hierarchy at once? 
> > 
> > yes. this for_each_mem_cgroup_tree() just locks a subtree.
> 
> OK, then I really misunderstood the macro and now I see your points.
> Thinking about it some more having a full hierarchy locked is not that
> good idea after all. We would block also parallel branches which will
> not bail out from OOM if we handle oom condition in another branch.
> 
> > 
> > > I have to confess that the behavior of mem_cgroup_start_loop is little
> > > bit obscure to me. The comment says it searches for the cgroup with the
> > > minimum ID - I assume this is the root of the hierarchy. Is this
> > > correct?
> > > 
> > 
> > No. Assume following sequence.
> > 
> >   1.  cgcreate -g memory:X  css_id=5 assigned.
> >   ........far later.....
> >   2.  cgcreate -g memory:A  css_id=30 assigned.
> >   3.  cgdelete -g memory:X  css_id=5 freed.
> >   4.  cgcreate -g memory:A/B
> >   5.  cgcreate -g memory:A/C
> >   6.  cgcreate -g memory:A/B/D
> >   7.  cgcreate -g memory:A/B/E
> > 
> > Then, css_id will be
> > ==
> >  A css_id=30
> >  B css_id=5  # reuse X's id.
> >  C css_id=31
> >  D css_id=32
> >  E css_id=33
> > ==
> > Then, the search under "B" will find B->D->E
> > 
> > The search under "A" will find B->A->C->D->E. 
> > 
> > > If yes then if we have oom in what-ever cgroup in the hierarchy then
> > > the above code should lock the whole hierarchy and the above never
> > > happens. Right?
> > 
> > Yes and no. old code allows following happens at the same time.
> > 
> >       A
> >     B   C
> >    D E   F
> >  
> >    B-D-E goes into OOM because of B's limit.
> >    C-F   goes into OOM because of C's limit
> > 
> > 
> > When you stop OOM under A because of B's limit, C can't invoke OOM.
> > 
> > After a little more consideration, my suggestion is,
> > 
> > === lock ===
> > 	bool success = true;
> > 	...
> > 	for_each_mem_cgroup_tree(iter, mem) {
> > 		success &= !!atomic_add_unless(&iter->oom_lock, 1, 1);
> > 		/* "break" loop is not allowed because of css refcount....*/
> > 	}
> > 	return success.
> > 
> > By this, when a sub-hierarchy is under OOM, don't invoke new OOM.
> 
> Hmm, I am afraid this will not work as well. The group tree traversing
> depends on the creation order so we might end up seeing locked subtree
> sooner than unlocked so we could grant the lock and see multiple OOMs.
> We have to guarantee that we do not grant the lock if we encounter
> already locked sub group (and then we have to clear oom_lock for all
> groups that we have already visited).
> 
> > === unlock ===
> > 	struct mem_cgroup *oom_root;
> > 
> > 	oom_root = memcg; 
> > 	do {
> > 		struct mem_cgroup *parent;
> > 
> > 		parent = mem_cgroup_parent(oom_root);
> > 		if (!parent || !parent->use_hierarchy)
> > 			break;
> > 
> > 		if (atomic_read(&parent->oom_lock))
> > 			break;
> > 	} while (1);
> > 
> > 	for_each_mem_cgroup_tree(iter, oom_root)
> > 		atomic_add_unless(&iter->oom_lock, -1, 0);
> > 
> > By this, at unlock, unlock oom-lock of a hierarchy which was under oom_lock
> > because of a sub-hierarchy was under OOM.
> 
> This would unlock also groups that might have a parallel oom lock.
> A - B - C - D oom (from B)
>   - E - F  oom (F)
> 
> unlock in what-ever branch will unlock also the parallel oom.
> I will think about something else and return to your first patch if I
> find it over complicated as well.

What about this? Just compile tested:
--- 
>From 90ab974eb69c61c2e3b94beabe9b6745fa319936 Mon Sep 17 00:00:00 2001
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
Unlock path is then very easy because we always unlock only that subtree
we have locked previously.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c |   48 +++++++++++++++++++++++++++++++++++++++---------
 1 files changed, 39 insertions(+), 9 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e013b8e..29f00d0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1803,22 +1803,51 @@ static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
 /*
  * Check OOM-Killer is already running under our hierarchy.
  * If someone is running, return false.
+ * Has to be called with memcg_oom_mutex
  */
 static bool mem_cgroup_oom_lock(struct mem_cgroup *mem)
 {
-	int x, lock_count = 0;
-	struct mem_cgroup *iter;
+	int x, lock_count = -1;
+	struct mem_cgroup *iter, *failed = NULL;
+	bool cond = true;
 
-	for_each_mem_cgroup_tree(iter, mem) {
-		x = atomic_inc_return(&iter->oom_lock);
-		lock_count = max(x, lock_count);
+	for_each_mem_cgroup_tree_cond(iter, mem, cond) {
+		x = !!atomic_add_unless(&iter->oom_lock, 1, 1);
+		if (lock_count == -1)
+			lock_count = x;
+		else if (lock_count != x) {
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
+		atomic_set(&iter->oom_lock, 0)
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
@@ -1916,7 +1945,8 @@ bool mem_cgroup_handle_oom(struct mem_cgroup *mem, gfp_t mask)
 		finish_wait(&memcg_oom_waitq, &owait.wait);
 	}
 	mutex_lock(&memcg_oom_mutex);
-	mem_cgroup_oom_unlock(mem);
+	if (locked)
+		mem_cgroup_oom_unlock(mem);
 	memcg_wakeup_oom(mem);
 	mutex_unlock(&memcg_oom_mutex);
 
-- 
1.7.5.4


-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
