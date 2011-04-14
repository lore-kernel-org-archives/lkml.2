Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758314Ab1DNIex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 04:34:53 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:60199 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756819Ab1DNIet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 04:34:49 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19jkuxnPapjtnppmSA+aavZx3FERcOps94p2A3R+m
	tJ9WczyJqsR0Tn
Subject: Re: query: [PATCH 2/2] cgroup: Remove call to synchronize_rcu in
 cgroup_attach_task
From: Mike Galbraith <efault@gmx.de>
To: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Colin Cross <ccross@android.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1302765999.8042.8.camel@marge.simson.net>
References: <1302170153.12304.31.camel@marge.simson.net>
	 <4DA50430.8020701@cn.fujitsu.com>
	 <1302664313.7407.29.camel@marge.simson.net>
	 <BANLkTikqvP90Etu=L24DPWbckrawM-6n=Q@mail.gmail.com>
	 <1302713819.7448.22.camel@marge.simson.net>
	 <1302765999.8042.8.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Apr 2011 10:34:44 +0200
Message-ID: <1302770084.27576.13.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > On Wed, 2011-04-13 at 15:16 +0200, Paul Menage wrote:

> > > > +       kfree(cgrp);
> > > 
> > > We might want to punt this through RCU again, in case the subsystem
> > > destroy() callbacks left anything around that was previously depending
> > > on the RCU barrier.

Yup, great idea.  Two stage teardown/free quenched the fireworks

> > > Also, I'd be concerned that subsystems might get confused by the fact
> > > that a new group called 'foo' could be created before the old 'foo'
> > > has been cleaned up? (And do any subsystems rely on being able to
> > > access the cgroup dentry up until the point when destroy() is called?

Re-creating a group doesn't appear to be a problem for 'cpu', either
with previous version running single a single beater proggy, or now
running multiple instances of create/attach/detach/destroy.

All other subsystems need testing.. and 'cpu' wants heftier testing.

cgroups: Remove call to synchronize_rcu() in cgroup_diput()

Instead of synchronously waiting via synchronize_rcu(), then initiating cgroup
destruction, schedule asynchronous destruction via call_rcu()->schedule_work()->
destroy_cgroup_rcu()->call_rcu()->free_cgroup_rcu()->kfree() two stage teardown.

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
 kernel/cgroup.c        |   67 +++++++++++++++++++++++++++++--------------------
 2 files changed, 42 insertions(+), 26 deletions(-)

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
@@ -836,6 +836,7 @@ static int cgroup_call_pre_destroy(struc
 	return ret;
 }
 
+
 static void free_cgroup_rcu(struct rcu_head *obj)
 {
 	struct cgroup *cgrp = container_of(obj, struct cgroup, rcu_head);
@@ -843,12 +844,50 @@ static void free_cgroup_rcu(struct rcu_h
 	kfree(cgrp);
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
+	call_rcu(&cgrp->rcu_head, free_cgroup_rcu);
+}
+
+static void destroy_cgroup_rcu(struct rcu_head *obj)
+{
+	struct cgroup *cgrp = container_of(obj, struct cgroup, rcu_head);
+
+	INIT_WORK(&cgrp->work, free_cgroup_work);
+	schedule_work(&cgrp->work);
+}
+
 static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 {
 	/* is dentry a directory ? if so, kfree() associated cgroup */
 	if (S_ISDIR(inode->i_mode)) {
 		struct cgroup *cgrp = dentry->d_fsdata;
-		struct cgroup_subsys *ss;
+
 		BUG_ON(!(cgroup_is_removed(cgrp)));
 		/* It's possible for external users to be holding css
 		 * reference counts on a cgroup; css_put() needs to
@@ -856,31 +895,7 @@ static void cgroup_diput(struct dentry *
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




