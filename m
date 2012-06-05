Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934156Ab2FENLa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 09:11:30 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48150 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934125Ab2FENLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 09:11:24 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org, dhowells@redhat.com,
        mszeredi@suse.cz
Subject: [PATCH 20/21] vfs: do_last(): clean up retry
Date: Tue,  5 Jun 2012 15:10:31 +0200
Message-Id: <1338901832-14049-21-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1338901832-14049-1-git-send-email-miklos@szeredi.hu>
References: <1338901832-14049-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Move the lookup retry logic to the bottom of the function to make the normal
case simpler to read.

Reported-by: David Howells <dhowells@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c |   36 +++++++++++++++++++++---------------
 1 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 7d87c63..d5dd6fb 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2605,22 +2605,11 @@ finish_open_created:
 		goto exit;
 	od->mnt = nd->path.mnt;
 	filp = finish_open(od, nd->path.dentry, NULL);
-	if (filp == ERR_PTR(-EOPENSTALE) && save_parent.dentry && !retried) {
-		BUG_ON(save_parent.dentry != dir);
-		path_put(&nd->path);
-		nd->path = save_parent;
-		nd->inode = dir->d_inode;
-		save_parent.mnt = NULL;
-		save_parent.dentry = NULL;
-		if (want_write) {
-			mnt_drop_write(nd->path.mnt);
-			want_write = false;
-		}
-		retried = true;
-		goto retry_lookup;
-	}
-	if (IS_ERR(filp))
+	if (IS_ERR(filp)) {
+		if (filp == ERR_PTR(-EOPENSTALE))
+			goto stale_open;
 		goto out;
+	}
 	error = open_check_o_direct(filp);
 	if (error)
 		goto exit_fput;
@@ -2650,6 +2639,23 @@ exit_fput:
 	fput(filp);
 	goto exit;
 
+stale_open:
+	/* If no saved parent or already retried then can't retry */
+	if (!save_parent.dentry || retried)
+		goto out;
+
+	BUG_ON(save_parent.dentry != dir);
+	path_put(&nd->path);
+	nd->path = save_parent;
+	nd->inode = dir->d_inode;
+	save_parent.mnt = NULL;
+	save_parent.dentry = NULL;
+	if (want_write) {
+		mnt_drop_write(nd->path.mnt);
+		want_write = false;
+	}
+	retried = true;
+	goto retry_lookup;
 }
 
 static struct file *path_openat(int dfd, const char *pathname,
-- 
1.7.7

