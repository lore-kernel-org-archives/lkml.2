Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964775Ab1C3WCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:02:47 -0400
Received: from cobra.newdream.net ([66.33.216.30]:43185 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933282Ab1C3WB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 18:01:58 -0400
From: Sage Weil <sage@newdream.net>
To: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mszeredi@suse.cz,
        Miklos Szeredi <miklos@suse.cz>
Subject: [PATCH 7/7] vfs: fix vfs_rename_dir for FS_RENAME_DOES_D_MOVE filesystems
Date: Wed, 30 Mar 2011 15:09:28 -0700
Message-Id: <1301522968-4382-8-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1301522968-4382-1-git-send-email-sage@newdream.net>
References: <1301522968-4382-1-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <miklos@suse.cz>

vfs_rename_dir() doesn't properly account for filesystems with
FS_RENAME_DOES_D_MOVE.  If new_dentry has a target inode attached, it
unhashes the new_dentry prior to the rename() iop and rehashes it after,
but doesn't account for the possibility that rename() may have swapped
{old,new}_dentry.  For FS_RENAME_DOES_D_MOVE filesystems, it rehashes
new_dentry (now the old renamed-from name, which d_move() expected to go
away), such that a subsequent lookup will find it.  Currently all
FS_RENAME_DOES_D_MOVE filesystems compensate for this by failing in
d_revalidate.

The bug was introduced by: commit 349457ccf2592c14bdf13b6706170ae2e94931b1
"[PATCH] Allow file systems to manually d_move() inside of ->rename()"

Fix by not rehashing the new dentry.  Rehashing used to be needed by
d_move() but isn't anymore.

Reported-by: Sage Weil <sage@newdream.net>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index d376688..98119a5 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3252,8 +3252,6 @@ static int vfs_rename_dir(struct inode *old_dir, struct dentry *old_dentry,
 			dont_mount(new_dentry);
 		}
 		mutex_unlock(&target->i_mutex);
-		if (d_unhashed(new_dentry))
-			d_rehash(new_dentry);
 	}
 	if (!error)
 		if (!(old_dir->i_sb->s_type->fs_flags & FS_RENAME_DOES_D_MOVE))
-- 
1.7.0

