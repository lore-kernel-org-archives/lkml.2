Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619Ab2DXXiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 19:38:23 -0400
Received: from longford.logfs.org ([213.229.74.203]:56614 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757553Ab2DXXiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 19:38:20 -0400
Date: Tue, 24 Apr 2012 16:59:48 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] add blockconsole
Message-ID: <20120424205946.GH20610@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Console driver similar to netconsole, except it writes to a block
device.  Can be useful in a setup where netconsole, for whatever
reasons, is impractical.

Signed-off-by: Joern Engel <joern@logfs.org>
---
 Documentation/block/blockconsole.txt |   61 ++++
 block/partitions/Makefile            |    1 +
 block/partitions/blockconsole.c      |   22 ++
 block/partitions/check.c             |    4 +
 drivers/block/Kconfig                |    5 +
 drivers/block/Makefile               |    1 +
 drivers/block/blockconsole.c         |  523 ++++++++++++++++++++++++++++++++++
 include/linux/blockconsole.h         |    7 +
 8 files changed, 624 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/block/blockconsole.txt
 create mode 100644 block/partitions/blockconsole.c
 create mode 100644 drivers/block/blockconsole.c
 create mode 100644 include/linux/blockconsole.h

diff --git a/Documentation/block/blockconsole.txt b/Documentation/block/blockconsole.txt
new file mode 100644
index 0000000..e84d4ae
--- /dev/null
+++ b/Documentation/block/blockconsole.txt
@@ -0,0 +1,61 @@
+
+started by Jörn Engel <joern@logfs.org> 2012.03.17
+
+Introduction:
+=============
+
+This module logs kernel printk messages to block devices, e.g. usb
+sticks.  It allows after-the-fact debugging when the main
+disk/filesystem fails and serial consoles and netconsole are
+impractical.
+
+It can currently only be used built-in.  Blockconsole hooks into the
+partition scanning code and will bring up configured block devices as
+soon as possible.  While this doesn't allow capture of early kernel
+panics, it does capture most of the boot process.
+
+Block device configuration:
+==================================
+
+Blockconsole has no configuration parameter.  In order to use a block
+device for logging, the blockconsole header has to be written to the
+device in questions.  Logging to partitions is not supported.
+
+Example:
+  echo "Linux blockconsole version 1.0" > /dev/sdc
+
+If the string "Linux blockconsole version 1.0" is present at the
+beginning of the device, this device will be used by blockconsole upon
+next boot.  It is possible but not required to add an additional
+character before the string.  Usually that would be a newline.
+
+Miscellaneous notes:
+====================
+
+Once every megabyte blockconsole will write a copy of its header to
+the device.  This header consists of a newline, the string "Linux
+blockconsole version 1.0", a 64bit big-endian sequence number, plus
+another eight newlines for a total of 48 bytes.  This means that log
+messages can be interrupted by the header in mid-line and continue
+after the header.
+
+The 64bit big-endian sequence number is used by blockconsole to
+determine where to continue logging after a reboot.  New logs will be
+written to the first megabytes that wasn't written to by the last
+instance of blockconsole.  Therefore users might want to read the log
+device in a hex editor and look for the place where the header
+sequence number changes.  This marks the end of the log, or at least
+it marks a location less than one megabyte from the end of the log.
+
+The blockconsole header is constructed such that opening the log
+device in a text editor, ignoring memory constraints due to large
+devices, should just work and be reasonably non-confusing to readers.
+
+Writing to the log device is strictly circular.  This should give
+optimal performance and reliability on cheap devices, like usb sticks.
+
+Writing to block devices has to happen in sector granularity, while
+kernel logging happens in byte granularity.  In order not to lose
+messages in important cases like kernel crashes, a timer will write
+out partial sectors if no new messages appear for a while.  The
+unwritten part of the sector will be filled with newlines.
diff --git a/block/partitions/Makefile b/block/partitions/Makefile
index 03af8ea..bf26d4a 100644
--- a/block/partitions/Makefile
+++ b/block/partitions/Makefile
@@ -18,3 +18,4 @@ obj-$(CONFIG_IBM_PARTITION) += ibm.o
 obj-$(CONFIG_EFI_PARTITION) += efi.o
 obj-$(CONFIG_KARMA_PARTITION) += karma.o
 obj-$(CONFIG_SYSV68_PARTITION) += sysv68.o
