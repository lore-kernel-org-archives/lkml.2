Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422879Ab2I1Upc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:45:32 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57655 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031093Ab2I1Ukx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:40:53 -0400
X-Sasl-enc: XpEQAW4id3od3qh1OMqf2JXhGgTzbEo2G/yiYZpYh4m/ 1348864852
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Miklos Szeredi <mszeredi@suse.cz>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 027/127] vfs: dcache: use DCACHE_DENTRY_KILLED instead of DCACHE_DISCONNECTED in d_kill()
Date: Fri, 28 Sep 2012 13:33:20 -0700
Message-Id: <20120928203048.998483503@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit b161dfa6937ae46d50adce8a7c6b12233e96e7bd upstream.

IBM reported a soft lockup after applying the fix for the rename_lock
deadlock.  Commit c83ce989cb5f ("VFS: Fix the nfs sillyrename regression
in kernel 2.6.38") was found to be the culprit.

The nfs sillyrename fix used DCACHE_DISCONNECTED to indicate that the
dentry was killed.  This flag can be set on non-killed dentries too,
which results in infinite retries when trying to traverse the dentry
tree.

This patch introduces a separate flag: DCACHE_DENTRY_KILLED, which is
only set in d_kill() and makes try_to_ascend() test only this flag.

IBM reported successful test results with this patch.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/dcache.c            |    4 ++--
 include/linux/dcache.h |    2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -290,7 +290,7 @@ static struct dentry *d_kill(struct dent
 	 * Inform try_to_ascend() that we are no longer attached to the
 	 * dentry tree
 	 */
-	dentry->d_flags |= DCACHE_DISCONNECTED;
+	dentry->d_flags |= DCACHE_DENTRY_KILLED;
 	if (parent)
 		spin_unlock(&parent->d_lock);
 	dentry_iput(dentry);
@@ -1015,7 +1015,7 @@ static struct dentry *try_to_ascend(stru
 	 * or deletion
 	 */
 	if (new != old->d_parent ||
-		 (old->d_flags & DCACHE_DISCONNECTED) ||
+		 (old->d_flags & DCACHE_DENTRY_KILLED) ||
 		 (!locked && read_seqretry(&rename_lock, seq))) {
 		spin_unlock(&new->d_lock);
 		new = NULL;
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -220,6 +220,8 @@ struct dentry_operations {
 #define DCACHE_MANAGED_DENTRY \
 	(DCACHE_MOUNTED|DCACHE_NEED_AUTOMOUNT|DCACHE_MANAGE_TRANSIT)
 
+#define DCACHE_DENTRY_KILLED	0x100000
+
 extern seqlock_t rename_lock;
 
 static inline int dname_external(struct dentry *dentry)


