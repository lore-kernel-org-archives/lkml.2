Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab2DEO7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 10:59:53 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37053 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab2DEO65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 10:58:57 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, mszeredi@suse.cz
Subject: [PATCH 13/34] vfs: nameidata_to_filp(): inline __dentry_open()
Date: Thu,  5 Apr 2012 16:58:39 +0200
Message-Id: <1333637940-31884-14-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1333637940-31884-1-git-send-email-miklos@szeredi.hu>
References: <1333637940-31884-1-git-send-email-miklos@szeredi.hu>
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

