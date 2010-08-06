Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934478Ab0HFKjG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 06:39:06 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:51595 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933698Ab0HFKjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 06:39:01 -0400
X-ASG-Debug-ID: 1281091139-5ce500090000-xx1T2L
X-Barracuda-URL: http://10.101.1.180:8000/cgi-bin/mark.cgi
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4C5BE640.2050801@fusionio.com>
Date: Fri, 6 Aug 2010 12:38:56 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-ASG-Orig-Subj: [GIT PULL] block/IO bits for 2.6.36-rc1
Subject: [GIT PULL] block/IO bits for 2.6.36-rc1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1281091140
X-Barracuda-Virus-Scanned: by Barracuda Spam & Virus Firewall at fusionio.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the big round of updates for the IO bits for 2.6.36-rc1.
Not sure what happened on the excessive number of merges listed
as:

      Merge branch 'for-2.6.36' into for-next

as these should 1) just have been regular fast forwards, and 2)
not be listed under 2.6.36 when the pull was in the other
direction. I tend to run -git git versions, so perhaps there
was a bad version in there. I was planning on reshuffling
the branch, but it's 3 months of churn and fixups in there and
that would take me a while. Let me know if you absolutely
hate it and I'll do it.

Anyway, summary of changes:

- The block parts of the BKL removal from Arnd.

- The race fixing and wakeup appeasing writeback thread
  cleanups/fixes from Artem. Originally done to be easier
  on the power consumption, but Artem also found and fixed
  some races on the exiting writeback task part.

- The writeback cleanups from Christoph.

- The writeback tracing bits from David Chinner, which
  allow us to trace and inspect whether things are doing
  as we inspect.

- Also from Christoph is the unification of the bio
  and request flags and removal of the flag wrappers,
  which makes things more readable and maintainable.

- Fixes from Tejun so that the read-ahead and sync WRITE
  bits match up again. Also puts the bio read/write bits
  into a separate header file.

- Two fixes for splice, alsoing going into stable.

- Series update of the blkfront driver.

- Series update of the CCISS driver.

- Removal of the ancient ISA_DMA_THRESHOLD in block/scsi
  from Tomo. This is the arch/ churn in this patch series.

- Also from Tomo is the nice cleanup of the empty barrier
  code and the conversion of barriers to be regular file
  system request instead of block PC requests.

- A fix for the discard handling, making sure that we
  don't traverse back into the file system on allocation.

- drbd gets a feature reverted that apparently wasn't
  well enough tested. This is also going into stable. A
  few other fixes for drbd as well.

- The floppy cleanup series from Stephen.

- And the usual string of little cleanups/fixes from a
  bunch of other people.


Please pull!

  git://git.kernel.dk/linux-2.6-block.git for-2.6.36

Andi Kleen (2):
      gcc-4.6: block: fix unused but set variables in blk-merge
      gcc-4.6: fs: fix unused but set warnings

Arnd Bergmann (8):
      scsi/i2o_block: cleanup ioctl handling
      block: push down BKL into .locked_ioctl
      block: push down BKL into .open and .release
      block: push BKL into blktrace ioctls
      block: remove BKL from BLKROSET and BLKFLSBUF
      block: remove BKL from partition ioctls
      scsi/sd: remove big kernel lock
      scsi/i2o: restore ioctl changes

Artem Bityutskiy (15):
      writeback: harmonize writeback threads naming
      writeback: fix possible race when creating bdi threads
      writeback: do not lose wake-ups in the forker thread - 1
      writeback: do not lose wake-ups in the forker thread - 2
      writeback: do not lose wake-ups in bdi threads
      writeback: simplify bdi code a little
      writeback: do not remove bdi from bdi_list
      writeback: move last_active to bdi
      writeback: restructure bdi forker loop a little
      writeback: move bdi threads exiting logic to the forker thread
      writeback: prevent unnecessary bdi threads wakeups
      writeback: optimize periodic bdi thread wakeups
      writeback: remove unnecessary init_timer call
      writeback: add new tracepoints
      writeback: cleanup bdi_register

Changli Gao (2):
      splice: direct_splice_actor() should not use pos in sd
      splice: check f_mode for seekable file

