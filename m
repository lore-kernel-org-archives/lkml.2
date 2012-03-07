Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030277Ab2CGVXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:23:40 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46985 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418Ab2CGVXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:23:31 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, Trond.Myklebust@netapp.com, sfrench@samba.org,
        sage@newdream.net, ericvh@gmail.com, mszeredi@suse.cz
Subject: [PATCH 20/25] vfs: move O_DIRECT check to common code
Date: Wed,  7 Mar 2012 22:22:37 +0100
Message-Id: <1331155362-11132-21-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Perform open_check_o_direct() in a common place in do_last after opening the
file.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c |   30 +++++++++---------------------
 1 files changed, 9 insertions(+), 21 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index fadc95c..4207e4f 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2055,19 +2055,13 @@ static struct file *atomic_create(struct inode *dir, struct dentry *dentry,
 	 * here.
 	 */
 	error = may_open(&filp->f_path, MAY_OPEN, open_flag);
-	if (error)
-		goto out_fput;
-
-	error = open_check_o_direct(filp);
-	if (error)
-		goto out_fput;
+	if (error) {
+		fput(filp);
+		return ERR_PTR(error);
+	}
 
 out:
 	return filp;
-
-out_fput:
-	fput(filp);
-	return ERR_PTR(error);
 }
 
 static struct file *create_open(struct inode *dir, struct dentry *dentry,
@@ -2249,22 +2243,16 @@ static struct file *atomic_open(struct nameidata *nd, struct dentry *dentry,
 		 * permission here.
 		 */
 		error = may_open(&filp->f_path, acc_mode, open_flag);
-		if (error)
-			goto out_fput;
-
-		error = open_check_o_direct(filp);
-		if (error)
-			goto out_fput;
+		if (error) {
+			fput(filp);
+			return ERR_PTR(error);
+		}
 	}
 	*create_error = 0;
 
 out:
 	return filp;
 
-out_fput:
-	fput(filp);
-	return ERR_PTR(error);
-
 look_up:
 	return NULL;
 }
@@ -2588,10 +2576,10 @@ common:
 	}
 	if (IS_ERR(filp))
 		goto out;
+opened:
 	error = open_check_o_direct(filp);
 	if (error)
 		goto exit_fput;
-opened:
 	error = ima_file_check(filp, op->acc_mode);
 	if (error)
 		goto exit_fput;
-- 
1.7.7

