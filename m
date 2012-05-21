Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159Ab2EUPdc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 11:33:32 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60065 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908Ab2EUPaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 11:30:23 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org, mszeredi@suse.cz
Subject: [PATCH 06/16] vfs: do_last(): make ENOENT exit RCU safe
Date: Mon, 21 May 2012 17:30:10 +0200
Message-Id: <1337614220-6174-7-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1337614220-6174-1-git-send-email-miklos@szeredi.hu>
References: <1337614220-6174-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

This will allow this code to be used in RCU mode.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 67bddd6..3f4b286 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2363,8 +2363,10 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 	BUG_ON(nd->flags & LOOKUP_RCU);
 	inode = path->dentry->d_inode;
 	error = -ENOENT;
-	if (!inode)
-		goto exit_dput;
+	if (!inode) {
+		path_to_nameidata(path, nd);
+		goto exit;
+	}
 
 	if (should_follow_link(inode, !symlink_ok)) {
 		if (nd->flags & LOOKUP_RCU) {
-- 
1.7.7

