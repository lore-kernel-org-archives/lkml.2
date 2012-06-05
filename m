Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761929Ab2FENLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 09:11:46 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48161 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934138Ab2FENL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 09:11:28 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org, dhowells@redhat.com,
        mszeredi@suse.cz
Subject: [PATCH 21/21] vfs: move O_DIRECT check to common code
Date: Tue,  5 Jun 2012 15:10:32 +0200
Message-Id: <1338901832-14049-22-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1338901832-14049-1-git-send-email-miklos@szeredi.hu>
References: <1338901832-14049-1-git-send-email-miklos@szeredi.hu>
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
index d5dd6fb..62514ae 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2296,22 +2296,15 @@ static struct file *atomic_open(struct nameidata *nd, struct dentry *dentry,
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
@@ -2610,10 +2603,10 @@ finish_open_created:
 			goto stale_open;
 		goto out;
 	}
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

