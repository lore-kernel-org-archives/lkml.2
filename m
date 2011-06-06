Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053Ab1FFUhZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 16:37:25 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:47339 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834Ab1FFUhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 16:37:22 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@ZenIV.linux.org.uk
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH] vfs: make unlink() return ENOENT in preference to EROFS
Date: Mon,  6 Jun 2011 16:37:20 -0400
Message-Id: <1307392640-28018-1-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.4.1.22.gec8e1.dirty
In-Reply-To: <20110606195555.GB20818@thunk.org>
References: <20110606195555.GB20818@thunk.org>
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
 fs/namei.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 1ab641f..a9edbe0 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2708,9 +2708,9 @@ static long do_unlinkat(int dfd, const char __user *pathname)
 	error = PTR_ERR(dentry);
 	if (!IS_ERR(dentry)) {
 		/* Why not before? Because we want correct error value */
-		if (nd.last.name[nd.last.len])
-			goto slashes;
 		inode = dentry->d_inode;
+		if (nd.last.name[nd.last.len] || !inode)
+			goto slashes;
 		if (inode)
 			ihold(inode);
 		error = mnt_want_write(nd.path.mnt);
-- 
1.7.4.1.22.gec8e1.dirty

