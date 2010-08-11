Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292Ab0HKX7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:59:17 -0400
Received: from kroah.org ([198.145.64.141]:43538 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759074Ab0HKX64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:58:56 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:02 2010
Message-Id: <20100811235502.695886900@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:54:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Josef Bacik <josef@redhat.com>, Chris Mason <chris.mason@oracle.com>,
        Jeff Mahoney <jeffm@suse.com>
Subject: [078/111] Btrfs: do not try and lookup the file extent when finishing ordered io
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Josef Bacik <josef@redhat.com>

commit efd049fb26a162c3830fd3cb1001fdc09b147f3b upstream.

When running the following fio job

[torrent]
filename=torrent-test
rw=randwrite
size=4g
filesize=4g
bs=4k
ioengine=sync

you would see long stalls where no work was being done.  That is because we were
doing all this extra work to read in the file extent outside of the transaction,
however in the random io case this ends up hurting us because the file extents
are not there to begin with.  So axe this logic, since we end up reading in the
file extent when we go to update it anyway.  This took the fio job from 11 mb/s
with several ~10 second stalls to 24 mb/s to a couple of 1-2 second stalls.

Signed-off-by: Josef Bacik <josef@redhat.com>
Signed-off-by: Chris Mason <chris.mason@oracle.com>
Acked-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/btrfs/inode.c |   46 ++--------------------------------------------
 1 file changed, 2 insertions(+), 44 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1680,24 +1680,6 @@ static int insert_reserved_file_extent(s
  * before we start the transaction.  It limits the amount of btree
  * reads required while inside the transaction.
  */
-static noinline void reada_csum(struct btrfs_root *root,
-				struct btrfs_path *path,
-				struct btrfs_ordered_extent *ordered_extent)
-{
-	struct btrfs_ordered_sum *sum;
-	u64 bytenr;
-
-	sum = list_entry(ordered_extent->list.next, struct btrfs_ordered_sum,
-			 list);
-	bytenr = sum->sums[0].bytenr;
-
-	/*
-	 * we don't care about the results, the point of this search is
-	 * just to get the btree leaves into ram
-	 */
-	btrfs_lookup_csum(NULL, root->fs_info->csum_root, path, bytenr, 0);
-}
-
 /* as ordered data IO finishes, this gets called so we can finish
  * an ordered extent if the range of bytes in the file it covers are
  * fully written.
@@ -1708,7 +1690,6 @@ static int btrfs_finish_ordered_io(struc
 	struct btrfs_trans_handle *trans;
 	struct btrfs_ordered_extent *ordered_extent = NULL;
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
-	struct btrfs_path *path;
 	int compressed = 0;
 	int ret;
 
@@ -1716,32 +1697,9 @@ static int btrfs_finish_ordered_io(struc
 	if (!ret)
 		return 0;
 
-	/*
-	 * before we join the transaction, try to do some of our IO.
-	 * This will limit the amount of IO that we have to do with
-	 * the transaction running.  We're unlikely to need to do any
-	 * IO if the file extents are new, the disk_i_size checks
-	 * covers the most common case.
-	 */
-	if (start < BTRFS_I(inode)->disk_i_size) {
-		path = btrfs_alloc_path();
-		if (path) {
-			ret = btrfs_lookup_file_extent(NULL, root, path,
-						       inode->i_ino,
-						       start, 0);
-			ordered_extent = btrfs_lookup_ordered_extent(inode,
-								     start);
-			if (!list_empty(&ordered_extent->list)) {
-				btrfs_release_path(root, path);
-				reada_csum(root, path, ordered_extent);
-			}
-			btrfs_free_path(path);
-		}
-	}
-
-	if (!ordered_extent)
-		ordered_extent = btrfs_lookup_ordered_extent(inode, start);
+	ordered_extent = btrfs_lookup_ordered_extent(inode, start);
 	BUG_ON(!ordered_extent);
+
 	if (test_bit(BTRFS_ORDERED_NOCOW, &ordered_extent->flags)) {
 		BUG_ON(!list_empty(&ordered_extent->list));
 		ret = btrfs_ordered_update_i_size(inode, 0, ordered_extent);


