Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120Ab1GZRd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 13:33:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426Ab1GZRdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 13:33:19 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] vfs: document locking requirements for d_move, __d_move and d_materialise_unique (try #2)
Date: Tue, 26 Jul 2011 13:33:16 -0400
Message-Id: <1311701596-23252-1-git-send-email-jlayton@redhat.com>
In-Reply-To: <1311701107-22971-1-git-send-email-jlayton@redhat.com>
References: <1311701107-22971-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding a comment to d_materialise_unique per Al's request...

d_move and __d_move have some pretty substantial locking requirements,
but they are not clearly documented. Add some comments spelling them
out. Also, document the requirement for the i_mutex of the parent in
d_materialise_unique.

Cc: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/dcache.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index be18598..b05aac3 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2138,8 +2138,9 @@ static void dentry_unlock_parents_for_move(struct dentry *dentry,
  * @target: new dentry
  *
  * Update the dcache to reflect the move of a file name. Negative
- * dcache entries should not be moved in this way.  Caller hold
- * rename_lock.
+ * dcache entries should not be moved in this way. Caller must hold
+ * rename_lock, the i_mutex of the source and target directories,
+ * and the sb->s_vfs_rename_mutex if they differ. See lock_rename().
  */
 static void __d_move(struct dentry * dentry, struct dentry * target)
 {
@@ -2202,7 +2203,8 @@ static void __d_move(struct dentry * dentry, struct dentry * target)
  * @target: new dentry
  *
  * Update the dcache to reflect the move of a file name. Negative
- * dcache entries should not be moved in this way.
+ * dcache entries should not be moved in this way. See the locking
+ * requirements for __d_move.
  */
 void d_move(struct dentry *dentry, struct dentry *target)
 {
@@ -2320,7 +2322,8 @@ static void __d_materialise_dentry(struct dentry *dentry, struct dentry *anon)
  * @inode: inode to bind to the dentry, to which aliases may be attached
  *
  * Introduces an dentry into the tree, substituting an extant disconnected
- * root directory alias in its place if there is one
+ * root directory alias in its place if there is one. Caller must hold the
+ * i_mutex of the parent directory.
  */
 struct dentry *d_materialise_unique(struct dentry *dentry, struct inode *inode)
 {
-- 
1.7.1

