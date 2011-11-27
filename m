Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab1K0Fgk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 00:36:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754215Ab1K0Fgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 00:36:36 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Cong Wang <amwang@redhat.com>,
        KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>,
        linux-nilfs@vger.kernel.org
Subject: [PATCH 42/62] nilfs2: remove the second argument of k[un]map_atomic()
Date: Sun, 27 Nov 2011 13:27:22 +0800
Message-Id: <1322371662-26166-43-git-send-email-amwang@redhat.com>
In-Reply-To: <1322371662-26166-1-git-send-email-amwang@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Cong Wang <amwang@redhat.com>
---
 fs/nilfs2/cpfile.c   |   94 +++++++++++++++++++++++++-------------------------
 fs/nilfs2/dat.c      |   38 ++++++++++----------
 fs/nilfs2/dir.c      |    4 +-
 fs/nilfs2/ifile.c    |    4 +-
 fs/nilfs2/mdt.c      |    4 +-
 fs/nilfs2/page.c     |    8 ++--
 fs/nilfs2/recovery.c |    4 +-
 fs/nilfs2/segbuf.c   |    4 +-
 fs/nilfs2/sufile.c   |   68 ++++++++++++++++++------------------
 9 files changed, 114 insertions(+), 114 deletions(-)

diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index c9b342c..dab5c4c 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -218,11 +218,11 @@ int nilfs_cpfile_get_checkpoint(struct inode *cpfile,
 								 kaddr, 1);
 		mark_buffer_dirty(cp_bh);
 
-		kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
+		kaddr = kmap_atomic(header_bh->b_page);
 		header = nilfs_cpfile_block_get_header(cpfile, header_bh,
 						       kaddr);
 		le64_add_cpu(&header->ch_ncheckpoints, 1);
-		kunmap_atomic(kaddr, KM_USER0);
+		kunmap_atomic(kaddr);
 		mark_buffer_dirty(header_bh);
 		nilfs_mdt_mark_dirty(cpfile);
 	}
@@ -313,7 +313,7 @@ int nilfs_cpfile_delete_checkpoints(struct inode *cpfile,
 			continue;
 		}
 
-		kaddr = kmap_atomic(cp_bh->b_page, KM_USER0);
+		kaddr = kmap_atomic(cp_bh->b_page);
 		cp = nilfs_cpfile_block_get_checkpoint(
 			cpfile, cno, cp_bh, kaddr);
 		nicps = 0;
@@ -334,7 +334,7 @@ int nilfs_cpfile_delete_checkpoints(struct inode *cpfile,
 						cpfile, cp_bh, kaddr, nicps);
 				if (count == 0) {
 					/* make hole */
-					kunmap_atomic(kaddr, KM_USER0);
+					kunmap_atomic(kaddr);
 					brelse(cp_bh);
 					ret =
 					  nilfs_cpfile_delete_checkpoint_block(
@@ -349,18 +349,18 @@ int nilfs_cpfile_delete_checkpoints(struct inode *cpfile,
 			}
 		}
 
-		kunmap_atomic(kaddr, KM_USER0);
+		kunmap_atomic(kaddr);
 		brelse(cp_bh);
 	}
 
 	if (tnicps > 0) {
-		kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
+		kaddr = kmap_atomic(header_bh->b_page);
 		header = nilfs_cpfile_block_get_header(cpfile, header_bh,
 						       kaddr);
 		le64_add_cpu(&header->ch_ncheckpoints, -(u64)tnicps);
 		mark_buffer_dirty(header_bh);
 		nilfs_mdt_mark_dirty(cpfile);
-		kunmap_atomic(kaddr, KM_USER0);
+		kunmap_atomic(kaddr);
 	}
 
 	brelse(header_bh);
@@ -408,7 +408,7 @@ static ssize_t nilfs_cpfile_do_get_cpinfo(struct inode *cpfile, __u64 *cnop,
 			continue; /* skip hole */
 		}
 
-		kaddr = kmap_atomic(bh->b_page, KM_USER0);
+		kaddr = kmap_atomic(bh->b_page);
 		cp = nilfs_cpfile_block_get_checkpoint(cpfile, cno, bh, kaddr);
 		for (i = 0; i < ncps && n < nci; i++, cp = (void *)cp + cpsz) {
 			if (!nilfs_checkpoint_invalid(cp)) {
@@ -418,7 +418,7 @@ static ssize_t nilfs_cpfile_do_get_cpinfo(struct inode *cpfile, __u64 *cnop,
 				n++;
 			}
 		}
-		kunmap_atomic(kaddr, KM_USER0);
+		kunmap_atomic(kaddr);
 		brelse(bh);
 	}
 
