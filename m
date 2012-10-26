Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427Ab2JZLj2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 07:39:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57431 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932351Ab2JZLiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 07:38:05 -0400
From: Michal Hocko <mhocko@suse.cz>
To: linux-mm@kvack.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Glauber Costa <glommer@parallels.com>
Subject: [PATCH v3 4/6] cgroups: forbid pre_destroy callback to fail
Date: Fri, 26 Oct 2012 13:37:31 +0200
Message-Id: <1351251453-6140-5-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1351251453-6140-1-git-send-email-mhocko@suse.cz>
References: <1351251453-6140-1-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that mem_cgroup_pre_destroy callback doesn't fail (other than a race
with a task attach resp. child group appears) finally we can safely move
on and forbit all the callbacks to fail.
The last missing piece is moving cgroup_call_pre_destroy after
cgroup_clear_css_refs so that css_tryget fails so no new charges for the
memcg can happen.
We cannot, however, move cgroup_call_pre_destroy right after because we
cannot call mem_cgroup_pre_destroy with the cgroup_lock held (see
3fa59dfb cgroup: fix potential deadlock in pre_destroy) so we have to
move it after the lock is released.

Changes since v1
- Li Zefan pointed out that mem_cgroup_pre_destroy cannot be called with
  cgroup_lock held

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 kernel/cgroup.c |   30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 7981850..e9e2287b 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -855,7 +855,7 @@ static struct inode *cgroup_new_inode(umode_t mode, struct super_block *sb)
  * Call subsys's pre_destroy handler.
  * This is called before css refcnt check.
  */
-static int cgroup_call_pre_destroy(struct cgroup *cgrp)
+static void cgroup_call_pre_destroy(struct cgroup *cgrp)
 {
 	struct cgroup_subsys *ss;
 	int ret = 0;
@@ -864,15 +864,8 @@ static int cgroup_call_pre_destroy(struct cgroup *cgrp)
 		if (!ss->pre_destroy)
 			continue;
 
-		ret = ss->pre_destroy(cgrp);
-		if (ret) {
-			/* ->pre_destroy() failure is being deprecated */
-			WARN_ON_ONCE(!ss->__DEPRECATED_clear_css_refs);
-			break;
-		}
+		BUG_ON(ss->pre_destroy(cgrp));
 	}
-
-	return ret;
 }
 
 static void cgroup_diput(struct dentry *dentry, struct inode *inode)
@@ -4151,7 +4144,6 @@ again:
 		mutex_unlock(&cgroup_mutex);
 		return -EBUSY;
 	}
-	mutex_unlock(&cgroup_mutex);
 
 	/*
 	 * In general, subsystem has no css->refcnt after pre_destroy(). But
@@ -4164,17 +4156,6 @@ again:
 	 */
 	set_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
 
-	/*
-	 * Call pre_destroy handlers of subsys. Notify subsystems
-	 * that rmdir() request comes.
-	 */
-	ret = cgroup_call_pre_destroy(cgrp);
-	if (ret) {
-		clear_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
-		return ret;
-	}
-
-	mutex_lock(&cgroup_mutex);
 	parent = cgrp->parent;
 	if (atomic_read(&cgrp->count) || !list_empty(&cgrp->children)) {
 		clear_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
@@ -4196,6 +4177,7 @@ again:
 			return -EINTR;
 		goto again;
 	}
+
 	/* NO css_tryget() can success after here. */
 	finish_wait(&cgroup_rmdir_waitq, &wait);
 	clear_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
@@ -4234,6 +4216,12 @@ again:
 	spin_unlock(&cgrp->event_list_lock);
 
 	mutex_unlock(&cgroup_mutex);
+
+	/*
+	 * Call pre_destroy handlers of subsys. Notify subsystems
+	 * that rmdir() request comes.
+	 */
+	cgroup_call_pre_destroy(cgrp);
 	return 0;
 }
 
-- 
1.7.10.4

