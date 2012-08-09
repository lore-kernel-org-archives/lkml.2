Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031210Ab2HIPr2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 11:47:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39267 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030969Ab2HIPrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 11:47:25 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Andy Whitcroft <apw@canonical.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mszeredi@suse.cz
Subject: [PATCH] overlayfs: copy up i_uid/i_gid from the underlying inode
Date: Thu,  9 Aug 2012 16:47:21 +0100
Message-Id: <1344527241-2480-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

YAMA et al rely on on i_uid/i_gid to be populated in order to perform
their checks.  While these really cannot be guarenteed as the underlying
filesystem may not even have the concept, they are expected to be filled
when possible.  To quote Al Viro:

    "Ideally, yes, we'd want to have ->i_uid used only by fs-specific
     code and helpers used by that fs (including those that are
     implicit defaults). [...]   In practice we have enough places
     where uid/gid is used directly to make setting them practically
     a requirement - places like /proc/<pid>/ can get away with
     not doing that, but only because shitloads of syscalls are
     not allowed on those anyway, permissions or no permissions.
     In anything general-purpose you really need to set it."

Copy up the underlying filesystem information into the overlayfs inode
when we create it.

BugLink: http://bugs.launchpad.net/bugs/944386
Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 fs/overlayfs/dir.c       |    2 ++
 fs/overlayfs/overlayfs.h |    6 ++++++
 fs/overlayfs/super.c     |    1 +
 3 files changed, 9 insertions(+)

	After a long hiatus I have had time to look into the issues
	highlighted by the i_uid/i_gid requirements from the VFS.
	I have identified a number of places which definatly did need
	the ids copying up and those are reflected in the patch below.
	I am not 100% convinced I have hit all of the places this might
	be needed but it cirtainly helps with the issues I was seeing
	with link and YAMA (which given YAMA is now gaining the link
	constraints in mainline in v3.6 we will see more issues here).
	were seeing and identify the places where

	Please consider for overlayfs.

	-apw

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index c914c97..084e527 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -304,6 +304,7 @@ static int ovl_create_object(struct dentry *dentry, int mode, dev_t rdev,
 		}
 	}
 	ovl_dentry_update(dentry, newdentry);
+	ovl_copyattr(newdentry->d_inode, inode);
 	d_instantiate(dentry, inode);
 	inode = NULL;
 	newdentry = NULL;
@@ -446,6 +447,7 @@ static int ovl_link(struct dentry *old, struct inode *newdir,
 				new->d_fsdata);
 		if (!newinode)
 			goto link_fail;
+		ovl_copyattr(upperdir->d_inode, newinode);
 
 		ovl_dentry_version_inc(new->d_parent);
 		ovl_dentry_update(new, newdentry);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 1dd05f7..3495a55 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -56,6 +56,12 @@ int ovl_removexattr(struct dentry *dentry, const char *name);
 
 struct inode *ovl_new_inode(struct super_block *sb, umode_t mode,
 			    struct ovl_entry *oe);
+static inline void ovl_copyattr(struct inode *from, struct inode *to)
+{
+	to->i_uid = from->i_uid;
+	to->i_gid = from->i_gid;
+}
+
 /* dir.c */
 extern const struct inode_operations ovl_dir_inode_operations;
 
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 1d2d1e2..23cac54 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -343,6 +343,7 @@ static int ovl_do_lookup(struct dentry *dentry)
 				      oe);
 		if (!inode)
 			goto out_dput;
+		ovl_copyattr(realdentry->d_inode, inode);
 	}
 
 	if (upperdentry)
-- 
1.7.9.5
