Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405Ab1FFXTq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 19:19:46 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:33984 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798Ab1FFXTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 19:19:45 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@ZenIV.linux.org.uk, mjt@tls.msk.ru
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH -v3] vfs: make unlink() and rmdir() return ENOENT in preference to EROFS
Date: Mon,  6 Jun 2011 19:19:40 -0400
Message-Id: <1307402380-14166-1-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.4.1.22.gec8e1.dirty
In-Reply-To: <4DED5926.80504@msgid.tls.msk.ru>
References: <4DED5926.80504@msgid.tls.msk.ru>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If user space attempts to remove a non-existent file or directory, and
the file system is mounted read-only, return ENOENT instead of EROFS.
Either error code is arguably valid/correct, but ENOENT is a more
specific error message.

Reported-by: Michael Tokarev <mjt@tls.msk.ru>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/namei.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 1ab641f..647ca6e 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2623,6 +2623,10 @@ static long do_rmdir(int dfd, const char __user *pathname)
 	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
 		goto exit2;
+	if (!dentry->d_inode) {
+		error = -ENOENT;
+		goto exit3;
+	}
 	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		goto exit3;
@@ -2708,11 +2712,10 @@ static long do_unlinkat(int dfd, const char __user *pathname)
 	error = PTR_ERR(dentry);
 	if (!IS_ERR(dentry)) {
 		/* Why not before? Because we want correct error value */
-		if (nd.last.name[nd.last.len])
-			goto slashes;
 		inode = dentry->d_inode;
-		if (inode)
-			ihold(inode);
+		if (nd.last.name[nd.last.len] || !inode)
+			goto slashes;
+		ihold(inode);
 		error = mnt_want_write(nd.path.mnt);
 		if (error)
 			goto exit2;
-- 
1.7.4.1.22.gec8e1.dirty

