Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912Ab1BPPlG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 10:41:06 -0500
Received: from cantor.suse.de ([195.135.220.2]:35182 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094Ab1BPPlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 10:41:02 -0500
Date: Wed, 16 Feb 2011 16:40:58 +0100
From: Jan Kara <jack@suse.cz>
To: Feng Tang <feng.tang@intel.com>
Cc: Jan Kara <jack@suse.cz>, "op.q.liu@gmail.com" <op.q.liu@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Subject: Re: ext2 write performance regression from 2.6.32
Message-ID: <20110216154058.GC5592@quack.suse.cz>
References: <AANLkTinES_gU=MxbSnidorsKDsMnAwzHVx+yntOLCf=f@mail.gmail.com>
 <AANLkTikvpyTPVnP1cxC4rSLARO3thpscyhmB4=BpFW-G@mail.gmail.com>
 <20110215144641.05318556@feng-i7>
 <20110215111126.GD17313@quack.suse.cz>
 <20110216102055.48af0d85@feng-i7>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
In-Reply-To: <20110216102055.48af0d85@feng-i7>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hello,

On Wed 16-02-11 10:20:55, Feng Tang wrote:
> On Tue, 15 Feb 2011 19:11:26 +0800
> Jan Kara <jack@suse.cz> wrote:
> > On Tue 15-02-11 14:46:41, Feng Tang wrote:
> > > After some debugging, here is one possible root cause for the dd
> > > performance drop between 2.6.30 and 2.6.32 (33/34/35 as well):
> > > in .30 the dd is a pure sequential operation while in .32 it isn't,
> > > and the change is related to the introduction of per-pdi flush.
> > > 
> > > I used a laptop with SDHC controller and run a simple dd of a
> > > double RAM size _file_ to a 1G SDHC card, the drop from .32 to .30
> > > is about 30%, from roughly 10MB/s to 7MB/s
> > > 
> > > I'm not very familiar with .30/.32 code, and here is a simple
> > > analysis:
> > > 
> > > When dd to a big ext2 file, there are 2 types of metadata will be
> > > updated besides the file data:
> > > 1. The ext2 global info like group descriptors and block bitmaps,
> > > whose buffer_header will be marked dirty in ext2_new_blocks()
> > > 2. The inode of the file under written, marked dirty in
> > > ext2_write/update_inode(), which is called by write_inode() and in
> > > writeback path.
> > > 
> > > In 2.6.30, with old pdflush interface, during the dd, the writeback
> > > of the 2 types of metadata will be triggered from wb_timer_fn() and
> > > dirty_balance_pages(), but they are always delayed in
> > > pdflush_operations() as the pdflush_list is empty. So that only the
> > > file data got be written back in a very smooth sequential mode. 
> > > 
> > > In 2.6.32, the writeback is per-bdi operation, every time the bdi
> > > for the sd card is called for flush, it will check and try to write
> > > back all the dirty pages, including both the metadata and data
> > > pages, so the previously sequential sd block access is periodically
> > > chimed in by the metadata block, which cause the performance drop.
> > > And if I ugly delayed the metadata writeback, the performance will
> > > be restored same as .30.
> >   Umm, interesting. 7 vs 10 MB/s is rather big difference. For
> > non-rotating media like is your SD card, I'd expect much less impact
> > of IO randomness, especially if we write in those 4 MB chunks. But we
> > are probably hit by the erase block size being big and thus FTL has
> > to do a lot of work.
> Yes, the impact is a little big, the original report from kyle is drop
> from 18 MB/s to 3 MB/s, and even a 35% drop on SATA disk.
> 
> > 
> > What might happen is that flusher thread competes with the process
> > doing writeback from balance_dirty_pages(). There are basically two
> > dirty inodes in the bdi in your test case - the file you write and
> > the device inode. So while one task flushes the file data pages, the
> > other task has no other choice but flush the device inode. But I'd
> > expect this to happen with pdflush as well. Can you send me raw block
> > traces from both kernels so that I can have a look? Thanks.
> 
> The logs are big, so I put the log for .30 and .32 as attachments.
  Thanks for the logs. So indeed what happens is that with 2.6.32, flusher
thread competes with dd doing writeout. So one of the processes is writing
out file's data and the other gets the device inode with metadata. Thus the
result is a mix of data and metadata and unnecessarily seeky.

In 2.6.30, pdflush seemed to stay away from the bdi for most of the time
and dd did all the writeback. I'm not sure why that happened because the
code was not designed that way (and I have seen several loads where what
happened above with flusher thread happened with pdflush as well). It is
probably something specific to that kind of load and machine. Anyway, not
too important now since pdflush is dead ;).

To solve exactly this kind of problems, we decided to leave as much IO as
possible to the flusher thread (in particular avoid doing IO from
balance_dirty_pages()). I have experimental patches to do that so if you'd
be willing to try them out, you are welcome. The patches are attached.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--BXVAT5kNtrzKuDFl
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-writeback-account-per-bdi-accumulated-written-pages.patch"

>From 4e1669d84332c49e6d94f296bbd86479d5936157 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 25 Jan 2011 23:03:33 +0100
Subject: [PATCH 1/5] writeback: account per-bdi accumulated written pages

Introduce the BDI_WRITTEN counter. It will be used for waking up
waiters in balance_dirty_pages().

Peter Zijlstra <a.p.zijlstra@chello.nl>:
Move BDI_WRITTEN accounting into __bdi_writeout_inc().
This will cover and fix fuse, which only calls bdi_writeout_inc().

CC: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Hellwig <hch@infradead.org>
CC: Dave Chinner <david@fromorbit.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/backing-dev.h |    1 +
 mm/backing-dev.c            |    6 ++++--
 mm/page-writeback.c         |    1 +
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 4ce34fa..63ab4a5 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -40,6 +40,7 @@ typedef int (congested_fn)(void *, int);
 enum bdi_stat_item {
 	BDI_RECLAIMABLE,
 	BDI_WRITEBACK,
+	BDI_WRITTEN,
 	NR_BDI_STAT_ITEMS
 };
 
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 027100d..4d14072 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -92,6 +92,7 @@ static int bdi_debug_stats_show(struct seq_file *m, void *v)
 		   "BdiDirtyThresh:   %8lu kB\n"
 		   "DirtyThresh:      %8lu kB\n"
 		   "BackgroundThresh: %8lu kB\n"
