Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab2BUSTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 13:19:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754939Ab2BUSRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 13:17:38 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 59/73] unionmount: Override creds when copying up a file to
 correctly set ownership [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 18:04:54 +0000
Message-ID: <20120221180454.25235.51523.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Override the current creds when creating a file for copy up purposes so that
the ownership of that file is set correctly.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/union.c |   22 +++++++++++++++++++---
 1 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/fs/union.c b/fs/union.c
index b8ee42d..264da49 100644
--- a/fs/union.c
+++ b/fs/union.c
@@ -556,28 +556,44 @@ int union_copyup_file(struct nameidata *nd, struct path *lower,
 		      struct dentry *dentry, size_t len)
 {
 	struct path *parent = &nd->path;
+	const struct cred *saved_cred;
+	struct cred *override_cred;
 	int error;
 
 	BUG_ON(!mutex_is_locked(&parent->dentry->d_inode->i_mutex));
 
+	override_cred = prepare_kernel_cred(NULL);
+	if (!override_cred)
+		return -ENOMEM;
+
+	override_cred->fsuid = lower->dentry->d_inode->i_uid;
+	override_cred->fsgid = lower->dentry->d_inode->i_gid;
+
+	saved_cred = override_creds(override_cred);
+
 	if (S_ISREG(lower->dentry->d_inode->i_mode)) {
 		error = union_create_file(nd, lower, dentry);
 		if (error)
-			return error;
+			goto out;
 		error = union_copyup_data(lower, parent->mnt, dentry, len);
 	} else if (S_ISLNK(lower->dentry->d_inode->i_mode)) {
-		return union_create_symlink(nd, lower, dentry);
+		error = union_create_symlink(nd, lower, dentry);
+		goto out;
 	} else {
 		/* Don't currently support copyup of special files, though in
 		 * theory there's no reason we couldn't at least copy up
 		 * blockdev, chrdev and FIFO files
 		 */
-		return -EXDEV;
+		error = -EXDEV;
+		goto out;
 	}
 	if (error)
 		/* Most likely error: ENOSPC */
 		vfs_unlink(parent->dentry->d_inode, dentry);
 
+out:
+	revert_creds(saved_cred);
+	put_cred(override_cred);
 	return error;
 }
 

