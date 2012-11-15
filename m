Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933608Ab2KOEgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:36:18 -0500
Received: from mail.kernel.org ([198.145.19.201]:49014 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992972Ab2KOELX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:11:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <ben@decadent.org.uk>,
        Jonathan Nieder <jrnieder@gmail.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 28/66] nfs: Show original device name verbatim in /proc/*/mount{s,info}
Date: Wed, 14 Nov 2012 20:10:33 -0800
Message-Id: <20121115040941.043852988@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040939.016421011@linuxfoundation.org>
References: <20121115040939.016421011@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 97a54868262da1629a3e65121e65b8e8c4419d9f upstream.

Since commit c7f404b ('vfs: new superblock methods to override
/proc/*/mount{s,info}'), nfs_path() is used to generate the mounted
device name reported back to userland.

nfs_path() always generates a trailing slash when the given dentry is
the root of an NFS mount, but userland may expect the original device
name to be returned verbatim (as it used to be).  Make this
canonicalisation optional and change the callers accordingly.

[jrnieder@gmail.com: use flag instead of bool argument]
Reported-and-tested-by: Chris Hiestand <chiestand@salk.edu>
Reference: http://bugs.debian.org/669314
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/internal.h      |    5 +++--
 fs/nfs/namespace.c     |   19 ++++++++++++++-----
 fs/nfs/nfs4namespace.c |    3 ++-
 fs/nfs/super.c         |    2 +-
 4 files changed, 20 insertions(+), 9 deletions(-)

--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -353,8 +353,9 @@ extern void nfs_sb_active(struct super_b
 extern void nfs_sb_deactive(struct super_block *sb);
 
 /* namespace.c */
+#define NFS_PATH_CANONICAL 1
 extern char *nfs_path(char **p, struct dentry *dentry,
-		      char *buffer, ssize_t buflen);
+		      char *buffer, ssize_t buflen, unsigned flags);
 extern struct vfsmount *nfs_d_automount(struct path *path);
 struct vfsmount *nfs_submount(struct nfs_server *, struct dentry *,
 			      struct nfs_fh *, struct nfs_fattr *);
@@ -491,7 +492,7 @@ static inline char *nfs_devname(struct d
 				char *buffer, ssize_t buflen)
 {
 	char *dummy;
-	return nfs_path(&dummy, dentry, buffer, buflen);
+	return nfs_path(&dummy, dentry, buffer, buflen, NFS_PATH_CANONICAL);
 }
 
 /*
--- a/fs/nfs/namespace.c
+++ b/fs/nfs/namespace.c
@@ -33,6 +33,7 @@ int nfs_mountpoint_expiry_timeout = 500
  * @dentry - pointer to dentry
  * @buffer - result buffer
  * @buflen - length of buffer
+ * @flags - options (see below)
  *
  * Helper function for constructing the server pathname
  * by arbitrary hashed dentry.
@@ -40,8 +41,14 @@ int nfs_mountpoint_expiry_timeout = 500
  * This is mainly for use in figuring out the path on the
  * server side when automounting on top of an existing partition
  * and in generating /proc/mounts and friends.
+ *
+ * Supported flags:
+ * NFS_PATH_CANONICAL: ensure there is exactly one slash after
+ *		       the original device (export) name
+ *		       (if unset, the original name is returned verbatim)
  */
-char *nfs_path(char **p, struct dentry *dentry, char *buffer, ssize_t buflen)
+char *nfs_path(char **p, struct dentry *dentry, char *buffer, ssize_t buflen,
+	       unsigned flags)
 {
 	char *end;
 	int namelen;
@@ -74,7 +81,7 @@ rename_retry:
 		rcu_read_unlock();
 		goto rename_retry;
 	}
-	if (*end != '/') {
+	if ((flags & NFS_PATH_CANONICAL) && *end != '/') {
 		if (--buflen < 0) {
 			spin_unlock(&dentry->d_lock);
 			rcu_read_unlock();
@@ -91,9 +98,11 @@ rename_retry:
 		return end;
 	}
 	namelen = strlen(base);
-	/* Strip off excess slashes in base string */
-	while (namelen > 0 && base[namelen - 1] == '/')
-		namelen--;
+	if (flags & NFS_PATH_CANONICAL) {
+		/* Strip off excess slashes in base string */
+		while (namelen > 0 && base[namelen - 1] == '/')
+			namelen--;
+	}
 	buflen -= namelen;
 	if (buflen < 0) {
 		spin_unlock(&dentry->d_lock);
--- a/fs/nfs/nfs4namespace.c
+++ b/fs/nfs/nfs4namespace.c
@@ -81,7 +81,8 @@ static char *nfs_path_component(const ch
 static char *nfs4_path(struct dentry *dentry, char *buffer, ssize_t buflen)
 {
 	char *limit;
-	char *path = nfs_path(&limit, dentry, buffer, buflen);
+	char *path = nfs_path(&limit, dentry, buffer, buflen,
+			      NFS_PATH_CANONICAL);
 	if (!IS_ERR(path)) {
 		char *path_component = nfs_path_component(path, limit);
 		if (path_component)
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -765,7 +765,7 @@ int nfs_show_devname(struct seq_file *m,
 	int err = 0;
 	if (!page)
 		return -ENOMEM;
-	devname = nfs_path(&dummy, root, page, PAGE_SIZE);
+	devname = nfs_path(&dummy, root, page, PAGE_SIZE, 0);
 	if (IS_ERR(devname))
 		err = PTR_ERR(devname);
 	else


