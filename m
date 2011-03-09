Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096Ab1CIAyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 19:54:52 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37526 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401Ab1CIAyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 19:54:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=a5srq8kjvM6WPgYpQwfuJmH/judIOVNB7aWBEUx231rxyO6YvNYrOcbUVkHxBdlSOe
         Mu+6okgX/ExBbR9fTD61KoxEpRoWcEdgPgUUyJy3EdVmyrvhwbmDQjJEnt6Ltz6Sq8os
         K+40+rcLiV9W8K/0povqSh6GlsqYPfzMiWuc0=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH next 3/5] staging: spectra: optimize kmalloc to kzalloc
Date: Wed,  9 Mar 2011 03:53:36 +0300
Message-Id: <1299632018-6774-3-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1299632018-6774-1-git-send-email-a.beregalov@gmail.com>
References: <1299632018-6774-1-git-send-email-a.beregalov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kzalloc rather than kmalloc followed by memset with 0.
Found by coccinelle.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/staging/spectra/flash.c |   26 +++++++++-----------------
 1 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/spectra/flash.c b/drivers/staging/spectra/flash.c
index f11197b..a2f8200 100644
--- a/drivers/staging/spectra/flash.c
+++ b/drivers/staging/spectra/flash.c
@@ -428,10 +428,9 @@ static int allocate_memory(void)
 		DeviceInfo.wPageDataSize;
 
 	/* Malloc memory for block tables */
-	g_pBlockTable = kmalloc(block_table_size, GFP_ATOMIC);
+	g_pBlockTable = kzalloc(block_table_size, GFP_ATOMIC);
 	if (!g_pBlockTable)
 		goto block_table_fail;
-	memset(g_pBlockTable, 0, block_table_size);
 	total_bytes += block_table_size;
 
 	g_pWearCounter = (u8 *)(g_pBlockTable +
@@ -447,19 +446,17 @@ static int allocate_memory(void)
 		Cache.array[i].address = NAND_CACHE_INIT_ADDR;
 		Cache.array[i].use_cnt = 0;
 		Cache.array[i].changed = CLEAR;
-		Cache.array[i].buf = kmalloc(Cache.cache_item_size,
-			GFP_ATOMIC);
+		Cache.array[i].buf = kzalloc(Cache.cache_item_size,
+					     GFP_ATOMIC);
 		if (!Cache.array[i].buf)
 			goto cache_item_fail;
-		memset(Cache.array[i].buf, 0, Cache.cache_item_size);
 		total_bytes += Cache.cache_item_size;
 	}
 
 	/* Malloc memory for IPF */
-	g_pIPF = kmalloc(page_size, GFP_ATOMIC);
+	g_pIPF = kzalloc(page_size, GFP_ATOMIC);
 	if (!g_pIPF)
 		goto ipf_fail;
-	memset(g_pIPF, 0, page_size);
 	total_bytes += page_size;
 
 	/* Malloc memory for data merging during Level2 Cache flush */
@@ -476,10 +473,9 @@ static int allocate_memory(void)
 	total_bytes += block_size;
 
 	/* Malloc memory for temp buffer */
-	g_pTempBuf = kmalloc(Cache.cache_item_size, GFP_ATOMIC);
+	g_pTempBuf = kzalloc(Cache.cache_item_size, GFP_ATOMIC);
 	if (!g_pTempBuf)
 		goto Temp_buf_fail;
-	memset(g_pTempBuf, 0, Cache.cache_item_size);
 	total_bytes += Cache.cache_item_size;
 
 	/* Malloc memory for block table blocks */
@@ -589,10 +585,9 @@ static int allocate_memory(void)
 	total_bytes += block_size;
 
 	/* Malloc memory for copy of block table used in CDMA mode */
-	g_pBTStartingCopy = kmalloc(block_table_size, GFP_ATOMIC);
+	g_pBTStartingCopy = kzalloc(block_table_size, GFP_ATOMIC);
 	if (!g_pBTStartingCopy)
 		goto bt_starting_copy;
-	memset(g_pBTStartingCopy, 0, block_table_size);
 	total_bytes += block_table_size;
 
 	g_pWearCounterCopy = (u8 *)(g_pBTStartingCopy +
@@ -608,28 +603,25 @@ static int allocate_memory(void)
 			5 * DeviceInfo.wDataBlockNum * sizeof(u8);
 	if (DeviceInfo.MLCDevice)
 		mem_size += 5 * DeviceInfo.wDataBlockNum * sizeof(u16);
-	g_pBlockTableCopies = kmalloc(mem_size, GFP_ATOMIC);
+	g_pBlockTableCopies = kzalloc(mem_size, GFP_ATOMIC);
 	if (!g_pBlockTableCopies)
 		goto blk_table_copies_fail;
-	memset(g_pBlockTableCopies, 0, mem_size);
 	total_bytes += mem_size;
 	g_pNextBlockTable = g_pBlockTableCopies;
 
 	/* Malloc memory for Block Table Delta */
 	mem_size = MAX_DESCS * sizeof(struct BTableChangesDelta);
-	g_pBTDelta = kmalloc(mem_size, GFP_ATOMIC);
+	g_pBTDelta = kzalloc(mem_size, GFP_ATOMIC);
 	if (!g_pBTDelta)
 		goto bt_delta_fail;
-	memset(g_pBTDelta, 0, mem_size);
 	total_bytes += mem_size;
 	g_pBTDelta_Free = g_pBTDelta;
 
 	/* Malloc memory for Copy Back Buffers */
 	for (j = 0; j < COPY_BACK_BUF_NUM; j++) {
-		cp_back_buf_copies[j] = kmalloc(block_size, GFP_ATOMIC);
+		cp_back_buf_copies[j] = kzalloc(block_size, GFP_ATOMIC);
 		if (!cp_back_buf_copies[j])
 			goto cp_back_buf_copies_fail;
-		memset(cp_back_buf_copies[j], 0, block_size);
 		total_bytes += block_size;
 	}
 	cp_back_buf_idx = 0;
-- 
1.7.4.1

