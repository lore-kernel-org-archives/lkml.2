Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859Ab0IPRsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 13:48:45 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:54174 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553Ab0IPRqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 13:46:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org
Subject: [PATCH 06/12] BKL: Remove BKL from capifs
Date: Thu, 16 Sep 2010 19:46:19 +0200
Message-Id: <1284659185-8942-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284659185-8942-1-git-send-email-arnd@arndb.de>
References: <1284659185-8942-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:O4se8MoGIc4fTe9RAWfq5g/xG6SGjok5NMwwGj7VeJi
 tamypO/VB5XoGG9JBPuLZTlvxjSrClnZYY2s1UyIQib0MX5NTZ
 sTcxc2m0cvu2f/ujkdE4nSjTFYeggE1zefwlvyNKKNtBouIoDF
 4Fy/S81fJusk0j97NW7cp158nGFanlqTk/dDzusWH5933HMYin
 8Gf3ZN7ul/Iwv4nD9+W4A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BKL is only used in fill_super, which is  protected by the superblocks
s_umount rw_semaphore. Therefore it is safe to remove the BKL entirely.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: netdev@vger.kernel.org
---
 drivers/isdn/capi/capifs.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/isdn/capi/capifs.c b/drivers/isdn/capi/capifs.c
index c559b52..b0dcdbc 100644
--- a/drivers/isdn/capi/capifs.c
+++ b/drivers/isdn/capi/capifs.c
@@ -17,7 +17,6 @@
 #include <linux/init.h>
 #include <linux/ctype.h>
 #include <linux/sched.h>	/* current */
-#include <linux/smp_lock.h>	/* For lock_kernel() */
 
 #include "capifs.h"
 
@@ -100,8 +99,6 @@ capifs_fill_super(struct super_block *s, void *data, int silent)
 {
 	struct inode * inode;
 
-	lock_kernel();
-
 	s->s_blocksize = 1024;
 	s->s_blocksize_bits = 10;
 	s->s_magic = CAPIFS_SUPER_MAGIC;
@@ -119,15 +116,12 @@ capifs_fill_super(struct super_block *s, void *data, int silent)
 	inode->i_nlink = 2;
 
 	s->s_root = d_alloc_root(inode);
-	if (s->s_root) {
-		unlock_kernel();
+	if (s->s_root)
 		return 0;
-	}
 
 	printk("capifs: get root dentry failed\n");
 	iput(inode);
 fail:
-	unlock_kernel();
 	return -ENOMEM;
 }
 
-- 
1.7.1

