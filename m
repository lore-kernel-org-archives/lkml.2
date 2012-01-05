Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030186Ab2AEXnY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 18:43:24 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55912 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932235Ab2AEXnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 18:43:08 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, mingo@redhat.com, rostedt@goodmis.org, fweisbec@gmail.com,
        teravest@google.com, slavapestov@google.com, ctalbott@google.com,
        dsharp@google.com
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCHSET RESEND] ioblame: statistical IO analyzer
Date: Thu,  5 Jan 2012 15:42:43 -0800
Message-Id: <1325806974-23486-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is re-post.  The original posting was on Dec 15th but it was
missing cc to LKML.  I got some responses on that thread so didn't
suspect LKML was missing.  If you're getting it the second time.  My
apologies.

Stuff pointed out in the original thread are...

* Is the quick variant of backtrace gathering really necessary? -
  Still need to get performance numbers.

* TRACE_EVENT_CONDITION() can be used in some places. - Will be
  updated.

Original message follows.  Thanks.

Hello, guys.

Even with blktrace and tracepoints, getting insight into the IOs going
on a system is very challenging.  A lot of IO operations happen long
after the action which triggered the IO finished and the overall
asynchronous nature of IO operations make it difficult to trace back
the origin of a given IO.

ioblame is an attempt at providing better visibility into overall IO
behavior.  ioblame hooks into various tracepoints and tries to
determine who caused any given IO how and charges the IO accordingly.

On each IO completion, ioblame knows who to charge the IO (task), how
the IO got triggered (stack trace at the point of triggering, be it
page, inode dirtying or direct IO issue) and various information about
the IO itself (offset, size, how long it took and so on).  ioblame
collects this information into histograms which is configurable from
userland using debugfs interface.

For example, using ioblame, user can acquire information like "this
task triggered IO with this stack trace on this file with the
following offset distribution".

For more details, please read Documentation/trace/ioblame.txt, which
I'll append to this message too for discussion.

This patchset contains the following 11 patches.

  0001-trace_event_filter-factorize-filter-creation.patch
  0002-trace_event_filter-add-trace_event_filter_-interface.patch
  0003-block-block_bio_complete-tracepoint-was-missing.patch
  0004-block-add-req-to-bio_-front-back-_merge-tracepoints.patch
  0005-block-abstract-disk-iteration-into-disk_iter.patch
  0006-writeback-move-struct-wb_writeback_work-to-writeback.patch
  0007-writeback-add-more-tracepoints.patch
  0008-block-add-block_touch_buffer-tracepoint.patch
  0009-vfs-add-fcheck-tracepoint.patch
  0010-stacktrace-implement-save_stack_trace_quick.patch
  0011-block-trace-implement-ioblame-IO-statistical-analyze.patch

0001-0002 export trace_event_filter so that ioblame can use it too.

0003 adds back block_bio_complete TP invocation, which got lost
somehow.  This probably makes sense as fix patch for 3.2.

0004-0006 update block layer in preparation.  0005 probably makes
sense as a standalone patch too.

0007-0009 add more tracepoints along the IO stack.

0010 adds nimbler backtrace dump function as ioblame dumps stacktrace
extremely frequently.

0011 implements ioblame.

This is still in early stage and I haven't done much performance
analysis yet.  Tentative testing shows it adds ~20% CPU overhead when
used on memory backed loopback device.

