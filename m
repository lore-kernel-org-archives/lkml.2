Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab2EJDKP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 23:10:15 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:59216 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824Ab2EJDKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 23:10:08 -0400
Date: Wed, 9 May 2012 23:10:02 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: tejun@google.com, agk@redhat.com
Subject: [Bcache v13 08/16] bcache: Documentation, and changes to generic code
Message-ID: <7e8cf40a8f87eab56c9864928b27bf34a4e964c3.1336619038.git.koverstreet@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1336619038.git.koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 Documentation/ABI/testing/sysfs-block-bcache |  156 ++++++++++++++++
 Documentation/bcache.txt                     |  255 +++++++++++++++++++++++++
 drivers/block/Kconfig                        |    2 +
 drivers/block/Makefile                       |    1 +
 drivers/block/bcache/Kconfig                 |   42 +++++
 drivers/block/bcache/Makefile                |    8 +
 include/linux/cgroup_subsys.h                |    6 +
 include/linux/sched.h                        |    4 +
 include/trace/events/bcache.h                |  257 ++++++++++++++++++++++++++
 kernel/fork.c                                |    4 +
 10 files changed, 735 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-block-bcache
 create mode 100644 Documentation/bcache.txt
 create mode 100644 drivers/block/bcache/Kconfig
 create mode 100644 drivers/block/bcache/Makefile
 create mode 100644 include/trace/events/bcache.h

