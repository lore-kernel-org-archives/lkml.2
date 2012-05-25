Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933251Ab2EYPaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 11:30:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932104Ab2EYP3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 11:29:44 -0400
From: Lukas Czerner <lczerner@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, mbroz@redhat.com,
        Lukas Czerner <lczerner@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 2/2] vfs: Do not copy_tree() unnecessarily while mounting
Date: Fri, 25 May 2012 17:29:36 +0200
Message-Id: <1337959776-16564-2-git-send-email-lczerner@redhat.com>
In-Reply-To: <1337959776-16564-1-git-send-email-lczerner@redhat.com>
References: <1337959776-16564-1-git-send-email-lczerner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While mounting propagate_mnt() would walk through propagation tree
cloning the mount for every every mount the root propagates to.
Even for mounts which parents are not parents of the directory you're
trying to mount to.

Then before the propagate_mnt() is left it will clean the unneeded
cloned mounts (those which parent root is not parent of your new mount
point).

I think this whole operation is unnecessary and can be avoided by
skipping the copy_tree() if the propagated mount root is not
subdirectory of the directory you're mounting to. Such cloned mount
would be cleaned up later anyway.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/pnode.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/pnode.c b/fs/pnode.c
index ab5fa9e..3ebf63d 100644
--- a/fs/pnode.c
+++ b/fs/pnode.c
@@ -237,22 +237,22 @@ int propagate_mnt(struct mount *dest_mnt, struct dentry *dest_dentry,
 
 		source =  get_source(m, prev_dest_mnt, prev_src_mnt, &type);
 
-		if (!(child = copy_tree(source, source->mnt.mnt_root, type))) {
-			ret = -ENOMEM;
-			list_splice(tree_list, tmp_list.prev);
-			goto out;
-		}
-
 		if (is_subdir(dest_dentry, m->mnt.mnt_root)) {
+			if (!(child = copy_tree(source,
+						source->mnt.mnt_root, type))) {
+				ret = -ENOMEM;
+				list_splice(tree_list, tmp_list.prev);
+				goto out;
+			}
+
 			mnt_set_mountpoint(m, dest_dentry, child);
 			list_add_tail(&child->mnt_hash, tree_list);
-		} else {
+		} else
 			/*
 			 * This can happen if the parent mount was bind mounted
 			 * on some subdirectory of a shared/slave mount.
 			 */
-			list_add_tail(&child->mnt_hash, &tmp_list);
-		}
+			continue;
 		prev_dest_mnt = m;
 		prev_src_mnt  = child;
 	}
-- 
1.7.7.6

