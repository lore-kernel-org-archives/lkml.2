Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083Ab0FDUrd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 16:47:33 -0400
Received: from kroah.org ([198.145.64.141]:44003 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756020Ab0FDUrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 16:47:32 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Nick Piggin <npiggin@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/3] fix setattr error handling in sysfs, configfs
Date: Fri,  4 Jun 2010 13:47:29 -0700
Message-Id: <1275684449-20061-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100604204450.GC19761@kroah.com>
References: <20100604204450.GC19761@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@suse.de>

sysfs and configfs setattr functions have error cases after the generic inode's
attributes have been changed. Fix consistency by changing the generic inode
attributes only when it is guaranteed to succeed.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Acked-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/configfs/inode.c |    9 ++++-----
 fs/sysfs/inode.c    |    6 ++++--
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/configfs/inode.c b/fs/configfs/inode.c
index 4164514..cf78d44 100644
--- a/fs/configfs/inode.c
+++ b/fs/configfs/inode.c
@@ -72,10 +72,6 @@ int configfs_setattr(struct dentry * dentry, struct iattr * iattr)
 	if (!sd)
 		return -EINVAL;
 
-	error = simple_setattr(dentry, iattr);
-	if (error)
-		return error;
-
 	sd_iattr = sd->s_iattr;
 	if (!sd_iattr) {
 		/* setting attributes for the first time, allocate now */
@@ -89,9 +85,12 @@ int configfs_setattr(struct dentry * dentry, struct iattr * iattr)
 		sd_iattr->ia_atime = sd_iattr->ia_mtime = sd_iattr->ia_ctime = CURRENT_TIME;
 		sd->s_iattr = sd_iattr;
 	}
-
 	/* attributes were changed atleast once in past */
 
+	error = simple_setattr(dentry, iattr);
+	if (error)
+		return error;
+
 	if (ia_valid & ATTR_UID)
 		sd_iattr->ia_uid = iattr->ia_uid;
 	if (ia_valid & ATTR_GID)
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index bde1a4c..0835a3b 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -117,11 +117,13 @@ int sysfs_setattr(struct dentry *dentry, struct iattr *iattr)
 	if (error)
 		goto out;
 
+	error = sysfs_sd_setattr(sd, iattr);
+	if (error)
+		goto out;
+
 	/* this ignores size changes */
 	generic_setattr(inode, iattr);
 
-	error = sysfs_sd_setattr(sd, iattr);
-
 out:
 	mutex_unlock(&sysfs_mutex);
 	return error;
-- 
1.7.1

