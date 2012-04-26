Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159Ab2DZQFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 12:05:55 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38231 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758082Ab2DZQFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 12:05:54 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, miklos@szeredi.hu, hch@infradead.org,
        michael.brantley@deshaw.com
Subject: [PATCH v1 12/12] vfs: fix renameat to retry on ESTALE errors
Date: Thu, 26 Apr 2012 11:57:23 -0400
Message-Id: <1335455843-16089-11-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1335455843-16089-1-git-send-email-jlayton@redhat.com>
References: <1335455843-16089-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...as always, rename is the messiest of the bunch...

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 0d54eb3..1db2814 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3274,12 +3274,15 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 	char *from;
 	char *to;
 	int error;
+	unsigned int try = 0;
+	bool should_retry = false;
 
-	error = user_path_parent(olddfd, oldname, &oldnd, &from, false);
+retry:
+	error = user_path_parent(olddfd, oldname, &oldnd, &from, try);
 	if (error)
 		goto exit;
 
-	error = user_path_parent(newdfd, newname, &newnd, &to, false);
+	error = user_path_parent(newdfd, newname, &newnd, &to, try);
 	if (error)
 		goto exit1;
 
@@ -3348,12 +3351,18 @@ exit4:
 	dput(old_dentry);
 exit3:
 	unlock_rename(new_dir, old_dir);
+	if (retry_estale(error, try++))
+		should_retry = true;
 exit2:
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
1.7.7.6

