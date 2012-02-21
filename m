Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab2BUT4K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 14:56:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754295Ab2BUTym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:54:42 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 33/73] unionmount: Mark lower layers in union [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 18:01:39 +0000
Message-ID: <20120221180139.25235.73784.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark lower layers in union to make it easier to tell when they're being
accessed - just in case a file gets mounted over a unioned lower file.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/namespace.c        |    5 ++++-
 fs/pnode.h            |    1 +
 fs/union.h            |    5 +++++
 include/linux/mount.h |    1 +
 4 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 5fbe3b0..1f24a6b 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -787,6 +787,9 @@ static struct mount *clone_mnt(struct mount *old, struct dentry *root,
 	list_add_tail(&mnt->mnt_instance, &sb->s_mounts);
 	br_write_unlock(vfsmount_lock);
 
+	if ((flag & CL_MAKE_UNION))
+		mnt->mnt.mnt_flags |= MNT_UNION_LOWER;
+
 	if (flag & CL_SLAVE) {
 		list_add(&mnt->mnt_slave, &old->mnt_slave_list);
 		mnt->mnt_master = old;
@@ -1509,7 +1512,7 @@ static int clone_union_tree(struct mount *topmost, struct path *mntpnt)
 	cloned_tree = copy_tree(mnt, mnt->mnt.mnt_root,
 				CL_COPY_ALL | CL_PRIVATE |
 				CL_NO_SHARED | CL_NO_SLAVE |
-				CL_MAKE_HARD_READONLY);
+				CL_MAKE_HARD_READONLY | CL_MAKE_UNION);
 	if (IS_ERR(cloned_tree))
 		return PTR_ERR(cloned_tree);
 
diff --git a/fs/pnode.h b/fs/pnode.h
index 321d7ab..3fd2afe 100644
--- a/fs/pnode.h
+++ b/fs/pnode.h
@@ -25,6 +25,7 @@
 #define CL_NO_SHARED 		0x20
 #define CL_NO_SLAVE 		0x40
 #define CL_MAKE_HARD_READONLY	0x80
+#define CL_MAKE_UNION		0x100
 
 static inline void set_mnt_shared(struct mount *mnt)
 {
diff --git a/fs/union.h b/fs/union.h
index 757f28c..48a9277 100644
--- a/fs/union.h
+++ b/fs/union.h
@@ -56,6 +56,11 @@ static inline bool IS_MNT_UNION(struct vfsmount *mnt)
 	return mnt->mnt_flags & MNT_UNION;
 }
 
+static inline bool IS_MNT_LOWER(struct vfsmount *mnt)
+{
+	return mnt->mnt_flags & MNT_UNION_LOWER;
+}
+
 static inline bool IS_DIR_UNIONED(struct dentry *dentry)
 {
 	return !!dentry->d_union_stack;
diff --git a/include/linux/mount.h b/include/linux/mount.h
index 67f46fa..bd21196 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -48,6 +48,7 @@ struct mnt_namespace;
 #define MNT_INTERNAL	0x4000
 #define MNT_HARD_READONLY	0x8000	/* has a hard read-only ref on the sb */
 #define MNT_UNION	0x10000		/* top layer of a union mount */
+#define MNT_UNION_LOWER	0x20000		/* lower layer of a union mount */
 
 struct vfsmount {
 	struct dentry *mnt_root;	/* root of the mounted tree */

