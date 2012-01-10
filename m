Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab2AJS3M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 13:29:12 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52173 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759Ab2AJS3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 13:29:02 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, mingo@redhat.com, rostedt@goodmis.org, fweisbec@gmail.com,
        teravest@google.com, slavapestov@google.com, ctalbott@google.com,
        dhsharp@google.com
Cc: linux-kernel@vger.kernel.org, winget@google.com, namhyung@gmail.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 9/9] block, trace: implement ioblame - IO tracer with origin tracking
Date: Tue, 10 Jan 2012 10:28:26 -0800
Message-Id: <1326220106-5765-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1326220106-5765-1-git-send-email-tj@kernel.org>
References: <1326220106-5765-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement ioblame, which can attribute each IO to its origin and
export the information using a tracepoint.

Operations which may eventually cause IOs and IO operations themselves
are identified and tracked primarily by their stack traces along with
the task and the target file (dev:ino:gen).  On each IO completion,
ioblame knows why that specific IO happened and exports the
information via ioblame:ioblame_io tracepoint.

While ioblame adds fields to a few fs and block layer objects, all
logic is well insulated inside ioblame proper and all hooking goes
through well defined tracepoints and doesn't add any significant
maintenance overhead.

For details, please read Documentation/trace/ioblame.txt.

-v2: Namhyung pointed out that all the information available at IO
     completion can be exported via tracepoint and letting userland do
     whatever it wants to do with that would be better.  Stripped out
     in-kernel statistics gathering.

     Now that everything is exported through tracepoint, iolog and
     counters_pipe[_pipe] are unnecessary.  Removed.  intents_bin too
     is removed.

     As data collection no longer requires polling, ioblame/intents is
     updated to generate inotify IN_MODIFY event after a new intent is
     created.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Justin TerAvest <teravest@google.com>
Cc: Slava Pestov <slavapestov@google.com>
Cc: David Sharp <dhsharp@google.com>
Cc: Jim Winget <winget@google.com>
---
 Documentation/trace/ioblame.txt |  476 ++++++++
 include/linux/blk_types.h       |    4 +
 include/linux/fs.h              |    3 +
 include/linux/genhd.h           |    3 +
 include/linux/ioblame.h         |   72 ++
 kernel/trace/Kconfig            |   12 +
 kernel/trace/Makefile           |    1 +
 kernel/trace/ioblame.c          | 2279 +++++++++++++++++++++++++++++++++++++++
 8 files changed, 2850 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/trace/ioblame.txt
 create mode 100644 include/linux/ioblame.h
 create mode 100644 kernel/trace/ioblame.c

