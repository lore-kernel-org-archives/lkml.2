Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab0KIWff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 17:35:35 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59534 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab0KIWfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 17:35:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=uFlENJZk3harpgjckhu6F0GSErwhkryXSK7Im7zpWDngYu4jL7Gt0M9Zw7CSJPBS6T
         K10R/pXKvI+FyUVeVlqYcozWJK/j4E9W+hIz3wEldkiupIGUepVm7SQJeWKGOErj4knQ
         JUJaXNtRn0u0KnDYteFSdIwxrqyd5eo4CifOU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Markus Gapp <markus.gapp@gmx.net>, Jan Kara <jack@suse.cz>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH] reiserfs: Fix inode mutex - reiserfs lock misordering
Date: Tue,  9 Nov 2010 23:35:27 +0100
Message-Id: <1289342127-11410-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reiserfs_unpack() locks the inode mutex with
reiserfs_mutex_lock_safe() to protect against reiserfs lock
dependency. However this protection requires to have the
reiserfs lock to be locked.

This is the case if reiserfs_unpack() is called by reiserfs_ioctl
but not from reiserfs_quota_on() when it tries to unpack tails of
quota files.

Fix the ordering of the two locks in reiserfs_unpack() to
fix this issue.

Reported-by: Markus Gapp <markus.gapp@gmx.net>
Reported-by: Jan Kara <jack@suse.cz>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 fs/reiserfs/ioctl.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/reiserfs/ioctl.c b/fs/reiserfs/ioctl.c
index adf22b4..d2a7955 100644
--- a/fs/reiserfs/ioctl.c
+++ b/fs/reiserfs/ioctl.c
@@ -184,12 +184,11 @@ int reiserfs_unpack(struct inode *inode, struct file *filp)
 		return 0;
 	}
 
-	/* we need to make sure nobody is changing the file size beneath
-	 ** us
-	 */
-	reiserfs_mutex_lock_safe(&inode->i_mutex, inode->i_sb);
 	depth = reiserfs_write_lock_once(inode->i_sb);
 
+	/* we need to make sure nobody is changing the file size beneath us */
+	reiserfs_mutex_lock_safe(&inode->i_mutex, inode->i_sb);
+
 	write_from = inode->i_size & (blocksize - 1);
 	/* if we are on a block boundary, we are already unpacked.  */
 	if (write_from == 0) {
-- 
1.6.2.3

