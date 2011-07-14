Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab1GNBKJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 21:10:09 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54461 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab1GNBKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 21:10:07 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 14 Jul 2011 10:02:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] memcg: make oom_lock 0 and 1 based rather than
 coutner
Message-Id: <20110714100259.cedbf6af.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <50d526ee242916bbfb44b9df4474df728c4892c6.1310561078.git.mhocko@suse.cz>
References: <cover.1310561078.git.mhocko@suse.cz>
	<50d526ee242916bbfb44b9df4474df728c4892c6.1310561078.git.mhocko@suse.cz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jul 2011 13:05:49 +0200
Michal Hocko <mhocko@suse.cz> wrote:

> 867578cb "memcg: fix oom kill behavior" introduced oom_lock counter
> which is incremented by mem_cgroup_oom_lock when we are about to handle
> memcg OOM situation. mem_cgroup_handle_oom falls back to a sleep if
> oom_lock > 1 to prevent from multiple oom kills at the same time.
> The counter is then decremented by mem_cgroup_oom_unlock called from the
> same function.
> 
> This works correctly but it can lead to serious starvations when we
> have many processes triggering OOM.
> 
> Consider a process (call it A) which gets the oom_lock (the first one
> that got to mem_cgroup_handle_oom and grabbed memcg_oom_mutex). All
> other processes are blocked on the mutex.
> While A releases the mutex and calls mem_cgroup_out_of_memory others
> will wake up (one after another) and increase the counter and fall into
> sleep (memcg_oom_waitq). Once A finishes mem_cgroup_out_of_memory it
> takes the mutex again and decreases oom_lock and wakes other tasks (if
> releasing memory of the killed task hasn't done it yet).
> The main problem here is that everybody still race for the mutex and
> there is no guarantee that we will get counter back to 0 for those
> that got back to mem_cgroup_handle_oom. In the end the whole convoy
> in/decreases the counter but we do not get to 1 that would enable
> killing so nothing useful is going on.
> The time is basically unbounded because it highly depends on scheduling
> and ordering on mutex.
> 

Hmm, ok, I see the problem.


> This patch replaces the counter by a simple {un}lock semantic. We are
> using only 0 and 1 to distinguish those two states.
> As mem_cgroup_oom_{un}lock works on the hierarchy we have to make sure
> that we cannot race with somebody else which is already guaranteed
> because we call both functions with the mutex held. All other consumers
> just read the value atomically for a single group which is sufficient
> because we set the value atomically.
> The other thing is that only that process which locked the oom will
> unlock it once the OOM is handled.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> ---
>  mm/memcontrol.c |   24 +++++++++++++++++-------
>  1 files changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e013b8e..f6c9ead 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1803,22 +1803,31 @@ static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
>  /*
>   * Check OOM-Killer is already running under our hierarchy.
>   * If someone is running, return false.
> + * Has to be called with memcg_oom_mutex
>   */
>  static bool mem_cgroup_oom_lock(struct mem_cgroup *mem)
>  {
> -	int x, lock_count = 0;
> +	int x, lock_count = -1;
>  	struct mem_cgroup *iter;
>  
>  	for_each_mem_cgroup_tree(iter, mem) {
> -		x = atomic_inc_return(&iter->oom_lock);
> -		lock_count = max(x, lock_count);
> +		x = !!atomic_add_unless(&iter->oom_lock, 1, 1);
> +		if (lock_count == -1)
> +			lock_count = x;
> +


Hmm...Assume following hierarchy.

	  A
       B     C
      D E 

The orignal code hanldes the situation

 1. B-D-E is under OOM
 2. A enters OOM after 1.

In original code, A will not invoke OOM (because B-D-E oom will kill a process.)
The new code invokes A will invoke new OOM....right ?

I wonder this kind of code
==
	bool success = true;
	...
	for_each_mem_cgroup_tree(iter, mem) {
		success &= !!atomic_add_unless(&iter->oom_lock, 1, 1);
		/* "break" loop is not allowed because of css refcount....*/
	}
	return success.
==
Then, one hierarchy can invoke one OOM kill within it.
But this will not work because we can't do proper unlock.


Hm. how about this ? This has only one lock point and we'll not see the BUG.
Not tested yet..


---
 mm/memcontrol.c |   77 +++++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 53 insertions(+), 24 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e013b8e..c36bd05 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -246,7 +246,8 @@ struct mem_cgroup {
 	 * Should the accounting and control be hierarchical, per subtree?
 	 */
 	bool use_hierarchy;
-	atomic_t	oom_lock;
+	int		oom_lock;
+	atomic_t	under_oom;
 	atomic_t	refcnt;
 
 	unsigned int	swappiness;
@@ -1801,36 +1802,63 @@ static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
 }
 
 /*
- * Check OOM-Killer is already running under our hierarchy.
+ * Check whether OOM-Killer is already running under our hierarchy.
  * If someone is running, return false.
  */
-static bool mem_cgroup_oom_lock(struct mem_cgroup *mem)
+static bool mem_cgroup_oom_lock(struct mem_cgroup *memcg)
 {
-	int x, lock_count = 0;
 	struct mem_cgroup *iter;
+	bool ret;
 
-	for_each_mem_cgroup_tree(iter, mem) {
-		x = atomic_inc_return(&iter->oom_lock);
-		lock_count = max(x, lock_count);
+	/*
+	 * If an ancestor (including this memcg) is the owner of OOM Lock.
+	 * return false;
+	 */
+	for (iter = memcg; iter != NULL; iter = parent_mem_cgroup(iter)) {
+		if (iter->oom_lock)
+			break;
+		if (!iter->use_hierarchy) {
+			iter = NULL;
+			break;
+		}
 	}
 
-	if (lock_count == 1)
-		return true;
-	return false;
+	if (iter)
+		return false;
+	/*
+	 * Make the owner of OOM lock to be the highest ancestor of hierarchy
+	 * under OOM. IOW, move children's OOM owner information to this memcg
+	 * if a child is owner. In this case, an OOM killer is running and
+	 * we return false. But make this memcg as owner of oom-lock.
+	 */
+	ret = true;
+	for_each_mem_cgroup_tree(iter, memcg) {
+		if (iter->oom_lock) {
+			iter->oom_lock = 0;
+			ret = false;
+		}
+		atomic_set(&iter->under_oom, 1);
+	}
+	/* Make this memcg as the owner of OOM lock. */
+	memcg->oom_lock = 1;
+	return ret;
 }
 
-static int mem_cgroup_oom_unlock(struct mem_cgroup *mem)
+static void mem_cgroup_oom_unlock(struct mem_cgroup *memcg)
 {
-	struct mem_cgroup *iter;
+	struct mem_cgroup *iter, *iter2;
 
-	/*
-	 * When a new child is created while the hierarchy is under oom,
-	 * mem_cgroup_oom_lock() may not be called. We have to use
-	 * atomic_add_unless() here.
-	 */
-	for_each_mem_cgroup_tree(iter, mem)
-		atomic_add_unless(&iter->oom_lock, -1, 0);
-	return 0;
+	for (iter = memcg; iter != NULL; iter = parent_mem_cgroup(iter)) {
+		if (iter->oom_lock) {
+			iter->oom_lock = 0;
+			break;
+		}
+	}
+	BUG_ON(!iter);
+
+	for_each_mem_cgroup_tree(iter2, iter)
+		atomic_set(&iter->under_oom, 0);
+	return;
 }
 
 
@@ -1875,7 +1903,7 @@ static void memcg_wakeup_oom(struct mem_cgroup *mem)
 
 static void memcg_oom_recover(struct mem_cgroup *mem)
 {
-	if (mem && atomic_read(&mem->oom_lock))
+	if (mem && atomic_read(&mem->under_oom))
 		memcg_wakeup_oom(mem);
 }
 
@@ -1916,7 +1944,8 @@ bool mem_cgroup_handle_oom(struct mem_cgroup *mem, gfp_t mask)
 		finish_wait(&memcg_oom_waitq, &owait.wait);
 	}
 	mutex_lock(&memcg_oom_mutex);
-	mem_cgroup_oom_unlock(mem);
+	if (locked)
+		mem_cgroup_oom_unlock(mem);
 	memcg_wakeup_oom(mem);
 	mutex_unlock(&memcg_oom_mutex);
 
@@ -4584,7 +4613,7 @@ static int mem_cgroup_oom_register_event(struct cgroup *cgrp,
 	list_add(&event->list, &memcg->oom_notify);
 
 	/* already in OOM ? */
-	if (atomic_read(&memcg->oom_lock))
+	if (atomic_read(&memcg->under_oom))
 		eventfd_signal(eventfd, 1);
 	mutex_unlock(&memcg_oom_mutex);
 
@@ -4619,7 +4648,7 @@ static int mem_cgroup_oom_control_read(struct cgroup *cgrp,
 
 	cb->fill(cb, "oom_kill_disable", mem->oom_kill_disable);
 
-	if (atomic_read(&mem->oom_lock))
+	if (atomic_read(&mem->under_oom))
 		cb->fill(cb, "under_oom", 1);
 	else
 		cb->fill(cb, "under_oom", 0);
-- 
1.7.4.1










