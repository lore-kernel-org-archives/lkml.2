Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435Ab2DYMoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 08:44:16 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45860 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325Ab2DYMoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 08:44:12 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org, mszeredi@suse.cz
Subject: [PATCH 06/16] vfs: do_last(): make ENOENT exit RCU safe
Date: Wed, 25 Apr 2012 14:44:07 +0200
Message-Id: <1335357857-16416-7-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1335357857-16416-1-git-send-email-miklos@szeredi.hu>
References: <1335357857-16416-1-git-send-email-miklos@szeredi.hu>
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
index a3a0fa1..d9b0eba 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2362,8 +2362,10 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 
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

