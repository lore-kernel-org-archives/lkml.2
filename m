Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab1F3Owy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 10:52:54 -0400
Received: from mail.betterlinux.com ([199.58.199.50]:47962 "EHLO
	mail.betterlinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab1F3Ows (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 10:52:48 -0400
Date: Thu, 30 Jun 2011 16:52:29 +0200
From: Andrea Righi <andrea@betterlinux.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 8/8] blk-throttle: enable throttling of task while
 dirtying pages
Message-ID: <20110630145229.GA1655@thinkpad>
References: <1309275309-12889-1-git-send-email-vgoyal@redhat.com>
 <1309275309-12889-9-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309275309-12889-9-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 11:35:09AM -0400, Vivek Goyal wrote:
> Put the blk_throtl_dirty_pages() hook in
> balance_dirty_pages_ratelimited_nr() to enable task throttling.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  include/linux/blkdev.h |    5 +++++
>  mm/page-writeback.c    |    3 +++
>  2 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 4ce6e68..5d4a57e 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1180,12 +1180,17 @@ static inline uint64_t rq_io_start_time_ns(struct request *req)
>  extern int blk_throtl_init(struct request_queue *q);
>  extern void blk_throtl_exit(struct request_queue *q);
>  extern int blk_throtl_bio(struct request_queue *q, struct bio **bio);
> +extern void blk_throtl_dirty_pages(struct address_space *mapping,
> +				unsigned long nr_dirty);
>  #else /* CONFIG_BLK_DEV_THROTTLING */
>  static inline int blk_throtl_bio(struct request_queue *q, struct bio **bio)
>  {
>  	return 0;
>  }
>  
> +static inline void blk_throtl_dirty_pages(struct address_space *mapping,
> +				unsigned long nr_dirty) {}
> +
>  static inline int blk_throtl_init(struct request_queue *q) { return 0; }
>  static inline int blk_throtl_exit(struct request_queue *q) { return 0; }
>  #endif /* CONFIG_BLK_DEV_THROTTLING */
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 31f6988..943e551 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -629,6 +629,9 @@ void balance_dirty_pages_ratelimited_nr(struct address_space *mapping,
>  	unsigned long ratelimit;
>  	unsigned long *p;
>  
> +	/* Subject writes to IO controller throttling */
> +	blk_throtl_dirty_pages(mapping, nr_pages_dirtied);
> +

mmmh.. in this way we throttle also tasks that are re-writing dirty pages
multiple times.

>From the controller perspective what is actually generating I/O on block
devices is the generation of _new_ dirty pages. Multiple re-writes in page
cache should never be throttled IMHO.

I would re-write this patch in the following way. What do you think?

Thanks,
-Andrea

---
Subject: [PATCH 8/8] blk-throttle: enable throttling of task while dirtying pages

From: Andrea Righi <andrea@betterlinux.com>

Put the blk_throtl_dirty_pages() hook in balance_dirty_pages_ratelimited_nr()
to enable task throttling.

Moreover, modify balance_dirty_pages_ratelimited_nr() to accept the additional
parameter "redirty". This parameter can be used to notify if the pages have
been dirtied for the first time or re-dirtied.

This information can be used by the blkio.throttle controller to distinguish
between a WRITE in the page cache, that will eventually generates I/O activity
on block device by the writeback code, and a re-WRITE operation that most of
the time will not generate additional I/O activity.

This means that a task that re-writes multiple times the same blocks of a file
is affected by the blkio limitations only for the actual I/O that will be
performed to the underlying block devices during the writeback process.

Signed-off-by: Andrea Righi <andrea@betterlinux.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 include/linux/writeback.h |    8 ++++++--
 mm/filemap.c              |    4 +++-
 mm/page-writeback.c       |   11 +++++++----
 3 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 17e7ccc..82d69c9 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -129,8 +129,12 @@ unsigned long bdi_dirty_limit(struct backing_dev_info *bdi,
 			       unsigned long dirty);
 
 void page_writeback_init(void);
-void balance_dirty_pages_ratelimited_nr(struct address_space *mapping,
-					unsigned long nr_pages_dirtied);
+
+#define balance_dirty_pages_ratelimited_nr(__mapping, __nr) \
+		__balance_dirty_pages_ratelimited_nr(__mapping, __nr, false)
+void __balance_dirty_pages_ratelimited_nr(struct address_space *mapping,
+					unsigned long nr_pages_dirtied,
+					bool redirty);
 
 static inline void
 balance_dirty_pages_ratelimited(struct address_space *mapping)
diff --git a/mm/filemap.c b/mm/filemap.c
index a8251a8..ff4bdc5 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2377,6 +2377,7 @@ static ssize_t generic_perform_write(struct file *file,
 		unsigned long bytes;	/* Bytes to write to page */
 		size_t copied;		/* Bytes copied from user */
 		void *fsdata;
+		unsigned int dirty;
 
 		offset = (pos & (PAGE_CACHE_SIZE - 1));
 		bytes = min_t(unsigned long, PAGE_CACHE_SIZE - offset,
@@ -2412,6 +2413,7 @@ again:
 		pagefault_enable();
 		flush_dcache_page(page);
 
+		dirty = PageDirty(page);
 		mark_page_accessed(page);
 		status = a_ops->write_end(file, mapping, pos, bytes, copied,
 						page, fsdata);
@@ -2438,7 +2440,7 @@ again:
 		pos += copied;
 		written += copied;
 
-		balance_dirty_pages_ratelimited(mapping);
+		__balance_dirty_pages_ratelimited_nr(mapping, 1, dirty);
 
 	} while (iov_iter_count(i));
 
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 943e551..4ca505d 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -613,6 +613,7 @@ static DEFINE_PER_CPU(unsigned long, bdp_ratelimits) = 0;
  * balance_dirty_pages_ratelimited_nr - balance dirty memory state
  * @mapping: address_space which was dirtied
  * @nr_pages_dirtied: number of pages which the caller has just dirtied
+ * @redirty: false if the pages have been dirtied for the first time
  *
  * Processes which are dirtying memory should call in here once for each page
  * which was newly dirtied.  The function will periodically check the system's
@@ -623,14 +624,16 @@ static DEFINE_PER_CPU(unsigned long, bdp_ratelimits) = 0;
  * limit we decrease the ratelimiting by a lot, to prevent individual processes
  * from overshooting the limit by (ratelimit_pages) each.
  */
-void balance_dirty_pages_ratelimited_nr(struct address_space *mapping,
-					unsigned long nr_pages_dirtied)
+void __balance_dirty_pages_ratelimited_nr(struct address_space *mapping,
+					unsigned long nr_pages_dirtied,
+					bool redirty)
 {
 	unsigned long ratelimit;
 	unsigned long *p;
 
 	/* Subject writes to IO controller throttling */
-	blk_throtl_dirty_pages(mapping, nr_pages_dirtied);
+	if (!redirty)
+		blk_throtl_dirty_pages(mapping, nr_pages_dirtied);
 
 	ratelimit = ratelimit_pages;
 	if (mapping->backing_dev_info->dirty_exceeded)
@@ -652,7 +655,7 @@ void balance_dirty_pages_ratelimited_nr(struct address_space *mapping,
 	}
 	preempt_enable();
 }
-EXPORT_SYMBOL(balance_dirty_pages_ratelimited_nr);
+EXPORT_SYMBOL(__balance_dirty_pages_ratelimited_nr);
 
 void throttle_vm_writeout(gfp_t gfp_mask)
 {