The patches are on top of mainline (42ebfc61cf "Merge branch
'stable...git/konrad/xen'") and perf/core (74eec26fac "perf tools: Add
ability to synthesize event according to a sample").

It's also available in the following git branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-ioblame

diffstat follows.

 Documentation/trace/ioblame.txt    |  646 ++++++
 arch/x86/include/asm/stacktrace.h  |    2 
 arch/x86/kernel/stacktrace.c       |   40 
 block/blk-core.c                   |    5 
 block/genhd.c                      |   98 -
 fs/bio.c                           |    3 
 fs/fs-writeback.c                  |   34 
 fs/super.c                         |    2 
 include/linux/blk_types.h          |    7 
 include/linux/buffer_head.h        |    7 
 include/linux/fdtable.h            |    3 
 include/linux/fs.h                 |    3 
 include/linux/genhd.h              |   14 
 include/linux/ioblame.h            |   95 +
 include/linux/stacktrace.h         |    6 
 include/linux/writeback.h          |   18 
 include/trace/events/block.h       |   70 
 include/trace/events/vfs.h         |   40 
 include/trace/events/writeback.h   |  113 +
 kernel/stacktrace.c                |    6 
 kernel/trace/Kconfig               |   11 
 kernel/trace/Makefile              |    1 
 kernel/trace/blktrace.c            |    2 
 kernel/trace/ioblame.c             | 3479 +++++++++++++++++++++++++++++++++++++
 kernel/trace/trace.h               |    6 
 kernel/trace/trace_events_filter.c |  379 ++--
 mm/page-writeback.c                |    2 
 27 files changed, 4872 insertions(+), 220 deletions(-)

Thanks.

--
tejun


ioblame - statistical IO analyzer with origin tracking

December, 2011		Tejun Heo <tj@kernel.org>


CONTENTS

1. Introduction
2. Overall design
3. Debugfs interface
3-1. Configuration
3-2. Monitoring
3-3. Data acquisition
4. Notes
5. Overheads


1. Introduction

In many workloads, IO throughput and latency have large effect on
overall performance; however, due to the complexity and asynchronous
nature, it is very difficult to characterize what's going on.
blktrace and various tracepoints provide visibility into individual IO
operations but it is still extremely difficult to trace back to the
origin of those IO operations.

ioblame is statistical IO analyzer which can track and record origin
of IOs.  It keeps track of who dirtied pages and inodes, and, on an
actual IO, attributes it to the originator of the IO.

The design goals of ioblame are

* Minimally invasive - Analyzer shouldn't be invasive.  Except for
  adding some fields to mostly block layer data structures for
  tracking, ioblame gathers all information through well defined
  tracepoints and all tracking logic is contained in ioblame proper.

* Generic and detailed - There are many different IO paths and
  filesystems which also go through changes regularly.  Analyzer
  should be able to report detailed enough result covering most cases
  without requiring frequent adaptation.  ioblame uses stack trace at
  key points combined information from generic layers to categorize
  IOs.  This gives detailed enough information into varying IO paths
  without requiring specific adaptations.

* Low overhead - Overhead both in terms of memory and processor cycles
  should be low enough so that the analyzer can be used in IO-heavy
  production environments.  ioblame keeps hot data structures compact
  and mostly read-only and avoids synchronization on hot paths by
  using RCU and taking advantage of the fact that statistics doesn't
  have to be completely accurate.

* Dynamic and customizable - There are many different aspects of IOs
  which can be irrelevant or interesting depending on the situation.
  From analysis point of view, always recording all collected data
  would be ideal but is very wasteful in most situations.  ioblame
  lets users decide what information to gather so that they can
  acquire relevant information without wasting resources
  unnecessarily.  ioblame also allows dynamic configuration while the
  analyzer is online which enables dynamic drill down of IO behaviors.


2. Overall design

ioblame tracks the following three object types.

* Role: This tracks 'who' is taking an action.  Normally corresponds
  to a thread.  Can also be specified by userland (not implemented
  yet).

* Intent: Stack trace + modifier.  An intent groups actions of the
  same type.  As the name suggests, modifier modifies the intent and
  there can be multiple intents with the same stack trace but
  different modifiers.  Currently, only writeback modifiers are
  implemented which denote why the writeback action is occurring -
  ie. wb_reason.

* Act: This is combination of role, intent and the inode being
  operated on and the ultimate tracking unit ioblame uses.  IOs are
  charged to and statistics are gathered by acts.

ioblame uses the same indexing data structure for all three types of
objects.  Objects are never linked directly using pointers and every
access goes through the index.  This allows avoiding expensive strict
object lifetime management.  Objects are located either by its content
via hash table or id which contains generation number.

To attribute data writebacks to the originator, ioblame maintains a
table indexed by page frame number which keeps track of which act
dirtied which pages.  For each IO, the target pages are looked up in
the table and the dirtying act is charged for the IO.  Note that,
currently, each IO is charged as whole to a single act - e.g. all of
an IO for writeback encompassing multiple dirtiers will be charged to
the first found dirtying act.  This simplifies data collection and
reporting while not losing too much information - writebacks tend to
be naturally grouped and IOPS (IO operations per second) are often
more significant than length of each IO.

inode writeback tracking is more involved as different filesystems
handle metadata updates and writebacks differently.  ioblame uses
per-inode and buffer_head operation tracking to identify inode
writebacks to the originator.

After all the tracking, on each IO completion, ioblame knows the
offset and size of the IO, the act to be charged, how long it took in
the queue and device.  From the information, ioblame produces fields
which can be recorded.

All statistics are recorded in histograms, called counters, which have
eight slots.  Userland can specify the number of counters, IO
directions to consider, what each counter records, the boundary values
to decide histogram slots and optional filter for more complex
filtering conditions.

All interactions including configuration and data acquisition happen
via files under /sys/kernel/debug/ioblame/.


3. Debugfs interface

3-1. Configuration

* devs				- can be changed anytime

  Specifies the devices ioblame is enabled for.  ioblame will only
  track operations on devices which are explicitly enabled in this
  file.

  It accepts white space separated list of MAJ:MINs or block device
  names with optional preceding '!' for negation.  Opening with
  O_TRUNC clears all existing entries.  For example,

  $ echo sda sdb > devs		# disables all devices and then enable sd[ab]
  $ echo sdc >> devs		# sd[abc] enabled
  $ echo !8:0 >> devs		# sd[bc] enabled
  $ cat devs
  8:16 sdb
  8:32 sdc

* max_{role|intent|act}s	- can be changed while disabled

  Specifies the maximum number of each object type.  If the number of
  certain object type exceeds the limit, IOs will be attributed to
  special NOMEM object.

* ttl_secs			- can be changed anytime

  Specifies TTL of roles and acts.  Roles are reclaimed after at least
  TTL has passed after the matching thread has exited or execed and
  assumed another tid.  Acts are reclaimed after being unused for at
  least TTL.

  Note that reclaiming is tied to userland reading counters data.  If
  userland doesn't read counters, reclaiming won't happen.

* nr_counters			- can be changed while disabled

  Specifies the number of counters.  Each act will have the specified
  number of histograms associated with it.  Individual counters can be
  configured using files under the counters subdirectory.  Any write
  to this file clears all counter settings.

* counters/NR			- can be changed anytime

  Specifies each counter.  Its format is

    DIR FIELD B0 B1 B2 B3 B4 B5 B6 B7 B8

  DIR is any combination of letters 'R', 'A', and 'W', each
  representing reads (sans readaheads), readaheads and writes.

  FIELD is the field to record in histogram and one of the followings.

    offset	: IO offset scaled to 0-65535
    size	: IO size
    wait_time	: time spent queued in usecs
    io_time	: time spent on device in usecs
    seek_dist	: seek dist from IO completed right before, scaled to 0-65536

  B[0-8] are the boundaries for the histogram.  Histograms have eight
  slots.  If (FIELD < B[0] || (B[8] != 0 && FIELD >= B[8])), it's not
  recorded; otherwise, FIELD is counted in the slot with enclosing
  boundaries.  e.g. If FIELD is >= B2 and < B3, it's recorded in the
  second slot (slot 1).

  B8 can be zero indicating no upper limit but all other boundaries
  must be equal to or larger than the boundary before them.

  e.g. To record offsets of reads and read aheads in counter 0,

  $ echo RA offset 0 8192 16384 24576 32768 40960 49152 57344 0 > counters/0

  If higher resolution than 8 slots is necessary, two counters can be
  used.

  $ echo RA offset 0 4096 8192 12288 16384 20480 24576 28672 32768 > counters/0
  $ echo RA offset 32768 36864 40960 45056 49152 53248 57344 61440 0 \
								   > counters/1

  Writing empty string disables the counter.

  $ echo > 1
  $ cat 1
  --- disabled

* counters/NR_filter		- can be changed anytime

  Specifies trace event type filter for more complex conditions.  For
  example, it allows conditions like "if IO is in the latter half of
  the device, size is smaller than 128k and IO time is equal to or
  longer than 10ms".

  To record IO time in counter 0 with the above condition,

  $ echo 'offset >= 16384 && size < 131072 && io_time >= 10000' > 0_filter
  $ echo RAW io_time 10000 25000 50000 100000 500000 1000000 2500000 \
							5000000 0 > 0

  Any FIELD can be used in filter specification.  For more details
  about filter format, please read "Event filtering" section in
  Documentation/trace/events.txt.

  Writing '0' to filter file removes the filter.  Note that writing
  malformed filter disables the filter and reading it back afterwards
  returns error message explaining why parsing failed.


3-2. Monitoring (read only)

* nr_{roles|intents|acts}

  Returns the number of objects of the type.  The number of roles and
  acts can decrease after reclaiming but nr_intents only increases
  while ioblame is enabled.

* stats/idx_nomem

  How many times role, intent or act creation failed because memory
  allocation failed while extending index to accomodate new object.

* stats/idx_nospc

  How many times role, intent or act creation failed because limit
  specified by {role|intent|act}_max is reached.

* stats/node_nomem

  How many times role, intent or act creation failed to allocate.

* stats/pgtree_nomem

  How many times page tree, which maps page frame number to dirtying
  act, failed to expand due to memory allocation failure.

* stats/cnts_nomem

  How many times per-act counter allocation failed.

* stats/iolog_overflow

  How many iolog entries are lost due to overflow.


3-3. Data acquisition (read only)

* iolog

  iolog is primarily a debug feature and dumps IOs as they complete.

  $ cat iolog
  R 4096 @ 74208 pid-5806 (ls) dev=0x800010 ino=0x2 gen=0x0
    #39 modifier=0x0
    [ffffffff811a0696] submit_bh+0xe6/0x120
    [ffffffff811a1f56] ll_rw_block+0xa6/0xb0
    [ffffffff81239a43] ext4_bread+0x43/0x80
    [ffffffff8123f4e3] htree_dirblock_to_tree+0x33/0x190
    [ffffffff8123f79a] ext4_htree_fill_tree+0x15a/0x250
    [ffffffff8122e26e] ext4_readdir+0x10e/0x5d0
    [ffffffff811832d0] vfs_readdir+0xa0/0xc0
    [ffffffff81183450] sys_getdents+0x80/0xe0
    [ffffffff81a3c8bb] system_call_fastpath+0x16/0x1b
  W 4096 @ 0 pid-20 (sync_supers) dev=0x800010 ino=0x0 gen=0x0
    #44 modifier=0x0
    [ffffffff811a0696] submit_bh+0xe6/0x120
    [ffffffff811a371d] __sync_dirty_buffer+0x4d/0xd0
    [ffffffff811a37ae] sync_dirty_buffer+0xe/0x10
    [ffffffff81250ee8] ext4_commit_super+0x188/0x230
    [ffffffff81250fae] ext4_write_super+0x1e/0x30
    [ffffffff811738fa] sync_supers+0xfa/0x100
    [ffffffff8113d3e1] bdi_sync_supers+0x41/0x60
    [ffffffff810ad4c6] kthread+0x96/0xa0
    [ffffffff81a3dcb4] kernel_thread_helper+0x4/0x10
  W 4096 @ 8512 pid-5813 dev=0x800010 ino=0x74 gen=0x4cc12c59
    #45 modifier=0x10000002
    [ffffffff812342cb] ext4_setattr+0x25b/0x4c0
    [ffffffff8118b9ba] notify_change+0x10a/0x2b0
    [ffffffff8119ef87] utimes_common+0xd7/0x180
    [ffffffff8119f0c9] do_utimes+0x99/0xf0
    [ffffffff8119f21d] sys_utimensat+0x2d/0x90
    [ffffffff81a3c8bb] system_call_fastpath+0x16/0x1b
  ...

  The first entry is 4k read at sector 74208 (unscaled) on /dev/sdb
  issued by ls.  The second is sync_supers writing out dirty super
  block.  The third is inode writeback from "touch FILE; sync".  Note
  that the modifier is set (it's indicating WB_REASON_SYNC).

  Here is another example from "cp FILE FILE1" and then waiting.

  W 4096 @ 0 pid-20 (sync_supers) dev=0x800010 ino=0x0 gen=0x0
    #16 modifier=0x0
    [ffffffff8139cd94] submit_bio+0x74/0x100
    [ffffffff811cba3b] submit_bh+0xeb/0x130
    [ffffffff811cecd2] __sync_dirty_buffer+0x52/0xd0
    [ffffffff811ced63] sync_dirty_buffer+0x13/0x20
    [ffffffff81281fa8] ext4_commit_super+0x188/0x230
    [ffffffff81282073] ext4_write_super+0x23/0x40
    [ffffffff8119c8d2] sync_supers+0x102/0x110
    [ffffffff81162c99] bdi_sync_supers+0x49/0x60
    [ffffffff810bc216] kthread+0xb6/0xc0
    [ffffffff81ab13b4] kernel_thread_helper+0x4/0x10
  ...
  W 4096 @ 8512 pid-668 dev=0x800010 ino=0x73 gen=0x17b5119d
    #23 modifier=0x10000003
    [ffffffff811c55b0] __mark_inode_dirty+0x220/0x330
    [ffffffff811cccfb] generic_write_end+0x6b/0xa0
    [ffffffff81268b10] ext4_da_write_end+0x150/0x360
    [ffffffff811444bb] generic_file_buffered_write+0x18b/0x290
    [ffffffff81146938] __generic_file_aio_write+0x238/0x460
    [ffffffff81146bd8] generic_file_aio_write+0x78/0xf0
    [ffffffff8125ef9f] ext4_file_write+0x6f/0x2a0
    [ffffffff811997f2] do_sync_write+0xe2/0x120
    [ffffffff8119a428] vfs_write+0xc8/0x180
    [ffffffff8119a5e1] sys_write+0x51/0x90
    [ffffffff81aafe2b] system_call_fastpath+0x16/0x1b
  ...
  W 524288 @ 3276800 pid-668 dev=0x800010 ino=0x73 gen=0x17b5119d
    #25 modifier=0x10000003
    [ffffffff811cc86c] __set_page_dirty+0x4c/0xd0
    [ffffffff811cc956] mark_buffer_dirty+0x66/0xa0
    [ffffffff811cca39] __block_commit_write+0xa9/0xe0
    [ffffffff811ccc42] block_write_end+0x42/0x90
    [ffffffff811cccc3] generic_write_end+0x33/0xa0
    [ffffffff81268b10] ext4_da_write_end+0x150/0x360
    [ffffffff811444bb] generic_file_buffered_write+0x18b/0x290
    [ffffffff81146938] __generic_file_aio_write+0x238/0x460
    [ffffffff81146bd8] generic_file_aio_write+0x78/0xf0
    [ffffffff8125ef9f] ext4_file_write+0x6f/0x2a0
    [ffffffff811997f2] do_sync_write+0xe2/0x120
    [ffffffff8119a428] vfs_write+0xc8/0x180
    [ffffffff8119a5e1] sys_write+0x51/0x90
    [ffffffff81aafe2b] system_call_fastpath+0x16/0x1b
  ...

  The first entry is ext4 marking super block dirty.  After a while,
  periodic writeback kicks in (modifier 0x100000003) and the inode
  dirtied by cp is written back followed by dirty data pages.

  At this point, iolog is mostly a debug feature.  The output format
  is quite verbose and it isn't particularly performant.  If
  necessary, it can be extended to use trace ringbuffer and grow
  per-cpu binary interface.

* intents

  Dump of intents in Human readable form.

  $ cat intents
  #0 modifier=0x0
  #1 modifier=0x0
  #2 modifier=0x0
  [ffffffff81189a6a] file_update_time+0xca/0x150
  [ffffffff81122030] __generic_file_aio_write+0x200/0x460
  [ffffffff81122301] generic_file_aio_write+0x71/0xe0
  [ffffffff8122ea94] ext4_file_write+0x64/0x280
  [ffffffff811b5d24] aio_rw_vect_retry+0x74/0x1d0
  [ffffffff811b7401] aio_run_iocb+0x61/0x190
  [ffffffff811b81c8] do_io_submit+0x648/0xaf0
  [ffffffff811b867b] sys_io_submit+0xb/0x10
  [ffffffff81a3c8bb] system_call_fastpath+0x16/0x1b
  #3 modifier=0x0
  [ffffffff811aaf2e] __blockdev_direct_IO+0x1f1e/0x37c0
  [ffffffff812353b2] ext4_direct_IO+0x1b2/0x3f0
  [ffffffff81121d6a] generic_file_direct_write+0xba/0x180
  [ffffffff8112210b] __generic_file_aio_write+0x2db/0x460
  [ffffffff81122301] generic_file_aio_write+0x71/0xe0
  [ffffffff8122ea94] ext4_file_write+0x64/0x280
  [ffffffff811b5d24] aio_rw_vect_retry+0x74/0x1d0
  [ffffffff811b7401] aio_run_iocb+0x61/0x190
  [ffffffff811b81c8] do_io_submit+0x648/0xaf0
  [ffffffff811b867b] sys_io_submit+0xb/0x10
  [ffffffff81a3c8bb] system_call_fastpath+0x16/0x1b
  #4 modifier=0x0
  [ffffffff811aaf2e] __blockdev_direct_IO+0x1f1e/0x37c0
  [ffffffff8126da71] ext4_ind_direct_IO+0x121/0x460
  [ffffffff81235436] ext4_direct_IO+0x236/0x3f0
  [ffffffff81122db2] generic_file_aio_read+0x6b2/0x740
  ...

  The # prefixed number is the NR of the intent used to link intent
  from stastics.  Modifier and stack trace follow.  The first two
  entries are special - 0 is nomem intent and 1 is lost intent.  The
  former is used when an intent can't be created because allocation
  failed or intent_max is reached.  The latter is used when reclaiming
  resulted in loss of tracking info and the IO can't be reported
  exactly.

  This file can be seeked by intent NR.  ie. seeking to 3 and reading
  will return intent #3 and after.  Because intents are never
  destroyed while ioblame is enabled, this allows userland tool to
  discover new intents since last reading.  Seeking to the number of
  currently known intents and reading returns only the newly created
  intents.

* intents_bin

  Identical to intents but in compact binary format and likely to be
  much more performant.  Each entry in the file is in the following
  format as defined in include/linux/ioblame.h.

  #define IOB_INTENTS_BIN_VER	1

  /* intent modifer */
  #define IOB_MODIFIER_TYPE_SHIFT	28
  #define IOB_MODIFIER_TYPE_MASK	0xf0000000U
  #define IOB_MODIFIER_VAL_MASK		(~IOB_MODIFIER_TYPE_MASK)

  /* val contains wb_reason */
  #define IOB_MODIFIER_WB		(1 << IOB_MODIFIER_TYPE_SHIFT)

  /* record struct for /sys/kernel/debug/ioblame/intents_bin */
  struct iob_intent_bin_record {
	uint16_t	len;
	uint16_t	ver;
	uint32_t	nr;
	uint32_t	modifier;
	uint32_t	__pad;
	uint64_t	trace[];
  } __packed;

* counters_pipe

  Dumps counters and triggers reclaim.  Opening and reading this file
  returns counters of all acts which have been used since the last
  open.

  Because roles and acts shouldn't be reclaimed before the updated
  counters are reported, reclaiming is tied to counters_pipe access.
  Opening counters_pipe prepares for reclaiming and closing executes
  it.  Act reclaiming works at ttl_secs / 2 granularity.  ioblame
  tries to stay close to the lifetime timings requested by ttl_secs
  but note that reclaim happens only on counters_pipe open/close.

  There can only be one user of counters_pipe at any given moment;
  otherwise, file operations will fail and the output and reclaiming
  timings are undefined.

  All reported histogram counters are u32 and never reset.  It's the
  user's responsibility to calculate the delta if necessary.  Note
  that counters_pipe reports all used acts since last open and
  counters are not guaranteed to have been updated - ie. there can be
  spurious acts in the output.

  counters_pipe is seekable by act NR.

  In the following example, two counters are configured - the first
  one counts read offsets and the second write offsets.  A file is
  copied using dd w/ direct flags.

  $ cat counters_pipe
  pid-20 (sync_supers) int=66 dev=0x800010 ino=0x0 gen=0x0
	  0       0       0       0       0       0       0       0
	  2       0       0       0       0       0       0       0
  pid-1708 int=58 dev=0x800010 ino=0x71 gen=0x3e0d99f2
	 11       0       0       0       0       0       0       0
	  0       0       0       0       0       0       0       0
  pid-1708 int=59 dev=0x800010 ino=0x71 gen=0x3e0d99f2
	 11       0       0       0       0       0       0       0
	  0       0       0       0       0       0       0       0
  pid-1708 int=62 dev=0x800010 ino=0x2727 gen=0xf4739822
	  0       0       0       0       0       0       0       0
	 10       0       0       0       0       0       0       0
  pid-1708 int=63 dev=0x800010 ino=0x2727 gen=0xf4739822
	  0       0       0       0       0       0       0       0
	 10       0       0       0       0       0       0       0
  pid-1708 int=31 dev=0x800010 ino=0x2727 gen=0xf4739822
	  0       0       0       0       0       0       0       0
	  2       0       0       0       0       0       0       0
  pid-1708 int=65 dev=0x800010 ino=0x2727 gen=0xf4739822
	  0       0       0       0       0       0       0       0
	  1       0       0       0       0       0       0       0

  pid-1708 is the dd which copied the file.  The output is separated
  by pid-* lines and each section corresponds to single act, which has
  intent NR and file (dev:ino:gen) associated with it.  One 8-slot
  histogram is printed per line in ascending order.

  The filesystem is mostly empty and, from the output, both files seem
  to be located in the first 1/8th of the disk.

  All reads happened through intent 58 and 59.  From intents file,
  they are,

  #58 modifier=0x0
  [ffffffff8139d974] submit_bio+0x74/0x100
  [ffffffff811d5dba] __blockdev_direct_IO+0xc2a/0x3830
  [ffffffff8129fe51] ext4_ind_direct_IO+0x121/0x470
  [ffffffff8126678e] ext4_direct_IO+0x23e/0x400
  [ffffffff81147b05] generic_file_aio_read+0x6d5/0x760
  [ffffffff81199932] do_sync_read+0xe2/0x120
  [ffffffff8119a5c5] vfs_read+0xc5/0x180
  [ffffffff8119a781] sys_read+0x51/0x90
  [ffffffff81ab1fab] system_call_fastpath+0x16/0x1b
  #59 modifier=0x0
  [ffffffff8139d974] submit_bio+0x74/0x100
  [ffffffff811d7345] __blockdev_direct_IO+0x21b5/0x3830
  [ffffffff8129fe51] ext4_ind_direct_IO+0x121/0x470
  [ffffffff8126678e] ext4_direct_IO+0x23e/0x400
  [ffffffff81147b05] generic_file_aio_read+0x6d5/0x760
  [ffffffff81199932] do_sync_read+0xe2/0x120
  [ffffffff8119a5c5] vfs_read+0xc5/0x180
  [ffffffff8119a781] sys_read+0x51/0x90
  [ffffffff81ab1fab] system_call_fastpath+0x16/0x1b

  Except for hitting slightly different paths in __blockdev_direct_IO,
  they both are ext4 direct reads as expected.  Writes seem more
  diversified and upon examination, #62 and #63 are ext4 direct
  writes.  #31 and #65 are more interesting.

  #31 modifier=0x0
  [ffffffff811cd0cc] __set_page_dirty+0x4c/0xd0
  [ffffffff811cd1b6] mark_buffer_dirty+0x66/0xa0
  [ffffffff811cd299] __block_commit_write+0xa9/0xe0
  [ffffffff811cd4a2] block_write_end+0x42/0x90
  [ffffffff811cd523] generic_write_end+0x33/0xa0
  [ffffffff81269720] ext4_da_write_end+0x150/0x360
  [ffffffff81144878] generic_file_buffered_write+0x188/0x2b0
  [ffffffff81146d18] __generic_file_aio_write+0x238/0x460
  [ffffffff81146fb8] generic_file_aio_write+0x78/0xf0
  [ffffffff8125fbaf] ext4_file_write+0x6f/0x2a0
  [ffffffff81199812] do_sync_write+0xe2/0x120
  [ffffffff8119a308] vfs_write+0xc8/0x180
  [ffffffff8119a4c1] sys_write+0x51/0x90
  [ffffffff81ab1fab] system_call_fastpath+0x16/0x1b

  This is buffered write.  It turns out the file size didn't match the
  specified blocksize, so dd turns off O_DIRECT for the last IO and
  issue buffered write for the remainder.

  Note that the actual IO submission is not visible in the stack trace
  as the IOs are charged to the dirtying act.  Actual IOs are likely
  to be executed from fsync(2).

  #65 modifier=0x0
  [ffffffff811c5e10] __mark_inode_dirty+0x220/0x330
  [ffffffff81267edd] ext4_da_update_reserve_space+0x13d/0x230
  [ffffffff8129006d] ext4_ext_map_blocks+0x13dd/0x1dc0
  [ffffffff81268a31] ext4_map_blocks+0x1b1/0x260
  [ffffffff81269c52] mpage_da_map_and_submit+0xb2/0x480
  [ffffffff8126a84a] ext4_da_writepages+0x30a/0x6e0
  [ffffffff8114f584] do_writepages+0x24/0x40
  [ffffffff811468cb] __filemap_fdatawrite_range+0x5b/0x60
  [ffffffff8114692a] filemap_write_and_wait_range+0x5a/0x80
  [ffffffff8125ff64] ext4_sync_file+0x74/0x440
  [ffffffff811ca31b] vfs_fsync_range+0x2b/0x40
  [ffffffff811ca34c] vfs_fsync+0x1c/0x20
  [ffffffff811ca58a] do_fsync+0x3a/0x60
  [ffffffff811ca5e0] sys_fsync+0x10/0x20
  [ffffffff81ab1fab] system_call_fastpath+0x16/0x1b

  And this is dd fsync(2)ing and marking inode for writeback.  As with
  data writeback, IO submission is not visible in the stack trace.

* counters_pipe_bin

  Identical to counters_pipe but in compact binary format and likely
  to be much more performant.  Each entry in the file is in the
  following format as defined in include/linux/ioblame.h.

  #define IOBC_PIPE_BIN_VER	1

  /* record struct for /sys/kernel/debug/ioblame/counters_pipe_bin */
  struct iobc_pipe_bin_record {
	  uint16_t	len;
	  uint16_t	ver;
	  int32_t	id;		/* >0 pid or negated user id */
	  uint32_t	intent_nr;	/* associated intent */
	  uint32_t	dev;
	  uint64_t	ino;
	  uint32_t	gen;
	  uint32_t	__pad;
	  uint32_t	cnts[];		/* [type][slot] */
  } __packed;

  Note that counters_pipe and counters_pipe_bin can't be used
  parallelly.  Only one opener is allowed across the two files at any
  given moment.


4. Notes

* By the time ioblame reports IOs or counters, the task which gets
  charged might have already exited and this is why ioblame prints
  task command in some reports but not in others.  Userland tool is
  advised to use combination of live task listing and process
  accounting to match pid's to commands.

* dev:ino:gen can be mapped to filename without scanning the whole
  filesystem by constructing FS-specific filehandle, opening it with
  open_by_handle_at(2) and then readlink(2)ing /proc/self/FD.  This
  will return full path as long as the dentry is in cache, which is
  likely if data acquisition and mapping don't happen too long after
  IOs.

* Mechanism to specify userland role ID is not implemented yet.


5. Overheads

On x86_64, role is 104 bytes, intent 32 + 8 * stack_depth and act 72
bytes.  Intents are allocated using kzalloc() and there shouldn't be
too many of them.  Both roles and acts have their own kmem_cache and
can be monitored via /proc/slabinfo.

Each counter occupy 32 * nr_counters and is aligned to cacheline.
Counters are allocated only as necessary.  iob_counters kmem_cache is
dynamically created on enable.

The size of page frame number -> dirtier mapping table is proportional
to the amount of available physical memory.  If max_acts <= 65536,
2bytes are used per PAGE_SIZE.  With 4k page, at most ~0.049% can be
used.  If max_acts > 65536, 4bytes are used doubling the percentage to
~0.098%.  The table also grows dynamically.

There are also indexing data structures used - hash tables, id[ra]s
and a radix tree.  There are three hash tables, each sized according
to max_{roles|intents|acts}.  The maximum memory usage by hash tables
is sizeof(void *) * (max_roles + max_intents + max_acts).  Memory used
by other indexing structures should be negligible.

Preliminary tests w/ fio ssd-test on loopback device on tmpfs, which
is purely CPU cycle bound, shows ~20% throughput hit.

*** TODO: add performance testing results and explain involved CPU
    overheads.

