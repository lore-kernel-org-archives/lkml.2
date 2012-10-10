Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab2JJVji (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 17:39:38 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:36923 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844Ab2JJVjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 17:39:36 -0400
X-ASG-Debug-ID: 1349905175-0421b558281b580001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <5075EB16.6090302@fusionio.com>
Date: Wed, 10 Oct 2012 15:39:34 -0600
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block IO bits for 3.7
X-Enigmail-Version: 1.4.4
X-ASG-Orig-Subj: [GIT PULL] block IO bits for 3.7
Content-Type: multipart/mixed;
	boundary="------------060505090409020409080801"
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1349905175
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.110981
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------060505090409020409080801
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit

Hi Linus,

Please find below the pull request for the core block IO bits for
3.7. Not a huge round this time, it contains:

- First series from Kent cleaning up and generalizing bio allocation
  and freeing.

- WRITE_SAME support from Martin.

- Mikulas patches to prevent O_DIRECT crashes when someone changes
  the block size of a device.

- Make bio_split() work on data-less bio's (like trim/discards).

- A few other minor fixups.

Please pull. Do note that it will merge cleanly into the current master
(as of right now), but the end-result wont compile due to the prio-tree
removal and change in the vm. You will get an error ala:

  CC      fs/block_dev.o
fs/block_dev.c: In function ‘set_blocksize’:
fs/block_dev.c:135:2: error: implicit declaration of function ‘prio_tree_empty’ [-Werror=implicit-function-declaration]

I've attached a patch from Andrew to fix that up, I'm guessing you
prefer that rather than me merging master into for-3.7/core at this
point.


  git://git.kernel.dk/linux-block.git for-3.7/core

----------------------------------------------------------------
Dave Reisner (1):
      block: reject invalid queue attribute values

Fengguang Wu (1):
      fs/block_dev.c:1644:5: sparse: symbol 'blkdev_mmap' was not declared

Jaehoon Chung (1):
      block: remove the duplicated setting for congestion_threshold

Jens Axboe (1):
      fs: fix include/percpu-rwsem.h export error

Kent Overstreet (8):
      block: Generalized bio pool freeing
      block: Ues bi_pool for bio_integrity_alloc()
      dm: Use bioset's front_pad for dm_rq_clone_bio_info
      block: Add bio_reset()
      pktcdvd: Switch to bio_kmalloc()
      block: Kill bi_destructor
      block: Consolidate bio_alloc_bioset(), bio_kmalloc()
      block: Add bio_clone_bioset(), bio_clone_kmalloc()

Martin K. Petersen (5):
      block: Clean up special command handling logic
      block: Consolidate command flag and queue limit checks for merges
      block: Implement support for WRITE SAME
      block: Make blkdev_issue_zeroout use WRITE SAME
      block: ioctl to zero block ranges

Maxim Levitsky (2):
      scatterlist: add sg_nents
      scatterlist: refactor the sg_nents

Mikulas Patocka (3):
      Fix a crash when block device is read and block size is changed at the same time
      blockdev: turn a rw semaphore into a percpu rw semaphore
      percpu-rw-semaphore: fix documentation typos

Peter Senna Tschudin (1):
      block/blk-tag.c: Remove useless kfree

Shaohua Li (1):
      block: makes bio_split support bio without data

Tejun Heo (2):
      block: lift the initial queue bypass mode on blk_register_queue() instead of blk_init_allocated_queue()
      block: fix request_queue->flags initialization

 Documentation/ABI/testing/sysfs-block |   14 ++
 Documentation/block/biodoc.txt        |    5 -
 Documentation/percpu-rw-semaphore.txt |   27 ++++
 block/blk-core.c                      |   51 ++++----
 block/blk-lib.c                       |  104 ++++++++++++++-
 block/blk-merge.c                     |   53 +++-----
 block/blk-settings.c                  |   16 +++
 block/blk-sysfs.c                     |   44 ++++++-
 block/blk-tag.c                       |    6 +-
 block/blk.h                           |    5 +-
 block/elevator.c                      |    6 +-
 block/ioctl.c                         |   27 ++++
 drivers/block/drbd/drbd_main.c        |   13 +-
 drivers/block/osdblk.c                |    3 +-
 drivers/block/pktcdvd.c               |   52 +-------
 drivers/char/raw.c                    |    2 +-
 drivers/md/dm-crypt.c                 |   16 +--
 drivers/md/dm-io.c                    |   11 --
 drivers/md/dm.c                       |   74 ++++-------
 drivers/md/md.c                       |   44 +------
 drivers/md/raid0.c                    |    1 +
 drivers/target/target_core_iblock.c   |    9 --
 fs/bio-integrity.c                    |   44 +++----
 fs/bio.c                              |  231 +++++++++++++++------------------
 fs/block_dev.c                        |   69 +++++++++-
 fs/exofs/ore.c                        |    5 +-
 include/linux/bio.h                   |   70 +++++++---
 include/linux/blk_types.h             |   36 +++--
 include/linux/blkdev.h                |   82 ++++++++++--
 include/linux/fs.h                    |    6 +
 include/linux/percpu-rwsem.h          |   89 +++++++++++++
 include/linux/scatterlist.h           |    1 +
 lib/scatterlist.c                     |   19 +++
 33 files changed, 771 insertions(+), 464 deletions(-)
 create mode 100644 Documentation/percpu-rw-semaphore.txt
 create mode 100644 include/linux/percpu-rwsem.h


-- 
Jens Axboe


--------------060505090409020409080801
Content-Type: text/x-patch; name="prio-tree-fixup.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="prio-tree-fixup.patch"

From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs/block_dev.c:set_blocksize(): use mapping_mapped()

... instead of open-coding it.

Suggested-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

diff -puN fs/block_dev.c~fs-block_devc-set_blocksize-use-mapping_mapped fs/=
block_dev.c
--- a/fs/block_dev.c~fs-block_devc-set_blocksize-use-mapping_mapped
+++ a/fs/block_dev.c
@@ -132,8 +132,7 @@ int set_blocksize(struct block_device *b
 	/* Check that the block device is not memory mapped */
 	mapping =3D bdev->bd_inode->i_mapping;
 	mutex_lock(&mapping->i_mmap_mutex);
-	if (!prio_tree_empty(&mapping->i_mmap) ||
-	    !list_empty(&mapping->i_mmap_nonlinear)) {
+	if (mapping_mapped(mapping)) {
 		mutex_unlock(&mapping->i_mmap_mutex);
 		percpu_up_write(&bdev->bd_block_size_semaphore);
 		return -EBUSY;


--------------060505090409020409080801--
