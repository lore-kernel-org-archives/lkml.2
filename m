Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab1C2HIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 03:08:35 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:43825 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752487Ab1C2HIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 03:08:34 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiQIAFGDkU15LK5JTmdsb2JhbACESZQFjHYLAQEbBQMjJbJjkHiBJ4NMdwSTAA
From: Dave Chinner <david@fromorbit.com>
To: torvalds@linux-foundation.org
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ryan@bluewatersys.com
Subject: [PATCH] fs: don't use igrab() while holding i_lock
Date: Tue, 29 Mar 2011 18:08:50 +1100
Message-Id: <1301382530-32069-1-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Fix the incorrect use of igrab() inside the i_lock in NFS and Ceph‥
If we are already holding the i_lock, we have a reference to the
inode so we can safely use ihold() to gain an extra reference. This
avoids hangs due to lock recursion on the i_lock now that the
inode_lock is gone and igrab() uses the i_lock itself.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/ceph/addr.c     |    2 +-
 fs/ceph/snap.c     |    4 ++--
 fs/nfs/nfs4state.c |    3 ++-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 561438b..37368ba 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -92,7 +92,7 @@ static int ceph_set_page_dirty(struct page *page)
 		ci->i_head_snapc = ceph_get_snap_context(snapc);
 	++ci->i_wrbuffer_ref_head;
 	if (ci->i_wrbuffer_ref == 0)
-		igrab(inode);
+		ihold(inode);
 	++ci->i_wrbuffer_ref;
 	dout("%p set_page_dirty %p idx %lu head %d/%d -> %d/%d "
 	     "snapc %p seq %lld (%d snaps)\n",
diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index f40b913..0aee66b 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -463,8 +463,8 @@ void ceph_queue_cap_snap(struct ceph_inode_info *ci)
 
 		dout("queue_cap_snap %p cap_snap %p queuing under %p\n", inode,
 		     capsnap, snapc);
-		igrab(inode);
-		
+		ihold(inode);
+
 		atomic_set(&capsnap->nref, 1);
 		capsnap->ci = ci;
 		INIT_LIST_HEAD(&capsnap->ci_item);
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index ab1bf5b..a6804f7 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -590,7 +590,8 @@ nfs4_get_open_state(struct inode *inode, struct nfs4_state_owner *owner)
 		state->owner = owner;
 		atomic_inc(&owner->so_count);
 		list_add(&state->inode_states, &nfsi->open_states);
-		state->inode = igrab(inode);
+		ihold(inode);
+		state->inode = inode;
 		spin_unlock(&inode->i_lock);
 		/* Note: The reclaim code dictates that we add stateless
 		 * and read-only stateids to the end of the list */
-- 
1.7.2.3

