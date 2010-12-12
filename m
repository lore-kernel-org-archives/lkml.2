Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab0LMAWj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:22:39 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44869 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298Ab0LLXpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:52 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: fweisbec@gmail.com, jeffm@suse.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [53/223] reiserfs: fix inode mutex - reiserfs lock misordering
Message-Id: <20101212234550.B7E61B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:50 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Frederic Weisbecker <fweisbec@gmail.com>

commit da905873effecd1c0166e578bc4b5006f041b18b upstream.

reiserfs_unpack() locks the inode mutex with reiserfs_mutex_lock_safe()
to protect against reiserfs lock dependency.  However this protection
requires to have the reiserfs lock to be locked.

This is the case if reiserfs_unpack() is called by reiserfs_ioctl but
not from reiserfs_quota_on() when it tries to unpack tails of quota
files.

Fix the ordering of the two locks in reiserfs_unpack() to fix this
issue.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Reported-by: Markus Gapp <markus.gapp@gmx.net>
Reported-by: Jan Kara <jack@suse.cz>
Cc: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/reiserfs/ioctl.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: linux/fs/reiserfs/ioctl.c
===================================================================
--- linux.orig/fs/reiserfs/ioctl.c
+++ linux/fs/reiserfs/ioctl.c
@@ -186,12 +186,11 @@ int reiserfs_unpack(struct inode *inode,
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
