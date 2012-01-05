Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964897Ab2AEXnt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 18:43:49 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55912 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030236Ab2AEXnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 18:43:43 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, mingo@redhat.com, rostedt@goodmis.org, fweisbec@gmail.com,
        teravest@google.com, slavapestov@google.com, ctalbott@google.com,
        dsharp@google.com
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/11] block, trace: implement ioblame IO statistical analyzer
Date: Thu,  5 Jan 2012 15:42:54 -0800
Message-Id: <1325806974-23486-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1325806974-23486-1-git-send-email-tj@kernel.org>
References: <1325806974-23486-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement ioblame, which can attribute each IO to its origin and
record user configurable histograms.

Operations which may eventually cause IOs and IO operations themselves
are identified and tracked primarily by their stack traces along with
the task and the target file (dev:ino:gen).  On each IO completion,
ioblame knows why that specific IO happened and record statistics in
user-configurable histograms.

ioblame aims to deliver insight into overall system IO behavior with
manageable overhead.  Also, to enable follow-the-breadcrumbs type
investigation, a lot of information gathering configurations can be
changed on the fly.

While ioblame adds fields to a few fs and block layer objects, all
logic is well insulated inside ioblame proper and all hooking goes
through well defined tracepoints and doesn't add any significant
maintenance overhead.

For details, please read Documentation/trace/ioblame.txt.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Justin TerAvest <teravest@google.com>
Cc: Slava Pestov <slavapestov@google.com>
---
 Documentation/trace/ioblame.txt |  646 ++++++++
 include/linux/blk_types.h       |    7 +-
 include/linux/fs.h              |    3 +
 include/linux/genhd.h           |    4 +
 include/linux/ioblame.h         |   95 ++
 kernel/trace/Kconfig            |   11 +
 kernel/trace/Makefile           |    1 +
 kernel/trace/ioblame.c          | 3479 +++++++++++++++++++++++++++++++++++++++
 8 files changed, 4244 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/trace/ioblame.txt
 create mode 100644 include/linux/ioblame.h
 create mode 100644 kernel/trace/ioblame.c

