Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab2BJFv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 00:51:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932391Ab2BJFpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 00:45:54 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Cong Wang <amwang@redhat.com>,
        Joern Engel <joern@logfs.org>,
        Prasad Joshi <prasadjoshi.linux@gmail.com>, logfs@logfs.org
Subject: [PATCH 37/60] logfs: remove the second argument of k[un]map_atomic()
Date: Fri, 10 Feb 2012 13:39:58 +0800
Message-Id: <1328852421-19678-38-git-send-email-amwang@redhat.com>
In-Reply-To: <1328852421-19678-1-git-send-email-amwang@redhat.com>
References: <1328852421-19678-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cong Wang <amwang@redhat.com>
---
 fs/logfs/dir.c       |   18 +++++++++---------
 fs/logfs/readwrite.c |   38 +++++++++++++++++++-------------------
 fs/logfs/segment.c   |    4 ++--
 3 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/fs/logfs/dir.c b/fs/logfs/dir.c
index 3de7a32..1b6e21d 100644
--- a/fs/logfs/dir.c
+++ b/fs/logfs/dir.c
@@ -177,17 +177,17 @@ static struct page *logfs_get_dd_page(struct inode *dir, struct dentry *dentry)
 				(filler_t *)logfs_readpage, NULL);
 		if (IS_ERR(page))
 			return page;
-		dd = kmap_atomic(page, KM_USER0);
+		dd = kmap_atomic(page);
 		BUG_ON(dd->namelen == 0);
 
 		if (name->len != be16_to_cpu(dd->namelen) ||
 				memcmp(name->name, dd->name, name->len)) {
-			kunmap_atomic(dd, KM_USER0);
+			kunmap_atomic(dd);
 			page_cache_release(page);
 			continue;
 		}
 
-		kunmap_atomic(dd, KM_USER0);
+		kunmap_atomic(dd);
 		return page;
 	}
 	return NULL;
@@ -365,9 +365,9 @@ static struct dentry *logfs_lookup(struct inode *dir, struct dentry *dentry,
 		return NULL;
 	}
 	index = page->index;
-	dd = kmap_atomic(page, KM_USER0);
+	dd = kmap_atomic(page);
 	ino = be64_to_cpu(dd->ino);
-	kunmap_atomic(dd, KM_USER0);
+	kunmap_atomic(dd);
 	page_cache_release(page);
 
 	inode = logfs_iget(dir->i_sb, ino);
@@ -402,12 +402,12 @@ static int logfs_write_dir(struct inode *dir, struct dentry *dentry,
 		if (!page)
 			return -ENOMEM;
 
-		dd = kmap_atomic(page, KM_USER0);
+		dd = kmap_atomic(page);
 		memset(dd, 0, sizeof(*dd));
 		dd->ino = cpu_to_be64(inode->i_ino);
 		dd->type = logfs_type(inode);
 		logfs_set_name(dd, &dentry->d_name);
-		kunmap_atomic(dd, KM_USER0);
+		kunmap_atomic(dd);
 
 		err = logfs_write_buf(dir, page, WF_LOCK);
 		unlock_page(page);
@@ -579,9 +579,9 @@ static int logfs_get_dd(struct inode *dir, struct dentry *dentry,
 	if (IS_ERR(page))
 		return PTR_ERR(page);
 	*pos = page->index;
-	map = kmap_atomic(page, KM_USER0);
+	map = kmap_atomic(page);
 	memcpy(dd, map, sizeof(*dd));
-	kunmap_atomic(map, KM_USER0);
+	kunmap_atomic(map);
 	page_cache_release(page);
 	return 0;
 }
diff --git a/fs/logfs/readwrite.c b/fs/logfs/readwrite.c
index 4153e65..e3ab5e5 100644
--- a/fs/logfs/readwrite.c
+++ b/fs/logfs/readwrite.c
@@ -517,9 +517,9 @@ static int indirect_write_alias(struct super_block *sb,
 
 		ino = page->mapping->host->i_ino;
 		logfs_unpack_index(page->index, &bix, &level);
-		child = kmap_atomic(page, KM_USER0);
+		child = kmap_atomic(page);
 		val = child[pos];
-		kunmap_atomic(child, KM_USER0);
+		kunmap_atomic(child);
 		err = write_one_alias(sb, ino, bix, level, pos, val);
 		if (err)
 			return err;
@@ -673,9 +673,9 @@ static void alloc_indirect_block(struct inode *inode, struct page *page,
 	alloc_data_block(inode, page);
 
 	block = logfs_block(page);
-	array = kmap_atomic(page, KM_USER0);
+	array = kmap_atomic(page);
 	initialize_block_counters(page, block, array, page_is_empty);
-	kunmap_atomic(array, KM_USER0);
+	kunmap_atomic(array);
 }
 
 static void block_set_pointer(struct page *page, int index, u64 ptr)
@@ -685,10 +685,10 @@ static void block_set_pointer(struct page *page, int index, u64 ptr)
 	u64 oldptr;
 
 	BUG_ON(!block);
-	array = kmap_atomic(page, KM_USER0);
+	array = kmap_atomic(page);
 	oldptr = be64_to_cpu(array[index]);
 	array[index] = cpu_to_be64(ptr);
-	kunmap_atomic(array, KM_USER0);
+	kunmap_atomic(array);
 	SetPageUptodate(page);
 
 	block->full += !!(ptr & LOGFS_FULLY_POPULATED)
@@ -701,9 +701,9 @@ static u64 block_get_pointer(struct page *page, int index)
 	__be64 *block;
 	u64 ptr;
 
-	block = kmap_atomic(page, KM_USER0);
+	block = kmap_atomic(page);
 	ptr = be64_to_cpu(block[index]);
-	kunmap_atomic(block, KM_USER0);
+	kunmap_atomic(block);
 	return ptr;
 }
 
@@ -850,7 +850,7 @@ static u64 seek_holedata_loop(struct inode *inode, u64 bix, int data)
 		}
 
 		slot = get_bits(bix, SUBLEVEL(level));