+obj-$(CONFIG_BLOCKCONSOLE) += blockconsole.o
diff --git a/block/partitions/blockconsole.c b/block/partitions/blockconsole.c
new file mode 100644
index 0000000..79796a8
--- /dev/null
+++ b/block/partitions/blockconsole.c
@@ -0,0 +1,22 @@
+#include <linux/blockconsole.h>
+
+#include "check.h"
+
+int blockconsole_partition(struct parsed_partitions *state)
+{
+	Sector sect;
+	void *data;
+	int err = 0;
+
+	data = read_part_sector(state, 0, &sect);
+	if (!data)
+		return -EIO;
+	if (!bcon_magic_present(data))
+		goto out;
+
+	bcon_add(state->name);
+	err = 1;
+out:
+	put_dev_sector(sect);
+	return err;
+}
diff --git a/block/partitions/check.c b/block/partitions/check.c
index bc90867..8de99fa 100644
--- a/block/partitions/check.c
+++ b/block/partitions/check.c
@@ -36,11 +36,15 @@
 
 int warn_no_part = 1; /*This is ugly: should make genhd removable media aware*/
 
+int blockconsole_partition(struct parsed_partitions *state);
 static int (*check_part[])(struct parsed_partitions *) = {
 	/*
 	 * Probe partition formats with tables at disk address 0
 	 * that also have an ADFS boot block at 0xdc0.
 	 */
+#ifdef CONFIG_BLOCKCONSOLE
+	blockconsole_partition,
+#endif
 #ifdef CONFIG_ACORN_PARTITION_ICS
 	adfspart_check_ICS,
 #endif
diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index a796407..7ce033d 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -555,4 +555,9 @@ config BLK_DEV_RBD
 
 	  If unsure, say N.
 
+config BLOCKCONSOLE
+	tristate "Block device console logging support"
+	help
+	  This enables logging to block devices.
+
 endif # BLK_DEV
diff --git a/drivers/block/Makefile b/drivers/block/Makefile
index 5b79505..1eb7f902 100644
--- a/drivers/block/Makefile
+++ b/drivers/block/Makefile
@@ -41,5 +41,6 @@ obj-$(CONFIG_XEN_BLKDEV_BACKEND)	+= xen-blkback/
 obj-$(CONFIG_BLK_DEV_DRBD)     += drbd/
 obj-$(CONFIG_BLK_DEV_RBD)     += rbd.o
 obj-$(CONFIG_BLK_DEV_PCIESSD_MTIP32XX)	+= mtip32xx/
+obj-$(CONFIG_BLOCKCONSOLE)	+= blockconsole.o
 
 swim_mod-y	:= swim.o swim_asm.o
diff --git a/drivers/block/blockconsole.c b/drivers/block/blockconsole.c
new file mode 100644
index 0000000..e72bb64
--- /dev/null
+++ b/drivers/block/blockconsole.c
@@ -0,0 +1,523 @@
+#include <linux/bio.h>
+#include <linux/blockconsole.h>
+#include <linux/console.h>
+#include <linux/fs.h>
+#include <linux/kthread.h>
+#include <linux/mm.h>
+#include <linux/mount.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/workqueue.h>
+
+#define BLOCKCONSOLE_MAGIC	"Linux blockconsole version 1.0"
+#define BCON_HEADERSIZE		(48)
+#define PAGE_COUNT		(256)
+#define SECTOR_COUNT		(PAGE_COUNT * (PAGE_SIZE >> 9))
+#define CACHE_PAGE_MASK		(PAGE_COUNT - 1)
+#define CACHE_SECTOR_MASK	(SECTOR_COUNT - 1)
+#define CACHE_SIZE		(PAGE_COUNT << PAGE_SHIFT)
+#define CACHE_MASK		(CACHE_SIZE - 1)
+#define SECTOR_SHIFT		(9)
+#define SECTOR_SIZE		(1 << SECTOR_SHIFT)
+#define SECTOR_MASK		(~(SECTOR_SIZE-1))
+#define PG_SECTOR_MASK		((PAGE_SIZE >> 9) - 1)
+
+struct bcon_bio {
+	struct bio bio;
+	struct bio_vec bvec;
+	int in_flight;
+};
+
+struct blockconsole {
+	struct spinlock write_lock;
+	struct spinlock end_io_lock;
+	struct timer_list pad_timer;
+	int error_count;
+	int lost_bytes;
+	struct kref kref;
+	u64 console_bytes;
+	u64 write_bytes;
+	u64 max_bytes;
+	u64 round;
+	void *sector_array[SECTOR_COUNT];
+	struct bcon_bio bio_array[SECTOR_COUNT];
+	struct page *pages;
+	struct bcon_bio zero_bios[PAGE_COUNT];
+	struct page *zero_page;
+	struct block_device *bdev;
+	struct console console;
+	struct work_struct unregister_work;
+	struct task_struct *writeback_thread;
+};
+
+static void bcon_get(struct blockconsole *bc)
+{
+	kref_get(&bc->kref);
+}
+
+static void bcon_release(struct kref *kref)
+{
+	struct blockconsole *bc = container_of(kref, struct blockconsole, kref);
+
+	__free_pages(bc->zero_page, 0);
+	__free_pages(bc->pages, 8);
+	kfree(bc);
+}
+
+static void bcon_put(struct blockconsole *bc)
+{
+	kref_put(&bc->kref, bcon_release);
+}
+
+static int bcon_console_ofs(struct blockconsole *bc)
+{
+	return bc->console_bytes & ~SECTOR_MASK;
+}
+
+static int bcon_console_sector(struct blockconsole *bc)
+{
+	return (bc->console_bytes >> SECTOR_SHIFT) & CACHE_SECTOR_MASK;
+}
+
+static int bcon_write_sector(struct blockconsole *bc)
+{
+	return (bc->write_bytes >> SECTOR_SHIFT) & CACHE_SECTOR_MASK;
+}
+
+static void bcon_advance_console_bytes(struct blockconsole *bc, int bytes)
+{
+	bc->console_bytes += bytes;
+	if (bc->console_bytes >= bc->max_bytes)
+		bc->console_bytes = 0;
+	if ((bc->console_bytes & CACHE_MASK) == 0)
+		bc->console_bytes += BCON_HEADERSIZE;
+}
+
+static void request_complete(struct bio *bio, int err)
+{
+	complete((struct completion *)bio->bi_private);
+}
+
+static void bcon_init_first_page(struct blockconsole *bc)
+{
+	void *buf = page_address(bc->pages);
+	size_t len = strlen(BLOCKCONSOLE_MAGIC);
+	__be64 *be_round = buf + 32;
+	u64 round = ++(bc->round);
+
+	/* XXX memset to spaces */
+	memset(buf, 10, BCON_HEADERSIZE);
+	memcpy(buf + 1, BLOCKCONSOLE_MAGIC, len);
+	*be_round = cpu_to_be64(round);
+}
+
+static int sync_read(struct blockconsole *bc, u64 ofs)
+{
+	struct bio bio;
+	struct bio_vec bio_vec;
+	struct completion complete;
+
+	bio_init(&bio);
+	bio.bi_io_vec = &bio_vec;
+	bio_vec.bv_page = bc->pages;
+	bio_vec.bv_len = SECTOR_SIZE;
+	bio_vec.bv_offset = 0;
+	bio.bi_vcnt = 1;
+	bio.bi_idx = 0;
+	bio.bi_size = SECTOR_SIZE;
+	bio.bi_bdev = bc->bdev;
+	bio.bi_sector = ofs >> SECTOR_SHIFT;
+	init_completion(&complete);
+	bio.bi_private = &complete;
+	bio.bi_end_io = request_complete;
+
+	submit_bio(READ, &bio);
+	wait_for_completion(&complete);
+	return test_bit(BIO_UPTODATE, &bio.bi_flags) ? 0 : -EIO;
+}
+
+static void bcon_erase_segment(struct blockconsole *bc)
+{
+	int i;
+
+	for (i = 0; i < PAGE_COUNT; i++) {
+		struct bcon_bio *bcon_bio = bc->zero_bios + i;
+		struct bio *bio = &bcon_bio->bio;
+
+		/*
+		 * If the last erase hasn't finished yet, just skip it.  The log will
+		 * look messy, but that's all.
+		 */
+		rmb();
+		if (bcon_bio->in_flight)
+			continue;
+		bio_init(bio);
+		bio->bi_io_vec = &bcon_bio->bvec;
+		bio->bi_vcnt = 1;
+		bio->bi_size = PAGE_SIZE;
+		bio->bi_bdev = bc->bdev;
+		bio->bi_private = bc;
+		bio->bi_idx = 0;
+		bio->bi_sector = (bc->write_bytes + i * PAGE_SIZE) >> 9;
+		bcon_bio->in_flight = 1;
+		wmb();
+		/* We want the erase to go to the device first somehow */
+		submit_bio(WRITE | REQ_SOFTBARRIER, bio);
+	}
+}
+
+static void bcon_advance_write_bytes(struct blockconsole *bc, int bytes)
+{
+	bc->write_bytes += bytes;
+	if (bc->write_bytes >= bc->max_bytes) {
+		bc->write_bytes = 0;
+		bcon_init_first_page(bc);
+	}
+}
+
+static int bcon_find_end_of_log(struct blockconsole *bc)
+{
+	u64 start = 0, end = bc->max_bytes, middle;
+	__be64 *be_round = (bc->sector_array[1]) + 32;
+	int err;
+
+	sync_read(bc, 0);
+	memcpy(bc->sector_array[1], bc->sector_array[0], BCON_HEADERSIZE);
+	for (;;) {
+		middle = (start + end) / 2;
+		middle &= ~CACHE_MASK;
+		if (middle == start)
+			break;
+		err = sync_read(bc, middle);
+		if (err)
+			return err;
+		if (memcmp(bc->sector_array[1], bc->sector_array[0],
+					BCON_HEADERSIZE)) {
+			/* If the two differ, we haven't written that far yet */
+			end = middle;
+		} else {
+			start = middle;
+		}
+	}
+	bc->round = be64_to_cpu(*be_round);
+	if (middle == 0 && (bc->round == 0 || bc->round > 0x100000000ull)) {
+		/* Chances are, this device is brand-new */
+		bc->round = 0;
+		bc->console_bytes = bc->write_bytes = 0;
+		bcon_init_first_page(bc);
+	} else {
+		bc->console_bytes = bc->write_bytes = end;
+		memcpy(bc->sector_array[0], bc->sector_array[1], BCON_HEADERSIZE);
+	}
+	bcon_advance_console_bytes(bc, 0); /* To skip the header */
+	bcon_advance_write_bytes(bc, 0); /* To wrap around, if necessary */
+	bcon_erase_segment(bc);
+	return 0;
+}
+
+static void bcon_unregister(struct work_struct *work)
+{
+	struct blockconsole *bc = container_of(work, struct blockconsole,
+			unregister_work);
+
+	unregister_console(&bc->console);
+	del_timer_sync(&bc->pad_timer);
+	kthread_stop(bc->writeback_thread);
+	/* No new io will be scheduled anymore now */
+	bcon_put(bc);
+}
+
+#define BCON_MAX_ERRORS	10
+static void bcon_end_io(struct bio *bio, int err)
+{
+	struct bcon_bio *bcon_bio = container_of(bio, struct bcon_bio, bio);
+	struct blockconsole *bc = bio->bi_private;
+	unsigned long flags;
+
+	/*
+	 * We want to assume the device broken and free this console if
+	 * we accumulate too many errors.  But if errors are transient,
+	 * we also want to forget about them once writes succeed again.
+	 * Oh, and we only want to reset the counter if it hasn't reached
+	 * the limit yet, so we don't bcon_put() twice from here.
+	 */
+	spin_lock_irqsave(&bc->end_io_lock, flags);
+	if (err) {
+		if (bc->error_count++ == BCON_MAX_ERRORS) {
+			schedule_work(&bc->unregister_work);
+		}
+	} else {
+		if (bc->error_count && bc->error_count < BCON_MAX_ERRORS)
+			bc->error_count = 0;
+	}
+	bcon_bio->in_flight = 0;
+	wmb(); /* FIXME: isn't this implicit in the spin_unlock already? */
+	spin_unlock_irqrestore(&bc->end_io_lock, flags);
+	bcon_put(bc);
+}
+
+static void bcon_writesector(struct blockconsole *bc, int index)
+{
+	struct bcon_bio *bcon_bio = bc->bio_array + index;
+	struct bio *bio = &bcon_bio->bio;
+
+	rmb();
+	if (bcon_bio->in_flight)
+		return;
+	bcon_get(bc);
+
+	bio_init(bio);
+	bio->bi_io_vec = &bcon_bio->bvec;
+	bio->bi_vcnt = 1;
+	bio->bi_size = SECTOR_SIZE;
+	bio->bi_bdev = bc->bdev;
+	bio->bi_private = bc;
+	bio->bi_end_io = bcon_end_io;
+
+	bio->bi_idx = 0;
+	bio->bi_sector = bc->write_bytes >> 9;
+	bcon_bio->in_flight = 1;
+	wmb();
+	submit_bio(WRITE, bio);
+}
+
+static int bcon_writeback(void *_bc)
+{
+	struct blockconsole *bc = _bc;
+	struct sched_param(sp);
+
+	sp.sched_priority = MAX_RT_PRIO - 1; /* Highest realtime prio */
+	sched_setscheduler_nocheck(current, SCHED_FIFO, &sp);
+	for (;;) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule();
+		if (kthread_should_stop())
+			break;
+		while (bcon_write_sector(bc) != bcon_console_sector(bc)) {
+			bcon_writesector(bc, bcon_write_sector(bc));
+			bcon_advance_write_bytes(bc, SECTOR_SIZE);
+			if (bcon_write_sector(bc) == 0) {
+				bcon_erase_segment(bc);
+			}
+		}
+	}
+	return 0;
+}
+
+static void bcon_pad(unsigned long data)
+{
+	struct blockconsole *bc = (void *)data;
+	unsigned int n;
+	unsigned long flags;
+
+	spin_lock_irqsave(&bc->write_lock, flags);
+	if (bcon_console_ofs(bc) != 0) {
+		n = SECTOR_SIZE - bcon_console_ofs(bc);
+		memset(bc->sector_array[bcon_console_sector(bc)]
+				+ bcon_console_ofs(bc), ' ', n);
+		memset(bc->sector_array[bcon_console_sector(bc)] + 511, 10, 1);
+		bcon_advance_console_bytes(bc, n);
+		wake_up_process(bc->writeback_thread);
+	}
+	spin_unlock_irqrestore(&bc->write_lock, flags);
+}
+
+static int bcon_handle_lost_lines(struct blockconsole *bc, void *buf, size_t n)
+{
+	int written;
+
+	if (!bc->lost_bytes)
+		return 0;
+	written = snprintf(buf, n, "blockconsole dropped %d bytes\n",
+			bc->lost_bytes);
+	if (written < n)
+		return 0;
+	bc->lost_bytes = 0;
+	return 1;
+}
+
+static void bcon_write(struct console *console, const char *msg,
+		unsigned int len)
+{
+	struct blockconsole *bc = container_of(console, struct blockconsole,
+			console);
+	unsigned int n;
+	unsigned long flags;
+	int i;
+
+	spin_lock_irqsave(&bc->write_lock, flags);
+	while (len) {
+		i = bcon_console_sector(bc);
+		rmb();
+		if (bc->bio_array[i].in_flight) {
+			bc->lost_bytes += len;
+			break;
+		}
+		n = min_t(int, len, SECTOR_SIZE - bcon_console_ofs(bc));
+		if (bcon_handle_lost_lines(bc, bc->sector_array[i]
+					+ bcon_console_ofs(bc), n) == 0) {
+			memcpy(bc->sector_array[i] + bcon_console_ofs(bc), msg, n);
+			len -= n;
+			msg += n;
+		}
+		bcon_advance_console_bytes(bc, n);
+		if (bcon_console_ofs(bc) == 0) {
+			wake_up_process(bc->writeback_thread);
+		}
+	}
+	if (bcon_console_ofs(bc) != 0)
+		mod_timer(&bc->pad_timer, jiffies + HZ);
+	spin_unlock_irqrestore(&bc->write_lock, flags);
+}
+
+static void bcon_init_bios(struct blockconsole *bc)
+{
+	int i;
+
+	for (i = 0; i < SECTOR_COUNT; i++) {
+		int page_index = i >> (PAGE_SHIFT - SECTOR_SHIFT);
+		struct page *page = bc->pages + page_index;
+		struct bcon_bio *bcon_bio = bc->bio_array + i;
+		struct bio_vec *bvec = &bcon_bio->bvec;
+
+		bcon_bio->in_flight = 0;
+		bc->sector_array[i] = page_address(bc->pages + page_index)
+			+ SECTOR_SIZE * (i & PG_SECTOR_MASK);
+		bvec->bv_page = page;
+		bvec->bv_len = SECTOR_SIZE;
+		bvec->bv_offset = SECTOR_SIZE * (i & PG_SECTOR_MASK);
+	}
+}
+
+static void bcon_init_zero_bio(struct blockconsole *bc)
+{
+	int i;
+
+	memset(page_address(bc->zero_page), 0, PAGE_SIZE);
+	for (i = 0; i < PAGE_COUNT; i++) {
+		struct bcon_bio *bcon_bio = bc->zero_bios + i;
+		struct bio_vec *bvec = &bcon_bio->bvec;
+
+		bcon_bio->in_flight = 0;
+		bvec->bv_page = bc->zero_page;
+		bvec->bv_len = PAGE_SIZE;
+		bvec->bv_offset = 0;
+	}
+}
+
+static int bcon_create(const char *devname)
+{
+	const fmode_t mode = FMODE_READ | FMODE_WRITE;
+	struct blockconsole *bc;
+	int err;
+
+	bc = kzalloc(sizeof(*bc), GFP_KERNEL);
+	if (!bc)
+		return -ENOMEM;
+	spin_lock_init(&bc->write_lock);
+	spin_lock_init(&bc->end_io_lock);
+	strcpy(bc->console.name, "blockcon");
+	bc->console.flags = CON_PRINTBUFFER | CON_ENABLED; /* FIXME: document flags */
+	bc->console.write = bcon_write;
+	bc->bdev = blkdev_get_by_path(devname, mode, NULL);
+#ifndef MODULE
+	if (IS_ERR(bc->bdev)) {
+		dev_t devt = name_to_dev_t(devname);
+		if (devt)
+			bc->bdev = blkdev_get_by_dev(devt, mode, NULL);
+	}
+#endif
+	if (IS_ERR(bc->bdev))
+		goto out;
+	bc->pages = alloc_pages(GFP_KERNEL, 8);
+	if (!bc->pages)
+		goto out;
+	bc->zero_page = alloc_pages(GFP_KERNEL, 0);
+	if (!bc->zero_page)
+		goto out1;
+	bcon_init_bios(bc);
+	bcon_init_zero_bio(bc);
+	setup_timer(&bc->pad_timer, bcon_pad, (unsigned long)bc);
+	bc->max_bytes = bc->bdev->bd_inode->i_size & ~CACHE_MASK;
+	err = bcon_find_end_of_log(bc);
+	if (err)
+		goto out2;
+	kref_init(&bc->kref); /* This reference gets freed on errors */
+	bc->writeback_thread = kthread_run(bcon_writeback, bc, "bcon_%s",
+			devname);
+	if (IS_ERR(bc->writeback_thread))
+		goto out2;
+	INIT_WORK(&bc->unregister_work, bcon_unregister);
+	register_console(&bc->console);
+	printk(KERN_INFO "blockconsole: now logging to %s\n", devname);
+	return 0;
+
+out2:
+	__free_pages(bc->zero_page, 0);
+out1:
+	__free_pages(bc->pages, 8);
+out:
+	kfree(bc);
+	/* Not strictly correct, be the caller doesn't care */
+	return -ENOMEM;
+}
+
+static void bcon_create_fuzzy(const char *name)
+{
+	char *longname;
+	int err;
+
+	err = bcon_create(name);
+	if (err) {
+		longname = kzalloc(strlen(name) + 6, GFP_KERNEL);
+		if (!longname)
+			return;
+		strcpy(longname, "/dev/");
+		strcat(longname, name);
+		bcon_create(longname);
+		kfree(longname);
+	}
+}
+
+static DEFINE_SPINLOCK(device_lock);
+static char scanned_devices[80];
+
+static void bcon_do_add(struct work_struct *work)
+{
+	char local_devices[80], *name, *remainder = local_devices;
+
+	spin_lock(&device_lock);
+	memcpy(local_devices, scanned_devices, sizeof(local_devices));
+	memset(scanned_devices, 0, sizeof(scanned_devices));
+	spin_unlock(&device_lock);
+
+	while (remainder && remainder[0]) {
+		name = strsep(&remainder, ",");
+		bcon_create_fuzzy(name);
+	}
+}
+
+DECLARE_WORK(bcon_add_work, bcon_do_add);
+
+void bcon_add(const char *name)
+{
+	/*
+	 * We add each name to a small static buffer and ask for a workqueue
+	 * to go pick it up asap.  Once it is picked up, the buffer is empty
+	 * again, so hopefully it will suffice for all sane users.
+	 */
+	spin_lock(&device_lock);
+	if (scanned_devices[0])
+		strncat(scanned_devices, ",", sizeof(scanned_devices));
+	strncat(scanned_devices, name, sizeof(scanned_devices));
+	spin_unlock(&device_lock);
+	schedule_work(&bcon_add_work);
+}
+
+int bcon_magic_present(const void *data)
+{
+	size_t len = strlen(BLOCKCONSOLE_MAGIC);
+
+	return memcmp(data + 1, BLOCKCONSOLE_MAGIC, len) == 0 ||
+		memcmp(data, BLOCKCONSOLE_MAGIC, len) == 0;
+}
diff --git a/include/linux/blockconsole.h b/include/linux/blockconsole.h
new file mode 100644
index 0000000..114f7c5
--- /dev/null
+++ b/include/linux/blockconsole.h
@@ -0,0 +1,7 @@
+#ifndef LINUX_BLOCKCONSOLE_H
+#define LINUX_BLOCKCONSOLE_H
+
+int bcon_magic_present(const void *data);
+void bcon_add(const char *name);
+
+#endif
-- 
1.7.9.1

