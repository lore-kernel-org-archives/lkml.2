Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab1K0Fgs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 00:36:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754215Ab1K0Fgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 00:36:43 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Cong Wang <amwang@redhat.com>,
        Anton Altaparmakov <anton@tuxera.com>,
        linux-ntfs-dev@lists.sourceforge.net
Subject: [PATCH 43/62] ntfs: remove the second argument of k[un]map_atomic()
Date: Sun, 27 Nov 2011 13:27:23 +0800
Message-Id: <1322371662-26166-44-git-send-email-amwang@redhat.com>
In-Reply-To: <1322371662-26166-1-git-send-email-amwang@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Cong Wang <amwang@redhat.com>
---
 fs/ntfs/aops.c   |   20 ++++++++++----------
 fs/ntfs/attrib.c |   20 ++++++++++----------
 fs/ntfs/file.c   |   16 ++++++++--------
 fs/ntfs/super.c  |    8 ++++----
 4 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/fs/ntfs/aops.c b/fs/ntfs/aops.c
index 0b1e885b..fa9c05f 100644
--- a/fs/ntfs/aops.c
+++ b/fs/ntfs/aops.c
@@ -94,11 +94,11 @@ static void ntfs_end_buffer_async_read(struct buffer_head *bh, int uptodate)
 			if (file_ofs < init_size)
 				ofs = init_size - file_ofs;
 			local_irq_save(flags);
-			kaddr = kmap_atomic(page, KM_BIO_SRC_IRQ);
+			kaddr = kmap_atomic(page);
 			memset(kaddr + bh_offset(bh) + ofs, 0,
 					bh->b_size - ofs);
 			flush_dcache_page(page);
-			kunmap_atomic(kaddr, KM_BIO_SRC_IRQ);
+			kunmap_atomic(kaddr);
 			local_irq_restore(flags);
 		}
 	} else {
@@ -147,11 +147,11 @@ static void ntfs_end_buffer_async_read(struct buffer_head *bh, int uptodate)
 		/* Should have been verified before we got here... */
 		BUG_ON(!recs);
 		local_irq_save(flags);
-		kaddr = kmap_atomic(page, KM_BIO_SRC_IRQ);
+		kaddr = kmap_atomic(page);
 		for (i = 0; i < recs; i++)
 			post_read_mst_fixup((NTFS_RECORD*)(kaddr +
 					i * rec_size), rec_size);
-		kunmap_atomic(kaddr, KM_BIO_SRC_IRQ);
+		kunmap_atomic(kaddr);
 		local_irq_restore(flags);
 		flush_dcache_page(page);
 		if (likely(page_uptodate && !PageError(page)))
@@ -504,7 +504,7 @@ retry_readpage:
 		/* Race with shrinking truncate. */
 		attr_len = i_size;
 	}
