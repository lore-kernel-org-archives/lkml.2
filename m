Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933552Ab0HLAeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:34:46 -0400
Received: from kroah.org ([198.145.64.141]:43466 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759110Ab0HKX6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:58:44 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:01 2010
Message-Id: <20100811235501.785000088@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:54:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Mason <chris.mason@oracle.com>, Jeff Mahoney <jeffm@suse.com>
Subject: [068/111] Btrfs: Use correct values when updating inode i_size on fallocate
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

commit d1ea6a61454e7d7ff0873d0ad1ae27d5807da0d3 upstream.

commit f2bc9dd07e3424c4ec5f3949961fe053d47bc825
Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date:   Wed Jan 20 12:57:53 2010 +0530

    Btrfs: Use correct values when updating inode i_size on fallocate

    Even though we allocate more, we should be updating inode i_size
    as per the arguments passed

    Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Signed-off-by: Chris Mason <chris.mason@oracle.com>
Acked-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/btrfs/inode.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5799,7 +5799,7 @@ out_fail:
 }
 
 static int prealloc_file_range(struct inode *inode, u64 start, u64 end,
-			       u64 alloc_hint, int mode)
+			u64 alloc_hint, int mode, loff_t actual_len)
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -5808,6 +5808,7 @@ static int prealloc_file_range(struct in
 	u64 cur_offset = start;
 	u64 num_bytes = end - start;
 	int ret = 0;
+	u64 i_size;
 
 	while (num_bytes > 0) {
 		alloc_size = min(num_bytes, root->fs_info->max_extent);
@@ -5846,8 +5847,12 @@ static int prealloc_file_range(struct in
 		BTRFS_I(inode)->flags |= BTRFS_INODE_PREALLOC;
 		if (!(mode & FALLOC_FL_KEEP_SIZE) &&
 		    cur_offset > inode->i_size) {
-			i_size_write(inode, cur_offset);
-			btrfs_ordered_update_i_size(inode, cur_offset, NULL);
+			if (cur_offset > actual_len)
+				i_size  = actual_len;
+			else
+				i_size = cur_offset;
+			i_size_write(inode, i_size);
+			btrfs_ordered_update_i_size(inode, i_size, NULL);
 		}
 
 		ret = btrfs_update_inode(trans, root, inode);
@@ -5940,7 +5945,7 @@ static long btrfs_fallocate(struct inode
 		     !test_bit(EXTENT_FLAG_PREALLOC, &em->flags))) {
 			ret = prealloc_file_range(inode,
 						  cur_offset, last_byte,
-						  alloc_hint, mode);
+						alloc_hint, mode, offset+len);
 			if (ret < 0) {
 				free_extent_map(em);
 				break;


