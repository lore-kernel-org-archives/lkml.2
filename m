Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab0JZK3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 06:29:00 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50343 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab0JZK27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 06:28:59 -0400
To: viro@ZenIV.linux.org.uk
CC: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-reply-to: <E1PAMux-0002CG-8a@pomaz-ex.szeredi.hu> (message from Miklos
	Szeredi on Mon, 25 Oct 2010 15:16:51 +0200)
Subject: Re: [PATCH] vfs: fix possible use after free in finish_open()
References: <E1PAMux-0002CG-8a@pomaz-ex.szeredi.hu>
Message-Id: <E1PAgls-00049P-QS@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 26 Oct 2010 12:28:48 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, broken patch.  Here's the correct one.

----
Subject: vfs: fix possible use after free in finish_open()

From: Miklos Szeredi <mszeredi@suse.cz>

In finish_open() nd->path is used after nameidata_to_filp() already
released it.  Fix by acquiring a ref to nd->path and releasing after
the last use.

Similar fix needed in do_last().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: stable@kernel.org
---
 fs/namei.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2010-10-26 11:29:16.000000000 +0200
+++ linux-2.6/fs/namei.c	2010-10-26 11:29:20.000000000 +0200
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
@@ -1679,8 +1686,11 @@ static struct file *do_last(struct namei
 			mnt_drop_write(nd->path.mnt);
 			goto exit;
 		}
+		/* nameidata_to_filp() puts nd->path */
+		mntget(nd->path.mnt);
 		filp = nameidata_to_filp(nd);
 		mnt_drop_write(nd->path.mnt);
+		mntput(nd->path.mnt);
 		if (!IS_ERR(filp)) {
 			error = ima_file_check(filp, acc_mode);
 			if (error) {
