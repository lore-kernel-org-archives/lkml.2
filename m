Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646Ab2IQUWE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 16:22:04 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59138 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723Ab2IQUWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 16:22:01 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org,
        Trond.Myklebust@netapp.com
Subject: [PATCH 1/2] vfs: dcache: fix deadlock in tree traversal
Date: Mon, 17 Sep 2012 22:23:30 +0200
Message-ID: <871ui01jr1.fsf@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

IBM reported a deadlock in select_parent().  This was found to be caused by
taking rename_lock when already locked when restarting the tree traversal.

There are two cases when the traversal needs to be restarted:

 1) concurrent d_move(); this can only happen when not already locked,
 since taking rename_lock protects against concurrent d_move().

 2) racing with final d_put() on child just at the moment of ascending
 to parent; rename_lock doesn't protect against this rare race, so it
 can happen when already locked.

Because of case 2. we need to be able to handle restarting the traversal
when rename_lock is already held.  This patch fixes all three callers of
try_to_ascend().

IBM reported that the deadlock is gone with this patch.  However, there's still
a soft lockup which is addressed by the next patch.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: stable@vger.kernel.org
---
 fs/dcache.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2012-09-17 19:56:19.000000000 +0200
+++ linux-2.6/fs/dcache.c	2012-09-17 20:04:07.000000000 +0200
@@ -1134,8 +1134,10 @@ int have_submounts(struct dentry *parent
 	return 1;
 
 rename_retry:
-	locked = 1;
-	write_seqlock(&rename_lock);
+	if (!locked) {
+		locked = 1;
+		write_seqlock(&rename_lock);
+	}
 	goto again;
 }
 EXPORT_SYMBOL(have_submounts);
@@ -1236,8 +1238,10 @@ static int select_parent(struct dentry *
 rename_retry:
 	if (found)
 		return found;
-	locked = 1;
-	write_seqlock(&rename_lock);
+	if (!locked) {
+		locked = 1;
+		write_seqlock(&rename_lock);
+	}
 	goto again;
 }
 
@@ -3035,8 +3039,11 @@ void d_genocide(struct dentry *root)
 	return;
 
 rename_retry:
-	locked = 1;
-	write_seqlock(&rename_lock);
+	if (!locked) {
+		locked = 1;
+		write_seqlock(&rename_lock);
+
+	}
 	goto again;
 }
 
