Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab1CYXwV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 19:52:21 -0400
Received: from kroah.org ([198.145.64.141]:41416 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755619Ab1CYXwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:52:18 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:48:40 2011
Message-Id: <20110325234839.956975466@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:47:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Phil Carmody <ext-phil.2.carmody@nokia.com>,
        Li Zefan <lizf@cn.fujitsu.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [10/55] cgroups: if you list_empty() a head then dont list_del() it
In-Reply-To: <20110325234853.GA21145@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Phil Carmody <ext-phil.2.carmody@nokia.com>

commit 8d2587970b8bdf7c8d9208e3f4bb93182aef1a0f upstream.

list_del() leaves poison in the prev and next pointers.  The next
list_empty() will compare those poisons, and say the list isn't empty.
Any list operations that assume the node is on a list because of such a
check will be fooled into dereferencing poison.  One needs to INIT the
node after the del, and fortunately there's already a wrapper for that -
list_del_init().

Some of the dels are followed by deallocations, so can be ignored, and one
can be merged with an add to make a move.  Apart from that, I erred on the
side of caution in making nodes list_empty()-queriable.

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
Reviewed-by: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/cgroup.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1791,10 +1791,8 @@ int cgroup_attach_task(struct cgroup *cg
 
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
@@ -3630,12 +3628,12 @@ again:
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
 
 	spin_lock(&cgrp->dentry->d_lock);
@@ -3856,7 +3854,7 @@ void cgroup_unload_subsys(struct cgroup_
 	subsys[ss->subsys_id] = NULL;
 
 	/* remove subsystem from rootnode's list of subsystems */
-	list_del(&ss->sibling);
+	list_del_init(&ss->sibling);
 
 	/*
 	 * disentangle the css from all css_sets attached to the dummytop. as
@@ -4230,7 +4228,7 @@ void cgroup_exit(struct task_struct *tsk
 	if (!list_empty(&tsk->cg_list)) {
 		write_lock(&css_set_lock);
 		if (!list_empty(&tsk->cg_list))
-			list_del(&tsk->cg_list);
+			list_del_init(&tsk->cg_list);
 		write_unlock(&css_set_lock);
 	}
 


