Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab0IPRsF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 13:48:05 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54546 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755562Ab0IPRqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 13:46:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-afs@lists.infradead.org,
        David Howells <dhowells@redhat.com>
Subject: [PATCH 08/12] BKL: Remove BKL from afs
Date: Thu, 16 Sep 2010 19:46:21 +0200
Message-Id: <1284659185-8942-9-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284659185-8942-1-git-send-email-arnd@arndb.de>
References: <1284659185-8942-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:y4gUSRAbuDaWfW14YT+LezoBryVvBLC7NqVY8/Xq7pP
 uVpW7mwh3S/CXjUvZhufH+npP/j0Ei9zwIRg5qkRb5rpC0rk2y
 yDdBbsf+ybboVFRhJd0JSBXBXgl4G+Iqo7skbJ/NOXbmlkqHs6
 iQttAEQYsykZnuf65x/yzROOwq4mljzl4SWhDe7nlI3IJDPJGd
 pBblmL6Vv8uxE5FoTFa9Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BKL is only used in put_super and fill_super, which are both protected
by the superblocks s_umount rw_semaphore. Therefore it is safe to remove
the BKL entirely.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: linux-afs@lists.infradead.org
Cc: David Howells <dhowells@redhat.com>
---
 fs/afs/super.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/fs/afs/super.c b/fs/afs/super.c
index 6c2fef4..eacf76d 100644
--- a/fs/afs/super.c
+++ b/fs/afs/super.c
@@ -19,7 +19,6 @@
 #include <linux/mount.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
 #include <linux/parser.h>
@@ -302,15 +301,12 @@ static int afs_fill_super(struct super_block *sb, void *data)
 	struct inode *inode = NULL;
 	int ret;
 
-	lock_kernel();
-
 	_enter("");
 
 	/* allocate a superblock info record */
 	as = kzalloc(sizeof(struct afs_super_info), GFP_KERNEL);
 	if (!as) {
 		_leave(" = -ENOMEM");
-		unlock_kernel();
 		return -ENOMEM;
 	}
 
@@ -344,7 +340,6 @@ static int afs_fill_super(struct super_block *sb, void *data)
 	sb->s_root = root;
 
 	_leave(" = 0");
-	unlock_kernel();
 	return 0;
 
 error_inode:
@@ -358,7 +353,6 @@ error:
 	sb->s_fs_info = NULL;
 
 	_leave(" = %d", ret);
-	unlock_kernel();
 	return ret;
 }
 
@@ -458,12 +452,8 @@ static void afs_put_super(struct super_block *sb)
 
 	_enter("");
 
-	lock_kernel();
-
 	afs_put_volume(as->volume);
 
-	unlock_kernel();
-
 	_leave("");
 }
 
-- 
1.7.1

