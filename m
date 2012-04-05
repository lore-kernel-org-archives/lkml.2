Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab2DEO77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 10:59:59 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:49884 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901Ab2DEO7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 10:59:04 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, mszeredi@suse.cz
Subject: [PATCH 17/34] vfs: do_last(): inline lookup_slow()
Date: Thu,  5 Apr 2012 16:58:43 +0200
Message-Id: <1333637940-31884-18-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1333637940-31884-1-git-send-email-miklos@szeredi.hu>
References: <1333637940-31884-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Copy lookup_slow() into do_last().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index c8a8b28..47bff57 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2276,9 +2276,22 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 			if (error < 0)
 				goto exit;
 
-			error = lookup_slow(nd, &nd->last, path);
-			if (error < 0)
+			BUG_ON(nd->inode != dir->d_inode);
+
+			mutex_lock(&dir->d_inode->i_mutex);
+			dentry = __lookup_hash(&nd->last, dir, nd);
+			mutex_unlock(&dir->d_inode->i_mutex);
+			error = PTR_ERR(dentry);
+			if (IS_ERR(dentry))
 				goto exit;
+			path->mnt = nd->path.mnt;
+			path->dentry = dentry;
+			error = follow_managed(path, nd->flags);
+			if (unlikely(error < 0))
+				goto exit_dput;
+
+			if (error)
+				nd->flags |= LOOKUP_JUMPED;
 
 			inode = path->dentry->d_inode;
 		}
-- 
1.7.7

