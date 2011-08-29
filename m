Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab1H2XXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 19:23:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:24129 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755419Ab1H2XX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 19:23:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="43424139"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 06/11] DIO: Inline the complete submission path v2
Date: Mon, 29 Aug 2011 16:23:17 -0700
Message-Id: <1314660202-661-7-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1314660202-661-1-git-send-email-andi@firstfloor.org>
References: <1314660202-661-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add inlines to all the submission path functions. While this increases
code size it also gives gcc a lot of optimization opportunities
in this critical hotpath.

In particular -- together with some other changes -- this
allows gcc to get rid of the unnecessary clearing of
sdio at the beginning and optimize the messy parameter passing.
Any non inlining of a function which takes a sdio parameter
would break this optimization because they cannot be done if the
address of a structure is taken.

Note that benefits are only seen with CONFIG_OPTIMIZE_INLINING
and CONFIG_CC_OPTIMIZE_FOR_SIZE both set to off.

This gives about 2.2% improvement on a large database benchmark
with a high IOPS rate.

v2: Add a comment
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/direct-io.c |   31 ++++++++++++++++++-------------
 1 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 172ec77..103a6fc 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -199,7 +199,7 @@ static inline unsigned dio_pages_present(struct dio *dio, struct dio_submit *sdi
 /*
  * Go grab and pin some userspace pages.   Typically we'll get 64 at a time.
  */
-static int dio_refill_pages(struct dio *dio, struct dio_submit *sdio)
+static inline int dio_refill_pages(struct dio *dio, struct dio_submit *sdio)
 {
 	int ret;
 	int nr_pages;
@@ -245,7 +245,7 @@ out:
  * decent number of pages, less frequently.  To provide nicer use of the
  * L1 cache.
  */
-static struct page *dio_get_page(struct dio *dio, struct dio_submit *sdio)
+static inline struct page *dio_get_page(struct dio *dio, struct dio_submit *sdio)
 {
 	if (dio_pages_present(dio, sdio) == 0) {
 		int ret;
@@ -376,7 +376,7 @@ void dio_end_io(struct bio *bio, int error)
 }
 EXPORT_SYMBOL_GPL(dio_end_io);
 
-static void
+static void inline
 dio_bio_alloc(struct dio *dio, struct dio_submit *sdio,
 	      struct block_device *bdev,
 	      sector_t first_sector, int nr_vecs)
@@ -407,7 +407,7 @@ dio_bio_alloc(struct dio *dio, struct dio_submit *sdio,
  *
  * bios hold a dio reference between submit_bio and ->end_io.
  */
-static void dio_bio_submit(struct dio *dio, struct dio_submit *sdio)
+static inline void dio_bio_submit(struct dio *dio, struct dio_submit *sdio)
 {
 	struct bio *bio = sdio->bio;
 	unsigned long flags;
@@ -435,7 +435,7 @@ static void dio_bio_submit(struct dio *dio, struct dio_submit *sdio)
 /*
  * Release any resources in case of a failure
  */
-static void dio_cleanup(struct dio *dio, struct dio_submit *sdio)
+static inline void dio_cleanup(struct dio *dio, struct dio_submit *sdio)
 {
 	while (dio_pages_present(dio, sdio))
 		page_cache_release(dio_get_page(dio, sdio));
@@ -528,7 +528,7 @@ static void dio_await_completion(struct dio *dio)
  *
  * This also helps to limit the peak amount of pinned userspace memory.
  */
-static int dio_bio_reap(struct dio *dio, struct dio_submit *sdio)
+static inline int dio_bio_reap(struct dio *dio, struct dio_submit *sdio)
 {
 	int ret = 0;
 
@@ -631,7 +631,7 @@ static int get_more_blocks(struct dio *dio, struct dio_submit *sdio,
 /*
  * There is no bio.  Make one now.
  */
-static int dio_new_bio(struct dio *dio, struct dio_submit *sdio, 
+static inline int dio_new_bio(struct dio *dio, struct dio_submit *sdio, 
 		       sector_t start_sector, struct buffer_head *map_bh)
 {
 	sector_t sector;
@@ -657,7 +657,7 @@ out:
  *
  * Return zero on success.  Non-zero means the caller needs to start a new BIO.
  */
-static int dio_bio_add_page(struct dio *dio, struct dio_submit *sdio)
+static inline int dio_bio_add_page(struct dio *dio, struct dio_submit *sdio)
 {
 	int ret;
 
@@ -689,8 +689,8 @@ static int dio_bio_add_page(struct dio *dio, struct dio_submit *sdio)
  * The caller of this function is responsible for removing cur_page from the
  * dio, and for dropping the refcount which came from that presence.
  */
-static int dio_send_cur_page(struct dio *dio, struct dio_submit *sdio,
-			     struct buffer_head *map_bh)
+static inline int dio_send_cur_page(struct dio *dio, struct dio_submit *sdio,
+	  		    	    struct buffer_head *map_bh)
 {
 	int ret = 0;
 
@@ -759,7 +759,7 @@ out:
  * If that doesn't work out then we put the old page into the bio and add this
  * page to the dio instead.
  */
-static int
+static inline int
 submit_page_section(struct dio *dio, struct dio_submit *sdio, struct page *page,
 		    unsigned offset, unsigned len, sector_t blocknr,
 		    struct buffer_head *map_bh)
@@ -842,7 +842,7 @@ static void clean_blockdev_aliases(struct dio *dio, struct buffer_head *map_bh)
  * `end' is zero if we're doing the start of the IO, 1 at the end of the
  * IO.
  */
-static void dio_zero_block(struct dio *dio, struct dio_submit *sdio, int end,
+static inline void dio_zero_block(struct dio *dio, struct dio_submit *sdio, int end,
 			   struct buffer_head *map_bh)
 {
 	unsigned dio_blocks_per_fs_block;
@@ -1039,7 +1039,7 @@ out:
 	return ret;
 }
 
-static ssize_t
+static inline ssize_t
 direct_io_worker(int rw, struct kiocb *iocb, struct inode *inode, 
 	const struct iovec *iov, loff_t offset, unsigned long nr_segs, 
 	unsigned blkbits, get_block_t get_block, dio_iodone_t end_io,
@@ -1213,6 +1213,11 @@ direct_io_worker(int rw, struct kiocb *iocb, struct inode *inode,
  * expected that filesystem provide exclusion between new direct I/O
  * and truncates.  For DIO_LOCKING filesystems this is done by i_mutex,
  * but other filesystems need to take care of this on their own.
+ * 
+ * NOTE: if you pass "sdio" to anything by pointer make sure that function
+ * is always inlined. Otherwise gcc is unable to split the structure into
+ * individual fields and will generate much worse code. 
+ * This is important for the whole file.
  */
 ssize_t
 __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
-- 
1.7.4.4

