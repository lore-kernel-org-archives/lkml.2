Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab0KKKOP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 05:14:15 -0500
Received: from mail.perches.com ([173.55.12.10]:4970 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649Ab0KKKOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 05:14:14 -0500
Subject: [PATCH] fs/affs/file.c: Use appropriate format types and casts
From: Joe Perches <joe@perches.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>
In-Reply-To: <AANLkTikQJS8GGEYoVRqGHkMCdw4p89ROBgvGMcJOWXwt@mail.gmail.com>
References: <cover.1289432524.git.joe@perches.com>
	 <61b367bd6aa6fc5664bce431f91f25f5cb2489f5.1289432524.git.joe@perches.com>
	 <AANLkTikQJS8GGEYoVRqGHkMCdw4p89ROBgvGMcJOWXwt@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Nov 2010 02:14:12 -0800
Message-ID: <1289470452.15905.178.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 10:20 +0100, Geert Uytterhoeven wrote:
> On Thu, Nov 11, 2010 at 00:46, Joe Perches <joe@perches.com> wrote:
> > Add __attribute__((format... to affs_error and affs_warning.
> You didn't fix any formats, you just added casts to silence the warnings?

I made them match the pr_debug uses.

Here's a patch to make the formats match the types
and use %llu and (unsigned long long) casts where
appropriate for the pr_debug as well as the affs_
uses.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/affs/file.c |   66 +++++++++++++++++++++++++++++++++++++------------------
 1 files changed, 44 insertions(+), 22 deletions(-)

diff --git a/fs/affs/file.c b/fs/affs/file.c
index 4c82c40..81f7805 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -46,7 +46,7 @@ const struct inode_operations affs_file_inode_operations = {
 static int
 affs_file_open(struct inode *inode, struct file *filp)
 {
-	pr_debug("AFFS: open(%lu,%d)\n",
+	pr_debug("AFFS: open(%lu, %d)\n",
 		 inode->i_ino, atomic_read(&AFFS_I(inode)->i_opencnt));
 	atomic_inc(&AFFS_I(inode)->i_opencnt);
 	return 0;
@@ -166,7 +166,8 @@ affs_alloc_extblock(struct inode *inode, struct buffer_head *bh, u32 ext)
 
 	tmp = be32_to_cpu(AFFS_TAIL(sb, bh)->extension);
 	if (tmp)
-		affs_warning(sb, "alloc_ext", "previous extension set (%x)", tmp);
+		affs_warning(sb, "alloc_ext", "previous extension set (%x)",
+			     tmp);
 	AFFS_TAIL(sb, bh)->extension = cpu_to_be32(blocknr);
 	affs_adjust_checksum(bh, blocknr - tmp);
 	mark_buffer_dirty_inode(bh, inode);
@@ -325,7 +326,8 @@ affs_get_block(struct inode *inode, sector_t block, struct buffer_head *bh_resul
 	struct buffer_head	*ext_bh;
 	u32			 ext;
 
-	pr_debug("AFFS: get_block(%u, %lu)\n", (u32)inode->i_ino, (unsigned long)block);
+	pr_debug("AFFS: get_block(%lu, %llu)\n",
+		 inode->i_ino, (unsigned long long)block);
 
 	BUG_ON(block > (sector_t)0x7fffffffUL);
 
@@ -355,8 +357,9 @@ affs_get_block(struct inode *inode, sector_t block, struct buffer_head *bh_resul
 
 		/* store new block */
 		if (bh_result->b_blocknr)
-			affs_warning(sb, "get_block", "block already set (%lx)",
-				     (unsigned long)bh_result->b_blocknr);
+			affs_warning(sb, "get_block",
+				     "block already set (%llx)",
+				     (unsigned long long)bh_result->b_blocknr);
 		AFFS_BLOCK(sb, ext_bh, block) = cpu_to_be32(blocknr);
 		AFFS_HEAD(ext_bh)->block_count = cpu_to_be32(block + 1);
 		affs_adjust_checksum(ext_bh, blocknr - bh_result->b_blocknr + 1);
@@ -366,7 +369,9 @@ affs_get_block(struct inode *inode, sector_t block, struct buffer_head *bh_resul
 			/* insert first block into header block */
 			u32 tmp = be32_to_cpu(AFFS_HEAD(ext_bh)->first_data);
 			if (tmp)
-				affs_warning(sb, "get_block", "first block already set (%d)", tmp);
+				affs_warning(sb, "get_block",
+					     "first block already set (%u)",
+					     tmp);
 			AFFS_HEAD(ext_bh)->first_data = cpu_to_be32(blocknr);
 			affs_adjust_checksum(ext_bh, blocknr - tmp);
 		}
@@ -378,8 +383,8 @@ affs_get_block(struct inode *inode, sector_t block, struct buffer_head *bh_resul
 	return 0;
 
 err_big:
-	affs_error(inode->i_sb,"get_block","strange block request %d",
-		   (int)block);
+	affs_error(inode->i_sb, "get_block", "strange block request %llu",
+		   (unsigned long long)block);
 	return -EIO;
 err_ext:
 	// unlock cache
@@ -504,7 +509,8 @@ affs_do_readpage_ofs(struct file *file, struct page *page, unsigned from, unsign
 	u32 bidx, boff, bsize;
 	u32 tmp;
 
-	pr_debug("AFFS: read_page(%u, %ld, %d, %d)\n", (u32)inode->i_ino, page->index, from, to);
+	pr_debug("AFFS: read_page(%lu, %ld, %d, %d)\n",
+		 inode->i_ino, page->index, from, to);
 	BUG_ON(from > to || to > PAGE_CACHE_SIZE);
 	kmap(page);
 	data = page_address(page);
@@ -539,7 +545,7 @@ affs_extent_file_ofs(struct inode *inode, u32 newsize)
 	u32 size, bsize;
 	u32 tmp;
 
-	pr_debug("AFFS: extent_file(%u, %d)\n", (u32)inode->i_ino, newsize);
+	pr_debug("AFFS: extent_file(%lu, %d)\n", inode->i_ino, newsize);
 	bsize = AFFS_SB(sb)->s_data_blksize;
 	bh = NULL;
 	size = AFFS_I(inode)->mmu_private;
@@ -580,7 +586,9 @@ affs_extent_file_ofs(struct inode *inode, u32 newsize)
 		if (prev_bh) {
 			u32 tmp = be32_to_cpu(AFFS_DATA_HEAD(prev_bh)->next);
 			if (tmp)
-				affs_warning(sb, "extent_file_ofs", "next block already set for %d (%d)", bidx, tmp);
+				affs_warning(sb, "extent_file_ofs",
+					     "next block already set for %u (%u)",
+					     bidx, tmp);
 			AFFS_DATA_HEAD(prev_bh)->next = cpu_to_be32(bh->b_blocknr);
 			affs_adjust_checksum(prev_bh, bh->b_blocknr - tmp);
 			mark_buffer_dirty_inode(prev_bh, inode);
@@ -605,7 +613,7 @@ affs_readpage_ofs(struct file *file, struct page *page)
 	u32 to;
 	int err;
 
-	pr_debug("AFFS: read_page(%u, %ld)\n", (u32)inode->i_ino, page->index);
+	pr_debug("AFFS: read_page(%lu, %ld)\n", inode->i_ino, page->index);
 	to = PAGE_CACHE_SIZE;
 	if (((page->index + 1) << PAGE_CACHE_SHIFT) > inode->i_size) {
 		to = inode->i_size & ~PAGE_CACHE_MASK;
@@ -628,7 +636,10 @@ static int affs_write_begin_ofs(struct file *file, struct address_space *mapping
 	pgoff_t index;
 	int err = 0;
 
-	pr_debug("AFFS: write_begin(%u, %llu, %llu)\n", (u32)inode->i_ino, (unsigned long long)pos, (unsigned long long)pos + len);
+	pr_debug("AFFS: write_begin(%lu, %llu, %llu)\n",
+		 inode->i_ino,
+		 (unsigned long long)pos,
+		 (unsigned long long)(pos + len));
 	if (pos > AFFS_I(inode)->mmu_private) {
 		/* XXX: this probably leaves a too-big i_size in case of
 		 * failure. Should really be updating i_size at write_end time
@@ -677,7 +688,10 @@ static int affs_write_end_ofs(struct file *file, struct address_space *mapping,
 	 * due to write_begin.
 	 */
 
-	pr_debug("AFFS: write_begin(%u, %llu, %llu)\n", (u32)inode->i_ino, (unsigned long long)pos, (unsigned long long)pos + len);
+	pr_debug("AFFS: write_begin(%lu, %llu, %llu)\n",
+		 inode->i_ino,
+		 (unsigned long long)pos,
+		 (unsigned long long)(pos + len));
 	bsize = AFFS_SB(sb)->s_data_blksize;
 	data = page_address(page);
 
@@ -720,7 +734,9 @@ static int affs_write_end_ofs(struct file *file, struct address_space *mapping,
 			if (prev_bh) {
 				u32 tmp = be32_to_cpu(AFFS_DATA_HEAD(prev_bh)->next);
 				if (tmp)
-					affs_warning(sb, "commit_write_ofs", "next block already set for %d (%d)", bidx, tmp);
+					affs_warning(sb, "commit_write_ofs",
+						     "next block already set for %u (%u)",
+						     bidx, tmp);
 				AFFS_DATA_HEAD(prev_bh)->next = cpu_to_be32(bh->b_blocknr);
 				affs_adjust_checksum(prev_bh, bh->b_blocknr - tmp);
 				mark_buffer_dirty_inode(prev_bh, inode);
@@ -751,7 +767,9 @@ static int affs_write_end_ofs(struct file *file, struct address_space *mapping,
 			if (prev_bh) {
 				u32 tmp = be32_to_cpu(AFFS_DATA_HEAD(prev_bh)->next);
 				if (tmp)
-					affs_warning(sb, "commit_write_ofs", "next block already set for %d (%d)", bidx, tmp);
+					affs_warning(sb, "commit_write_ofs",
+						     "next block already set for %u (%u)",
+						     bidx, tmp);
 				AFFS_DATA_HEAD(prev_bh)->next = cpu_to_be32(bh->b_blocknr);
 				affs_adjust_checksum(prev_bh, bh->b_blocknr - tmp);
 				mark_buffer_dirty_inode(prev_bh, inode);
@@ -820,8 +838,10 @@ affs_truncate(struct inode *inode)
 	struct buffer_head *ext_bh;
 	int i;
 
-	pr_debug("AFFS: truncate(inode=%d, oldsize=%u, newsize=%u)\n",
-		 (u32)inode->i_ino, (u32)AFFS_I(inode)->mmu_private, (u32)inode->i_size);
+	pr_debug("AFFS: truncate(inode=%lu, oldsize=%llu, newsize=%llu)\n",
+		 inode->i_ino,
+		 (unsigned long long)AFFS_I(inode)->mmu_private,
+		 (unsigned long long)inode->i_size);
 
 	last_blk = 0;
 	ext = 0;
@@ -850,8 +870,9 @@ affs_truncate(struct inode *inode)
 	// lock cache
 	ext_bh = affs_get_extblock(inode, ext);
 	if (IS_ERR(ext_bh)) {
-		affs_warning(sb, "truncate", "unexpected read error for ext block %u (%ld)",
-			     (unsigned int)ext, PTR_ERR(ext_bh));
+		affs_warning(sb, "truncate",
+			     "unexpected read error for ext block %u (%ld)",
+			     ext, PTR_ERR(ext_bh));
 		return;
 	}
 	if (AFFS_I(inode)->i_lc) {
@@ -897,8 +918,9 @@ affs_truncate(struct inode *inode)
 			struct buffer_head *bh = affs_bread_ino(inode, last_blk, 0);
 			u32 tmp;
 			if (IS_ERR(bh)) {
-				affs_warning(sb, "truncate", "unexpected read error for last block %u (%ld)",
-					     (unsigned int)ext, PTR_ERR(bh));
+				affs_warning(sb, "truncate",
+					     "unexpected read error for last block %u (%ld)",
+					     ext, PTR_ERR(bh));
 				return;
 			}
 			tmp = be32_to_cpu(AFFS_DATA_HEAD(bh)->next);


