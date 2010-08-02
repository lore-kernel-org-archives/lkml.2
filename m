Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab0HBOST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 10:18:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:44730 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537Ab0HBOSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 10:18:16 -0400
Message-ID: <4C56D3A1.1070102@kernel.org>
Date: Mon, 02 Aug 2010 16:18:09 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, stable@kernel.org
CC: Vladislav Bolkhovitin <vst@vlnb.net>, Bryan Mesich <bryan.mesich@ndsu.edu>,
        scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, dm-devel@redhat.com,
        Neil Brown <neilb@suse.de>
Subject: [PATCH RESEND 2/2 block#for-linus] bio, fs: separate out bio_types.h
 and define READ/WRITE constants in terms of BIO_RW_* flags
References: <20100628010346.GA2376@atlantis.cc.ndsu.nodak.edu>	<4C28EFD6.2070203@vlnb.net>	<20100714190325.GA25148@atlantis.cc.ndsu.nodak.edu>	<4C3EF3AD.5070509@vlnb.net>	<20100723191844.GB31152@atlantis.cc.ndsu.nodak.edu>	<4C4D7DF5.9060909@vlnb.net>	<20100727220110.GF31152@atlantis.cc.ndsu.nodak.edu>	<4C5073F3.1060406@vlnb.net>	<4C52A98A.7060507@kernel.org> <20100802104227.79340b49@notabene> <4C56D259.8000504@kernel.org>
In-Reply-To: <4C56D259.8000504@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 02 Aug 2010 14:17:52 +0000 (UTC)
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
 include/linux/bio.h       |  153 +-----------------------------------------
 include/linux/bio_types.h |  164 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h        |   17 ++--
 3 files changed, 176 insertions(+), 158 deletions(-)

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

+/* struct bio, bio_vec and BIO_* flags are defined in bio_types.h */
+#include <linux/bio_types.h>
+
 #define BIO_DEBUG

 #ifdef BIO_DEBUG
@@ -41,154 +44,6 @@
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
- * bio bi_rw flags
- *
- * bit 0 -- data direction
- *	If not set, bio is a read from device. If set, it's a write to device.
- * bit 1 -- fail fast device errors
- * bit 2 -- fail fast transport errors
- * bit 3 -- fail fast driver errors
- * bit 4 -- rw-ahead when set
- * bit 5 -- barrier
- *	Insert a serialization point in the IO queue, forcing previously
- *	submitted IO to be completed before this one is issued.
- * bit 6 -- synchronous I/O hint.
- * bit 7 -- Unplug the device immediately after submitting this bio.
- * bit 8 -- metadata request
- *	Used for tracing to differentiate metadata and data IO. May also
- *	get some preferential treatment in the IO scheduler
- * bit 9 -- discard sectors
- *	Informs the lower level device that this range of sectors is no longer
- *	used by the file system and may thus be freed by the device. Used
- *	for flash based storage.
- *	Don't want driver retries for any fast fail whatever the reason.
- * bit 10 -- Tell the IO scheduler not to wait for more requests after this
-	one has been submitted, even if it is a SYNC request.
- */
-enum bio_rw_flags {
-	BIO_RW,
-	BIO_RW_FAILFAST_DEV,
-	BIO_RW_FAILFAST_TRANSPORT,
-	BIO_RW_FAILFAST_DRIVER,
-	/* above flags must match REQ_* */
-	BIO_RW_AHEAD,
-	BIO_RW_BARRIER,
-	BIO_RW_SYNCIO,
-	BIO_RW_UNPLUG,
-	BIO_RW_META,
-	BIO_RW_DISCARD,
-	BIO_RW_NOIDLE,
-};
-
-/*
- * First four bits must match between bio->bi_rw and rq->cmd_flags, make
- * that explicit here.
- */
-#define BIO_RW_RQ_MASK		0xf
-
-static inline bool bio_rw_flagged(struct bio *bio, enum bio_rw_flags flag)
-{
-	return (bio->bi_rw & (1 << flag)) != 0;
-}
-
-/*
  * upper 16 bits of bi_rw define the io priority of this bio
  */
 #define BIO_PRIO_SHIFT	(8 * sizeof(unsigned long) - IOPRIO_BITS)
Index: work/include/linux/bio_types.h
===================================================================
--- /dev/null
+++ work/include/linux/bio_types.h
@@ -0,0 +1,164 @@
+/*
+ * BIO data types and constants.  Include linux/bio.h for usual cases.
+ * Directly include this file only to break include dependency loop.
+ */
+#ifndef __LINUX_BIO_TYPES_H
+#define __LINUX_BIO_TYPES_H
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
+typedef void (bio_end_io_t) (struct bio *, int);
+typedef void (bio_destructor_t) (struct bio *);
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
+ * bio bi_rw flags
+ *
+ * bit 0 -- data direction
+ *	If not set, bio is a read from device. If set, it's a write to device.
+ * bit 1 -- fail fast device errors
+ * bit 2 -- fail fast transport errors
+ * bit 3 -- fail fast driver errors
+ * bit 4 -- rw-ahead when set
+ * bit 5 -- barrier
+ *	Insert a serialization point in the IO queue, forcing previously
+ *	submitted IO to be completed before this one is issued.
+ * bit 6 -- synchronous I/O hint.
+ * bit 7 -- Unplug the device immediately after submitting this bio.
+ * bit 8 -- metadata request
+ *	Used for tracing to differentiate metadata and data IO. May also
+ *	get some preferential treatment in the IO scheduler
+ * bit 9 -- discard sectors
+ *	Informs the lower level device that this range of sectors is no longer
+ *	used by the file system and may thus be freed by the device. Used
+ *	for flash based storage.
+ *	Don't want driver retries for any fast fail whatever the reason.
+ * bit 10 -- Tell the IO scheduler not to wait for more requests after this
+	one has been submitted, even if it is a SYNC request.
+ */
+enum bio_rw_flags {
+	BIO_RW,
+	BIO_RW_FAILFAST_DEV,
+	BIO_RW_FAILFAST_TRANSPORT,
+	BIO_RW_FAILFAST_DRIVER,
+	/* above flags must match REQ_* */
+	BIO_RW_AHEAD,
+	BIO_RW_BARRIER,
+	BIO_RW_SYNCIO,
+	BIO_RW_UNPLUG,
+	BIO_RW_META,
+	BIO_RW_DISCARD,
+	BIO_RW_NOIDLE,
+};
+
+/*
+ * First four bits must match between bio->bi_rw and rq->cmd_flags, make
+ * that explicit here.
+ */
+#define BIO_RW_RQ_MASK		0xf
+
+static inline bool bio_rw_flagged(struct bio *bio, enum bio_rw_flags flag)
+{
+	return (bio->bi_rw & (1 << flag)) != 0;
+}
+
+#endif /* CONFIG_BLOCK */
+#endif /* __LINUX_BIO_TYPES_H */
Index: work/include/linux/fs.h
===================================================================
--- work.orig/include/linux/fs.h
+++ work/include/linux/fs.h
@@ -8,6 +8,7 @@

 #include <linux/limits.h>
 #include <linux/ioctl.h>
+#include <linux/bio_types.h>

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
@@ -144,12 +145,12 @@ struct inodes_stat_t {
  *			of this IO.
  *
  */
-#define RW_MASK		1
-#define RWA_MASK	2
-#define READ 0
-#define WRITE 1
-#define READA 16	/* read-ahead  - don't block if no resources */
-#define SWRITE 17	/* for ll_rw_block() - wait for buffer lock */
+#define RW_MASK		(1 << BIO_RW)
+#define RWA_MASK	(1 << BIO_RW_AHEAD)
+#define READ		0
+#define WRITE		RW_MASK
+#define READA		RWA_MASK
+#define SWRITE		(WRITE | READA)
 #define READ_SYNC	(READ | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG))
 #define READ_META	(READ | (1 << BIO_RW_META))
 #define WRITE_SYNC_PLUG	(WRITE | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_NOIDLE))
@@ -2198,7 +2199,6 @@ static inline void insert_inode_hash(str
 extern void file_move(struct file *f, struct list_head *list);
 extern void file_kill(struct file *f);
 #ifdef CONFIG_BLOCK
-struct bio;
 extern void submit_bio(int, struct bio *);
 extern int bdev_read_only(struct block_device *);
 #endif
@@ -2265,7 +2265,6 @@ static inline int xip_truncate_page(stru
 #endif

 #ifdef CONFIG_BLOCK
-struct bio;
 typedef void (dio_submit_t)(int rw, struct bio *bio, struct inode *inode,
 			    loff_t file_offset);
 void dio_end_io(struct bio *bio, int error);
