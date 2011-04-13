Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904Ab1DMDMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 23:12:00 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:53099 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752181Ab1DMDL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 23:11:58 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/U55pa1vbUR2mdV2wuB8TPEYPt2eM8g6qXdk9m65
	GipOmc/ySXhehz
Subject: Re: query: [PATCH 2/2] cgroup: Remove call to synchronize_rcu in
 cgroup_attach_task
From: Mike Galbraith <efault@gmx.de>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Menage <menage@google.com>,
        Colin Cross <ccross@android.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4DA50430.8020701@cn.fujitsu.com>
References: <1302170153.12304.31.camel@marge.simson.net>
	 <4DA50430.8020701@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Apr 2011 05:11:53 +0200
Message-ID: <1302664313.7407.29.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-13 at 10:02 +0800, Li Zefan wrote:
> Mike Galbraith wrote:
> > Greetings,
> > 
> > Wrt these patches:
> > 
> > https://lkml.org/lkml/2010/11/24/14 [PATCH 1/2] cgroup: Set CGRP_RELEASABLE when adding to a cgroup
> > https://lkml.org/lkml/2010/11/24/15 [PATCH 2/2] cgroup: Remove call to synchronize_rcu in cgroup_attach_task
> > 
> > I received a query regarding 2/2 because a large database company is
> > apparently moving tasks between cgroups frequently enough that their
> > database initialization time dropped from ~11 hours to ~4 hours when
> > they applied this patch.
> > 
> > Curious why these got no traction.
> 
> I thought Paul was following the this. I'll spend some time on patch
> review.

Great!

Three orders of magnitude latency improvements are a terrible thing to
waste ;-)  I tried doing it a bit differently, but would have ended up
about the same due to the need for rmdir to succeed after the attach
(detach of last task) returns.

However...

If the user _does_ that rmdir(), it's more or less back to square one.
RCU grace periods should not impact userland, but if you try to do
create/attach/detach/destroy, you run into the same bottleneck, as does
any asynchronous GC, though that's not such a poke in the eye.  I tried
a straight forward move to schedule_work(), and it seems to work just
fine.  rmdir() no longer takes ~30ms on my box, but closer to 20us.

cgroups: Remove call to synchronize_rcu() in cgroup_diput()

Instead of synchronously waiting via synchronize_rcu(), then initiating cgroup
destruction, schedule asynchronous destruction via call_rcu()->schedule_work()
and move along smartly.

Some numbers:
    1000 x simple loop - create/attach self/detatch self/destroy, zero work.

    Virgin source
    real    1m39.713s   1.000000
    user    0m0.000s
    sys     0m0.076s

    + Android commits 60cdbd1f and 05946a1
    real    0m33.627s    .337237
    user    0m0.056s
    sys     0m0.000s

    + Android commits + below
    real    0m0.046s     .000461
    user    0m0.000s
    sys     0m0.044s

Not-signed-off-by: Mike Galbraith <efault@gmx.de>

---
 include/linux/cgroup.h |    1 
 kernel/cgroup.c        |   59 +++++++++++++++++++++++++++----------------------
 2 files changed, 34 insertions(+), 26 deletions(-)

Index: linux-2.6.39.git/include/linux/cgroup.h
===================================================================
--- linux-2.6.39.git.orig/include/linux/cgroup.h
+++ linux-2.6.39.git/include/linux/cgroup.h
@@ -231,6 +231,7 @@ struct cgroup {
 
 	/* For RCU-protected deletion */
 	struct rcu_head rcu_head;
+	struct work_struct work;
 
 	/* List of events which userspace want to recieve */
 	struct list_head event_list;
Index: linux-2.6.39.git/kernel/cgroup.c
===================================================================
--- linux-2.6.39.git.orig/kernel/cgroup.c
+++ linux-2.6.39.git/kernel/cgroup.c
@@ -836,11 +836,42 @@ static int cgroup_call_pre_destroy(struc
 	return ret;
 }
 
+static void free_cgroup_work(struct work_struct *work)
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
+	kfree(cgrp);
+}
+
 static void free_cgroup_rcu(struct rcu_head *obj)
 {
 	struct cgroup *cgrp = container_of(obj, struct cgroup, rcu_head);
 
-	kfree(cgrp);
+	INIT_WORK(&cgrp->work, free_cgroup_work);
+	schedule_work(&cgrp->work);
 }
 
 static void cgroup_diput(struct dentry *dentry, struct inode *inode)
@@ -848,7 +879,7 @@ static void cgroup_diput(struct dentry *
 	/* is dentry a directory ? if so, kfree() associated cgroup */
 	if (S_ISDIR(inode->i_mode)) {
 		struct cgroup *cgrp = dentry->d_fsdata;
-		struct cgroup_subsys *ss;
+
 		BUG_ON(!(cgroup_is_removed(cgrp)));
 		/* It's possible for external users to be holding css
 		 * reference counts on a cgroup; css_put() needs to
@@ -856,30 +887,6 @@ static void cgroup_diput(struct dentry *
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
 		call_rcu(&cgrp->rcu_head, free_cgroup_rcu);
 	}
 	iput(inode);