Christoph Hellwig (11):
      writeback: remove writeback_inodes_wbc
      writeback: split writeback_inodes_wb
      block: BARRIER request should imply SYNC
      block: remove wrappers for request type/flags
      block: unify flags for struct bio and struct request
      block: fix some more cmd_type cleanup fallout
      virtio_blk: remove overzealous warning
      writeback: simplify the write back thread queue
      writeback: remove wb_list
      writeback: merge bdi_writeback_task and bdi_start_fn
      block: don't allocate a payload for discard request

Daniel Stodden (10):
      xenbus: Make xenbus_switch_state transactional
      blkfront: Fix backtrace in del_gendisk
      blkfront: Fix gendisk leak
      blkfront: Clean up vbd release
      blkfront: Lock blkfront_info when closing
      blkfront: Fix blkfront backend switch race (bdev open)
      blkfront: Fix blkfront backend switch race (bdev release)
      blkfront: Lock blockfront_info during xbdev removal
      blkfront: Remove obsolete info->users
      blkfront: Klog the unclean release path

Dave Chinner (4):
      writeback: Initial tracing support
      writeback: Add tracing to balance_dirty_pages
      writeback: Add tracing to write_cache_pages
      blkdev: check for valid request queue before issuing flush

FUJITA Tomonori (21):
      aha1532: remove ISA_DMA_THRESHOLD usage
      block: kill ISA_DMA_THRESHOLD usage
      remove needless ISA_DMA_THRESHOLD
      scsi: add sd_unprep_fn to free discard page
      scsi: remove unused free discard page in sd_done
      block: introduce REQ_FLUSH flag
      block: permit PREFLUSH and POSTFLUSH without prepare_flush_fn
      scsi: stop using q->prepare_flush_fn
      osdblk: stop using q->prepare_flush_fn
      ps3disk: stop using q->prepare_flush_fn
      dm: stop using q->prepare_flush_fn
      virtio_blk: stop using q->prepare_flush_fn
      ide: stop using q->prepare_flush_fn
      block: remove q->prepare_flush_fn completely
      scsi: need to reset unprep_rq_fn in sd_remove
      block: remove unused REQ_TYPE_LINUX_BLOCK
      scsi: fix discard page leak
      scsi: convert discard to REQ_TYPE_FS from REQ_TYPE_BLOCK_PC
      block: set REQ_TYPE_FS on flush requests
      block: set up rq->rq_disk properly for flush requests
      scsi: use REQ_TYPE_FS for flush request

Ian Campbell (1):
      xen: use less generic names in blkfront driver.

James Bottomley (1):
      block: implement an unprep function corresponding directly to prep

Jan Beulich (2):
      blkfront: fixes for 'xm block-detach ... --force'
      blkfront: don't access freed struct xenbus_device

Jens Axboe (29):
      block: add sysfs knob for turning off disk entropy contributions
      block: add helpers for the trivial queue flag sysfs show/store entries
      block: fix reversed set/clear of bits in helpers
      Merge branch 'for-2.6.36' into for-next
      Merge branch 'writeback-2.6.36' into for-next
      Merge branch 'for-2.6.36' into for-next
      Merge branch 'for-linus' into for-next
      Merge branch 'for-linus' into for-next
      Merge branch 'for-2.6.36' into for-next
      Merge branch 'for-2.6.36' into for-next
      Merge branch 'for-linus' into for-next
      Merge branch 'for-2.6.36' into for-next
      Merge branch 'for-linus' into for-next
      virtio_blk: add default case to cmd type switch
      Merge branch 'for-linus' into for-next
      Merge branch 'writeback-2.6.36' into for-2.6.36
      Merge branch 'for-2.6.36' into for-next
      Merge branch 'for-2.6.36' into for-next
      Merge branch 'for-2.6.36' into for-next
      Merge branch 'for-2.6.36' into for-next
      Merge branch 'for-linus' into for-2.6.36
      block: fixup missing conversion from BIO_RW_DISCARD to REQ_DISCARD
      Merge branch 'master' into for-2.6.36
      block: fix problem with sending down discard that isn't of correct granularity
      coda: fixup clash with block layer REQ_* defines
      writeback: fix bad _bh spinlock nesting
      block: fix missing export of blk_types.h
      Merge branch 'master' into for-2.6.36
      Merge branch 'master' into for-2.6.36

Jeremy Fitzhardinge (4):
      xen/blkfront: avoid compiler warning from missing cases
      Merge remote branch 'jens-linux-2.6-block/for-2.6.36' into upstream/blkfront
      xen/blkfront: use tagged queuing for barriers
      xen/blkfront: Use QUEUE_ORDERED_DRAIN for old backends

