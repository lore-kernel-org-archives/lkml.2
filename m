Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab1FFU6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 16:58:17 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:55306 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896Ab1FFU6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 16:58:16 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@ZenIV.linux.org.uk, lacombar@gmail.com
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH -v2] vfs: make unlink() return ENOENT in preference to EROFS
Date: Mon,  6 Jun 2011 16:58:13 -0400
Message-Id: <1307393893-28672-1-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.4.1.22.gec8e1.dirty
In-Reply-To: <BANLkTimX_R8-mT4PqAhqwvCPm_-bcDFqVQ@mail.gmail.com>
References: <BANLkTimX_R8-mT4PqAhqwvCPm_-bcDFqVQ@mail.gmail.com>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If user space attempts to unlink a non-existent file, and the file
system is mounted read-only, return ENOENT instead of EROFS.  Either
error code is arguably valid/correct, but ENOENT is a more specific
error message.

Reported-by: Michael Tokarev <mjt@tls.msk.ru>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/namei.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 1ab641f..30398db 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2708,11 +2708,10 @@ static long do_unlinkat(int dfd, const char __user *pathname)
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