diff --git a/Documentation/trace/ioblame.txt b/Documentation/trace/ioblame.txt
new file mode 100644
index 0000000..cd72f29
--- /dev/null
+++ b/Documentation/trace/ioblame.txt
@@ -0,0 +1,476 @@
+
+ioblame - IO tracer with origin tracking
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
+3-2. Stats and intents
+4. Trace examples
+5. Notes
+6. Overheads
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
+ioblame is IO tracer which tracks origin of each IO.  It keeps track
+of who dirtied pages and inodes, and, on an actual IO, attributes it
+to the originator of the IO.  All the information ioblame collects is
+exported via ioblame:ioblame_io tracepoint on each IO completion.
+
+The design goals of ioblame are
+
+* Minimally invasive - Tracer shouldn't be invasive.  Except for
+  adding some fields to mostly block layer data structures for
+  tracking, ioblame gathers all information through well defined
+  tracepoints and all tracking logic is contained in ioblame proper.
+
+* Generic and detailed - There are many different IO paths and
+  filesystems which also go through changes regularly.  Tracer should
+  be able to report detailed enough result covering most cases without
+  requiring frequent adaptation.  ioblame uses stack trace at key
+  points combined information from generic layers to categorize IOs.
+  This gives detailed enough information into varying IO paths without
+  requiring specific adaptations.
+
+* Low overhead - Overhead both in terms of memory and processor cycles
+  should be low enough so that the analyzer can be used in IO-heavy
+  production environments.  ioblame keeps hot data structures compact
+  and mostly read-only and avoids synchronization on hot paths by
+  using RCU and taking advantage of the fact that statistics doesn't
+  have to be completely accurate.
+
+
+2. Overall design
+
+ioblame tracks the following three object types.
+
+* Role: This tracks 'who' is taking an action.  Corresponds to a
+  thread.
+
+* Intent: Stack trace + modifier.  An intent groups actions of the
+  same type.  As the name suggests, modifier modifies the intent and
+  there can be multiple intents with the same stack trace but
+  different modifiers.  Currently, only writeback modifiers are
+  implemented which denote why the writeback action is occurring -
+  ie. wb_reason.
+
+* Act: This is combination of role, intent and the inode being
+  operated.  This is not visible to userland and used internally to
+  track dirtier and its intent in compact form.
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
+On each IO completion, ioblame knows the offset and size of the IO,
+who's responsible and its intent, how long it took in the queue and
+the target file.  This information is reported via ioblame:ioblame_io
+tracepoint.
+
+Except for the tracepoint, all interactions happen using files under
+/sys/kernel/debug/ioblame/.
+
+
+3. Debugfs interface
+
+3-1. Configuration
+
+* enable			- can be changed anytime
+
+  Master enable.  Write [Yy1] to enable, [Nn0] to disable.
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
+
+3-2. Stats and intents (read only)
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
+* intents
+
+  Dump of intents.
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
+  At least one inotify IN_MODIFY event is generated after a new intent
+  is created.
+
+
+4. Trace examples
+
+All information ioblame gathers is available through
+ioblame:ioblame_io tracing event.  The outputs in the following
+examples are reformatted and annoated.
+
+4-1. ls, touch and sync - on an ext4 FS w/o journal
+
+- sector=69896 size=4096 rw=META|PRIO wait_nsec=45244 io_nsec=11263878
+  pid=952 intent=8 dev=8:17 ino=2 gen=0
+
+  pid 952 (ls) issues 4k META|PRIO read on /dev/sdb1's root directory
+  with intent 8 to read directory entries.
+
+  #8 modifier=0x0
+  [ffffffff813981b8] generic_make_request+0x18/0x100
+  [ffffffff81398314] submit_bio+0x74/0x100
+  [ffffffff811c6b9b] submit_bh+0xeb/0x130
+  [ffffffff811c851e] ll_rw_block+0xae/0xb0
+  [ffffffff81265703] ext4_bread+0x43/0x80
+  [ffffffff8126b458] htree_dirblock_to_tree+0x38/0x190
+  [ffffffff8126b655] ext4_htree_fill_tree+0xa5/0x260
+  [ffffffff81259c76] ext4_readdir+0x116/0x5e0
+  [ffffffff811a7ec0] vfs_readdir+0xb0/0xd0
+  [ffffffff811a8049] sys_getdents+0x89/0xf0
+  [ffffffff81aaca6b] system_call_fastpath+0x16/0x1b
+
+- sector=4232 size=4096 rw= wait_nsec=69052 io_nsec=475710
+  pid=953 intent=14 dev=8:16 ino=0 gen=0
+
+  pid 953 (touch) issues 4k read with intent 14 during open(2).
+
+  #14 modifier=0x0
+  [ffffffff813981b8] generic_make_request+0x18/0x100
+  [ffffffff81398314] submit_bio+0x74/0x100
+  [ffffffff811c6b9b] submit_bh+0xeb/0x130
+  [ffffffff811c8425] bh_submit_read+0x35/0x80
+  [ffffffff8125b29b] ext4_read_inode_bitmap+0x18b/0x3f0
+  [ffffffff8125bf85] ext4_new_inode+0x355/0x10b0
+  [ffffffff81269a7a] ext4_create+0x9a/0x120
+  [ffffffff811a366c] vfs_create+0x8c/0xe0
+  [ffffffff811a4616] do_last+0x776/0x8e0
+  [ffffffff811a4858] path_openat+0xd8/0x410
+  [ffffffff811a4ca9] do_filp_open+0x49/0xa0
+  [ffffffff811926a7] do_sys_open+0x107/0x1e0
+  [ffffffff811927c0] sys_open+0x20/0x30
+  [ffffffff81aaca6b] system_call_fastpath+0x16/0x1b
+
+- sector=4360 size=4096 rw=WRITE wait_nsec=28998035 io_nsec=768370
+  pid=953 intent=11 dev=8:17 ino=14 gen=3151897938
+
+  touch dirtied inode 14 and the following sync forces writeback.
+  The IO is attributed to the dirtier.  Note the non-zero modifier is
+  indicating WB_REASON_SYNC.
+
+  #11 modifier=0x10000002
+  [ffffffff811c0710] __mark_inode_dirty+0x220/0x330
+  [ffffffff8125feeb] ext4_setattr+0x26b/0x4d0
+  [ffffffff811b0f2a] notify_change+0x10a/0x2b0
+  [ffffffff811c52de] utimes_common+0xde/0x190
+  [ffffffff811c5431] do_utimes+0xa1/0xf0
+  [ffffffff811c55a6] sys_utimensat+0x36/0xb0
+  [ffffffff81aaca6b] system_call_fastpath+0x16/0x1b
+
+
+4-2. copying a 1M file from another filesystem and waiting a bit
+
+- sector=2056 size=4096 rw=WRITE wait_nsec=151425 io_nsec=584466
+  pid=1004 intent=24 dev=8:16 ino=0 gen=0
+
+  flush-8:16 starting writeback w/ WB_REASON_BACKGROUND.  This
+  repeats a couple times.
+
+  #24 modifier=0x10000000
+  [ffffffff813981b8] generic_make_request+0x18/0x100
+  [ffffffff81398314] submit_bio+0x74/0x100
+  [ffffffff811c6b9b] submit_bh+0xeb/0x130
+  [ffffffff811ca410] __block_write_full_page+0x210/0x3b0
+  [ffffffff811ca6a0] block_write_full_page_endio+0xf0/0x140
+  [ffffffff811ca705] block_write_full_page+0x15/0x20
+  [ffffffff811ce438] blkdev_writepage+0x18/0x20
+  [ffffffff81148f1a] __writepage+0x1a/0x50
+  [ffffffff81149ae6] write_cache_pages+0x206/0x4f0
+  [ffffffff81149e24] generic_writepages+0x54/0x80
+  [ffffffff81149e74] do_writepages+0x24/0x40
+  [ffffffff811bf301] writeback_single_inode+0x1a1/0x600
+  [ffffffff811c01db] writeback_sb_inodes+0x1ab/0x280
+  [ffffffff811c0b8e] __writeback_inodes_wb+0x9e/0xd0
+  [ffffffff811c0ea3] wb_writeback+0x243/0x3a0
+  [ffffffff811c115a] wb_do_writeback+0x15a/0x2b0
+  [ffffffff811c138a] bdi_writeback_thread+0xda/0x330
+  [ffffffff810bc286] kthread+0xb6/0xc0
+  [ffffffff81aadff4] kernel_thread_helper+0x4/0x10
+
+- sector=4360 size=4096 rw=WRITE wait_nsec=781396 io_nsec=894147
+  pid=1017 intent=25 dev=8:17 ino=12 gen=3151897939
+
+  Writeback got to inode 12 which was created and written to by cp.
+  This is inode writeback.
+
+  #25 modifier=0x10000000
+  [ffffffff811c0710] __mark_inode_dirty+0x220/0x330
+  [ffffffff811c7e5b] generic_write_end+0x6b/0xa0
+  [ffffffff8126191a] ext4_da_write_end+0xfa/0x350
+  [ffffffff8113f168] generic_file_buffered_write+0x188/0x2b0
+  [ffffffff81141608] __generic_file_aio_write+0x238/0x460
+  [ffffffff811418a8] generic_file_aio_write+0x78/0xf0
+  [ffffffff8125a4cf] ext4_file_write+0x6f/0x2a0
+  [ffffffff81194112] do_sync_write+0xe2/0x120
+  [ffffffff81194c08] vfs_write+0xc8/0x180
+  [ffffffff81194dc1] sys_write+0x51/0x90
+  [ffffffff81aaca6b] system_call_fastpath+0x16/0x1b
+
+- sector=268288 size=524288 rw=WRITE wait_nsec=461543 io_nsec=3180190
+  pid=1017 intent=27 dev=8:17 ino=12 gen=3151897939
+
+  The first half of data.
+
+  #27 modifier=0x10000000
+  [ffffffff811c79cc] __set_page_dirty+0x4c/0xd0
+  [ffffffff811c7ab6] mark_buffer_dirty+0x66/0xa0
+  [ffffffff811c7b99] __block_commit_write+0xa9/0xe0
+  [ffffffff811c7da2] block_write_end+0x42/0x90
+  [ffffffff811c7e23] generic_write_end+0x33/0xa0
+  [ffffffff8126191a] ext4_da_write_end+0xfa/0x350
+  [ffffffff8113f168] generic_file_buffered_write+0x188/0x2b0
+  [ffffffff81141608] __generic_file_aio_write+0x238/0x460
+  [ffffffff811418a8] generic_file_aio_write+0x78/0xf0
+  [ffffffff8125a4cf] ext4_file_write+0x6f/0x2a0
+  [ffffffff81194112] do_sync_write+0xe2/0x120
+  [ffffffff81194c08] vfs_write+0xc8/0x180
+  [ffffffff81194dc1] sys_write+0x51/0x90
+  [ffffffff81aaca6b] system_call_fastpath+0x16/0x1b
+
+- sector=269312 size=524288 rw=WRITE wait_nsec=364198 io_nsec=5667553
+  pid=1017 intent=27 dev=8:17 ino=12 gen=3151897939
+
+  And the second half.
+
+
+4-3. dd if=/dev/zero of=testfile bs=128k count=4 oflag=direct
+
+- sector=266496 size=131072 rw=WRITE|SYNC wait_nsec=48180 io_nsec=1066758
+  pid=1042 intent=34 dev=8:17 ino=12 gen=3151897940
+
+  First chunk.
+
+  #34 modifier=0x0
+  [ffffffff813981b8] generic_make_request+0x18/0x100
+  [ffffffff81398314] submit_bio+0x74/0x100
+  [ffffffff811d1c45] __blockdev_direct_IO+0x21b5/0x3830
+  [ffffffff8129a7a1] ext4_ind_direct_IO+0x121/0x470
+  [ffffffff812612ee] ext4_direct_IO+0x23e/0x400
+  [ffffffff81141308] generic_file_direct_write+0xc8/0x190
+  [ffffffff811416ab] __generic_file_aio_write+0x2db/0x460
+  [ffffffff811418a8] generic_file_aio_write+0x78/0xf0
+  [ffffffff8125a4cf] ext4_file_write+0x6f/0x2a0
+  [ffffffff81194112] do_sync_write+0xe2/0x120
+  [ffffffff81194c08] vfs_write+0xc8/0x180
+  [ffffffff81194dc1] sys_write+0x51/0x90
+  [ffffffff81aaca6b] system_call_fastpath+0x16/0x1b
+
+- sector=266752 size=131072 rw=WRITE|SYNC wait_nsec=15155 io_nsec=1086987
+  pid=1042 intent=34 dev=8:17 ino=12 gen=3151897940
+
+  Second.
+
+- sector=267008 size=131072 rw=WRITE|SYNC wait_nsec=22694 io_nsec=1092836
+  pid=1042 intent=34 dev=8:17 ino=12 gen=3151897940
+
+  Third.
+
+- sector=267264 size=131072 rw=WRITE|SYNC wait_nsec=15852 io_nsec=1021868
+  pid=1042 intent=34 dev=8:17 ino=12 gen=3151897940
+
+  Fourth.
+
+...
+
+- sector=4360 size=4096 rw=WRITE wait_nsec=1378342 io_nsec=828771
+  pid=1042 intent=35 dev=8:17 ino=12 gen=3151897940
+
+  After a while, inode is written back with WB_REASON_PERIODIC.
+
+  #35 modifier=0x10000003
+  [ffffffff811c0710] __mark_inode_dirty+0x220/0x330
+  [ffffffff8129611a] ext4_mb_new_blocks+0xea/0x5a0
+  [ffffffff8128b22e] ext4_ext_map_blocks+0x1c0e/0x1d80
+  [ffffffff812638d1] ext4_map_blocks+0x1b1/0x260
+  [ffffffff81263a28] _ext4_get_block+0xa8/0x160
+  [ffffffff81263b46] ext4_get_block+0x16/0x20
+  [ffffffff811d0460] __blockdev_direct_IO+0x9d0/0x3830
+  [ffffffff8129a7a1] ext4_ind_direct_IO+0x121/0x470
+  [ffffffff812612ee] ext4_direct_IO+0x23e/0x400
+  [ffffffff81141308] generic_file_direct_write+0xc8/0x190
+  [ffffffff811416ab] __generic_file_aio_write+0x2db/0x460
+  [ffffffff811418a8] generic_file_aio_write+0x78/0xf0
+  [ffffffff8125a4cf] ext4_file_write+0x6f/0x2a0
+  [ffffffff81194112] do_sync_write+0xe2/0x120
+  [ffffffff81194c08] vfs_write+0xc8/0x180
+  [ffffffff81194dc1] sys_write+0x51/0x90
+  [ffffffff81aaca6b] system_call_fastpath+0x16/0x1b
+
+
+5. Notes
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
+* At this point, it's mostly tested with ext4 w/o journal.  Metadata
+  dirtier tracking w/ journal needs improvements.
+
+
+6. Overheads
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
index 4053cbd..2ee4e3b 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -8,6 +8,7 @@
 #ifdef CONFIG_BLOCK
 
 #include <linux/types.h>