@@ -451,10 +451,10 @@ static ssize_t nilfs_cpfile_do_get_ssinfo(struct inode *cpfile, __u64 *cnop,
 		ret = nilfs_cpfile_get_header_block(cpfile, &bh);
 		if (ret < 0)
 			goto out;
-		kaddr = kmap_atomic(bh->b_page, KM_USER0);
+		kaddr = kmap_atomic(bh->b_page);
 		header = nilfs_cpfile_block_get_header(cpfile, bh, kaddr);
 		curr = le64_to_cpu(header->ch_snapshot_list.ssl_next);
-		kunmap_atomic(kaddr, KM_USER0);
+		kunmap_atomic(kaddr);
 		brelse(bh);
 		if (curr == 0) {
 			ret = 0;
@@ -472,7 +472,7 @@ static ssize_t nilfs_cpfile_do_get_ssinfo(struct inode *cpfile, __u64 *cnop,
 			ret = 0; /* No snapshots (started from a hole block) */
 		goto out;
 	}
-	kaddr = kmap_atomic(bh->b_page, KM_USER0);
+	kaddr = kmap_atomic(bh->b_page);
 	while (n < nci) {
 		cp = nilfs_cpfile_block_get_checkpoint(cpfile, curr, bh, kaddr);
 		curr = ~(__u64)0; /* Terminator */
@@ -488,7 +488,7 @@ static ssize_t nilfs_cpfile_do_get_ssinfo(struct inode *cpfile, __u64 *cnop,
 
 		next_blkoff = nilfs_cpfile_get_blkoff(cpfile, next);
 		if (curr_blkoff != next_blkoff) {
-			kunmap_atomic(kaddr, KM_USER0);
+			kunmap_atomic(kaddr);
 			brelse(bh);
 			ret = nilfs_cpfile_get_checkpoint_block(cpfile, next,
 								0, &bh);
@@ -496,12 +496,12 @@ static ssize_t nilfs_cpfile_do_get_ssinfo(struct inode *cpfile, __u64 *cnop,
 				WARN_ON(ret == -ENOENT);
 				goto out;
 			}
-			kaddr = kmap_atomic(bh->b_page, KM_USER0);
+			kaddr = kmap_atomic(bh->b_page);
 		}
 		curr = next;
 		curr_blkoff = next_blkoff;
 	}
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 	brelse(bh);
 	*cnop = curr;
 	ret = n;
@@ -592,24 +592,24 @@ static int nilfs_cpfile_set_snapshot(struct inode *cpfile, __u64 cno)
 	ret = nilfs_cpfile_get_checkpoint_block(cpfile, cno, 0, &cp_bh);
 	if (ret < 0)
 		goto out_sem;
-	kaddr = kmap_atomic(cp_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic(cp_bh->b_page);
 	cp = nilfs_cpfile_block_get_checkpoint(cpfile, cno, cp_bh, kaddr);
 	if (nilfs_checkpoint_invalid(cp)) {
 		ret = -ENOENT;
-		kunmap_atomic(kaddr, KM_USER0);
+		kunmap_atomic(kaddr);
 		goto out_cp;
 	}
 	if (nilfs_checkpoint_snapshot(cp)) {
 		ret = 0;
-		kunmap_atomic(kaddr, KM_USER0);
+		kunmap_atomic(kaddr);
 		goto out_cp;
 	}
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 
 	ret = nilfs_cpfile_get_header_block(cpfile, &header_bh);
 	if (ret < 0)
 		goto out_cp;
-	kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic(header_bh->b_page);
 	header = nilfs_cpfile_block_get_header(cpfile, header_bh, kaddr);
 	list = &header->ch_snapshot_list;
 	curr_bh = header_bh;
@@ -621,13 +621,13 @@ static int nilfs_cpfile_set_snapshot(struct inode *cpfile, __u64 cno)
 		prev_blkoff = nilfs_cpfile_get_blkoff(cpfile, prev);
 		curr = prev;
 		if (curr_blkoff != prev_blkoff) {
-			kunmap_atomic(kaddr, KM_USER0);
+			kunmap_atomic(kaddr);
 			brelse(curr_bh);
 			ret = nilfs_cpfile_get_checkpoint_block(cpfile, curr,
 								0, &curr_bh);
 			if (ret < 0)
 				goto out_header;
-			kaddr = kmap_atomic(curr_bh->b_page, KM_USER0);
+			kaddr = kmap_atomic(curr_bh->b_page);
 		}
 		curr_blkoff = prev_blkoff;
 		cp = nilfs_cpfile_block_get_checkpoint(
@@ -635,7 +635,7 @@ static int nilfs_cpfile_set_snapshot(struct inode *cpfile, __u64 cno)
 		list = &cp->cp_snapshot_list;
 		prev = le64_to_cpu(list->ssl_prev);
 	}
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 
 	if (prev != 0) {
 		ret = nilfs_cpfile_get_checkpoint_block(cpfile, prev, 0,
@@ -647,29 +647,29 @@ static int nilfs_cpfile_set_snapshot(struct inode *cpfile, __u64 cno)
 		get_bh(prev_bh);
 	}
 
-	kaddr = kmap_atomic(curr_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic(curr_bh->b_page);
 	list = nilfs_cpfile_block_get_snapshot_list(
 		cpfile, curr, curr_bh, kaddr);
 	list->ssl_prev = cpu_to_le64(cno);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 
-	kaddr = kmap_atomic(cp_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic(cp_bh->b_page);
 	cp = nilfs_cpfile_block_get_checkpoint(cpfile, cno, cp_bh, kaddr);
 	cp->cp_snapshot_list.ssl_next = cpu_to_le64(curr);
 	cp->cp_snapshot_list.ssl_prev = cpu_to_le64(prev);
 	nilfs_checkpoint_set_snapshot(cp);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 
-	kaddr = kmap_atomic(prev_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic(prev_bh->b_page);
 	list = nilfs_cpfile_block_get_snapshot_list(
 		cpfile, prev, prev_bh, kaddr);
 	list->ssl_next = cpu_to_le64(cno);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 
-	kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic(header_bh->b_page);
 	header = nilfs_cpfile_block_get_header(cpfile, header_bh, kaddr);
 	le64_add_cpu(&header->ch_nsnapshots, 1);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 
 	mark_buffer_dirty(prev_bh);
 	mark_buffer_dirty(curr_bh);
@@ -710,23 +710,23 @@ static int nilfs_cpfile_clear_snapshot(struct inode *cpfile, __u64 cno)
 	ret = nilfs_cpfile_get_checkpoint_block(cpfile, cno, 0, &cp_bh);
 	if (ret < 0)
 		goto out_sem;
-	kaddr = kmap_atomic(cp_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic(cp_bh->b_page);
 	cp = nilfs_cpfile_block_get_checkpoint(cpfile, cno, cp_bh, kaddr);
 	if (nilfs_checkpoint_invalid(cp)) {
 		ret = -ENOENT;
-		kunmap_atomic(kaddr, KM_USER0);
+		kunmap_atomic(kaddr);
 		goto out_cp;
 	}
 	if (!nilfs_checkpoint_snapshot(cp)) {
 		ret = 0;
-		kunmap_atomic(kaddr, KM_USER0);
+		kunmap_atomic(kaddr);
 		goto out_cp;
 	}
 
 	list = &cp->cp_snapshot_list;
 	next = le64_to_cpu(list->ssl_next);
 	prev = le64_to_cpu(list->ssl_prev);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 
 	ret = nilfs_cpfile_get_header_block(cpfile, &header_bh);
 	if (ret < 0)
@@ -750,29 +750,29 @@ static int nilfs_cpfile_clear_snapshot(struct inode *cpfile, __u64 cno)
 		get_bh(prev_bh);
 	}
 
-	kaddr = kmap_atomic(next_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic(next_bh->b_page);
 	list = nilfs_cpfile_block_get_snapshot_list(
 		cpfile, next, next_bh, kaddr);
 	list->ssl_prev = cpu_to_le64(prev);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 
-	kaddr = kmap_atomic(prev_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic(prev_bh->b_page);
 	list = nilfs_cpfile_block_get_snapshot_list(
 		cpfile, prev, prev_bh, kaddr);
 	list->ssl_next = cpu_to_le64(next);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 
-	kaddr = kmap_atomic(cp_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic(cp_bh->b_page);
 	cp = nilfs_cpfile_block_get_checkpoint(cpfile, cno, cp_bh, kaddr);
 	cp->cp_snapshot_list.ssl_next = cpu_to_le64(0);
 	cp->cp_snapshot_list.ssl_prev = cpu_to_le64(0);
 	nilfs_checkpoint_clear_snapshot(cp);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 
-	kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic(header_bh->b_page);
 	header = nilfs_cpfile_block_get_header(cpfile, header_bh, kaddr);
 	le64_add_cpu(&header->ch_nsnapshots, -1);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 
 	mark_buffer_dirty(next_bh);
 	mark_buffer_dirty(prev_bh);
@@ -829,13 +829,13 @@ int nilfs_cpfile_is_snapshot(struct inode *cpfile, __u64 cno)
 	ret = nilfs_cpfile_get_checkpoint_block(cpfile, cno, 0, &bh);
 	if (ret < 0)
 		goto out;
-	kaddr = kmap_atomic(bh->b_page, KM_USER0);
+	kaddr = kmap_atomic(bh->b_page);
 	cp = nilfs_cpfile_block_get_checkpoint(cpfile, cno, bh, kaddr);
 	if (nilfs_checkpoint_invalid(cp))
 		ret = -ENOENT;
 	else
 		ret = nilfs_checkpoint_snapshot(cp);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 	brelse(bh);
 
  out:
@@ -912,12 +912,12 @@ int nilfs_cpfile_get_stat(struct inode *cpfile, struct nilfs_cpstat *cpstat)
 	ret = nilfs_cpfile_get_header_block(cpfile, &bh);
 	if (ret < 0)
 		goto out_sem;
-	kaddr = kmap_atomic(bh->b_page, KM_USER0);
+	kaddr = kmap_atomic(bh->b_page);
 	header = nilfs_cpfile_block_get_header(cpfile, bh, kaddr);
 	cpstat->cs_cno = nilfs_mdt_cno(cpfile);
 	cpstat->cs_ncps = le64_to_cpu(header->ch_ncheckpoints);
 	cpstat->cs_nsss = le64_to_cpu(header->ch_nsnapshots);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 	brelse(bh);
 
  out_sem:
diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index fcc2f86..b5c13f3 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -85,13 +85,13 @@ void nilfs_dat_commit_alloc(struct inode *dat, struct nilfs_palloc_req *req)
 	struct nilfs_dat_entry *entry;
 	void *kaddr;
 
-	kaddr = kmap_atomic(req->pr_entry_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic(req->pr_entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
 					     req->pr_entry_bh, kaddr);
 	entry->de_start = cpu_to_le64(NILFS_CNO_MIN);
 	entry->de_end = cpu_to_le64(NILFS_CNO_MAX);
 	entry->de_blocknr = cpu_to_le64(0);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 
 	nilfs_palloc_commit_alloc_entry(dat, req);
 	nilfs_dat_commit_entry(dat, req);
@@ -109,13 +109,13 @@ static void nilfs_dat_commit_free(struct inode *dat,
 	struct nilfs_dat_entry *entry;
 	void *kaddr;
 
-	kaddr = kmap_atomic(req->pr_entry_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic(req->pr_entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
 					     req->pr_entry_bh, kaddr);
 	entry->de_start = cpu_to_le64(NILFS_CNO_MIN);
 	entry->de_end = cpu_to_le64(NILFS_CNO_MIN);
 	entry->de_blocknr = cpu_to_le64(0);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 
 	nilfs_dat_commit_entry(dat, req);
 	nilfs_palloc_commit_free_entry(dat, req);
@@ -136,12 +136,12 @@ void nilfs_dat_commit_start(struct inode *dat, struct nilfs_palloc_req *req,
 	struct nilfs_dat_entry *entry;
 	void *kaddr;
 
-	kaddr = kmap_atomic(req->pr_entry_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic(req->pr_entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
 					     req->pr_entry_bh, kaddr);
 	entry->de_start = cpu_to_le64(nilfs_mdt_cno(dat));
 	entry->de_blocknr = cpu_to_le64(blocknr);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 
 	nilfs_dat_commit_entry(dat, req);
 }
@@ -160,12 +160,12 @@ int nilfs_dat_prepare_end(struct inode *dat, struct nilfs_palloc_req *req)
 		return ret;
 	}
 
-	kaddr = kmap_atomic(req->pr_entry_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic(req->pr_entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
 					     req->pr_entry_bh, kaddr);
 	start = le64_to_cpu(entry->de_start);
 	blocknr = le64_to_cpu(entry->de_blocknr);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 
 	if (blocknr == 0) {
 		ret = nilfs_palloc_prepare_free_entry(dat, req);
@@ -186,7 +186,7 @@ void nilfs_dat_commit_end(struct inode *dat, struct nilfs_palloc_req *req,
 	sector_t blocknr;
 	void *kaddr;
 
-	kaddr = kmap_atomic(req->pr_entry_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic(req->pr_entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
 					     req->pr_entry_bh, kaddr);
 	end = start = le64_to_cpu(entry->de_start);
@@ -196,7 +196,7 @@ void nilfs_dat_commit_end(struct inode *dat, struct nilfs_palloc_req *req,
 	}
 	entry->de_end = cpu_to_le64(end);
 	blocknr = le64_to_cpu(entry->de_blocknr);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 
 	if (blocknr == 0)
 		nilfs_dat_commit_free(dat, req);
@@ -211,12 +211,12 @@ void nilfs_dat_abort_end(struct inode *dat, struct nilfs_palloc_req *req)
 	sector_t blocknr;
 	void *kaddr;
 
-	kaddr = kmap_atomic(req->pr_entry_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic(req->pr_entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
 					     req->pr_entry_bh, kaddr);
 	start = le64_to_cpu(entry->de_start);
 	blocknr = le64_to_cpu(entry->de_blocknr);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 
 	if (start == nilfs_mdt_cno(dat) && blocknr == 0)
 		nilfs_palloc_abort_free_entry(dat, req);
@@ -346,20 +346,20 @@ int nilfs_dat_move(struct inode *dat, __u64 vblocknr, sector_t blocknr)
 		}
 	}
 
-	kaddr = kmap_atomic(entry_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic(entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, vblocknr, entry_bh, kaddr);
 	if (unlikely(entry->de_blocknr == cpu_to_le64(0))) {
 		printk(KERN_CRIT "%s: vbn = %llu, [%llu, %llu)\n", __func__,
 		       (unsigned long long)vblocknr,
 		       (unsigned long long)le64_to_cpu(entry->de_start),
 		       (unsigned long long)le64_to_cpu(entry->de_end));
-		kunmap_atomic(kaddr, KM_USER0);
+		kunmap_atomic(kaddr);
 		brelse(entry_bh);
 		return -EINVAL;
 	}
 	WARN_ON(blocknr == 0);
 	entry->de_blocknr = cpu_to_le64(blocknr);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 
 	mark_buffer_dirty(entry_bh);
 	nilfs_mdt_mark_dirty(dat);
@@ -409,7 +409,7 @@ int nilfs_dat_translate(struct inode *dat, __u64 vblocknr, sector_t *blocknrp)
 		}
 	}
 
-	kaddr = kmap_atomic(entry_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic(entry_bh->b_page);
 	entry = nilfs_palloc_block_get_entry(dat, vblocknr, entry_bh, kaddr);
 	blocknr = le64_to_cpu(entry->de_blocknr);
 	if (blocknr == 0) {
@@ -419,7 +419,7 @@ int nilfs_dat_translate(struct inode *dat, __u64 vblocknr, sector_t *blocknrp)
 	*blocknrp = blocknr;
 
  out:
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 	brelse(entry_bh);
 	return ret;
 }
@@ -440,7 +440,7 @@ ssize_t nilfs_dat_get_vinfo(struct inode *dat, void *buf, unsigned visz,
 						   0, &entry_bh);
 		if (ret < 0)
 			return ret;
-		kaddr = kmap_atomic(entry_bh->b_page, KM_USER0);
+		kaddr = kmap_atomic(entry_bh->b_page);
 		/* last virtual block number in this block */
 		first = vinfo->vi_vblocknr;
 		do_div(first, entries_per_block);
@@ -456,7 +456,7 @@ ssize_t nilfs_dat_get_vinfo(struct inode *dat, void *buf, unsigned visz,
 			vinfo->vi_end = le64_to_cpu(entry->de_end);
 			vinfo->vi_blocknr = le64_to_cpu(entry->de_blocknr);
 		}
-		kunmap_atomic(kaddr, KM_USER0);
+		kunmap_atomic(kaddr);
 		brelse(entry_bh);
 	}
 
diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index 3a19239..53ed93a 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -602,7 +602,7 @@ int nilfs_make_empty(struct inode *inode, struct inode *parent)
 		unlock_page(page);
 		goto fail;
 	}
-	kaddr = kmap_atomic(page, KM_USER0);
+	kaddr = kmap_atomic(page);
 	memset(kaddr, 0, chunk_size);
 	de = (struct nilfs_dir_entry *)kaddr;
 	de->name_len = 1;
@@ -617,7 +617,7 @@ int nilfs_make_empty(struct inode *inode, struct inode *parent)
 	de->inode = cpu_to_le64(parent->i_ino);
 	memcpy(de->name, "..\0", 4);
 	nilfs_set_de_type(de, inode);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 	nilfs_commit_chunk(page, mapping, 0, chunk_size);
 fail:
 	page_cache_release(page);
diff --git a/fs/nilfs2/ifile.c b/fs/nilfs2/ifile.c
index 684d763..5a48df7 100644
--- a/fs/nilfs2/ifile.c
+++ b/fs/nilfs2/ifile.c
@@ -122,11 +122,11 @@ int nilfs_ifile_delete_inode(struct inode *ifile, ino_t ino)
 		return ret;
 	}
 
-	kaddr = kmap_atomic(req.pr_entry_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic(req.pr_entry_bh->b_page);
 	raw_inode = nilfs_palloc_block_get_entry(ifile, req.pr_entry_nr,
 						 req.pr_entry_bh, kaddr);
 	raw_inode->i_flags = 0;
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 
 	mark_buffer_dirty(req.pr_entry_bh);
 	brelse(req.pr_entry_bh);
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 800e8d7..f9897d0 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -58,12 +58,12 @@ nilfs_mdt_insert_new_block(struct inode *inode, unsigned long block,
 
 	set_buffer_mapped(bh);
 
-	kaddr = kmap_atomic(bh->b_page, KM_USER0);
+	kaddr = kmap_atomic(bh->b_page);
 	memset(kaddr + bh_offset(bh), 0, 1 << inode->i_blkbits);
 	if (init_block)
 		init_block(inode, bh, kaddr);
 	flush_dcache_page(bh->b_page);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 
 	set_buffer_uptodate(bh);
 	mark_buffer_dirty(bh);
diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 65221a0..3e7b2a0 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -119,11 +119,11 @@ void nilfs_copy_buffer(struct buffer_head *dbh, struct buffer_head *sbh)
 	struct page *spage = sbh->b_page, *dpage = dbh->b_page;
 	struct buffer_head *bh;
 
-	kaddr0 = kmap_atomic(spage, KM_USER0);
-	kaddr1 = kmap_atomic(dpage, KM_USER1);
+	kaddr0 = kmap_atomic(spage);
+	kaddr1 = kmap_atomic(dpage);
 	memcpy(kaddr1 + bh_offset(dbh), kaddr0 + bh_offset(sbh), sbh->b_size);
-	kunmap_atomic(kaddr1, KM_USER1);
-	kunmap_atomic(kaddr0, KM_USER0);
+	kunmap_atomic(kaddr1);
+	kunmap_atomic(kaddr0);
 
 	dbh->b_state = sbh->b_state & NILFS_BUFFER_INHERENT_BITS;
 	dbh->b_blocknr = sbh->b_blocknr;
diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index a604ac0..f1626f5 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -493,9 +493,9 @@ static int nilfs_recovery_copy_block(struct the_nilfs *nilfs,
 	if (unlikely(!bh_org))
 		return -EIO;
 
-	kaddr = kmap_atomic(page, KM_USER0);
+	kaddr = kmap_atomic(page);
 	memcpy(kaddr + bh_offset(bh_org), bh_org->b_data, bh_org->b_size);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 	brelse(bh_org);
 	return 0;
 }
diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index 850a7c0..dc9a913 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -227,9 +227,9 @@ static void nilfs_segbuf_fill_in_data_crc(struct nilfs_segment_buffer *segbuf,
 		crc = crc32_le(crc, bh->b_data, bh->b_size);
 	}
 	list_for_each_entry(bh, &segbuf->sb_payload_buffers, b_assoc_buffers) {
-		kaddr = kmap_atomic(bh->b_page, KM_USER0);
+		kaddr = kmap_atomic(bh->b_page);
 		crc = crc32_le(crc, kaddr + bh_offset(bh), bh->b_size);
-		kunmap_atomic(kaddr, KM_USER0);
+		kunmap_atomic(kaddr);
 	}
 	raw_sum->ss_datasum = cpu_to_le32(crc);
 }
diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index 0a0aba6..c5b7653 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -111,11 +111,11 @@ static void nilfs_sufile_mod_counter(struct buffer_head *header_bh,
 	struct nilfs_sufile_header *header;
 	void *kaddr;
 
-	kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic(header_bh->b_page);
 	header = kaddr + bh_offset(header_bh);
 	le64_add_cpu(&header->sh_ncleansegs, ncleanadd);
 	le64_add_cpu(&header->sh_ndirtysegs, ndirtyadd);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 
 	mark_buffer_dirty(header_bh);
 }
@@ -319,11 +319,11 @@ int nilfs_sufile_alloc(struct inode *sufile, __u64 *segnump)
 	ret = nilfs_sufile_get_header_block(sufile, &header_bh);
 	if (ret < 0)
 		goto out_sem;
-	kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic(header_bh->b_page);
 	header = kaddr + bh_offset(header_bh);
 	ncleansegs = le64_to_cpu(header->sh_ncleansegs);
 	last_alloc = le64_to_cpu(header->sh_last_alloc);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 
 	nsegments = nilfs_sufile_get_nsegments(sufile);
 	maxsegnum = sui->allocmax;
@@ -356,7 +356,7 @@ int nilfs_sufile_alloc(struct inode *sufile, __u64 *segnump)
 							   &su_bh);
 		if (ret < 0)
 			goto out_header;
-		kaddr = kmap_atomic(su_bh->b_page, KM_USER0);
+		kaddr = kmap_atomic(su_bh->b_page);
 		su = nilfs_sufile_block_get_segment_usage(
 			sufile, segnum, su_bh, kaddr);
 
@@ -367,14 +367,14 @@ int nilfs_sufile_alloc(struct inode *sufile, __u64 *segnump)
 				continue;
 			/* found a clean segment */
 			nilfs_segment_usage_set_dirty(su);
-			kunmap_atomic(kaddr, KM_USER0);
+			kunmap_atomic(kaddr);
 
-			kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
+			kaddr = kmap_atomic(header_bh->b_page);
 			header = kaddr + bh_offset(header_bh);
 			le64_add_cpu(&header->sh_ncleansegs, -1);
 			le64_add_cpu(&header->sh_ndirtysegs, 1);
 			header->sh_last_alloc = cpu_to_le64(segnum);
-			kunmap_atomic(kaddr, KM_USER0);
+			kunmap_atomic(kaddr);
 
 			sui->ncleansegs--;
 			mark_buffer_dirty(header_bh);
@@ -385,7 +385,7 @@ int nilfs_sufile_alloc(struct inode *sufile, __u64 *segnump)
 			goto out_header;
 		}
 
-		kunmap_atomic(kaddr, KM_USER0);
+		kunmap_atomic(kaddr);
 		brelse(su_bh);
 	}
 
@@ -407,16 +407,16 @@ void nilfs_sufile_do_cancel_free(struct inode *sufile, __u64 segnum,
 	struct nilfs_segment_usage *su;
 	void *kaddr;
 
-	kaddr = kmap_atomic(su_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic(su_bh->b_page);
 	su = nilfs_sufile_block_get_segment_usage(sufile, segnum, su_bh, kaddr);
 	if (unlikely(!nilfs_segment_usage_clean(su))) {
 		printk(KERN_WARNING "%s: segment %llu must be clean\n",
 		       __func__, (unsigned long long)segnum);
-		kunmap_atomic(kaddr, KM_USER0);
+		kunmap_atomic(kaddr);
 		return;
 	}
 	nilfs_segment_usage_set_dirty(su);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 
 	nilfs_sufile_mod_counter(header_bh, -1, 1);
 	NILFS_SUI(sufile)->ncleansegs--;
@@ -433,11 +433,11 @@ void nilfs_sufile_do_scrap(struct inode *sufile, __u64 segnum,
 	void *kaddr;
 	int clean, dirty;
 
-	kaddr = kmap_atomic(su_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic(su_bh->b_page);
 	su = nilfs_sufile_block_get_segment_usage(sufile, segnum, su_bh, kaddr);
 	if (su->su_flags == cpu_to_le32(1UL << NILFS_SEGMENT_USAGE_DIRTY) &&
 	    su->su_nblocks == cpu_to_le32(0)) {
-		kunmap_atomic(kaddr, KM_USER0);
+		kunmap_atomic(kaddr);
 		return;
 	}
 	clean = nilfs_segment_usage_clean(su);
@@ -447,7 +447,7 @@ void nilfs_sufile_do_scrap(struct inode *sufile, __u64 segnum,
 	su->su_lastmod = cpu_to_le64(0);
 	su->su_nblocks = cpu_to_le32(0);
 	su->su_flags = cpu_to_le32(1UL << NILFS_SEGMENT_USAGE_DIRTY);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 
 	nilfs_sufile_mod_counter(header_bh, clean ? (u64)-1 : 0, dirty ? 0 : 1);
 	NILFS_SUI(sufile)->ncleansegs -= clean;
@@ -464,12 +464,12 @@ void nilfs_sufile_do_free(struct inode *sufile, __u64 segnum,
 	void *kaddr;
 	int sudirty;
 
-	kaddr = kmap_atomic(su_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic(su_bh->b_page);
 	su = nilfs_sufile_block_get_segment_usage(sufile, segnum, su_bh, kaddr);
 	if (nilfs_segment_usage_clean(su)) {
 		printk(KERN_WARNING "%s: segment %llu is already clean\n",
 		       __func__, (unsigned long long)segnum);
-		kunmap_atomic(kaddr, KM_USER0);
+		kunmap_atomic(kaddr);
 		return;
 	}
 	WARN_ON(nilfs_segment_usage_error(su));
@@ -477,7 +477,7 @@ void nilfs_sufile_do_free(struct inode *sufile, __u64 segnum,
 
 	sudirty = nilfs_segment_usage_dirty(su);
 	nilfs_segment_usage_set_clean(su);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 	mark_buffer_dirty(su_bh);
 
 	nilfs_sufile_mod_counter(header_bh, 1, sudirty ? (u64)-1 : 0);
@@ -525,13 +525,13 @@ int nilfs_sufile_set_segment_usage(struct inode *sufile, __u64 segnum,
 	if (ret < 0)
 		goto out_sem;
 
-	kaddr = kmap_atomic(bh->b_page, KM_USER0);
+	kaddr = kmap_atomic(bh->b_page);
 	su = nilfs_sufile_block_get_segment_usage(sufile, segnum, bh, kaddr);
 	WARN_ON(nilfs_segment_usage_error(su));
 	if (modtime)
 		su->su_lastmod = cpu_to_le64(modtime);
 	su->su_nblocks = cpu_to_le32(nblocks);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 
 	mark_buffer_dirty(bh);
 	nilfs_mdt_mark_dirty(sufile);
@@ -572,7 +572,7 @@ int nilfs_sufile_get_stat(struct inode *sufile, struct nilfs_sustat *sustat)
 	if (ret < 0)
 		goto out_sem;
 
-	kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic(header_bh->b_page);
 	header = kaddr + bh_offset(header_bh);
 	sustat->ss_nsegs = nilfs_sufile_get_nsegments(sufile);
 	sustat->ss_ncleansegs = le64_to_cpu(header->sh_ncleansegs);
@@ -582,7 +582,7 @@ int nilfs_sufile_get_stat(struct inode *sufile, struct nilfs_sustat *sustat)
 	spin_lock(&nilfs->ns_last_segment_lock);
 	sustat->ss_prot_seq = nilfs->ns_prot_seq;
 	spin_unlock(&nilfs->ns_last_segment_lock);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 	brelse(header_bh);
 
  out_sem:
@@ -598,15 +598,15 @@ void nilfs_sufile_do_set_error(struct inode *sufile, __u64 segnum,
 	void *kaddr;
 	int suclean;
 
-	kaddr = kmap_atomic(su_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic(su_bh->b_page);
 	su = nilfs_sufile_block_get_segment_usage(sufile, segnum, su_bh, kaddr);
 	if (nilfs_segment_usage_error(su)) {
-		kunmap_atomic(kaddr, KM_USER0);
+		kunmap_atomic(kaddr);
 		return;
 	}
 	suclean = nilfs_segment_usage_clean(su);
 	nilfs_segment_usage_set_error(su);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 
 	if (suclean) {
 		nilfs_sufile_mod_counter(header_bh, -1, 0);
@@ -675,7 +675,7 @@ static int nilfs_sufile_truncate_range(struct inode *sufile,
 			/* hole */
 			continue;
 		}
-		kaddr = kmap_atomic(su_bh->b_page, KM_USER0);
+		kaddr = kmap_atomic(su_bh->b_page);
 		su = nilfs_sufile_block_get_segment_usage(
 			sufile, segnum, su_bh, kaddr);
 		su2 = su;
@@ -684,7 +684,7 @@ static int nilfs_sufile_truncate_range(struct inode *sufile,
 			     ~(1UL << NILFS_SEGMENT_USAGE_ERROR)) ||
 			    nilfs_segment_is_active(nilfs, segnum + j)) {
 				ret = -EBUSY;
-				kunmap_atomic(kaddr, KM_USER0);
+				kunmap_atomic(kaddr);
 				brelse(su_bh);
 				goto out_header;
 			}
@@ -696,7 +696,7 @@ static int nilfs_sufile_truncate_range(struct inode *sufile,
 				nc++;
 			}
 		}
-		kunmap_atomic(kaddr, KM_USER0);
+		kunmap_atomic(kaddr);
 		if (nc > 0) {
 			mark_buffer_dirty(su_bh);
 			ncleaned += nc;
@@ -772,10 +772,10 @@ int nilfs_sufile_resize(struct inode *sufile, __u64 newnsegs)
 		sui->ncleansegs -= nsegs - newnsegs;
 	}
 
-	kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic(header_bh->b_page);
 	header = kaddr + bh_offset(header_bh);
 	header->sh_ncleansegs = cpu_to_le64(sui->ncleansegs);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 
 	mark_buffer_dirty(header_bh);
 	nilfs_mdt_mark_dirty(sufile);
@@ -840,7 +840,7 @@ ssize_t nilfs_sufile_get_suinfo(struct inode *sufile, __u64 segnum, void *buf,
 			continue;
 		}
 
-		kaddr = kmap_atomic(su_bh->b_page, KM_USER0);
+		kaddr = kmap_atomic(su_bh->b_page);
 		su = nilfs_sufile_block_get_segment_usage(
 			sufile, segnum, su_bh, kaddr);
 		for (j = 0; j < n;
@@ -853,7 +853,7 @@ ssize_t nilfs_sufile_get_suinfo(struct inode *sufile, __u64 segnum, void *buf,
 				si->sui_flags |=
 					(1UL << NILFS_SEGMENT_USAGE_ACTIVE);
 		}
-		kunmap_atomic(kaddr, KM_USER0);
+		kunmap_atomic(kaddr);
 		brelse(su_bh);
 	}
 	ret = nsegs;
@@ -902,10 +902,10 @@ int nilfs_sufile_read(struct super_block *sb, size_t susize,
 		goto failed;
 
 	sui = NILFS_SUI(sufile);
-	kaddr = kmap_atomic(header_bh->b_page, KM_USER0);
+	kaddr = kmap_atomic(header_bh->b_page);
 	header = kaddr + bh_offset(header_bh);
 	sui->ncleansegs = le64_to_cpu(header->sh_ncleansegs);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 	brelse(header_bh);
 
 	sui->allocmax = nilfs_sufile_get_nsegments(sufile) - 1;
-- 
1.7.4.4