diff --git a/Documentation/trace/ioblame.txt b/Documentation/trace/ioblame.txt
new file mode 100644
index 0000000..4541184
--- /dev/null
+++ b/Documentation/trace/ioblame.txt
@@ -0,0 +1,646 @@
+
+ioblame - statistical IO analyzer with origin tracking
+
+December, 2011		Tejun Heo <tj@kernel.org>
+
+
+CONTENTS
+
+1. Introduction
+2. Overall design
+3. Debugfs interface
+3-1. Configuration
+3-2. Monitoring
+3-3. Data acquisition
+4. Notes
+5. Overheads
+
+
+1. Introduction
+
+In many workloads, IO throughput and latency have large effect on
+overall performance; however, due to the complexity and asynchronous
+nature, it is very difficult to characterize what's going on.
+blktrace and various tracepoints provide visibility into individual IO
+operations but it is still extremely difficult to trace back to the
+origin of those IO operations.
+
+ioblame is statistical IO analyzer which can track and record origin
+of IOs.  It keeps track of who dirtied pages and inodes, and, on an
+actual IO, attributes it to the originator of the IO.
+
+The design goals of ioblame are
+
+* Minimally invasive - Analyzer shouldn't be invasive.  Except for
+  adding some fields to mostly block layer data structures for
+  tracking, ioblame gathers all information through well defined
+  tracepoints and all tracking logic is contained in ioblame proper.
+
+* Generic and detailed - There are many different IO paths and
+  filesystems which also go through changes regularly.  Analyzer
+  should be able to report detailed enough result covering most cases
+  without requiring frequent adaptation.  ioblame uses stack trace at
+  key points combined information from generic layers to categorize
+  IOs.  This gives detailed enough information into varying IO paths
+  without requiring specific adaptations.
+
+* Low overhead - Overhead both in terms of memory and processor cycles
+  should be low enough so that the analyzer can be used in IO-heavy
+  production environments.  ioblame keeps hot data structures compact
+  and mostly read-only and avoids synchronization on hot paths by
+  using RCU and taking advantage of the fact that statistics doesn't
+  have to be completely accurate.
+
+* Dynamic and customizable - There are many different aspects of IOs
+  which can be irrelevant or interesting depending on the situation.
+  From analysis point of view, always recording all collected data
+  would be ideal but is very wasteful in most situations.  ioblame
+  lets users decide what information to gather so that they can
+  acquire relevant information without wasting resources
+  unnecessarily.  ioblame also allows dynamic configuration while the
+  analyzer is online which enables dynamic drill down of IO behaviors.
+
+
+2. Overall design
+
+ioblame tracks the following three object types.
+
+* Role: This tracks 'who' is taking an action.  Normally corresponds
+  to a thread.  Can also be specified by userland (not implemented
+  yet).
+
+* Intent: Stack trace + modifier.  An intent groups actions of the
+  same type.  As the name suggests, modifier modifies the intent and
+  there can be multiple intents with the same stack trace but
+  different modifiers.  Currently, only writeback modifiers are
+  implemented which denote why the writeback action is occurring -
+  ie. wb_reason.
+
+* Act: This is combination of role, intent and the inode being
+  operated on and the ultimate tracking unit ioblame uses.  IOs are
+  charged to and statistics are gathered by acts.
+
+ioblame uses the same indexing data structure for all three types of
+objects.  Objects are never linked directly using pointers and every
+access goes through the index.  This allows avoiding expensive strict
+object lifetime management.  Objects are located either by its content
+via hash table or id which contains generation number.
+
+To attribute data writebacks to the originator, ioblame maintains a
+table indexed by page frame number which keeps track of which act
+dirtied which pages.  For each IO, the target pages are looked up in
+the table and the dirtying act is charged for the IO.  Note that,
+currently, each IO is charged as whole to a single act - e.g. all of
+an IO for writeback encompassing multiple dirtiers will be charged to
+the first found dirtying act.  This simplifies data collection and
+reporting while not losing too much information - writebacks tend to
+be naturally grouped and IOPS (IO operations per second) are often
+more significant than length of each IO.
+
+inode writeback tracking is more involved as different filesystems
+handle metadata updates and writebacks differently.  ioblame uses
+per-inode and buffer_head operation tracking to identify inode
+writebacks to the originator.
+
+After all the tracking, on each IO completion, ioblame knows the
+offset and size of the IO, the act to be charged, how long it took in
+the queue and device.  From the information, ioblame produces fields
+which can be recorded.
+
+All statistics are recorded in histograms, called counters, which have
+eight slots.  Userland can specify the number of counters, IO
+directions to consider, what each counter records, the boundary values
+to decide histogram slots and optional filter for more complex
+filtering conditions.
+
+All interactions including configuration and data acquisition happen
+via files under /sys/kernel/debug/ioblame/.
+
+
+3. Debugfs interface
+
+3-1. Configuration
+
+* devs				- can be changed anytime
+
+  Specifies the devices ioblame is enabled for.  ioblame will only
+  track operations on devices which are explicitly enabled in this
+  file.
+
+  It accepts white space separated list of MAJ:MINs or block device
+  names with optional preceding '!' for negation.  Opening with
+  O_TRUNC clears all existing entries.  For example,
+
+  $ echo sda sdb > devs		# disables all devices and then enable sd[ab]
+  $ echo sdc >> devs		# sd[abc] enabled
+  $ echo !8:0 >> devs		# sd[bc] enabled
+  $ cat devs
+  8:16 sdb
+  8:32 sdc
+
+* max_{role|intent|act}s	- can be changed while disabled
+
+  Specifies the maximum number of each object type.  If the number of
+  certain object type exceeds the limit, IOs will be attributed to
+  special NOMEM object.
+
+* ttl_secs			- can be changed anytime
+
+  Specifies TTL of roles and acts.  Roles are reclaimed after at least
+  TTL has passed after the matching thread has exited or execed and
+  assumed another tid.  Acts are reclaimed after being unused for at
+  least TTL.
+
+  Note that reclaiming is tied to userland reading counters data.  If
+  userland doesn't read counters, reclaiming won't happen.
+
+* nr_counters			- can be changed while disabled
+
+  Specifies the number of counters.  Each act will have the specified
+  number of histograms associated with it.  Individual counters can be
+  configured using files under the counters subdirectory.  Any write
+  to this file clears all counter settings.
+
+* counters/NR			- can be changed anytime
+
+  Specifies each counter.  Its format is
+
+    DIR FIELD B0 B1 B2 B3 B4 B5 B6 B7 B8
+
+  DIR is any combination of letters 'R', 'A', and 'W', each
+  representing reads (sans readaheads), readaheads and writes.
+
+  FIELD is the field to record in histogram and one of the followings.
+
+    offset	: IO offset scaled to 0-65535
+    size	: IO size
+    wait_time	: time spent queued in usecs
+    io_time	: time spent on device in usecs
+    seek_dist	: seek dist from IO completed right before, scaled to 0-65536
+
+  B[0-8] are the boundaries for the histogram.  Histograms have eight
+  slots.  If (FIELD < B[0] || (B[8] != 0 && FIELD >= B[8])), it's not
+  recorded; otherwise, FIELD is counted in the slot with enclosing
+  boundaries.  e.g. If FIELD is >= B2 and < B3, it's recorded in the
+  second slot (slot 1).
+
+  B8 can be zero indicating no upper limit but all other boundaries
+  must be equal to or larger than the boundary before them.
+
+  e.g. To record offsets of reads and read aheads in counter 0,
+
+  $ echo RA offset 0 8192 16384 24576 32768 40960 49152 57344 0 > counters/0
+
+  If higher resolution than 8 slots is necessary, two counters can be
+  used.
+
+  $ echo RA offset 0 4096 8192 12288 16384 20480 24576 28672 32768 > counters/0
+  $ echo RA offset 32768 36864 40960 45056 49152 53248 57344 61440 0 \
+								   > counters/1
+
+  Writing empty string disables the counter.
+
+  $ echo > 1
+  $ cat 1
+  --- disabled
+
+* counters/NR_filter		- can be changed anytime
+
+  Specifies trace event type filter for more complex conditions.  For
+  example, it allows conditions like "if IO is in the latter half of
+  the device, size is smaller than 128k and IO time is equal to or
+  longer than 10ms".
+
+  To record IO time in counter 0 with the above condition,
+
+  $ echo 'offset >= 16384 && size < 131072 && io_time >= 10000' > 0_filter
+  $ echo RAW io_time 10000 25000 50000 100000 500000 1000000 2500000 \
+							5000000 0 > 0
+
+  Any FIELD can be used in filter specification.  For more details
+  about filter format, please read "Event filtering" section in
+  Documentation/trace/events.txt.
+
+  Writing '0' to filter file removes the filter.  Note that writing
+  malformed filter disables the filter and reading it back afterwards
+  returns error message explaining why parsing failed.
+
+
+3-2. Monitoring (read only)
+
+* nr_{roles|intents|acts}
+
+  Returns the number of objects of the type.  The number of roles and
+  acts can decrease after reclaiming but nr_intents only increases
+  while ioblame is enabled.
+
+* stats/idx_nomem
+
+  How many times role, intent or act creation failed because memory
+  allocation failed while extending index to accomodate new object.
+
+* stats/idx_nospc
+
+  How many times role, intent or act creation failed because limit
+  specified by {role|intent|act}_max is reached.
+
+* stats/node_nomem
+
+  How many times role, intent or act creation failed to allocate.
+
+* stats/pgtree_nomem
+
+  How many times page tree, which maps page frame number to dirtying
+  act, failed to expand due to memory allocation failure.
+
+* stats/cnts_nomem
+
+  How many times per-act counter allocation failed.
+
+* stats/iolog_overflow
+
+  How many iolog entries are lost due to overflow.
+
+
+3-3. Data acquisition (read only)
+
+* iolog
+
+  iolog is primarily a debug feature and dumps IOs as they complete.
+
+  $ cat iolog
+  R 4096 @ 74208 pid-5806 (ls) dev=0x800010 ino=0x2 gen=0x0
+    #39 modifier=0x0
+    [ffffffff811a0696] submit_bh+0xe6/0x120
+    [ffffffff811a1f56] ll_rw_block+0xa6/0xb0
+    [ffffffff81239a43] ext4_bread+0x43/0x80
+    [ffffffff8123f4e3] htree_dirblock_to_tree+0x33/0x190
+    [ffffffff8123f79a] ext4_htree_fill_tree+0x15a/0x250
+    [ffffffff8122e26e] ext4_readdir+0x10e/0x5d0
+    [ffffffff811832d0] vfs_readdir+0xa0/0xc0
+    [ffffffff81183450] sys_getdents+0x80/0xe0
+    [ffffffff81a3c8bb] system_call_fastpath+0x16/0x1b
+  W 4096 @ 0 pid-20 (sync_supers) dev=0x800010 ino=0x0 gen=0x0
+    #44 modifier=0x0
+    [ffffffff811a0696] submit_bh+0xe6/0x120
+    [ffffffff811a371d] __sync_dirty_buffer+0x4d/0xd0
+    [ffffffff811a37ae] sync_dirty_buffer+0xe/0x10
+    [ffffffff81250ee8] ext4_commit_super+0x188/0x230
+    [ffffffff81250fae] ext4_write_super+0x1e/0x30
+    [ffffffff811738fa] sync_supers+0xfa/0x100
+    [ffffffff8113d3e1] bdi_sync_supers+0x41/0x60
+    [ffffffff810ad4c6] kthread+0x96/0xa0
+    [ffffffff81a3dcb4] kernel_thread_helper+0x4/0x10
+  W 4096 @ 8512 pid-5813 dev=0x800010 ino=0x74 gen=0x4cc12c59
+    #45 modifier=0x10000002
+    [ffffffff812342cb] ext4_setattr+0x25b/0x4c0
+    [ffffffff8118b9ba] notify_change+0x10a/0x2b0
+    [ffffffff8119ef87] utimes_common+0xd7/0x180
+    [ffffffff8119f0c9] do_utimes+0x99/0xf0
+    [ffffffff8119f21d] sys_utimensat+0x2d/0x90
+    [ffffffff81a3c8bb] system_call_fastpath+0x16/0x1b
+  ...
+
+  The first entry is 4k read at sector 74208 (unscaled) on /dev/sdb
+  issued by ls.  The second is sync_supers writing out dirty super
+  block.  The third is inode writeback from "touch FILE; sync".  Note
+  that the modifier is set (it's indicating WB_REASON_SYNC).
+
+  Here is another example from "cp FILE FILE1" and then waiting.
+
+  W 4096 @ 0 pid-20 (sync_supers) dev=0x800010 ino=0x0 gen=0x0
+    #16 modifier=0x0
+    [ffffffff8139cd94] submit_bio+0x74/0x100
+    [ffffffff811cba3b] submit_bh+0xeb/0x130
+    [ffffffff811cecd2] __sync_dirty_buffer+0x52/0xd0
+    [ffffffff811ced63] sync_dirty_buffer+0x13/0x20
+    [ffffffff81281fa8] ext4_commit_super+0x188/0x230
+    [ffffffff81282073] ext4_write_super+0x23/0x40
+    [ffffffff8119c8d2] sync_supers+0x102/0x110
+    [ffffffff81162c99] bdi_sync_supers+0x49/0x60
+    [ffffffff810bc216] kthread+0xb6/0xc0
+    [ffffffff81ab13b4] kernel_thread_helper+0x4/0x10
+  ...
+  W 4096 @ 8512 pid-668 dev=0x800010 ino=0x73 gen=0x17b5119d
+    #23 modifier=0x10000003
+    [ffffffff811c55b0] __mark_inode_dirty+0x220/0x330
+    [ffffffff811cccfb] generic_write_end+0x6b/0xa0
+    [ffffffff81268b10] ext4_da_write_end+0x150/0x360
+    [ffffffff811444bb] generic_file_buffered_write+0x18b/0x290
+    [ffffffff81146938] __generic_file_aio_write+0x238/0x460
+    [ffffffff81146bd8] generic_file_aio_write+0x78/0xf0
+    [ffffffff8125ef9f] ext4_file_write+0x6f/0x2a0
+    [ffffffff811997f2] do_sync_write+0xe2/0x120
+    [ffffffff8119a428] vfs_write+0xc8/0x180
+    [ffffffff8119a5e1] sys_write+0x51/0x90
+    [ffffffff81aafe2b] system_call_fastpath+0x16/0x1b
+  ...
+  W 524288 @ 3276800 pid-668 dev=0x800010 ino=0x73 gen=0x17b5119d
+    #25 modifier=0x10000003
+    [ffffffff811cc86c] __set_page_dirty+0x4c/0xd0
+    [ffffffff811cc956] mark_buffer_dirty+0x66/0xa0
+    [ffffffff811cca39] __block_commit_write+0xa9/0xe0
+    [ffffffff811ccc42] block_write_end+0x42/0x90
+    [ffffffff811cccc3] generic_write_end+0x33/0xa0
+    [ffffffff81268b10] ext4_da_write_end+0x150/0x360
+    [ffffffff811444bb] generic_file_buffered_write+0x18b/0x290
+    [ffffffff81146938] __generic_file_aio_write+0x238/0x460
+    [ffffffff81146bd8] generic_file_aio_write+0x78/0xf0
+    [ffffffff8125ef9f] ext4_file_write+0x6f/0x2a0
+    [ffffffff811997f2] do_sync_write+0xe2/0x120
+    [ffffffff8119a428] vfs_write+0xc8/0x180
+    [ffffffff8119a5e1] sys_write+0x51/0x90
+    [ffffffff81aafe2b] system_call_fastpath+0x16/0x1b
+  ...
+
+  The first entry is ext4 marking super block dirty.  After a while,
+  periodic writeback kicks in (modifier 0x100000003) and the inode
+  dirtied by cp is written back followed by dirty data pages.
+
+  At this point, iolog is mostly a debug feature.  The output format
+  is quite verbose and it isn't particularly performant.  If
+  necessary, it can be extended to use trace ringbuffer and grow
+  per-cpu binary interface.
+
+* intents
+
+  Dump of intents in Human readable form.
+
+  $ cat intents
+  #0 modifier=0x0
+  #1 modifier=0x0
+  #2 modifier=0x0
+  [ffffffff81189a6a] file_update_time+0xca/0x150
+  [ffffffff81122030] __generic_file_aio_write+0x200/0x460
+  [ffffffff81122301] generic_file_aio_write+0x71/0xe0
+  [ffffffff8122ea94] ext4_file_write+0x64/0x280
+  [ffffffff811b5d24] aio_rw_vect_retry+0x74/0x1d0
+  [ffffffff811b7401] aio_run_iocb+0x61/0x190
+  [ffffffff811b81c8] do_io_submit+0x648/0xaf0
+  [ffffffff811b867b] sys_io_submit+0xb/0x10
+  [ffffffff81a3c8bb] system_call_fastpath+0x16/0x1b
+  #3 modifier=0x0
+  [ffffffff811aaf2e] __blockdev_direct_IO+0x1f1e/0x37c0
+  [ffffffff812353b2] ext4_direct_IO+0x1b2/0x3f0
+  [ffffffff81121d6a] generic_file_direct_write+0xba/0x180
+  [ffffffff8112210b] __generic_file_aio_write+0x2db/0x460
+  [ffffffff81122301] generic_file_aio_write+0x71/0xe0
+  [ffffffff8122ea94] ext4_file_write+0x64/0x280
+  [ffffffff811b5d24] aio_rw_vect_retry+0x74/0x1d0
+  [ffffffff811b7401] aio_run_iocb+0x61/0x190
+  [ffffffff811b81c8] do_io_submit+0x648/0xaf0
+  [ffffffff811b867b] sys_io_submit+0xb/0x10
+  [ffffffff81a3c8bb] system_call_fastpath+0x16/0x1b
+  #4 modifier=0x0
+  [ffffffff811aaf2e] __blockdev_direct_IO+0x1f1e/0x37c0
+  [ffffffff8126da71] ext4_ind_direct_IO+0x121/0x460
+  [ffffffff81235436] ext4_direct_IO+0x236/0x3f0
+  [ffffffff81122db2] generic_file_aio_read+0x6b2/0x740
+  ...
+
+  The # prefixed number is the NR of the intent used to link intent
+  from stastics.  Modifier and stack trace follow.  The first two
+  entries are special - 0 is nomem intent and 1 is lost intent.  The
+  former is used when an intent can't be created because allocation
+  failed or intent_max is reached.  The latter is used when reclaiming
+  resulted in loss of tracking info and the IO can't be reported
+  exactly.
+
+  This file can be seeked by intent NR.  ie. seeking to 3 and reading
+  will return intent #3 and after.  Because intents are never
+  destroyed while ioblame is enabled, this allows userland tool to
+  discover new intents since last reading.  Seeking to the number of
+  currently known intents and reading returns only the newly created
+  intents.
+
+* intents_bin
+
+  Identical to intents but in compact binary format and likely to be
+  much more performant.  Each entry in the file is in the following
+  format as defined in include/linux/ioblame.h.
+
+  #define IOB_INTENTS_BIN_VER	1
+
+  /* intent modifer */
+  #define IOB_MODIFIER_TYPE_SHIFT	28
+  #define IOB_MODIFIER_TYPE_MASK	0xf0000000U
+  #define IOB_MODIFIER_VAL_MASK		(~IOB_MODIFIER_TYPE_MASK)
+
+  /* val contains wb_reason */
+  #define IOB_MODIFIER_WB		(1 << IOB_MODIFIER_TYPE_SHIFT)
+
+  /* record struct for /sys/kernel/debug/ioblame/intents_bin */
+  struct iob_intent_bin_record {
+	uint16_t	len;
+	uint16_t	ver;
+	uint32_t	nr;
+	uint32_t	modifier;
+	uint32_t	__pad;
+	uint64_t	trace[];
+  } __packed;
+
+* counters_pipe
+
+  Dumps counters and triggers reclaim.  Opening and reading this file
+  returns counters of all acts which have been used since the last
+  open.
+
+  Because roles and acts shouldn't be reclaimed before the updated
+  counters are reported, reclaiming is tied to counters_pipe access.
+  Opening counters_pipe prepares for reclaiming and closing executes
+  it.  Act reclaiming works at ttl_secs / 2 granularity.  ioblame
+  tries to stay close to the lifetime timings requested by ttl_secs
+  but note that reclaim happens only on counters_pipe open/close.
+
+  There can only be one user of counters_pipe at any given moment;
+  otherwise, file operations will fail and the output and reclaiming
+  timings are undefined.
+
+  All reported histogram counters are u32 and never reset.  It's the
+  user's responsibility to calculate the delta if necessary.  Note
+  that counters_pipe reports all used acts since last open and
+  counters are not guaranteed to have been updated - ie. there can be
+  spurious acts in the output.
+
+  counters_pipe is seekable by act NR.
+
+  In the following example, two counters are configured - the first
+  one counts read offsets and the second write offsets.  A file is
+  copied using dd w/ direct flags.
+
+  $ cat counters_pipe
+  pid-20 (sync_supers) int=66 dev=0x800010 ino=0x0 gen=0x0
+	  0       0       0       0       0       0       0       0
+	  2       0       0       0       0       0       0       0
+  pid-1708 int=58 dev=0x800010 ino=0x71 gen=0x3e0d99f2
+	 11       0       0       0       0       0       0       0
+	  0       0       0       0       0       0       0       0
+  pid-1708 int=59 dev=0x800010 ino=0x71 gen=0x3e0d99f2
+	 11       0       0       0       0       0       0       0
+	  0       0       0       0       0       0       0       0
+  pid-1708 int=62 dev=0x800010 ino=0x2727 gen=0xf4739822
+	  0       0       0       0       0       0       0       0
+	 10       0       0       0       0       0       0       0
+  pid-1708 int=63 dev=0x800010 ino=0x2727 gen=0xf4739822
+	  0       0       0       0       0       0       0       0
+	 10       0       0       0       0       0       0       0
+  pid-1708 int=31 dev=0x800010 ino=0x2727 gen=0xf4739822
+	  0       0       0       0       0       0       0       0
+	  2       0       0       0       0       0       0       0
+  pid-1708 int=65 dev=0x800010 ino=0x2727 gen=0xf4739822
+	  0       0       0       0       0       0       0       0
+	  1       0       0       0       0       0       0       0
+
+  pid-1708 is the dd which copied the file.  The output is separated
+  by pid-* lines and each section corresponds to single act, which has
+  intent NR and file (dev:ino:gen) associated with it.  One 8-slot
+  histogram is printed per line in ascending order.
+
+  The filesystem is mostly empty and, from the output, both files seem
+  to be located in the first 1/8th of the disk.
+
+  All reads happened through intent 58 and 59.  From intents file,
+  they are,
+
+  #58 modifier=0x0
+  [ffffffff8139d974] submit_bio+0x74/0x100
+  [ffffffff811d5dba] __blockdev_direct_IO+0xc2a/0x3830
+  [ffffffff8129fe51] ext4_ind_direct_IO+0x121/0x470
+  [ffffffff8126678e] ext4_direct_IO+0x23e/0x400
+  [ffffffff81147b05] generic_file_aio_read+0x6d5/0x760
+  [ffffffff81199932] do_sync_read+0xe2/0x120
+  [ffffffff8119a5c5] vfs_read+0xc5/0x180
+  [ffffffff8119a781] sys_read+0x51/0x90
+  [ffffffff81ab1fab] system_call_fastpath+0x16/0x1b
+  #59 modifier=0x0
+  [ffffffff8139d974] submit_bio+0x74/0x100
+  [ffffffff811d7345] __blockdev_direct_IO+0x21b5/0x3830
+  [ffffffff8129fe51] ext4_ind_direct_IO+0x121/0x470
+  [ffffffff8126678e] ext4_direct_IO+0x23e/0x400
+  [ffffffff81147b05] generic_file_aio_read+0x6d5/0x760
+  [ffffffff81199932] do_sync_read+0xe2/0x120
+  [ffffffff8119a5c5] vfs_read+0xc5/0x180
+  [ffffffff8119a781] sys_read+0x51/0x90
+  [ffffffff81ab1fab] system_call_fastpath+0x16/0x1b
+
+  Except for hitting slightly different paths in __blockdev_direct_IO,
+  they both are ext4 direct reads as expected.  Writes seem more
+  diversified and upon examination, #62 and #63 are ext4 direct
+  writes.  #31 and #65 are more interesting.
+
+  #31 modifier=0x0
+  [ffffffff811cd0cc] __set_page_dirty+0x4c/0xd0
+  [ffffffff811cd1b6] mark_buffer_dirty+0x66/0xa0
+  [ffffffff811cd299] __block_commit_write+0xa9/0xe0
+  [ffffffff811cd4a2] block_write_end+0x42/0x90
+  [ffffffff811cd523] generic_write_end+0x33/0xa0
+  [ffffffff81269720] ext4_da_write_end+0x150/0x360
+  [ffffffff81144878] generic_file_buffered_write+0x188/0x2b0
+  [ffffffff81146d18] __generic_file_aio_write+0x238/0x460
+  [ffffffff81146fb8] generic_file_aio_write+0x78/0xf0
+  [ffffffff8125fbaf] ext4_file_write+0x6f/0x2a0
+  [ffffffff81199812] do_sync_write+0xe2/0x120
+  [ffffffff8119a308] vfs_write+0xc8/0x180
+  [ffffffff8119a4c1] sys_write+0x51/0x90
+  [ffffffff81ab1fab] system_call_fastpath+0x16/0x1b
+
+  This is buffered write.  It turns out the file size didn't match the
+  specified blocksize, so dd turns off O_DIRECT for the last IO and
+  issue buffered write for the remainder.
+
+  Note that the actual IO submission is not visible in the stack trace
+  as the IOs are charged to the dirtying act.  Actual IOs are likely
+  to be executed from fsync(2).
+
+  #65 modifier=0x0
+  [ffffffff811c5e10] __mark_inode_dirty+0x220/0x330
+  [ffffffff81267edd] ext4_da_update_reserve_space+0x13d/0x230
+  [ffffffff8129006d] ext4_ext_map_blocks+0x13dd/0x1dc0
+  [ffffffff81268a31] ext4_map_blocks+0x1b1/0x260
+  [ffffffff81269c52] mpage_da_map_and_submit+0xb2/0x480
+  [ffffffff8126a84a] ext4_da_writepages+0x30a/0x6e0
+  [ffffffff8114f584] do_writepages+0x24/0x40
+  [ffffffff811468cb] __filemap_fdatawrite_range+0x5b/0x60
+  [ffffffff8114692a] filemap_write_and_wait_range+0x5a/0x80
+  [ffffffff8125ff64] ext4_sync_file+0x74/0x440
+  [ffffffff811ca31b] vfs_fsync_range+0x2b/0x40
+  [ffffffff811ca34c] vfs_fsync+0x1c/0x20
+  [ffffffff811ca58a] do_fsync+0x3a/0x60
+  [ffffffff811ca5e0] sys_fsync+0x10/0x20
+  [ffffffff81ab1fab] system_call_fastpath+0x16/0x1b
+
+  And this is dd fsync(2)ing and marking inode for writeback.  As with
+  data writeback, IO submission is not visible in the stack trace.
+
+* counters_pipe_bin
+
+  Identical to counters_pipe but in compact binary format and likely
+  to be much more performant.  Each entry in the file is in the
+  following format as defined in include/linux/ioblame.h.
+
+  #define IOBC_PIPE_BIN_VER	1
+
+  /* record struct for /sys/kernel/debug/ioblame/counters_pipe_bin */
+  struct iobc_pipe_bin_record {
+	  uint16_t	len;
+	  uint16_t	ver;
+	  int32_t	id;		/* >0 pid or negated user id */
+	  uint32_t	intent_nr;	/* associated intent */
+	  uint32_t	dev;
+	  uint64_t	ino;
+	  uint32_t	gen;
+	  uint32_t	__pad;
+	  uint32_t	cnts[];		/* [type][slot] */
+  } __packed;
+
+  Note that counters_pipe and counters_pipe_bin can't be used
+  parallelly.  Only one opener is allowed across the two files at any
+  given moment.
+
+
+4. Notes
+
+* By the time ioblame reports IOs or counters, the task which gets
+  charged might have already exited and this is why ioblame prints
+  task command in some reports but not in others.  Userland tool is
+  advised to use combination of live task listing and process
+  accounting to match pid's to commands.
+
+* dev:ino:gen can be mapped to filename without scanning the whole
+  filesystem by constructing FS-specific filehandle, opening it with
+  open_by_handle_at(2) and then readlink(2)ing /proc/self/FD.  This
+  will return full path as long as the dentry is in cache, which is
+  likely if data acquisition and mapping don't happen too long after
+  IOs.
+
+* Mechanism to specify userland role ID is not implemented yet.
+
+
+5. Overheads
+
+On x86_64, role is 104 bytes, intent 32 + 8 * stack_depth and act 72
+bytes.  Intents are allocated using kzalloc() and there shouldn't be
+too many of them.  Both roles and acts have their own kmem_cache and
+can be monitored via /proc/slabinfo.
+
+Each counter occupy 32 * nr_counters and is aligned to cacheline.
+Counters are allocated only as necessary.  iob_counters kmem_cache is
+dynamically created on enable.
+
+The size of page frame number -> dirtier mapping table is proportional
+to the amount of available physical memory.  If max_acts <= 65536,
+2bytes are used per PAGE_SIZE.  With 4k page, at most ~0.049% can be
+used.  If max_acts > 65536, 4bytes are used doubling the percentage to
+~0.098%.  The table also grows dynamically.
+
+There are also indexing data structures used - hash tables, id[ra]s
+and a radix tree.  There are three hash tables, each sized according
+to max_{roles|intents|acts}.  The maximum memory usage by hash tables
+is sizeof(void *) * (max_roles + max_intents + max_acts).  Memory used
+by other indexing structures should be negligible.
+
+Preliminary tests w/ fio ssd-test on loopback device on tmpfs, which
+is purely CPU cycle bound, shows ~20% throughput hit.
+
+*** TODO: add performance testing results and explain involved CPU
+    overheads.
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 4053cbd..4f42174 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -8,6 +8,7 @@
 #ifdef CONFIG_BLOCK
 
 #include <linux/types.h>
+#include <linux/ioblame.h>
 
 struct bio_set;
 struct bio;
@@ -66,10 +67,12 @@ struct bio {
 	bio_end_io_t		*bi_end_io;
 
 	void			*bi_private;
-#if defined(CONFIG_BLK_DEV_INTEGRITY)
+#ifdef CONFIG_BLK_DEV_INTEGRITY
 	struct bio_integrity_payload *bi_integrity;  /* data integrity */
 #endif
-
+#if defined(CONFIG_IO_BLAME) || defined(CONFIG_IO_BLAME_MODULE)
+	struct iob_io_info	bi_iob_info;
+#endif
 	bio_destructor_t	*bi_destructor;	/* destructor */
 
 	/*
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e0bc4ff..950b2b3 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -835,6 +835,9 @@ struct inode {
 	atomic_t		i_readcount; /* struct files open RO */
 #endif
 	void			*i_private; /* fs or device private pointer */
+#if defined(CONFIG_IO_BLAME) || defined(CONFIG_IO_BLAME_MODULE)
+	union iob_id		i_iob_act;
+#endif
 };
 
 static inline int inode_unhashed(struct inode *inode)
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index aefa6ba..7d02c88 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -190,6 +190,10 @@ struct gendisk {
 #ifdef  CONFIG_BLK_DEV_INTEGRITY
 	struct blk_integrity *integrity;
 #endif
+#if defined(CONFIG_IO_BLAME) || defined(CONFIG_IO_BLAME_MODULE)
+	bool iob_enabled;
+	u16 iob_scaled_last_sect;
+#endif
 	int node_id;
 };
 
diff --git a/include/linux/ioblame.h b/include/linux/ioblame.h
new file mode 100644
index 0000000..689b722
--- /dev/null
+++ b/include/linux/ioblame.h
@@ -0,0 +1,95 @@
+/*
+ * include/linux/ioblame.h - statistical IO analyzer with origin tracking
+ *
+ * Copyright (C) 2011 Google, Inc.
+ * Copyright (C) 2011 Tejun Heo <tj@kernel.org>
+ */
+#ifndef _IOBLAME_H
+#define _IOBLAME_H
+
+#ifdef __KERNEL__
+
+#include <linux/rcupdate.h>
+
+struct page;
+struct inode;
+struct buffer_head;
+
+#if defined(CONFIG_IO_BLAME) || defined(CONFIG_IO_BLAME_MODULE)
+
+/*
+ * Each iob_node is identified by 64bit id, which packs three fields in it
+ * - @type, @nr and @gen.  @nr is ida allocated index in @type.  It is
+ * always allocated from the lowest available slot, which allows efficient
+ * use of pgtree and idr; however, this means @nr is likely to be recycled.
+ * @gen is used to disambiguate recycled @nr's.
+ */
+#define IOB_NR_BITS			31
+#define IOB_GEN_BITS			31
+#define IOB_TYPE_BITS			2
+
+union iob_id {
+	u64				v;
+	struct {
+		u64			nr:IOB_NR_BITS;
+		u64			gen:IOB_GEN_BITS;
+		u64			type:IOB_TYPE_BITS;
+	} f;
+};
+
+struct iob_io_info {
+	unsigned long			rw;
+	sector_t			sector;
+
+	unsigned long			queued_at;
+	unsigned long			issued_at;
+
+	union iob_id			act;
+	unsigned int			size;
+};
+
+#endif	/* CONFIG_IO_BLAME[_MODULE] */
+#endif	/* __KERNEL__ */
+
+enum iob_special_nr {
+	IOB_NOMEM_NR,
+	IOB_LOST_NR,
+	IOB_BASE_NR,
+};
+
+#define IOB_INTENTS_BIN_VER	1
+
+/* intent modifer */
+#define IOB_MODIFIER_TYPE_SHIFT	28
+#define IOB_MODIFIER_TYPE_MASK	0xf0000000U
+#define IOB_MODIFIER_VAL_MASK	(~IOB_MODIFIER_TYPE_MASK)
+
+/* val contains wb_reason */
+#define IOB_MODIFIER_WB		(1 << IOB_MODIFIER_TYPE_SHIFT)
+
+/* record struct for /sys/kernel/debug/ioblame/intents_bin */
+struct iob_intent_bin_record {
+	uint16_t	len;
+	uint16_t	ver;
+	uint32_t	nr;
+	uint32_t	modifier;
+	uint32_t	__pad;
+	uint64_t	trace[];
+} __packed;
+
+#define IOBC_PIPE_BIN_VER	1
+
+/* record struct for /sys/kernel/debug/ioblame/counters_pipe_bin */
+struct iobc_pipe_bin_record {
+	uint16_t	len;
+	uint16_t	ver;
+	int32_t		id;		/* >0 pid or negated user id */
+	uint32_t	intent_nr;	/* associated intent */
+	uint32_t	dev;
+	uint64_t	ino;
+	uint32_t	gen;
+	uint32_t	__pad;
+	uint32_t	cnts[];		/* [type][slot] */
+} __packed;
+
+#endif	/* _IOBLAME_H */
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index cd31345..551d8fb 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -368,6 +368,17 @@ config BLK_DEV_IO_TRACE
 
 	  If unsure, say N.
 
+config IO_BLAME
+	tristate "Enable io-blame tracer"
+	depends on SYSFS
+	depends on BLOCK
+	select TRACEPOINTS
+	select STACKTRACE
+	help
+	  Say Y here if you want to enable end-to-end IO tracer.
+
+	  If unsure, say N.
+
 config KPROBE_EVENT
 	depends on KPROBES
 	depends on HAVE_REGS_AND_STACK_ACCESS_API
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 5f39a07..408cd1a 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -46,6 +46,7 @@ obj-$(CONFIG_BLK_DEV_IO_TRACE) += blktrace.o
 ifeq ($(CONFIG_BLOCK),y)
 obj-$(CONFIG_EVENT_TRACING) += blktrace.o
 endif
+obj-$(CONFIG_IO_BLAME) += ioblame.o
 obj-$(CONFIG_EVENT_TRACING) += trace_events.o
 obj-$(CONFIG_EVENT_TRACING) += trace_export.o
 obj-$(CONFIG_FTRACE_SYSCALLS) += trace_syscalls.o
diff --git a/kernel/trace/ioblame.c b/kernel/trace/ioblame.c
new file mode 100644
index 0000000..9083675
--- /dev/null
+++ b/kernel/trace/ioblame.c
@@ -0,0 +1,3479 @@
+/*
+ * kernel/trace/ioblame.c - statistical IO analyzer with origin tracking
+ *
+ * Copyright (C) 2011 Google, Inc.
+ * Copyright (C) 2011 Tejun Heo <tj@kernel.org>
+ */
+#include <linux/module.h>
+#include <linux/list.h>
+#include <linux/idr.h>
+#include <linux/bitmap.h>
+#include <linux/radix-tree.h>
+#include <linux/rculist.h>
+#include <linux/spinlock.h>
+#include <linux/mutex.h>
+#include <linux/stacktrace.h>
+#include <linux/gfp.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/log2.h>
+#include <linux/jhash.h>
+#include <linux/genhd.h>
+#include <linux/string.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <linux/mm_types.h>
+#include <linux/fs.h>
+#include <linux/buffer_head.h>
+#include <linux/blkdev.h>
+#include <linux/writeback.h>
+#include <linux/log2.h>
+#include <asm/div64.h>
+
+#include <trace/events/sched.h>
+#include <trace/events/vfs.h>
+#include <trace/events/writeback.h>
+#include <trace/events/block.h>
+
+#include "trace.h"
+
+#include <linux/ioblame.h>
+
+#define IOB_ROLE_NAMELEN	32
+#define IOB_STACK_MAX_DEPTH	32
+
+#define IOB_DFL_MAX_ROLES	(1 << 16)
+#define IOB_DFL_MAX_INTENTS	(1 << 10)
+#define IOB_DFL_MAX_ACTS	(1 << 16)
+#define IOB_DFL_TTL_SECS	120
+#define IOB_IOLOG_CNT		512
+
+#define IOB_LAST_INO_DURATION	(5 * HZ)	/* last_ino is valid for 5s */
+
+/*
+ * Each type represents different type of entities tracked by ioblame and
+ * has its own iob_idx.
+ *
+ * role		: "who" - either a task or custom id from userland.
+ *
+ * intent	: The who's intention - backtrace + modifier.
+ *
+ * act		: Product of role, intent and the target inode.  "who"
+ *		  acts on a target inode with certain backtrace.
+ */
+enum iob_type {
+	IOB_INVALID,
+	IOB_ROLE,
+	IOB_INTENT,
+	IOB_ACT,
+
+	IOB_NR_TYPES,
+};
+
+#define IOB_PACK_ID(_type, _nr, _gen)	\
+	(union iob_id){ .f = { .type = (_type), .nr = (_nr), .gen = (_gen) }}
+
+/* stats */
+struct iob_stats {
+	u64 idx_nomem;
+	u64 idx_nospc;
+	u64 node_nomem;
+	u64 pgtree_nomem;
+	u64 cnts_nomem;
+	u64 iolog_overflow;
+};
+
+/* iob_node is what iob_idx indexes and embedded in every iob_type */
+struct iob_node {
+	struct hlist_node	hash_node;
+	union iob_id		id;
+};
+
+/* describes properties and operations of an iob_type for iob_idx */
+struct iob_idx_type {
+	enum iob_type		type;
+
+	/* calculate hash value from key */
+	unsigned long		(*hash)(void *key);
+	/* return %true if @node matches @key */
+	bool			(*match)(struct iob_node *node, void *key);
+	/* create a new node which matches @key w/ alloc mask @gfp_mask */
+	struct iob_node		*(*create)(void *key, gfp_t gfp_mask);
+	/* destroy @node */
+	void			(*destroy)(struct iob_node *node);
+
+	/* keys for fallback nodes */
+	void			*nomem_key;
+	void			*lost_key;
+};
+
+/*
+ * iob_idx indexes iob_nodes.  iob_nodes can either be found via hash table
+ * or by id.f.nr.  Hash calculation and matching are determined by
+ * iob_idx_type.  If a node is missing during hash lookup, new one is
+ * automatically created.
+ */
+struct iob_idx {
+	const struct iob_idx_type *type;
+
+	/* hash */
+	struct hlist_head	*hash;
+	unsigned int		hash_mask;
+
+	/* id index */
+	struct ida		ida;		/* used for allocation */
+	struct idr		idr;		/* record node or gen */
+
+	/* fallback nodes */
+	struct iob_node		*nomem_node;
+	struct iob_node		*lost_node;
+
+	/* stats */
+	unsigned int		nr_nodes;
+	unsigned int		max_nodes;
+};
+
+/*
+ * Functions to encode and decode pointer and generation for iob_idx->idr.
+ *
+ * id.f.gen is used to disambiguate recycled id.f.nr.  When there's no
+ * active node, iob_idx->idr slot carries the last generation number.
+ */
+static void *iob_idr_encode_node(struct iob_node *node)
+{
+	BUG_ON((unsigned long)node & 1);
+	return node;
+}
+
+static void *iob_idr_encode_gen(u32 gen)
+{
+	unsigned long v = (unsigned long)gen;
+	return (void *)((v << 1) | 1);
+}
+
+static struct iob_node *iob_idr_node(void *p)
+{
+	unsigned long v = (unsigned long)p;
+	return (v & 1) ? NULL : (void *)v;
+}
+
+static u32 iob_idr_gen(void *p)
+{
+	unsigned long v = (unsigned long)p;
+	return (v & 1) ? v >> 1 : 0;
+}
+
+/* IOB_ROLE */
+struct iob_role {
+	struct iob_node		node;
+
+	/*
+	 * For task roles, because a task can change its pid during exec
+	 * and we want exact match for removal on task exit, we use task
+	 * pointer as key and ->id contains pid.  For userland specified
+	 * roles, ->task is %NULL and ->id is negative and used as key.
+	 */
+	int			pid;	/* pid for troles, -id for uroles */
+	struct task_struct	*task;	/* %NULL for uroles */
+	union iob_id		user_role;
+
+	/* modifier currently in effect */
+	u32			modifier;
+
+	/* last file this trole has operated on */
+	struct {
+		dev_t			dev;
+		u32			gen;
+		ino_t			ino;
+	} last_ino;
+	unsigned long		last_ino_jiffies;
+
+	/* act for inode dirtying/writing in progress */
+	union iob_id		inode_act;
+
+	/* for reclaiming */
+	struct list_head	free_list;
+};
+
+/* IOB_INTENT - uses separate key struct to use struct stack_trace directly */
+struct iob_intent_key {
+	u32			modifier;
+	int			depth;
+	unsigned long		*trace;
+};
+
+struct iob_intent {
+	struct iob_node		node;
+
+	u32			modifier;
+	int			depth;
+	unsigned long		trace[];
+};
+
+/* IOB_ACT */
+struct iob_act {
+	struct iob_node		node;
+
+	u32			*cnts;	/* [slot][type] */
+	struct iob_act		*free_next;
+
+	/* key fields follow - paddings, if any, should be zero filled */
+	union iob_id		role;	/* must be the first field of keys */
+	union iob_id		intent;
+	dev_t			dev;
+	u32			gen;
+	ino_t			ino;
+};
+
+#define IOB_ACT_KEY_OFFSET	offsetof(struct iob_act, role)
+
+static DEFINE_MUTEX(iob_mutex);		/* enable/disable and userland access */
+static DEFINE_SPINLOCK(iob_lock);	/* write access to all int structures */
+
+static bool iob_enabled __read_mostly = false;
+
+/* temp buffer used for parsing/printing, user must be holding iob_mutex */
+static char __iob_page_buf[PAGE_SIZE];
+#define iob_page_buf	({ lockdep_assert_held(&iob_mutex); __iob_page_buf; })
+
+/* userland tunable knobs */
+static unsigned int iob_max_roles __read_mostly = IOB_DFL_MAX_ROLES;
+static unsigned int iob_max_intents __read_mostly = IOB_DFL_MAX_INTENTS;
+static unsigned int iob_max_acts __read_mostly = IOB_DFL_MAX_ACTS;
+static unsigned int iob_ttl_secs __read_mostly = IOB_DFL_TTL_SECS;
+static bool iob_ignore_ino __read_mostly;
+
+/* pgtree params, determined by iob_max_acts */
+static unsigned long iob_pgtree_shift __read_mostly;
+static unsigned long iob_pgtree_pfn_shift __read_mostly;
+static unsigned long iob_pgtree_pfn_mask __read_mostly;
+
+/* role and act caches, intent is variable size and allocated using kzalloc */
+static struct kmem_cache *iob_role_cache;
+static struct kmem_cache *iob_act_cache;
+
+/* iob_idx for each iob_type */
+static struct iob_idx *iob_role_idx __read_mostly;
+static struct iob_idx *iob_intent_idx __read_mostly;
+static struct iob_idx *iob_act_idx __read_mostly;
+
+/* for iob_role reclaiming */
+static unsigned long iob_role_reclaim_tstmp;
+
+static struct list_head iob_role_to_free_heads[2] = {
+	LIST_HEAD_INIT(iob_role_to_free_heads[0]),
+	LIST_HEAD_INIT(iob_role_to_free_heads[1]),
+};
+static struct list_head *iob_role_to_free_front = &iob_role_to_free_heads[0];
+static struct list_head *iob_role_to_free_back = &iob_role_to_free_heads[1];
+
+/* for iob_act reclaiming */
+static unsigned long iob_act_reclaim_tstmp;
+static unsigned long *iob_act_used_bitmaps[4];
+
+struct iob_act_used {
+	unsigned long	*cur;
+	unsigned long	*staging;
+	unsigned long	*front;
+	unsigned long	*back;
+} iob_act_used;
+
+/* pgtree - maps pfn to act id.f.nr */
+static RADIX_TREE(iob_pgtree, GFP_NOWAIT);
+
+/* stats and /sys/kernel/debug/ioblame */
+static struct iob_stats iob_stats;
+static struct dentry *iob_dir;
+
+/*
+ * Counters - counts io events in histograms.  What events are counted how
+ * is userland configurable.
+ */
+
+/* number of histogram slots, there are places which assume it to be 8 */
+#define IOBC_NR_SLOTS			8
+
+/* for data direction predicate */
+enum iobc_dir {
+	IOBC_READ			= 1 << 0, /* reads (sans read aheads) */
+	IOBC_RAHEAD			= 1 << 1, /* reads */
+	IOBC_WRITE			= 1 << 2, /* writes */
+};
+
+/* fields which can be counted, can also be used in filters */
+enum iobc_field {
+	IOBC_OFFSET,			/* request offset (scaled to 0-65535) */
+	IOBC_SIZE,			/* size of request */
+	IOBC_WAIT_TIME,			/* wait time in usecs */
+	IOBC_IO_TIME,			/* service time in usecs */
+	IOBC_SEEK_DIST,			/* scaled seek distance */
+
+	IOBC_NR_FIELDS,
+};
+
+/* and their userland visible names for counter and filter specification */
+static char *iobc_field_strs[] = {
+	[IOBC_OFFSET]			= "offset",
+	[IOBC_SIZE]			= "size",
+	[IOBC_WAIT_TIME]		= "wait_time",
+	[IOBC_IO_TIME]			= "io_time",
+	[IOBC_SEEK_DIST]		= "seek_dist",
+};
+
+/* max len of field name, 32 gotta be enough */
+#define IOBC_FIELD_MAX_LEN		32
+
+/* struct to RCU free event filter */
+struct iobc_filter_rcu {
+	struct event_filter		*filter;
+	struct rcu_head			rcu_head;
+};
+
+/*
+ * Describes a counter type.  There are @iobc_nr_types types and each
+ * iob_act has matching set of histograms.
+ */
+struct iobc_type {
+	u16				dir;	/* data direction predicate */
+	u16				field;	/* field to count */
+
+	/*
+	 * Histogram boundaries.  bounds[N] <= bounds[N+1] should hold
+	 * except for the last entry.  The first and last entries are
+	 * cutoff conditions and the last can be zero denoting no limit.
+	 * Internal entries are used to decide the histogram slot to use.
+	 */
+	u32				bounds[IOBC_NR_SLOTS + 1];
+
+	/* optional filter, all fields can be used in event filter format */
+	struct event_filter __rcu	*filter;
+	struct iobc_filter_rcu		*filter_rcu;
+};
+
+/* constructed during module init and fed to trace_event_filter_create() */
+static LIST_HEAD(iobc_event_field_list);
+static struct ftrace_event_field iobc_event_fields[IOBC_NR_FIELDS];
+
+/* configured counters types and kmem cache */
+static int iobc_nr_types;
+static struct iobc_type *iobc_types;
+static struct kmem_cache *iobc_cnts_cache;
+
+/* iobc_pipe in use? */
+static bool iobc_pipe_opened;
+
+/* ioblame/counters directory */
+static struct dentry *iobc_dir;
+
+static void iob_count(struct iob_io_info *io, struct gendisk *disk);
+
+/* ioblame/iolog for slow verbose per-io output */
+static DEFINE_SPINLOCK(iob_iolog_lock);
+static DECLARE_WAIT_QUEUE_HEAD(iob_iolog_wait);
+static struct iob_io_info *iob_iolog;
+static char *iob_iolog_buf;
+static int iob_iolog_head, iob_iolog_tail;
+
+static void iob_iolog_fill(struct iob_io_info *io);
+
+
+/*
+ * IOB_IDX
+ *
+ * This is the main indexing facility used to maintain and access all
+ * iob_type objects.  iob_idx operates on iob_node which each iob_type
+ * object embeds.
+ *
+ * Each iob_idx is associated with iob_idx_type on creation, which
+ * describes which type it is, methods used during hash lookup and two keys
+ * for fallback node creation.
+ *
+ * Objects can be accessed either by hash table or id.  Hash table lookup
+ * uses iob_idx_type->hash() and ->match() methods for lookup and
+ * ->create() and ->destroy() to create new object if missing and
+ * requested.  Note that the hash key is opaque to iob_idx.  Key handling
+ * is defined completely by iob_idx_type methods.
+ *
+ * When a new object is created, iob_idx automatically assigns an id, which
+ * is combination of type enum, object number (nr), and generation number.
+ * Object number is ida allocated and always packed towards 0.  Generation
+ * number starts at 1 and gets incremented each time the nr is recycled.
+ *
+ * Access by id is either by whole id or nr part of it.  Objects are not
+ * created through id lookups.
+ *
+ * Read accesses are protected by sched_rcu.  Using sched_rcu allows
+ * avoiding extra rcu locking operations in tracepoint probes.  Write
+ * accesses are expected to be infrequent and synchronized with single
+ * spinlock - iob_lock.
+ */
+
+static int iob_idx_install_node(struct iob_node *node, struct iob_idx *idx,
+				gfp_t gfp_mask)
+{
+	const struct iob_idx_type *type = idx->type;
+	int nr = -1, idr_nr = -1, ret;
+	void *p;
+
+	INIT_HLIST_NODE(&node->hash_node);
+
+	/* allocate nr and make sure it's under the limit */
+	do {
+		if (unlikely(!ida_pre_get(&idx->ida, gfp_mask)))
+			goto enomem;
+		ret = ida_get_new(&idx->ida, &nr);
+	} while (unlikely(ret == -EAGAIN));
+
+	if (unlikely(ret < 0 || nr >= idx->max_nodes))
+		goto enospc;
+
+	/* if @nr was used before, idr would have last_gen recorded, look up */
+	p = idr_find(&idx->idr, nr);
+	if (p) {
+		WARN_ON_ONCE(iob_idr_node(p));
+		/* set id with gen before replacing the idr entry */
+		node->id = IOB_PACK_ID(type->type, nr, iob_idr_gen(p) + 1);
+		idr_replace(&idx->idr, node, nr);
+		return 0;
+	}
+
+	/* create a new idr entry, it must match ida allocation */
+	node->id = IOB_PACK_ID(type->type, nr, 1);
+	do {
+		if (unlikely(!idr_pre_get(&idx->idr, gfp_mask)))
+			goto enomem;
+		ret = idr_get_new_above(&idx->idr, iob_idr_encode_node(node),
+					nr, &idr_nr);
+	} while (unlikely(ret == -EAGAIN));
+
+	if (unlikely(ret < 0) || WARN_ON_ONCE(idr_nr != nr))
+		goto enospc;
+
+	return 0;
+
+enomem:
+	iob_stats.idx_nomem++;
+	ret = -ENOMEM;
+	goto fail;
+enospc:
+	iob_stats.idx_nospc++;
+	ret = -ENOSPC;
+fail:
+	if (idr_nr >= 0)
+		idr_remove(&idx->idr, idr_nr);
+	if (nr >= 0)
+		ida_remove(&idx->ida, nr);
+	return ret;
+}
+
+/**
+ * iob_idx_destroy - destroy iob_idx
+ * @idx: iob_idx to destroy
+ *
+ * Free all nodes indexed by @idx and @idx itself.  The caller is
+ * responsible for ensuring nobody is accessing @idx.
+ */
+static void iob_idx_destroy(struct iob_idx *idx)
+{
+	const struct iob_idx_type *type = idx->type;
+	void *ptr;
+	int pos = 0;
+
+	while ((ptr = idr_get_next(&idx->idr, &pos))) {
+		struct iob_node *node = iob_idr_node(ptr);
+		if (node)
+			type->destroy(node);
+		pos++;
+	}
+
+	idr_remove_all(&idx->idr);
+	idr_destroy(&idx->idr);
+	ida_destroy(&idx->ida);
+
+	vfree(idx->hash);
+	kfree(idx);
+}
+
+/**
+ * iob_idx_create - create a new iob_idx
+ * @type: type of new iob_idx
+ * @max_nodes: maximum number of nodes allowed
+ *
+ * Create a new @type iob_idx.  Newly created iob_idx has two fallback
+ * nodes pre-allocated - one for nomem and the other for lost nodes, each
+ * occupying IOB_NOMEM_NR and IOB_LOST_NR slot respectively.
+ *
+ * Returns pointer to the new iob_idx on success, %NULL on failure.
+ */
+static struct iob_idx *iob_idx_create(const struct iob_idx_type *type,
+				      unsigned int max_nodes)
+{
+	unsigned int hash_sz = rounddown_pow_of_two(max_nodes);
+	struct iob_idx *idx;
+	struct iob_node *node;
+
+	if (max_nodes < 2)
+		return NULL;
+
+	/* alloc and init */
+	idx = kzalloc(sizeof(*idx), GFP_KERNEL);
+	if (!idx)
+		return NULL;
+
+	ida_init(&idx->ida);
+	idr_init(&idx->idr);
+	idx->type = type;
+	idx->max_nodes = max_nodes;
+	idx->hash_mask = hash_sz - 1;
+
+	idx->hash = vzalloc(hash_sz * sizeof(idx->hash[0]));
+	if (!idx->hash)
+		goto fail;
+
+	/* create and install nomem_node */
+	node = type->create(type->nomem_key, GFP_KERNEL);
+	if (!node)
+		goto fail;
+	if (iob_idx_install_node(node, idx, GFP_KERNEL) < 0) {
+		type->destroy(node);
+		goto fail;
+	}
+	idx->nomem_node = node;
+	idx->nr_nodes++;
+
+	/* create and install lost_node */
+	node = type->create(type->lost_key, GFP_KERNEL);
+	if (!node)
+		goto fail;
+	if (iob_idx_install_node(node, idx, GFP_KERNEL) < 0) {
+		type->destroy(node);
+		goto fail;
+	}
+	idx->lost_node = node;
+	idx->nr_nodes++;
+
+	/* verify both fallback nodes have the correct id.f.nr */
+	if (idx->nomem_node->id.f.nr != IOB_NOMEM_NR ||
+	    idx->lost_node->id.f.nr != IOB_LOST_NR)
+		goto fail;
+
+	return idx;
+fail:
+	iob_idx_destroy(idx);
+	return NULL;
+}
+
+/**
+ * iob_node_by_nr_raw - lookup node by nr
+ * @nr: nr to lookup
+ * @idx: iob_idx to lookup from
+ *
+ * Lookup node occupying slot @nr.  If such node doesn't exist, %NULL is
+ * returned.
+ */
+static struct iob_node *iob_node_by_nr_raw(int nr, struct iob_idx *idx)
+{
+	WARN_ON_ONCE(!rcu_read_lock_sched_held());
+	return iob_idr_node(idr_find(&idx->idr, nr));
+}
+
+/**
+ * iob_node_by_id_raw - lookup node by id
+ * @id: id to lookup
+ * @idx: iob_idx to lookup from
+ *
+ * Lookup node with @id.  @id's type should match @idx's type and all three
+ * id fields should match for successful lookup - type, id and generation.
+ * Returns %NULL on failure.
+ */
+static struct iob_node *iob_node_by_id_raw(union iob_id id, struct iob_idx *idx)
+{
+	struct iob_node *node;
+
+	WARN_ON_ONCE(id.f.type != idx->type->type);
+
+	node = iob_node_by_nr_raw(id.f.nr, idx);
+	if (likely(node && node->id.v == id.v))
+		return node;
+	return NULL;
+}
+
+static struct iob_node *iob_hash_head_lookup(void *key,
+					     struct hlist_head *hash_head,
+					     const struct iob_idx_type *type)
+{
+	struct hlist_node *pos;
+	struct iob_node *node;
+
+	hlist_for_each_entry_rcu(node, pos, hash_head, hash_node)
+		if (type->match(node, key))
+			return node;
+	return NULL;
+}
+
+/**
+ * iob_get_node_raw - lookup node from hash table and create if missing
+ * @key: key to lookup hash table with
+ * @idx: iob_idx to lookup from
+ * @create: whether to create a new node if lookup fails
+ *
+ * Look up node which matches @key in @idx.  If no such node exists and
+ * @create is %true, create a new one.  A newly created node will have
+ * unique id assigned to it as long as generation number doesn't overflow.
+ *
+ * This function should be called under rcu sched read lock and returns
+ * %NULL on failure.
+ */
+static struct iob_node *iob_get_node_raw(void *key, struct iob_idx *idx,
+					 bool create)
+{
+	const struct iob_idx_type *type = idx->type;
+	struct iob_node *node, *new_node;
+	struct hlist_head *hash_head;
+	unsigned long hash, flags;
+
+	WARN_ON_ONCE(!rcu_read_lock_sched_held());
+
+	/* lookup hash */
+	hash = type->hash(key);
+	hash_head = &idx->hash[hash & idx->hash_mask];
+
+	node = iob_hash_head_lookup(key, hash_head, type);
+	if (node || !create)
+		return node;
+
+	/* non-existent && @create, create new one */
+	new_node = type->create(key, GFP_NOWAIT);
+	if (!new_node) {
+		iob_stats.node_nomem++;
+		return NULL;
+	}
+
+	spin_lock_irqsave(&iob_lock, flags);
+
+	/* someone might have inserted it inbetween, lookup again */
+	node = iob_hash_head_lookup(key, hash_head, type);
+	if (node)
+		goto out_unlock;
+
+	/* install the node and add to the hash table */
+	if (iob_idx_install_node(new_node, idx, GFP_NOWAIT))
+		goto out_unlock;
+
+	hlist_add_head_rcu(&new_node->hash_node, hash_head);
+	idx->nr_nodes++;
+
+	node = new_node;
+	new_node = NULL;
+out_unlock:
+	spin_unlock_irqrestore(&iob_lock, flags);
+
+	if (unlikely(new_node))
+		type->destroy(new_node);
+	return node;
+}
+
+/**
+ * iob_node_by_nr - lookup node by nr with fallback
+ * @nr: nr to lookup
+ * @idx: iob_idx to lookup from
+ *
+ * Same as iob_node_by_nr_raw() but returns @idx->lost_node instead of
+ * %NULL if lookup fails.  The lost_node is returned as nr/id lookup
+ * failure indicates the target node has already been reclaimed.
+ */
+static struct iob_node *iob_node_by_nr(int nr, struct iob_idx *idx)
+{
+	return iob_node_by_nr_raw(nr, idx) ?: idx->lost_node;
+}
+
+/**
+ * iob_node_by_nr - lookup node by id with fallback
+ * @id: id to lookup
+ * @idx: iob_idx to lookup from
+ *
+ * Same as iob_node_by_id_raw() but returns @idx->lost_node instead of
+ * %NULL if lookup fails.  The lost_node is returned as nr/id lookup
+ * failure indicates the target node has already been reclaimed.
+ */
+static struct iob_node *iob_node_by_id(union iob_id id, struct iob_idx *idx)
+{
+	return iob_node_by_id_raw(id, idx) ?: idx->lost_node;
+}
+
+/**
+ * iob_get_node - lookup node from hash table and create if missing w/ fallback
+ * @key: key to lookup hash table with
+ * @idx: iob_idx to lookup from
+ * @create: whether to create a new node if lookup fails
+ *
+ * Same as iob_get_node_raw(@key, @idx, %true) but returns @idx->nomem_node
+ * instead of %NULL on failure as the only reason is alloc failure.
+ */
+static struct iob_node *iob_get_node(void *key, struct iob_idx *idx)
+{
+	return iob_get_node_raw(key, idx, true) ?: idx->nomem_node;
+}
+
+/**
+ * iob_unhash_node - unhash an iob_node
+ * @node: node to unhash
+ * @idx: iob_idx @node is hashed on
+ *
+ * Make @node invisible from hash lookup.  It will still be visible from
+ * id/nr lookup.
+ *
+ * Must be called holding iob_lock and returns %true if unhashed
+ * successfully, %false if someone else already unhashed it.
+ */
+static bool iob_unhash_node(struct iob_node *node, struct iob_idx *idx)
+{
+	lockdep_assert_held(&iob_lock);
+
+	if (hlist_unhashed(&node->hash_node))
+		return false;
+	hlist_del_init_rcu(&node->hash_node);
+	return true;
+}
+
+/**
+ * iob_remove_node - remove an iob_node
+ * @node: node to remove
+ * @idx: iob_idx @node is on
+ *
+ * Remove @node from @idx.  The caller is responsible for calling
+ * iob_unhash_node() before.  Note that removed nodes should be freed only
+ * after RCU grace period has passed.
+ *
+ * Must be called holding iob_lock.
+ */
+static void iob_remove_node(struct iob_node *node, struct iob_idx *idx)
+{
+	lockdep_assert_held(&iob_lock);
+
+	/* don't remove idr slot, record current generation there */
+	idr_replace(&idx->idr, iob_idr_encode_gen(node->id.f.gen),
+		    node->id.f.nr);
+	ida_remove(&idx->ida, node->id.f.nr);
+	idx->nr_nodes--;
+}
+
+
+/*
+ * IOB_ROLE
+ *
+ * There are two types of roles - task and user specified.  task_role
+ * represents a task and keyed by its task pointer.  task_role is created
+ * when the matching task first enters iob tracking, unhashed on task exit
+ * and destroyed after reclaim period has passed.
+ *
+ * The reason task_roles are keyed by task pointer instead of pid is
+ * because pid can change across exec(2) and we need reliable match on task
+ * exit to avoid leaking task_roles.  A task_role is unhashed and scheduled
+ * for removal on task exit or if thie pid no longer matches after exec.
+ *
+ * These life-cycle rules guarantee that any task is given one id across
+ * its lifetime and avoids resource leaks.
+ *
+ * task_roles also carry context information for the task, e.g. whether the
+ * task is currently assuming a user specified role, the last file the task
+ * operated on, currently on-going inode operation and so on.
+ *
+ * User specified roles are identified by positive integers, which are
+ * stored negated in role->id, and managed by userland.  Userland can
+ * request the current task to assume a user specified role, in which case
+ * all actions taken by the task is attributed to the user specified role.
+ */
+
+static struct iob_role *iob_node_to_role(struct iob_node *node)
+{
+	return node ? container_of(node, struct iob_role, node) : NULL;
+}
+
+static unsigned long iob_role_hash(void *key)
+{
+	struct iob_role *rkey = key;
+
+	/* task_roles are keyed by task ptr, user roles by id */
+	if (rkey->pid >= 0)
+		return jhash(rkey->task, sizeof(rkey->task), JHASH_INITVAL);
+	else
+		return jhash_1word(rkey->pid, JHASH_INITVAL);
+}
+
+static bool iob_role_match(struct iob_node *node, void *key)
+{
+	struct iob_role *role = iob_node_to_role(node);
+	struct iob_role *rkey = key;
+
+	if (rkey->pid >= 0)
+		return rkey->task == role->task;
+	else
+		return rkey->pid == role->pid;
+}
+
+static struct iob_node *iob_role_create(void *key, gfp_t gfp_mask)
+{
+	struct iob_role *rkey = key;
+	struct iob_role *role;
+
+	role = kmem_cache_alloc(iob_role_cache, gfp_mask);
+	if (!role)
+		return NULL;
+	*role = *rkey;
+	INIT_LIST_HEAD(&role->free_list);
+	return &role->node;
+}
+
+static void iob_role_destroy(struct iob_node *node)
+{
+	kmem_cache_free(iob_role_cache, iob_node_to_role(node));
+}
+
+static struct iob_role iob_role_null_key = { };
+
+static const struct iob_idx_type iob_role_idx_type = {
+	.type		= IOB_ROLE,
+
+	.hash		= iob_role_hash,
+	.match		= iob_role_match,
+	.create		= iob_role_create,
+	.destroy	= iob_role_destroy,
+
+	.nomem_key	= &iob_role_null_key,
+	.lost_key	= &iob_role_null_key,
+};
+
+static struct iob_role *iob_role_by_id(union iob_id id)
+{
+	return iob_node_to_role(iob_node_by_id(id, iob_role_idx));
+}
+
+/**
+ * iob_reclaim_current_task_role - reclaim the current task_role
+ *
+ * Unhash task_role.  This function guarantees that the %current task_role
+ * won't be visible to hash table lookup by itself.
+ */
+static void iob_reclaim_current_task_role(void)
+{
+	struct iob_role rkey = { };
+	struct iob_role *trole;
+	unsigned long flags;
+
+	/*
+	 * A task_role is always created by %current and thus guaranteed to
+	 * be visible to %current.  Negative result from lockless lookup
+	 * can be trusted.
+	 */
+	rkey.task = current;
+	rkey.pid = task_pid_nr(current);
+	trole = iob_node_to_role(iob_get_node_raw(&rkey, iob_role_idx, false));
+	if (!trole)
+		return;
+
+	/* unhash and queue on reclaim list */
+	spin_lock_irqsave(&iob_lock, flags);
+	WARN_ON_ONCE(!iob_unhash_node(&trole->node, iob_role_idx));
+	WARN_ON_ONCE(!list_empty(&trole->free_list));
+	list_add_tail(&trole->free_list, iob_role_to_free_front);
+	spin_unlock_irqrestore(&iob_lock, flags);
+}
+
+/**
+ * iob_current_task_role - lookup task_role for %current
+ *
+ * Return task_role for %current.  May return nomem node under memory
+ * pressure.
+ */
+static struct iob_role *iob_current_task_role(void)
+{
+	struct iob_role rkey = { };
+	struct iob_role *trole;
+	bool retried = false;
+
+	rkey.task = current;
+	rkey.pid = task_pid_nr(current);
+retry:
+	trole = iob_node_to_role(iob_get_node(&rkey, iob_role_idx));
+
+	/*
+	 * If %current exec'd, its pid may have changed.  In such cases,
+	 * shoot down the current task_role and retry.
+	 */
+	if (trole->pid == rkey.pid || trole->node.id.f.nr < IOB_BASE_NR)
+		return trole;
+
+	iob_reclaim_current_task_role();
+
+	/* this shouldn't happen more than once */
+	WARN_ON_ONCE(retried);
+	retried = true;
+	goto retry;
+}
+
+/**
+ * iob_task_role_to_role - return the role to use for IO blaming
+ * @trole: task_role of interest
+ *
+ * If @trole has a user role, return it; otherwise, return @trole.
+ */
+static struct iob_role *iob_task_role_to_role(struct iob_role *trole)
+{
+	struct iob_role *urole;
+
+	if (!trole || !trole->user_role.v)
+		return trole;
+
+	/* look up user role */
+	urole = iob_role_by_id(trole->user_role);
+	if (urole) {
+		WARN_ON_ONCE(urole->pid >= 0);
+		return urole;
+	}
+
+	/* user_role is dangling, clear it */
+	trole->user_role.v = 0;
+	return trole;
+}
+
+/**
+ * iob_current_role - lookup role for %current
+ *
+ * Return role to use for IO blaming.
+ */
+static struct iob_role *iob_current_role(void)
+{
+	return iob_task_role_to_role(iob_current_task_role());
+}
+
+
+/*
+ * IOB_INTENT
+ *
+ * An intent represents a category of actions a task can take.  It
+ * currently consists of stack trace at the point of action and modifier.
+ * The number of unique backtraces is expected to be limited and no
+ * reclaiming is implemented.
+ */
+
+static struct iob_intent *iob_node_to_intent(struct iob_node *node)
+{
+	return node ? container_of(node, struct iob_intent, node) : NULL;
+}
+
+static unsigned long iob_intent_hash(void *key)
+{
+	struct iob_intent_key *ikey = key;
+
+	return jhash(ikey->trace, ikey->depth * sizeof(ikey->trace[0]),
+		     JHASH_INITVAL + ikey->modifier);
+}
+
+static bool iob_intent_match(struct iob_node *node, void *key)
+{
+	struct iob_intent *intent = iob_node_to_intent(node);
+	struct iob_intent_key *ikey = key;
+
+	if (intent->modifier == ikey->modifier &&
+	    intent->depth == ikey->depth)
+		return !memcmp(intent->trace, ikey->trace,
+			       intent->depth * sizeof(intent->trace[0]));
+	return false;
+}
+
+static struct iob_node *iob_intent_create(void *key, gfp_t gfp_mask)
+{
+	struct iob_intent_key *ikey = key;
+	struct iob_intent *intent;
+	size_t trace_sz = sizeof(intent->trace[0]) * ikey->depth;
+
+	intent = kzalloc(sizeof(*intent) + trace_sz, gfp_mask);
+	if (!intent)
+		return NULL;
+
+	intent->modifier = ikey->modifier;
+	intent->depth = ikey->depth;
+	memcpy(intent->trace, ikey->trace, trace_sz);
+	return &intent->node;
+}
+
+static void iob_intent_destroy(struct iob_node *node)
+{
+	kfree(iob_node_to_intent(node));
+}
+
+static struct iob_intent_key iob_intent_null_key = { };
+
+static const struct iob_idx_type iob_intent_idx_type = {
+	.type		= IOB_INTENT,
+
+	.hash		= iob_intent_hash,
+	.match		= iob_intent_match,
+	.create		= iob_intent_create,
+	.destroy	= iob_intent_destroy,
+
+	.nomem_key	= &iob_intent_null_key,
+	.lost_key	= &iob_intent_null_key,
+};
+
+static struct iob_intent *iob_intent_by_nr(int nr)
+{
+	return iob_node_to_intent(iob_node_by_nr(nr, iob_intent_idx));
+}
+
+static struct iob_intent *iob_intent_by_id(union iob_id id)
+{
+	return iob_node_to_intent(iob_node_by_id(id, iob_intent_idx));
+}
+
+static struct iob_intent *iob_get_intent(unsigned long *trace, int depth,
+					 u32 modifier)
+{
+	struct iob_intent_key ikey = { .modifier = modifier, .depth = depth,
+				       .trace = trace };
+
+	return iob_node_to_intent(iob_get_node(&ikey, iob_intent_idx));
+}
+
+static DEFINE_PER_CPU(unsigned long [IOB_STACK_MAX_DEPTH], iob_trace_buf_pcpu);
+
+/**
+ * iob_current_intent - return intent for %current
+ * @skip: number of stack frames to skip
+ *
+ * Acquire stack trace after skipping @skip frames and return matching
+ * iob_intent.  The stack trace never includes iob_current_intent() and
+ * @skip of 1 skips the caller not iob_current_intent().  May return nomem
+ * node under memory pressure.
+ */
+static noinline struct iob_intent *iob_current_intent(int skip)
+{
+	unsigned long *trace = *this_cpu_ptr(&iob_trace_buf_pcpu);
+	struct stack_trace st = { .max_entries = IOB_STACK_MAX_DEPTH,
+				  .entries = trace, .skip = skip + 1 };
+	struct iob_intent *intent;
+	unsigned long flags;
+
+	/* disable IRQ to make trace_pcpu array access exclusive */
+	local_irq_save(flags);
+
+	/* acquire stack trace, ignore -1LU end of stack marker */
+	save_stack_trace_quick(&st);
+	if (st.nr_entries && trace[st.nr_entries - 1] == ULONG_MAX)
+		st.nr_entries--;
+
+	/* get matching iob_intent */
+	intent = iob_get_intent(trace, st.nr_entries, 0);
+
+	local_irq_restore(flags);
+	return intent;
+}
+
+
+/*
+ * IOB_ACT
+ *
+ * Represents specific action an iob_role took.  Consists of a iob_role,
+ * iob_act, and the target inode.  iob_act is what ioblame tracks.  For
+ * each operation which needs to be blamed, iob_act is acquired and
+ * recorded (either by id or id.f.nr) and used for data gathering and
+ * reporting.
+ *
+ * Because this is product of three different entities, the number can grow
+ * quite large.  Each successful lookup sets updates used bitmap and
+ * iob_acts which haven't been used for iob_ttl_secs are reclaimed after
+ * data is collected by userland.
+ */
+
+static void iob_act_mark_used(struct iob_act *act)
+{
+	if (!test_bit(act->node.id.f.nr, iob_act_used.cur))
+		set_bit(act->node.id.f.nr, iob_act_used.cur);
+}
+
+static struct iob_act *iob_node_to_act(struct iob_node *node)
+{
+	return node ? container_of(node, struct iob_act, node) : NULL;
+}
+
+static unsigned long iob_act_hash(void *key)
+{
+	return jhash(key + IOB_ACT_KEY_OFFSET,
+		     sizeof(struct iob_act) - IOB_ACT_KEY_OFFSET,
+		     JHASH_INITVAL);
+}
+
+static bool iob_act_match(struct iob_node *node, void *key)
+{
+	return !memcmp((void *)node + IOB_ACT_KEY_OFFSET,
+		       key + IOB_ACT_KEY_OFFSET,
+		       sizeof(struct iob_act) - IOB_ACT_KEY_OFFSET);
+}
+
+static struct iob_node *iob_act_create(void *key, gfp_t gfp_mask)
+{
+	struct iob_act *akey = key;
+	struct iob_act *act;
+
+	act = kmem_cache_alloc(iob_act_cache, gfp_mask);
+	if (!act)
+		return NULL;
+	*act = *akey;
+	return &act->node;
+}
+
+static void iob_act_destroy(struct iob_node *node)
+{
+	struct iob_act *act = iob_node_to_act(node);
+
+	if (act->cnts)
+		kmem_cache_free(iobc_cnts_cache, act->cnts);
+	kmem_cache_free(iob_act_cache, act);
+}
+
+static struct iob_act iob_act_nomem_key = {
+	.role		= IOB_PACK_ID(IOB_ROLE, IOB_NOMEM_NR, 1),
+	.intent		= IOB_PACK_ID(IOB_INTENT, IOB_NOMEM_NR, 1),
+};
+
+static struct iob_act iob_act_lost_key = {
+	.role		= IOB_PACK_ID(IOB_ROLE, IOB_LOST_NR, 1),
+	.intent		= IOB_PACK_ID(IOB_INTENT, IOB_LOST_NR, 1),
+};
+
+static const struct iob_idx_type iob_act_idx_type = {
+	.type		= IOB_ACT,
+
+	.hash		= iob_act_hash,
+	.match		= iob_act_match,
+	.create		= iob_act_create,
+	.destroy	= iob_act_destroy,
+
+	.nomem_key	= &iob_act_nomem_key,
+	.lost_key	= &iob_act_lost_key,
+};
+
+static struct iob_act *iob_act_by_nr(int nr)
+{
+	return iob_node_to_act(iob_node_by_nr(nr, iob_act_idx));
+}
+
+static struct iob_act *iob_act_by_id(union iob_id id)
+{
+	return iob_node_to_act(iob_node_by_id(id, iob_act_idx));
+}
+
+/**
+ * iob_current_act - return the current iob_act
+ * @stack_skip: number of stack frames to skip when acquiring iob_intent
+ * @dev: dev_t of the inode being operated on
+ * @ino: ino of the inode being operated on
+ * @gen: generation of the inode being operated on
+ *
+ * Return iob_act for %current with the current backtrace.
+ * iob_current_act() is never included in the backtrace.  May return nomem
+ * node under memory pressure.
+ */
+static __always_inline struct iob_act *iob_current_act(int stack_skip,
+						dev_t dev, ino_t ino, u32 gen)
+{
+	struct iob_role *role = iob_current_role();
+	struct iob_intent *intent = iob_current_intent(stack_skip);
+	struct iob_act akey = { .role = role->node.id,
+				.intent = intent->node.id, .dev = dev };
+	struct iob_act *act;
+	int min_nr;
+
+	/* if either role or intent is special, return matching special role */
+	min_nr = min_t(int, role->node.id.f.nr, intent->node.id.f.nr);
+	if (unlikely(min_nr < IOB_BASE_NR)) {
+		if (min_nr == IOB_NOMEM_NR)
+			return iob_node_to_act(iob_act_idx->nomem_node);
+		else
+			return iob_node_to_act(iob_act_idx->lost_node);
+	}
+
+	/* if ignore_ino is set, use the same act for all files on the dev */
+	if (!iob_ignore_ino) {
+		akey.ino = ino;
+		akey.gen = gen;
+	}
+
+	act = iob_node_to_act(iob_get_node(&akey, iob_act_idx));
+	if (act)
+		iob_act_mark_used(act);
+	return act;
+}
+
+/**
+ * iob_modified_act - determined modified act
+ * @act: the base act
+ * @modifier: modifier to apply
+ *
+ * Return iob_act which is identical to @act except that its intent
+ * modifier is @modifier.  @act is allowed to have no or any modifier on
+ * entry.  May return nomem node under memory pressure.
+ */
+static struct iob_act *iob_modified_act(struct iob_act *act, u32 modifier)
+{
+	struct iob_intent *intent = iob_intent_by_id(act->intent);
+	struct iob_act akey = { .role = act->role, .dev = act->dev };
+
+	/* if ignore_ino is set, use the same act for all files on the dev */
+	if (!iob_ignore_ino) {
+		akey.ino = act->ino;
+		akey.gen = act->gen;
+	}
+
+	intent = iob_get_intent(intent->trace, intent->depth, modifier);
+	akey.intent = intent->node.id;
+
+	return iob_node_to_act(iob_get_node(&akey, iob_act_idx));
+}
+
+
+/*
+ * RECLAIM
+ *
+ * iob_act can only be reclaimed once data is collected by userland, so we
+ * run reclaimer together with data acquisition.
+ *
+ * iob_act uses bitmaps to collect and track used state history.  Used bits
+ * are tracked every half ttl period and iob_acts which haven't been used
+ * for two half ttl periods are reclaimed.  As reclaiming is regulated by
+ * data acquisition, the code doesn't have full control over reclaim
+ * timing.  It tries to stay close to the behavior specified by
+ * @iob_ttl_secs.
+ *
+ * iob_role goes through reclaiming mostly to delay freeing so that roles
+ * are still available when async IO events fire after the original tasks
+ * exit.  iob_role reclaiming is simpler and always happens after at least
+ * one ttl period has passed.
+ */
+
+/**
+ * iob_switch_act_used_cur - switch iob_act_used->cur and ->staging
+ *
+ * Switch the cur and staging bitmaps and wait for all current users to
+ * finish.  ->staging must be clear on entry.  On return, ->staging points
+ * to used bitmap collected since the previous switch and is guaranteed to
+ * be quiescent.
+ *
+ * Must be called under iob_mutex.
+ */
+static void iob_switch_act_used_cur(void)
+{
+	struct iob_act_used *u = &iob_act_used;
+
+	lockdep_assert_held(&iob_mutex);
+	swap(u->cur, u->staging);
+	synchronize_sched();
+}
+
+/**
+ * iob_reclaim - reclaim iob_roles and iob_acts
+ *
+ * This function looks at iob_act_used->staging, ->front, ->back, and
+ * iob_role_to_free_front and reclaims unused nodes.  On entry,
+ * iob_act_used->staging should contain used bitmap from the previous
+ * period - IOW, the caller should have called iob_switch_act_used_cur()
+ * before.
+ *
+ * Must be called under iob_mutex.
+ */
+static void iob_reclaim(void)
+{
+	LIST_HEAD(role_todo);
+	unsigned long ttl = iob_ttl_secs * HZ;
+	unsigned long role_delta = jiffies - iob_role_reclaim_tstmp;
+	unsigned long act_delta = jiffies - iob_act_reclaim_tstmp;
+	struct iob_role *role, *role_pos;
+	struct iob_act *free_head = NULL, *act;
+	struct iob_act_used *u = &iob_act_used;
+	unsigned long *reclaim;
+	unsigned long flags;
+	int i;
+
+	lockdep_assert_held(&iob_mutex);
+
+	/* collect staging into front and clear staging */
+	bitmap_or(u->front, u->front, u->staging, iob_max_acts);
+	bitmap_clear(u->staging, 0, iob_max_acts);
+
+	/* if less than ttl/2 has passed, collecting is enough */
+	if (act_delta < ttl / 2)
+		return;
+
+	/* >= ttl/2 has passed, let's see if we can kill anything */
+	spin_lock_irqsave(&iob_lock, flags);
+
+	/* determine which roles to reclaim */
+	if (role_delta >= ttl) {
+		/* roles in the other free_head are now older than ttl */
+		list_splice_init(iob_role_to_free_back, &role_todo);
+		swap(iob_role_to_free_front, iob_role_to_free_back);
+		iob_role_reclaim_tstmp = jiffies;
+
+		/*
+		 * All roles to be reclaimed should have been unhashed
+		 * already.  Removing is enough.
+		 */
+		list_for_each_entry(role, &role_todo, free_list) {
+			WARN_ON_ONCE(!hlist_unhashed(&role->node.hash_node));
+			iob_remove_node(&role->node, iob_role_idx);
+		}
+	}
+
+	/*
+	 * Determine the bitmap to use for act reclaim.  Ideally, we want
+	 * to be invoked every ttl/2 for reclaim granularity but don't have
+	 * control over that.  We handle [ttl/2,ttl) as ttl/2 - acts which
+	 * are marked unused in both front and back bitmaps are reclaimed.
+	 * If >=ttl, we ignore back bitmap and reclaim any which is marked
+	 * unused in the front bitmap.
+	 */
+	if (act_delta < ttl) {
+		bitmap_or(u->back, u->back, u->front, iob_max_acts);
+		reclaim = u->back;
+	} else {
+		reclaim = u->front;
+	}
+
+	/* unhash and remove all acts which don't have bit set in @reclaim */
+	for (i = find_next_zero_bit(reclaim, iob_max_acts, IOB_BASE_NR);
+	     i < iob_max_acts;
+	     i = find_next_zero_bit(reclaim, iob_max_acts, i + 1)) {
+		act = iob_node_to_act(iob_node_by_nr_raw(i, iob_act_idx));
+		if (act) {
+			WARN_ON_ONCE(!iob_unhash_node(&act->node, iob_act_idx));
+			iob_remove_node(&act->node, iob_act_idx);
+			act->free_next = free_head;
+			free_head = act;
+		}
+	}
+
+	spin_unlock_irqrestore(&iob_lock, flags);
+
+	/* reclaim complete, front<->back and clear front */
+	swap(u->front, u->back);
+	bitmap_clear(u->front, 0, iob_max_acts);
+
+	iob_act_reclaim_tstmp = jiffies;
+
+	/* before freeing reclaimed nodes, wait for in-flight users to finish */
+	synchronize_sched();
+
+	list_for_each_entry_safe(role, role_pos, &role_todo, free_list)
+		iob_role_destroy(&role->node);
+
+	while ((act = free_head)) {
+		free_head = act->free_next;
+		iob_act_destroy(&act->node);
+	}
+}
+
+/*
+ * PGTREE
+ *
+ * Radix tree to map pfn to iob_act.  This is used to track which iob_act
+ * dirtied the page.  When a bio is issued, each page in the iovec is
+ * consulted against pgtree to find out which act caused it.
+ *
+ * Because the size of pgtree is proportional to total available memory, it
+ * uses id.f.nr instead of full id and may occassionally give stale result.
+ * Also, it uses u16 array if ACT_MAX is <= USHRT_MAX; otherwise, u32.
+ */
+
+void *iob_pgtree_slot(unsigned long pfn)
+{
+	unsigned long idx = pfn >> iob_pgtree_pfn_shift;
+	unsigned long offset = pfn & iob_pgtree_pfn_mask;
+	void *p;
+
+	p = radix_tree_lookup(&iob_pgtree, idx);
+	if (p)
+		return p + (offset << iob_pgtree_shift);
+	return NULL;
+}
+
+/**
+ * iob_pgtree_set_nr - map pfn to nr
+ * @pfn: pfn to map
+ * @nr: id.f.nr to be mapped
+ *
+ * Map @pfn to @nr, which can later be retrieved using
+ * iob_pgtree_get_and_clear_nr().  This function is opportunistic - it may
+ * fail under memory pressure and clobber each other's mappings when
+ * multiple pgtree ops race.
+ */
+static int iob_pgtree_set_nr(unsigned long pfn, int nr)
+{
+	void *slot, *p;
+	unsigned long flags;
+	int ret;
+retry:
+	slot = iob_pgtree_slot(pfn);
+	if (likely(slot)) {
+		/*
+		 * We're playing with pointer casts and racy accesses.  Use
+		 * ACCESS_ONCE() to avoid compiler surprises.
+		 */
+		switch (iob_pgtree_shift) {
+		case 1:
+			ACCESS_ONCE(*(u16 *)slot) = nr;
+			break;
+		case 2:
+			ACCESS_ONCE(*(u32 *)slot) = nr;
+			break;
+		default:
+			BUG();
+		}
+		return 0;
+	}
+
+	/* slot missing, create and insert new page and retry */
+	p = (void *)get_zeroed_page(GFP_NOWAIT);
+	if (!p) {
+		iob_stats.pgtree_nomem++;
+		return -ENOMEM;
+	}
+
+	spin_lock_irqsave(&iob_lock, flags);
+	ret = radix_tree_insert(&iob_pgtree, pfn >> iob_pgtree_pfn_shift, p);
+	spin_unlock_irqrestore(&iob_lock, flags);
+
+	if (ret) {
+		free_page((unsigned long)p);
+		if (ret != -EEXIST) {
+			iob_stats.pgtree_nomem++;
+			return ret;
+		}
+	}
+	goto retry;
+}
+
+/**
+ * iob_pgtree_get_and_clear_nr - read back pfn to nr mapping and clear it
+ * @pfn: pfn to read mapping for
+ *
+ * Read back mapping set by iob_pgtree_set_nr().  This function is
+ * opportunistic and may clobber each other's mappings when multiple pgtree
+ * ops race.
+ */
+static int iob_pgtree_get_and_clear_nr(unsigned long pfn)
+{
+	void *slot;
+	int nr;
+
+	slot = iob_pgtree_slot(pfn);
+	if (unlikely(!slot))
+		return 0;
+
+	/*
+	 * We're playing with pointer casts and racy accesses.  Use
+	 * ACCESS_ONCE() to avoid compiler surprises.
+	 */
+	switch (iob_pgtree_shift) {
+	case 1:
+		nr = ACCESS_ONCE(*(u16 *)slot);
+		if (nr)
+			ACCESS_ONCE(*(u16 *)slot) = 0;
+		break;
+	case 2:
+		nr = ACCESS_ONCE(*(u32 *)slot);
+		if (nr)
+			ACCESS_ONCE(*(u32 *)slot) = 0;
+		break;
+	default:
+		BUG();
+	}
+	return nr;
+}
+
+
+/*
+ * PROBES
+ *
+ * Tracepoint probes.  This is how ioblame learns what's going on in the
+ * system.  TP probes are always called with preemtion disabled, so we
+ * don't need explicit rcu_read_lock_sched().
+ */
+
+static bool iob_enabled_inode(struct inode *inode)
+{
+	WARN_ON_ONCE(!rcu_read_lock_sched_held());
+
+	return iob_enabled && inode->i_sb->s_bdev &&
+		inode->i_sb->s_bdev->bd_disk->iob_enabled;
+}
+
+static bool iob_enabled_bh(struct buffer_head *bh)
+{
+	WARN_ON_ONCE(!rcu_read_lock_sched_held());
+
+	return iob_enabled && bh->b_bdev->bd_disk->iob_enabled;
+}
+
+static bool iob_enabled_bio(struct bio *bio)
+{
+	WARN_ON_ONCE(!rcu_read_lock_sched_held());
+
+	return iob_enabled && bio->bi_bdev &&
+		bio->bi_bdev->bd_disk->iob_enabled;
+}
+
+/* current timestamp in usecs, base is unknown and may jump backwards */
+static unsigned long iob_now_usecs(void)
+{
+	u64 now = local_clock();
+
+	/*
+	 * We don't worry about @now itself wrapping.  On 32bit, the
+	 * divided ulong result will wrap in orderly manner and
+	 * time_before/after() should work as expected.
+	 */
+	do_div(now, 1000);
+	return now;
+}
+
+static void iob_set_last_ino(struct inode *inode)
+{
+	struct iob_role *trole = iob_current_task_role();
+
+	trole->last_ino.dev = inode->i_sb->s_dev;
+	trole->last_ino.ino = inode->i_ino;
+	trole->last_ino.gen = inode->i_generation;
+	trole->last_ino_jiffies = jiffies;
+}
+
+/*
+ * Mark the last inode accessed by this task role.  This is used to
+ * attribute IOs to files.
+ */
+static void iob_probe_vfs_fcheck(void *data, struct files_struct *files,
+				 unsigned int fd, struct file *file)
+{
+	if (file) {
+		struct inode *inode = file->f_dentry->d_inode;
+
+		if (iob_enabled_inode(inode))
+			iob_set_last_ino(inode);
+	}
+}
+
+/* called after a page is dirtied - record the dirtying act in pgtree */
+static void iob_probe_wb_dirty_page(void *data, struct page *page,
+				    struct address_space *mapping)
+{
+	struct inode *inode = mapping->host;
+
+	if (iob_enabled_inode(inode)) {
+		struct iob_act *act = iob_current_act(2, inode->i_sb->s_dev,
+						      inode->i_ino,
+						      inode->i_generation);
+
+		iob_pgtree_set_nr(page_to_pfn(page), act->node.id.f.nr);
+	}
+}
+
+/*
+ * Writeback is starting, record wb_reason in trole->modifier.  This will
+ * be applied to any IOs issued from this task until writeback is finished.
+ */
+static void iob_probe_wb_start(void *data, struct backing_dev_info *bdi,
+			       struct wb_writeback_work *work)
+{
+	struct iob_role *trole = iob_current_task_role();
+
+	trole->modifier = work->reason | IOB_MODIFIER_WB;
+}
+
+/* writeback done, clear modifier */
+static void iob_probe_wb_written(void *data, struct backing_dev_info *bdi,
+				 struct wb_writeback_work *work)
+{
+	struct iob_role *trole = iob_current_task_role();
+
+	trole->modifier = 0;
+}
+
+/*
+ * An inode is about to be written back.  Will be followed by data and
+ * inode writeback.  In case dirtier data is not recorded in pgtree or
+ * inode, remember the inode in trole->last_ino.
+ */
+static void iob_probe_wb_single_inode_start(void *data, struct inode *inode,
+					    struct writeback_control *wbc,
+					    unsigned long nr_to_write)
+{
+	if (iob_enabled_inode(inode))
+		iob_set_last_ino(inode);
+}
+
+/*
+ * Called when an inode is about to be dirtied, right before fs
+ * dirty_inode() method.  Different filesystems implement inode dirtying
+ * and writeback differently.  Some may allocate bh on dirtying, some might
+ * do it during write_inode() and others might not use bh at all.
+ *
+ * To cover most cases, two tracking mechanisms are used - trole->inode_act
+ * and inode->i_iob_act.  The former marks the current task as performing
+ * inode dirtying act and any IOs issued or bhs touched are attributed to
+ * the act.  The latter records the dirtying act on the inode itself so
+ * that if the filesystem takes action for the inode from write_inode(),
+ * the acting task can take on the dirtying act.
+ */
+static void iob_probe_wb_dirty_inode_start(void *data, struct inode *inode,
+					   int flags)
+{
+	if (iob_enabled_inode(inode)) {
+		struct iob_role *trole = iob_current_task_role();
+		struct iob_act *act = iob_current_act(1, inode->i_sb->s_dev,
+						      inode->i_ino,
+						      inode->i_generation);
+		trole->inode_act = act->node.id;
+		inode->i_iob_act = act->node.id;
+	}
+}
+
+/* inode dirtying complete */
+static void iob_probe_wb_dirty_inode(void *data, struct inode *inode, int flags)
+{
+	if (iob_enabled_inode(inode))
+		iob_current_task_role()->inode_act.v = 0;
+}
+
+/*
+ * Called when an inode is being written back, right before fs
+ * write_inode() method.  Inode writeback is starting, take on the act
+ * which dirtied the inode.
+ */
+static void iob_probe_wb_write_inode_start(void *data, struct inode *inode,
+					   struct writeback_control *wbc)
+{
+	if (iob_enabled_inode(inode) && inode->i_iob_act.v) {
+		struct iob_role *trole = iob_current_task_role();
+
+		trole->inode_act = inode->i_iob_act;
+	}
+}
+
+/* inode writing complete */
+static void iob_probe_wb_write_inode(void *data, struct inode *inode,
+				     struct writeback_control *wbc)
+{
+	if (iob_enabled_inode(inode))
+		iob_current_task_role()->inode_act.v = 0;
+}
+
+/*
+ * Called on touch_buffer().  Transfer inode act to pgtree.  This catches
+ * most inode operations for filesystems which use bh for metadata.
+ */
+static void iob_probe_block_touch_buffer(void *data, struct buffer_head *bh)
+{
+	if (iob_enabled_bh(bh)) {
+		struct iob_role *trole = iob_current_task_role();
+
+		if (trole->inode_act.v)
+			iob_pgtree_set_nr(page_to_pfn(bh->b_page),
+					  trole->inode_act.f.nr);
+	}
+}
+
+/* bio is being queued, collect all info into bio->bi_iob_info */
+static void iob_probe_block_bio_queue(void *data, struct request_queue *q,
+				      struct bio *bio)
+{
+	struct iob_io_info *io = &bio->bi_iob_info;
+	struct iob_act *act = NULL;
+	struct iob_role *trole;
+	int i;
+
+	if (!iob_enabled_bio(bio))
+		return;
+
+	trole = iob_current_task_role();
+
+	io->rw = bio->bi_rw;
+	io->sector = bio->bi_sector;
+	io->size = bio->bi_size;
+	io->issued_at = io->queued_at = iob_now_usecs();
+
+	/* trole's inode_act has the highest priority */
+	if (trole->inode_act.v)
+		io->act = trole->inode_act;
+
+	/* always walk pgtree and clear matching pages */
+	for (i = 0; i < bio->bi_vcnt; i++) {
+		struct bio_vec *bv = &bio->bi_io_vec[i];
+		int nr;
+
+		if (!bv->bv_len)
+			continue;
+
+		nr = iob_pgtree_get_and_clear_nr(page_to_pfn(bv->bv_page));
+		if (!nr || io->act.v)
+			continue;
+
+		/* this is the first act, charge everything to it */
+		act = iob_act_by_nr(nr);
+		io->act = act->node.id;
+	}
+
+	/*
+	 * If act is still not set, charge it to the IO issuer.  When
+	 * acquiring stack trace, skip this function and
+	 * generic_make_request[_checks]()
+	 */
+	if (!io->act.v) {
+		unsigned long now = jiffies;
+		dev_t dev = bio->bi_bdev->bd_dev;
+		ino_t ino = 0;
+		u32 gen = 0;
+
+		/*
+		 * Charge IOs to the last file this task initiated RW or
+		 * writeback on, which is highly likely to be the file this
+		 * IO is for.  As a sanity check, trust last_ino only for
+		 * pre-defined duration.
+		 */
+		if (time_before_eq(trole->last_ino_jiffies, now) &&
+		    now - trole->last_ino_jiffies <= IOB_LAST_INO_DURATION) {
+			dev = trole->last_ino.dev;
+			ino = trole->last_ino.ino;
+			gen = trole->last_ino.gen;
+		}
+
+		act = iob_current_act(3, dev, ino, gen);
+		io->act = act->node.id;
+	}
+
+	/* if %current has modifier set, apply it */
+	if (trole->modifier) {
+		if (!act)
+			act = iob_act_by_id(io->act);
+		act = iob_modified_act(act, trole->modifier);
+		io->act = act->node.id;
+	}
+}
+
+/* when bios get merged, charge everything to the first bio */
+static void iob_probe_block_bio_backmerge(void *data, struct request_queue *q,
+					  struct request *rq, struct bio *bio)
+{
+	struct bio *mbio = rq->bio;
+	struct iob_io_info *mio = &mbio->bi_iob_info;
+	struct iob_io_info *sio = &bio->bi_iob_info;
+
+	mio->size += sio->size;
+	sio->size = 0;
+}
+
+/* when bios get merged, charge everything to the first bio */
+static void iob_probe_block_bio_frontmerge(void *data, struct request_queue *q,
+					   struct request *rq, struct bio *bio)
+{
+	struct bio *mbio = rq->bio;
+	struct iob_io_info *mio = &mbio->bi_iob_info;
+	struct iob_io_info *sio = &bio->bi_iob_info;
+
+	mio->sector = sio->sector;
+	mio->size += sio->size;
+	mio->act = sio->act;
+	sio->size = 0;
+}
+
+/* record issue timestamp, this may not happen for bio based drivers */
+static void iob_probe_block_rq_issue(void *data, struct request_queue *q,
+				     struct request *rq)
+{
+	if (rq->bio && rq->bio->bi_iob_info.size)
+		rq->bio->bi_iob_info.issued_at = iob_now_usecs();
+}
+
+/* bio is complete, report and accumulate statistics */
+static void iob_probe_block_bio_complete(void *data, struct request_queue *q,
+					 struct bio *bio, int error)
+{
+	struct iob_io_info *io = &bio->bi_iob_info;
+
+	if (!io->size)
+		return;
+
+	if (!iob_enabled_bio(bio))
+		return;
+
+	if (iobc_nr_types)
+		iob_count(io, bio->bi_bdev->bd_disk);
+
+	if (iob_iolog)
+		iob_iolog_fill(io);
+}
+
+/* %current is exiting, shoot down its task_role */
+static void iob_probe_block_sched_process_exit(void *data,
+					       struct task_struct *task)
+{
+	WARN_ON_ONCE(task != current);
+	iob_reclaim_current_task_role();
+}
+
+
+/*
+ * Counters.
+ *
+ * Collects io stats to be reported to userland.  Each act is associcated
+ * with a set of counters as determined by counter types.
+ *
+ * Each counter type consists of histogram of eight u32's, the field to
+ * record, boundary values used to determine the slot in the histogram and
+ * optional filter.  It describes whether the counter should be activated
+ * for a specific IO (filter), if so, which value to record (field) and to
+ * which slot (boundaries).
+ *
+ * Counter types are userland configurable via ioblame/nr_counters and
+ * ioblame/counters/NR[_filter].
+ */
+
+/*
+ * Helper to grab iob_lock and get iobc_type associated with
+ * ioblame/counters/NR[_filter] @file.
+ */
+static struct iobc_type *iobc_lock_and_get_type(struct file *file)
+	__acquires(&iob_mutex)
+{
+	int i;
+
+	mutex_lock(&iob_mutex);
+
+	i = (long)file->f_dentry->d_inode->i_private;
+
+	/* raced nr_counters reduction? */
+	if (i >= iobc_nr_types) {
+		mutex_unlock(&iob_mutex);
+		return ERR_PTR(-ENOENT);
+	}
+
+	return &iobc_types[i];
+}
+
+/*
+ * ioblame/counters/NR - read and set counter type.  Its format is
+ *
+ *   DIR FIELD_NAME B0 B1 B2 B3 B4 B5 B6 B7 B8
+ *
+ * DIR is any combination of letters 'r', 'a', and 'w', each representing
+ * reads, readaheads and writes.  FIELD_NAME is one of iobc_field_strs[]
+ * and B[0-8] are u32 values delimiting histogram slots - ie. a value >= B3
+ * and < B4 would be recorded in histogram slot 3.  Values < B0 or >=
+ * non-zero B8 are ignored.
+ *
+ * Note that counter type can be updated while iob is enabled.
+ */
+static ssize_t iobc_type_read(struct file *file, char __user *ubuf,
+			      size_t count, loff_t *ppos)
+{
+	struct iobc_type *type;
+	char *buf;
+	u32 *b;
+	ssize_t ret;
+
+	type = iobc_lock_and_get_type(file);
+	if (IS_ERR(type))
+		return PTR_ERR(type);
+
+	buf = iob_page_buf;
+	b = type->bounds;
+
+	if (type->dir) {
+		char dir[4] = "---";
+
+		if (type->dir & IOBC_READ)
+			dir[0] = 'R';
+		if (type->dir & IOBC_RAHEAD)
+			dir[1] = 'A';
+		if (type->dir & IOBC_WRITE)
+			dir[2] = 'W';
+
+		snprintf(buf, PAGE_SIZE, "%s %s %u %u %u %u %u %u %u %u %u\n",
+			 dir, iobc_field_strs[type->field],
+			 b[0], b[1], b[2], b[3], b[4], b[5], b[6], b[7], b[8]);
+	} else {
+		snprintf(buf, PAGE_SIZE, "--- disabled\n");
+	}
+
+	ret = simple_read_from_buffer(ubuf, count, ppos, buf, strlen(buf));
+
+	mutex_unlock(&iob_mutex);
+
+	return ret;
+}
+
+static ssize_t iobc_type_write(struct file *file, const char __user *ubuf,
+			       size_t cnt, loff_t *ppos)
+{
+	char field_str[IOBC_FIELD_MAX_LEN + 1];
+	char dir_buf[4];
+	char *buf, *p;
+	struct iobc_type *type;
+	unsigned dir, b[IOBC_NR_SLOTS + 1];
+	int i, field, ret;
+
+	if (cnt >= PAGE_SIZE)
+		return -EOVERFLOW;
+
+	type = iobc_lock_and_get_type(file);
+	if (IS_ERR(type))
+		return PTR_ERR(type);
+
+	buf = iob_page_buf;
+
+	ret = -EFAULT;
+	if (copy_from_user(buf, ubuf, cnt))
+		goto out;
+	buf[cnt] = '\0';
+
+	p = strim(buf);
+	if (!strlen(p)) {
+		type->dir = 0;
+		ret = 0;
+		goto out;
+	}
+
+	/* start parsing */
+	ret = -EINVAL;
+
+	if (sscanf(p, "%3s %"__stringify(IOBC_FIELD_MAX_LEN)"s %u %u %u %u %u %u %u %u %u",
+		   dir_buf, field_str, &b[0], &b[1], &b[2], &b[3],
+		   &b[4], &b[5], &b[6], &b[7], &b[8]) != 11)
+		goto out;
+
+	/* parse direction */
+	dir = 0;
+	if (strchr(dir_buf, 'r') || strchr(dir_buf, 'R'))
+		dir |= IOBC_READ;
+	if (strchr(dir_buf, 'a') || strchr(dir_buf, 'A'))
+		dir |= IOBC_RAHEAD;
+	if (strchr(dir_buf, 'w') || strchr(dir_buf, 'W'))
+		dir |= IOBC_WRITE;
+
+	/* match field */
+	field = IOBC_NR_FIELDS;
+	for (i = 0; i < ARRAY_SIZE(iobc_field_strs); i++)
+		if (!strcmp(field_str, iobc_field_strs[i]))
+			field = i;
+	if (field == IOBC_NR_FIELDS)
+		goto out;
+
+	/*
+	 * Make sure boundary values don't decrease, the last entry can be
+	 * zero meaning no limit.
+	 */
+	for (i = 0; i < IOBC_NR_SLOTS - 1; i++)
+		if (b[i] > b[i + 1])
+			goto out;
+
+	if (b[IOBC_NR_SLOTS] &&
+	    b[IOBC_NR_SLOTS - 1] > b[IOBC_NR_SLOTS])
+		goto out;
+
+	/* alright, commit - if iob is enabled, just let the users race */
+	type->dir = dir;
+	type->field = field;
+	for (i = 0; i < ARRAY_SIZE(type->bounds); i++)
+		type->bounds[i] = b[i];
+	ret = 0;
+out:
+	mutex_unlock(&iob_mutex);
+	return ret ?: cnt;
+}
+
+static const struct file_operations iobc_type_fops = {
+	.owner		= THIS_MODULE,
+	.open		= nonseekable_open,
+	.read		= iobc_type_read,
+	.write		= iobc_type_write,
+};
+
+/*
+ * ioblame/counters/NR_filter - read and set counter filters.  Filters are
+ * the same as trace event filters and all counter fields can be used.  If
+ * no filter is set, the counter is always enabled.
+ *
+ * Note that counter filter can be updated while iob is enabled.
+ */
+static ssize_t iobc_filter_read(struct file *file, char __user *ubuf,
+				size_t count, loff_t *ppos)
+{
+	struct iobc_type *type;
+	char *buf;
+	ssize_t ret = 0;
+
+	type = iobc_lock_and_get_type(file);
+	if (IS_ERR(type))
+		return PTR_ERR(type);
+
+	buf = iob_page_buf;
+
+	if (type->filter) {
+		const char *s = trace_event_filter_string(type->filter);
+
+		if (s) {
+			snprintf(buf, PAGE_SIZE, "%s\n", s);
+			ret = simple_read_from_buffer(ubuf, count, ppos,
+						      buf, strlen(buf));
+		}
+	}
+
+	mutex_unlock(&iob_mutex);
+
+	return ret;
+}
+
+static void iobc_filter_free_rcu(struct rcu_head *head)
+{
+	struct iobc_filter_rcu *rcu = container_of(head, struct iobc_filter_rcu,
+						   rcu_head);
+	trace_event_filter_destroy(rcu->filter);
+	kfree(rcu);
+}
+
+static void iobc_free_filter(struct iobc_type *type)
+{
+	if (!type->filter)
+		return;
+
+	type->filter_rcu->filter = type->filter;
+	call_rcu_sched(&type->filter_rcu->rcu_head, iobc_filter_free_rcu);
+	rcu_assign_pointer(type->filter, NULL);
+	type->filter_rcu = NULL;
+}
+
+static ssize_t iobc_filter_write(struct file *file, const char __user *ubuf,
+				 size_t cnt, loff_t *ppos)
+{
+	struct iobc_filter_rcu *filter_rcu = NULL;
+	struct event_filter *filter = NULL;
+	struct iobc_type *type;
+	char *buf;
+	int ret;
+
+	if (cnt >= PAGE_SIZE)
+		return -EOVERFLOW;
+
+	type = iobc_lock_and_get_type(file);
+	if (IS_ERR(type))
+		return PTR_ERR(type);
+
+	buf = iob_page_buf;
+
+	ret = -EFAULT;
+	if (copy_from_user(buf, ubuf, cnt))
+		goto out;
+	buf[cnt] = '\0';
+
+	ret = 0;
+	buf = strim(buf);
+	if (buf[0] == '0' && buf[1] == '\0') {
+		iobc_free_filter(type);
+		goto out;
+	}
+
+	ret = -ENOMEM;
+	filter_rcu = kzalloc(sizeof(*filter_rcu), GFP_KERNEL);
+	if (!filter_rcu)
+		goto out;
+
+	ret = trace_event_filter_create(&iobc_event_field_list, buf, &filter);
+	/*
+	 * If we have a filter, whether error one or not, install it.
+	 * type->filter is RCU managed so that it can be modified while iob
+	 * is enabled.
+	 */
+	if (filter) {
+		iobc_free_filter(type);
+		type->filter_rcu = filter_rcu;
+		rcu_assign_pointer(type->filter, filter);
+	} else {
+		kfree(filter_rcu);
+		kfree(filter);
+	}
+out:
+	mutex_unlock(&iob_mutex);
+	return ret ?: cnt;
+}
+
+static const struct file_operations iobc_filter_fops = {
+	.owner		= THIS_MODULE,
+	.open		= nonseekable_open,
+	.read		= iobc_filter_read,
+	.write		= iobc_filter_write,
+};
+
+/*
+ * ioblame/nr_counters - the number of counter types.  Can be set only
+ * while iob is disabled.  Write resets all counter types and filters.
+ */
+static int iobc_nr_types_get(void *data, u64 *val)
+{
+	*val = iobc_nr_types;
+	return 0;
+}
+
+static int iobc_nr_types_set(void *data, u64 val)
+{
+	struct iobc_type *tmp_types = NULL;
+	int i, ret;
+
+	if (val > INT_MAX)
+		return -EINVAL;
+
+	mutex_lock(&iob_mutex);
+
+	ret = -EBUSY;
+	if (iob_enabled)
+		goto out_unlock;
+
+	/* destroy old counters/ dir */
+	if (iobc_dir) {
+		debugfs_remove_recursive(iobc_dir);
+		iobc_dir = NULL;
+	}
+
+	if (!val)
+		goto done;
+
+	/* create new ones */
+	ret = -ENOMEM;
+	tmp_types = kzalloc(sizeof(tmp_types[0]) * val, GFP_KERNEL);
+	if (!tmp_types)
+		goto out_unlock;
+
+	iobc_dir = debugfs_create_dir("counters", iob_dir);
+	if (!iobc_dir)
+		goto out_unlock;
+
+	for (i = 0; i < val; i++) {
+		char cnt_name[16], filter_name[32];
+
+		snprintf(cnt_name, sizeof(cnt_name), "%d", i);
+		snprintf(filter_name, sizeof(filter_name), "%d_filter", i);
+
+		if (!debugfs_create_file(cnt_name, 0600, iobc_dir,
+					 (void *)(long)i, &iobc_type_fops) ||
+		    !debugfs_create_file(filter_name, 0600, iobc_dir,
+					 (void *)(long)i, &iobc_filter_fops)) {
+			debugfs_remove_recursive(iobc_dir);
+			iobc_dir = NULL;
+			goto out_unlock;
+		}
+	}
+done:
+	/* destroy old type and commit new one */
+	for (i = 0; i < iobc_nr_types; i++)
+		iobc_free_filter(&iobc_types[i]);
+	swap(iobc_types, tmp_types);
+	iobc_nr_types = val;
+	ret = 0;
+out_unlock:
+	mutex_unlock(&iob_mutex);
+	kfree(tmp_types);
+	return ret;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(iobc_nr_types_fops,
+			iobc_nr_types_get, iobc_nr_types_set, "%llu\n");
+
+/*
+ * Actual counting.  iob_count() is called on each io completion and
+ * responsible for updating the corresponding act->cnts[].
+ *
+ * Note that act->cnts is indexed by slot first and then type.  This is to
+ * increase chance of updates to different counters falling in the same
+ * cache line.  We update one out of eight histogram counters belonging to
+ * each type.  If the counters are organized by type and then slot, it'll
+ * always touch every cacheline the counters occupy.
+ */
+static int iobc_idx(int type, int slot)
+{
+	return slot * iobc_nr_types + type;
+}
+
+/*
+ * Scale @sect / @capa to [0,65536).  IOW, @sect * 65536 / @capa.  Shift
+ * bits around so that we don't lose precision unnecessarily while still
+ * doing single 64bit/32bit division.
+ */
+static u16 iobc_scale_sect(u64 sect, u64 capa)
+{
+	int shift = fls64(capa) - 32;
+
+	if (shift <= 0) {
+		sect <<= 16;
+	} else {
+		if (shift <= 16)
+			sect <<= 16 - shift;
+		else
+			sect >>= shift - 16;
+		capa >>= shift;
+	}
+
+	do_div(sect, capa);
+
+	return sect;
+}
+
+static void iob_count(struct iob_io_info *io, struct gendisk *disk)
+{
+	struct iob_act *act = iob_act_by_id(io->act);
+	unsigned long now = iob_now_usecs();
+	u16 sect = iobc_scale_sect(io->sector, get_capacity(disk));
+	u32 fields[IOBC_NR_FIELDS];
+	u32 *cnts;
+	int i, dir;
+
+	iob_act_mark_used(act);
+
+	/* timestamps may jump backwards, fix up */
+	if (time_before(now, io->issued_at))
+		io->issued_at = now;
+	if (time_before(io->issued_at, io->queued_at))
+		io->queued_at = io->issued_at;
+
+	if (!(io->rw & REQ_WRITE)) {
+		if (io->rw & REQ_RAHEAD)
+			dir = IOBC_RAHEAD;
+		else
+			dir = IOBC_READ;
+	} else
+		dir = IOBC_WRITE;
+
+	fields[IOBC_OFFSET] = sect;
+	fields[IOBC_SIZE] = io->size;
+	fields[IOBC_WAIT_TIME] = io->issued_at - io->queued_at;
+	fields[IOBC_IO_TIME] = now - io->issued_at;
+	fields[IOBC_SEEK_DIST] = abs(sect - disk->iob_scaled_last_sect);
+
+	disk->iob_scaled_last_sect = sect;
+
+	/* all fields ready, find or allocate cnts to update */
+	cnts = act->cnts;
+	if (!cnts) {
+		unsigned long flags;
+
+		cnts = kmem_cache_zalloc(iobc_cnts_cache, GFP_NOIO);
+		if (!cnts) {
+			iob_stats.cnts_nomem++;
+			return;
+		}
+
+		spin_lock_irqsave(&iob_lock, flags);
+		if (!act->cnts) {
+			act->cnts = cnts;
+		} else {
+			kmem_cache_free(iobc_cnts_cache, cnts);
+			cnts = act->cnts;
+		}
+		spin_unlock_irqrestore(&iob_lock, flags);
+	}
+
+	/* let's count */
+	for (i = 0; i < iobc_nr_types; i++) {
+		struct iobc_type *type = &iobc_types[i];
+		struct event_filter *filter = rcu_dereference(type->filter);
+		u32 *b = type->bounds;
+		u32 v = fields[type->field];
+		int slot = -1;
+
+		if (!(type->dir & dir))
+			continue;
+
+		/* if there's filter, run it */
+		if (filter && !filter_match_preds(filter, fields))
+			continue;
+
+		/* open coded binary search to determine histogram slot */
+		if (v < b[4]) {
+			if (v < b[2]) {
+				if (v < b[1]) {
+					if (v >= b[0])
+						slot = 0;
+				} else {
+					slot = 1;
+				}
+			} else {
+				if (v < b[3])
+					slot = 2;
+				else
+					slot = 3;
+			}
+		} else {
+			if (v < b[6]) {
+				if (v < b[5])
+					slot = 4;
+				else
+					slot = 5;
+			} else {
+				if (v < b[7]) {
+					slot = 6;
+				} else {
+					if (!b[8] || v < b[8])
+						slot = 7;
+				}
+			}
+		}
+
+		/*
+		 * Yeah, finally.  Histogram increment is opportunistic and
+		 * racing updates may clobber each other.  Given how act is
+		 * determined, this isn't too likely to happen.  Even when
+		 * it does, as only updates on histogram are increments,
+		 * the deviation should be small.
+		 */
+		if (slot >= 0)
+			cnts[iobc_idx(i, slot)]++;
+	}
+}
+
+/**
+ * iob_disable - disable ioblame
+ *
+ * Master disble.  Stop ioblame, unregister all hooks and free all
+ * resources.
+ */
+static void iob_disable(void)
+{
+	const int gang_nr = 16;
+	unsigned long indices[gang_nr];
+	void **slots[gang_nr];
+	unsigned long base_idx = 0;
+	int i, nr;
+
+	mutex_lock(&iob_mutex);
+
+	if (iob_enabled) {
+		/* if enabled, unregister all hooks */
+		iob_enabled = false;
+		iobc_pipe_opened = false;
+		unregister_trace_vfs_fcheck(iob_probe_vfs_fcheck, NULL);
+		unregister_trace_writeback_dirty_page(iob_probe_wb_dirty_page, NULL);
+		unregister_trace_writeback_start(iob_probe_wb_start, NULL);
+		unregister_trace_writeback_written(iob_probe_wb_written, NULL);
+		unregister_trace_writeback_single_inode_start(iob_probe_wb_single_inode_start, NULL);
+		unregister_trace_writeback_dirty_inode_start(iob_probe_wb_dirty_inode_start, NULL);
+		unregister_trace_writeback_dirty_inode(iob_probe_wb_dirty_inode, NULL);
+		unregister_trace_writeback_write_inode_start(iob_probe_wb_write_inode_start, NULL);
+		unregister_trace_writeback_write_inode(iob_probe_wb_write_inode, NULL);
+		unregister_trace_block_touch_buffer(iob_probe_block_touch_buffer, NULL);
+		unregister_trace_block_bio_queue(iob_probe_block_bio_queue, NULL);
+		unregister_trace_block_bio_backmerge(iob_probe_block_bio_backmerge, NULL);
+		unregister_trace_block_bio_frontmerge(iob_probe_block_bio_frontmerge, NULL);
+		unregister_trace_block_rq_issue(iob_probe_block_rq_issue, NULL);
+		unregister_trace_block_bio_complete(iob_probe_block_bio_complete, NULL);
+		unregister_trace_sched_process_exit(iob_probe_block_sched_process_exit, NULL);
+		/* and drain all in-flight users */
+		tracepoint_synchronize_unregister();
+	}
+
+	/*
+	 * At this point, we're sure that nobody is executing iob hooks.
+	 * Free all resources.
+	 */
+	for (i = 0; i < ARRAY_SIZE(iob_act_used_bitmaps); i++) {
+		vfree(iob_act_used_bitmaps[i]);
+		iob_act_used_bitmaps[i] = NULL;
+	}
+
+	if (iob_role_idx)
+		iob_idx_destroy(iob_role_idx);
+	if (iob_intent_idx)
+		iob_idx_destroy(iob_intent_idx);
+	if (iob_act_idx)
+		iob_idx_destroy(iob_act_idx);
+	iob_role_idx = iob_intent_idx = iob_act_idx = NULL;
+
+	while ((nr = radix_tree_gang_lookup_slot(&iob_pgtree, slots, indices,
+						 base_idx, gang_nr))) {
+		for (i = 0; i < nr; i++) {
+			free_page((unsigned long)*slots[i]);
+			radix_tree_delete(&iob_pgtree, indices[i]);
+		}
+		base_idx = indices[nr - 1] + 1;
+	}
+
+	if (iobc_cnts_cache) {
+		kmem_cache_destroy(iobc_cnts_cache);
+		iobc_cnts_cache = NULL;
+	}
+
+	mutex_unlock(&iob_mutex);
+}
+
+/**
+ * iob_enable - enable ioblame
+ *
+ * Master enable.  Set up all resources and enable ioblame.  Returns 0 on
+ * success, -errno on failure.
+ */
+static int iob_enable(void)
+{
+	int i, err;
+
+	mutex_lock(&iob_mutex);
+
+	if (iob_enabled)
+		goto out;
+
+	/* allocate iobc_cnts cache */
+	err = -ENOMEM;
+	iobc_cnts_cache = kmem_cache_create("iob_counters",
+				iobc_nr_types * IOBC_NR_SLOTS * sizeof(u32),
+				__alignof__(u32), SLAB_HWCACHE_ALIGN, NULL);
+	if (!iobc_cnts_cache)
+		goto out;
+
+	/* determine pgtree params from iob_max_acts */
+	iob_pgtree_shift = iob_max_acts <= USHRT_MAX ? 1 : 2;
+	iob_pgtree_pfn_shift = PAGE_SHIFT - iob_pgtree_shift;
+	iob_pgtree_pfn_mask = (1 << iob_pgtree_pfn_shift) - 1;
+
+	/* create iob_idx'es and allocate act used bitmaps */
+	err = -ENOMEM;
+	iob_role_idx = iob_idx_create(&iob_role_idx_type, iob_max_roles);
+	iob_intent_idx = iob_idx_create(&iob_intent_idx_type, iob_max_intents);
+	iob_act_idx = iob_idx_create(&iob_act_idx_type, iob_max_acts);
+
+	if (!iob_role_idx || !iob_intent_idx || !iob_act_idx)
+		goto out;
+
+	for (i = 0; i < ARRAY_SIZE(iob_act_used_bitmaps); i++) {
+		iob_act_used_bitmaps[i] = vzalloc(sizeof(unsigned long) *
+						  BITS_TO_LONGS(iob_max_acts));
+		if (!iob_act_used_bitmaps[i])
+			goto out;
+	}
+
+	iob_role_reclaim_tstmp = jiffies;
+	iob_act_reclaim_tstmp = jiffies;
+	iob_act_used.cur = iob_act_used_bitmaps[0];
+	iob_act_used.staging = iob_act_used_bitmaps[1];;
+	iob_act_used.front = iob_act_used_bitmaps[2];;
+	iob_act_used.back = iob_act_used_bitmaps[3];;
+
+	/* register hooks */
+	err = register_trace_vfs_fcheck(iob_probe_vfs_fcheck, NULL);
+	if (err)
+		goto out;
+	err = register_trace_writeback_dirty_page(iob_probe_wb_dirty_page, NULL);
+	if (err)
+		goto out;
+	err = register_trace_writeback_start(iob_probe_wb_start, NULL);
+	if (err)
+		goto out;
+	err = register_trace_writeback_written(iob_probe_wb_written, NULL);
+	if (err)
+		goto out;
+	err = register_trace_writeback_single_inode_start(iob_probe_wb_single_inode_start, NULL);
+	if (err)
+		goto out;
+	err = register_trace_writeback_dirty_inode_start(iob_probe_wb_dirty_inode_start, NULL);
+	if (err)
+		goto out;
+	err = register_trace_writeback_dirty_inode(iob_probe_wb_dirty_inode, NULL);
+	if (err)
+		goto out;
+	err = register_trace_writeback_write_inode_start(iob_probe_wb_write_inode_start, NULL);
+	if (err)
+		goto out;
+	err = register_trace_writeback_write_inode(iob_probe_wb_write_inode, NULL);
+	if (err)
+		goto out;
+	err = register_trace_block_touch_buffer(iob_probe_block_touch_buffer, NULL);
+	if (err)
+		goto out;
+	err = register_trace_block_bio_queue(iob_probe_block_bio_queue, NULL);
+	if (err)
+		goto out;
+	err = register_trace_block_bio_backmerge(iob_probe_block_bio_backmerge, NULL);
+	if (err)
+		goto out;
+	err = register_trace_block_bio_frontmerge(iob_probe_block_bio_frontmerge, NULL);
+	if (err)
+		goto out;
+	err = register_trace_block_rq_issue(iob_probe_block_rq_issue, NULL);
+	if (err)
+		goto out;
+	err = register_trace_block_bio_complete(iob_probe_block_bio_complete, NULL);
+	if (err)
+		goto out;
+	err = register_trace_sched_process_exit(iob_probe_block_sched_process_exit, NULL);
+	if (err)
+		goto out;
+
+	/* wait until everything becomes visible */
+	synchronize_sched();
+	/* and go... */
+	iob_enabled = true;
+out:
+	mutex_unlock(&iob_mutex);
+
+	if (iob_enabled)
+		return 0;
+	iob_disable();
+	return err;
+}
+
+/* ioblame/{*_max|ttl_secs} - uint tunables */
+static int iob_uint_get(void *data, u64 *val)
+{
+	*val = *(unsigned int *)data;
+	return 0;
+}
+
+static int __iob_uint_set(void *data, u64 val, bool must_be_disabled)
+{
+	if (val > INT_MAX)
+		return -EINVAL;
+
+	mutex_lock(&iob_mutex);
+	if (must_be_disabled && iob_enabled) {
+		mutex_unlock(&iob_mutex);
+		return -EBUSY;
+	}
+
+	*(unsigned int *)data = val;
+
+	mutex_unlock(&iob_mutex);
+
+	return 0;
+}
+
+/* max params must not be manipulated while enabled */
+static int iob_uint_set_disabled(void *data, u64 val)
+{
+	return __iob_uint_set(data, val, true);
+}
+
+/* ttl can be changed anytime */
+static int iob_uint_set(void *data, u64 val)
+{
+	return __iob_uint_set(data, val, false);
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(iob_uint_fops_disabled, iob_uint_get,
+			iob_uint_set_disabled, "%llu\n");
+DEFINE_SIMPLE_ATTRIBUTE(iob_uint_fops, iob_uint_get, iob_uint_set, "%llu\n");
+
+/* bool - ioblame/ignore_ino, also used for ioblame/enable */
+static ssize_t iob_bool_read(struct file *file, char __user *ubuf,
+			     size_t count, loff_t *ppos)
+{
+	bool *boolp = file->f_dentry->d_inode->i_private;
+	const char *str = *boolp ? "Y\n" : "N\n";
+
+	return simple_read_from_buffer(ubuf, count, ppos, str, strlen(str));
+}
+
+static ssize_t __iob_bool_write(struct file *file, const char __user *ubuf,
+				size_t count, loff_t *ppos, bool *boolp)
+{
+	char buf[32] = { };
+	int err;
+
+	if (copy_from_user(buf, ubuf, min(count, sizeof(buf) - 1)))
+		return -EFAULT;
+
+	err = strtobool(buf, boolp);
+	if (err)
+		return err;
+
+	return err ?: count;
+}
+
+static ssize_t iob_bool_write(struct file *file, const char __user *ubuf,
+			      size_t count, loff_t *ppos)
+{
+	return __iob_bool_write(file, ubuf, count, ppos,
+				file->f_dentry->d_inode->i_private);
+}
+
+static const struct file_operations iob_bool_fops = {
+	.owner		= THIS_MODULE,
+	.open		= nonseekable_open,
+	.read		= iob_bool_read,
+	.write		= iob_bool_write,
+};
+
+/* u64 fops, used for stats */
+static int iob_u64_get(void *data, u64 *val)
+{
+	*val = *(u64 *)data;
+	return 0;
+}
+DEFINE_SIMPLE_ATTRIBUTE(iob_stats_fops, iob_u64_get, NULL, "%llu\n");
+
+/* used to export nr_nodes of each iob_idx */
+static int iob_nr_nodes_get(void *data, u64 *val)
+{
+	struct iob_idx **idxp = data;
+
+	*val = 0;
+	mutex_lock(&iob_mutex);
+	if (*idxp)
+		*val = (*idxp)->nr_nodes;
+	mutex_unlock(&iob_mutex);
+	return 0;
+}
+DEFINE_SIMPLE_ATTRIBUTE(iob_nr_nodes_fops, iob_nr_nodes_get, NULL, "%llu\n");
+
+/*
+ * ioblame/devs - per device enable switch, accepts block device kernel
+ * name, "maj:min" or "*" for all devices.  Prefix '!' to disable.  Opening
+ * w/ O_TRUNC also disables ioblame for all devices.
+ */
+static void iob_enable_all_devs(bool enable)
+{
+	struct disk_iter diter;
+	struct gendisk *disk;
+
+	disk_iter_init(&diter);
+	while ((disk = disk_iter_next(&diter)))
+		disk->iob_enabled = enable;
+	disk_iter_exit(&diter);
+}
+
+static void *iob_devs_seq_start(struct seq_file *seqf, loff_t *pos)
+{
+	loff_t skip = *pos;
+	struct disk_iter *diter;
+	struct gendisk *disk;
+
+	diter = kmalloc(sizeof(*diter), GFP_KERNEL);
+	if (!diter)
+		return ERR_PTR(-ENOMEM);
+
+	seqf->private = diter;
+	disk_iter_init(diter);
+
+	/* skip to the current *pos */
+	do {
+		disk = disk_iter_next(diter);
+		if (!disk)
+			return NULL;
+	} while (skip--);
+
+	/* skip to the first iob_enabled disk */
+	while (disk && !disk->iob_enabled) {
+		(*pos)++;
+		disk = disk_iter_next(diter);
+	}
+
+	return disk;
+}
+
+static void *iob_devs_seq_next(struct seq_file *seqf, void *v, loff_t *pos)
+{
+	/* skip to the next iob_enabled disk */
+	while (true) {
+		struct gendisk *disk;
+
+		(*pos)++;
+		disk = disk_iter_next(seqf->private);
+		if (!disk)
+			return NULL;
+
+		if (disk->iob_enabled)
+			return disk;
+	}
+}
+
+static int iob_devs_seq_show(struct seq_file *seqf, void *v)
+{
+	struct gendisk *disk = v;
+	dev_t dev = disk_devt(disk);
+
+	seq_printf(seqf, "%u:%u %s\n", MAJOR(dev), MINOR(dev),
+		   disk->disk_name);
+	return 0;
+}
+
+static void iob_devs_seq_stop(struct seq_file *seqf, void *v)
+{
+	struct disk_iter *diter = seqf->private;
+
+	/* stop is called even after start failed :-( */
+	if (diter) {
+		disk_iter_exit(diter);
+		kfree(diter);
+	}
+}
+
+static ssize_t iob_devs_write(struct file *file, const char __user *ubuf,
+			      size_t cnt, loff_t *ppos)
+{
+	char *buf = NULL, *p = NULL, *last_tok = NULL, *tok;
+	int err;
+
+	if (!cnt)
+		return 0;
+
+	err = -ENOMEM;
+	buf = vmalloc(cnt + 1);
+	if (!buf)
+		goto out;
+
+	err = -EFAULT;
+	if (copy_from_user(buf, ubuf, cnt))
+		goto out;
+	buf[cnt] = '\0';
+
+	err = 0;
+	p = buf;
+	while ((tok = strsep(&p, " \t\r\n"))) {
+		bool enable = true;
+		int partno = 0;
+		struct gendisk *disk;
+		unsigned maj, min;
+		dev_t devt;
+
+		tok = strim(tok);
+		if (!strlen(tok))
+			continue;
+
+		if (tok[0] == '!') {
+			enable = false;
+			tok++;
+		}
+
+		if (!strcmp(tok, "*")) {
+			iob_enable_all_devs(enable);
+			last_tok = tok;
+			continue;
+		}
+
+		if (sscanf(tok, "%u:%u", &maj, &min) == 2)
+			devt = MKDEV(maj, min);
+		else
+			devt = blk_lookup_devt(tok, 0);
+
+		disk = get_gendisk(devt, &partno);
+		if (!disk || partno) {
+			err = -EINVAL;
+			goto out;
+		}
+
+		disk->iob_enabled = enable;
+		put_disk(disk);
+		last_tok = tok;
+	}
+out:
+	vfree(buf);
+	if (!err)
+		return cnt;
+	if (last_tok)
+		return last_tok + strlen(last_tok) - buf;
+	return err;
+}
+
+static const struct seq_operations iob_devs_sops = {
+	.start		= iob_devs_seq_start,
+	.next		= iob_devs_seq_next,
+	.show		= iob_devs_seq_show,
+	.stop		= iob_devs_seq_stop,
+};
+
+static int iob_devs_seq_open(struct inode *inode, struct file *file)
+{
+	if ((file->f_mode & FMODE_WRITE) && (file->f_flags & O_TRUNC))
+		iob_enable_all_devs(false);
+
+	return seq_open(file, &iob_devs_sops);
+}
+
+static const struct file_operations iob_devs_fops = {
+	.owner		= THIS_MODULE,
+	.open		= iob_devs_seq_open,
+	.read		= seq_read,
+	.write		= iob_devs_write,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
+/*
+ * ioblame/enable - master enable switch
+ */
+static ssize_t iob_enable_write(struct file *file, const char __user *ubuf,
+				size_t count, loff_t *ppos)
+{
+	bool enable;
+	ssize_t ret;
+	int err = 0;
+
+	ret = __iob_bool_write(file, ubuf, count, ppos, &enable);
+	if (ret < 0)
+		return ret;
+
+	if (enable)
+		err = iob_enable();
+	else
+		iob_disable();
+
+	return err ?: ret;
+}
+
+static const struct file_operations iob_enable_fops = {
+	.owner		= THIS_MODULE,
+	.open		= nonseekable_open,
+	.read		= iob_bool_read,
+	.write		= iob_enable_write,
+};
+
+/*
+ * Print helpers.
+ */
+#define iob_print(p, e, fmt, args...)	(p + scnprintf(p, e - p, fmt , ##args))
+
+static char *iob_print_role(char *p, char *e, union iob_id role_id)
+{
+	struct iob_role *role = iob_role_by_id(role_id);
+
+	if (role->pid < 0) {
+		p = iob_print(p, e, "user-%d", -role->pid);
+	} else {
+		struct task_struct *task;
+		int no = role->node.id.f.nr;
+
+		rcu_read_lock_sched();
+		task = pid_task(find_pid_ns(role->pid, &init_pid_ns),
+				PIDTYPE_PID);
+		if (task)
+			p = iob_print(p, e, "pid-%d (%s)",
+				      role->pid, task->comm);
+		else if (no >= 2)
+			p = iob_print(p, e, "pid-%d", role->pid);
+		else
+			p = iob_print(p, e, "%s", no ? "lost" : "nomem");
+		rcu_read_unlock_sched();
+	}
+
+	return p;
+}
+
+static char *iob_print_intent(char *p, char *e, struct iob_intent *intent,
+			      const char *header)
+{
+	int i;
+
+	p = iob_print(p, e, "%s#%d modifier=0x%x\n", header,
+		      intent->node.id.f.nr, intent->modifier);
+	for (i = 0; i < intent->depth; i++)
+		p = iob_print(p, e, "%s[%p] %pF\n", header,
+			      (void *)intent->trace[i],
+			      (void *)intent->trace[i]);
+	return p;
+}
+
+
+/*
+ * ioblame/intents[_bin] - export intents to userland.
+ *
+ * Userland can acquire intents by reading either ioblame/intents or
+ * intents_bin, where the former is human readable text and the latter in
+ * binary format.
+ *
+ * While iob is enabled, intents are never reclaimed, intent nr is
+ * guaranteed to be allocated consecutively in ascending order and both
+ * intents files are lseekable by intent nr, so userland tools which want
+ * to learn about new intents since last reading can simply seek to the
+ * number of currently known intents and start reading from there.
+ */
+static loff_t iob_intents_llseek(struct file *file, loff_t offset, int origin)
+{
+	loff_t ret = -EIO;
+
+	mutex_lock(&iob_mutex);
+
+	if (iob_enabled) {
+		/*
+		 * We seek by intent nr and don't care about i_size.
+		 * Temporarily set i_size to nr_nodes and hitch on generic
+		 * llseek.
+		 */
+		i_size_write(file->f_dentry->d_inode, iob_intent_idx->nr_nodes);
+		ret = generic_file_llseek(file, offset, origin);
+		i_size_write(file->f_dentry->d_inode, 0);
+	}
+
+	mutex_unlock(&iob_mutex);
+	return ret;
+}
+
+static ssize_t iob_intents_read(struct file *file, char __user *ubuf,
+				size_t count, loff_t *ppos)
+{
+	char *buf, *p, *e;
+	int err;
+
+	if (count < PAGE_SIZE)
+		return -EINVAL;
+
+	err = -EIO;
+	mutex_lock(&iob_mutex);
+	if (!iob_enabled)
+		goto out;
+
+	p = buf = iob_page_buf;
+	e = p + PAGE_SIZE;
+
+	err = 0;
+	if (*ppos >= iob_intent_idx->nr_nodes)
+		goto out;
+
+	/* print to buf */
+	rcu_read_lock_sched();
+	p = iob_print_intent(p, e, iob_intent_by_nr(*ppos), "");
+	rcu_read_unlock_sched();
+	WARN_ON_ONCE(p == e);
+
+	/* copy out */
+	err = -EFAULT;
+	if (copy_to_user(ubuf, buf, p - buf))
+		goto out;
+
+	(*ppos)++;
+	err = 0;
+out:
+	mutex_unlock(&iob_mutex);
+	return err ?: p - buf;
+}
+
+static ssize_t iob_intents_read_bin(struct file *file, char __user *ubuf,
+				    size_t count, loff_t *ppos)
+{
+	static struct {
+		struct iob_intent_bin_record r;
+		uint64_t s[IOB_STACK_MAX_DEPTH];
+	} rec_buf = { .r.ver = IOB_INTENTS_BIN_VER };
+	struct iob_intent_bin_record *rec = &rec_buf.r;
+	char __user *up = ubuf, __user *ue = ubuf + count;
+	int nr, err = 0;
+
+	mutex_lock(&iob_mutex);
+	if (!iob_enabled) {
+		err = -EIO;
+		goto out;
+	}
+
+	/* for each intent */
+	for (nr = *ppos; nr < iob_intent_idx->nr_nodes; nr++) {
+		struct iob_intent *intent;
+		size_t tlen;
+
+		/* print to buf */
+		rcu_read_lock_sched();
+
+		intent = iob_intent_by_nr(nr);
+		tlen = sizeof(rec->trace[0]) * intent->depth;
+
+		rec->len = offsetof(struct iob_intent_bin_record, trace) + tlen;
+		rec->nr = intent->node.id.f.nr;
+		rec->modifier = intent->modifier;
+		memcpy(rec->trace, intent->trace, tlen);
+
+		rcu_read_unlock_sched();
+
+		/* copy out */
+		if (ue - up < rec->len)
+			break;
+
+		if (copy_to_user(up, &rec, rec->len)) {
+			err = -EFAULT;
+			break;
+		}
+		up += rec->len;
+		*ppos = nr + 1;
+	}
+out:
+	mutex_unlock(&iob_mutex);
+
+	if (err && up == ubuf)
+		return err;
+	return up - ubuf;
+}
+
+static const struct file_operations iob_intents_fops = {
+	.owner		= THIS_MODULE,
+	.open		= generic_file_open,
+	.llseek		= iob_intents_llseek,
+	.read		= iob_intents_read,
+};
+
+static const struct file_operations iob_intents_bin_fops = {
+	.owner		= THIS_MODULE,
+	.open		= generic_file_open,
+	.llseek		= iob_intents_llseek,
+	.read		= iob_intents_read_bin,
+};
+
+/*
+ * ioblame/counters_pipe[_bin] - export counters to userland and reclaim acts.
+ *
+ * Userland can acquire dirty counters by reading either
+ * ioblame/counters_pipe or counters_pipe_bin, where the former is human
+ * readable text and the latter in binary format.
+ *
+ * As acts can't be reclaimed with dirty counters, accessing counters also
+ * triggers reclaim.  Opening any of the two couters_pipe files switches
+ * the current used bitmap with staging and closing folds staging into
+ * front bitmap and the rest of reclaim starts.
+ *
+ * Each open-(N*read)-close cycle clears dirtiness on all counters whether
+ * all the counters were read or not and concurrent accesses to
+ * counters_pipe files aren't allowed.
+ *
+ * Note that cnts of all acts which have been used are reported whether
+ * cnts themselves have been updated or not.  ie. Counters which haven't
+ * changed since last read might be reported again.
+ */
+
+static int iobc_pipe_open(struct inode *inode, struct file *filp)
+{
+	int ret = -EIO;
+
+	mutex_lock(&iob_mutex);
+
+	/* only one opener, opened is cleared on release or iob_disable() */
+	if (iob_enabled && !iobc_pipe_opened) {
+		/* switch used and staging */
+		iob_switch_act_used_cur();
+		iobc_pipe_opened = true;
+		ret = 0;
+	}
+
+	mutex_unlock(&iob_mutex);
+	return ret;
+}
+
+static loff_t iobc_pipe_llseek(struct file *file, loff_t offset, int origin)
+{
+	loff_t ret;
+
+	/*
+	 * We seek by act nr and don't care about i_size.  Temporarily set
+	 * i_size to iob_max_acts and hitch on generic llseek.
+	 */
+	i_size_write(file->f_dentry->d_inode, iob_max_acts);
+	ret = generic_file_llseek(file, offset, origin);
+	i_size_write(file->f_dentry->d_inode, 0);
+
+	return ret;
+}
+
+static ssize_t iobc_pipe_read(struct file *file, char __user *ubuf,
+			      size_t count, loff_t *ppos)
+{
+	unsigned long *bitmap = iob_act_used.staging;
+	unsigned long bit = *ppos;
+	struct iob_act *act;
+	struct iob_intent *intent;
+	char *buf, *p, *e;
+	int i, j, err;
+
+	if (count < PAGE_SIZE)
+		return -EINVAL;
+
+	err = -EIO;
+	mutex_lock(&iob_mutex);
+	if (!iobc_pipe_opened)
+		goto out;
+
+	p = buf = iob_page_buf;
+	e = p + PAGE_SIZE;
+
+	rcu_read_lock_sched();
+
+	/* find the next used act w/ cnts */
+	while (true) {
+		err = 0;
+		bit = find_next_bit(bitmap, iob_max_acts, bit);
+		if (bit >= iob_max_acts) {
+			rcu_read_unlock_sched();
+			goto out;
+		}
+		act = iob_act_by_nr(bit);
+		if (act->cnts)
+			break;
+		bit++;
+	}
+
+	/* print to buf */
+	intent = iob_intent_by_id(act->intent);
+
+	p = iob_print_role(p, e, act->role);
+	p = iob_print(p, e, " int=%u dev=0x%x ino=0x%lx gen=0x%x\n",
+		      intent->node.id.f.nr, act->dev, act->ino, act->gen);
+
+	for (i = 0; i < iobc_nr_types; i++) {
+		p = iob_print(p, e, " ");
+		for (j = 0; j < IOBC_NR_SLOTS; j++)
+			p = iob_print(p, e, " %7d", act->cnts[iobc_idx(i, j)]);
+		p = iob_print(p, e, "\n");
+	}
+
+	rcu_read_unlock_sched();
+
+	/* copy out */
+	err = -EFAULT;
+	if (copy_to_user(ubuf, buf, p - buf))
+		goto out;
+
+	*ppos = bit + 1;
+	err = 0;
+out:
+	mutex_unlock(&iob_mutex);
+	return err ?: p - buf;
+}
+
+static ssize_t iobc_pipe_read_bin(struct file *file, char __user *ubuf,
+				  size_t count, loff_t *ppos)
+{
+	unsigned long *bitmap = iob_act_used.staging;
+	char __user *up = ubuf, __user *ue = ubuf + count;
+	struct iobc_pipe_bin_record *rec;
+	size_t reclen;
+	int i, j, bit, err;
+
+	/* sanity checks */
+	reclen = sizeof(struct iobc_pipe_bin_record) +
+		iobc_nr_types * IOBC_NR_SLOTS * sizeof(u32);
+	if (reclen > PAGE_SIZE) {
+		pr_err_once("ioblame: doesn't support bin counter reads larger than PAGE_SIZE");
+		return -EINVAL;
+	}
+	if (reclen > count)
+		return -EOVERFLOW;
+
+	err = -EIO;
+	mutex_lock(&iob_mutex);
+	if (!iobc_pipe_opened)
+		goto out;
+
+	rec = (void *)iob_page_buf;
+	memset(rec, 0, sizeof(*rec));
+	rec->ver = IOBC_PIPE_BIN_VER;
+	rec->len = reclen;
+
+	bit = *ppos;
+	do {
+		struct iob_act *act;
+		struct iob_role *role;
+
+		/* for each used act w/ cnts */
+		bit = find_next_bit(bitmap, iob_max_acts, bit);
+		if (bit >= iob_max_acts)
+			break;
+
+		rcu_read_lock_sched();
+
+		act = iob_act_by_nr(bit);
+		if (!act->cnts) {
+			rcu_read_unlock_sched();
+			goto next;
+		}
+
+		role = iob_role_by_id(act->role);
+
+		/* fill in @rec */
+		rec->id = role->pid;
+		rec->intent_nr = act->intent.f.nr;
+		rec->dev = act->dev;
+		rec->ino = act->ino;
+		rec->gen = act->gen;
+
+		/* @act->cnts is transposed, transpose it back for userland */
+		for (i = 0; i < iobc_nr_types; i++)
+			for (j = 0; j < IOBC_NR_SLOTS; j++)
+				rec->cnts[i * IOBC_NR_SLOTS + j] =
+					act->cnts[iobc_idx(i, j)];
+		rcu_read_unlock_sched();
+
+		/* copy out */
+		err = -EFAULT;
+		if (copy_to_user(up, rec, rec->len))
+			goto out;
+		up += reclen;
+	next:
+		*ppos = ++bit;
+	} while (up + reclen <= ue);
+
+	err = 0;
+out:
+	mutex_unlock(&iob_mutex);
+
+	if (err && up == ubuf)
+		return err;
+	return up - ubuf;
+}
+
+static int iobc_pipe_release(struct inode *inode, struct file *file)
+{
+	mutex_lock(&iob_mutex);
+	if (iobc_pipe_opened) {
+		/* all used acts are reported, trigger reclaim */
+		iob_reclaim();
+		iobc_pipe_opened = false;
+	}
+	mutex_unlock(&iob_mutex);
+	return 0;
+}
+
+static const struct file_operations iobc_pipe_fops = {
+	.owner		= THIS_MODULE,
+	.open		= iobc_pipe_open,
+	.llseek		= iobc_pipe_llseek,
+	.read		= iobc_pipe_read,
+	.release	= iobc_pipe_release,
+};
+
+static const struct file_operations iobc_pipe_bin_fops = {
+	.owner		= THIS_MODULE,
+	.open		= iobc_pipe_open,
+	.llseek		= iobc_pipe_llseek,
+	.read		= iobc_pipe_read_bin,
+	.release	= iobc_pipe_release,
+};
+
+/*
+ * ioblame/iolog - debug pipe which dumps every iob_io_info on bio completion
+ */
+static void iob_iolog_fill(struct iob_io_info *io)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&iob_iolog_lock, flags);
+
+	iob_iolog[iob_iolog_head] = *io;
+
+	/* if was empty, wake up consumer */
+	if (iob_iolog_head == iob_iolog_tail)
+		wake_up(&iob_iolog_wait);
+
+	iob_iolog_head = (iob_iolog_head + 1) % IOB_IOLOG_CNT;
+
+	/* if full, forget the oldest entry */
+	if (iob_iolog_head == iob_iolog_tail) {
+		iob_iolog_tail = (iob_iolog_tail + 1) % IOB_IOLOG_CNT;
+		iob_stats.iolog_overflow++;
+	}
+
+	spin_unlock_irqrestore(&iob_iolog_lock, flags);
+}
+
+static int iob_iolog_consume(struct iob_io_info *io)
+{
+	unsigned long flags;
+	int ret;
+retry:
+	ret = wait_event_interruptible(iob_iolog_wait,
+				       iob_iolog_head != iob_iolog_tail);
+	if (ret)
+		return ret;
+
+	spin_lock_irqsave(&iob_iolog_lock, flags);
+
+	if (iob_iolog_head == iob_iolog_tail) {
+		spin_unlock_irqrestore(&iob_iolog_lock, flags);
+		goto retry;
+	}
+
+	*io = iob_iolog[iob_iolog_tail];
+	iob_iolog_tail = (iob_iolog_tail + 1) % IOB_IOLOG_CNT;
+
+	spin_unlock_irqrestore(&iob_iolog_lock, flags);
+
+	return 0;
+}
+
+static int iob_iolog_open(struct inode *inode, struct file *file)
+{
+	int ret;
+
+	mutex_lock(&iob_mutex);
+
+	ret = nonseekable_open(inode, file);
+	if (ret)
+		goto out_unlock;
+
+	ret = -EBUSY;
+	if (iob_iolog)
+		goto out_unlock;
+
+	ret = -ENOMEM;
+	iob_iolog = vzalloc(sizeof(iob_iolog[0]) * IOB_IOLOG_CNT);
+	if (!iob_iolog)
+		goto out_unlock;
+
+	iob_iolog_buf = (void *)__get_free_page(GFP_KERNEL);
+	if (!iob_iolog_buf) {
+		vfree(iob_iolog);
+		goto out_unlock;
+	}
+
+	ret = 0;
+out_unlock:
+	mutex_unlock(&iob_mutex);
+	return ret;
+}
+
+static ssize_t iob_iolog_read(struct file *file, char __user *ubuf,
+			      size_t len, loff_t *ppos)
+{
+	char *p = iob_iolog_buf;
+	char *e = p + PAGE_SIZE;
+	struct iob_io_info io;
+	struct iob_act *act;
+	int ret;
+
+	if (len < PAGE_SIZE)
+		return -EINVAL;
+
+	ret = iob_iolog_consume(&io);
+	if (ret)
+		return ret;
+
+	rcu_read_lock_sched();
+	if (!iob_enabled) {
+		rcu_read_unlock_sched();
+		return -EIO;
+	}
+
+	act = iob_act_by_id(io.act);
+
+	p = iob_print(p, e, "%c %u @ %llu ", io.rw & REQ_WRITE ? 'W' : 'R',
+		      io.size, (unsigned long long)io.sector);
+	p = iob_print_role(p, e, act->role);
+	p = iob_print(p, e, " dev=0x%x ino=0x%lx gen=0x%x\n",
+		      act->dev, act->ino, act->gen);
+	p = iob_print_intent(p, e, iob_intent_by_id(act->intent), "  ");
+
+	rcu_read_unlock_sched();
+
+	ret = p - iob_iolog_buf;
+	if (copy_to_user(ubuf, iob_iolog_buf, ret))
+		return -EFAULT;
+	return ret;
+}
+
+static int iob_iolog_release(struct inode *inode, struct file *file)
+{
+	struct iob_io_info *iolog = iob_iolog;
+
+	mutex_lock(&iob_mutex);
+
+	iob_iolog = NULL;
+	synchronize_sched();
+
+	vfree(iolog);
+	free_page((unsigned long)iob_iolog_buf);
+	iob_iolog_head = iob_iolog_tail = 0;
+	iob_iolog_buf = NULL;
+
+	mutex_unlock(&iob_mutex);
+	return 0;
+}
+
+static const struct file_operations iob_iolog_fops = {
+	.owner		= THIS_MODULE,
+	.open		= iob_iolog_open,
+	.read		= iob_iolog_read,
+	.release	= iob_iolog_release,
+};
+
+static int __init ioblame_init(void)
+{
+	struct dentry *stats_dir;
+	int i;
+
+	BUILD_BUG_ON((1 << IOB_TYPE_BITS) < IOB_NR_TYPES);
+	BUILD_BUG_ON(IOB_NR_BITS + IOB_GEN_BITS + IOB_TYPE_BITS != 64);
+
+	iob_role_cache = KMEM_CACHE(iob_role, 0);
+	iob_act_cache = KMEM_CACHE(iob_act, 0);
+	if (!iob_role_cache || !iob_act_cache)
+		goto fail;
+
+	/* build iobc_event_fields list, used to parse filters */
+	for (i = 0; i < IOBC_NR_FIELDS; i++) {
+		struct ftrace_event_field *f = &iobc_event_fields[i];
+
+		f->name = iobc_field_strs[i];
+		f->filter_type = FILTER_OTHER;
+		f->offset = i * sizeof(u32);
+		f->size = sizeof(u32);
+		f->is_signed = 0;
+
+		list_add_tail(&f->link, &iobc_event_field_list);
+	}
+
+	/* create ioblame/ dirs and files */
+	iob_dir = debugfs_create_dir("ioblame", NULL);
+	if (!iob_dir)
+		goto fail;
+
+	if (!debugfs_create_file("max_roles", 0600, iob_dir, &iob_max_roles, &iob_uint_fops_disabled) ||
+	    !debugfs_create_file("max_intents", 0600, iob_dir, &iob_max_intents, &iob_uint_fops_disabled) ||
+	    !debugfs_create_file("max_acts", 0600, iob_dir, &iob_max_acts, &iob_uint_fops_disabled) ||
+	    !debugfs_create_file("ttl_secs", 0600, iob_dir, &iob_ttl_secs, &iob_uint_fops) ||
+	    !debugfs_create_file("ignore_ino", 0600, iob_dir, &iob_ignore_ino, &iob_bool_fops) ||
+	    !debugfs_create_file("devs", 0600, iob_dir, NULL, &iob_devs_fops) ||
+	    !debugfs_create_file("intents", 0400, iob_dir, NULL, &iob_intents_fops) ||
+	    !debugfs_create_file("intents_bin", 0400, iob_dir, NULL, &iob_intents_bin_fops) ||
+	    !debugfs_create_file("nr_counters", 0600, iob_dir, NULL, &iobc_nr_types_fops) ||
+	    !debugfs_create_file("counters_pipe", 0200, iob_dir, NULL, &iobc_pipe_fops) ||
+	    !debugfs_create_file("counters_pipe_bin", 0200, iob_dir, NULL, &iobc_pipe_bin_fops) ||
+	    !debugfs_create_file("iolog", 0600, iob_dir, NULL, &iob_iolog_fops) ||
+	    !debugfs_create_file("enable", 0600, iob_dir, &iob_enabled, &iob_enable_fops) ||
+	    !debugfs_create_file("nr_roles", 0400, iob_dir, &iob_role_idx, &iob_nr_nodes_fops) ||
+	    !debugfs_create_file("nr_intents", 0400, iob_dir, &iob_intent_idx, &iob_nr_nodes_fops) ||
+	    !debugfs_create_file("nr_acts", 0400, iob_dir, &iob_act_idx, &iob_nr_nodes_fops))
+		goto fail;
+
+	stats_dir = debugfs_create_dir("stats", iob_dir);
+	if (!stats_dir)
+		goto fail;
+	if (!debugfs_create_file("idx_nomem", 0400, stats_dir, &iob_stats.idx_nomem, &iob_stats_fops) ||
+	    !debugfs_create_file("idx_nospc", 0400, stats_dir, &iob_stats.idx_nospc, &iob_stats_fops) ||
+	    !debugfs_create_file("node_nomem", 0400, stats_dir, &iob_stats.node_nomem, &iob_stats_fops) ||
+	    !debugfs_create_file("pgtree_nomem", 0400, stats_dir, &iob_stats.pgtree_nomem, &iob_stats_fops) ||
+	    !debugfs_create_file("cnts_nomem", 0400, stats_dir, &iob_stats.cnts_nomem, &iob_stats_fops) ||
+	    !debugfs_create_file("iolog_overflow", 0400, stats_dir, &iob_stats.iolog_overflow, &iob_stats_fops))
+		goto fail;
+
+	return 0;
+
+fail:
+	if (iob_role_cache)
+		kmem_cache_destroy(iob_role_cache);
+	if (iob_act_cache)
+		kmem_cache_destroy(iob_act_cache);
+	if (iob_dir)
+		debugfs_remove_recursive(iob_dir);
+	return -ENOMEM;
+}
+
+static void __exit ioblame_exit(void)
+{
+	iob_disable();
+	debugfs_remove_recursive(iob_dir);
+	kmem_cache_destroy(iob_role_cache);
+	kmem_cache_destroy(iob_act_cache);
+}
+
+module_init(ioblame_init);
+module_exit(ioblame_exit);
+
+MODULE_AUTHOR("Tejun Heo <tj@kernel.org>");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("IO monitor with dirtier and issuer tracking");
-- 
1.7.3.1