Joe Perches (1):
      drivers/cdrom: use pr_<level>

Julia Lawall (1):
      drivers/block: use memdup_user

K. Y. Srinivasan (2):
      xen/front: Propagate changed size of VBDs
      xen/blkfront: revalidate after setting capacity

Kulikov Vasiliy (1):
      cpqarray: check put_user() result

Lars Ellenberg (1):
      drbd: revert "delay probes", feature is being re-implemented differently

Mike Miller (11):
      cciss: enqueue and submit io
      cciss: clean up interrupt handler
      cciss: check for msi in interrupt_not_for_us
      cciss: make interrupt access methods return type bool
      cciss: add performant mode support for Stars/Sirius
      cciss: new controller support and bump driver version
      cciss: make sure we request the performant mode irq
      cciss: fix call to put_controller_in_performant_mode
      cciss: move next_command function from ifdef
      cciss: remove errant debug code
      cciss: change pad value from 32 to 0

Mike Snitzer (1):
      block: disallow FS recursion from sb_issue_discard allocation

Miklos Szeredi (1):
      splice: fix misuse of SPLICE_F_NONBLOCK

Minchan Kim (1):
      writeback: remove wb in get_next_work_item

Philipp Reisner (2):
      drbd: Disable delay probes for the upcomming release
      drbd: Initialize all members of sync_conf to their defaults [Bugz 315]

Randy Dunlap (2):
      block/xd.c: fix brace typo
      writeback.h: needs linux/device.h

Stephen Hemminger (9):
      floppy: initialize debug jiffies offset
      floppy: remove unnecessary inlines
      floppy: silence warning during disk test
      floppy: use atomic type for usage_count
      floppy: cmos attribute should be static
      floppy: fix signed/unsigned warnings
      floppy: use wait_event_interruptible
      floppy: use warning macros
      floppy: make controller const

Stephen M. Cameron (26):
      cciss: Set the performant mode bit in the scsi half of the driver
      cciss: save pdev pointer in per hba structure early to avoid passing it around so much.
      cciss: factor out cciss_lookup_board_id
      cciss: factor out cciss_board_disabled
      cciss: remove board_id parameter from cciss_interrupt_mode()
      cciss: factor out cciss_find_memory_BAR()
      cciss: factor out cciss_wait_for_board_ready()
      cciss: factor out cciss_find_cfgtables
      cciss: fix leak of ioremapped memory
      cciss: factor out cciss_find_board_params
      cciss: factor out CISS_signature_present()
      cciss: factor out cciss_enable_scsi_prefetch()
      cciss: factor out cciss_p600_dma_prefetch_quirk()
      cciss: cleanup some debug ifdefs
      cciss: make cciss_put_controller_into_performant_mode as __devinit
      cciss: factor out cciss_wait_for_mode_change_ack()
      cciss: factor out cciss_enter_performant_mode
      cciss: factor out cciss_find_cfg_addrs.
      cciss: factor out cciss_reset_devices()
      cciss: fix hard reset code.
      cciss: sanitize max commands
      cciss: forbid hard reset of 640x boards
      cciss: use consistent variable names
      cciss: separate cmd_alloc() and cmd_special_alloc()
      cciss: change printks to dev_warn, etc.
      cciss: cleanup interrupt_not_for_us

Stephen Rothwell (1):
      block: fix for block tracing build error

