Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab0LHBBX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:01:23 -0500
Received: from kroah.org ([198.145.64.141]:48980 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757290Ab0LHBBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:01:19 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:34 2010
Message-Id: <20101208005734.365687430@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:58:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Roberto Sassu <roberto.sassu@polito.it>,
        Dustin Kirkland <kirkland@canonical.com>,
        James Morris <jmorris@namei.org>,
        Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Subject: [130/289] ecryptfs: call vfs_setxattr() in ecryptfs_setxattr()
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Roberto Sassu <roberto.sassu@polito.it>

commit 48b512e6857139393cdfce26348c362b87537018 upstream.

Ecryptfs is a stackable filesystem which relies on lower filesystems the
ability of setting/getting extended attributes.

If there is a security module enabled on the system it updates the
'security' field of inodes according to the owned extended attribute set
with the function vfs_setxattr().  When this function is performed on a
ecryptfs filesystem the 'security' field is not updated for the lower
filesystem since the call security_inode_post_setxattr() is missing for
the lower inode.
Further, the call security_inode_setxattr() is missing for the lower inode,
leading to policy violations in the security module because specific
checks for this hook are not performed (i. e. filesystem
'associate' permission on SELinux is not checked for the lower filesystem).

This patch replaces the call of the setxattr() method of the lower inode
in the function ecryptfs_setxattr() with vfs_setxattr().

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
Cc: Dustin Kirkland <kirkland@canonical.com>
Acked-by: James Morris <jmorris@namei.org>
Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ecryptfs/inode.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -32,6 +32,7 @@
 #include <linux/crypto.h>
 #include <linux/fs_stack.h>
 #include <linux/slab.h>
+#include <linux/xattr.h>
 #include <asm/unaligned.h>
 #include "ecryptfs_kernel.h"
 
@@ -1112,10 +1113,8 @@ ecryptfs_setxattr(struct dentry *dentry,
 		rc = -EOPNOTSUPP;
 		goto out;
 	}
-	mutex_lock(&lower_dentry->d_inode->i_mutex);
-	rc = lower_dentry->d_inode->i_op->setxattr(lower_dentry, name, value,
-						   size, flags);
-	mutex_unlock(&lower_dentry->d_inode->i_mutex);
+
+	rc = vfs_setxattr(lower_dentry, name, value, size, flags);
 out:
 	return rc;
 }


