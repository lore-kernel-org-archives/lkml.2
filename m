Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab2GWVSs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 17:18:48 -0400
Received: from longford.logfs.org ([213.229.74.203]:44599 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755Ab2GWVSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 17:18:46 -0400
Date: Mon, 23 Jul 2012 16:04:59 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, Steve Hodgson <steve@purestorage.com>
Subject: Re: [PATCH] add blockconsole version 1.1
Message-ID: <20120723200459.GD17767@logfs.org>
References: <20120424205946.GH20610@logfs.org>
 <x49zka0j5bk.fsf@segfault.boston.devel.redhat.com>
 <20120425132513.GA23492@logfs.org>
 <x49vcknkdvn.fsf@segfault.boston.devel.redhat.com>
 <20120712174633.GA7248@logfs.org>
 <20120713130336.GC10298@x1.osrc.amd.com>
 <20120713162009.GA10268@logfs.org>
 <20120716124614.GA19497@x1.osrc.amd.com>
 <20120718185335.GA1771@logfs.org>
 <20120718214520.GA14067@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120718214520.GA14067@liondog.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 July 2012 23:45:21 +0200, Borislav Petkov wrote:
> 
> Something like the above, just slap it at the beginning of
> Documentation/block/blockconsole.txt for impatient people like me and
> that's it :-).

And below is an updated patch with your changes folded in.  I did a
few minor tweaks, so there is every possibility I may have messed it
up.

Jörn

--
You can't tell where a program is going to spend its time. Bottlenecks
occur in surprising places, so don't try to second guess and put in a
speed hack until you've proven that's where the bottleneck is.
-- Rob Pike

[PATCH 1/2] add blockconsole version 1.1

Console driver similar to netconsole, except it writes to a block
device.  Can be useful in a setup where netconsole, for whatever
reasons, is impractical.

Changes since version 1.0:
- Header format overhaul, addressing several annoyances when actually
  using blockconsole for production.
- Steve Hodgson added a panic notifier.
- Added improvements from Borislav Petkov.

Signed-off-by: Steve Hodgson <steve@purestorage.com>
Signed-off-by: Joern Engel <joern@logfs.org>
---
 Documentation/block/blockconsole.txt            |   94 ++++
 Documentation/block/blockconsole/bcon_tail      |   57 +++
 Documentation/block/blockconsole/mkblockconsole |   24 +
 block/partitions/Makefile                       |    1 +
 block/partitions/blockconsole.c                 |   22 +
 block/partitions/check.c                        |    4 +
 drivers/block/Kconfig                           |    6 +
 drivers/block/Makefile                          |    1 +
 drivers/block/blockconsole.c                    |  612 +++++++++++++++++++++++
 include/linux/blockconsole.h                    |    7 +
 include/linux/mount.h                           |    2 +-
 init/do_mounts.c                                |    4 +-
 12 files changed, 831 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/block/blockconsole.txt
 create mode 100755 Documentation/block/blockconsole/bcon_tail
 create mode 100755 Documentation/block/blockconsole/mkblockconsole
 create mode 100644 block/partitions/blockconsole.c
 create mode 100644 drivers/block/blockconsole.c
 create mode 100644 include/linux/blockconsole.h

diff --git a/Documentation/block/blockconsole.txt b/Documentation/block/blockconsole.txt
new file mode 100644
index 0000000..2b45516
--- /dev/null
+++ b/Documentation/block/blockconsole.txt
@@ -0,0 +1,94 @@
+started by Jörn Engel <joern@logfs.org> 2012.03.17
+
+Blocksonsole for the impatient
+==============================
+
+1. Find an unused USB stick and prepare it for blockconsole by writing
+   the blockconsole signature to it:
+   $ ./mkblockconsole /dev/<usb_stick>
+
+2. USB stick is ready for use, replug it so that the kernel can start
+   logging to it.
+
+3. After you've done logging, read out the logs from it like this:
+   $ ./bcon_tail
+
+   This creates a file called /var/log/bcon.<UUID> which contains the
+   last 16M of the logs.  Open it with a sane editor like vim which
+   can display zeroed gaps as a single line and start staring at the
+   logs.
+   For the really impatient, use:
+   $ vi `./bcon_tail`
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
+device in question.  Logging to partitions is not supported.
+
+The example program mkblockconsole can be used to generate such a
+header on a device.
+
+Header format:
+==============
+
+A legal header looks like this:
+
+Linux blockconsole version 1.1
+818cf322
+00000000
+00000000
+
+It consists of a newline, the "Linux blockconsole version 1.1" string
+plus three numbers on separate lines each.  Numbers are all 32bit,
+represented as 8-byte hex strings, with letters in lowercase.  The
+first number is a uuid for this particular console device.  Just pick
+a random number when generating the device.  The second number is a
+wrap counter and unlikely to ever increment.  The third is a tile
+counter, with a tile being one megabyte in size.
+
+Miscellaneous notes:
+====================
+
+Blockconsole will write a new header for every tile or once every
+megabyte.  The header starts with a newline in order to ensure the
+"Linux blockconsole...' string always ends up at the beginning of a
+line if you read the blockconsole in a text editor.
+
+The blockconsole header is constructed such that opening the log
+device in a text editor, ignoring memory constraints due to large
+devices, should just work and be reasonably non-confusing to readers.
+However, the example program bcon_tail can be used to copy the last 16
+tiles of the log device to /var/log/bcon.<uuid>, which should be much
+easier to handle.
+
+The wrap counter is used by blockconsole to determine where to
+continue logging after a reboot.  New logs will be written to the
+first tile that wasn't written to by the last instance of
+blockconsole.  Similarly bcon_tail is doing a binary search to find
+the end of the log.
+
+Writing to the log device is strictly circular.  This should give
+optimal performance and reliability on cheap devices, like usb sticks.
+
+Writing to block devices has to happen in sector granularity, while
+kernel logging happens in byte granularity.  In order not to lose
+messages in important cases like kernel crashes, a timer will write
+out partial sectors if no new messages appear for a while.  The
+unwritten part of the sector will be filled with spaces and a single
+newline.  In a quiet system, these empty lines can make up the bulk of
+the log.
diff --git a/Documentation/block/blockconsole/bcon_tail b/Documentation/block/blockconsole/bcon_tail
new file mode 100755
index 0000000..5d788c9
--- /dev/null
+++ b/Documentation/block/blockconsole/bcon_tail
@@ -0,0 +1,57 @@
+#!/bin/bash
+
+TAIL_LEN=16
+TEMPLATE=/tmp/bcon_template
+BUF=/tmp/bcon_buf
+
+if [ -z "$(which lsscsi)" ]; then
+	echo "You need to install the lsscsi package on your distro."
+	exit 1
+fi
+
+end_of_log() {
+	DEV=$1
+	UUID=`head -c40 $DEV|tail -c8`
+	LOGFILE=/var/log/bcon.$UUID
+	SECTORS=`hdparm -g $DEV|grep sectors|sed 's/.*sectors = \([0-9]*\).*/\1/'`
+	#MSIZE=`expr $SECTORS / 2048`
+	dd if=$DEV iflag=direct bs=512 2>/dev/null|head -c50 > $TEMPLATE
+	#START, MIDDLE and END are in sectors
+	START=0
+	MIDDLE=$SECTORS
+	END=$SECTORS
+	while true; do
+		MIDDLE=`expr \( \( $END + $START \) / 4096 \) \* 2048`
+		if [ $MIDDLE -eq $START ]; then
+			break
+		fi
+		dd if=$DEV iflag=direct bs=512 count=1 skip=$MIDDLE 2>/dev/null|head -c50 > $BUF
+		if diff -q $BUF $TEMPLATE > /dev/null; then
+			START=$MIDDLE
+		else
+			END=$MIDDLE
+		fi
+	done
+	#switch to megabytes
+	END=`expr $END / 2048`
+	START=`expr $START / 2048`
+	if [ $START -lt $TAIL_LEN ]; then
+		START=0
+	else
+		START=`expr $START - $TAIL_LEN + 1`
+	fi
+	LEN=`expr $END - $START`
+	dd if=$DEV iflag=direct bs=1M count=$LEN skip=$START >$LOGFILE 2>/dev/null
+	echo $LOGFILE
+}
+
+# HEADER contains a newline, so the funny quoting is necessary
+HEADER='
+Linux blockconsole version 1.1'
+CANDIDATES=`lsscsi |sed 's|.*/dev|/dev|'`
+
+for DEV in $CANDIDATES; do
+	if [ "`head -c32 $DEV`" == "$HEADER" ]; then
+		end_of_log $DEV
+	fi
+done
diff --git a/Documentation/block/blockconsole/mkblockconsole b/Documentation/block/blockconsole/mkblockconsole
new file mode 100755
index 0000000..05c4ad8
--- /dev/null
+++ b/Documentation/block/blockconsole/mkblockconsole
@@ -0,0 +1,24 @@
+#!/bin/sh
+
+if [ ! $# -eq 1 ]; then
+	echo "Usage: $0 <dev>"
+	exit 1
+elif mount|fgrep -q $1; then
+	echo Device appears to be mounted - aborting
+	exit 1
+else
+	dd if=/dev/zero bs=1M count=1 > $1
+	# The funky formatting is actually needed!
+	UUID=`head -c4 /dev/urandom |hexdump -e '/4 "%08x"'`
+	echo > /tmp/$UUID
+	echo 'Linux blockconsole version 1.1' >> /tmp/$UUID
+	echo "$UUID" >> /tmp/$UUID
+	echo 00000000 >> /tmp/$UUID
+	echo 00000000 >> /tmp/$UUID
+	for i in `seq 452`; do echo -n " " >> /tmp/$UUID; done
+	echo >> /tmp/$UUID
+	cat /tmp/$UUID > $1
+	rm /tmp/$UUID
+	sync
+	exit 0
+fi
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
index a796407..637c952 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -555,4 +555,10 @@ config BLK_DEV_RBD
 
 	  If unsure, say N.
 
+config BLOCKCONSOLE
+	bool "Block device console logging support"
+	help
+	  This enables logging to block devices.
+	  See <file:Documentation/block/blockconsole.txt> for details.
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
index 0000000..09f239c
--- /dev/null
+++ b/drivers/block/blockconsole.c
@@ -0,0 +1,612 @@
+/*
+ * Blockconsole - write kernel console to a block device
+ *
+ * Copyright (C) 2012  Joern Engel <joern@logfs.org>
+ */
+#include <linux/bio.h>
+#include <linux/blockconsole.h>
+#include <linux/console.h>
+#include <linux/fs.h>
+#include <linux/kref.h>
+#include <linux/kthread.h>
+#include <linux/mm.h>
+#include <linux/mount.h>
+#include <linux/random.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/workqueue.h>
+
+#define BLOCKCONSOLE_MAGIC_OLD	"\nLinux blockconsole version 1.0\n"
+#define BLOCKCONSOLE_MAGIC	"\nLinux blockconsole version 1.1\n"
+#define BCON_UUID_OFS		(32)
+#define BCON_ROUND_OFS		(41)
+#define BCON_TILE_OFS		(50)
+#define BCON_HEADERSIZE		(50)
+#define BCON_LONG_HEADERSIZE	(59) /* with tile index */
+
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
+	void *sector;
+	int in_flight;
+};
+
+struct blockconsole {
+	char devname[32];
+	struct spinlock end_io_lock;
+	struct timer_list pad_timer;
+	int error_count;
+	struct kref kref;
+	u64 console_bytes;
+	u64 write_bytes;
+	u64 max_bytes;
+	u32 round;
+	u32 uuid;
+	struct bcon_bio bio_array[SECTOR_COUNT];
+	struct page *pages;
+	struct bcon_bio zero_bios[PAGE_COUNT];
+	struct page *zero_page;
+	struct block_device *bdev;
+	struct console console;
+	struct work_struct unregister_work;
+	struct task_struct *writeback_thread;
+	struct notifier_block panic_block;
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
+	invalidate_mapping_pages(bc->bdev->bd_inode->i_mapping, 0, -1);
+	blkdev_put(bc->bdev, FMODE_READ|FMODE_WRITE);
+	kfree(bc);
+}
+
+static void bcon_put(struct blockconsole *bc)
+{
+	kref_put(&bc->kref, bcon_release);
+}
+
+static int __bcon_console_ofs(u64 console_bytes)
+{
+	return console_bytes & ~SECTOR_MASK;
+}
+
+static int bcon_console_ofs(struct blockconsole *bc)
+{
+	return __bcon_console_ofs(bc->console_bytes);
+}
+
+static int __bcon_console_sector(u64 console_bytes)
+{
+	return (console_bytes >> SECTOR_SHIFT) & CACHE_SECTOR_MASK;
+}
+
+static int bcon_console_sector(struct blockconsole *bc)
+{
+	return __bcon_console_sector(bc->console_bytes);
+}
+
+static int bcon_write_sector(struct blockconsole *bc)
+{
+	return (bc->write_bytes >> SECTOR_SHIFT) & CACHE_SECTOR_MASK;
+}
+
+static void clear_sector(void *sector)
+{
+	memset(sector, ' ', 511);
+	memset(sector + 511, 10, 1);
+}
+
+static void bcon_init_first_page(struct blockconsole *bc)
+{
+	char *buf = page_address(bc->pages);
+	size_t len = strlen(BLOCKCONSOLE_MAGIC);
+	u32 tile = bc->console_bytes >> 20; /* We overflow after 4TB - fine */
+
+	clear_sector(buf);
+	memcpy(buf, BLOCKCONSOLE_MAGIC, len);
+	sprintf(buf + BCON_UUID_OFS, "%08x", bc->uuid);
+	sprintf(buf + BCON_ROUND_OFS, "%08x", bc->round);
+	sprintf(buf + BCON_TILE_OFS, "%08x", tile);
+	/* replace NUL with newline */
+	buf[BCON_UUID_OFS + 8] = 10;
+	buf[BCON_ROUND_OFS + 8] = 10;
+	buf[BCON_TILE_OFS + 8] = 10;
+}
+
+static void bcon_advance_console_bytes(struct blockconsole *bc, int bytes)
+{
+	u64 old, new;
+
+	do {
+		old = bc->console_bytes;
+		new = old + bytes;
+		if (new >= bc->max_bytes)
+			new = 0;
+		if ((new & CACHE_MASK) == 0) {
+			bcon_init_first_page(bc);
+			new += BCON_LONG_HEADERSIZE;
+		}
+	} while (cmpxchg64(&bc->console_bytes, old, new) != old);
+}
+
+static void request_complete(struct bio *bio, int err)
+{
+	complete((struct completion *)bio->bi_private);
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
+		bc->round++;
+	}
+}
+
+static int bcon_convert_old_format(struct blockconsole *bc)
+{
+	bc->uuid = get_random_int();
+	bc->round = 0;
+	bc->console_bytes = bc->write_bytes = 0;
+	bcon_advance_console_bytes(bc, 0); /* To skip the header */
+	bcon_advance_write_bytes(bc, 0); /* To wrap around, if necessary */
+	bcon_erase_segment(bc);
+	printk(KERN_INFO"blockconsole: converted %s from old format\n",
+			bc->devname);
+	return 0;
+}
+
+static int bcon_find_end_of_log(struct blockconsole *bc)
+{
+	u64 start = 0, end = bc->max_bytes, middle;
+	void *sec0 = bc->bio_array[0].sector;
+	void *sec1 = bc->bio_array[1].sector;
+	int err, version;
+
+	err = sync_read(bc, 0);
+	if (err)
+		return err;
+	/* Second sanity check, out of sheer paranoia */
+	version = bcon_magic_present(sec0);
+	if (version == 10)
+		return bcon_convert_old_format(bc);
+	bc->uuid = simple_strtoull(sec0 + BCON_UUID_OFS, NULL, 16);
+	bc->round = simple_strtoull(sec0 + BCON_ROUND_OFS, NULL, 16);
+
+	memcpy(sec1, sec0, BCON_HEADERSIZE);
+	for (;;) {
+		middle = (start + end) / 2;
+		middle &= ~CACHE_MASK;
+		if (middle == start)
+			break;
+		err = sync_read(bc, middle);
+		if (err)
+			return err;
+		if (memcmp(sec1, sec0, BCON_HEADERSIZE)) {
+			/* If the two differ, we haven't written that far yet */
+			end = middle;
+		} else {
+			start = middle;
+		}
+	}
+	bc->console_bytes = bc->write_bytes = end;
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
+	atomic_notifier_chain_unregister(&panic_notifier_list, &bc->panic_block);
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
+			printk(KERN_INFO"blockconsole: no longer logging to %s\n", bc->devname);
+			schedule_work(&bc->unregister_work);
+		}
+	} else {
+		if (bc->error_count && bc->error_count < BCON_MAX_ERRORS)
+			bc->error_count = 0;
+	}
+	/*
+	 * Add padding (a bunch of spaces and a newline) early so bcon_pad
+	 * only has to advance a pointer.
+	 */
+	clear_sector(bcon_bio->sector);
+	bcon_bio->in_flight = 0;
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
+
+	/*
+	 * We deliberately race against bcon_write here.  If we lose the race,
+	 * our padding is no longer where we expected it to be, i.e. it is
+	 * no longer a bunch of spaces with a newline at the end.  There could
+	 * not be a newline at all or it could be somewhere in the middle.
+	 * Either way, the log corruption is fairly obvious to spot and ignore
+	 * for human readers.
+	 */
+	n = SECTOR_SIZE - bcon_console_ofs(bc);
+	if (n != SECTOR_SIZE) {
+		bcon_advance_console_bytes(bc, n);
+		wake_up_process(bc->writeback_thread);
+	}
+}
+
+static void bcon_write(struct console *console, const char *msg,
+		unsigned int len)
+{
+	struct blockconsole *bc = container_of(console, struct blockconsole,
+			console);
+	unsigned int n;
+	u64 console_bytes;
+	int i;
+
+	while (len) {
+		console_bytes = bc->console_bytes;
+		i = __bcon_console_sector(console_bytes);
+		rmb();
+		if (bc->bio_array[i].in_flight)
+			break;
+		n = min_t(int, len, SECTOR_SIZE -
+				__bcon_console_ofs(console_bytes));
+		memcpy(bc->bio_array[i].sector +
+				__bcon_console_ofs(console_bytes), msg, n);
+		len -= n;
+		msg += n;
+		bcon_advance_console_bytes(bc, n);
+	}
+	wake_up_process(bc->writeback_thread);
+	mod_timer(&bc->pad_timer, jiffies + HZ);
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
+		bcon_bio->sector = page_address(bc->pages + page_index)
+			+ SECTOR_SIZE * (i & PG_SECTOR_MASK);
+		clear_sector(bcon_bio->sector);
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
+static int blockconsole_panic(struct notifier_block *this, unsigned long event,
+		void *ptr)
+{
+	struct blockconsole *bc = container_of(this, struct blockconsole,
+			panic_block);
+	unsigned int n;
+
+	n = SECTOR_SIZE - bcon_console_ofs(bc);
+	if (n != SECTOR_SIZE)
+		bcon_advance_console_bytes(bc, n);
+	bcon_writeback(bc);
+	return NOTIFY_DONE;
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
+	memset(bc->devname, ' ', sizeof(bc->devname));
+	strlcpy(bc->devname, devname, sizeof(bc->devname));
+	spin_lock_init(&bc->end_io_lock);
+	strcpy(bc->console.name, "bcon");
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
+	bc->panic_block.notifier_call = blockconsole_panic;
+	bc->panic_block.priority = INT_MAX;
+	atomic_notifier_chain_register(&panic_notifier_list, &bc->panic_block);
+	printk(KERN_INFO"blockconsole: now logging to %s at %llx\n", devname,
+			bc->console_bytes >> 20);
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
+static int isnum(const void *data)
+{
+	unsigned long long num;
+	char *end;
+
+	/* Must be an 8-digit hex number followed by newline */
+	num = simple_strtoull(data, &end, 16);
+	if (end != data + 8)
+		return 0;
+	if (*end != 10)
+		return 0;
+	if (num > 0xffffffffull)
+		return 0;
+	return 1;
+}
+
+int bcon_magic_present(const void *data)
+{
+	size_t len = strlen(BLOCKCONSOLE_MAGIC);
+
+	if (!memcmp(data, BLOCKCONSOLE_MAGIC_OLD, len))
+		return 10;
+	if (memcmp(data, BLOCKCONSOLE_MAGIC, len))
+		return 0;
+	if (!isnum(data + BCON_UUID_OFS))
+		return 0;
+	if (!isnum(data + BCON_ROUND_OFS))
+		return 0;
+	if (!isnum(data + BCON_TILE_OFS))
+		return 0;
+	return 11;
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
diff --git a/include/linux/mount.h b/include/linux/mount.h
index d7029f4..6b5fa77 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -74,6 +74,6 @@ extern struct vfsmount *vfs_kern_mount(struct file_system_type *type,
 extern void mnt_set_expiry(struct vfsmount *mnt, struct list_head *expiry_list);
 extern void mark_mounts_for_expiry(struct list_head *mounts);
 
-extern dev_t name_to_dev_t(char *name);
+extern dev_t name_to_dev_t(const char *name);
 
 #endif /* _LINUX_MOUNT_H */
diff --git a/init/do_mounts.c b/init/do_mounts.c
index d3f0aee..a6d9bcb 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -106,7 +106,7 @@ no_match:
  *
  * Returns the matching dev_t on success or 0 on failure.
  */
-static dev_t devt_from_partuuid(char *uuid_str)
+static dev_t devt_from_partuuid(const char *uuid_str)
 {
 	dev_t res = 0;
 	struct device *dev = NULL;
@@ -183,7 +183,7 @@ done:
  *	bangs.
  */
 
-dev_t name_to_dev_t(char *name)
+dev_t name_to_dev_t(const char *name)
 {
 	char s[32];
 	char *p;
-- 
1.7.10.4

