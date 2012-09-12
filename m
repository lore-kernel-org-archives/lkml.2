Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab2IMAgY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:36:24 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:59246 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114Ab2ILXc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:32:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Stefan Behrens <sbehrens@giantdisaster.de>,
        Chris Mason <chris.mason@oracle.com>
Subject: [ 047/108] Btrfs: revert checksum error statistic which can cause a BUG()
Date: Wed, 12 Sep 2012 16:28:45 -0700
Message-Id: <20120912232455.481708100@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Behrens <sbehrens@giantdisaster.de>

commit 5ee0844d6427e7338e0aba748f62b62d07ea2ed0 upstream.

Commit 442a4f6308e694e0fa6025708bd5e4e424bbf51c added btrfs device
statistic counters for detected IO and checksum errors to Linux 3.5.
The statistic part that counts checksum errors in
end_bio_extent_readpage() can cause a BUG() in a subfunction:
"kernel BUG at fs/btrfs/volumes.c:3762!"
That part is reverted with the current patch.
However, the counting of checksum errors in the scrub context remains
active, and the counting of detected IO errors (read, write or flush
errors) in all contexts remains active.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
Signed-off-by: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/extent_io.c |   17 ++---------------
 fs/btrfs/volumes.c   |   22 ----------------------
 fs/btrfs/volumes.h   |    2 --
 3 files changed, 2 insertions(+), 39 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2329,23 +2329,10 @@ static void end_bio_extent_readpage(stru
 		if (uptodate && tree->ops && tree->ops->readpage_end_io_hook) {
 			ret = tree->ops->readpage_end_io_hook(page, start, end,
 							      state, mirror);
-			if (ret) {
-				/* no IO indicated but software detected errors
-				 * in the block, either checksum errors or
-				 * issues with the contents */
-				struct btrfs_root *root =
-					BTRFS_I(page->mapping->host)->root;
-				struct btrfs_device *device;
-
+			if (ret)
 				uptodate = 0;
-				device = btrfs_find_device_for_logical(
-						root, start, mirror);
-				if (device)
-					btrfs_dev_stat_inc_and_print(device,
-						BTRFS_DEV_STAT_CORRUPTION_ERRS);
-			} else {
+			else
 				clean_io_failure(start, page);
-			}
 		}
 
 		if (!uptodate && tree->ops && tree->ops->readpage_io_failed_hook) {
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4602,28 +4602,6 @@ int btrfs_read_sys_array(struct btrfs_ro
 	return ret;
 }
 
-struct btrfs_device *btrfs_find_device_for_logical(struct btrfs_root *root,
-						   u64 logical, int mirror_num)
-{
-	struct btrfs_mapping_tree *map_tree = &root->fs_info->mapping_tree;
-	int ret;
-	u64 map_length = 0;
-	struct btrfs_bio *bbio = NULL;
-	struct btrfs_device *device;
-
-	BUG_ON(mirror_num == 0);
-	ret = btrfs_map_block(map_tree, WRITE, logical, &map_length, &bbio,
-			      mirror_num);
-	if (ret) {
-		BUG_ON(bbio != NULL);
-		return NULL;
-	}
-	BUG_ON(mirror_num != bbio->mirror_num);
-	device = bbio->stripes[mirror_num - 1].dev;
-	kfree(bbio);
-	return device;
-}
-
 int btrfs_read_chunk_tree(struct btrfs_root *root)
 {
 	struct btrfs_path *path;
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -288,8 +288,6 @@ int btrfs_cancel_balance(struct btrfs_fs
 int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
 int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
 			 u64 *start, u64 *max_avail);
-struct btrfs_device *btrfs_find_device_for_logical(struct btrfs_root *root,
-						   u64 logical, int mirror_num);
 void btrfs_dev_stat_print_on_error(struct btrfs_device *device);
 void btrfs_dev_stat_inc_and_print(struct btrfs_device *dev, int index);
 int btrfs_get_dev_stats(struct btrfs_root *root,


