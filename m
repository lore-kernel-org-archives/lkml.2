Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab1AZMs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 07:48:56 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:58943 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab1AZMsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 07:48:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH v2] hpfs: remove the BKL
Date: Wed, 26 Jan 2011 13:48:46 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        linux-fsdevel@vger.kernel.org
References: <1295993854-4971-1-git-send-email-arnd@arndb.de> <1295993854-4971-11-git-send-email-arnd@arndb.de> <m2ipxc34aq.fsf@linux.intel.com>
In-Reply-To: <m2ipxc34aq.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101261348.46795.arnd@arndb.de>
X-Provags-ID: V02:K0:bHcclS6QXiZkxWBOCDJcKup4dFtJdfMXYGMtPvM/A5J
 2frCi3bM8IabLAJVwk0Chm//GJYtj94rldog6a+c14TuX1EE/D
 V9KPIw3Y7YaW+mH/aXEkGHLk28PzKX2/HrPlpKqjw5vALvDYgS
 NSteKFC3QASEiGQYznR9HDQTJjjG+uEmXL93xN3MDXHlgcxWR5
 YpeAgpL7EMaj9XU8sYxew==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the BKL in hpfs in a rather awful
way, by making the code only work on uniprocessor
systems without kernel preemption, as suggested
by Andi Kleen.

The HPFS code probably has close to zero remaining
users on current kernels, all archeological uses of
the file system can probably be done with the significant
restrictions.

The hpfs_lock/hpfs_unlock functions are left in the
code as stubs, in case someone feels motivated to
make it work on SMP again.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: linux-fsdevel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>

diff --git a/fs/hpfs/Kconfig b/fs/hpfs/Kconfig
index 63b6f56..0c39dc3 100644
--- a/fs/hpfs/Kconfig
+++ b/fs/hpfs/Kconfig
@@ -1,7 +1,7 @@
 config HPFS_FS
 	tristate "OS/2 HPFS file system support"
 	depends on BLOCK
-	depends on BKL # nontrivial to fix
+	depends on BROKEN || !PREEMPT
 	help
 	  OS/2 is IBM's operating system for PC's, the same as Warp, and HPFS
 	  is the file system used for organizing files on OS/2 hard disk
diff --git a/fs/hpfs/hpfs_fn.h b/fs/hpfs/hpfs_fn.h
index 6761cb3..c15adbc 100644
--- a/fs/hpfs/hpfs_fn.h
+++ b/fs/hpfs/hpfs_fn.h
@@ -13,7 +13,6 @@
 #include <linux/pagemap.h>
 #include <linux/buffer_head.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 
 #include "hpfs.h"
 
@@ -345,14 +344,23 @@ static inline time32_t gmt_to_local(struct super_block *s, time_t t)
 }
 
 /*
- * Locking
+ * Locking:
+ *
+ * hpfs_lock() is a leftover from the big kernel lock.
+ * Right now, these functions are empty and only left
+ * for documentation purposes. The file system no longer
+ * works on SMP systems, so the lock is not needed
+ * any more.
+ *
+ * If someone is interested in making it work again, this
+ * would be the place to start by adding a per-superblock
+ * mutex and fixing all the bugs and performance issues
+ * caused by that.
  */
 static inline void hpfs_lock(struct super_block *s)
 {
-	lock_kernel();
 }
 
 static inline void hpfs_unlock(struct super_block *s)
 {
-	unlock_kernel();
 }
diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
index 501ea86..c89b408 100644
--- a/fs/hpfs/super.c
+++ b/fs/hpfs/super.c
@@ -479,6 +479,11 @@ static int hpfs_fill_super(struct super_block *s, void *options, int silent)
 
 	int o;
 
+	if (num_possible_cpus() > 1) {
+		printk(KERN_ERR "HPFS is not SMP safe\n");
+		return -EINVAL;
+	}
+
 	save_mount_options(s, options);
 
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
