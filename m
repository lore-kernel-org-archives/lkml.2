Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414Ab0HJJoJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 05:44:09 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:47687 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756556Ab0HJJnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 05:43:33 -0400
Message-Id: <20100810094326.557856708@szeredi.hu>
References: <20100810094134.596235651@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Tue, 10 Aug 2010 11:41:37 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 3/7] ia64: perfmon: add d_dname method
Content-Disposition: inline; filename=vfs-add-d_dname-method.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Switch ia64/perfmon to using the d_dname() instead of relying on
__d_path() to prepend the name of the root dentry to the path.

CC: Tony Luck <tony.luck@intel.com>
CC: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 arch/ia64/kernel/perfmon.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

Index: linux-2.6/arch/ia64/kernel/perfmon.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/perfmon.c	2010-07-06 17:59:04.000000000 +0200
+++ linux-2.6/arch/ia64/kernel/perfmon.c	2010-07-06 18:08:09.000000000 +0200
@@ -2191,8 +2191,15 @@ pfmfs_delete_dentry(struct dentry *dentr
 	return 1;
 }
 
+static char *pfmfs_dname(struct dentry *dentry, char *buffer, int buflen)
+{
+	return dynamic_dname(dentry, buffer, buflen, "pfm:[%lu]",
+			     dentry->d_inode->i_ino);
+}
+
 static const struct dentry_operations pfmfs_dentry_operations = {
 	.d_delete = pfmfs_delete_dentry,
+	.d_dname = pfmfs_dname,
 };
 
 
@@ -2202,8 +2209,7 @@ pfm_alloc_file(pfm_context_t *ctx)
 	struct file *file;
 	struct inode *inode;
 	struct path path;
-	char name[32];
-	struct qstr this;
+	struct qstr this = { .name = "" };
 
 	/*
 	 * allocate a new inode
@@ -2218,11 +2224,6 @@ pfm_alloc_file(pfm_context_t *ctx)
 	inode->i_uid  = current_fsuid();
 	inode->i_gid  = current_fsgid();
 
-	sprintf(name, "[%lu]", inode->i_ino);
-	this.name = name;
-	this.len  = strlen(name);
-	this.hash = inode->i_ino;
-
 	/*
 	 * allocate a new dcache entry
 	 */

-- 
