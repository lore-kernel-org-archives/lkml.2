Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab0JWLiy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 07:38:54 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41490 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110Ab0JWLiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 07:38:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=cvZMSCxXE9oAaGXGMYW1DVDkEb2T8Qr3ZZhm1jfbZqiMM/5QOGmVj/+BNQs+GfmHFR
         2+FzJ+GMIFDUju5Fe4gfq3CVM1i9SzvQoBPx81suxxOLOaCjt/NrBbCacc0/CoYXskNb
         jGdNzq3BxNx2EZNJU9OppL57v6o4hxMDf5OpM=
From: Alessio Igor Bogani <abogani@texware.it>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tim Bird <tim.bird@am.sony.com>, LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH 6/6] udf: Replace BKL
Date: Sat, 23 Oct 2010 13:37:33 +0200
Message-Id: <1287833853-4175-6-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1287833853-4175-1-git-send-email-abogani@texware.it>
References: <1287833853-4175-1-git-send-email-abogani@texware.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The call to udf_truncate() is moved into i_mutex protected section.
So we can remove BKL from itself.

Replace BKL with i_mutex in udf_evict_inode() and in udf_block_map().

Remove BKL from udf_get_block() because alla code path calls that function
with i_mutex held.

In udf_write_inode() protect udf_update_inode() call only if it isn't called
with i_mutex already held.

This work was supported by a hardware donation from the CE Linux Forum.

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 fs/udf/inode.c |   27 ++++++++++++---------------
 1 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index fc48f37..ecc8b61 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -31,7 +31,7 @@
 
 #include "udfdecl.h"
 #include <linux/mm.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/module.h>
 #include <linux/pagemap.h>
 #include <linux/buffer_head.h>
@@ -78,10 +78,10 @@ void udf_evict_inode(struct inode *inode)
 	if (!inode->i_nlink && !is_bad_inode(inode)) {
 		want_delete = 1;
 		inode->i_size = 0;
+		mutex_lock(&inode->i_mutex);
 		udf_truncate(inode);
-		lock_kernel();
 		udf_update_inode(inode, IS_SYNC(inode));
-		unlock_kernel();
+		mutex_unlock(&inode->i_mutex);
 	}
 	invalidate_inode_buffers(inode);
 	end_writeback(inode);
@@ -97,9 +97,9 @@ void udf_evict_inode(struct inode *inode)
 	kfree(iinfo->i_ext.i_data);
 	iinfo->i_ext.i_data = NULL;
 	if (want_delete) {
-		lock_kernel();
+		mutex_lock(&inode->i_mutex);
 		udf_free_inode(inode);
-		unlock_kernel();
+		mutex_unlock(&inode->i_mutex);
 	}
 }
 
@@ -303,8 +303,6 @@ static int udf_get_block(struct inode *inode, sector_t block,
 	new = 0;
 	bh = NULL;
 
-	lock_kernel();
-
 	iinfo = UDF_I(inode);
 	if (block == iinfo->i_next_alloc_block + 1) {
 		iinfo->i_next_alloc_block++;
@@ -324,7 +322,6 @@ static int udf_get_block(struct inode *inode, sector_t block,
 	map_bh(bh_result, inode->i_sb, phys);
 
 abort:
-	unlock_kernel();
 	return err;
 }
 
@@ -1022,7 +1019,6 @@ void udf_truncate(struct inode *inode)
 	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
 		return;
 
-	lock_kernel();
 	iinfo = UDF_I(inode);
 	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
 		if (inode->i_sb->s_blocksize <
@@ -1031,7 +1027,6 @@ void udf_truncate(struct inode *inode)
 			udf_expand_file_adinicb(inode, inode->i_size, &err);
 			if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
 				inode->i_size = iinfo->i_lenAlloc;
-				unlock_kernel();
 				return;
 			} else
 				udf_truncate_extents(inode);
@@ -1053,7 +1048,6 @@ void udf_truncate(struct inode *inode)
 		udf_sync_inode(inode);
 	else
 		mark_inode_dirty(inode);
-	unlock_kernel();
 }
 
 static void __udf_read_inode(struct inode *inode)
@@ -1375,9 +1369,12 @@ int udf_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	int ret;
 
-	lock_kernel();
+	if (wbc->sync_mode == WB_SYNC_ALL)
+		return udf_sync_inode(inode);
+
+	mutex_lock(&inode->i_mutex);
 	ret = udf_update_inode(inode, wbc->sync_mode == WB_SYNC_ALL);
-	unlock_kernel();
+	mutex_unlock(&inode->i_mutex);
 
 	return ret;
 }
@@ -2048,7 +2045,7 @@ long udf_block_map(struct inode *inode, sector_t block)
 	struct extent_position epos = {};
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&inode->i_mutex);
 
 	if (inode_bmap(inode, block, &epos, &eloc, &elen, &offset) ==
 						(EXT_RECORDED_ALLOCATED >> 30))
@@ -2056,7 +2053,7 @@ long udf_block_map(struct inode *inode, sector_t block)
 	else
 		ret = 0;
 
-	unlock_kernel();
+	mutex_unlock(&inode->i_mutex);
 	brelse(epos.bh);
 
 	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_VARCONV))
-- 
1.7.0.4

