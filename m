Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab1CUXRc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:17:32 -0400
Received: from kroah.org ([198.145.64.141]:52478 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755563Ab1CUXR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:17:27 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:03:21 2011
Message-Id: <20110321230321.854111685@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:01:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [02/78] VFS: Fix the nfs sillyrename regression in kernel 2.6.38
In-Reply-To: <20110321230346.GA14681@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit c83ce989cb5ff86575821992ea82c4df5c388ebc upstream.

The new vfs locking scheme introduced in 2.6.38 breaks NFS sillyrename
because the latter relies on being able to determine the parent
directory of the dentry in the ->iput() callback in order to send the
appropriate unlink rpc call.

Looking at the code that cares about races with dput(), there doesn't
seem to be anything that specifically uses d_parent as a test for
whether or not there is a race:
  - __d_lookup_rcu(), __d_lookup() all test for d_hashed() after d_parent
  - shrink_dcache_for_umount() is safe since nothing else can rearrange
    the dentries in that super block.
  - have_submount(), select_parent() and d_genocide() can test for a
    deletion if we set the DCACHE_DISCONNECTED flag when the dentry
    is removed from the parent's d_subdirs list.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/dcache.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -296,8 +296,12 @@ static struct dentry *d_kill(struct dent
 	__releases(parent->d_lock)
 	__releases(dentry->d_inode->i_lock)
 {
-	dentry->d_parent = NULL;
 	list_del(&dentry->d_u.d_child);
+	/*
+	 * Inform try_to_ascend() that we are no longer attached to the
+	 * dentry tree
+	 */
+	dentry->d_flags |= DCACHE_DISCONNECTED;
 	if (parent)
 		spin_unlock(&parent->d_lock);
 	dentry_iput(dentry);
@@ -1030,6 +1034,7 @@ static struct dentry *try_to_ascend(stru
 	 * or deletion
 	 */
 	if (new != old->d_parent ||
+		 (old->d_flags & DCACHE_DISCONNECTED) ||
 		 (!locked && read_seqretry(&rename_lock, seq))) {
 		spin_unlock(&new->d_lock);
 		new = NULL;


