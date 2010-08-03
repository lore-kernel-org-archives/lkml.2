Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab0HCJyz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 05:54:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:50316 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755145Ab0HCJyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 05:54:53 -0400
Message-ID: <4C57E765.2000508@kernel.org>
Date: Tue, 03 Aug 2010 11:54:45 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: stable@kernel.org, Vladislav Bolkhovitin <vst@vlnb.net>,
        Bryan Mesich <bryan.mesich@ndsu.edu>, scst-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, Neil Brown <neilb@suse.de>
Subject: [PATCH 2/2 block#for-2.6.36] bio, fs: separate out bio_types.h and
 define READ/WRITE constants in terms of BIO_RW_* flags
References: <20100628010346.GA2376@atlantis.cc.ndsu.nodak.edu>	<4C28EFD6.2070203@vlnb.net>	<20100714190325.GA25148@atlantis.cc.ndsu.nodak.edu>	<4C3EF3AD.5070509@vlnb.net>	<20100723191844.GB31152@atlantis.cc.ndsu.nodak.edu>	<4C4D7DF5.9060909@vlnb.net>	<20100727220110.GF31152@atlantis.cc.ndsu.nodak.edu>	<4C5073F3.1060406@vlnb.net>	<4C52A98A.7060507@kernel.org> <20100802104227.79340b49@notabene> <4C56D397.8010305@kernel.org> <4C5724E8.9010204@kernel.dk>
In-Reply-To: <4C5724E8.9010204@kernel.dk>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 03 Aug 2010 09:54:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux/fs.h hard coded READ/WRITE constants which should match BIO_RW_*
flags.  This is fragile and caused breakage during BIO_RW_* flag
rearrangement.  The hardcoding is to avoid include dependency hell.

Create linux/bio_types.h which contatins definitions for bio data
structures and flags and include it from bio.h and fs.h, and make fs.h
define all READ/WRITE related constants in terms of BIO_RW_* flags.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axobe <axboe@kernel.dk>
---
I renamed the file to blk_types.h instead of bio_types.h as it now
contains the REQ bits too.

 include/linux/bio.h       |  183 -------------------------------------------
 include/linux/blk_types.h |  193 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h        |   15 +--
 3 files changed, 204 insertions(+), 187 deletions(-)

Index: work/include/linux/bio.h
===================================================================
--- work.orig/include/linux/bio.h
+++ work/include/linux/bio.h
@@ -9,7 +9,7 @@
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
-
+ *
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
@@ -28,6 +28,9 @@

 #include <asm/io.h>

+/* struct bio, bio_vec and BIO_* flags are defined in blk_types.h */
+#include <linux/blk_types.h>
+
 #define BIO_DEBUG

 #ifdef BIO_DEBUG
@@ -41,184 +44,6 @@
 #define BIO_MAX_SECTORS		(BIO_MAX_SIZE >> 9)

 /*
- * was unsigned short, but we might as well be ready for > 64kB I/O pages
- */
-struct bio_vec {
-	struct page	*bv_page;
-	unsigned int	bv_len;
-	unsigned int	bv_offset;
-};
-
-struct bio_set;
-struct bio;
-struct bio_integrity_payload;
-typedef void (bio_end_io_t) (struct bio *, int);
-typedef void (bio_destructor_t) (struct bio *);
-
-/*
- * main unit of I/O for the block layer and lower layers (ie drivers and
- * stacking drivers)
- */
-struct bio {
-	sector_t		bi_sector;	/* device address in 512 byte
-						   sectors */
-	struct bio		*bi_next;	/* request queue link */
-	struct block_device	*bi_bdev;
-	unsigned long		bi_flags;	/* status, command, etc */
-	unsigned long		bi_rw;		/* bottom bits READ/WRITE,
-						 * top bits priority
-						 */
-
-	unsigned short		bi_vcnt;	/* how many bio_vec's */
-	unsigned short		bi_idx;		/* current index into bvl_vec */
-
-	/* Number of segments in this BIO after
-	 * physical address coalescing is performed.
-	 */
-	unsigned int		bi_phys_segments;
-
-	unsigned int		bi_size;	/* residual I/O count */
-
-	/*
-	 * To keep track of the max segment size, we account for the
-	 * sizes of the first and last mergeable segments in this bio.
-	 */
-	unsigned int		bi_seg_front_size;
-	unsigned int		bi_seg_back_size;
-
-	unsigned int		bi_max_vecs;	/* max bvl_vecs we can hold */
-
-	unsigned int		bi_comp_cpu;	/* completion CPU */
-
-	atomic_t		bi_cnt;		/* pin count */
-
-	struct bio_vec		*bi_io_vec;	/* the actual vec list */
-
-	bio_end_io_t		*bi_end_io;
-
-	void			*bi_private;
-#if defined(CONFIG_BLK_DEV_INTEGRITY)
-	struct bio_integrity_payload *bi_integrity;  /* data integrity */
-#endif
-
-	bio_destructor_t	*bi_destructor;	/* destructor */
-
-	/*
-	 * We can inline a number of vecs at the end of the bio, to avoid
-	 * double allocations for a small number of bio_vecs. This member
-	 * MUST obviously be kept at the very end of the bio.
-	 */
-	struct bio_vec		bi_inline_vecs[0];
-};
-
-/*
- * bio flags
- */
-#define BIO_UPTODATE	0	/* ok after I/O completion */
-#define BIO_RW_BLOCK	1	/* RW_AHEAD set, and read/write would block */
-#define BIO_EOF		2	/* out-out-bounds error */
-#define BIO_SEG_VALID	3	/* bi_phys_segments valid */
-#define BIO_CLONED	4	/* doesn't own data */
-#define BIO_BOUNCED	5	/* bio is a bounce bio */
-#define BIO_USER_MAPPED 6	/* contains user pages */
-#define BIO_EOPNOTSUPP	7	/* not supported */
-#define BIO_CPU_AFFINE	8	/* complete bio on same CPU as submitted */
-#define BIO_NULL_MAPPED 9	/* contains invalid user pages */
-#define BIO_FS_INTEGRITY 10	/* fs owns integrity data, not block layer */
-#define BIO_QUIET	11	/* Make BIO Quiet */
-#define bio_flagged(bio, flag)	((bio)->bi_flags & (1 << (flag)))
-
-/*
- * top 4 bits of bio flags indicate the pool this bio came from
- */
-#define BIO_POOL_BITS		(4)
-#define BIO_POOL_NONE		((1UL << BIO_POOL_BITS) - 1)
-#define BIO_POOL_OFFSET		(BITS_PER_LONG - BIO_POOL_BITS)
-#define BIO_POOL_MASK		(1UL << BIO_POOL_OFFSET)
-#define BIO_POOL_IDX(bio)	((bio)->bi_flags >> BIO_POOL_OFFSET)	
-
-/*
- * Request flags.  For use in the cmd_flags field of struct request, and in
- * bi_rw of struct bio.  Note that some flags are only valid in either one.
- */
-enum rq_flag_bits {
-	/* common flags */
-	__REQ_WRITE,		/* not set, read. set, write */
-	__REQ_FAILFAST_DEV,	/* no driver retries of device errors */
-	__REQ_FAILFAST_TRANSPORT, /* no driver retries of transport errors */
-	__REQ_FAILFAST_DRIVER,	/* no driver retries of driver errors */
-
-	__REQ_HARDBARRIER,	/* may not be passed by drive either */
-	__REQ_SYNC,		/* request is sync (sync write or read) */
-	__REQ_META,		/* metadata io request */
-	__REQ_DISCARD,		/* request to discard sectors */
-	__REQ_NOIDLE,		/* don't anticipate more IO after this one */
-
-	/* bio only flags */
-	__REQ_UNPLUG,		/* unplug the immediately after submission */
-	__REQ_RAHEAD,		/* read ahead, can fail anytime */
-
-	/* request only flags */
-	__REQ_SORTED,		/* elevator knows about this request */
-	__REQ_SOFTBARRIER,	/* may not be passed by ioscheduler */
-	__REQ_FUA,		/* forced unit access */
-	__REQ_NOMERGE,		/* don't touch this for merging */
-	__REQ_STARTED,		/* drive already may have started this one */
-	__REQ_DONTPREP,		/* don't call prep for this one */
-	__REQ_QUEUED,		/* uses queueing */
-	__REQ_ELVPRIV,		/* elevator private data attached */
-	__REQ_FAILED,		/* set if the request failed */
-	__REQ_QUIET,		/* don't worry about errors */
-	__REQ_PREEMPT,		/* set for "ide_preempt" requests */
-	__REQ_ORDERED_COLOR,	/* is before or after barrier */
-	__REQ_ALLOCED,		/* request came from our alloc pool */
-	__REQ_COPY_USER,	/* contains copies of user pages */
-	__REQ_INTEGRITY,	/* integrity metadata has been remapped */
-	__REQ_FLUSH,		/* request for cache flush */
-	__REQ_IO_STAT,		/* account I/O stat */
-	__REQ_MIXED_MERGE,	/* merge of different types, fail separately */
-	__REQ_NR_BITS,		/* stops here */
-};
-
-#define REQ_WRITE		(1 << __REQ_WRITE)
-#define REQ_FAILFAST_DEV	(1 << __REQ_FAILFAST_DEV)
-#define REQ_FAILFAST_TRANSPORT	(1 << __REQ_FAILFAST_TRANSPORT)
-#define REQ_FAILFAST_DRIVER	(1 << __REQ_FAILFAST_DRIVER)
-#define REQ_HARDBARRIER		(1 << __REQ_HARDBARRIER)
-#define REQ_SYNC		(1 << __REQ_SYNC)
-#define REQ_META		(1 << __REQ_META)
-#define REQ_DISCARD		(1 << __REQ_DISCARD)
-#define REQ_NOIDLE		(1 << __REQ_NOIDLE)
-
-#define REQ_FAILFAST_MASK \
-	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
-#define REQ_COMMON_MASK \
-	(REQ_WRITE | REQ_FAILFAST_MASK | REQ_HARDBARRIER | REQ_SYNC | \
-	 REQ_META| REQ_DISCARD | REQ_NOIDLE)
-
-#define REQ_UNPLUG		(1 << __REQ_UNPLUG)
-#define REQ_RAHEAD		(1 << __REQ_RAHEAD)
-
-#define REQ_SORTED		(1 << __REQ_SORTED)
-#define REQ_SOFTBARRIER		(1 << __REQ_SOFTBARRIER)
-#define REQ_FUA			(1 << __REQ_FUA)
-#define REQ_NOMERGE		(1 << __REQ_NOMERGE)
-#define REQ_STARTED		(1 << __REQ_STARTED)
-#define REQ_DONTPREP		(1 << __REQ_DONTPREP)
-#define REQ_QUEUED		(1 << __REQ_QUEUED)
-#define REQ_ELVPRIV		(1 << __REQ_ELVPRIV)
-#define REQ_FAILED		(1 << __REQ_FAILED)
-#define REQ_QUIET		(1 << __REQ_QUIET)
-#define REQ_PREEMPT		(1 << __REQ_PREEMPT)
-#define REQ_ORDERED_COLOR	(1 << __REQ_ORDERED_COLOR)
-#define REQ_ALLOCED		(1 << __REQ_ALLOCED)
-#define REQ_COPY_USER		(1 << __REQ_COPY_USER)
-#define REQ_INTEGRITY		(1 << __REQ_INTEGRITY)
-#define REQ_FLUSH		(1 << __REQ_FLUSH)
-#define REQ_IO_STAT		(1 << __REQ_IO_STAT)
-#define REQ_MIXED_MERGE		(1 << __REQ_MIXED_MERGE)
-
-/*
  * upper 16 bits of bi_rw define the io priority of this bio
  */
 #define BIO_PRIO_SHIFT	(8 * sizeof(unsigned long) - IOPRIO_BITS)
Index: work/include/linux/fs.h
===================================================================
--- work.orig/include/linux/fs.h
+++ work/include/linux/fs.h
@@ -8,6 +8,7 @@

 #include <linux/limits.h>
 #include <linux/ioctl.h>
+#include <linux/blk_types.h>

 /*
  * It's silly to have NR_OPEN bigger than NR_FILE, but you can change
@@ -117,7 +118,7 @@ struct inodes_stat_t {
  *			immediately wait on this read without caring about
  *			unplugging.
  * READA		Used for read-ahead operations. Lower priority, and the
- *			 block layer could (in theory) choose to ignore this
+ *			block layer could (in theory) choose to ignore this
  *			request if it runs into resource problems.
  * WRITE		A normal async write. Device will be plugged.
  * SWRITE		Like WRITE, but a special case for ll_rw_block() that
@@ -144,13 +145,13 @@ struct inodes_stat_t {
  *			of this IO.
  *
  */
-#define RW_MASK			1
-#define RWA_MASK		16
+#define RW_MASK			REQ_WRITE
+#define RWA_MASK		REQ_RAHEAD

 #define READ			0
-#define WRITE			1
-#define READA			16 /* readahead - don't block if no resources */
-#define SWRITE			17 /* for ll_rw_block(), wait for buffer lock */
+#define WRITE			RW_MASK
+#define READA			RWA_MASK
+#define SWRITE			(WRITE | READA)

 #define READ_SYNC		(READ | REQ_SYNC | REQ_UNPLUG)
 #define READ_META		(READ | REQ_META)
@@ -2200,7 +2201,6 @@ static inline void insert_inode_hash(str
 extern void file_move(struct file *f, struct list_head *list);
 extern void file_kill(struct file *f);
 #ifdef CONFIG_BLOCK
-struct bio;
 extern void submit_bio(int, struct bio *);
 extern int bdev_read_only(struct block_device *);
 #endif
@@ -2267,7 +2267,6 @@ static inline int xip_truncate_page(stru
 #endif

 #ifdef CONFIG_BLOCK
-struct bio;
 typedef void (dio_submit_t)(int rw, struct bio *bio, struct inode *inode,
 			    loff_t file_offset);
 void dio_end_io(struct bio *bio, int error);
Index: work/include/linux/blk_types.h
===================================================================
--- /dev/null
+++ work/include/linux/blk_types.h
@@ -0,0 +1,193 @@
+/*
+ * Block data types and constants.  Directly include this file only to
+ * break include dependency loop.
+ */
+#ifndef __LINUX_BLK_TYPES_H
+#define __LINUX_BLK_TYPES_H
+
+#ifdef CONFIG_BLOCK
+
+#include <linux/types.h>
+
+struct bio_set;
+struct bio;
+struct bio_integrity_payload;
+struct page;
+struct block_device;
+typedef void (bio_end_io_t) (struct bio *, int);
+typedef void (bio_destructor_t) (struct bio *);
+
+/*
+ * was unsigned short, but we might as well be ready for > 64kB I/O pages
+ */
+struct bio_vec {
+	struct page	*bv_page;
+	unsigned int	bv_len;
+	unsigned int	bv_offset;
+};
+
+/*
+ * main unit of I/O for the block layer and lower layers (ie drivers and
+ * stacking drivers)
+ */
+struct bio {
+	sector_t		bi_sector;	/* device address in 512 byte
+						   sectors */
+	struct bio		*bi_next;	/* request queue link */
+	struct block_device	*bi_bdev;
+	unsigned long		bi_flags;	/* status, command, etc */
+	unsigned long		bi_rw;		/* bottom bits READ/WRITE,
+						 * top bits priority
+						 */
+
+	unsigned short		bi_vcnt;	/* how many bio_vec's */
+	unsigned short		bi_idx;		/* current index into bvl_vec */
+
+	/* Number of segments in this BIO after
+	 * physical address coalescing is performed.
+	 */
+	unsigned int		bi_phys_segments;
+
+	unsigned int		bi_size;	/* residual I/O count */
+
+	/*
+	 * To keep track of the max segment size, we account for the
+	 * sizes of the first and last mergeable segments in this bio.
+	 */
+	unsigned int		bi_seg_front_size;
+	unsigned int		bi_seg_back_size;
+
+	unsigned int		bi_max_vecs;	/* max bvl_vecs we can hold */
+
+	unsigned int		bi_comp_cpu;	/* completion CPU */
+
+	atomic_t		bi_cnt;		/* pin count */
+
+	struct bio_vec		*bi_io_vec;	/* the actual vec list */
+
+	bio_end_io_t		*bi_end_io;
+
+	void			*bi_private;
+#if defined(CONFIG_BLK_DEV_INTEGRITY)
+	struct bio_integrity_payload *bi_integrity;  /* data integrity */
+#endif
+
+	bio_destructor_t	*bi_destructor;	/* destructor */
+
+	/*
+	 * We can inline a number of vecs at the end of the bio, to avoid
+	 * double allocations for a small number of bio_vecs. This member
+	 * MUST obviously be kept at the very end of the bio.
+	 */
+	struct bio_vec		bi_inline_vecs[0];
+};
+
+/*
+ * bio flags
+ */
+#define BIO_UPTODATE	0	/* ok after I/O completion */
+#define BIO_RW_BLOCK	1	/* RW_AHEAD set, and read/write would block */
+#define BIO_EOF		2	/* out-out-bounds error */
+#define BIO_SEG_VALID	3	/* bi_phys_segments valid */
+#define BIO_CLONED	4	/* doesn't own data */
+#define BIO_BOUNCED	5	/* bio is a bounce bio */
+#define BIO_USER_MAPPED 6	/* contains user pages */
+#define BIO_EOPNOTSUPP	7	/* not supported */
+#define BIO_CPU_AFFINE	8	/* complete bio on same CPU as submitted */
+#define BIO_NULL_MAPPED 9	/* contains invalid user pages */
+#define BIO_FS_INTEGRITY 10	/* fs owns integrity data, not block layer */
+#define BIO_QUIET	11	/* Make BIO Quiet */
+#define bio_flagged(bio, flag)	((bio)->bi_flags & (1 << (flag)))
+
+/*
+ * top 4 bits of bio flags indicate the pool this bio came from
+ */
+#define BIO_POOL_BITS		(4)
+#define BIO_POOL_NONE		((1UL << BIO_POOL_BITS) - 1)
+#define BIO_POOL_OFFSET		(BITS_PER_LONG - BIO_POOL_BITS)
+#define BIO_POOL_MASK		(1UL << BIO_POOL_OFFSET)
+#define BIO_POOL_IDX(bio)	((bio)->bi_flags >> BIO_POOL_OFFSET)
+
+/*
+ * Request flags.  For use in the cmd_flags field of struct request, and in
+ * bi_rw of struct bio.  Note that some flags are only valid in either one.
+ */
+enum rq_flag_bits {
+	/* common flags */
+	__REQ_WRITE,		/* not set, read. set, write */
+	__REQ_FAILFAST_DEV,	/* no driver retries of device errors */
+	__REQ_FAILFAST_TRANSPORT, /* no driver retries of transport errors */
+	__REQ_FAILFAST_DRIVER,	/* no driver retries of driver errors */
+
+	__REQ_HARDBARRIER,	/* may not be passed by drive either */
+	__REQ_SYNC,		/* request is sync (sync write or read) */
+	__REQ_META,		/* metadata io request */
+	__REQ_DISCARD,		/* request to discard sectors */
+	__REQ_NOIDLE,		/* don't anticipate more IO after this one */
+
+	/* bio only flags */
+	__REQ_UNPLUG,		/* unplug the immediately after submission */
+	__REQ_RAHEAD,		/* read ahead, can fail anytime */
+
+	/* request only flags */
+	__REQ_SORTED,		/* elevator knows about this request */
+	__REQ_SOFTBARRIER,	/* may not be passed by ioscheduler */
+	__REQ_FUA,		/* forced unit access */
+	__REQ_NOMERGE,		/* don't touch this for merging */
+	__REQ_STARTED,		/* drive already may have started this one */
+	__REQ_DONTPREP,		/* don't call prep for this one */
+	__REQ_QUEUED,		/* uses queueing */
+	__REQ_ELVPRIV,		/* elevator private data attached */
+	__REQ_FAILED,		/* set if the request failed */
+	__REQ_QUIET,		/* don't worry about errors */
+	__REQ_PREEMPT,		/* set for "ide_preempt" requests */
+	__REQ_ORDERED_COLOR,	/* is before or after barrier */
+	__REQ_ALLOCED,		/* request came from our alloc pool */
+	__REQ_COPY_USER,	/* contains copies of user pages */
+	__REQ_INTEGRITY,	/* integrity metadata has been remapped */
+	__REQ_FLUSH,		/* request for cache flush */
+	__REQ_IO_STAT,		/* account I/O stat */
+	__REQ_MIXED_MERGE,	/* merge of different types, fail separately */
+	__REQ_NR_BITS,		/* stops here */
+};
+
+#define REQ_WRITE		(1 << __REQ_WRITE)
+#define REQ_FAILFAST_DEV	(1 << __REQ_FAILFAST_DEV)
+#define REQ_FAILFAST_TRANSPORT	(1 << __REQ_FAILFAST_TRANSPORT)
+#define REQ_FAILFAST_DRIVER	(1 << __REQ_FAILFAST_DRIVER)
+#define REQ_HARDBARRIER		(1 << __REQ_HARDBARRIER)
+#define REQ_SYNC		(1 << __REQ_SYNC)
+#define REQ_META		(1 << __REQ_META)
+#define REQ_DISCARD		(1 << __REQ_DISCARD)
+#define REQ_NOIDLE		(1 << __REQ_NOIDLE)
+
+#define REQ_FAILFAST_MASK \
+	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
+#define REQ_COMMON_MASK \
+	(REQ_WRITE | REQ_FAILFAST_MASK | REQ_HARDBARRIER | REQ_SYNC | \
+	 REQ_META| REQ_DISCARD | REQ_NOIDLE)
+
+#define REQ_UNPLUG		(1 << __REQ_UNPLUG)
+#define REQ_RAHEAD		(1 << __REQ_RAHEAD)
+
+#define REQ_SORTED		(1 << __REQ_SORTED)
+#define REQ_SOFTBARRIER		(1 << __REQ_SOFTBARRIER)
+#define REQ_FUA			(1 << __REQ_FUA)
+#define REQ_NOMERGE		(1 << __REQ_NOMERGE)
+#define REQ_STARTED		(1 << __REQ_STARTED)
+#define REQ_DONTPREP		(1 << __REQ_DONTPREP)
+#define REQ_QUEUED		(1 << __REQ_QUEUED)
+#define REQ_ELVPRIV		(1 << __REQ_ELVPRIV)
+#define REQ_FAILED		(1 << __REQ_FAILED)
+#define REQ_QUIET		(1 << __REQ_QUIET)
+#define REQ_PREEMPT		(1 << __REQ_PREEMPT)
+#define REQ_ORDERED_COLOR	(1 << __REQ_ORDERED_COLOR)
+#define REQ_ALLOCED		(1 << __REQ_ALLOCED)
+#define REQ_COPY_USER		(1 << __REQ_COPY_USER)
+#define REQ_INTEGRITY		(1 << __REQ_INTEGRITY)
+#define REQ_FLUSH		(1 << __REQ_FLUSH)
+#define REQ_IO_STAT		(1 << __REQ_IO_STAT)
+#define REQ_MIXED_MERGE		(1 << __REQ_MIXED_MERGE)
+
+#endif /* CONFIG_BLOCK */
+#endif /* __LINUX_BLK_TYPES_H */
