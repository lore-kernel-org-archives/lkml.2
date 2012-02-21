Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab2BUR71 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 12:59:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532Ab2BUR7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 12:59:24 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 14/73] whiteout: Allow removal of a directory with whiteouts
 [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, Jan Blunck <jblunck@suse.de>,
        Valerie Aurora <vaurora@redhat.com>,
        David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 17:59:14 +0000
Message-ID: <20120221175914.25235.70382.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

do_whiteout() allows removal of a directory when it has whiteouts but
is logically empty.

XXX - This patch abuses readdir() to check if the union directory is
logically empty - that is, all the entries are whiteouts (or "." or
"..").  Currently, we have no clean VFS interface to ask the lower
file system if a directory is empty.

Fixes:
 - Add ->is_directory_empty() op
 - Add is_directory_empty flag to dentry (ugly dcache populate)
 - Ask underlying fs to remove it and look for an error return
 - (your idea here)

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/namei.c |   85 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 85 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 3d396fd..991a32c 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -33,6 +33,7 @@
 #include <linux/device_cgroup.h>
 #include <linux/fs_struct.h>
 #include <linux/posix_acl.h>
+#include <linux/init_task.h>
 #include <asm/uaccess.h>
 
 #include "internal.h"
@@ -2735,6 +2736,90 @@ error_unlock:
 }
 
 /*
+ * XXX - We are abusing readdir to check if a union directory is
+ * logically empty.
+ */
+static int filldir_is_empty(void *__buf, const char *name, int namelen,
+			    loff_t offset, u64 ino, unsigned int d_type)
+{
+	int *is_empty = __buf;
+
+	switch (namelen) {
+	case 2:
+		if (name[1] != '.')
+			break;
+	case 1:
+		if (name[0] != '.')
+			break;
+		return 0;
+	}
+
+	if (d_type == DT_WHT)
+		return 0;
+
+	*is_empty = 0;
+	return 1; /* no point scanning further */
+}
+
+static int directory_is_empty(struct path *path)
+{
+	struct file *file;
+	int err;
+	int is_empty = 1;
+
+	BUG_ON(!S_ISDIR(path->dentry->d_inode->i_mode));
+
+	/* references for the file pointer */
+	path_get(path);
+
+	file = dentry_open(path->dentry, path->mnt, O_RDONLY, &init_cred);
+	if (IS_ERR(file))
+		return 0;
+
+	err = vfs_readdir(file, filldir_is_empty, &is_empty);
+
+	fput(file);
+	return is_empty;
+}
+
+static int do_whiteout(struct nameidata *nd, struct path *path, int isdir)
+{
+	struct path safe = nd->path;
+	struct dentry *dentry = path->dentry;
+	int err;
+
+	path_get(&safe);
+
+	err = may_delete(nd->path.dentry->d_inode, dentry, isdir);
+	if (err)
+		goto out;
+
+	err = -ENOTEMPTY;
+	if (isdir && !directory_is_empty(path))
+		goto out;
+
+	if (nd->path.dentry != dentry->d_parent) {
+		dentry = __lookup_hash(&path->dentry->d_name, nd->path.dentry,
+				       nd);
+		err = PTR_ERR(dentry);
+		if (IS_ERR(dentry))
+			goto out;
+
+		dput(path->dentry);
+		if (path->mnt != safe.mnt)
+			mntput(path->mnt);
+		path->mnt = nd->path.mnt;
+		path->dentry = dentry;
+	}
+
+	err = vfs_whiteout(nd->path.dentry->d_inode, dentry, isdir);
+
+out:
+	path_put(&safe);
+	return err;
+}
+
+/*
  * The dentry_unhash() helper will try to drop the dentry early: we
  * should have a usage count of 2 if we're the only user of this
  * dentry, and if that is true (possibly after pruning the dcache),

