Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092Ab2BUUAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 15:00:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754975Ab2BUTxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:53:55 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 64/73] union-mount: Implement union-aware truncate() [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com> (Further development)
Date: Tue, 21 Feb 2012 18:05:31 +0000
Message-ID: <20120221180531.25235.60819.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com> (Further development)
---

 fs/open.c |   44 ++++++++++++++++++++++++++++++++++++++------
 1 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index bce645b..f61183b 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -65,14 +65,17 @@ int do_truncate(struct dentry *dentry, loff_t length, unsigned int time_attrs,
 static long do_sys_truncate(const char __user *pathname, loff_t length)
 {
 	struct path path;
+	struct nameidata nd;
+	struct vfsmount *mnt;
 	struct inode *inode;
+	char *tmp;
 	int error;
 
 	error = -EINVAL;
 	if (length < 0)	/* sorry, but loff_t says... */
 		goto out;
 
-	error = user_path(pathname, &path);
+	error = user_path_nd(AT_FDCWD, pathname, 0, &nd, &path, &tmp);
 	if (error)
 		goto out;
 	inode = path.dentry->d_inode;
@@ -86,18 +89,45 @@ static long do_sys_truncate(const char __user *pathname, loff_t length)
 	if (!S_ISREG(inode->i_mode))
 		goto dput_and_out;
 
-	error = mnt_want_write(path.mnt);
+	/* If we're looking at the lower layer of a union mount, then we need
+	 * to create the file on the upperfs and truncate that.
+	 */
+	if (IS_MNT_LOWER(path.mnt))
+		mnt = nd.path.mnt;
+	else
+		mnt = path.mnt;
+
+	error = mnt_want_write(mnt);
 	if (error)
 		goto dput_and_out;
 
-	error = inode_permission(inode, MAY_WRITE);
-	if (error)
-		goto mnt_drop_write_and_out;
+	if (unlikely(IS_MNT_UNION(mnt))) {
+		/* We have to be able to write to the upperfs. */
+		error = -EROFS;
+		if (mnt->mnt_sb->s_flags & MS_RDONLY)
+			goto mnt_drop_write_and_out;
+
+		/* But the lowerfs inode must offer write permission - if the
+		 * lowerfs was mounted writably. */
+		error = __inode_permission(inode, MAY_WRITE);
+		if (error)
+			goto mnt_drop_write_and_out;
+	} else {
+		error = inode_permission(inode, MAY_WRITE);
+		if (error)
+			goto mnt_drop_write_and_out;
+	}
 
 	error = -EPERM;
 	if (IS_APPEND(inode))
 		goto mnt_drop_write_and_out;
 
+	error = union_copyup_len(&nd, &path, length);
+	if (error)
+		goto mnt_drop_write_and_out;
+
+	/* path may have changed after copyup */
+	inode = path.dentry->d_inode;
 	error = get_write_access(inode);
 	if (error)
 		goto mnt_drop_write_and_out;
@@ -119,9 +149,11 @@ static long do_sys_truncate(const char __user *pathname, loff_t length)
 put_write_and_out:
 	put_write_access(inode);
 mnt_drop_write_and_out:
-	mnt_drop_write(path.mnt);
+	mnt_drop_write(mnt);
 dput_and_out:
 	path_put(&path);
+	path_put(&nd.path);
+	putname(tmp);
 out:
 	return error;
 }

