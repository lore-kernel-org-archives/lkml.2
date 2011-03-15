Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742Ab1CONOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 09:14:19 -0400
Received: from smtp.nokia.com ([147.243.1.47]:31448 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757677Ab1CONOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 09:14:18 -0400
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: menage@google.com, lizf@cn.fujitsu.com
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, ext-phil.2.carmody@nokia.com
Subject: [PATCH 2/2] cgroup: if you list_empty() a head then don't list_del() it
Date: Tue, 15 Mar 2011 15:08:43 +0200
Message-Id: <1300194523-19325-3-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.7.2.rc1.37.gf8c40
In-Reply-To: <1300194523-19325-2-git-send-email-ext-phil.2.carmody@nokia.com>
References: <1300194523-19325-1-git-send-email-ext-phil.2.carmody@nokia.com>
 <1300194523-19325-2-git-send-email-ext-phil.2.carmody@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

list_del() leaves poison in the prev and next pointers. The next
list_empty() will compare those poisons, and say the list isn't empty.
Any list operations that assume the node is on a list because of such a
check will be fooled into dereferencing poison. One needs to INIT the
node after the del, and fortunately there's already a wrapper for that -
list_del_init().

Some of the dels are followed by deallocations, so can be ignored,
and one can be merged with an add to make a move. Apart from that, I
erred on the side of caution in making nodes list_empty()-queriable.

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
---
 kernel/cgroup.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index b24d702..bcc7336 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1813,10 +1813,8 @@ int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 
 	/* Update the css_set linked lists if we're using them */
 	write_lock(&css_set_lock);
-	if (!list_empty(&tsk->cg_list)) {
-		list_del(&tsk->cg_list);
-		list_add(&tsk->cg_list, &newcg->tasks);
-	}
+	if (!list_empty(&tsk->cg_list))
+		list_move(&tsk->cg_list, &newcg->tasks);
 	write_unlock(&css_set_lock);
 
 	for_each_subsys(root, ss) {
@@ -3655,12 +3653,12 @@ again:
 	spin_lock(&release_list_lock);
 	set_bit(CGRP_REMOVED, &cgrp->flags);
 	if (!list_empty(&cgrp->release_list))
-		list_del(&cgrp->release_list);
+		list_del_init(&cgrp->release_list);
 	spin_unlock(&release_list_lock);
 
 	cgroup_lock_hierarchy(cgrp->root);
 	/* delete this cgroup from parent->children */
-	list_del(&cgrp->sibling);
+	list_del_init(&cgrp->sibling);
 	cgroup_unlock_hierarchy(cgrp->root);
 
 	d = dget(cgrp->dentry);
@@ -3879,7 +3877,7 @@ void cgroup_unload_subsys(struct cgroup_subsys *ss)
 	subsys[ss->subsys_id] = NULL;
 
 	/* remove subsystem from rootnode's list of subsystems */
-	list_del(&ss->sibling);
+	list_del_init(&ss->sibling);
 
 	/*
 	 * disentangle the css from all css_sets attached to the dummytop. as
@@ -4253,7 +4251,7 @@ void cgroup_exit(struct task_struct *tsk, int run_callbacks)
 	if (!list_empty(&tsk->cg_list)) {
 		write_lock(&css_set_lock);
 		if (!list_empty(&tsk->cg_list))
-			list_del(&tsk->cg_list);
+			list_del_init(&tsk->cg_list);
 		write_unlock(&css_set_lock);
 	}
 
-- 
1.7.2.rc1.37.gf8c40

