Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab2DEPAH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 11:00:07 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60434 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913Ab2DEO7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 10:59:12 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, mszeredi@suse.cz
Subject: [PATCH 21/34] vfs: lookup_open(): expand lookup_hash()
Date: Thu,  5 Apr 2012 16:58:47 +0200
Message-Id: <1333637940-31884-22-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1333637940-31884-1-git-send-email-miklos@szeredi.hu>
References: <1333637940-31884-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Copy __lookup_hash() into lookup_open().  The next patch will insert the atomic
open call just before the real lookup.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 426b544..4815607 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2231,14 +2231,24 @@ static struct file *lookup_open(struct nameidata *nd, struct path *path,
 				int *want_write, bool *created)
 {
 	struct dentry *dir = nd->path.dentry;
+	struct inode *dir_inode = dir->d_inode;
 	struct dentry *dentry;
 	int error;
+	bool need_lookup;
 
 	*created = false;
-	dentry = lookup_hash(nd);
+	dentry = lookup_dcache(&nd->last, dir, nd, &need_lookup);
 	if (IS_ERR(dentry))
 		return ERR_CAST(dentry);
 
+	if (need_lookup) {
+		BUG_ON(dentry->d_inode);
+
+		dentry = lookup_real(dir_inode, dentry, nd);
+		if (IS_ERR(dentry))
+			return ERR_CAST(dentry);
+	}
+
 	/* Negative dentry, just create the file */
 	if (!dentry->d_inode && (op->open_flag & O_CREAT)) {
 		umode_t mode = op->mode;
-- 
1.7.7

