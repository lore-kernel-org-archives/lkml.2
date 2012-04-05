Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab2DEO7h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 10:59:37 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62866 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669Ab2DEO6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 10:58:46 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, mszeredi@suse.cz
Subject: [PATCH 06/34] vfs: do_last(): make ENOENT exit RCU safe
Date: Thu,  5 Apr 2012 16:58:32 +0200
Message-Id: <1333637940-31884-7-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1333637940-31884-1-git-send-email-miklos@szeredi.hu>
References: <1333637940-31884-1-git-send-email-miklos@szeredi.hu>
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
index a94b0d4..709e992 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2391,8 +2391,10 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 
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

