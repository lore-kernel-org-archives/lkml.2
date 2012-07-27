Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab2G0EnZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 00:43:25 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:58985 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab2G0EnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 00:43:23 -0400
From: Filipe Brandenburger <filbranden@gmail.com>
To: "J. Bruce Fields" <bfields@fieldses.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <matthew@wil.cx>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Filipe Brandenburger <filbranden@gmail.com>
Subject: [PATCHv3] locks: prevent side-effects of locks_release_private before file_lock is initialized
Date: Fri, 27 Jul 2012 00:42:52 -0400
Message-Id: <1343364172-1763-1-git-send-email-filbranden@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <20120707190451.GA17049@fieldses.org>
References: <20120707190451.GA17049@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When calling fcntl(fd, F_SETLEASE, lck) [with lck=F_WRLCK or F_RDLCK],
the custom signal or owner (if any were previously set using F_SETSIG
or F_SETOWN fcntls) would be reset when F_SETLEASE was called for the
second time on the same file descriptor.

This bug is a regression of 2.6.37 and is described here:
https://bugzilla.kernel.org/show_bug.cgi?id=43336

This patch reverts a commit from Oct 2004 (with subject "nfs4 lease:
move the f_delown processing") which originally introduced the
lm_release_private callback.

Signed-off-by: Filipe Brandenburger <filbranden@gmail.com>
---
 fs/locks.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 82c3533..6595882 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -427,18 +427,8 @@ static void lease_break_callback(struct file_lock *fl)
 	kill_fasync(&fl->fl_fasync, SIGIO, POLL_MSG);
 }
 
-static void lease_release_private_callback(struct file_lock *fl)
-{
-	if (!fl->fl_file)
-		return;
-
-	f_delown(fl->fl_file);
-	fl->fl_file->f_owner.signum = 0;
-}
-
 static const struct lock_manager_operations lease_manager_ops = {
 	.lm_break = lease_break_callback,
-	.lm_release_private = lease_release_private_callback,
 	.lm_change = lease_modify,
 };
 
@@ -1155,8 +1145,13 @@ int lease_modify(struct file_lock **before, int arg)
 		return error;
 	lease_clear_pending(fl, arg);
 	locks_wake_up_blocks(fl);
-	if (arg == F_UNLCK)
+	if (arg == F_UNLCK) {
+		struct file *filp = fl->fl_file;
+
+		f_delown(filp);
+		filp->f_owner.signum = 0;
 		locks_delete_lock(before);
+	}
 	return 0;
 }
 
-- 
1.7.7.6

