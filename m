Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab2BUTyp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 14:54:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754053Ab2BUTyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:54:41 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 63/73] union-mount: Implement union-aware writable open() [ver
 #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 18:05:24 +0000
Message-ID: <20120221180524.25235.44633.stgit@warthog.procyon.org.uk>
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

Copy up a file when opened with write permissions.  Does not copy up
the file data when O_TRUNC is specified.

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/namei.c |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index dad7bef..4fe8f4c 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2521,6 +2521,24 @@ static inline int open_to_namei_flags(int flag)
 	return flag;
 }
 
+static int open_union_copyup(struct nameidata *nd, struct path *path,
+			     int open_flag)
+{
+	struct vfsmount *oldmnt = path->mnt;
+	int error;
+
+	if (open_flag & O_TRUNC)
+		error = union_copyup_len(nd, path, 0);
+	else
+		error = union_copyup(nd, path);
+	if (error)
+		return error;
+	if (oldmnt != path->mnt)
+		mntput(nd->path.mnt);
+
+	return error;
+}
+
 /*
  * Handle the last step of open()
  */
@@ -2586,6 +2604,13 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 			if (!nd->inode->i_op->lookup)
 				goto exit;
 		}
+
+		if (acc_mode & MAY_WRITE) {
+			error = open_union_copyup(nd, &nd->path, open_flag);
+			if (error)
+				goto exit;
+		}
+
 		audit_inode(pathname, nd->path.dentry);
 		goto ok;
 	}
@@ -2669,6 +2694,12 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 	if (path->dentry->d_inode->i_op->follow_link)
 		return NULL;
 
+	if (acc_mode & MAY_WRITE) {
+		error = open_union_copyup(nd, path, open_flag);
+		if (error)
+			goto exit_dput;
+	}
+
 	path_to_nameidata(path, nd);
 	nd->inode = path->dentry->d_inode;
 	/* Why this, you ask?  _Now_ we might have grown LOOKUP_JUMPED... */

