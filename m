Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab2DEO7z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 10:59:55 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:52339 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873Ab2DEO67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 10:58:59 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, mszeredi@suse.cz
Subject: [PATCH 14/34] vfs: nameidata_to_filp(): don't throw away file on error
Date: Thu,  5 Apr 2012 16:58:40 +0200
Message-Id: <1333637940-31884-15-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1333637940-31884-1-git-send-email-miklos@szeredi.hu>
References: <1333637940-31884-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

If open fails, don't put the file.  This allows it to be reused if open needs to
be retried.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/open.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 161c15f..0510e58 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -814,10 +814,11 @@ struct file *nameidata_to_filp(struct nameidata *nd)
 
 	/* Pick up the filp from the open intent */
 	filp = nd->intent.open.file;
-	nd->intent.open.file = NULL;
 
 	/* Has the filesystem initialised the file for us? */
-	if (filp->f_path.dentry == NULL) {
+	if (filp->f_path.dentry != NULL) {
+		nd->intent.open.file = NULL;
+	} else {
 		struct file *res;
 
 		path_get(&nd->path);
@@ -826,6 +827,7 @@ struct file *nameidata_to_filp(struct nameidata *nd)
 		if (!IS_ERR(res)) {
 			int error;
 
+			nd->intent.open.file = NULL;
 			BUG_ON(res != filp);
 
 			error = open_check_o_direct(filp);
@@ -834,7 +836,7 @@ struct file *nameidata_to_filp(struct nameidata *nd)
 				filp = ERR_PTR(error);
 			}
 		} else {
-			put_filp(filp);
+			/* Allow nd->intent.open.file to be recycled */
 			filp = res;
 		}
 	}
-- 
1.7.7

