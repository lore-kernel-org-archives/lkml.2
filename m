Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078Ab0LGKJI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 05:09:08 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38978 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab0LGKJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 05:09:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ZBbTCeUWIrHUpbcbFsqw3Mid5ziM1trHI/pNknsPMU675OAfl+WEzi1Rncy8B76kkY
         MPgmZcr1gtALy3QS5/Mk8zPqv2PHXHGXv4XVB7C6dFI0nRcuPg0L5YhfGWeHrXUetkAS
         l+Tvc9iZQ859bGuJ4j0fBTUZmx7QMaOlOkNLM=
From: Namhyung Kim <namhyung@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruen@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] mbcache: use list_for_each_entry*
Date: Tue,  7 Dec 2010 19:08:54 +0900
Message-Id: <1291716536-10285-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert list_for_each*() + list_entry() to list_for_each_entry*().

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/mbcache.c |   36 ++++++++++++++----------------------
 1 files changed, 14 insertions(+), 22 deletions(-)

diff --git a/fs/mbcache.c b/fs/mbcache.c
index 9344474..0477c71 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -278,21 +278,18 @@ void
 mb_cache_shrink(struct block_device *bdev)
 {
 	LIST_HEAD(free_list);
-	struct list_head *l, *ltmp;
+	struct mb_cache_entry *ce, *tmp;
 
 	spin_lock(&mb_cache_spinlock);
-	list_for_each_safe(l, ltmp, &mb_cache_lru_list) {
-		struct mb_cache_entry *ce =
-			list_entry(l, struct mb_cache_entry, e_lru_list);
+	list_for_each_entry_safe(ce, tmp, &mb_cache_lru_list, e_lru_list) {
 		if (ce->e_bdev == bdev) {
 			list_move_tail(&ce->e_lru_list, &free_list);
 			__mb_cache_entry_unhash(ce);
 		}
 	}
 	spin_unlock(&mb_cache_spinlock);
-	list_for_each_safe(l, ltmp, &free_list) {
-		__mb_cache_entry_forget(list_entry(l, struct mb_cache_entry,
-						   e_lru_list), GFP_KERNEL);
+	list_for_each_entry_safe(ce, tmp, &free_list, e_lru_list) {
+		__mb_cache_entry_forget(ce, GFP_KERNEL);
 	}
 }
 
@@ -308,12 +305,10 @@ void
 mb_cache_destroy(struct mb_cache *cache)
 {
 	LIST_HEAD(free_list);
-	struct list_head *l, *ltmp;
+	struct mb_cache_entry *ce, *tmp;
 
 	spin_lock(&mb_cache_spinlock);
-	list_for_each_safe(l, ltmp, &mb_cache_lru_list) {
-		struct mb_cache_entry *ce =
-			list_entry(l, struct mb_cache_entry, e_lru_list);
+	list_for_each_entry_safe(ce, tmp, &mb_cache_lru_list, e_lru_list) {
 		if (ce->e_cache == cache) {
 			list_move_tail(&ce->e_lru_list, &free_list);
 			__mb_cache_entry_unhash(ce);
@@ -322,9 +317,8 @@ mb_cache_destroy(struct mb_cache *cache)
 	list_del(&cache->c_cache_list);
 	spin_unlock(&mb_cache_spinlock);
 
-	list_for_each_safe(l, ltmp, &free_list) {
-		__mb_cache_entry_forget(list_entry(l, struct mb_cache_entry,
-						   e_lru_list), GFP_KERNEL);
+	list_for_each_entry_safe(ce, tmp, &free_list, e_lru_list) {
+		__mb_cache_entry_forget(ce, GFP_KERNEL);
 	}
 
 	if (atomic_read(&cache->c_entry_count) > 0) {
@@ -398,16 +392,16 @@ mb_cache_entry_insert(struct mb_cache_entry *ce, struct block_device *bdev,
 {
 	struct mb_cache *cache = ce->e_cache;
 	unsigned int bucket;
-	struct list_head *l;
+	struct list_head *block_list;
+	struct mb_cache_entry *entry;
 	int error = -EBUSY;
 
 	bucket = hash_long((unsigned long)bdev + (block & 0xffffffff), 
 			   cache->c_bucket_bits);
+	block_list = &cache->c_block_hash[bucket];
 	spin_lock(&mb_cache_spinlock);
-	list_for_each_prev(l, &cache->c_block_hash[bucket]) {
-		struct mb_cache_entry *ce =
-			list_entry(l, struct mb_cache_entry, e_block_list);
-		if (ce->e_bdev == bdev && ce->e_block == block)
+	list_for_each_entry_reverse(entry, block_list, e_block_list) {
+		if (entry->e_bdev == bdev && entry->e_block == block)
 			goto out;
 	}
 	__mb_cache_entry_unhash(ce);
@@ -468,14 +462,12 @@ mb_cache_entry_get(struct mb_cache *cache, struct block_device *bdev,
 		   sector_t block)
 {
 	unsigned int bucket;
-	struct list_head *l;
 	struct mb_cache_entry *ce;
 
 	bucket = hash_long((unsigned long)bdev + (block & 0xffffffff),
 			   cache->c_bucket_bits);
 	spin_lock(&mb_cache_spinlock);
-	list_for_each(l, &cache->c_block_hash[bucket]) {
-		ce = list_entry(l, struct mb_cache_entry, e_block_list);
+	list_for_each_entry(ce, &cache->c_block_hash[bucket], e_block_list) {
 		if (ce->e_bdev == bdev && ce->e_block == block) {
 			DEFINE_WAIT(wait);
 
-- 
1.7.0.4

