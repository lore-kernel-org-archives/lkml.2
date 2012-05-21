Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab2EUPap (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 11:30:45 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43253 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441Ab2EUPal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 11:30:41 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org, mszeredi@suse.cz
Subject: [PATCH 13/16] vfs: nameidata_to_filp(): inline __dentry_open()
Date: Mon, 21 May 2012 17:30:17 +0200
Message-Id: <1337614220-6174-14-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1337614220-6174-1-git-send-email-miklos@szeredi.hu>
References: <1337614220-6174-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Copy __dentry_open() into nameidata_to_filp().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/open.c |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index e1448cd..161c15f 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -818,9 +818,25 @@ struct file *nameidata_to_filp(struct nameidata *nd)
 
 	/* Has the filesystem initialised the file for us? */
 	if (filp->f_path.dentry == NULL) {
+		struct file *res;
+
 		path_get(&nd->path);
-		filp = __dentry_open(nd->path.dentry, nd->path.mnt, filp,
-				     NULL, cred);
+		res = do_dentry_open(nd->path.dentry, nd->path.mnt,
+				     filp, NULL, cred);
+		if (!IS_ERR(res)) {
+			int error;
+
+			BUG_ON(res != filp);
+
+			error = open_check_o_direct(filp);
+			if (error) {
+				fput(filp);
+				filp = ERR_PTR(error);
+			}
+		} else {
+			put_filp(filp);
+			filp = res;
+		}
 	}
 	return filp;
 }
-- 
1.7.7

