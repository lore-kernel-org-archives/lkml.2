Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab2J0MeS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 08:34:18 -0400
Received: from mail-ye0-f174.google.com ([209.85.213.174]:56913 "EHLO
	mail-ye0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041Ab2J0MeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 08:34:13 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, michael.brantley@deshaw.com,
        hch@infradead.org, miklos@szeredi.hu, pstaubach@exagrid.com
Subject: [PATCH v8 12/32] vfs: fix renameat to retry on ESTALE errors
Date: Sat, 27 Oct 2012 08:33:19 -0400
Message-Id: <1351341219-17837-13-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351341219-17837-1-git-send-email-jlayton@redhat.com>
References: <1351341219-17837-1-git-send-email-jlayton@redhat.com>
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
index 467b9f1..27bff9b 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3849,15 +3849,18 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
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
@@ -3929,11 +3932,17 @@ exit3:
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

