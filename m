Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab2BQPLb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 10:11:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57850 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab2BQPLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 10:11:30 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Andy Whitcroft <apw@canonical.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mszeredi@suse.cz
Subject: [PATCH 1/1] overlayfs: apply device cgroup and security permissions to overlay files
Date: Fri, 17 Feb 2012 15:10:51 +0000
Message-Id: <1329491451-14960-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When checking permissions on an overlayfs inode we do not take into
account either device cgroup restrictions nor security permissions.
This allows a user to mount an overlayfs layer over a restricted device
directory and by pass those permissions to open otherwise restricted
files.

Use devcgroup_inode_permission() and security_inode_permission() against
the underlying inodes when calculating ovl_permission().

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 fs/overlayfs/inode.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

	Not sure whether you saw this the first time round.  This was shown
	up in testing with containers, specifically with device cgroups.
	It seems we should be re-checking here else users can simply
	bypass the containers device permissions by mounting an overlayfs
	fs over them.

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index ba1a777..1145a76 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -10,6 +10,8 @@
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/xattr.h>
+#include <linux/device_cgroup.h>
+#include <linux/security.h>
 #include "overlayfs.h"
 
 int ovl_setattr(struct dentry *dentry, struct iattr *attr)
@@ -118,6 +120,11 @@ int ovl_permission(struct inode *inode, int mask)
 		err = realinode->i_op->permission(realinode, mask);
 	else
 		err = generic_permission(realinode, mask);
+
+	if (!err)
+		err = devcgroup_inode_permission(realinode, mask);
+	if (!err)
+		err = security_inode_permission(realinode, mask);
 out_dput:
 	dput(alias);
 	return err;
-- 
1.7.9

