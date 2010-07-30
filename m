Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933125Ab0G3SYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:24:18 -0400
Received: from kroah.org ([198.145.64.141]:58580 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759987Ab0G3Rzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:55:52 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:42 2010
Message-Id: <20100730175142.021229423@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:51:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Lubomir Rintel <lkundrak@v3.sk>, Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [092/205] sysvfs: fix NULL deref. when allocating new inode
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Lubomir Rintel <lkundrak@v3.sk>

commit 46c23d7f520e315dde86881b38ba92ebdf34ced5 upstream.

A call to sysv_write_inode() in sysv_new_inode() to its new interface that
replaced wait flag with writeback structure.  This was broken by
a9185b41a4f84971b930c519f0c63bd450c4810d ("pass writeback_control to
->write_inode").

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/sysv/ialloc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/sysv/ialloc.c
+++ b/fs/sysv/ialloc.c
@@ -25,6 +25,7 @@
 #include <linux/stat.h>
 #include <linux/string.h>
 #include <linux/buffer_head.h>
+#include <linux/writeback.h>
 #include "sysv.h"
 
 /* We don't trust the value of
@@ -139,6 +140,9 @@ struct inode * sysv_new_inode(const stru
 	struct inode *inode;
 	sysv_ino_t ino;
 	unsigned count;
+	struct writeback_control wbc = {
+		.sync_mode = WB_SYNC_NONE
+	};
 
 	inode = new_inode(sb);
 	if (!inode)
@@ -177,7 +181,7 @@ struct inode * sysv_new_inode(const stru
 	mark_inode_dirty(inode);
 
 	inode->i_mode = mode;		/* for sysv_write_inode() */
-	sysv_write_inode(inode, 0);	/* ensure inode not allocated again */
+	sysv_write_inode(inode, &wbc);	/* ensure inode not allocated again */
 	mark_inode_dirty(inode);	/* cleared by sysv_write_inode() */
 	/* That's it. */
 	unlock_super(sb);


