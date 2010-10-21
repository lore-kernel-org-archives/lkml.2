Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169Ab0JUNWz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:22:55 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:7306 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932139Ab0JUNWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:22:52 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoAGAGfav0x5LdoFgWdsb2JhbACUZ4xxFgEBFiIiwC+FSgSKTYUB
Message-Id: <20101021131015.991189232@kernel.dk>
User-Agent: quilt/0.48-1
Date: Fri, 22 Oct 2010 00:08:30 +1100
From: npiggin@kernel.dk
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        npiggin@kernel.dk
Subject: [patch 01/14] fs: icache begin inode_lock lock breaking
References: <20101021130829.442910807@kernel.dk>
Content-Disposition: inline; filename=fs-inode_lock-deopt.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark the occasion by open-coding the atomic_dec_and_lock from inode
refcounting, and replace it with an open coded equivalent. This is in
preparation for breaking the inode_lock into multiple locks (dec_and_lock can
only handle one lock at a time).

Signed-off-by: Nick Piggin <npiggin@kernel.dk>
---
 fs/inode.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2010-10-21 23:49:56.000000000 +1100
+++ linux-2.6/fs/inode.c	2010-10-21 23:50:49.000000000 +1100
@@ -26,6 +26,16 @@
 #include <linux/posix_acl.h>
 
 /*
+ * Icache locking
+ *
+ * Usage:
+ * inode_lock protects:
+ *   everything
+ *
+ * Ordering:
+ * inode_lock
+ */
+/*
  * This is needed for the following functions:
  *  - inode_has_buffers
  *  - invalidate_inode_buffers
@@ -1259,8 +1269,14 @@ void iput(struct inode *inode)
 	if (inode) {
 		BUG_ON(inode->i_state & I_CLEAR);
 
-		if (atomic_dec_and_lock(&inode->i_count, &inode_lock))
+		/* open-code atomic_dec_and_lock */
+		if (atomic_add_unless(&inode->i_count, -1, 1))
+			return;
+		spin_lock(&inode_lock);
+		if (atomic_dec_and_test(&inode->i_count))
 			iput_final(inode);
+		else
+			spin_unlock(&inode_lock);
 	}
 }
 EXPORT_SYMBOL(iput);


