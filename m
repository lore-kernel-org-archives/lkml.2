Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab2EUPbu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 11:31:50 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65374 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab2EUPan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 11:30:43 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org, mszeredi@suse.cz
Subject: [PATCH 14/16] vfs: nameidata_to_filp(): don't throw away file on error
Date: Mon, 21 May 2012 17:30:18 +0200
Message-Id: <1337614220-6174-15-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1337614220-6174-1-git-send-email-miklos@szeredi.hu>
References: <1337614220-6174-1-git-send-email-miklos@szeredi.hu>
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

