Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933595Ab0HLAgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:36:46 -0400
Received: from kroah.org ([198.145.64.141]:43403 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759035Ab0HKX6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:58:33 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:01 2010
Message-Id: <20100811235500.974610115@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:54:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Josef Bacik <josef@redhat.com>, Chris Mason <chris.mason@oracle.com>,
        Jeff Mahoney <jeffm@suse.com>
Subject: [059/111] Btrfs: make metadata chunks smaller
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Josef Bacik <josef@redhat.com>

commit 83d3c9696fed237a3d96fce18299e2fcf112109f upstream.

This patch makes us a bit less zealous about making sure we have enough free
metadata space by pearing down the size of new metadata chunks to 256mb instead
of 1gb.  Also, we used to try an allocate metadata chunks when allocating data,
but that sort of thing is done elsewhere now so we can just remove it.  With my
-ENOSPC test I used to have 3gb reserved for metadata out of 75gb, now I have
1.7gb.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
Signed-off-by: Chris Mason <chris.mason@oracle.com>
Acked-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 fs/btrfs/extent-tree.c |   11 +----------
 fs/btrfs/volumes.c     |    2 +-
 2 files changed, 2 insertions(+), 11 deletions(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4593,7 +4593,6 @@ int btrfs_reserve_extent(struct btrfs_tr
 {
 	int ret;
 	u64 search_start = 0;
-	struct btrfs_fs_info *info = root->fs_info;
 
 	data = btrfs_get_alloc_profile(root, data);
 again:
@@ -4601,17 +4600,9 @@ again:
 	 * the only place that sets empty_size is btrfs_realloc_node, which
 	 * is not called recursively on allocations
 	 */
-	if (empty_size || root->ref_cows) {
-		if (!(data & BTRFS_BLOCK_GROUP_METADATA)) {
-			ret = do_chunk_alloc(trans, root->fs_info->extent_root,
-				     2 * 1024 * 1024,
-				     BTRFS_BLOCK_GROUP_METADATA |
-				     (info->metadata_alloc_profile &
-				      info->avail_metadata_alloc_bits), 0);
-		}
+	if (empty_size || root->ref_cows)
 		ret = do_chunk_alloc(trans, root->fs_info->extent_root,
 				     num_bytes + 2 * 1024 * 1024, data, 0);
-	}
 
 	WARN_ON(num_bytes < root->sectorsize);
 	ret = find_free_extent(trans, root, num_bytes, empty_size,
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2209,7 +2209,7 @@ static int __btrfs_alloc_chunk(struct bt
 		max_chunk_size = 10 * calc_size;
 		min_stripe_size = 64 * 1024 * 1024;
 	} else if (type & BTRFS_BLOCK_GROUP_METADATA) {
-		max_chunk_size = 4 * calc_size;
+		max_chunk_size = 256 * 1024 * 1024;
 		min_stripe_size = 32 * 1024 * 1024;
 	} else if (type & BTRFS_BLOCK_GROUP_SYSTEM) {
 		calc_size = 8 * 1024 * 1024;


