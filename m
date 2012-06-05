Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760836Ab2FENKM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 09:10:12 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48161 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760749Ab2FENKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 09:10:09 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org, dhowells@redhat.com,
        mszeredi@suse.cz
Subject: [PATCH 01/21] vfs: do_last(): inline lookup_slow()
Date: Tue,  5 Jun 2012 15:10:12 +0200
Message-Id: <1338901832-14049-2-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1338901832-14049-1-git-send-email-miklos@szeredi.hu>
References: <1338901832-14049-1-git-send-email-miklos@szeredi.hu>
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
index 7d69419..d6e8c55 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2245,9 +2245,22 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
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

