Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab0ITSEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 14:04:53 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34550 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab0ITSEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 14:04:51 -0400
Message-Id: <20100920180446.104998543@szeredi.hu>
References: <20100920180404.939991832@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Mon, 20 Sep 2010 20:04:09 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: vaurora@redhat.com, neilb@suse.de, viro@zeniv.linux.org.uk,
        stable@kernel.org
Subject: [PATCH 5/7 v3] vfs: fix possible use after free in finish_open()
Content-Disposition: inline; filename=vfs-open-truncate-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

If open(O_TRUNC) is called and the actual open fails, then nd->path
will be released by nameidata_to_filp().  If this races with an
unmount then mnt_drop_write() can Oops.

Fix by acquiring a ref to nd->path and releasing after
mnt_drop_write().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: stable@kernel.org
---
 fs/namei.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2010-09-20 13:32:35.000000000 +0200
+++ linux-2.6/fs/namei.c	2010-09-20 13:33:14.000000000 +0200
@@ -1559,6 +1559,11 @@ static struct file *finish_open(struct n
 			mnt_drop_write(nd->path.mnt);
 		goto exit;
 	}
+	if (will_truncate) {
+		/* nameidata_to_filp() puts nd->path! */
+		path_get(&nd->path);
+	}
+
 	filp = nameidata_to_filp(nd);
 	if (!IS_ERR(filp)) {
 		error = ima_file_check(filp, acc_mode);
@@ -1581,8 +1586,10 @@ static struct file *finish_open(struct n
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

-- 