-	addr = kmap_atomic(page, KM_USER0);
+	addr = kmap_atomic(page);
 	/* Copy the data to the page. */
 	memcpy(addr, (u8*)ctx->attr +
 			le16_to_cpu(ctx->attr->data.resident.value_offset),
@@ -512,7 +512,7 @@ retry_readpage:
 	/* Zero the remainder of the page. */
 	memset(addr + attr_len, 0, PAGE_CACHE_SIZE - attr_len);
 	flush_dcache_page(page);
-	kunmap_atomic(addr, KM_USER0);
+	kunmap_atomic(addr);
 put_unm_err_out:
 	ntfs_attr_put_search_ctx(ctx);
 unm_err_out:
@@ -746,14 +746,14 @@ lock_retry_remap:
 			unsigned long *bpos, *bend;
 
 			/* Check if the buffer is zero. */
-			kaddr = kmap_atomic(page, KM_USER0);
+			kaddr = kmap_atomic(page);
 			bpos = (unsigned long *)(kaddr + bh_offset(bh));
 			bend = (unsigned long *)((u8*)bpos + blocksize);
 			do {
 				if (unlikely(*bpos))
 					break;
 			} while (likely(++bpos < bend));
-			kunmap_atomic(kaddr, KM_USER0);
+			kunmap_atomic(kaddr);
 			if (bpos == bend) {
 				/*
 				 * Buffer is zero and sparse, no need to write
@@ -1495,14 +1495,14 @@ retry_writepage:
 		/* Shrinking cannot fail. */
 		BUG_ON(err);
 	}
-	addr = kmap_atomic(page, KM_USER0);
+	addr = kmap_atomic(page);
 	/* Copy the data from the page to the mft record. */
 	memcpy((u8*)ctx->attr +
 			le16_to_cpu(ctx->attr->data.resident.value_offset),
 			addr, attr_len);
 	/* Zero out of bounds area in the page cache page. */
 	memset(addr + attr_len, 0, PAGE_CACHE_SIZE - attr_len);
-	kunmap_atomic(addr, KM_USER0);
+	kunmap_atomic(addr);
 	flush_dcache_page(page);
 	flush_dcache_mft_record_page(ctx->ntfs_ino);
 	/* We are done with the page. */
diff --git a/fs/ntfs/attrib.c b/fs/ntfs/attrib.c
index f14fde2..08c9bcd 100644
--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -1656,12 +1656,12 @@ int ntfs_attr_make_non_resident(ntfs_inode *ni, const u32 data_size)
 	attr_size = le32_to_cpu(a->data.resident.value_length);
 	BUG_ON(attr_size != data_size);
 	if (page && !PageUptodate(page)) {
-		kaddr = kmap_atomic(page, KM_USER0);
+		kaddr = kmap_atomic(page);
 		memcpy(kaddr, (u8*)a +
 				le16_to_cpu(a->data.resident.value_offset),
 				attr_size);
 		memset(kaddr + attr_size, 0, PAGE_CACHE_SIZE - attr_size);
-		kunmap_atomic(kaddr, KM_USER0);
+		kunmap_atomic(kaddr);
 		flush_dcache_page(page);
 		SetPageUptodate(page);
 	}
@@ -1806,9 +1806,9 @@ undo_err_out:
 			sizeof(a->data.resident.reserved));
 	/* Copy the data from the page back to the attribute value. */
 	if (page) {
-		kaddr = kmap_atomic(page, KM_USER0);
+		kaddr = kmap_atomic(page);
 		memcpy((u8*)a + mp_ofs, kaddr, attr_size);
-		kunmap_atomic(kaddr, KM_USER0);
+		kunmap_atomic(kaddr);
 	}
 	/* Setup the allocated size in the ntfs inode in case it changed. */
 	write_lock_irqsave(&ni->size_lock, flags);
@@ -2540,10 +2540,10 @@ int ntfs_attr_set(ntfs_inode *ni, const s64 ofs, const s64 cnt, const u8 val)
 		size = PAGE_CACHE_SIZE;
 		if (idx == end)
 			size = end_ofs;
-		kaddr = kmap_atomic(page, KM_USER0);
+		kaddr = kmap_atomic(page);
 		memset(kaddr + start_ofs, val, size - start_ofs);
 		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
+		kunmap_atomic(kaddr);
 		set_page_dirty(page);
 		page_cache_release(page);
 		balance_dirty_pages_ratelimited(mapping);
@@ -2561,10 +2561,10 @@ int ntfs_attr_set(ntfs_inode *ni, const s64 ofs, const s64 cnt, const u8 val)
 					"page (index 0x%lx).", idx);
 			return -ENOMEM;
 		}
-		kaddr = kmap_atomic(page, KM_USER0);
+		kaddr = kmap_atomic(page);
 		memset(kaddr, val, PAGE_CACHE_SIZE);
 		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
+		kunmap_atomic(kaddr);
 		/*
 		 * If the page has buffers, mark them uptodate since buffer
 		 * state and not page state is definitive in 2.6 kernels.
@@ -2598,10 +2598,10 @@ int ntfs_attr_set(ntfs_inode *ni, const s64 ofs, const s64 cnt, const u8 val)
 					"(error, index 0x%lx).", idx);
 			return PTR_ERR(page);
 		}
-		kaddr = kmap_atomic(page, KM_USER0);
+		kaddr = kmap_atomic(page);
 		memset(kaddr, val, end_ofs);
 		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
+		kunmap_atomic(kaddr);
 		set_page_dirty(page);
 		page_cache_release(page);
 		balance_dirty_pages_ratelimited(mapping);
diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index c587e2d..8639169 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -704,7 +704,7 @@ map_buffer_cached:
 				u8 *kaddr;
 				unsigned pofs;
 					
-				kaddr = kmap_atomic(page, KM_USER0);
+				kaddr = kmap_atomic(page);
 				if (bh_pos < pos) {
 					pofs = bh_pos & ~PAGE_CACHE_MASK;
 					memset(kaddr + pofs, 0, pos - bh_pos);
@@ -713,7 +713,7 @@ map_buffer_cached:
 					pofs = end & ~PAGE_CACHE_MASK;
 					memset(kaddr + pofs, 0, bh_end - end);
 				}
-				kunmap_atomic(kaddr, KM_USER0);
+				kunmap_atomic(kaddr);
 				flush_dcache_page(page);
 			}
 			continue;
@@ -1287,9 +1287,9 @@ static inline size_t ntfs_copy_from_user(struct page **pages,
 		len = PAGE_CACHE_SIZE - ofs;
 		if (len > bytes)
 			len = bytes;
-		addr = kmap_atomic(*pages, KM_USER0);
+		addr = kmap_atomic(*pages);
 		left = __copy_from_user_inatomic(addr + ofs, buf, len);
-		kunmap_atomic(addr, KM_USER0);
+		kunmap_atomic(addr);
 		if (unlikely(left)) {
 			/* Do it the slow way. */
 			addr = kmap(*pages);
