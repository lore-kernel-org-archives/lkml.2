Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717Ab0DBKsu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 06:48:50 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39968 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab0DBKsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 06:48:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :x-operating-system:user-agent;
        b=sNBHQU6RQR8oXmYjHNSo25aZ9b5o2ev8d4doDzXbCA0ZG/nhc0nO1kCt4Hod4GJglt
         +Qf/vXFH7h0AxEr0lLfh9EfxUQ4vejr530s+VBlG0svZvXukI0LX1pDZ8ft1kbFXC+OA
         jiOb0naf3ZLW+Z0jBtZ1/sQB1040pDI1mtWhA=
Date: Fri, 2 Apr 2010 18:48:37 +0800
From: Li Hong <lihong.hi@gmail.com>
To: KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>,
       linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] nilfs2: Combine nilfs_btree_release_path() and
 nilfs_btree_free_path()
Message-ID: <20100402104837.GD9652@xhl>
Mail-Followup-To: KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>,
	linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20100402104206.GB9652@xhl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100402104206.GB9652@xhl>
X-Operating-System: Linux xhl 2.6.31-14-generic
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, a same patch sent out a short time ago but replied to a wrong thread.
-------------------- cut here ----------------------

nilfs_btree_release_path() and nilfs_btree_free_path() are bound into each other
tightly. Make them into one procedure to clearify the logic and avoid some
misusages.

Signed-off-by: Li Hong <lihong.hi@gmail.com>
---
 fs/nilfs2/btree.c |   22 +++++-----------------
 1 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index bb31ab3..fa4b123 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -93,18 +93,14 @@ out:
 	return path;
 }
 
-static inline void nilfs_btree_free_path(struct nilfs_btree_path *path)
+static void nilfs_btree_free_path(struct nilfs_btree_path *path)
 {
-	kmem_cache_free(nilfs_btree_path_cache, path);
-}
-
-static void nilfs_btree_release_path(struct nilfs_btree_path *path)
-{
-	int level;
+	int level = NILFS_BTREE_LEVEL_DATA;
 
-	for (level = NILFS_BTREE_LEVEL_DATA; level < NILFS_BTREE_LEVEL_MAX;
-	     level++)
+	for (; level < NILFS_BTREE_LEVEL_MAX; level++)
 		brelse(path[level].bp_bh);
+
+	kmem_cache_free(nilfs_btree_path_cache, path);
 }
 
 /*
@@ -573,7 +569,6 @@ static int nilfs_btree_lookup(const struct nilfs_bmap *bmap,
 	if (ptrp != NULL)
 		*ptrp = ptr;
 
-	nilfs_btree_release_path(path);
 	nilfs_btree_free_path(path);
 
 	return ret;
@@ -655,7 +650,6 @@ static int nilfs_btree_lookup_contig(const struct nilfs_bmap *bmap,
 	*ptrp = ptr;
 	ret = cnt;
  out:
-	nilfs_btree_release_path(path);
 	nilfs_btree_free_path(path);
 	return ret;
 }
@@ -1139,7 +1133,6 @@ static int nilfs_btree_insert(struct nilfs_bmap *bmap, __u64 key, __u64 ptr)
 	nilfs_bmap_add_blocks(bmap, stats.bs_nblocks);
 
  out:
-	nilfs_btree_release_path(path);
 	nilfs_btree_free_path(path);
 	return ret;
 }
@@ -1472,7 +1465,6 @@ static int nilfs_btree_delete(struct nilfs_bmap *bmap, __u64 key)
 	nilfs_bmap_sub_blocks(bmap, stats.bs_nblocks);
 
 out:
-	nilfs_btree_release_path(path);
 	nilfs_btree_free_path(path);
 	return ret;
 }
@@ -1490,7 +1482,6 @@ static int nilfs_btree_last_key(const struct nilfs_bmap *bmap, __u64 *keyp)
 
 	ret = nilfs_btree_do_lookup_last(btree, path, keyp, NULL);
 
-	nilfs_btree_release_path(path);
 	nilfs_btree_free_path(path);
 
 	return ret;
@@ -1944,7 +1935,6 @@ static int nilfs_btree_propagate(const struct nilfs_bmap *bmap,
 		nilfs_btree_propagate_p(btree, path, level, bh);
 
  out:
-	nilfs_btree_release_path(path);
 	nilfs_btree_free_path(path);
 
 	return ret;
@@ -2126,7 +2116,6 @@ static int nilfs_btree_assign(struct nilfs_bmap *bmap,
 		nilfs_btree_assign_p(btree, path, level, bh, blocknr, binfo);
 
  out:
-	nilfs_btree_release_path(path);
 	nilfs_btree_free_path(path);
 
 	return ret;
@@ -2190,7 +2179,6 @@ static int nilfs_btree_mark(struct nilfs_bmap *bmap, __u64 key, int level)
 		nilfs_bmap_set_dirty(&btree->bt_bmap);
 
  out:
-	nilfs_btree_release_path(path);
 	nilfs_btree_free_path(path);
 	return ret;
 }
-- 
1.6.3.3