+		   "BdiWritten:       %8lu kB\n"
 		   "b_dirty:          %8lu\n"
 		   "b_io:             %8lu\n"
 		   "b_more_io:        %8lu\n"
@@ -99,8 +100,9 @@ static int bdi_debug_stats_show(struct seq_file *m, void *v)
 		   "state:            %8lx\n",
 		   (unsigned long) K(bdi_stat(bdi, BDI_WRITEBACK)),
 		   (unsigned long) K(bdi_stat(bdi, BDI_RECLAIMABLE)),
-		   K(bdi_thresh), K(dirty_thresh),
-		   K(background_thresh), nr_dirty, nr_io, nr_more_io,
+		   K(bdi_thresh), K(dirty_thresh), K(background_thresh),
+		   (unsigned long) K(bdi_stat(bdi, BDI_WRITTEN)),
+		   nr_dirty, nr_io, nr_more_io,
 		   !list_empty(&bdi->bdi_list), bdi->state);
 #undef K
 
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 2cb01f6..c472c1c 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -219,6 +219,7 @@ int dirty_bytes_handler(struct ctl_table *table, int write,
  */
 static inline void __bdi_writeout_inc(struct backing_dev_info *bdi)
 {
+	__inc_bdi_stat(bdi, BDI_WRITTEN);
 	__prop_inc_percpu_max(&vm_completions, &bdi->completions,
 			      bdi->max_prop_frac);
 }
-- 
1.7.1


--BXVAT5kNtrzKuDFl
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0002-mm-Properly-reflect-task-dirty-limits-in-dirty_excee.patch"

>From 6cc831cf8cdb5e43218e8a87244f6d27e315fe53 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Fri, 28 Jan 2011 17:42:55 +0100
Subject: [PATCH 2/5] mm: Properly reflect task dirty limits in dirty_exceeded logic

We set bdi->dirty_exceeded (and thus ratelimiting code starts to
call balance_dirty_pages() every 8 pages) when a per-bdi limit is
exceeded or global limit is exceeded. But per-bdi limit also depends
on the task. Thus different tasks reach the limit on that bdi at
different levels of dirty pages. The result is that with current code
bdi->dirty_exceeded ping-ponged between 1 and 0 depending on which task
just got into balance_dirty_pages().

We fix the issue by clearing bdi->dirty_exceeded only when per-bdi amount
of dirty pages drops below the threshold (7/8 * bdi_dirty_limit) where task
limits already do not have any influence.

CC: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Hellwig <hch@infradead.org>
CC: Dave Chinner <david@fromorbit.com>
CC: Wu Fengguang <fengguang.wu@intel.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/page-writeback.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index c472c1c..f388f70 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -275,12 +275,13 @@ static inline void task_dirties_fraction(struct task_struct *tsk,
  * effectively curb the growth of dirty pages. Light dirtiers with high enough
  * dirty threshold may never get throttled.
  */
+#define TASK_LIMIT_FRACTION 8
 static unsigned long task_dirty_limit(struct task_struct *tsk,
 				       unsigned long bdi_dirty)
 {
 	long numerator, denominator;
 	unsigned long dirty = bdi_dirty;
-	u64 inv = dirty >> 3;
+	u64 inv = dirty / TASK_LIMIT_FRACTION;
 
 	task_dirties_fraction(tsk, &numerator, &denominator);
 	inv *= numerator;
@@ -291,6 +292,12 @@ static unsigned long task_dirty_limit(struct task_struct *tsk,
 	return max(dirty, bdi_dirty/2);
 }
 
+/* Minimum limit for any task */
+static unsigned long task_min_dirty_limit(unsigned long bdi_dirty)
+{
+	return bdi_dirty - bdi_dirty / TASK_LIMIT_FRACTION;
+}
+
 /*
  *
  */
@@ -484,9 +491,11 @@ static void balance_dirty_pages(struct address_space *mapping,
 	unsigned long background_thresh;
 	unsigned long dirty_thresh;
 	unsigned long bdi_thresh;
+	unsigned long min_bdi_thresh = ULONG_MAX;
 	unsigned long pages_written = 0;
 	unsigned long pause = 1;
 	bool dirty_exceeded = false;
+	bool min_dirty_exceeded = false;
 	struct backing_dev_info *bdi = mapping->backing_dev_info;
 
 	for (;;) {
@@ -513,6 +522,7 @@ static void balance_dirty_pages(struct address_space *mapping,
 			break;
 
 		bdi_thresh = bdi_dirty_limit(bdi, dirty_thresh);
+		min_bdi_thresh = task_min_dirty_limit(bdi_thresh);
 		bdi_thresh = task_dirty_limit(current, bdi_thresh);
 
 		/*
@@ -542,6 +552,9 @@ static void balance_dirty_pages(struct address_space *mapping,
 		dirty_exceeded =
 			(bdi_nr_reclaimable + bdi_nr_writeback > bdi_thresh)
 			|| (nr_reclaimable + nr_writeback > dirty_thresh);
+		min_dirty_exceeded =
+			(bdi_nr_reclaimable + bdi_nr_writeback > min_bdi_thresh)
+			|| (nr_reclaimable + nr_writeback > dirty_thresh);
 
 		if (!dirty_exceeded)
 			break;
@@ -579,7 +592,8 @@ static void balance_dirty_pages(struct address_space *mapping,
 			pause = HZ / 10;
 	}
 
-	if (!dirty_exceeded && bdi->dirty_exceeded)
+	/* Clear dirty_exceeded flag only when no task can exceed the limit */
+	if (!min_dirty_exceeded && bdi->dirty_exceeded)
 		bdi->dirty_exceeded = 0;
 
 	if (writeback_in_progress(bdi))
-- 
1.7.1


--BXVAT5kNtrzKuDFl
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0003-mm-Implement-IO-less-balance_dirty_pages.patch"

>From c9341803e17802ac52231b5a6441b7f808085522 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 26 Jan 2011 15:39:21 +0100
Subject: [PATCH 3/5] mm: Implement IO-less balance_dirty_pages()

This patch changes balance_dirty_pages() throttling so that the function does
not submit writes on its own but rather waits for flusher thread to do enough
writes. This has an advantage that we have a single source of IO allowing for
better writeback locality. Also we do not have to reenter filesystems from a
non-trivial context.

The waiting is implemented as follows: Whenever we decide to throttle a task in
balance_dirty_pages(), task adds itself to a list of tasks that are throttled
against that bdi and goes to sleep waiting to receive specified amount of page
IO completions. Once in a while (currently HZ/10, later the interval should be
autotuned based on observed IO completion rate), accumulated page IO
completions are distributed equally among waiting tasks.

This waiting scheme has been chosen so that waiting time in
balance_dirty_pages() is proportional to
  number_waited_pages * number_of_waiters.
In particular it does not depend on the total number of pages being waited for,
thus providing possibly a fairer results. Note that the dependency on the
number of waiters is inevitable, since all the waiters compete for a common
resource so their number has to be somehow reflected in waiting time.

CC: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Hellwig <hch@infradead.org>
CC: Dave Chinner <david@fromorbit.com>
CC: Wu Fengguang <fengguang.wu@intel.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/backing-dev.h      |    7 +
 include/linux/writeback.h        |    1 +
 include/trace/events/writeback.h |   65 +++++++-
 mm/backing-dev.c                 |    8 +
 mm/page-writeback.c              |  345 +++++++++++++++++++++++++-------------
 5 files changed, 310 insertions(+), 116 deletions(-)

diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 63ab4a5..65b6e61 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -89,6 +89,13 @@ struct backing_dev_info {
 
 	struct timer_list laptop_mode_wb_timer;
 
+	spinlock_t balance_lock;	/* lock protecting four entries below */
+	unsigned long written_start;	/* BDI_WRITTEN last time we scanned balance_list*/
+	struct list_head balance_list;	/* waiters in balance_dirty_pages */
+	unsigned int balance_waiters;	/* number of waiters in the list */
+	struct delayed_work balance_work;	/* work distributing page
+						   completions among waiters */
+
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *debug_dir;
 	struct dentry *debug_stats;
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 0ead399..901c33f 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -129,6 +129,7 @@ unsigned long bdi_dirty_limit(struct backing_dev_info *bdi,
 			       unsigned long dirty);
 
 void page_writeback_init(void);
+void distribute_page_completions(struct work_struct *work);
 void balance_dirty_pages_ratelimited_nr(struct address_space *mapping,
 					unsigned long nr_pages_dirtied);
 
diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index 4e249b9..c51d4ab 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -147,11 +147,70 @@ DEFINE_EVENT(wbc_class, name, \
 DEFINE_WBC_EVENT(wbc_writeback_start);
 DEFINE_WBC_EVENT(wbc_writeback_written);
 DEFINE_WBC_EVENT(wbc_writeback_wait);
-DEFINE_WBC_EVENT(wbc_balance_dirty_start);
-DEFINE_WBC_EVENT(wbc_balance_dirty_written);
-DEFINE_WBC_EVENT(wbc_balance_dirty_wait);
 DEFINE_WBC_EVENT(wbc_writepage);
 
+TRACE_EVENT(writeback_balance_dirty_pages_waiting,
+	TP_PROTO(struct backing_dev_info *bdi, unsigned long pages),
+	TP_ARGS(bdi, pages),
+	TP_STRUCT__entry(
+		__array(char, name, 32)
+		__field(unsigned long, pages)
+	),
+	TP_fast_assign(
+		strncpy(__entry->name, dev_name(bdi->dev), 32);
+		__entry->pages = pages;
+	),
+	TP_printk("bdi=%s, pages=%lu",
+		  __entry->name, __entry->pages
+	)
+);
+
+TRACE_EVENT(writeback_balance_dirty_pages_woken,
+	TP_PROTO(struct backing_dev_info *bdi),
+	TP_ARGS(bdi),
+	TP_STRUCT__entry(
+		__array(char, name, 32)
+	),
+	TP_fast_assign(
+		strncpy(__entry->name, dev_name(bdi->dev), 32);
+	),
+	TP_printk("bdi=%s",
+		  __entry->name
+	)
+);
+
+TRACE_EVENT(writeback_distribute_page_completions,
+	TP_PROTO(struct backing_dev_info *bdi, unsigned long written),
+	TP_ARGS(bdi, start, written),
+	TP_STRUCT__entry(
+		__array(char, name, 32)
+		__field(unsigned long, start)
+		__field(unsigned long, written)
+	),
+	TP_fast_assign(
+		strncpy(__entry->name, dev_name(bdi->dev), 32);
+		__entry->start = bdi->written_start;
+		__entry->written = written - bdi->written_start;
+	),
+	TP_printk("bdi=%s, written_start=%lu, to_distribute=%lu",
+		  __entry->name, __entry->start, __entry->written
+	)
+);
+
+TRACE_EVENT(writeback_distribute_page_completions_wakeall,
+	TP_PROTO(struct backing_dev_info *bdi),
+	TP_ARGS(bdi),
+	TP_STRUCT__entry(
+		__array(char, name, 32)
+	),
+	TP_fast_assign(
+		strncpy(__entry->name, dev_name(bdi->dev), 32);
+	),
+	TP_printk("bdi=%s",
+		  __entry->name
+	)
+);
+
 DECLARE_EVENT_CLASS(writeback_congest_waited_template,
 
 	TP_PROTO(unsigned int usec_timeout, unsigned int usec_delayed),
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 4d14072..2ecc3fe 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -652,6 +652,12 @@ int bdi_init(struct backing_dev_info *bdi)
 	INIT_LIST_HEAD(&bdi->bdi_list);
 	INIT_LIST_HEAD(&bdi->work_list);
 
+	spin_lock_init(&bdi->balance_lock);
+	INIT_LIST_HEAD(&bdi->balance_list);
+	bdi->written_start = 0;
+	bdi->balance_waiters = 0;
+	INIT_DELAYED_WORK(&bdi->balance_work, distribute_page_completions);
+
 	bdi_wb_init(&bdi->wb, bdi);
 
 	for (i = 0; i < NR_BDI_STAT_ITEMS; i++) {
@@ -691,6 +697,8 @@ void bdi_destroy(struct backing_dev_info *bdi)
 		spin_unlock(&inode_lock);
 	}
 
+	cancel_delayed_work_sync(&bdi->balance_work);
+	WARN_ON(!list_empty(&bdi->balance_list));
 	bdi_unregister(bdi);
 
 	for (i = 0; i < NR_BDI_STAT_ITEMS; i++)
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index f388f70..697dd8e 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -132,6 +132,17 @@ static struct prop_descriptor vm_completions;
 static struct prop_descriptor vm_dirties;
 
 /*
+ * Item a process queues to bdi list in balance_dirty_pages() when it gets
+ * throttled
+ */
+struct balance_waiter {
+	struct list_head bw_list;
+	unsigned long bw_wait_pages;	/* Number of pages to wait for to
+					   get written */
+	struct task_struct *bw_task;	/* Task waiting for IO */
+};
+
+/*
  * couple the period to the dirty_ratio:
  *
  *   period/2 ~ roundup_pow_of_two(dirty limit)
@@ -476,140 +487,248 @@ unsigned long bdi_dirty_limit(struct backing_dev_info *bdi, unsigned long dirty)
 	return bdi_dirty;
 }
 
-/*
- * balance_dirty_pages() must be called by processes which are generating dirty
- * data.  It looks at the number of dirty pages in the machine and will force
- * the caller to perform writeback if the system is over `vm_dirty_ratio'.
- * If we're over `background_thresh' then the writeback threads are woken to
- * perform some writeout.
- */
-static void balance_dirty_pages(struct address_space *mapping,
-				unsigned long write_chunk)
-{
-	long nr_reclaimable, bdi_nr_reclaimable;
-	long nr_writeback, bdi_nr_writeback;
+struct dirty_limit_state {
+	long nr_reclaimable;
+	long nr_writeback;
+	long bdi_nr_reclaimable;
+	long bdi_nr_writeback;
 	unsigned long background_thresh;
 	unsigned long dirty_thresh;
 	unsigned long bdi_thresh;
-	unsigned long min_bdi_thresh = ULONG_MAX;
-	unsigned long pages_written = 0;
-	unsigned long pause = 1;
-	bool dirty_exceeded = false;
-	bool min_dirty_exceeded = false;
-	struct backing_dev_info *bdi = mapping->backing_dev_info;
+};
 
-	for (;;) {
-		struct writeback_control wbc = {
-			.sync_mode	= WB_SYNC_NONE,
-			.older_than_this = NULL,
-			.nr_to_write	= write_chunk,
-			.range_cyclic	= 1,
-		};
+static void get_global_dirty_limit_state(struct dirty_limit_state *st)
+{
+	/*
+	 * Note: nr_reclaimable denotes nr_dirty + nr_unstable.  Unstable
+	 * writes are a feature of certain networked filesystems (i.e. NFS) in
+	 * which data may have been written to the server's write cache, but
+	 * has not yet been flushed to permanent storage.
+	 */
+	st->nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
+				global_page_state(NR_UNSTABLE_NFS);
+	st->nr_writeback = global_page_state(NR_WRITEBACK);
 
-		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
-					global_page_state(NR_UNSTABLE_NFS);
-		nr_writeback = global_page_state(NR_WRITEBACK);
+	global_dirty_limits(&st->background_thresh, &st->dirty_thresh);
+}
 
-		global_dirty_limits(&background_thresh, &dirty_thresh);
+/* This function expects global state to be already filled in! */
+static void get_bdi_dirty_limit_state(struct backing_dev_info *bdi,
+				      struct dirty_limit_state *st)
+{
+	unsigned long min_bdi_thresh;
 
-		/*
-		 * Throttle it only when the background writeback cannot
-		 * catch-up. This avoids (excessively) small writeouts
-		 * when the bdi limits are ramping up.
-		 */
-		if (nr_reclaimable + nr_writeback <=
-				(background_thresh + dirty_thresh) / 2)
-			break;
+	st->bdi_thresh = bdi_dirty_limit(bdi, st->dirty_thresh);
+	min_bdi_thresh = task_min_dirty_limit(st->bdi_thresh);
+	/*
+	 * In order to avoid the stacked BDI deadlock we need to ensure we
+	 * accurately count the 'dirty' pages when the threshold is low.
+	 *
+	 * Otherwise it would be possible to get thresh+n pages reported dirty,
+	 * even though there are thresh-m pages actually dirty; with m+n
+	 * sitting in the percpu deltas.
+	 */
+	if (min_bdi_thresh < 2*bdi_stat_error(bdi)) {
+		st->bdi_nr_reclaimable = bdi_stat_sum(bdi, BDI_RECLAIMABLE);
+		st->bdi_nr_writeback = bdi_stat_sum(bdi, BDI_WRITEBACK);
+	} else {
+		st->bdi_nr_reclaimable = bdi_stat(bdi, BDI_RECLAIMABLE);
+		st->bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
+	}
+}
 
-		bdi_thresh = bdi_dirty_limit(bdi, dirty_thresh);
-		min_bdi_thresh = task_min_dirty_limit(bdi_thresh);
-		bdi_thresh = task_dirty_limit(current, bdi_thresh);
+/* Possibly states of dirty memory for BDI */
+enum {
+	DIRTY_OK,			/* Everything below limit */
+	DIRTY_EXCEED_BACKGROUND,	/* Backround writeback limit exceeded */
+	DIRTY_MAY_EXCEED_LIMIT,		/* Some task may exceed its dirty limit */
+	DIRTY_EXCEED_LIMIT,		/* Global dirty limit exceeded */
+};
 
-		/*
-		 * In order to avoid the stacked BDI deadlock we need
-		 * to ensure we accurately count the 'dirty' pages when
-		 * the threshold is low.
-		 *
-		 * Otherwise it would be possible to get thresh+n pages
-		 * reported dirty, even though there are thresh-m pages
-		 * actually dirty; with m+n sitting in the percpu
-		 * deltas.
-		 */
-		if (bdi_thresh < 2*bdi_stat_error(bdi)) {
-			bdi_nr_reclaimable = bdi_stat_sum(bdi, BDI_RECLAIMABLE);
-			bdi_nr_writeback = bdi_stat_sum(bdi, BDI_WRITEBACK);
-		} else {
-			bdi_nr_reclaimable = bdi_stat(bdi, BDI_RECLAIMABLE);
-			bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
-		}
+static int check_dirty_limits(struct backing_dev_info *bdi,
+			      struct dirty_limit_state *st)
+{
+	unsigned long min_bdi_thresh;
+	int ret = DIRTY_OK;
 
-		/*
-		 * The bdi thresh is somehow "soft" limit derived from the
-		 * global "hard" limit. The former helps to prevent heavy IO
-		 * bdi or process from holding back light ones; The latter is
-		 * the last resort safeguard.
-		 */
-		dirty_exceeded =
-			(bdi_nr_reclaimable + bdi_nr_writeback > bdi_thresh)
-			|| (nr_reclaimable + nr_writeback > dirty_thresh);
-		min_dirty_exceeded =
-			(bdi_nr_reclaimable + bdi_nr_writeback > min_bdi_thresh)
-			|| (nr_reclaimable + nr_writeback > dirty_thresh);
-
-		if (!dirty_exceeded)
-			break;
+	get_global_dirty_limit_state(st);
+	/*
+	 * Throttle it only when the background writeback cannot catch-up. This
+	 * avoids (excessively) small writeouts when the bdi limits are ramping
+	 * up.
+	 */
+	if (st->nr_reclaimable + st->nr_writeback <=
+			(st->background_thresh + st->dirty_thresh) / 2)
+		goto out;
 
-		if (!bdi->dirty_exceeded)
-			bdi->dirty_exceeded = 1;
-
-		/* Note: nr_reclaimable denotes nr_dirty + nr_unstable.
-		 * Unstable writes are a feature of certain networked
-		 * filesystems (i.e. NFS) in which data may have been
-		 * written to the server's write cache, but has not yet
-		 * been flushed to permanent storage.
-		 * Only move pages to writeback if this bdi is over its
-		 * threshold otherwise wait until the disk writes catch
-		 * up.
-		 */
-		trace_wbc_balance_dirty_start(&wbc, bdi);
-		if (bdi_nr_reclaimable > bdi_thresh) {
-			writeback_inodes_wb(&bdi->wb, &wbc);
-			pages_written += write_chunk - wbc.nr_to_write;
-			trace_wbc_balance_dirty_written(&wbc, bdi);
-			if (pages_written >= write_chunk)
-				break;		/* We've done our duty */
+	get_bdi_dirty_limit_state(bdi, st);
+	min_bdi_thresh = task_min_dirty_limit(st->bdi_thresh);
+
+	/*
+	 * The bdi thresh is somehow "soft" limit derived from the global
+	 * "hard" limit. The former helps to prevent heavy IO bdi or process
+	 * from holding back light ones; The latter is the last resort
+	 * safeguard.
+	 */
+	if (st->nr_reclaimable + st->nr_writeback > st->dirty_thresh) {
+		ret = DIRTY_EXCEED_LIMIT;
+		goto out;
+	}
+	if (st->bdi_nr_reclaimable + st->bdi_nr_writeback > min_bdi_thresh) {
+		ret = DIRTY_MAY_EXCEED_LIMIT;
+		goto out;
+	}
+	if (st->nr_reclaimable > st->background_thresh)
+		ret = DIRTY_EXCEED_BACKGROUND;
+out:
+	return ret;
+}
+
+static bool bdi_task_limit_exceeded(struct dirty_limit_state *st,
+				    struct task_struct *p)
+{
+	unsigned long bdi_thresh;
+
+	bdi_thresh = task_dirty_limit(p, st->bdi_thresh);
+
+	return st->bdi_nr_reclaimable + st->bdi_nr_writeback > bdi_thresh;
+}
+
+static void balance_waiter_done(struct backing_dev_info *bdi,
+				struct balance_waiter *bw)
+{
+	list_del_init(&bw->bw_list);
+	bdi->balance_waiters--;
+	wake_up_process(bw->bw_task);
+}
+
+void distribute_page_completions(struct work_struct *work)
+{
+	struct backing_dev_info *bdi =
+		container_of(work, struct backing_dev_info, balance_work.work);
+	unsigned long written = bdi_stat_sum(bdi, BDI_WRITTEN);
+	unsigned long pages_per_waiter;
+	struct balance_waiter *waiter, *tmpw;
+	struct dirty_limit_state st;
+	int dirty_exceeded;
+
+	trace_writeback_distribute_page_completions(bdi, written);
+	dirty_exceeded = check_dirty_limits(bdi, &st);
+	if (dirty_exceeded < DIRTY_MAY_EXCEED_LIMIT) {
+		/* Wakeup everybody */
+		trace_writeback_distribute_page_completions_wakeall(bdi);
+		spin_lock(&bdi->balance_lock);
+		list_for_each_entry_safe(
+				waiter, tmpw, &bdi->balance_list, bw_list)
+			balance_waiter_done(bdi, waiter);
+		spin_unlock(&bdi->balance_lock);
+		return;
+	}
+
+	spin_lock(&bdi->balance_lock);
+	/* Distribute pages equally among waiters */
+	while (!list_empty(&bdi->balance_list)) {
+		pages_per_waiter = (written - bdi->written_start) /
+							bdi->balance_waiters;
+		if (!pages_per_waiter)
+			break;
+		list_for_each_entry_safe(
+				waiter, tmpw, &bdi->balance_list, bw_list) {
+			unsigned long delta = min(pages_per_waiter,
+						  waiter->bw_wait_pages);
+
+			waiter->bw_wait_pages -= delta;
+			bdi->written_start += delta;
+			if (waiter->bw_wait_pages == 0)
+				balance_waiter_done(bdi, waiter);
 		}
-		trace_wbc_balance_dirty_wait(&wbc, bdi);
-		__set_current_state(TASK_UNINTERRUPTIBLE);
-		io_schedule_timeout(pause);
+	}
+	/* Wake tasks that might have gotten below their limits */
+	list_for_each_entry_safe(waiter, tmpw, &bdi->balance_list, bw_list) {
+		if (dirty_exceeded == DIRTY_MAY_EXCEED_LIMIT &&
+		     !bdi_task_limit_exceeded(&st, waiter->bw_task))
+			balance_waiter_done(bdi, waiter);
+	}
+	/* More page completions needed? */
+	if (!list_empty(&bdi->balance_list))
+		schedule_delayed_work(&bdi->balance_work, HZ/10);
+	spin_unlock(&bdi->balance_lock);
+}
 
+/*
+ * balance_dirty_pages() must be called by processes which are generating dirty
+ * data.  It looks at the number of dirty pages in the machine and will force
+ * the caller to perform writeback if the system is over `vm_dirty_ratio'.
+ * If we're over `background_thresh' then the writeback threads are woken to
+ * perform some writeout.
+ */
+static void balance_dirty_pages(struct address_space *mapping,
+				unsigned long write_chunk)
+{
+	struct backing_dev_info *bdi = mapping->backing_dev_info;
+	struct balance_waiter bw;
+	struct dirty_limit_state st;
+	int dirty_exceeded = check_dirty_limits(bdi, &st);
+
+	if (dirty_exceeded < DIRTY_MAY_EXCEED_LIMIT ||
+	    (dirty_exceeded == DIRTY_MAY_EXCEED_LIMIT &&
+	     !bdi_task_limit_exceeded(&st, current))) {
+		if (bdi->dirty_exceeded &&
+		    dirty_exceeded < DIRTY_MAY_EXCEED_LIMIT)
+			bdi->dirty_exceeded = 0;
 		/*
-		 * Increase the delay for each loop, up to our previous
-		 * default of taking a 100ms nap.
+		 * In laptop mode, we wait until hitting the higher threshold
+		 * before starting background writeout, and then write out all
+		 * the way down to the lower threshold.  So slow writers cause
+		 * minimal disk activity.
+		 *
+		 * In normal mode, we start background writeout at the lower
+		 * background_thresh, to keep the amount of dirty memory low.
 		 */
-		pause <<= 1;
-		if (pause > HZ / 10)
-			pause = HZ / 10;
+		if (!laptop_mode && dirty_exceeded == DIRTY_EXCEED_BACKGROUND)
+			bdi_start_background_writeback(bdi);
+		return;
 	}
 
-	/* Clear dirty_exceeded flag only when no task can exceed the limit */
-	if (!min_dirty_exceeded && bdi->dirty_exceeded)
-		bdi->dirty_exceeded = 0;
+	if (!bdi->dirty_exceeded)
+		bdi->dirty_exceeded = 1;
 
-	if (writeback_in_progress(bdi))
-		return;
+	trace_writeback_balance_dirty_pages_waiting(bdi, write_chunk);
+	/* Kick flusher thread to start doing work if it isn't already */
+	bdi_start_background_writeback(bdi);
 
+	bw.bw_wait_pages = write_chunk;
+	bw.bw_task = current;
+	spin_lock(&bdi->balance_lock);
 	/*
-	 * In laptop mode, we wait until hitting the higher threshold before
-	 * starting background writeout, and then write out all the way down
-	 * to the lower threshold.  So slow writers cause minimal disk activity.
-	 *
-	 * In normal mode, we start background writeout at the lower
-	 * background_thresh, to keep the amount of dirty memory low.
+	 * First item? Need to schedule distribution of IO completions among
+	 * items on balance_list
+	 */
+	if (list_empty(&bdi->balance_list)) {
+		bdi->written_start = bdi_stat_sum(bdi, BDI_WRITTEN);
+		/* FIXME: Delay should be autotuned based on dev throughput */
+		schedule_delayed_work(&bdi->balance_work, HZ/10);
+	}
+	/*
+	 * Add work to the balance list, from now on the structure is handled
+	 * by distribute_page_completions()
+	 */
+	list_add_tail(&bw.bw_list, &bdi->balance_list);
+	bdi->balance_waiters++;
+	/*
+	 * Setting task state must happen inside balance_lock to avoid races
+	 * with distribution function waking us.
+	 */
+	__set_current_state(TASK_UNINTERRUPTIBLE);
+	spin_unlock(&bdi->balance_lock);
+	/* Wait for pages to get written */
+	schedule();
+	/*
+	 * Enough page completions should have happened by now and we should
+	 * have been removed from the list
 	 */
-	if ((laptop_mode && pages_written) ||
-	    (!laptop_mode && (nr_reclaimable > background_thresh)))
-		bdi_start_background_writeback(bdi);
+	WARN_ON(!list_empty(&bw.bw_list));
+	trace_writeback_balance_dirty_pages_woken(bdi);
 }
 
 void set_page_dirty_balance(struct page *page, int page_mkwrite)
-- 
1.7.1


--BXVAT5kNtrzKuDFl
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0004-mm-Remove-low-limit-from-sync_writeback_pages.patch"

>From a2e285562dea734896e571399cfc993b309029b9 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 26 Jan 2011 17:07:21 +0100
Subject: [PATCH 4/5] mm: Remove low limit from sync_writeback_pages()

sync_writeback_pages() limited minimal amount of pages to write
in balance_dirty_pages() to 3/2*ratelimit_pages (6 MB) to submit
reasonably sized IO. Since we do not submit any IO anymore, be more
fair and let the task wait only for 3/2*(the amount dirtied).

CC: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Hellwig <hch@infradead.org>
CC: Dave Chinner <david@fromorbit.com>
CC: Wu Fengguang <fengguang.wu@intel.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/page-writeback.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 697dd8e..ff07280 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -43,16 +43,11 @@
 static long ratelimit_pages = 32;
 
 /*
- * When balance_dirty_pages decides that the caller needs to perform some
- * non-background writeback, this is how many pages it will attempt to write.
- * It should be somewhat larger than dirtied pages to ensure that reasonably
- * large amounts of I/O are submitted.
+ * When balance_dirty_pages decides that the caller needs to wait for some
+ * writeback to happen, this is how many pages it will attempt to write.
  */
 static inline long sync_writeback_pages(unsigned long dirtied)
 {
-	if (dirtied < ratelimit_pages)
-		dirtied = ratelimit_pages;
-
 	return dirtied + dirtied / 2;
 }
 
-- 
1.7.1


--BXVAT5kNtrzKuDFl
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0005-mm-Autotune-interval-between-distribution-of-page-co.patch"

>From fa819b0ec141ecabdac06edd41463409eec2737c Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 27 Jan 2011 13:34:58 +0100
Subject: [PATCH 5/5] mm: Autotune interval between distribution of page completions

To avoid throttling processes in balance_dirty_pages() for too long, it
is desirable to distribute page completions often enough. On the other
hand we do not want to distribute them too often so that we do not burn
too much CPU. Obviously, the proper interval depends on the amount of
pages we wait for and on the speed the underlying device can write them.
So we estimate the throughput of the device, compute the number of
pages we need to be completed, and from that compute desired time of
next distribution of page completions. To avoid extremities, we force
the computed sleep time to be in [HZ/50..HZ/4] interval.

CC: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Hellwig <hch@infradead.org>
CC: Dave Chinner <david@fromorbit.com>
CC: Wu Fengguang <fengguang.wu@intel.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/backing-dev.h      |    6 ++-
 include/trace/events/writeback.h |   25 ++++++++++
 mm/backing-dev.c                 |    2 +
 mm/page-writeback.c              |   90 ++++++++++++++++++++++++++++++++-----
 4 files changed, 108 insertions(+), 15 deletions(-)

diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 65b6e61..a4f9133 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -89,12 +89,14 @@ struct backing_dev_info {
 
 	struct timer_list laptop_mode_wb_timer;
 
-	spinlock_t balance_lock;	/* lock protecting four entries below */
-	unsigned long written_start;	/* BDI_WRITTEN last time we scanned balance_list*/
+	spinlock_t balance_lock;	/* lock protecting entries below */
 	struct list_head balance_list;	/* waiters in balance_dirty_pages */
 	unsigned int balance_waiters;	/* number of waiters in the list */
 	struct delayed_work balance_work;	/* work distributing page
 						   completions among waiters */
+	unsigned long written_start;	/* BDI_WRITTEN last time we scanned balance_list*/
+	unsigned long start_jiffies;	/* time when we last scanned list */
+	unsigned long pages_per_s;	/* estimated throughput of bdi */
 
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *debug_dir;
diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index c51d4ab..fdf8ad3 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -211,6 +211,31 @@ TRACE_EVENT(writeback_distribute_page_completions_wakeall,
 	)
 );
 
+TRACE_EVENT(writeback_distribute_page_completions_scheduled,
+	TP_PROTO(struct backing_dev_info *bdi, unsigned long nap,
+		 unsigned long pages),
+	TP_ARGS(bdi, nap, pages),
+	TP_STRUCT__entry(
+		__array(char, name, 32)
+		__field(unsigned long, nap)
+		__field(unsigned long, pages)
+		__field(unsigned long, waiters)
+		__field(unsigned long, pages_per_s)
+	),
+	TP_fast_assign(
+		strncpy(__entry->name, dev_name(bdi->dev), 32);
+		__entry->nap = nap;
+		__entry->pages = pages;
+		__entry->waiters = bdi->balance_waiters;
+		__entry->pages_per_s = bdi->pages_per_s;
+	),
+	TP_printk("bdi=%s, sleep=%u ms, want_pages=%lu, waiters=%lu,"
+		  " pages_per_s=%lu",
+		  __entry->name, jiffies_to_msecs(__entry->nap),
+		  __entry->pages, __entry->waiters, __entry->pages_per_s
+	)
+);
+
 DECLARE_EVENT_CLASS(writeback_congest_waited_template,
 
 	TP_PROTO(unsigned int usec_timeout, unsigned int usec_delayed),
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 2ecc3fe..e2cbe5c 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -655,8 +655,10 @@ int bdi_init(struct backing_dev_info *bdi)
 	spin_lock_init(&bdi->balance_lock);
 	INIT_LIST_HEAD(&bdi->balance_list);
 	bdi->written_start = 0;
+	bdi->start_jiffies = 0;
 	bdi->balance_waiters = 0;
 	INIT_DELAYED_WORK(&bdi->balance_work, distribute_page_completions);
+	bdi->pages_per_s = 1;
 
 	bdi_wb_init(&bdi->wb, bdi);
 
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index ff07280..09f1adf 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -597,12 +597,65 @@ static void balance_waiter_done(struct backing_dev_info *bdi,
 	wake_up_process(bw->bw_task);
 }
 
+static unsigned long compute_distribute_time(struct backing_dev_info *bdi,
+					     unsigned long min_pages)
+{
+	unsigned long nap;
+
+	/*
+	 * Because of round robin distribution, every waiter has to get at
+	 * least min_pages pages.
+	 */
+	min_pages *= bdi->balance_waiters;
+	nap = msecs_to_jiffies(
+			((u64)min_pages) * MSEC_PER_SEC / bdi->pages_per_s);
+	/*
+	 * Force computed sleep time to be in interval (HZ/50..HZ/5)
+	 * so that we
+	 * a) don't wake too often and burn too much CPU
+	 * b) check dirty limits at least once in a while
+	 */
+	nap = max_t(unsigned long, HZ/50, nap);
+	nap = min_t(unsigned long, HZ/4, nap);
+	trace_writeback_distribute_page_completions_scheduled(bdi, nap,
+		min_pages);
+	return nap;
+}
+
+/*
+ * When the throughput is computed, we consider an imaginary WINDOW_MS
+ * miliseconds long window. In this window, we know that it took 'deltams'
+ * miliseconds to write 'written' pages and for the rest of the window we
+ * assume number of pages corresponding to the throughput we previously
+ * computed to have been written. Thus we obtain total number of pages
+ * written in the imaginary window and from it new throughput.
+ */
+#define WINDOW_MS 10000
+
+static void update_bdi_throughput(struct backing_dev_info *bdi,
+				 unsigned long written, unsigned long time)
+{
+	unsigned int deltams = jiffies_to_msecs(time - bdi->start_jiffies);
+
+	written -= bdi->written_start;
+	if (deltams > WINDOW_MS) {
+		/* Add 1 to avoid 0 result */
+		bdi->pages_per_s = 1 + ((u64)written) * MSEC_PER_SEC / deltams;
+		return;
+	}
+	bdi->pages_per_s = 1 +
+		(((u64)bdi->pages_per_s) * (WINDOW_MS - deltams) +
+		 ((u64)written) * MSEC_PER_SEC) / WINDOW_MS;
+}
+
 void distribute_page_completions(struct work_struct *work)
 {
 	struct backing_dev_info *bdi =
 		container_of(work, struct backing_dev_info, balance_work.work);
 	unsigned long written = bdi_stat_sum(bdi, BDI_WRITTEN);
 	unsigned long pages_per_waiter;
+	unsigned long cur_time = jiffies;
+	unsigned long min_pages = ULONG_MAX;
 	struct balance_waiter *waiter, *tmpw;
 	struct dirty_limit_state st;
 	int dirty_exceeded;
@@ -616,11 +669,14 @@ void distribute_page_completions(struct work_struct *work)
 		list_for_each_entry_safe(
 				waiter, tmpw, &bdi->balance_list, bw_list)
 			balance_waiter_done(bdi, waiter);
+		update_bdi_throughput(bdi, written, cur_time);
 		spin_unlock(&bdi->balance_lock);
 		return;
 	}
 
 	spin_lock(&bdi->balance_lock);
+	update_bdi_throughput(bdi, written, cur_time);
+	bdi->start_jiffies = cur_time;
 	/* Distribute pages equally among waiters */
 	while (!list_empty(&bdi->balance_list)) {
 		pages_per_waiter = (written - bdi->written_start) /
@@ -638,15 +694,22 @@ void distribute_page_completions(struct work_struct *work)
 				balance_waiter_done(bdi, waiter);
 		}
 	}
-	/* Wake tasks that might have gotten below their limits */
+	/*
+	 * Wake tasks that might have gotten below their limits and compute
+	 * the number of pages we wait for
+	 */
 	list_for_each_entry_safe(waiter, tmpw, &bdi->balance_list, bw_list) {
 		if (dirty_exceeded == DIRTY_MAY_EXCEED_LIMIT &&
-		     !bdi_task_limit_exceeded(&st, waiter->bw_task))
+		    !bdi_task_limit_exceeded(&st, waiter->bw_task))
 			balance_waiter_done(bdi, waiter);
+		else if (waiter->bw_wait_pages < min_pages)
+			min_pages = waiter->bw_wait_pages;
 	}
 	/* More page completions needed? */
-	if (!list_empty(&bdi->balance_list))
-		schedule_delayed_work(&bdi->balance_work, HZ/10);
+	if (!list_empty(&bdi->balance_list)) {
+		schedule_delayed_work(&bdi->balance_work,
+			      compute_distribute_time(bdi, min_pages));
+	}
 	spin_unlock(&bdi->balance_lock);
 }
 
@@ -696,21 +759,22 @@ static void balance_dirty_pages(struct address_space *mapping,
 	bw.bw_task = current;
 	spin_lock(&bdi->balance_lock);
 	/*
-	 * First item? Need to schedule distribution of IO completions among
-	 * items on balance_list
-	 */
-	if (list_empty(&bdi->balance_list)) {
-		bdi->written_start = bdi_stat_sum(bdi, BDI_WRITTEN);
-		/* FIXME: Delay should be autotuned based on dev throughput */
-		schedule_delayed_work(&bdi->balance_work, HZ/10);
-	}
-	/*
 	 * Add work to the balance list, from now on the structure is handled
 	 * by distribute_page_completions()
 	 */
 	list_add_tail(&bw.bw_list, &bdi->balance_list);
 	bdi->balance_waiters++;
 	/*
+	 * First item? Need to schedule distribution of IO completions among
+	 * items on balance_list
+	 */
+	if (bdi->balance_waiters == 1) {
+		bdi->written_start = bdi_stat_sum(bdi, BDI_WRITTEN);
+		bdi->start_jiffies = jiffies;
+		schedule_delayed_work(&bdi->balance_work,
+			compute_distribute_time(bdi, write_chunk));
+	}
+	/*
 	 * Setting task state must happen inside balance_lock to avoid races
 	 * with distribution function waking us.
 	 */
-- 
1.7.1


--BXVAT5kNtrzKuDFl--
