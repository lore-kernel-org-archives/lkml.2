Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab2DEPEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 11:04:53 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38928 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab2DEO7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 10:59:41 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, mszeredi@suse.cz
Subject: [PATCH 34/34] vfs: move O_DIRECT check to common code
Date: Thu,  5 Apr 2012 16:59:00 +0200
Message-Id: <1333637940-31884-35-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1333637940-31884-1-git-send-email-miklos@szeredi.hu>
References: <1333637940-31884-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Perform open_check_o_direct() in a common place in do_last after opening the
file.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c |   17 +++++------------
 1 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index ed0b72b..07fae42 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2327,22 +2327,15 @@ static struct file *atomic_open(struct nameidata *nd, struct dentry *dentry,
 	 * here.
 	 */
 	error = may_open(&filp->f_path, acc_mode, open_flag);
-	if (error)
-		goto out_fput;
-
-	error = open_check_o_direct(filp);
-	if (error)
-		goto out_fput;
+	if (error) {
+		fput(filp);
+		filp = ERR_PTR(error);
+	}
 
 out:
 	dput(dentry);
 	return filp;
 
-out_fput:
-	fput(filp);
-	filp = ERR_PTR(error);
-	goto out;
-
 no_open:
 	if (need_lookup) {
 		dentry = lookup_real(dir, dentry, nd);
@@ -2650,10 +2643,10 @@ common:
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

