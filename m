Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab0JYNRB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 09:17:01 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:58675 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab0JYNRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 09:17:00 -0400
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] vfs: fix possible use after free in finish_open()
Message-Id: <E1PAMux-0002CG-8a@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 25 Oct 2010 15:16:51 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

In finish_open() nd->path is used after nameidata_to_filp() already
released it.  Fix by acquiring a ref to nd->path and releasing after
the last use.

Similar fix needed in do_last().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: stable@kernel.org
---
 fs/namei.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2010-10-25 15:07:17.000000000 +0200
+++ linux-2.6/fs/namei.c	2010-10-25 15:07:32.000000000 +0200
@@ -1549,11 +1549,16 @@ static struct file *finish_open(struct n
 		error = mnt_want_write(nd->path.mnt);
 		if (error)
 			goto exit;
+
+		/* nameidata_to_filp() puts nd->path */
+		path_get(&nd->path);
 	}
 	error = may_open(&nd->path, acc_mode, open_flag);
 	if (error) {
-		if (will_truncate)
+		if (will_truncate) {
 			mnt_drop_write(nd->path.mnt);
+			path_put(&nd->path);
+		}
 		goto exit;
 	}
 	filp = nameidata_to_filp(nd);
@@ -1578,8 +1583,10 @@ static struct file *finish_open(struct n
 	 * because the filp has had a write taken
 	 * on its behalf.
 	 */
-	if (will_truncate)
+	if (will_truncate) {
 		mnt_drop_write(nd->path.mnt);
+		path_put(&nd->path);
+	}
 	return filp;
 
 exit:
@@ -1679,8 +1686,12 @@ static struct file *do_last(struct namei
 			mnt_drop_write(nd->path.mnt);
 			goto exit;
 		}
+		/* nameidata_to_filp() puts nd->path */
+		mntget(nd->path.mnt);
 		filp = nameidata_to_filp(nd);
 		mnt_drop_write(nd->path.mnt);
+		mntput(nd->path.mnt);
+		path_put(&nd->path);
 		if (!IS_ERR(filp)) {
 			error = ima_file_check(filp, acc_mode);
 			if (error) {
