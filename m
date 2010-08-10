Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425Ab0HJJoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 05:44:17 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:47709 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757386Ab0HJJn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 05:43:59 -0400
Message-Id: <20100810094328.533589457@szeredi.hu>
References: <20100810094134.596235651@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Tue, 10 Aug 2010 11:41:38 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] vfs: __d_path: dont prepend the name of the root dentry
Content-Disposition: inline; filename=vfs-dont-prepend-name-of-root-dentry.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

In the old times pseudo-filesystems set the name of theroot dentry to
some prefix like "pipe:" and the name of the child dentry to "[123]"
and relied on a hack in __d_path() to replace the preceding slash with
the root's name to get "pipe:[123]".

Then the d_dname() dentry operation was introduced which solved the
same problem without having to pre-fill the name in each dentry.

Currently the following pseudo filesystems exist in the kernel:

perfmon
mtd
anon_inode
bdev
pipe
socket

Of these only perfmon, anon_inode, pipe and socket create
sub-dentries, all of which have now been switched to using d_dname().

bdev and mtd only create inodes.

This means that now the hack to overwrite the slash can be removed, so
for unreachable paths (e.g. within a detached mount) the path string
won't be polluted with garbage.  For these cases a subsequent patch
will add a prefix, indicating that the path is unreachable.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/dcache.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2010-07-06 18:08:06.000000000 +0200
+++ linux-2.6/fs/dcache.c	2010-07-06 18:08:12.000000000 +0200
@@ -1968,9 +1968,15 @@ out:
 	return retval;
 
 global_root:
-	retval += 1;	/* hit the slash */
-	if (prepend_name(&retval, &buflen, &dentry->d_name) != 0)
-		goto Elong;
+	/*
+	 * Filesystems needing to implement special "root names"
+	 * should do so with ->d_dname()
+	 */
+	if (IS_ROOT(dentry) &&
+	    (dentry->d_name.len != 1 || dentry->d_name.name[0] != '/')) {
+		WARN(1, "Root dentry has weird name <%.*s>\n",
+		     (int) dentry->d_name.len, dentry->d_name.name);
+	}
 	root->mnt = vfsmnt;
 	root->dentry = dentry;
 	goto out;

-- 
