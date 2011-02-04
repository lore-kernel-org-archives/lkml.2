Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab1BDP2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 10:28:50 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:27187 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835Ab1BDP2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 10:28:45 -0500
From: Andrey Vagin <avagin@openvz.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Andrey Vagin <avagin@openvz.org>
Subject: [PATCH 1/2] fs: Correctly check d_find_alias() return code in devpts_pty_kill
Date: Fri,  4 Feb 2011 18:28:26 +0300
Message-Id: <1296833307-22549-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

d_find_alias() return NULL in case error, but we expected errno in
devpts_pty_kill.

Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 fs/devpts/inode.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index 8392c8c..530b1f1 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -544,14 +544,12 @@ void devpts_pty_kill(struct tty_struct *tty)
 	mutex_lock(&root->d_inode->i_mutex);
 
 	dentry = d_find_alias(inode);
-	if (IS_ERR(dentry))
+	if (!dentry)
 		goto out;
 
-	if (dentry) {
-		inode->i_nlink--;
-		d_delete(dentry);
-		dput(dentry);	/* d_alloc_name() in devpts_pty_new() */
-	}
+	inode->i_nlink--;
+	d_delete(dentry);
+	dput(dentry);	/* d_alloc_name() in devpts_pty_new() */
 
 	dput(dentry);		/* d_find_alias above */
 out:
-- 
1.7.2.1