Tejun Heo (2):
      bio, fs: update RWA_MASK, READA and SWRITE to match the corresponding BIO_RW_* bits
      bio, fs: separate out bio_types.h and define READ/WRITE constants in terms of BIO_RW_* flags

 arch/alpha/include/asm/scatterlist.h      |    2 -
 arch/avr32/include/asm/scatterlist.h      |    2 -
 arch/blackfin/include/asm/scatterlist.h   |    2 -
 arch/cris/include/asm/scatterlist.h       |    2 -
 arch/frv/include/asm/scatterlist.h        |    2 -
 arch/h8300/include/asm/scatterlist.h      |    2 -
 arch/ia64/include/asm/scatterlist.h       |    9 -
 arch/m32r/include/asm/scatterlist.h       |    2 -
 arch/m68k/include/asm/scatterlist.h       |    3 -
 arch/microblaze/include/asm/scatterlist.h |    2 -
 arch/mips/include/asm/scatterlist.h       |    2 -
 arch/mn10300/include/asm/scatterlist.h    |    2 -
 arch/parisc/include/asm/scatterlist.h     |    1 -
 arch/powerpc/include/asm/scatterlist.h    |    3 -
 arch/s390/include/asm/scatterlist.h       |    2 -
 arch/score/include/asm/scatterlist.h      |    2 -
 arch/sh/include/asm/scatterlist.h         |    2 -
 arch/sparc/include/asm/scatterlist.h      |    1 -
 arch/um/drivers/ubd_kern.c                |    7 +-
 arch/x86/include/asm/scatterlist.h        |    1 -
 arch/xtensa/include/asm/scatterlist.h     |    2 -
 block/blk-barrier.c                       |   35 +-
 block/blk-core.c                          |  112 +-
 block/blk-exec.c                          |    2 +-
 block/blk-lib.c                           |   48 +-
 block/blk-map.c                           |    2 +-
 block/blk-merge.c                         |    9 +-
 block/blk-settings.c                      |   17 +
 block/blk-sysfs.c                         |   82 +-
 block/blk.h                               |    6 +-
 block/cfq-iosched.c                       |   21 +-
 block/compat_ioctl.c                      |   56 -
 block/elevator.c                          |   19 +-
 block/ioctl.c                             |   21 +-
 drivers/ata/libata-scsi.c                 |    4 +-
 drivers/block/DAC960.c                    |   13 +-
 drivers/block/amiflop.c                   |   29 +-
 drivers/block/aoe/aoeblk.c                |    6 +-
 drivers/block/ataflop.c                   |   32 +-
 drivers/block/brd.c                       |    9 +-
 drivers/block/cciss.c                     | 2165 +++++++++++++++++------------
 drivers/block/cciss.h                     |  135 ++-
 drivers/block/cciss_cmd.h                 |   36 +-
 drivers/block/cciss_scsi.c                |  670 +++++-----
 drivers/block/cpqarray.c                  |   78 +-
 drivers/block/drbd/drbd_actlog.c          |    8 +-
 drivers/block/drbd/drbd_int.h             |   16 +-
 drivers/block/drbd/drbd_main.c            |  102 +--
 drivers/block/drbd/drbd_nl.c              |    4 -
 drivers/block/drbd/drbd_proc.c            |   19 +-
 drivers/block/drbd/drbd_receiver.c        |  135 +--
 drivers/block/drbd/drbd_req.c             |    2 +-
 drivers/block/drbd/drbd_worker.c          |   15 +-
 drivers/block/floppy.c                    |  182 +--
 drivers/block/hd.c                        |    2 +-
 drivers/block/loop.c                      |    9 +-
 drivers/block/mg_disk.c                   |    4 +-
 drivers/block/nbd.c                       |    7 +-
 drivers/block/osdblk.c                    |   15 +-
 drivers/block/paride/pcd.c                |   21 +-
 drivers/block/paride/pd.c                 |   11 +-
 drivers/block/paride/pf.c                 |   26 +-
 drivers/block/pktcdvd.c                   |   20 +-
 drivers/block/ps3disk.c                   |   25 +-
 drivers/block/swim.c                      |   20 +-
 drivers/block/swim3.c                     |   32 +-
 drivers/block/ub.c                        |   35 +-
 drivers/block/umem.c                      |    2 +-
 drivers/block/viodasd.c                   |   21 +-
 drivers/block/virtio_blk.c                |   88 +-
 drivers/block/xd.c                        |   19 +-
 drivers/block/xen-blkfront.c              |  393 ++++--
 drivers/block/xsysace.c                   |    8 +-
 drivers/block/z2ram.c                     |   13 +-
 drivers/cdrom/cdrom.c                     |   46 +-
 drivers/cdrom/gdrom.c                     |   48 +-
 drivers/cdrom/viocd.c                     |  106 +-
 drivers/ide/ide-atapi.c                   |   17 +-
 drivers/ide/ide-cd.c                      |   98 +-
 drivers/ide/ide-cd_ioctl.c                |    2 +-
 drivers/ide/ide-disk.c                    |   18 +-
 drivers/ide/ide-disk_ioctl.c              |    9 +-
 drivers/ide/ide-eh.c                      |    5 +-
 drivers/ide/ide-floppy.c                  |   27 +-
 drivers/ide/ide-floppy_ioctl.c            |   12 +-
 drivers/ide/ide-gd.c                      |   19 +-
 drivers/ide/ide-io.c                      |    8 +-
 drivers/ide/ide-pm.c                      |    8 +-
 drivers/ide/ide-tape.c                    |   22 +-
 drivers/md/dm-io.c                        |   12 +-
 drivers/md/dm-kcopyd.c                    |    2 +-
 drivers/md/dm-raid1.c                     |    2 +-
 drivers/md/dm-stripe.c                    |    2 +-
 drivers/md/dm.c                           |   47 +-
 drivers/md/linear.c                       |    2 +-
 drivers/md/md.c                           |   16 +-
 drivers/md/md.h                           |    4 +-
 drivers/md/multipath.c                    |    8 +-
 drivers/md/raid0.c                        |    2 +-
 drivers/md/raid1.c                        |   22 +-
 drivers/md/raid10.c                       |   12 +-
 drivers/md/raid5.c                        |    2 +-
 drivers/memstick/core/mspro_block.c       |   12 +-
 drivers/message/i2o/i2o_block.c           |   30 +-
 drivers/mmc/card/block.c                  |    5 +
 drivers/mmc/card/queue.c                  |    4 +-
 drivers/mtd/mtd_blkdevs.c                 |   15 +-
 drivers/s390/block/dasd.c                 |    8 +-
 drivers/s390/block/dcssblk.c              |    5 +
 drivers/s390/char/tape_block.c            |    8 +-
 drivers/scsi/aha1542.c                    |   25 -
 drivers/scsi/osd/osd_initiator.c          |    8 +-
 drivers/scsi/scsi_error.c                 |   12 +-
 drivers/scsi/scsi_lib.c                   |   14 +-
 drivers/scsi/sd.c                         |  126 ++-
 drivers/scsi/sd.h                         |    2 +-
 drivers/scsi/sr.c                         |   25 +-
 drivers/scsi/sun3_NCR5380.c               |    2 +-
 drivers/scsi/sun3_scsi.c                  |    2 +-
 drivers/scsi/sun3_scsi_vme.c              |    2 +-
 drivers/staging/hv/blkvsc_drv.c           |   13 +-
 drivers/xen/xenbus/xenbus_client.c        |   90 +-
 fs/bio.c                                  |    5 +-
 fs/block_dev.c                            |   10 +-
 fs/btrfs/disk-io.c                        |    8 +-
 fs/btrfs/inode.c                          |    6 +-
 fs/btrfs/volumes.c                        |   18 +-
 fs/coda/psdev.c                           |   12 +-
 fs/coda/upcall.c                          |   12 +-
 fs/exofs/ios.c                            |    2 +-
 fs/fs-writeback.c                         |  161 ++-
 fs/gfs2/log.c                             |    4 +-
 fs/gfs2/meta_io.c                         |    8 +-
 fs/gfs2/ops_fstype.c                      |    2 +-
 fs/nilfs2/segbuf.c                        |    2 +-
 fs/splice.c                               |   14 +-
 include/linux/Kbuild                      |    1 +
 include/linux/audit.h                     |    2 +-
 include/linux/backing-dev.h               |   23 +-
 include/linux/bio.h                       |  158 +--
 include/linux/blk_types.h                 |  193 +++
 include/linux/blkdev.h                    |  142 +--
 include/linux/blktrace_api.h              |   18 +-
 include/linux/coda_psdev.h                |    8 +-
 include/linux/drbd.h                      |    2 +-
 include/linux/drbd_nl.h                   |    9 +-
 include/linux/fs.h                        |   45 +-
 include/trace/events/block.h              |   15 +-
 include/trace/events/writeback.h          |  159 +++
 kernel/power/block_io.c                   |    2 +-
 kernel/trace/blktrace.c                   |   80 +-
 mm/backing-dev.c                          |  446 +++----
 mm/page-writeback.c                       |    5 +
 mm/page_io.c                              |    2 +-
 154 files changed, 4264 insertions(+), 3210 deletions(-)
 create mode 100644 include/linux/blk_types.h
 create mode 100644 include/trace/events/writeback.h

-- 
Jens Axboe


Confidentiality Notice: This e-mail message, its contents and any attachments to it are confidential to the intended recipient, and may contain information that is privileged and/or exempt from disclosure under applicable law. If you are not the intended recipient, please immediately notify the sender and destroy the original e-mail message and any attachments (and any copies that may have been made) from your system or otherwise. Any unauthorized use, copying, disclosure or distribution of this information is strictly prohibited.