+#include <linux/ioblame.h>
 
 struct bio_set;
 struct bio;
@@ -69,6 +70,9 @@ struct bio {
 #if defined(CONFIG_BLK_DEV_INTEGRITY)
 	struct bio_integrity_payload *bi_integrity;  /* data integrity */
 #endif
+#if defined(CONFIG_IO_BLAME) || defined(CONFIG_IO_BLAME_MODULE)
+	struct iob_io_info	bi_iob_info;
+#endif
 
 	bio_destructor_t	*bi_destructor;	/* destructor */
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7aacf31..7a43f9a 100644
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
index 9d0e0b5..237db65 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -190,6 +190,9 @@ struct gendisk {
 #ifdef  CONFIG_BLK_DEV_INTEGRITY
 	struct blk_integrity *integrity;
 #endif
+#if defined(CONFIG_IO_BLAME) || defined(CONFIG_IO_BLAME_MODULE)
+	bool iob_enabled;
+#endif
 	int node_id;
 };
 
diff --git a/include/linux/ioblame.h b/include/linux/ioblame.h
new file mode 100644
index 0000000..06c7f3a
--- /dev/null
+++ b/include/linux/ioblame.h
@@ -0,0 +1,72 @@
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
+	sector_t			sector;
+	size_t				size;
+	unsigned long			rw;
+
+	u64				queued_at;
+	u64				issued_at;
+
+	pid_t				pid;
+	int				intent;
+	dev_t				dev;
+	u32				gen;
+	ino_t				ino;
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
+/* intent modifer */
+#define IOB_MODIFIER_TYPE_SHIFT	28
+#define IOB_MODIFIER_TYPE_MASK	0xf0000000U
+#define IOB_MODIFIER_VAL_MASK	(~IOB_MODIFIER_TYPE_MASK)
+
+/* val contains wb_reason */
+#define IOB_MODIFIER_WB		(1 << IOB_MODIFIER_TYPE_SHIFT)
+
+#endif	/* _IOBLAME_H */
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index cd31345..ccc7c12 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -368,6 +368,18 @@ config BLK_DEV_IO_TRACE
 
 	  If unsure, say N.
 
+config IO_BLAME
+	tristate "Enable io-blame tracer"
+	depends on SYSFS
+	depends on BLOCK
+	select TRACEPOINTS
+	select STACKTRACE
+	help
+	  Say Y here if you want to enable IO tracer with dirtier
+	  tracking.  See Documentation/trace/ioblame.txt.
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
index 0000000..ae46abe
--- /dev/null
+++ b/kernel/trace/ioblame.c
@@ -0,0 +1,2279 @@
+/*
+ * kernel/trace/ioblame.c - IO tracer with origin tracking
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
+	 * Because a task can change its pid during exec and we want exact
+	 * match for removal on task exit, we use task pointer as key.
+	 */
+	struct task_struct	*task;
+	int			pid;
+
+	/* modifier currently in effect */
+	u32			modifier;
+
+	/* last file this role has operated on */
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
+/* for reclaiming */
+static void iob_reclaim_workfn(struct work_struct *work);
+static DECLARE_DELAYED_WORK(iob_reclaim_work, iob_reclaim_workfn);
+
+static unsigned int iob_role_reclaim_seq;
+
+static struct list_head iob_role_to_free_heads[2] = {
+	LIST_HEAD_INIT(iob_role_to_free_heads[0]),
+	LIST_HEAD_INIT(iob_role_to_free_heads[1]),
+};
+static struct list_head *iob_role_to_free_front = &iob_role_to_free_heads[0];
+static struct list_head *iob_role_to_free_back = &iob_role_to_free_heads[1];
+
+static unsigned long *iob_act_used_bitmaps[2];
+
+struct iob_act_used {
+	unsigned long	*front;
+	unsigned long	*back;
+} iob_act_used;
+
+/* pgtree - maps pfn to act nr */
+static RADIX_TREE(iob_pgtree, GFP_NOWAIT);
+
+/* stats and /sys/kernel/debug/ioblame */
+static struct iob_stats iob_stats;
+static struct dentry *iob_dir;
+static struct dentry *iob_intents_dentry;
+
+static void iob_intent_notify_workfn(struct work_struct *work);
+static DECLARE_WORK(iob_intent_notify_work, iob_intent_notify_workfn);
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
+#define CREATE_TRACE_POINTS
+#include <trace/events/ioblame.h>
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
+ * A role represents a task and is keyed by its task pointer.  It is
+ * created when the matching task first enters iob tracking, unhashed on
+ * task exit and destroyed after reclaim period has passed.
+ *
+ * The reason why task_roles are keyed by task pointer instead of pid is
+ * that pid can change across exec(2) and we need reliable match on task
+ * exit to avoid leaking task_roles.  A task_role is unhashed and scheduled
+ * for removal on task exit or if thie pid no longer matches after exec.
+ *
+ * These life-cycle rules guarantee that any task is given one id across
+ * its lifetime and avoid resource leaks.
+ *
+ * A role also carries context information for the task, e.g. the last file
+ * the task operated on, currently on-going inode operation and so on.
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
+	return jhash(rkey->task, sizeof(rkey->task), JHASH_INITVAL);
+}
+
+static bool iob_role_match(struct iob_node *node, void *key)
+{
+	struct iob_role *role = iob_node_to_role(node);
+	struct iob_role *rkey = key;
+
+	return rkey->task == role->task;
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
+ * iob_reclaim_current_role - reclaim role for %current
+ *
+ * This function guarantees that the self role won't be visible to hash
+ * table lookup by %current itself.
+ */
+static void iob_reclaim_current_role(void)
+{
+	struct iob_role rkey = { };
+	struct iob_role *role;
+	unsigned long flags;
+
+	/*
+	 * A role is always created by %current and thus guaranteed to be
+	 * visible to %current.  Negative result from lockless lookup can
+	 * be trusted.
+	 */
+	rkey.task = current;
+	rkey.pid = task_pid_nr(current);
+	role = iob_node_to_role(iob_get_node_raw(&rkey, iob_role_idx, false));
+	if (!role)
+		return;
+
+	/* unhash and queue on reclaim list */
+	spin_lock_irqsave(&iob_lock, flags);
+	WARN_ON_ONCE(!iob_unhash_node(&role->node, iob_role_idx));
+	WARN_ON_ONCE(!list_empty(&role->free_list));
+	list_add_tail(&role->free_list, iob_role_to_free_front);
+	spin_unlock_irqrestore(&iob_lock, flags);
+}
+
+/**
+ * iob_current_role - lookup role for %current
+ *
+ * Return role for %current.  May return nomem node under memory pressure.
+ */
+static struct iob_role *iob_current_role(void)
+{
+	struct iob_role rkey = { };
+	struct iob_role *role;
+	bool retried = false;
+
+	rkey.task = current;
+	rkey.pid = task_pid_nr(current);
+retry:
+	role = iob_node_to_role(iob_get_node(&rkey, iob_role_idx));
+
+	/*
+	 * If %current exec'd, its pid may have changed.  In such cases,
+	 * shoot down the current role and retry.
+	 */
+	if (role->pid == rkey.pid || role->node.id.f.nr < IOB_BASE_NR)
+		return role;
+
+	iob_reclaim_current_role();
+
+	/* this shouldn't happen more than once */
+	WARN_ON_ONCE(retried);
+	retried = true;
+	goto retry;
+}
+
+
+/*
+ * IOB_INTENT
+ *
+ * An intent represents a category of actions a task can take.  It
+ * currently consists of the stack trace at the point of action and an
+ * optional modifier.  The number of unique backtraces is expected to be
+ * limited and no reclaiming is implemented.
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
+
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
+	struct iob_intent *intent;
+	int nr_nodes;
+
+	nr_nodes = iob_intent_idx->nr_nodes;
+
+	intent = iob_node_to_intent(iob_get_node(&ikey, iob_intent_idx));
+
+	/*
+	 * If nr_nodes changed across get_node, we probably have created a
+	 * new entry.  Notify change on intent files.  This may be spurious
+	 * but won't miss an event, which is good enough.
+	 */
+	if (nr_nodes != iob_intent_idx->nr_nodes)
+		schedule_work(&iob_intent_notify_work);
+
+	return intent;
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
+/**
+ * iob_modified_intent - determine modified intent
+ * @intent: the base intent
+ * @modifier: modifier to apply
+ *
+ * Return iob_intent which is identical to @intent except that its modifier
+ * is @modifier.  @intent is allowed to have any modifier including zero on
+ * entry.  May return nomem node under memory pressure.
+ */
+static struct iob_intent *iob_modified_intent(struct iob_intent *intent,
+					      u32 modifier)
+{
+	if (intent->modifier == modifier ||
+	    unlikely(intent->node.id.f.nr < IOB_BASE_NR))
+		return intent;
+	return iob_get_intent(intent->trace, intent->depth, modifier);
+}
+
+
+/*
+ * IOB_ACT
+ *
+ * Represents specific action an iob_role took.  Consists of a iob_role,
+ * iob_act, and the target inode.  iob_act is used to track dirtiers.  For
+ * each dirtying operation, iob_act is acquired and recorded (either by id
+ * or id.f.nr) and used for reporting later.
+ *
+ * Because this is product of three different entities, the number can grow
+ * quite large.  Each successful lookup sets used bitmap and iob_acts which
+ * haven't been used for iob_ttl_secs are reclaimed.
+ */
+
+static void iob_act_mark_used(struct iob_act *act)
+{
+	if (!test_bit(act->node.id.f.nr, iob_act_used.front))
+		set_bit(act->node.id.f.nr, iob_act_used.front);
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
+	kmem_cache_free(iob_act_cache, iob_node_to_act(node));
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
+
+/*
+ * RECLAIM
+ */
+
+/**
+ * iob_reclaim - reclaim iob_roles and iob_acts
+ *
+ * This function is called from workqueue every ttl/2 and looks at
+ * iob_act_used->front/back and iob_role_to_free_front/back to reclaim
+ * unused nodes.
+ *
+ * iob_act uses bitmaps to collect and track used history.  Used bits are
+ * examined every ttl/2 period and iob_acts which haven't been used for two
+ * half periods are reclaimed.
+ *
+ * iob_role goes through reclaiming mostly to delay freeing so that roles
+ * are still available when async IO events fire after the original tasks
+ * exit.  iob_role reclaiming is simpler and happens every ttl.
+ */
+static void iob_reclaim_workfn(struct work_struct *work)
+{
+	LIST_HEAD(role_todo);
+	struct iob_act_used *u = &iob_act_used;
+	struct iob_act *free_head = NULL;
+	struct iob_act *act;
+	struct iob_role *role, *role_pos;
+	unsigned long flags;
+	int i;
+
+	/*
+	 * We're gonna reclaim acts which don't have bit set in both front
+	 * and back used bitmaps - IOW, the ones which weren't used in the
+	 * last and this ttl/2 periods.
+	 */
+	bitmap_or(u->back, u->front, u->back, iob_max_acts);
+
+	spin_lock_irqsave(&iob_lock, flags);
+
+	/*
+	 * Determine which roles to reclaim.  This function is executed
+	 * every ttl/2 but we want ttl.  Skip every other time.
+	 */
+	if (!(++iob_role_reclaim_seq % 2)) {
+		/* roles in the other free_head are now older than ttl */
+		list_splice_init(iob_role_to_free_back, &role_todo);
+		swap(iob_role_to_free_front, iob_role_to_free_back);
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
+	/* unhash and remove all acts which don't have bit set in @u->back */
+	for (i = find_next_zero_bit(u->back, iob_max_acts, IOB_BASE_NR);
+	     i < iob_max_acts;
+	     i = find_next_zero_bit(u->back, iob_max_acts, i + 1)) {
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
+
+	queue_delayed_work(system_nrt_wq, &iob_reclaim_work,
+			   iob_ttl_secs * HZ / 2);
+}
+
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
+static void iob_set_last_ino(struct inode *inode)
+{
+	struct iob_role *role = iob_current_role();
+
+	role->last_ino.dev = inode->i_sb->s_dev;
+	role->last_ino.ino = inode->i_ino;
+	role->last_ino.gen = inode->i_generation;
+	role->last_ino_jiffies = jiffies;
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
+ * Writeback is starting, record wb_reason in role->modifier.  This will
+ * be applied to any IOs issued from this task until writeback is finished.
+ */
+static void iob_probe_wb_start(void *data, struct backing_dev_info *bdi,
+			       struct wb_writeback_work *work)
+{
+	struct iob_role *role = iob_current_role();
+
+	role->modifier = work->reason | IOB_MODIFIER_WB;
+}
+
+/* writeback done, clear modifier */
+static void iob_probe_wb_written(void *data, struct backing_dev_info *bdi,
+				 struct wb_writeback_work *work)
+{
+	struct iob_role *role = iob_current_role();
+
+	role->modifier = 0;
+}
+
+/*
+ * An inode is about to be written back.  Will be followed by data and
+ * inode writeback.  In case dirtier data is not recorded in pgtree or
+ * inode, remember the inode in role->last_ino.
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
+ * To cover most cases, two tracking mechanisms are used - role->inode_act
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
+		struct iob_role *role = iob_current_role();
+		struct iob_act *act = iob_current_act(1, inode->i_sb->s_dev,
+						      inode->i_ino,
+						      inode->i_generation);
+		role->inode_act = act->node.id;
+		inode->i_iob_act = act->node.id;
+	}
+}
+
+/* inode dirtying complete */
+static void iob_probe_wb_dirty_inode(void *data, struct inode *inode, int flags)
+{
+	if (iob_enabled_inode(inode))
+		iob_current_role()->inode_act.v = 0;
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
+		struct iob_role *role = iob_current_role();
+
+		role->inode_act = inode->i_iob_act;
+	}
+}
+
+/* inode writing complete */
+static void iob_probe_wb_write_inode(void *data, struct inode *inode,
+				     struct writeback_control *wbc)
+{
+	if (iob_enabled_inode(inode))
+		iob_current_role()->inode_act.v = 0;
+}
+
+/*
+ * Called on touch_buffer().  Transfer inode act to pgtree.  This catches
+ * most inode operations for filesystems which use bh for metadata.
+ */
+static void iob_probe_block_touch_buffer(void *data, struct buffer_head *bh)
+{
+	if (iob_enabled_bh(bh)) {
+		struct iob_role *role = iob_current_role();
+
+		if (role->inode_act.v)
+			iob_pgtree_set_nr(page_to_pfn(bh->b_page),
+					  role->inode_act.f.nr);
+	}
+}
+
+/* bio is being queued, collect all info into bio->bi_iob_info */
+static void iob_probe_block_bio_queue(void *data, struct request_queue *q,
+				      struct bio *bio)
+{
+	struct iob_io_info *io = &bio->bi_iob_info;
+	struct iob_act *act = NULL;
+	struct iob_role *role;
+	struct iob_intent *intent;
+	int i;
+
+	if (!iob_enabled_bio(bio))
+		return;
+
+	role = iob_current_role();
+
+	io->sector = bio->bi_sector;
+	io->size = bio->bi_size;
+	io->rw = bio->bi_rw;
+
+	/* usec duration will be calculated on completion */
+	io->queued_at = io->issued_at = local_clock();
+
+	/* role's inode_act has the highest priority */
+	if (role->inode_act.v)
+		act = iob_act_by_id(role->inode_act);
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
+		if (!nr || act)
+			continue;
+
+		/* this is the first act, charge everything to it */
+		act = iob_act_by_nr(nr);
+	}
+
+	if (act) {
+		/* charge it to async dirtier */
+		io->pid = iob_role_by_id(act->role)->pid;
+		io->dev = act->dev;
+		io->ino = act->ino;
+		io->gen = act->gen;
+
+		intent = iob_intent_by_id(act->intent);
+	} else {
+		/*
+		 * Charge it to the IO issuer and the last file this task
+		 * initiated RW or writeback on, which is highly likely to
+		 * be the file this IO is for.  As a sanity check, trust
+		 * last_ino only for pre-defined duration.
+		 *
+		 * When acquiring stack trace, skip this function and
+		 * generic_make_request[_checks]()
+		 */
+		unsigned long now = jiffies;
+
+		io->pid = role->pid;
+
+		if (!iob_ignore_ino &&
+		    time_before_eq(role->last_ino_jiffies, now) &&
+		    now - role->last_ino_jiffies <= IOB_LAST_INO_DURATION) {
+			io->dev = role->last_ino.dev;
+			io->ino = role->last_ino.ino;
+			io->gen = role->last_ino.gen;
+		} else {
+			io->dev = bio->bi_bdev->bd_dev;
+			io->ino = 0;
+			io->gen = 0;
+		}
+
+		intent = iob_current_intent(2);
+	}
+
+	/* apply intent modifier and store nr */
+	intent = iob_modified_intent(intent, role->modifier);
+	io->intent = intent->node.id.f.nr;
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
+	size_t msize = mio->size;
+
+	*mio = *sio;
+	mio->size += msize;
+	sio->size = 0;
+}
+
+/* record issue timestamp, this may not happen for bio based drivers */
+static void iob_probe_block_rq_issue(void *data, struct request_queue *q,
+				     struct request *rq)
+{
+	if (rq->bio && rq->bio->bi_iob_info.size)
+		rq->bio->bi_iob_info.issued_at = local_clock();
+}
+
+/* bio is complete, report and accumulate statistics */
+static void iob_probe_block_bio_complete(void *data, struct request_queue *q,
+					 struct bio *bio, int error)
+{
+	/* kick the TP */
+	trace_ioblame_io(bio);
+}
+
+/* %current is exiting, shoot down its role */
+static void iob_probe_block_sched_process_exit(void *data,
+					       struct task_struct *task)
+{
+	WARN_ON_ONCE(task != current);
+	iob_reclaim_current_role();
+}
+
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
+	/* if enabled, disable reclaim and unregister all hooks */
+	if (iob_enabled) {
+		cancel_delayed_work_sync(&iob_reclaim_work);
+		cancel_work_sync(&iob_intent_notify_work);
+		iob_enabled = false;
+
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
+
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
+	iob_role_reclaim_seq = 0;
+	iob_act_used.front = iob_act_used_bitmaps[0];;
+	iob_act_used.back = iob_act_used_bitmaps[1];;
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
+	queue_delayed_work(system_nrt_wq, &iob_reclaim_work,
+			   iob_ttl_secs * HZ / 2);
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
+ * ioblame/intents - export intents to userland.
+ *
+ * Userland can acquire intents by reading ioblame/intents.
+ *
+ * While iob is enabled, intents are never reclaimed, intent nr is
+ * guaranteed to be allocated consecutively in ascending order and both
+ * intents files are lseekable by intent nr, so userland tools which want
+ * to learn about new intents since last reading can simply seek to the
+ * number of currently known intents and start reading from there.
+ *
+ * Both files generate at least one size changed notification after a new
+ * intent is created.
+ */
+static void iob_intent_notify_workfn(struct work_struct *work)
+{
+	struct iattr iattr = (struct iattr){ .ia_valid = ATTR_SIZE };
+
+	/*
+	 * Invoked after new intent is created, kick bogus size changed
+	 * notification.
+	 */
+	notify_change(iob_intents_dentry, &iattr);
+}
+
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
+static const struct file_operations iob_intents_fops = {
+	.owner		= THIS_MODULE,
+	.open		= generic_file_open,
+	.llseek		= iob_intents_llseek,
+	.read		= iob_intents_read,
+};
+
+
+static int __init ioblame_init(void)
+{
+	struct dentry *stats_dir;
+
+	BUILD_BUG_ON((1 << IOB_TYPE_BITS) < IOB_NR_TYPES);
+	BUILD_BUG_ON(IOB_NR_BITS + IOB_GEN_BITS + IOB_TYPE_BITS != 64);
+
+	iob_role_cache = KMEM_CACHE(iob_role, 0);
+	iob_act_cache = KMEM_CACHE(iob_act, 0);
+	if (!iob_role_cache || !iob_act_cache)
+		goto fail;
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
+	    !debugfs_create_file("enable", 0600, iob_dir, &iob_enabled, &iob_enable_fops) ||
+	    !debugfs_create_file("nr_roles", 0400, iob_dir, &iob_role_idx, &iob_nr_nodes_fops) ||
+	    !debugfs_create_file("nr_intents", 0400, iob_dir, &iob_intent_idx, &iob_nr_nodes_fops) ||
+	    !debugfs_create_file("nr_acts", 0400, iob_dir, &iob_act_idx, &iob_nr_nodes_fops))
+		goto fail;
+
+	iob_intents_dentry = debugfs_create_file("intents", 0400, iob_dir, NULL, &iob_intents_fops);
+	if (!iob_intents_dentry)
+		goto fail;
+
+	stats_dir = debugfs_create_dir("stats", iob_dir);
+	if (!stats_dir)
+		goto fail;
+
+	if (!debugfs_create_file("idx_nomem", 0400, stats_dir, &iob_stats.idx_nomem, &iob_stats_fops) ||
+	    !debugfs_create_file("idx_nospc", 0400, stats_dir, &iob_stats.idx_nospc, &iob_stats_fops) ||
+	    !debugfs_create_file("node_nomem", 0400, stats_dir, &iob_stats.node_nomem, &iob_stats_fops) ||
+	    !debugfs_create_file("pgtree_nomem", 0400, stats_dir, &iob_stats.pgtree_nomem, &iob_stats_fops))
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