-		rblock = kmap_atomic(page, KM_USER0);
+		rblock = kmap_atomic(page);
 		while (slot < LOGFS_BLOCK_FACTOR) {
 			if (data && (rblock[slot] != 0))
 				break;
@@ -861,12 +861,12 @@ static u64 seek_holedata_loop(struct inode *inode, u64 bix, int data)
 			bix &= ~(increment - 1);
 		}
 		if (slot >= LOGFS_BLOCK_FACTOR) {
-			kunmap_atomic(rblock, KM_USER0);
+			kunmap_atomic(rblock);
 			logfs_put_read_page(page);
 			return bix;
 		}
 		bofs = be64_to_cpu(rblock[slot]);
-		kunmap_atomic(rblock, KM_USER0);
+		kunmap_atomic(rblock);
 		logfs_put_read_page(page);
 		if (!bofs) {
 			BUG_ON(data);
@@ -1961,9 +1961,9 @@ int logfs_read_inode(struct inode *inode)
 	if (IS_ERR(page))
 		return PTR_ERR(page);
 
-	di = kmap_atomic(page, KM_USER0);
+	di = kmap_atomic(page);
 	logfs_disk_to_inode(di, inode);
-	kunmap_atomic(di, KM_USER0);
+	kunmap_atomic(di);
 	move_page_to_inode(inode, page);
 	page_cache_release(page);
 	return 0;
@@ -1982,9 +1982,9 @@ static struct page *inode_to_page(struct inode *inode)
 	if (!page)
 		return NULL;
 
-	di = kmap_atomic(page, KM_USER0);
+	di = kmap_atomic(page);
 	logfs_inode_to_disk(inode, di);
-	kunmap_atomic(di, KM_USER0);
+	kunmap_atomic(di);
 	move_inode_to_page(page, inode);
 	return page;
 }
@@ -2041,13 +2041,13 @@ static void logfs_mod_segment_entry(struct super_block *sb, u32 segno,
 
 	if (write)
 		alloc_indirect_block(inode, page, 0);
-	se = kmap_atomic(page, KM_USER0);
+	se = kmap_atomic(page);
 	change_se(se + child_no, arg);
 	if (write) {
 		logfs_set_alias(sb, logfs_block(page), child_no);
 		BUG_ON((int)be32_to_cpu(se[child_no].valid) > super->s_segsize);
 	}
-	kunmap_atomic(se, KM_USER0);
+	kunmap_atomic(se);
 
 	logfs_put_write_page(page);
 }
@@ -2245,10 +2245,10 @@ int logfs_inode_write(struct inode *inode, const void *buf, size_t count,
 	if (!page)
 		return -ENOMEM;
 
-	pagebuf = kmap_atomic(page, KM_USER0);
+	pagebuf = kmap_atomic(page);
 	memcpy(pagebuf, buf, count);
 	flush_dcache_page(page);
-	kunmap_atomic(pagebuf, KM_USER0);
+	kunmap_atomic(pagebuf);
 
 	if (i_size_read(inode) < pos + LOGFS_BLOCKSIZE)
 		i_size_write(inode, pos + LOGFS_BLOCKSIZE);
diff --git a/fs/logfs/segment.c b/fs/logfs/segment.c
index ab798ed..e28d090 100644
--- a/fs/logfs/segment.c
+++ b/fs/logfs/segment.c
@@ -543,9 +543,9 @@ void move_page_to_btree(struct page *page)
 		BUG_ON(!item); /* mempool empty */
 		memset(item, 0, sizeof(*item));
 
-		child = kmap_atomic(page, KM_USER0);
+		child = kmap_atomic(page);
 		item->val = child[pos];
-		kunmap_atomic(child, KM_USER0);
+		kunmap_atomic(child);
 		item->child_no = pos;
 		list_add(&item->list, &block->item_list);
 	}
-- 
1.7.7.6

