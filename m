Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260Ab2ITS4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 14:56:09 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60371 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755597Ab2ITSzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 14:55:20 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, dhowells@redhat.com, sedat.dilek@googlemail.com,
        hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: [PATCH 13/13] overlayfs: copy up i_uid/i_gid from the underlying inode
Date: Thu, 20 Sep 2012 20:55:30 +0200
Message-Id: <1348167330-30288-14-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1348167330-30288-1-git-send-email-miklos@szeredi.hu>
References: <1348167330-30288-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Whitcroft <apw@canonical.com>

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
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/overlayfs/dir.c       |    2 ++
 fs/overlayfs/inode.c     |    2 ++
 fs/overlayfs/overlayfs.h |    6 ++++++
 fs/overlayfs/super.c     |    1 +
 4 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 1453997..b5e8db2 100644
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
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index f3a534f..e7ab09b 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -31,6 +31,8 @@ int ovl_setattr(struct dentry *dentry, struct iattr *attr)
 
 	mutex_lock(&upperdentry->d_inode->i_mutex);
 	err = notify_change(upperdentry, attr);
+	if (!err)
+		ovl_copyattr(upperdentry->d_inode, dentry->d_inode);
 	mutex_unlock(&upperdentry->d_inode->i_mutex);
 
 	return err;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index fe1241d..1cba38f 100644
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
index 8cfe8df..357d6e8 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -347,6 +347,7 @@ static int ovl_do_lookup(struct dentry *dentry)
 				      oe);
 		if (!inode)
 			goto out_dput;
+		ovl_copyattr(realdentry->d_inode, inode);
 	}
 
 	if (upperdentry)
-- 
1.7.7

