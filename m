Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab0IPRqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 13:46:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64480 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363Ab0IPRqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 13:46:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, reiserfs-devel@vger.kernel.org
Subject: [PATCH 05/12] BKL: Remove BKL from ReiserFS
Date: Thu, 16 Sep 2010 19:46:18 +0200
Message-Id: <1284659185-8942-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284659185-8942-1-git-send-email-arnd@arndb.de>
References: <1284659185-8942-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:rjSltymMTI9tU0YnSPem1xQspprCW8PUyLZSN/JE0IE
 CRF8/WJTT0kn2CYLMLYLhSVUo8uY1qCfQKG8ZBlyEYPvbbPlEd
 /8q+t6BUZf3IRSkgVQhNOwwhNXFSe3+QmceE22QmdM0HHZavMS
 9UaHziL5WGGBmpILCBfGkTs8ayGUahlPfSUOI5tGYB+ndBNAv8
 iCjnzgYKeO06FpD9oQbvg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BKL only got into reiserfs through the pushdown into
->fill_super. This function is already sufficiently
serialized using reiserfs_write_lock(), so we can
safely remove the BKL here.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: reiserfs-devel@vger.kernel.org
---
 fs/reiserfs/super.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 6874489..b8df814 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -28,7 +28,6 @@
 #include <linux/mount.h>
 #include <linux/namei.h>
 #include <linux/crc32.h>
-#include <linux/smp_lock.h>
 
 struct file_system_type reiserfs_fs_type;
 
@@ -1628,8 +1627,6 @@ static int reiserfs_fill_super(struct super_block *s, void *data, int silent)
 	char *qf_names[MAXQUOTAS] = {};
 	unsigned int qfmt = 0;
 
-	lock_kernel();
-
 	save_mount_options(s, data);
 
 	sbi = kzalloc(sizeof(struct reiserfs_sb_info), GFP_KERNEL);
@@ -1887,8 +1884,6 @@ static int reiserfs_fill_super(struct super_block *s, void *data, int silent)
 	spin_lock_init(&sbi->bitmap_lock);
 
 	reiserfs_write_unlock(s);
-
-	unlock_kernel();
 	return (0);
 
 error:
@@ -1911,7 +1906,6 @@ error:
 	kfree(sbi);
 
 	s->s_fs_info = NULL;
-	unlock_kernel();
 	return errval;
 }
 
-- 
1.7.1

