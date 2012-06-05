Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761830Ab2FENKg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 09:10:36 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46637 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761722Ab2FENKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 09:10:31 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org, dhowells@redhat.com,
        mszeredi@suse.cz
Subject: [PATCH 05/21] vfs: lookup_open(): expand lookup_hash()
Date: Tue,  5 Jun 2012 15:10:16 +0200
Message-Id: <1338901832-14049-6-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1338901832-14049-1-git-send-email-miklos@szeredi.hu>
References: <1338901832-14049-1-git-send-email-miklos@szeredi.hu>
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
index 1153476..cd20ddc 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2200,14 +2200,24 @@ static struct file *lookup_open(struct nameidata *nd, struct path *path,
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

