Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932577Ab0HXW60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:58:26 -0400
Received: from kroah.org ([198.145.64.141]:40297 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932722Ab0HXW6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:58:17 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:42:13 2010
Message-Id: <20100824224213.351592096@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:41:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Wengang Wang <wen.gang.wang@oracle.com>,
        Srinivas Eeda <srinivas.eeda@oracle.com>,
        Joel Becker <joel.becker@oracle.com>
Subject: [15/91] ocfs2/dlm: avoid incorrect bit set in refmap on recovery master
In-Reply-To: <20100824224617.GA5440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Wengang Wang <wen.gang.wang@oracle.com>

commit a524812b7eaa7783d7811198921100f079034e61 upstream.

In the following situation, there remains an incorrect bit in refmap on the
recovery master. Finally the recovery master will fail at purging the lockres
due to the incorrect bit in refmap.

1) node A has no interest on lockres A any longer, so it is purging it.
2) the owner of lockres A is node B, so node A is sending de-ref message
to node B.
3) at this time, node B crashed. node C becomes the recovery master. it recovers
lockres A(because the master is the dead node B).
4) node A migrated lockres A to node C with a refbit there.
5) node A failed to send de-ref message to node B because it crashed. The failure
is ignored. no other action is done for lockres A any more.

For mormal, re-send the deref message to it to recovery master can fix it. Well,
ignoring the failure of deref to the original master and not recovering the lockres
to recovery master has the same effect. And the later is simpler.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
Acked-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ocfs2/dlm/dlmrecovery.c |   22 ++++++++++------------
 fs/ocfs2/dlm/dlmthread.c   |   34 +++++++++++++++++++++-------------
 2 files changed, 31 insertions(+), 25 deletions(-)

--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -1991,6 +1991,8 @@ void dlm_move_lockres_to_recovery_list(s
 	struct list_head *queue;
 	struct dlm_lock *lock, *next;
 
+	assert_spin_locked(&dlm->spinlock);
+	assert_spin_locked(&res->spinlock);
 	res->state |= DLM_LOCK_RES_RECOVERING;
 	if (!list_empty(&res->recovering)) {
 		mlog(0,
@@ -2320,19 +2322,15 @@ static void dlm_do_local_recovery_cleanu
 			/* zero the lvb if necessary */
 			dlm_revalidate_lvb(dlm, res, dead_node);
 			if (res->owner == dead_node) {
-				if (res->state & DLM_LOCK_RES_DROPPING_REF)
-					mlog(0, "%s:%.*s: owned by "
-					     "dead node %u, this node was "
-					     "dropping its ref when it died. "
-					     "continue, dropping the flag.\n",
-					     dlm->name, res->lockname.len,
-					     res->lockname.name, dead_node);
-
-				/* the wake_up for this will happen when the
-				 * RECOVERING flag is dropped later */
-				res->state &= ~DLM_LOCK_RES_DROPPING_REF;
+				if (res->state & DLM_LOCK_RES_DROPPING_REF) {
+					mlog(ML_NOTICE, "Ignore %.*s for "
+					     "recovery as it is being freed\n",
+					     res->lockname.len,
+					     res->lockname.name);
+				} else
+					dlm_move_lockres_to_recovery_list(dlm,
+									  res);
 
-				dlm_move_lockres_to_recovery_list(dlm, res);
 			} else if (res->owner == dlm->node_num) {
 				dlm_free_dead_locks(dlm, res, dead_node);
 				__dlm_lockres_calc_usage(dlm, res);
--- a/fs/ocfs2/dlm/dlmthread.c
+++ b/fs/ocfs2/dlm/dlmthread.c
@@ -92,19 +92,27 @@ int __dlm_lockres_has_locks(struct dlm_l
  * truly ready to be freed. */
 int __dlm_lockres_unused(struct dlm_lock_resource *res)
 {
-	if (!__dlm_lockres_has_locks(res) &&
-	    (list_empty(&res->dirty) && !(res->state & DLM_LOCK_RES_DIRTY))) {
-		/* try not to scan the bitmap unless the first two
-		 * conditions are already true */
-		int bit = find_next_bit(res->refmap, O2NM_MAX_NODES, 0);
-		if (bit >= O2NM_MAX_NODES) {
-			/* since the bit for dlm->node_num is not
-			 * set, inflight_locks better be zero */
-			BUG_ON(res->inflight_locks != 0);
-			return 1;
-		}
-	}
-	return 0;
+	int bit;
+
+	if (__dlm_lockres_has_locks(res))
+		return 0;
+
+	if (!list_empty(&res->dirty) || res->state & DLM_LOCK_RES_DIRTY)
+		return 0;
+
+	if (res->state & DLM_LOCK_RES_RECOVERING)
+		return 0;
+
+	bit = find_next_bit(res->refmap, O2NM_MAX_NODES, 0);
+	if (bit < O2NM_MAX_NODES)
+		return 0;
+
+	/*
+	 * since the bit for dlm->node_num is not set, inflight_locks better
+	 * be zero
+	 */
+	BUG_ON(res->inflight_locks != 0);
+	return 1;
 }
 
 


