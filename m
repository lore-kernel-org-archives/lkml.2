Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab2BUTyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 14:54:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755992Ab2BUTyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:54:17 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 10/73] VFS: Add CL_MAKE_HARD_READONLY flag to
 clone_mnt()/copy_tree() [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Ram Pai <linuxram@us.ibm.com>
Date: Tue, 21 Feb 2012 17:58:40 +0000
Message-ID: <20120221175840.25235.26634.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Valerie Aurora <vaurora@redhat.com>

Passing the CL_MAKE_HARD_READONLY flag to clone_mnt() causes the clone
to fail if the source superblock is not read-only.  If it is
read-only, it increments the hard read-only users and sets the
MNT_HARD_READONLY flag in the vfsmount.  When the mount is freed via
free_vfsmnt(), automatically decrement the hard read-only users count.

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Ram Pai <linuxram@us.ibm.com>
---

 fs/namespace.c        |   18 ++++++++++++++++++
 fs/pnode.h            |    1 +
 include/linux/mount.h |    1 +
 3 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 96f43f2..c01aff2 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -481,6 +481,12 @@ int sb_prepare_remount_readonly(struct super_block *sb)
 static void free_vfsmnt(struct mount *mnt)
 {
 	kfree(mnt->mnt_devname);
+	if (mnt->mnt.mnt_flags & MNT_HARD_READONLY) {
+		BUG_ON(mnt->mnt.mnt_sb->s_hard_readonly_users <= 0);
+		down_write(&mnt->mnt.mnt_sb->s_umount);
+		mnt->mnt.mnt_sb->s_hard_readonly_users--;
+		up_write(&mnt->mnt.mnt_sb->s_umount);
+	}
 	mnt_free_id(mnt);
 #ifdef CONFIG_SMP
 	free_percpu(mnt->mnt_pcp);
@@ -746,6 +752,16 @@ static struct mount *clone_mnt(struct mount *old, struct dentry *root,
 	if ((flag & CL_NO_SLAVE) && IS_MNT_SLAVE(old))
 		return ERR_PTR(-EINVAL);
 
+	if (flag & CL_MAKE_HARD_READONLY) {
+		down_write(&sb->s_umount);
+		if (!(sb->s_flags & MS_RDONLY)) {
+			up_write(&sb->s_umount);
+			return ERR_PTR(-EBUSY);
+		}
+		sb->s_hard_readonly_users++;
+		up_write(&sb->s_umount);
+	}
+
 	mnt = alloc_vfsmnt(old->mnt_devname);
 	if (!mnt)
 		return ERR_PTR(-ENOMEM);
@@ -784,6 +800,8 @@ static struct mount *clone_mnt(struct mount *old, struct dentry *root,
 	}
 	if (flag & CL_MAKE_SHARED)
 		set_mnt_shared(mnt);
+	if (flag & CL_MAKE_HARD_READONLY)
+		mnt->mnt.mnt_flags |= MNT_HARD_READONLY;
 
 	/* stick the duplicate mount on the same expiry list as the
 	 * original if that was on one */
diff --git a/fs/pnode.h b/fs/pnode.h
index f7ae149..321d7ab 100644
--- a/fs/pnode.h
+++ b/fs/pnode.h
@@ -24,6 +24,7 @@
 #define CL_PRIVATE 		0x10
 #define CL_NO_SHARED 		0x20
 #define CL_NO_SLAVE 		0x40
+#define CL_MAKE_HARD_READONLY	0x80
 
 static inline void set_mnt_shared(struct mount *mnt)
 {
diff --git a/include/linux/mount.h b/include/linux/mount.h
index d7029f4..41c7c84 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -46,6 +46,7 @@ struct mnt_namespace;
 
 
 #define MNT_INTERNAL	0x4000
+#define MNT_HARD_READONLY	0x8000	/* has a hard read-only ref on the sb */
 
 struct vfsmount {
 	struct dentry *mnt_root;	/* root of the mounted tree */

