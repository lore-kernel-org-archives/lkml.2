Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932557Ab1FVTVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 15:21:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:38457 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932512Ab1FVTUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 15:20:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,407,1304319600"; 
   d="scan'208";a="16980952"
From: Andi Kleen <andi@firstfloor.org>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dehrenberg@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 6/6] DIO: Inline the complete submission path
Date: Wed, 22 Jun 2011 12:18:42 -0700
Message-Id: <1308770322-22565-7-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308770322-22565-1-git-send-email-andi@firstfloor.org>
References: <1308770322-22565-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add inlines to all the submission path functions. While this increases
code slightly it also gives gcc a lot of optimization opportunities
in this critical hotpath.

In particular -- together with some other changes -- this
allows gcc to get rid of the unnecessary clearing of
sdio at the beginning and optimize the messy parameter passing.

Note that benefits are only seen with CONFIG_OPTIMIZE_INLINING
and CONFIG_CC_OPTIMIZE_FOR_SIZE both set to off.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/direct-io.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index cc75445..1a2edbf 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -155,7 +155,7 @@ static inline unsigned dio_pages_present(struct dio *dio, struct dio_submit *sdi
 /*
  * Go grab and pin some userspace pages.   Typically we'll get 64 at a time.
  */
-static int dio_refill_pages(struct dio *dio, struct dio_submit *sdio)
+static inline int dio_refill_pages(struct dio *dio, struct dio_submit *sdio)
 {
 	int ret;
 	int nr_pages;
@@ -201,7 +201,7 @@ out:
  * decent number of pages, less frequently.  To provide nicer use of the
  * L1 cache.
  */
-static struct page *dio_get_page(struct dio *dio, struct dio_submit *sdio)
+static inline struct page *dio_get_page(struct dio *dio, struct dio_submit *sdio)
 {
 	if (dio_pages_present(dio, sdio) == 0) {
 		int ret;
@@ -334,7 +334,7 @@ void dio_end_io(struct bio *bio, int error)
 }
 EXPORT_SYMBOL_GPL(dio_end_io);
 
-static void
+static void inline
 dio_bio_alloc(struct dio *dio, struct dio_submit *sdio,
 	      struct block_device *bdev,
 	      sector_t first_sector, int nr_vecs)
@@ -365,7 +365,7 @@ dio_bio_alloc(struct dio *dio, struct dio_submit *sdio,
  *
  * bios hold a dio reference between submit_bio and ->end_io.
  */
-static void dio_bio_submit(struct dio *dio, struct dio_submit *sdio)
+static inline void dio_bio_submit(struct dio *dio, struct dio_submit *sdio)
 {
 	struct bio *bio = sdio->bio;
 	unsigned long flags;
@@ -393,7 +393,7 @@ static void dio_bio_submit(struct dio *dio, struct dio_submit *sdio)
 /*
  * Release any resources in case of a failure
  */
-static void dio_cleanup(struct dio *dio, struct dio_submit *sdio)
+static inline void dio_cleanup(struct dio *dio, struct dio_submit *sdio)
 {
 	while (dio_pages_present(dio, sdio))
 		page_cache_release(dio_get_page(dio, sdio));
@@ -486,7 +486,7 @@ static void dio_await_completion(struct dio *dio)
  *
  * This also helps to limit the peak amount of pinned userspace memory.
  */
-static int dio_bio_reap(struct dio *dio, struct dio_submit *sdio)
+static inline int dio_bio_reap(struct dio *dio, struct dio_submit *sdio)
 {
 	int ret = 0;
 
@@ -589,7 +589,7 @@ static int get_more_blocks(struct dio *dio, struct dio_submit *sdio,
 /*
  * There is no bio.  Make one now.
  */
-static int dio_new_bio(struct dio *dio, struct dio_submit *sdio, 
+static inline int dio_new_bio(struct dio *dio, struct dio_submit *sdio, 
 		       sector_t start_sector, struct buffer_head *map_bh)
 {
 	sector_t sector;
@@ -615,7 +615,7 @@ out:
  *
  * Return zero on success.  Non-zero means the caller needs to start a new BIO.
  */
-static int dio_bio_add_page(struct dio *dio, struct dio_submit *sdio)
+static inline int dio_bio_add_page(struct dio *dio, struct dio_submit *sdio)
 {
 	int ret;
 
@@ -647,8 +647,8 @@ static int dio_bio_add_page(struct dio *dio, struct dio_submit *sdio)
  * The caller of this function is responsible for removing cur_page from the
  * dio, and for dropping the refcount which came from that presence.
  */
-static int dio_send_cur_page(struct dio *dio, struct dio_submit *sdio,
-			     struct buffer_head *map_bh)
+static inline int dio_send_cur_page(struct dio *dio, struct dio_submit *sdio,
+	  		    	    struct buffer_head *map_bh)
 {
 	int ret = 0;
 
@@ -717,7 +717,7 @@ out:
  * If that doesn't work out then we put the old page into the bio and add this
  * page to the dio instead.
  */
-static int
+static inline int
 submit_page_section(struct dio *dio, struct dio_submit *sdio, struct page *page,
 		    unsigned offset, unsigned len, sector_t blocknr,
 		    struct buffer_head *map_bh)
@@ -800,7 +800,7 @@ static void clean_blockdev_aliases(struct dio *dio, struct buffer_head *map_bh)
  * `end' is zero if we're doing the start of the IO, 1 at the end of the
  * IO.
  */
-static void dio_zero_block(struct dio *dio, struct dio_submit *sdio, int end,
+static inline void dio_zero_block(struct dio *dio, struct dio_submit *sdio, int end,
 			   struct buffer_head *map_bh)
 {
 	unsigned dio_blocks_per_fs_block;
@@ -1000,7 +1000,7 @@ out:
 /*
  * Releases both i_mutex and i_alloc_sem
  */
-static ssize_t
+static inline ssize_t
 direct_io_worker(int rw, struct kiocb *iocb, struct inode *inode, 
 	const struct iovec *iov, loff_t offset, unsigned long nr_segs, 
 	unsigned blkbits, get_block_t get_block, dio_iodone_t end_io,
-- 
1.7.4.4

