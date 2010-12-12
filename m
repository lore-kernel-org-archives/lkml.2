Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab0LMAOa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:14:30 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36042 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904Ab0LLXqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:30 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: roberto.sassu@polito.it, kirkland@canonical.com, jmorris@namei.org,
        tyhicks@linux.vnet.ibm.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [89/223] ecryptfs: call vfs_setxattr() in ecryptfs_setxattr()
Message-Id: <20101212234628.D9CD0B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:28 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/ecryptfs/inode.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: linux/fs/ecryptfs/inode.c
===================================================================
--- linux.orig/fs/ecryptfs/inode.c
+++ linux/fs/ecryptfs/inode.c
@@ -32,6 +32,7 @@
 #include <linux/crypto.h>
 #include <linux/fs_stack.h>
 #include <linux/slab.h>
+#include <linux/xattr.h>
 #include <asm/unaligned.h>
 #include "ecryptfs_kernel.h"
 
@@ -1020,10 +1021,8 @@ ecryptfs_setxattr(struct dentry *dentry,
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
