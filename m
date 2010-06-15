Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264Ab0FOSlb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 14:41:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754485Ab0FOSl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 14:41:29 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 01/38] VFS: Comment follow_mount() and friends
Date: Tue, 15 Jun 2010 11:39:31 -0700
Message-Id: <1276627208-17242-2-git-send-email-vaurora@redhat.com>
In-Reply-To: <1276627208-17242-1-git-send-email-vaurora@redhat.com>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add comments describing what the directions "up" and "down" mean and
ref count handling to the VFS follow_mount() family of functions.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
---
 fs/namei.c     |   43 +++++++++++++++++++++++++++++++++++++++----
 fs/namespace.c |   16 ++++++++++++++--
 2 files changed, 53 insertions(+), 6 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index b86b96f..ec178f1 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -596,6 +596,17 @@ loop:
 	return err;
 }
 
+/*
+ * follow_up - Find the mountpoint of path's vfsmount
+ *
+ * Given a path, find the mountpoint of its source file system.
+ * Replace @path with the path of the mountpoint in the parent mount.
+ * Up is towards /.
+ *
+ * Return 1 if we went up a level and 0 if we were already at the
+ * root.
+ */
+
 int follow_up(struct path *path)
 {
 	struct vfsmount *parent;
@@ -616,8 +627,22 @@ int follow_up(struct path *path)
 	return 1;
 }
 
-/* no need for dcache_lock, as serialization is taken care in
- * namespace.c
+/*
+ * __follow_mount - Return the most recent mount at this mountpoint
+ *
+ * Given a mountpoint, find the most recently mounted file system at
+ * this mountpoint and return the path to its root dentry.  This is
+ * the file system that is visible, and it is in the direction of VFS
+ * "down" - away from the root of the mount tree.  See comments to
+ * lookup_mnt() for an example of "down."
+ *
+ * Does not decrement the refcount on the given mount even if it
+ * follows it to another mount and returns that path instead.
+ *
+ * Returns 0 if path was unchanged, 1 if we followed it to another mount.
+ *
+ * No need for dcache_lock, as serialization is taken care in
+ * namespace.c.
  */
 static int __follow_mount(struct path *path)
 {
@@ -636,6 +661,12 @@ static int __follow_mount(struct path *path)
 	return res;
 }
 
+/*
+ * Like __follow_mount, but no return value and drops references to
+ * both mnt and dentry of the given path if it follows to another
+ * mount.
+ */
+
 static void follow_mount(struct path *path)
 {
 	while (d_mountpoint(path->dentry)) {
@@ -649,8 +680,12 @@ static void follow_mount(struct path *path)
 	}
 }
 
-/* no need for dcache_lock, as serialization is taken care in
- * namespace.c
+/*
+ * Like follow_mount(), but traverses only one layer instead of
+ * continuing until it runs out.
+ *
+ * No need for dcache_lock, as serialization is taken care in
+ * namespace.c.
  */
 int follow_down(struct path *path)
 {
diff --git a/fs/namespace.c b/fs/namespace.c
index f20cb57..d405444 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -433,8 +433,20 @@ struct vfsmount *__lookup_mnt(struct vfsmount *mnt, struct dentry *dentry,
 }
 
 /*
- * lookup_mnt increments the ref count before returning
- * the vfsmount struct.
+ * lookup_mnt - Return the first child mount mounted at path
+ *
+ * "First" means first mounted chronologically.  If you create the
+ * following mounts:
+ *
+ * mount /dev/sda1 /mnt
+ * mount /dev/sda2 /mnt
+ * mount /dev/sda3 /mnt
+ *
+ * Then lookup_mnt() on the base /mnt dentry in the root mount will
+ * return successively the root dentry and vfsmount of /dev/sda1, then
+ * /dev/sda2, then /dev/sda3, then NULL.
+ *
+ * lookup_mnt takes a reference to the found vfsmount.
  */
 struct vfsmount *lookup_mnt(struct path *path)
 {
-- 
1.6.3.3

