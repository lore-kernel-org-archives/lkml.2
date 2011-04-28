Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902Ab1D1Jip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 05:38:45 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:53586 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754397Ab1D1Jin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 05:38:43 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/6yM5iStX6TG0rLGESkLxWHxP3DpqXGBVgh7h/3K
	jQud/ijYqEtocl
Subject: Re: query: [PATCH 2/2] cgroup: Remove call to synchronize_rcu in
 cgroup_attach_task
From: Mike Galbraith <efault@gmx.de>
To: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Colin Cross <ccross@android.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1303136494.7542.20.camel@marge.simson.net>
References: <1302170153.12304.31.camel@marge.simson.net>
	 <4DA50430.8020701@cn.fujitsu.com>
	 <1302664313.7407.29.camel@marge.simson.net>
	 <BANLkTikqvP90Etu=L24DPWbckrawM-6n=Q@mail.gmail.com>
	 <1303136494.7542.20.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Apr 2011 11:38:36 +0200
Message-ID: <1303983516.7460.5.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-18 at 16:21 +0200, Mike Galbraith wrote: 
> On Wed, 2011-04-13 at 15:16 +0200, Paul Menage wrote:
> 
> > Also, I'd be concerned that subsystems might get confused by the fact
> > that a new group called 'foo' could be created before the old 'foo'
> > has been cleaned up?
> 
> Decided to try beating on that without my hack.  Seems these patches...
>      patches/cgroup-Set-CGRP_RELEASABLE-when-adding-to-a-group
>      patches/cgroup-Remove-call-to-synchronize_rcu-in-cgroup_attach_task
> ...either introduced a bug, or made an existing one easier to hit.  With
> only those two applied, and several tasks doing - create, attach,
> detach, fork off a rmdir - all for the same cgroup, box griped.
> 
> With my hack on top, I'd either see rcu workers explode, or list
> corruption in cgroup_attach_task(), depending on phase-of-moon.
> 
> (hohum, maybe it'll turn out to be a defenseless _baby_ dragon..)

The explosions are because the logic to snag rmdir() should anyone grab
a reference will let us zip right through and free a cgroup while
there's a destruction in flight.  Adding a cgrp->count check before
trying to cgroup_clear_css_refs() prevents the explosions, but that
leaves RCU grace periods still embedded in userspace.

So...

I bent up put_css_set() a bit to try to destroy synchronously on final
put if possible, so rmdir() will only be snagged if that fails.  The
thing seems to be working, so I'll show it.  Readers (beware) may notice
some gratuitous looking chicken scratches.  Just ignore those, and move
along smartly to the suggesting a much better way part, for surely one
must exist. 

marge:~ # time sh -c "mkdir /cgroups/foo;echo $$ > /cgroups/foo/tasks;echo $$ > /cgroups/tasks;rmdir /cgroups/foo"

virgin tip

real    0m0.086s
user    0m0.004s
sys     0m0.000s

tip + rocks 'n sticks

real    0m0.006s
user    0m0.000s
sys     0m0.004s

(on top of Android patches)

---
 include/linux/cgroup.h |    1 
 kernel/cgroup.c        |  206 ++++++++++++++++++++++++++++++++++---------------
 2 files changed, 146 insertions(+), 61 deletions(-)

Index: linux-2.6/kernel/cgroup.c
===================================================================
--- linux-2.6.orig/kernel/cgroup.c
+++ linux-2.6/kernel/cgroup.c
@@ -134,7 +134,7 @@ struct css_id {
 	 * The css to which this ID points. This pointer is set to valid value
 	 * after cgroup is populated. If cgroup is removed, this will be NULL.
 	 * This pointer is expected to be RCU-safe because destroy()
-	 * is called after synchronize_rcu(). But for safe use, css_is_removed()
+	 * is called after an RCU grace period. But for safe use, css_is_removed()
 	 * css_tryget() should be used for avoiding race.
 	 */
 	struct cgroup_subsys_state __rcu *css;
@@ -353,7 +353,14 @@ static struct hlist_head *css_set_hash(s
 	return &css_set_table[index];
 }
 
-static void free_css_set_work(struct work_struct *work)
+static void free_css_set_rcu(struct rcu_head *obj)
+{
+	struct css_set *cg = container_of(obj, struct css_set, rcu_head);
+
+	kfree(cg);
+}
+
+static void destroy_css_set_work(struct work_struct *work)
 {
 	struct css_set *cg = container_of(work, struct css_set, work);
 	struct cg_cgroup_link *link;
@@ -373,14 +380,14 @@ static void free_css_set_work(struct wor
 	}
 	write_unlock(&css_set_lock);
 
-	kfree(cg);
+	call_rcu(&cg->rcu_head, free_css_set_rcu);
 }
 
-static void free_css_set_rcu(struct rcu_head *obj)
+static void destroy_css_set_rcu(struct rcu_head *obj)
 {
 	struct css_set *cg = container_of(obj, struct css_set, rcu_head);
 
-	INIT_WORK(&cg->work, free_css_set_work);
+	INIT_WORK(&cg->work, destroy_css_set_work);
 	schedule_work(&cg->work);
 }
 
@@ -398,8 +405,13 @@ static inline void get_css_set(struct cs
 	atomic_inc(&cg->refcount);
 }
 
-static void put_css_set(struct css_set *cg)
+static int cgroup_clear_css_refs(struct cgroup *cgrp);
+
+static void put_css_set(struct css_set *cg, int locked)
 {
+	struct cg_cgroup_link *link, *tmp;
+	int sync = locked, owner = 0;
+
 	/*
 	 * Ensure that the refcount doesn't hit zero while any readers
 	 * can see it. Similar to atomic_dec_and_lock(), but for an
@@ -407,17 +419,53 @@ static void put_css_set(struct css_set *
 	 */
 	if (atomic_add_unless(&cg->refcount, -1, 1))
 		return;
+	if (!locked)
+		sync = owner = mutex_trylock(&cgroup_mutex);
 	write_lock(&css_set_lock);
 	if (!atomic_dec_and_test(&cg->refcount)) {
 		write_unlock(&css_set_lock);
+		if (owner)
+			mutex_unlock(&cgroup_mutex);
 		return;
 	}
 
 	hlist_del(&cg->hlist);
 	css_set_count--;
 
+	/* synchronous destruction requires cgroup mutex. */
+	if (!sync)
+		goto out;
+
+	list_for_each_entry_safe(link, tmp, &cg->cg_links, cg_link_list) {
+		struct cgroup *cgrp = link->cgrp;
+
+		if (!cgroup_clear_css_refs(cgrp)) {
+			sync = 0;
+			goto out;
+		}
+	}
+
+	list_for_each_entry_safe(link, tmp, &cg->cg_links, cg_link_list) {
+		struct cgroup *cgrp = link->cgrp;
+
+		list_del(&link->cg_link_list);
+		list_del(&link->cgrp_link_list);
+		if (atomic_dec_and_test(&cgrp->count)) {
+			check_for_release(cgrp);
+			cgroup_wakeup_rmdir_waiter(cgrp);
+		}
+		kfree(link);
+	}
+
+out:
 	write_unlock(&css_set_lock);
-	call_rcu(&cg->rcu_head, free_css_set_rcu);
+	if (owner)
+		mutex_unlock(&cgroup_mutex);
+
+	if (sync)
+		call_rcu(&cg->rcu_head, free_css_set_rcu);
+	else
+		call_rcu(&cg->rcu_head, destroy_css_set_rcu);
 }
 
 /*
@@ -620,7 +668,7 @@ static struct css_set *find_css_set(
 	struct list_head tmp_cg_links;
 
 	struct hlist_head *hhead;
-	struct cg_cgroup_link *link;
+	struct cg_cgroup_link *link, *tmp;
 
 	/* First see if we already have a cgroup group that matches
 	 * the desired set */
@@ -654,7 +702,7 @@ static struct css_set *find_css_set(
 
 	write_lock(&css_set_lock);
 	/* Add reference counts and links from the new css_set. */
-	list_for_each_entry(link, &oldcg->cg_links, cg_link_list) {
+	list_for_each_entry_safe(link, tmp, &oldcg->cg_links, cg_link_list) {
 		struct cgroup *c = link->cgrp;
 		if (c->root == cgrp->root)
 			c = cgrp;
@@ -695,8 +743,8 @@ static struct cgroup *task_cgroup_from_r
 	if (css == &init_css_set) {
 		res = &root->top_cgroup;
 	} else {
-		struct cg_cgroup_link *link;
-		list_for_each_entry(link, &css->cg_links, cg_link_list) {
+		struct cg_cgroup_link *link, *tmp;
+		list_for_each_entry_safe(link, tmp, &css->cg_links, cg_link_list) {
 			struct cgroup *c = link->cgrp;
 			if (c->root == root) {
 				res = c;
@@ -843,12 +891,50 @@ static void free_cgroup_rcu(struct rcu_h
 	kfree(cgrp);
 }
 
+static void destroy_cgroup_work(struct work_struct *work)
+{
+	struct cgroup *cgrp = container_of(work, struct cgroup, work);
+	struct cgroup_subsys *ss;
+
+	mutex_lock(&cgroup_mutex);
+	/*
+	 * Release the subsystem state objects.
+	 */
+	for_each_subsys(cgrp->root, ss)
+		ss->destroy(ss, cgrp);
+
+	cgrp->root->number_of_cgroups--;
+	mutex_unlock(&cgroup_mutex);
+
+	/*
+	 * Drop the active superblock reference that we took when we
+	 * created the cgroup
+	 */
+	deactivate_super(cgrp->root->sb);
+
+	/*
+	 * if we're getting rid of the cgroup, refcount should ensure
+	 * that there are no pidlists left.
+	 */
+	BUG_ON(!list_empty(&cgrp->pidlists));
+
+	call_rcu(&cgrp->rcu_head, free_cgroup_rcu);
+}
+
+static void destroy_cgroup_rcu(struct rcu_head *obj)
+{
+	struct cgroup *cgrp = container_of(obj, struct cgroup, rcu_head);
+
+	INIT_WORK(&cgrp->work, destroy_cgroup_work);
+	schedule_work(&cgrp->work);
+}
+
 static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 {
+	struct cgroup *cgrp = dentry->d_fsdata;
+
 	/* is dentry a directory ? if so, kfree() associated cgroup */
 	if (S_ISDIR(inode->i_mode)) {
-		struct cgroup *cgrp = dentry->d_fsdata;
-		struct cgroup_subsys *ss;
 		BUG_ON(!(cgroup_is_removed(cgrp)));
 		/* It's possible for external users to be holding css
 		 * reference counts on a cgroup; css_put() needs to
@@ -856,31 +942,7 @@ static void cgroup_diput(struct dentry *
 		 * the reference count in order to know if it needs to
 		 * queue the cgroup to be handled by the release
 		 * agent */
-		synchronize_rcu();
-
-		mutex_lock(&cgroup_mutex);
-		/*
-		 * Release the subsystem state objects.
-		 */
-		for_each_subsys(cgrp->root, ss)
-			ss->destroy(ss, cgrp);
-
-		cgrp->root->number_of_cgroups--;
-		mutex_unlock(&cgroup_mutex);
-
-		/*
-		 * Drop the active superblock reference that we took when we
-		 * created the cgroup
-		 */
-		deactivate_super(cgrp->root->sb);
-
-		/*
-		 * if we're getting rid of the cgroup, refcount should ensure
-		 * that there are no pidlists left.
-		 */
-		BUG_ON(!list_empty(&cgrp->pidlists));
-
-		call_rcu(&cgrp->rcu_head, free_cgroup_rcu);
+		call_rcu(&cgrp->rcu_head, destroy_cgroup_rcu);
 	}
 	iput(inode);
 }
@@ -1792,7 +1854,7 @@ int cgroup_attach_task(struct cgroup *cg
 	 * based on its final set of cgroups
 	 */
 	newcg = find_css_set(cg, cgrp);
-	put_css_set(cg);
+	put_css_set(cg, 1);
 	if (!newcg) {
 		retval = -ENOMEM;
 		goto out;
@@ -1801,7 +1863,7 @@ int cgroup_attach_task(struct cgroup *cg
 	task_lock(tsk);
 	if (tsk->flags & PF_EXITING) {
 		task_unlock(tsk);
-		put_css_set(newcg);
+		put_css_set(newcg, 1);
 		retval = -ESRCH;
 		goto out;
 	}
@@ -1820,7 +1882,7 @@ int cgroup_attach_task(struct cgroup *cg
 	}
 	set_bit(CGRP_RELEASABLE, &cgrp->flags);
 	/* put_css_set will not destroy cg until after an RCU grace period */
-	put_css_set(cg);
+	put_css_set(cg, 1);
 
 	/*
 	 * wake up rmdir() waiter. the rmdir should fail since the cgroup
@@ -2361,12 +2423,14 @@ EXPORT_SYMBOL_GPL(cgroup_add_files);
 int cgroup_task_count(const struct cgroup *cgrp)
 {
 	int count = 0;
-	struct cg_cgroup_link *link;
+	struct cg_cgroup_link *link, *tmp;
 
 	read_lock(&css_set_lock);
-	list_for_each_entry(link, &cgrp->css_sets, cgrp_link_list) {
+	rcu_read_lock();
+	list_for_each_entry_safe(link, tmp, &cgrp->css_sets, cgrp_link_list) {
 		count += atomic_read(&link->cg->refcount);
 	}
+	rcu_read_unlock();
 	read_unlock(&css_set_lock);
 	return count;
 }
@@ -3538,10 +3602,16 @@ static int cgroup_clear_css_refs(struct
 	struct cgroup_subsys *ss;
 	unsigned long flags;
 	bool failed = false;
+
 	local_irq_save(flags);
 	for_each_subsys(cgrp->root, ss) {
 		struct cgroup_subsys_state *css = cgrp->subsys[ss->subsys_id];
 		int refcnt;
+
+		/* Someone beat us to it. */
+		if (test_bit(CSS_REMOVED, &css->flags))
+			continue;
+
 		while (1) {
 			/* We can only remove a CSS with a refcnt==1 */
 			refcnt = atomic_read(&css->refcnt);
@@ -3580,17 +3650,20 @@ static int cgroup_clear_css_refs(struct
 	return !failed;
 }
 
-/* checks if all of the css_sets attached to a cgroup have a refcount of 0.
- * Must be called with css_set_lock held */
+/* checks if all of the css_sets attached to a cgroup have a refcount of 0. */
 static int cgroup_css_sets_empty(struct cgroup *cgrp)
 {
-	struct cg_cgroup_link *link;
+	struct cg_cgroup_link *link, *tmp;
 
-	list_for_each_entry(link, &cgrp->css_sets, cgrp_link_list) {
+	read_lock(&css_set_lock);
+	list_for_each_entry_safe(link, tmp, &cgrp->css_sets, cgrp_link_list) {
 		struct css_set *cg = link->cg;
-		if (atomic_read(&cg->refcount) > 0)
+		if (atomic_read(&cg->refcount) > 0) {
+			read_unlock(&css_set_lock);
 			return 0;
+		}
 	}
+	read_unlock(&css_set_lock);
 
 	return 1;
 }
@@ -3606,7 +3679,8 @@ static int cgroup_rmdir(struct inode *un
 
 	/* the vfs holds both inode->i_mutex already */
 again:
-	mutex_lock(&cgroup_mutex);
+	if (!cgroup_lock_live_group(cgrp))
+		return -ENODEV;
 	if (!cgroup_css_sets_empty(cgrp)) {
 		mutex_unlock(&cgroup_mutex);
 		return -EBUSY;
@@ -3638,15 +3712,22 @@ again:
 		return ret;
 	}
 
-	mutex_lock(&cgroup_mutex);
-	parent = cgrp->parent;
+	if (!cgroup_lock_live_group(cgrp))
+		return -ENODEV;
 	if (!cgroup_css_sets_empty(cgrp) || !list_empty(&cgrp->children)) {
 		clear_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
 		mutex_unlock(&cgroup_mutex);
 		return -EBUSY;
 	}
+
 	prepare_to_wait(&cgroup_rmdir_waitq, &wait, TASK_INTERRUPTIBLE);
-	if (!cgroup_clear_css_refs(cgrp)) {
+	parent = cgrp->parent;
+
+	/*
+	 * Oops, someone grabbed a reference, or there is an asynchronous
+	 * final put_css_set() in flight, so we have to wait.
+	 */
+	if (atomic_read(&cgrp->count) || !cgroup_clear_css_refs(cgrp)) {
 		mutex_unlock(&cgroup_mutex);
 		/*
 		 * Because someone may call cgroup_wakeup_rmdir_waiter() before
@@ -3660,12 +3741,13 @@ again:
 			return -EINTR;
 		goto again;
 	}
-	/* NO css_tryget() can success after here. */
 	finish_wait(&cgroup_rmdir_waitq, &wait);
 	clear_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
 
-	spin_lock(&release_list_lock);
+	/* NO css_tryget() can success after here. */
 	set_bit(CGRP_REMOVED, &cgrp->flags);
+
+	spin_lock(&release_list_lock);
 	if (!list_empty(&cgrp->release_list))
 		list_del_init(&cgrp->release_list);
 	spin_unlock(&release_list_lock);
@@ -4279,7 +4361,7 @@ void cgroup_exit(struct task_struct *tsk
 	task_unlock(tsk);
 
 	if (cg)
-		put_css_set(cg);
+		put_css_set(cg, 0);
 }
 
 /**
@@ -4366,7 +4448,7 @@ int cgroup_clone(struct task_struct *tsk
 	    (parent != task_cgroup(tsk, subsys->subsys_id))) {
 		/* Aargh, we raced ... */
 		mutex_unlock(&inode->i_mutex);
-		put_css_set(cg);
+		put_css_set(cg, 1);
 
 		deactivate_super(root->sb);
 		/* The cgroup is still accessible in the VFS, but
@@ -4392,7 +4474,7 @@ int cgroup_clone(struct task_struct *tsk
 	mutex_unlock(&inode->i_mutex);
 
 	mutex_lock(&cgroup_mutex);
-	put_css_set(cg);
+	put_css_set(cg, 1);
 	mutex_unlock(&cgroup_mutex);
 	deactivate_super(root->sb);
 	return ret;
@@ -4904,13 +4986,13 @@ static int current_css_set_cg_links_read
 					 struct cftype *cft,
 					 struct seq_file *seq)
 {
-	struct cg_cgroup_link *link;
+	struct cg_cgroup_link *link, *tmp;
 	struct css_set *cg;
 
 	read_lock(&css_set_lock);
 	rcu_read_lock();
 	cg = rcu_dereference(current->cgroups);
-	list_for_each_entry(link, &cg->cg_links, cg_link_list) {
+	list_for_each_entry_safe(link, tmp, &cg->cg_links, cg_link_list) {
 		struct cgroup *c = link->cgrp;
 		const char *name;
 
@@ -4931,10 +5013,11 @@ static int cgroup_css_links_read(struct
 				 struct cftype *cft,
 				 struct seq_file *seq)
 {
-	struct cg_cgroup_link *link;
+	struct cg_cgroup_link *link, *tmp;
 
 	read_lock(&css_set_lock);
-	list_for_each_entry(link, &cont->css_sets, cgrp_link_list) {
+	rcu_read_lock();
+	list_for_each_entry_safe(link, tmp, &cont->css_sets, cgrp_link_list) {
 		struct css_set *cg = link->cg;
 		struct task_struct *task;
 		int count = 0;
@@ -4949,6 +5032,7 @@ static int cgroup_css_links_read(struct
 			}
 		}
 	}
+	rcu_read_unlock();
 	read_unlock(&css_set_lock);
 	return 0;
 }
Index: linux-2.6/include/linux/cgroup.h
===================================================================
--- linux-2.6.orig/include/linux/cgroup.h
+++ linux-2.6/include/linux/cgroup.h
@@ -231,6 +231,7 @@ struct cgroup {
 
 	/* For RCU-protected deletion */
 	struct rcu_head rcu_head;
+	struct work_struct work;
 
 	/* List of events which userspace want to receive */
 	struct list_head event_list;




