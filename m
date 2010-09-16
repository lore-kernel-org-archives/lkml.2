Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649Ab0IPRq6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 13:46:58 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:52123 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578Ab0IPRqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 13:46:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Dustin Kirkland <kirkland@canonical.com>,
        Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
        ecryptfs-devel@lists.launchpad.net
Subject: [PATCH 09/12] BKL: Remove BKL from ecryptfs
Date: Thu, 16 Sep 2010 19:46:22 +0200
Message-Id: <1284659185-8942-10-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284659185-8942-1-git-send-email-arnd@arndb.de>
References: <1284659185-8942-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:yGG/9BLQYU4MEJ5hoUl89KnjqhDbDDjdW75osS/jG2G
 6Z6v/1qfLgzKsLp1hkLyxADXtr0Hx+6Of2W7WQCulq8z7C83Tz
 0ksRAIOZbW1BTFrRqOH4R6+7vZdf32xZVw+YxYc6sV8A5nb1tH
 1LTzFiF9GSNssUDEmTksDfoXWyP71M/pCWN9NCF9/k/1b4ftSB
 n/cXu2XOARum+k41xacXg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BKL is only used in fill_super, which is protected by the superblocks
s_umount rw_semaphorei, and in fasync, which does not do anything that
could require the BKL. Therefore it is safe to remove the BKL entirely.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Dustin Kirkland <kirkland@canonical.com>
Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Cc: ecryptfs-devel@lists.launchpad.net
---
 fs/ecryptfs/file.c |    3 ---
 fs/ecryptfs/main.c |    4 ----
 2 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index 622c951..2b9a644 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -31,7 +31,6 @@
 #include <linux/security.h>
 #include <linux/compat.h>
 #include <linux/fs_stack.h>
-#include <linux/smp_lock.h>
 #include "ecryptfs_kernel.h"
 
 /**
@@ -284,11 +283,9 @@ static int ecryptfs_fasync(int fd, struct file *file, int flag)
 	int rc = 0;
 	struct file *lower_file = NULL;
 
-	lock_kernel();
 	lower_file = ecryptfs_file_to_lower(file);
 	if (lower_file->f_op && lower_file->f_op->fasync)
 		rc = lower_file->f_op->fasync(fd, lower_file, flag);
-	unlock_kernel();
 	return rc;
 }
 
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index c4af92f..cbd4e18 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -36,7 +36,6 @@
 #include <linux/parser.h>
 #include <linux/fs_stack.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>     /* For lock_kernel() */
 #include "ecryptfs_kernel.h"
 
 /**
@@ -551,7 +550,6 @@ static int ecryptfs_get_sb(struct file_system_type *fs_type, int flags,
 	const char *err = "Getting sb failed";
 	int rc;
 
-	lock_kernel();
 	sbi = kmem_cache_zalloc(ecryptfs_sb_info_cache, GFP_KERNEL);
 	if (!sbi) {
 		rc = -ENOMEM;
@@ -610,7 +608,6 @@ static int ecryptfs_get_sb(struct file_system_type *fs_type, int flags,
 		goto out;
 	}
 	simple_set_mnt(mnt, s);
-	unlock_kernel();
 	return 0;
 
 out:
@@ -619,7 +616,6 @@ out:
 		kmem_cache_free(ecryptfs_sb_info_cache, sbi);
 	}
 	printk(KERN_ERR "%s; rc = [%d]\n", err, rc);
-	unlock_kernel();
 	return rc;
 }
 
-- 
1.7.1

