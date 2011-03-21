Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab1CUXRa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:17:30 -0400
Received: from kroah.org ([198.145.64.141]:52474 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755202Ab1CUXR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:17:26 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:03:21 2011
Message-Id: <20110321230321.748487778@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:01:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [01/78] dcache.c: create helper function for duplicated functionality
In-Reply-To: <20110321230346.GA14681@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit c826cb7dfce80512c26c984350077a25046bd215 upstream.

This creates a helper function for he "try to ascend into the parent
directory" case, which was written out in triplicate before.  With all
the locking and subtle sequence number stuff, we really don't want to
duplicate that kind of code.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/dcache.c |   88 +++++++++++++++++++++++++-----------------------------------
 1 file changed, 37 insertions(+), 51 deletions(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1012,6 +1012,34 @@ void shrink_dcache_for_umount(struct sup
 }
 
 /*
+ * This tries to ascend one level of parenthood, but
+ * we can race with renaming, so we need to re-check
+ * the parenthood after dropping the lock and check
+ * that the sequence number still matches.
+ */
+static struct dentry *try_to_ascend(struct dentry *old, int locked, unsigned seq)
+{
+	struct dentry *new = old->d_parent;
+
+	rcu_read_lock();
+	spin_unlock(&old->d_lock);
+	spin_lock(&new->d_lock);
+
+	/*
+	 * might go back up the wrong parent if we have had a rename
+	 * or deletion
+	 */
+	if (new != old->d_parent ||
+		 (!locked && read_seqretry(&rename_lock, seq))) {
+		spin_unlock(&new->d_lock);
+		new = NULL;
+	}
+	rcu_read_unlock();
+	return new;
+}
+
+
+/*
  * Search for at least 1 mount point in the dentry's subdirs.
  * We descend to the next level whenever the d_subdirs
  * list is non-empty and continue searching.
@@ -1066,24 +1094,10 @@ resume:
 	 * All done at this level ... ascend and resume the search.
 	 */
 	if (this_parent != parent) {
-		struct dentry *tmp;
-		struct dentry *child;
-
-		tmp = this_parent->d_parent;
-		rcu_read_lock();
-		spin_unlock(&this_parent->d_lock);
-		child = this_parent;
-		this_parent = tmp;
-		spin_lock(&this_parent->d_lock);
-		/* might go back up the wrong parent if we have had a rename
-		 * or deletion */
-		if (this_parent != child->d_parent ||
-			 (!locked && read_seqretry(&rename_lock, seq))) {
-			spin_unlock(&this_parent->d_lock);
-			rcu_read_unlock();
+		struct dentry *child = this_parent;
+		this_parent = try_to_ascend(this_parent, locked, seq);
+		if (!this_parent)
 			goto rename_retry;
-		}
-		rcu_read_unlock();
 		next = child->d_u.d_child.next;
 		goto resume;
 	}
@@ -1181,24 +1195,10 @@ resume:
 	 * All done at this level ... ascend and resume the search.
 	 */
 	if (this_parent != parent) {
-		struct dentry *tmp;
-		struct dentry *child;
-
-		tmp = this_parent->d_parent;
-		rcu_read_lock();
-		spin_unlock(&this_parent->d_lock);
-		child = this_parent;
-		this_parent = tmp;
-		spin_lock(&this_parent->d_lock);
-		/* might go back up the wrong parent if we have had a rename
-		 * or deletion */
-		if (this_parent != child->d_parent ||
-			(!locked && read_seqretry(&rename_lock, seq))) {
-			spin_unlock(&this_parent->d_lock);
-			rcu_read_unlock();
+		struct dentry *child = this_parent;
+		this_parent = try_to_ascend(this_parent, locked, seq);
+		if (!this_parent)
 			goto rename_retry;
-		}
-		rcu_read_unlock();
 		next = child->d_u.d_child.next;
 		goto resume;
 	}
@@ -2942,28 +2942,14 @@ resume:
 		spin_unlock(&dentry->d_lock);
 	}
 	if (this_parent != root) {
-		struct dentry *tmp;
-		struct dentry *child;
-
-		tmp = this_parent->d_parent;
+		struct dentry *child = this_parent;
 		if (!(this_parent->d_flags & DCACHE_GENOCIDE)) {
 			this_parent->d_flags |= DCACHE_GENOCIDE;
 			this_parent->d_count--;
 		}
-		rcu_read_lock();
-		spin_unlock(&this_parent->d_lock);
-		child = this_parent;
-		this_parent = tmp;
-		spin_lock(&this_parent->d_lock);
-		/* might go back up the wrong parent if we have had a rename
-		 * or deletion */
-		if (this_parent != child->d_parent ||
-			 (!locked && read_seqretry(&rename_lock, seq))) {
-			spin_unlock(&this_parent->d_lock);
-			rcu_read_unlock();
+		this_parent = try_to_ascend(this_parent, locked, seq);
+		if (!this_parent)
 			goto rename_retry;
-		}
-		rcu_read_unlock();
 		next = child->d_u.d_child.next;
 		goto resume;
 	}