diff --git a/Documentation/ABI/testing/sysfs-block-bcache b/Documentation/ABI/testing/sysfs-block-bcache
new file mode 100644
index 0000000..9e4bbc5
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-block-bcache
@@ -0,0 +1,156 @@
+What:		/sys/block/<disk>/bcache/unregister
+Date:		November 2010
+Contact:	Kent Overstreet <kent.overstreet@gmail.com>
+Description:
+		A write to this file causes the backing device or cache to be
+		unregistered. If a backing device had dirty data in the cache,
+		writeback mode is automatically disabled and all dirty data is
+		flushed before the device is unregistered. Caches unregister
+		all associated backing devices before unregistering themselves.
+
+What:		/sys/block/<disk>/bcache/clear_stats
+Date:		November 2010
+Contact:	Kent Overstreet <kent.overstreet@gmail.com>
+Description:
+		Writing to this file resets all the statistics for the device.
+
+What:		/sys/block/<disk>/bcache/cache
+Date:		November 2010
+Contact:	Kent Overstreet <kent.overstreet@gmail.com>
+Description:
+		For a backing device that has cache, a symlink to
+		the bcache/ dir of that cache.
+
+What:		/sys/block/<disk>/bcache/cache_hits
+Date:		November 2010
+Contact:	Kent Overstreet <kent.overstreet@gmail.com>
+Description:
+		For backing devices: integer number of full cache hits,
+		counted per bio. A partial cache hit counts as a miss.
+
+What:		/sys/block/<disk>/bcache/cache_misses
+Date:		November 2010
+Contact:	Kent Overstreet <kent.overstreet@gmail.com>
+Description:
+		For backing devices: integer number of cache misses.
+
+What:		/sys/block/<disk>/bcache/cache_hit_ratio
+Date:		November 2010
+Contact:	Kent Overstreet <kent.overstreet@gmail.com>
+Description:
+		For backing devices: cache hits as a percentage.
+
+What:		/sys/block/<disk>/bcache/sequential_cutoff
+Date:		November 2010
+Contact:	Kent Overstreet <kent.overstreet@gmail.com>
+Description:
+		For backing devices: Threshold past which sequential IO will
+		skip the cache. Read and written as bytes in human readable
+		units (i.e. echo 10M > sequntial_cutoff).
+
+What:		/sys/block/<disk>/bcache/bypassed
+Date:		November 2010
+Contact:	Kent Overstreet <kent.overstreet@gmail.com>
+Description:
+		Sum of all reads and writes that have bypassed the cache (due
+		to the sequential cutoff).  Expressed as bytes in human
+		readable units.
+
+What:		/sys/block/<disk>/bcache/writeback
+Date:		November 2010
+Contact:	Kent Overstreet <kent.overstreet@gmail.com>
+Description:
+		For backing devices: When on, writeback caching is enabled and
+		writes will be buffered in the cache. When off, caching is in
+		writethrough mode; reads and writes will be added to the
+		cache but no write buffering will take place.
+
+What:		/sys/block/<disk>/bcache/writeback_running
+Date:		November 2010
+Contact:	Kent Overstreet <kent.overstreet@gmail.com>
+Description:
+		For backing devices: when off, dirty data will not be written
+		from the cache to the backing device. The cache will still be
+		used to buffer writes until it is mostly full, at which point
+		writes transparently revert to writethrough mode. Intended only
+		for benchmarking/testing.
+
+What:		/sys/block/<disk>/bcache/writeback_delay
+Date:		November 2010
+Contact:	Kent Overstreet <kent.overstreet@gmail.com>
+Description:
+		For backing devices: In writeback mode, when dirty data is
+		written to the cache and the cache held no dirty data for that
+		backing device, writeback from cache to backing device starts
+		after this delay, expressed as an integer number of seconds.
+
+What:		/sys/block/<disk>/bcache/writeback_percent
+Date:		November 2010
+Contact:	Kent Overstreet <kent.overstreet@gmail.com>
+Description:
+		For backing devices: If nonzero, writeback from cache to
+		backing device only takes place when more than this percentage
+		of the cache is used, allowing more write coalescing to take
+		place and reducing total number of writes sent to the backing
+		device. Integer between 0 and 40.
+
+What:		/sys/block/<disk>/bcache/synchronous
+Date:		November 2010
+Contact:	Kent Overstreet <kent.overstreet@gmail.com>
+Description:
+		For a cache, a boolean that allows synchronous mode to be
+		switched on and off. In synchronous mode all writes are ordered
+		such that the cache can reliably recover from unclean shutdown;
+		if disabled bcache will not generally wait for writes to
+		complete but if the cache is not shut down cleanly all data
+		will be discarded from the cache. Should not be turned off with
+		writeback caching enabled.
+
+What:		/sys/block/<disk>/bcache/discard
+Date:		November 2010
+Contact:	Kent Overstreet <kent.overstreet@gmail.com>
+Description:
+		For a cache, a boolean allowing discard/TRIM to be turned off
+		or back on if the device supports it.
+
+What:		/sys/block/<disk>/bcache/bucket_size
+Date:		November 2010
+Contact:	Kent Overstreet <kent.overstreet@gmail.com>
+Description:
+		For a cache, bucket size in human readable units, as set at
+		cache creation time; should match the erase block size of the
+		SSD for optimal performance.
+
+What:		/sys/block/<disk>/bcache/nbuckets
+Date:		November 2010
+Contact:	Kent Overstreet <kent.overstreet@gmail.com>
+Description:
+		For a cache, the number of usable buckets.
+
+What:		/sys/block/<disk>/bcache/tree_depth
+Date:		November 2010
+Contact:	Kent Overstreet <kent.overstreet@gmail.com>
+Description:
+		For a cache, height of the btree excluding leaf nodes (i.e. a
+		one node tree will have a depth of 0).
+
+What:		/sys/block/<disk>/bcache/btree_cache_size
+Date:		November 2010
+Contact:	Kent Overstreet <kent.overstreet@gmail.com>
+Description:
+		Number of btree buckets/nodes that are currently cached in
+		memory; cache dynamically grows and shrinks in response to
+		memory pressure from the rest of the system.
+
+What:		/sys/block/<disk>/bcache/written
+Date:		November 2010
+Contact:	Kent Overstreet <kent.overstreet@gmail.com>
+Description:
+		For a cache, total amount of data in human readable units
+		written to the cache, excluding all metadata.
+
+What:		/sys/block/<disk>/bcache/btree_written
+Date:		November 2010
+Contact:	Kent Overstreet <kent.overstreet@gmail.com>
+Description:
+		For a cache, sum of all btree writes in human readable units.
diff --git a/Documentation/bcache.txt b/Documentation/bcache.txt
new file mode 100644
index 0000000..270c734
--- /dev/null
+++ b/Documentation/bcache.txt
@@ -0,0 +1,255 @@
+Say you've got a big slow raid 6, and an X-25E or three. Wouldn't it be
+nice if you could use them as cache... Hence bcache.
+
+Userspace tools and a wiki are at:
+  git://evilpiepirate.org/~kent/bcache-tools.git
+  http://bcache.evilpiepirate.org
+
+It's designed around the performance characteristics of SSDs - it only allocates
+in erase block sized buckets, and it uses a hybrid btree/log to track cached
+extants (which can be anywhere from a single sector to the bucket size). It's
+designed to avoid random writes at all costs; it fills up an erase block
+sequentially, then issues a discard before reusing it.
+
+Both writethrough and writeback caching are supported. Writeback defaults to
+off, but can be switched on and off arbitrarily at runtime. Bcache goes to
+great lengths to protect your data - it reliably handles unclean shutdown. (It
+doesn't even have a notion of a clean shutdown; bcache simply doesn't return
+writes as completed until they're on stable storage).
+
+Writeback caching can use most of the cache for buffering writes - writing
+dirty data to the backing device is always done sequentially, scanning from the
+start to the end of the index.
+
+Since random IO is what SSDs excel at, there generally won't be much benefit
+to caching large sequential IO. Bcache detects sequential IO and skips it;
+it also keeps a rolling average of the IO sizes per task, and as long as the
+average is above the cutoff it will skip all IO from that task - instead of
+caching the first 512k after every seek. Backups and large file copies should
+thus entirely bypass the cache.
+
+In the event of a data IO error on the flash it will try to recover by reading
+from disk or invalidating cache entries.  For unrecoverable errors (meta data
+or dirty data), caching is automatically disabled; if dirty data was present
+in the cache it first disables writeback caching and waits for all dirty data
+to be flushed.
+
+Getting started:
+You'll need make-bcache from the bcache-tools repository. Both the cache device
+and backing device must be formatted before use.
+  make-bcache -B /dev/sdb
+  make-bcache -C -w2k -b1M -j64 /dev/sdc
+
+To make bcache devices known to the kernel, echo them to /sys/fs/bcache/register:
+  echo /dev/sdb > /sys/fs/bcache/register
+  echo /dev/sdc > /sys/fs/bcache/register
+
+To register your bcache devices automatically, you could add something like
+this to an init script:
+  echo /dev/sd* > /sys/fs/bcache/register_quiet
+
+It'll look for bcache superblocks and ignore everything that doesn't have one.
+
+When you register a backing device, you'll get a new /dev/bcache# device:
+  mkfs.ext4 /dev/bcache0
+  mount /dev/bcache0 /mnt
+
+Cache devices are managed as sets; multiple caches per set isn't supported yet
+but will allow for mirroring of metadata and dirty data in the future. Your new
+cache set shows up as /sys/fs/bcache/<UUID>
+
+To enable caching, you need to attach the backing device to the cache set by
+specifying the UUID:
+  echo <UUID> > /sys/block/sdb/bcache/attach
+
+The cache set with that UUID need not be registered to attach to it - the UUID
+will be saved to the backing device's superblock and it'll start being cached
+when the cache set does show up.
+
+This only has to be done once. The next time you reboot, just reregister all
+your bcache devices. If a backing device has data in a cache somewhere, the
+/dev/bcache# device won't be created until the cache shows up - particularly
+important if you have writeback caching turned on.
+
+If you're booting up and your cache device is gone and never coming back, you
+can force run the backing device:
+  echo 1 > /sys/block/sdb/bcache/running
+
+The backing device will still use that cache set if it shows up in the future,
+but all the cached data will be invalidated. If there was dirty data in the
+cache, don't expect the filesystem to be recoverable - you will have massive
+filesystem corruption, though ext4's fsck does work miracles.
+
+
+Other sysfs files for the backing device:
+
+  bypassed
+    Sum of all IO, reads and writes, than have bypassed the cache
+
+  cache_hits
+  cache_misses
+  cache_hit_ratio
+    Hits and misses are counted per individual IO as bcache sees them; a
+    partial hit is counted as a miss.
+
+  cache_miss_collisions
+    Count of times a read completes but the data is already in the cache and
+    is therefore redundant.  This is usually caused by readahead while a
+    read to the same location occurs.
+
+  cache_readaheads
+    Count of times readahead occured.
+
+  clear_stats
+    Writing to this file resets all the statistics.
+
+  flush_delay_ms
+  flush_delay_ms_sync
+    Optional delay for btree writes to allow for more coalescing of updates to
+    the index. Default to 0.
+
+  label
+    Name of underlying device.
+
+  readahead
+    Size of readahead that should be performed.  Defaults to 0.  If set to e.g.
+    1M, it will round cache miss reads up to that size, but without overlapping
+    existing cache entries.
+
+  running
+    1 if bcache is running.
+
+  sequential_cutoff
+    A sequential IO will bypass the cache once it passes this threshhold; the
+    most recent 128 IOs are tracked so sequential IO can be detected even when
+    it isn't all done at once.
+
+  sequential_cutoff_average
+    If the weighted average from a client is higher than this cutoff we bypass
+    all IO.
+
+  unregister
+    Writing to this file disables caching on that device
+
+  writeback
+    Boolean, if off only writethrough caching is done
+
+  writeback_delay
+    When dirty data is written to the cache and it previously did not contain
+    any, waits some number of seconds before initiating writeback. Defaults to
+    30.
+
+  writeback_percent
+    To allow for more buffering of random writes, writeback only proceeds when
+    more than this percentage of the cache is unavailable. Defaults to 0.
+
+  writeback_running
+    If off, writeback of dirty data will not take place at all. Dirty data will
+    still be added to the cache until it is mostly full; only meant for
+    benchmarking. Defaults to on.
+
+For the cache set:
+  active_journal_entries
+    Number of journal entries that are newer than the index.
+
+  average_key_size
+    Average data per key in the btree.
+
+  average_seconds_between_gc
+    How often garbage collection is occuring.
+
+  block_size
+    Block size of the virtual device.
+
+  btree_avg_keys_written
+    Average number of keys per write to the btree when a node wasn't being
+    rewritten - indicates how much coalescing is taking place.
+
+
+  btree_cache_size
+    Number of btree buckets currently cached in memory
+
+  btree_nodes
+    Total nodes in the btree.
+
+  btree_used_percent
+    Average fraction of btree in use.
+
+  bucket_size
+    Size of Buckets
+
+  bypassed
+    Sum of all IO, reads and writes, than have bypassed the cache
+
+  cache_available_percent
+    Percentage of cache device free.
+
+  clear_stats
+    Clears the statistics associated with this cache
+
+  dirty_data
+    How much dirty data is in the cache.
+
+  gc_ms_max
+    Longest garbage collection.
+
+  internal/bset_tree_stats
+  internal/btree_cache_max_chain
+    Internal.  Statistics about the bset tree and chain length.  Likely to be
+    hidden soon.
+
+  io_error_halflife
+  io_error_limit
+    These determines how many errors we accept before disabling the cache.
+    Each error is decayed by the half life (in # ios).  If the decaying count
+    reaches io_error_limit dirty data is written out and the cache is disabled.
+
+  root_usage_percent
+    Percentage of the root btree node in use.  If this gets too high the node
+    will split, increasing the tree depth.
+
+  seconds_since_gc
+    When was the last garbage collection.
+
+  synchronous
+    Boolean; when on all writes to the cache are strictly ordered such that it
+    can recover from unclean shutdown. If off it will not generally wait for
+    writes to complete, but the entire cache contents will be invalidated on
+    unclean shutdown. Not recommended that it be turned off when writeback is
+    on.
+
+  tree_depth
+    Depth of the btree.
+
+  trigger_gc
+    Force garbage collection to run now.
+
+  unregister
+    Closes the cache device and all devices being cached; if dirty data is
+    present it will disable writeback caching and wait for it to be flushed.
+
+
+For each cache within a cache set:
+  btree_written
+    Sum of all btree writes, in (kilo/mega/giga) bytes
+
+  discard
+    Boolean; if on a discard/TRIM will be issued to each bucket before it is
+    reused. Defaults to on if supported.
+
+  io_errors
+    Number of errors that have occured, decayed by io_error_halflife.
+
+  metadata_written
+    Total Metadata written (btree + other meta data).
+
+  nbuckets
+    Total buckets in this cache
+
+  priority_stats
+    Statistics about how recently data in the cache has been accessed.  This can
+    reveal your working set size.
+
+  written
+    Sum of all data that has been written to the cache; comparison with
+    btree_written gives the amount of write inflation in bcache.
diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 4e4c8a4..d872600 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -526,6 +526,8 @@ config VIRTIO_BLK
 	  This is the virtual block driver for virtio.  It can be used with
           lguest or QEMU based VMMs (like KVM or Xen).  Say Y or M.
 
+source "drivers/block/bcache/Kconfig"
+
 config BLK_DEV_HD
 	bool "Very old hard disk (MFM/RLL/IDE) driver"
 	depends on HAVE_IDE
diff --git a/drivers/block/Makefile b/drivers/block/Makefile
index 5b79505..19520e1 100644
--- a/drivers/block/Makefile
+++ b/drivers/block/Makefile
@@ -41,5 +41,6 @@ obj-$(CONFIG_XEN_BLKDEV_BACKEND)	+= xen-blkback/
 obj-$(CONFIG_BLK_DEV_DRBD)     += drbd/
 obj-$(CONFIG_BLK_DEV_RBD)     += rbd.o
 obj-$(CONFIG_BLK_DEV_PCIESSD_MTIP32XX)	+= mtip32xx/
+obj-$(CONFIG_BCACHE)           += bcache/
 
 swim_mod-y	:= swim.o swim_asm.o
diff --git a/drivers/block/bcache/Kconfig b/drivers/block/bcache/Kconfig
new file mode 100644
index 0000000..019f133
--- /dev/null
+++ b/drivers/block/bcache/Kconfig
@@ -0,0 +1,42 @@
+
+config BCACHE
+	tristate "Block device as cache"
+	select COMPACTION
+	select CLOSURES
+	---help---
+	Allows a block device to be used as cache for other devices; uses
+	a btree for indexing and the layout is optimized for SSDs.
+
+	See Documentation/bcache.txt for details.
+
+config BCACHE_DEBUG
+	bool "Bcache debugging"
+	depends on BCACHE
+	---help---
+	Don't select this option unless you're a developer
+
+	Enables extra debugging tools (primarily a fuzz tester)
+
+config BCACHE_EDEBUG
+	bool "Extended runtime checks"
+	depends on BCACHE
+	---help---
+	Don't select this option unless you're a developer
+
+	Enables extra runtime checks which significantly affect performance
+
+config BCACHE_LATENCY_DEBUG
+	bool "Latency tracing for bcache"
+	depends on BCACHE
+	---help---
+	Hacky latency tracing that has nevertheless been useful in the past:
+	adds a global variable accessible via /sys/fs/bcache/latency_warn_ms,
+	which defaults to 0. If nonzero, any timed operation that takes longer
+	emits a printk.
+
+config CGROUP_BCACHE
+  bool "Cgroup controls for bcache"
+  depends on BCACHE && BLK_CGROUP
+  ---help---
+  TODO
+
diff --git a/drivers/block/bcache/Makefile b/drivers/block/bcache/Makefile
new file mode 100644
index 0000000..84302f9
--- /dev/null
+++ b/drivers/block/bcache/Makefile
@@ -0,0 +1,8 @@
+
+ccflags-y		+= -std=gnu99
+obj-$(CONFIG_BCACHE)	+= bcache.o
+
+bcache-y		:= alloc.o btree.o bset.o io.o journal.o\
+	writeback.o request.o super.o debug.o util.o trace.o stats.o
+
+CFLAGS_request.o	+= -Iblock
diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
index 0bd390c..d698634 100644
--- a/include/linux/cgroup_subsys.h
+++ b/include/linux/cgroup_subsys.h
@@ -72,3 +72,9 @@ SUBSYS(net_prio)
 #endif
 
 /* */
+
+#ifdef CONFIG_CGROUP_BCACHE
+SUBSYS(bcache)
+#endif
+
+/* */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0657368..63014ba 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1590,6 +1590,10 @@ struct task_struct {
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 	atomic_t ptrace_bp_refcnt;
 #endif
+#if defined(CONFIG_BCACHE) || defined(CONFIG_BCACHE_MODULE)
+	unsigned int	sequential_io;
+	unsigned int	sequential_io_avg;
+#endif
 };
 
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
diff --git a/include/trace/events/bcache.h b/include/trace/events/bcache.h
new file mode 100644
index 0000000..229ffe1
--- /dev/null
+++ b/include/trace/events/bcache.h
@@ -0,0 +1,257 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM bcache
+
+#if !defined(_TRACE_BCACHE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_BCACHE_H
+
+#include <linux/tracepoint.h>
+
+struct btree_op;
+
+DECLARE_EVENT_CLASS(bcache_request,
+
+	TP_PROTO(struct btree_op *op, struct bio *bio),
+
+	TP_ARGS(op, bio),
+
+	TP_STRUCT__entry(
+		__field(dev_t,		dev			)
+		__field(unsigned int,	orig_major		)
+		__field(unsigned int,	orig_minor		)
+		__field(sector_t,	sector			)
+		__field(dev_t,		orig_sector		)
+		__field(unsigned int,	nr_sector		)
+		__array(char,		rwbs,	6		)
+		__array(char,		comm,	TASK_COMM_LEN	)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= bio->bi_bdev->bd_dev;
+		__entry->orig_major	= op->d->disk->major;
+		__entry->orig_minor	= op->d->disk->first_minor;
+		__entry->sector		= bio->bi_sector;
+		__entry->orig_sector	= bio->bi_sector - 16;
+		__entry->nr_sector	= bio->bi_size >> 9;
+		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
+		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+	),
+
+	TP_printk("%d,%d %s %llu + %u [%s] (from %d,%d @ %llu)",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->rwbs,
+		  (unsigned long long)__entry->sector,
+		  __entry->nr_sector, __entry->comm,
+		  __entry->orig_major, __entry->orig_minor,
+		  (unsigned long long)__entry->orig_sector)
+);
+
+DEFINE_EVENT(bcache_request, bcache_request_start,
+
+	TP_PROTO(struct btree_op *op, struct bio* bio),
+
+	TP_ARGS(op, bio)
+);
+
+DEFINE_EVENT(bcache_request, bcache_request_end,
+
+	TP_PROTO(struct btree_op *op, struct bio* bio),
+
+	TP_ARGS(op, bio)
+);
+
+DECLARE_EVENT_CLASS(bcache_bio,
+
+	TP_PROTO(struct bio *bio),
+
+	TP_ARGS(bio),
+
+	TP_STRUCT__entry(
+		__field(dev_t,		dev			)
+		__field(sector_t,	sector			)
+		__field(unsigned int,	nr_sector		)
+		__array(char,		rwbs,	6		)
+		__array(char,		comm,	TASK_COMM_LEN	)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= bio->bi_bdev->bd_dev;
+		__entry->sector		= bio->bi_sector;
+		__entry->nr_sector	= bio->bi_size >> 9;
+		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
+		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+	),
+
+	TP_printk("%d,%d  %s %llu + %u [%s]",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->rwbs,
+		  (unsigned long long)__entry->sector,
+		  __entry->nr_sector, __entry->comm)
+);
+
+
+DEFINE_EVENT(bcache_bio, bcache_passthrough,
+
+	TP_PROTO(struct bio *bio),
+
+	TP_ARGS(bio)
+);
+
+DEFINE_EVENT(bcache_bio, bcache_cache_hit,
+
+	TP_PROTO(struct bio *bio),
+
+	TP_ARGS(bio)
+);
+
+DEFINE_EVENT(bcache_bio, bcache_cache_miss,
+
+	TP_PROTO(struct bio *bio),
+
+	TP_ARGS(bio)
+);
+
+DEFINE_EVENT(bcache_bio, bcache_read_retry,
+
+	TP_PROTO(struct bio *bio),
+
+	TP_ARGS(bio)
+);
+
+DEFINE_EVENT(bcache_bio, bcache_writethrough,
+
+	TP_PROTO(struct bio *bio),
+
+	TP_ARGS(bio)
+);
+
+DEFINE_EVENT(bcache_bio, bcache_writeback,
+
+	TP_PROTO(struct bio *bio),
+
+	TP_ARGS(bio)
+);
+
+DEFINE_EVENT(bcache_bio, bcache_write_skip,
+
+	TP_PROTO(struct bio *bio),
+
+	TP_ARGS(bio)
+);
+
+DEFINE_EVENT(bcache_bio, bcache_btree_read,
+
+	TP_PROTO(struct bio *bio),
+
+	TP_ARGS(bio)
+);
+
+DEFINE_EVENT(bcache_bio, bcache_btree_write,
+
+	TP_PROTO(struct bio *bio),
+
+	TP_ARGS(bio)
+);
+
+DEFINE_EVENT(bcache_bio, bcache_write_dirty,
+
+	TP_PROTO(struct bio *bio),
+
+	TP_ARGS(bio)
+);
+
+DEFINE_EVENT(bcache_bio, bcache_read_dirty,
+
+	TP_PROTO(struct bio *bio),
+
+	TP_ARGS(bio)
+);
+
+DEFINE_EVENT(bcache_bio, bcache_journal_write,
+
+	TP_PROTO(struct bio *bio),
+
+	TP_ARGS(bio)
+);
+
+DECLARE_EVENT_CLASS(bcache_cache_bio,
+
+	TP_PROTO(struct bio *bio,
+		 sector_t orig_sector,
+		 struct block_device* orig_bdev),
+
+	TP_ARGS(bio, orig_sector, orig_bdev),
+
+	TP_STRUCT__entry(
+		__field(dev_t,		dev			)
+		__field(dev_t,		orig_dev		)
+		__field(sector_t,	sector			)
+		__field(sector_t,	orig_sector		)
+		__field(unsigned int,	nr_sector		)
+		__array(char,		rwbs,	6		)
+		__array(char,		comm,	TASK_COMM_LEN	)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= bio->bi_bdev->bd_dev;
+		__entry->orig_dev	= orig_bdev->bd_dev;
+		__entry->sector		= bio->bi_sector;
+		__entry->orig_sector	= orig_sector;
+		__entry->nr_sector	= bio->bi_size >> 9;
+		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
+		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+	),
+
+	TP_printk("%d,%d  %s %llu + %u [%s] (from %d,%d %llu)",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->rwbs,
+		  (unsigned long long)__entry->sector,
+		  __entry->nr_sector, __entry->comm,
+		  MAJOR(__entry->orig_dev), MINOR(__entry->orig_dev),
+		  (unsigned long long)__entry->orig_sector)
+);
+
+DEFINE_EVENT(bcache_cache_bio, bcache_cache_insert,
+
+	TP_PROTO(struct bio *bio,
+		 sector_t orig_sector,
+		 struct block_device *orig_bdev),
+
+	TP_ARGS(bio, orig_sector, orig_bdev)
+);
+
+DECLARE_EVENT_CLASS(bcache_gc,
+
+	TP_PROTO(uint8_t *uuid),
+
+	TP_ARGS(uuid),
+
+	TP_STRUCT__entry(
+		__field(uint8_t *,	uuid)
+	),
+
+	TP_fast_assign(
+		__entry->uuid		= uuid;
+	),
+
+	TP_printk("%pU", __entry->uuid)
+);
+
+
+DEFINE_EVENT(bcache_gc, bcache_gc_start,
+
+	     TP_PROTO(uint8_t *uuid),
+
+	     TP_ARGS(uuid)
+);
+
+DEFINE_EVENT(bcache_gc, bcache_gc_end,
+
+	     TP_PROTO(uint8_t *uuid),
+
+	     TP_ARGS(uuid)
+);
+
+#endif /* _TRACE_BCACHE_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/kernel/fork.c b/kernel/fork.c
index 26a7a67..9b83c81 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1255,6 +1255,10 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->memcg_batch.do_batch = 0;
 	p->memcg_batch.memcg = NULL;
 #endif
+#ifdef CONFIG_BCACHE
+	p->sequential_io	= 0;
+	p->sequential_io_avg	= 0;
+#endif
 
 	/* Perform scheduler related setup. Assign this task to a CPU. */
 	sched_fork(p);
-- 
1.7.9.rc2

