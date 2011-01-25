Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab1AYWTK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 17:19:10 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:62612 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557Ab1AYWSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 17:18:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 10/20] hpfs: replace BKL with a global mutex
Date: Tue, 25 Jan 2011 23:17:24 +0100
Message-Id: <1295993854-4971-11-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295993854-4971-1-git-send-email-arnd@arndb.de>
References: <1295993854-4971-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:txarRBwDUwlWhEmjTg5xZANYLAKvyzmrFS2iqGiuEwP
 GSQrpKcRxAnM5Twq3j5Xzd9pLcq8ZCnj5+4Xuov3kd/iZrWS3W
 CIvwWH80Iz7J7X3OkiGZ1B5zoxOTp/yN2sKDlenhKWTd9FhENq
 QCw0gupqkopAEyhKMWY5V0KTv4xDyEwcHT8vhjNfo6OhSxjKCi
 Oo1p+zkau20BZzTqZ9nNQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the BKL in hpfs in a rather awful
way, by replacing it with a mutex that basically
serializes the entire file system.

The only reason I hope to get away with this
is because there don't seem to be any real
users left, and the file system is going out
through the staging door anyways.

Since the mutex code is not even tested and
I don't expect anyone to do that, I'm marking
it as broken on SMP and PREEMPT kernels, so
it won't actually get used.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: linux-fsdevel@vger.kernel.org
---
 fs/hpfs/Kconfig   |    2 +-
 fs/hpfs/hpfs_fn.h |   30 ++++++++++++++++++++++++++----
 fs/hpfs/super.c   |    1 +
 3 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/fs/hpfs/Kconfig b/fs/hpfs/Kconfig
index 63b6f56..73476c1 100644
--- a/fs/hpfs/Kconfig
+++ b/fs/hpfs/Kconfig
@@ -1,7 +1,7 @@
 config HPFS_FS
 	tristate "OS/2 HPFS file system support"
 	depends on BLOCK
-	depends on BKL # nontrivial to fix
+	depends on BROKEN || !(SMP || PREEMPT)
 	help
 	  OS/2 is IBM's operating system for PC's, the same as Warp, and HPFS
 	  is the file system used for organizing files on OS/2 hard disk
diff --git a/fs/hpfs/hpfs_fn.h b/fs/hpfs/hpfs_fn.h
index 6761cb3..ffdb16e 100644
--- a/fs/hpfs/hpfs_fn.h
+++ b/fs/hpfs/hpfs_fn.h
@@ -13,7 +13,6 @@
 #include <linux/pagemap.h>
 #include <linux/buffer_head.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 
 #include "hpfs.h"
 
@@ -90,6 +89,7 @@ struct hpfs_sb_info {
 	unsigned sb_max_fwd_alloc;	/* max forwad allocation */
 	struct mutex hpfs_creation_de;	/* when creating dirents, nobody else
 					   can alloc blocks */
+	struct mutex global_mutex;	/* replaces BKL, serializes everything on SMP */
 	/*unsigned sb_mounting : 1;*/
 	int sb_timeshift;
 };
@@ -345,14 +345,36 @@ static inline time32_t gmt_to_local(struct super_block *s, time_t t)
 }
 
 /*
- * Locking
+ * Locking:
+ *
+ * hpfs_lock() is a leftover from the big kernel lock.
+ * This mutex is used as the outermost lock in hpfs,
+ * all other mutexes (inode->i_mutex, hpfs_inode_info->i_mutex,
+ * hpfs_inode_info->i_parent_mutex, hpfs_creation_de and
+ * lock_super) can get taken while hpfs_lock is held already.
+ *
+ * Code inspection has shown that hpfs_lock never gets taken
+ * recursively, and that it never nests inside one of the
+ * mutexes above, so there should be no deadlocks.
+ *
+ * However, it is frequently held while wait_for_buffer
+ * sleeps, which probably causes a huge slowdown, since
+ * that serializes all operations on a file system.
+ *
+ * Moreover, the locking code is entirely untested, use at
+ * your own risk.
  */
 static inline void hpfs_lock(struct super_block *s)
 {
-	lock_kernel();
+#if defined(CONFIG_SMP) || defined(CONFIG_PREEMPT)
+#warning HPFS is likely broken on SMP configurations
+	mutex_lock(&hpfs_sb(s)->global_mutex);
+#endif
 }
 
 static inline void hpfs_unlock(struct super_block *s)
 {
-	unlock_kernel();
+#if defined(CONFIG_SMP) || defined(CONFIG_PREEMPT)
+	mutex_unlock(&hpfs_sb(s)->global_mutex);
+#endif
 }
diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
index 501ea86..694a683 100644
--- a/fs/hpfs/super.c
+++ b/fs/hpfs/super.c
@@ -491,6 +491,7 @@ static int hpfs_fill_super(struct super_block *s, void *options, int silent)
 	sbi->sb_cp_table = NULL;
 
 	mutex_init(&sbi->hpfs_creation_de);
+	mutex_init(&sbi->global_mutex);
 
 	uid = current_uid();
 	gid = current_gid();
-- 
1.7.1

