Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064Ab2KEPck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 10:32:40 -0500
Received: from mail-gh0-f174.google.com ([209.85.160.174]:65208 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932914Ab2KEPWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 10:22:43 -0500
From: Jeff Layton <jlayton@redhat.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, michael.brantley@deshaw.com,
        hch@infradead.org, miklos@szeredi.hu, pstaubach@exagrid.com
Subject: [PATCH v9 12/34] vfs: fix renameat to retry on ESTALE errors
Date: Mon,  5 Nov 2012 10:21:51 -0500
Message-Id: <1352128933-28526-13-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352128933-28526-1-git-send-email-jlayton@redhat.com>
References: <1352128933-28526-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...as always, rename is the messiest of the bunch. We have to track
whether to retry or not via a separate flag since the error handling
is already quite complex.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index fb5a084..39adf1b 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3856,15 +3856,18 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 	struct nameidata oldnd, newnd;
 	struct filename *from;
 	struct filename *to;
+	unsigned int try = 0;
+	bool should_retry = false;
 	int error;
 
-	from = user_path_parent(olddfd, oldname, &oldnd, 0);
+retry:
+	from = user_path_parent(olddfd, oldname, &oldnd, try);
 	if (IS_ERR(from)) {
 		error = PTR_ERR(from);
 		goto exit;
 	}
 
-	to = user_path_parent(newdfd, newname, &newnd, 0);
+	to = user_path_parent(newdfd, newname, &newnd, try);
 	if (IS_ERR(to)) {
 		error = PTR_ERR(to);
 		goto exit1;
@@ -3936,11 +3939,17 @@ exit3:
 	unlock_rename(new_dir, old_dir);
 	mnt_drop_write(oldnd.path.mnt);
 exit2:
+	if (retry_estale(error, try++))
+		should_retry = true;
 	path_put(&newnd.path);
 	putname(to);
 exit1:
 	path_put(&oldnd.path);
 	putname(from);
+	if (should_retry) {
+		should_retry = false;
+		goto retry;
+	}
 exit:
 	return error;
 }
-- 
1.7.11.7

