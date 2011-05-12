Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab1ELBYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 21:24:37 -0400
Received: from cobra.newdream.net ([66.33.216.30]:54291 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab1ELBYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 21:24:32 -0400
From: Sage Weil <sage@newdream.net>
To: viro@ZenIV.linux.org.uk, hch@lst.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        ceph-devel@vger.kernel.org, Sage Weil <sage@newdream.net>
Subject: [PATCH 2/3] ceph: clear parent D_COMPLETE flag when on dentry prune
Date: Wed, 11 May 2011 18:43:35 -0700
Message-Id: <1305164616-26597-3-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1305164616-26597-1-git-send-email-sage@newdream.net>
References: <1305164616-26597-1-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the VFS prunes a dentry from the cache, clear the D_COMPLETE flag
on the parent dentry.  Do this for the live and snapshotted namespaces. Do
not bother for the .snap dir contents, since we do not cache that.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/ceph/dir.c   |   28 ++++++++++++++++++++++++++++
 fs/ceph/super.h |   13 +++++++++++++
 2 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 1a867a3..e2005fa 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1053,7 +1053,33 @@ static int ceph_snapdir_d_revalidate(struct dentry *dentry,
 	return 1;
 }
 
+/*
+ * When the VFS prunes a dentry from the cache, we need to clear the
+ * complete flag on the parent directory.
+ *
+ * Called under dentry->d_lock.
+ */
+static void ceph_d_prune(struct dentry *dentry)
+{
+	struct ceph_dentry_info *di;
+
+	dout("d_release %p\n", dentry);
+
+	/* do we have a valid parent? */
+	if (!dentry->d_parent || IS_ROOT(dentry))
+		return;
+
+	/* if we are not hashed, we don't affect D_COMPLETE */
+	if (d_unhashed(dentry))
+		return;
 
+	/*
+	 * we hold d_lock, so d_parent is stable, and d_fsdata is never
+	 * cleared until d_release
+	 */
+	di = ceph_dentry(dentry->d_parent);
+	clear_bit(CEPH_D_COMPLETE, &di->flags);
+}
 
 /*
  * read() on a dir.  This weird interface hack only works if mounted
@@ -1259,6 +1285,7 @@ const struct inode_operations ceph_dir_iops = {
 const struct dentry_operations ceph_dentry_ops = {
 	.d_revalidate = ceph_d_revalidate,
 	.d_release = ceph_d_release,
+	.d_prune = ceph_d_prune,
 };
 
 const struct dentry_operations ceph_snapdir_dentry_ops = {
@@ -1268,4 +1295,5 @@ const struct dentry_operations ceph_snapdir_dentry_ops = {
 
 const struct dentry_operations ceph_snap_dentry_ops = {
 	.d_release = ceph_d_release,
+	.d_prune = ceph_d_prune,
 };
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 619fe71..b6bf098 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -201,6 +201,7 @@ struct ceph_inode_xattr {
  * Ceph dentry state
  */
 struct ceph_dentry_info {
+	unsigned long flags;
 	struct ceph_mds_session *lease_session;
 	u32 lease_gen, lease_shared_gen;
 	u32 lease_seq;
@@ -211,6 +212,18 @@ struct ceph_dentry_info {
 	u64 offset;
 };
 
+/*
+ * dentry flags
+ *
+ * The locking for D_COMPLETE is a bit odd:
+ *  - we can clear it at almost any time (see ceph_d_prune)
+ *  - it is only meaningful if:
+ *    - we hold dir inode i_lock
+ *    - we hold dir FILE_SHARED caps
+ *    - the dentry D_COMPLETE is set
+ */
+#define CEPH_D_COMPLETE 1  /* if set, d_u.d_subdirs is complete directory */
+
 struct ceph_inode_xattrs_info {
 	/*
 	 * (still encoded) xattr blob. we avoid the overhead of parsing
-- 
1.7.0