@@ -1401,10 +1401,10 @@ static inline size_t ntfs_copy_from_user_iovec(struct page **pages,
 		len = PAGE_CACHE_SIZE - ofs;
 		if (len > bytes)
 			len = bytes;
-		addr = kmap_atomic(*pages, KM_USER0);
+		addr = kmap_atomic(*pages);
 		copied = __ntfs_copy_from_user_iovec_inatomic(addr + ofs,
 				*iov, *iov_ofs, len);
-		kunmap_atomic(addr, KM_USER0);
+		kunmap_atomic(addr);
 		if (unlikely(copied != len)) {
 			/* Do it the slow way. */
 			addr = kmap(*pages);
@@ -1691,7 +1691,7 @@ static int ntfs_commit_pages_after_write(struct page **pages,
 	BUG_ON(end > le32_to_cpu(a->length) -
 			le16_to_cpu(a->data.resident.value_offset));
 	kattr = (u8*)a + le16_to_cpu(a->data.resident.value_offset);
-	kaddr = kmap_atomic(page, KM_USER0);
+	kaddr = kmap_atomic(page);
 	/* Copy the received data from the page to the mft record. */
 	memcpy(kattr + pos, kaddr + pos, bytes);
 	/* Update the attribute length if necessary. */
@@ -1713,7 +1713,7 @@ static int ntfs_commit_pages_after_write(struct page **pages,
 		flush_dcache_page(page);
 		SetPageUptodate(page);
 	}
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 	/* Update initialized_size/i_size if necessary. */
 	read_lock_irqsave(&ni->size_lock, flags);
 	initialized_size = ni->initialized_size;
diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index b52706d..2978cd3 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -2475,7 +2475,7 @@ static s64 get_nr_free_clusters(ntfs_volume *vol)
 			nr_free -= PAGE_CACHE_SIZE * 8;
 			continue;
 		}
-		kaddr = kmap_atomic(page, KM_USER0);
+		kaddr = kmap_atomic(page);
 		/*
 		 * Subtract the number of set bits. If this
 		 * is the last page and it is partial we don't really care as
@@ -2485,7 +2485,7 @@ static s64 get_nr_free_clusters(ntfs_volume *vol)
 		 */
 		nr_free -= bitmap_weight(kaddr,
 					PAGE_CACHE_SIZE * BITS_PER_BYTE);
-		kunmap_atomic(kaddr, KM_USER0);
+		kunmap_atomic(kaddr);
 		page_cache_release(page);
 	}
 	ntfs_debug("Finished reading $Bitmap, last index = 0x%lx.", index - 1);
@@ -2546,7 +2546,7 @@ static unsigned long __get_nr_free_mft_records(ntfs_volume *vol,
 			nr_free -= PAGE_CACHE_SIZE * 8;
 			continue;
 		}
-		kaddr = kmap_atomic(page, KM_USER0);
+		kaddr = kmap_atomic(page);
 		/*
 		 * Subtract the number of set bits. If this
 		 * is the last page and it is partial we don't really care as
@@ -2556,7 +2556,7 @@ static unsigned long __get_nr_free_mft_records(ntfs_volume *vol,
 		 */
 		nr_free -= bitmap_weight(kaddr,
 					PAGE_CACHE_SIZE * BITS_PER_BYTE);
-		kunmap_atomic(kaddr, KM_USER0);
+		kunmap_atomic(kaddr);
 		page_cache_release(page);
 	}
 	ntfs_debug("Finished reading $MFT/$BITMAP, last index = 0x%lx.",
-- 
1.7.4.4

