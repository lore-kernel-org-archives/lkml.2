Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab2JGXWQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:22:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38161 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752432Ab2JGXV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:21:58 -0400
Message-Id: <20121007225836.111413761@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:58:44 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Miklos Szeredi <mszeredi@suse.cz>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 010/108] vfs: dcache: use DCACHE_DENTRY_KILLED instead of DCACHE_DISCONNECTED
 in d_kill()
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/dcache.c            |    4 ++--
 include/linux/dcache.h |    2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 8086636..16521a9 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -389,7 +389,7 @@ static struct dentry *d_kill(struct dentry *dentry, struct dentry *parent)
 	 * Inform try_to_ascend() that we are no longer attached to the
 	 * dentry tree
 	 */
-	dentry->d_flags |= DCACHE_DISCONNECTED;
+	dentry->d_flags |= DCACHE_DENTRY_KILLED;
 	if (parent)
 		spin_unlock(&parent->d_lock);
 	dentry_iput(dentry);
@@ -1048,7 +1048,7 @@ static struct dentry *try_to_ascend(struct dentry *old, int locked, unsigned seq
 	 * or deletion
 	 */
 	if (new != old->d_parent ||
-		 (old->d_flags & DCACHE_DISCONNECTED) ||
+		 (old->d_flags & DCACHE_DENTRY_KILLED) ||
 		 (!locked && read_seqretry(&rename_lock, seq))) {
 		spin_unlock(&new->d_lock);
 		new = NULL;
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index caa34e5..5920079 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -206,6 +206,8 @@ struct dentry_operations {
 #define DCACHE_MANAGED_DENTRY \
 	(DCACHE_MOUNTED|DCACHE_NEED_AUTOMOUNT|DCACHE_MANAGE_TRANSIT)
 
+#define DCACHE_DENTRY_KILLED	0x100000
+
 extern seqlock_t rename_lock;
 
 static inline int dname_external(struct dentry *dentry)


