Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294Ab0JFIdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 04:33:04 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:61940 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932184Ab0JFIdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 04:33:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=HGTqYYvbm+KdtOsliI8UkThtKquGoMPtIrxfLzQXJyJ9KRyHpELJTUsBzfJSa4I7up
         Vst+5j80jVmPXus4VaRRmUe2pQ6ZJ7SbyycnvrF9pjmLzSkayRsudOZgFyPngCDiPyBd
         +abvxPjil+5dv5SYD1u9oJzYA/5nlaoFa5zJU=
Date: Wed, 6 Oct 2010 16:31:50 +0800
From: Cong Meng <mcpacino@gmail.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>, Nick Piggin <npiggin@kernel.dk>
Subject: introduce dm-snap-mv
Message-ID: <20101006083150.GA15758@zhongling>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

I am very glad to introduce my work dm-snap-mv here.


what is dm-snap-mv
-------------------
The dm-snap-mv is a target module for device-mapper, which can take
multiple snapshots against an existing block device(origin device).

All snapshots are saved in an independent block device(COW device).

The copy-on-write is used, so only diff-data will be saved in the COW device.


features
--------
1. snapshot of origin
2. snapshot of snapshot
3. instant snapshot creation and deletion
4. origin and snapshots are concurrent readable/writable
5. rollback snapshot to origin
6. multiple origin devices share a COW device
7. multiple COW devices are supported


diagram
-------

           +---------------------+    +---------------+     +--------------+
   read <--|                     |-----               |     |              |
           |    origin dm_dev    |    |   origin_dev  | COW |              |
  write ---|                     |---->               |----->  snapshot-1  |
           +---------------------+    +--|------------+     |     ...      | 
                                         |                  |     ...      |        
           +---------------------+    +--|------------------+     ...      |
   read <--|                     |-------?-                    snapshot-N  |
           |  snapshot-X dm_dev  |    |         cow_dev                    |
  write ---|                     |---->                                    |
           +---------------------+    +------------------------------------+

  dm_dev: device-mapper device, created by "dmsetup create ..."
     COW: copy-on-write


download the source
-----------------------
http://github.com/mcpacino/dm-snap-mv

git clone git://github.com/mcpacino/dm-snap-mv.git


a kernel patch
--------------
Now, dm-snap-mv highly depends on a kernel patch below, which make __getblk()
can get a 4K buffer head while block size of the disk is NOT 4K.

Signed-off-by: Cong Meng <mcpacino@gmail.com>
---
 fs/buffer.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 3e7dca2..f7f9d33 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1051,10 +1051,7 @@ grow_buffers(struct block_device *bdev, sector_t block, int size)
 	pgoff_t index;
 	int sizebits;
 
-	sizebits = -1;
-	do {
-		sizebits++;
-	} while ((size << sizebits) < PAGE_SIZE);
+	sizebits = PAGE_CACHE_SHIFT - bdev->bd_inode->i_blkbits;
 
 	index = block >> sizebits;
 
@@ -2924,7 +2921,7 @@ int submit_bh(int rw, struct buffer_head * bh)
 	 */
 	bio = bio_alloc(GFP_NOIO, 1);
 
-	bio->bi_sector = bh->b_blocknr * (bh->b_size >> 9);
+	bio->bi_sector = bh->b_blocknr << (bh->b_bdev->bd_inode->i_blkbits - 9);
 	bio->bi_bdev = bh->b_bdev;
 	bio->bi_io_vec[0].bv_page = bh->b_page;
 	bio->bi_io_vec[0].bv_len = bh->b_size;
