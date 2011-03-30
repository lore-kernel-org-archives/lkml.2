Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932743Ab1C3QvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 12:51:15 -0400
Received: from smtp-out.google.com ([216.239.44.51]:17317 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052Ab1C3QvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 12:51:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:mime-version:
	content-type:content-transfer-encoding;
	b=WNEQvYlc2GiS1fgNavbLcJNj4tpZMXfk7AkppCR9Zqxu99lcVXupvJTVVKjRSm8mt
	TM4iemNIv78Bild+xTAlw==
From: Justin TerAvest <teravest@google.com>
To: vgoyal@redhat.com
Cc: jaxboe@fusionio.com, m-ikeda@ds.jp.nec.com, ryov@valinux.co.jp,
        taka@valinux.co.jp, kamezawa.hiroyu@jp.fujitsu.com,
        righi.andrea@gmail.com, guijianfeng@cn.fujitsu.com,
        balbir@linux.vnet.ibm.com, ctalbott@google.com,
        linux-kernel@vger.kernel.org, Justin TerAvest <teravest@google.com>
Subject: =?UTF-8?q?=5BRFC=5D=20=5BPATCH=20v3=200/8=5D=20Provide=20cgroup=20isolation=20for=20buffered=20writes=2E?=
Date: Wed, 30 Mar 2011 09:50:32 -0700
Message-Id: <1301503840-25851-1-git-send-email-teravest@google.com>
X-Mailer: git-send-email 1.7.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds tracking to the page_cgroup structure for which cgroup has
dirtied a page, and uses that information to provide isolation between
cgroups performing writeback.

I know that there is some discussion to remove request descriptor limits
entirely, but I included a patch to introduce per-cgroup limits to enable
this functionality. Without it, we didn't see much isolation improvement.

I think most of this material has been discussed on lkml previously, this is
just another attempt to make a patchset that handles buffered writes for CFQ.

There was a lot of previous discussion at:
 http://thread.gmane.org/gmane.linux.kernel/1007922

Thanks to Andrea Righi, Kamezawa Hiroyuki, Munehiro Ikeda, Nauman Rafique,
and Vivek Goyal for work on previous versions of these patches.

For version 3:
  - I fixed a bug with restored requests with
    blk_flush_restore_request() which caused a BUG with flush requests.
  - Cleaned up test information in the cover sheet more.
  - There are still outstanding issues, this is mostly to prevent an
    oops Vivek noticed on boot.

For version 2:
  - I collected more statistics and provided data in the cover sheet
  - blkio id is now stored inside "flags" in page_cgroup, with cmpxchg
  - I cleaned up some patch names
  - Added symmetric reference wrappers in cfq-iosched

There are a couple lingering issues that exist in this patchset-- it's meant
to be an RFC to discuss the overall design for tracking of buffered writes.
I have at least a couple of patches to finish to make absolutely sure that
refcounts and locking are handled properly, I just need to do more testing.

No other patches were applied to the Jens' tree when testing this code.

TODOs:
  - Make sure we run sync as part of "exec_prerun" for fio testing
  - Find a way to not use cmpxchg() to store data in page_cgroup->flags.

 Documentation/block/biodoc.txt |   10 +
 block/blk-cgroup.c             |  203 +++++++++++++++++-
 block/blk-cgroup.h             |    9 +-
 block/blk-core.c               |  218 +++++++++++++------
 block/blk-flush.c              |    2 +
 block/blk-settings.c           |    2 +-
 block/blk-sysfs.c              |   59 +++---
 block/cfq-iosched.c            |  473 ++++++++++++++++++++++++++++++----------
 block/cfq.h                    |    6 +-
 block/elevator.c               |    7 +-
 fs/buffer.c                    |    2 +
 fs/direct-io.c                 |    2 +
 include/linux/blk_types.h      |    2 +
 include/linux/blkdev.h         |   81 +++++++-
 include/linux/blkio-track.h    |   89 ++++++++
 include/linux/elevator.h       |   14 +-
 include/linux/iocontext.h      |    1 +
 include/linux/memcontrol.h     |    6 +
 include/linux/mmzone.h         |    4 +-
 include/linux/page_cgroup.h    |   38 +++-
 init/Kconfig                   |   16 ++
 mm/Makefile                    |    3 +-
 mm/bounce.c                    |    2 +
 mm/filemap.c                   |    2 +
 mm/memcontrol.c                |    6 +
 mm/memory.c                    |    6 +
 mm/page-writeback.c            |   14 +-
 mm/page_cgroup.c               |   29 ++-
 mm/swap_state.c                |    2 +
 29 files changed, 1068 insertions(+), 240 deletions(-)

0001-cfq-iosched-add-symmetric-reference-wrappers.patch
0002-block-fs-mm-IO-cgroup-tracking-for-buffered-write.patch
0003-cfq-iosched-Make-async-queues-per-cgroup.patch
0004-block-Modify-CFQ-to-use-IO-tracking-information.patch
0005-cfq-Fix-up-tracked-async-workload-length.patch
0006-cfq-add-per-cgroup-writeout-done-by-flusher-stat.patch
0007-block-Per-cgroup-request-descriptor-counts.patch
0008-cfq-Don-t-allow-preemption-across-cgroups.patch

===================================== Isolation experiment results

For isolation testing, we run a test that's available at:
  git://google3-2.osuosl.org/tests/blkcgroup.git

This test creates multiple containers, assigning weights to devices, and
checks how closely values as reported by blkio.time match the requested
weights. This is used as a means to determine how effective the isolation is
provided by the linux kernel.

For example, "900 wrseq.buf*2, 100 wrseq.buf*2", means that we create two
cgroups,
  - One with weight_device 900 for a given device
  - One with weight_device 100 for the same device
...Then, in the cgroups, we run an identical workload, performing buffered
writes with two processes.

I've filtered the lines below to only mention experiments that involve buffered
writers, since that should be all that is affected by this patch.

All performance numbers below are with the ext2 filesystem.

Before patches
==============
----- Running experiment 12: 500 wrseq.buf*2, 500 wrseq.buf*2
experiment 12 achieved DTFs: 472, 527
experiment 12 PASSED: max observed error is 28, allowed is 150
----- Running experiment 13: 900 wrseq.buf*2, 100 wrseq.buf*2
experiment 13 achieved DTFs: 735, 264
experiment 13 FAILED: max observed error is 165, allowed is 150
----- Running experiment 14: 100 wrseq.buf*2, 900 wrseq.buf*2
experiment 14 achieved DTFs: 312, 687
experiment 14 FAILED: max observed error is 213, allowed is 150
----- Running experiment 15: 600 wrseq.buf*2, 200 wrseq.buf*2, 200 wrseq.buf*2
experiment 15 achieved DTFs: 443, 151, 405
experiment 15 FAILED: max observed error is 205, allowed is 150
----- Running experiment 16: 650 wrseq.buf*2, 100 wrseq.buf*2, 100 wrseq.buf*2, 150 wrseq.buf*2
experiment 16 achieved DTFs: 341, 365, 97, 195
experiment 16 FAILED: max observed error is 309, allowed is 150
----- Running experiment 17: 140 wrseq.buf*2, 140 wrseq.buf*2, 140 wrseq.buf*2, 140 wrseq.buf*2, 140 wrseq.buf*2, 140 wrseq.buf*2, 160 wrseq.buf*2
experiment 17 achieved DTFs: 192, 64, 100, 128, 160, 128, 224
experiment 17 PASSED: max observed error is 76, allowed is 150
----- Running experiment 27: 500 rdrand, 500 wrseq.buf*2
experiment 27 achieved DTFs: 985, 14
experiment 27 FAILED: max observed error is 486, allowed is 150
----- Running experiment 28: 900 rdrand, 100 wrseq.buf*2
experiment 28 achieved DTFs: 991, 8
experiment 28 PASSED: max observed error is 92, allowed is 150
----- Running experiment 29: 100 rdrand, 900 wrseq.buf*2
experiment 29 achieved DTFs: 961, 38
experiment 29 FAILED: max observed error is 862, allowed is 150


After patches
=============
----- Running experiment 12: 500 wrseq.buf*2, 500 wrseq.buf*2
experiment 12 achieved DTFs: 499, 500
experiment 12 PASSED: max observed error is 1, allowed is 150
----- Running experiment 13: 900 wrseq.buf*2, 100 wrseq.buf*2
experiment 13 achieved DTFs: 864, 135
experiment 13 PASSED: max observed error is 36, allowed is 150
----- Running experiment 14: 100 wrseq.buf*2, 900 wrseq.buf*2
experiment 14 achieved DTFs: 113, 886
experiment 14 PASSED: max observed error is 14, allowed is 150
----- Running experiment 15: 600 wrseq.buf*2, 200 wrseq.buf*2, 200 wrseq.buf*2
experiment 15 achieved DTFs: 593, 204, 201
experiment 15 PASSED: max observed error is 7, allowed is 150
----- Running experiment 16: 650 wrseq.buf*2, 100 wrseq.buf*2, 100 wrseq.buf*2, 150 wrseq.buf*2
experiment 16 achieved DTFs: 608, 113, 111, 166
experiment 16 PASSED: max observed error is 42, allowed is 150
----- Running experiment 17: 140 wrseq.buf*2, 140 wrseq.buf*2, 140 wrseq.buf*2, 140 wrseq.buf*2, 140 wrseq.buf*2, 140 wrseq.buf*2, 160 wrseq.buf*2
experiment 17 achieved DTFs: 140, 139, 139, 139, 140, 141, 159
experiment 17 PASSED: max observed error is 1, allowed is 150
----- Running experiment 27: 500 rdrand, 500 wrseq.buf*2
experiment 27 achieved DTFs: 512, 487
experiment 27 PASSED: max observed error is 13, allowed is 150
----- Running experiment 28: 900 rdrand, 100 wrseq.buf*2
experiment 28 achieved DTFs: 869, 130
experiment 28 PASSED: max observed error is 31, allowed is 150
----- Running experiment 29: 100 rdrand, 900 wrseq.buf*2
experiment 29 achieved DTFs: 131, 868
experiment 29 PASSED: max observed error is 32, allowed is 150

With the patches applied, and workload
  "100 wrseq.buf, 200 wrseq.buf, 300 wrseq.buf, 400 wrseq.buf", we confirm
how the tests works by providing data from /dev/cgroup:

/dev/cgroup/blkcgroupt0/blkio.sectors
8:16 510040
8:0 376

/dev/cgroup/blkcgroupt1/blkio.sectors
8:16 941040

/dev/cgroup/blkcgroupt2/blkio.sectors
8:16 1224456
8:0 8

/dev/cgroup/blkcgroupt3/blkio.sectors
8:16 1509576
8:0 152

/dev/cgroup/blkcgroupt0/blkio.time
8:16 2651
8:0 20

/dev/cgroup/blkcgroupt1/blkio.time
8:16 5200

/dev/cgroup/blkcgroupt2/blkio.time
8:16 7350
8:0 8

/dev/cgroup/blkcgroupt3/blkio.time
8:16 9591
8:0 20

/dev/cgroup/blkcgroupt0/blkio.weight_device
8:16    100

/dev/cgroup/blkcgroupt1/blkio.weight_device
8:16    200

/dev/cgroup/blkcgroupt2/blkio.weight_device
8:16    300

/dev/cgroup/blkcgroupt3/blkio.weight_device
8:16    400

Summary
=======
Isolation between buffered writers is clearly better with this patch.

"Error" is much lower with the patches, showing that blkio.time is closer in
sync to the weight requested than without the patches.


=============================== Read latency results
To test read latency, I created two containers:
  - One called "readers", with weight 900
  - One called "writers", with weight 100

Adding "sync;" to the exec_prerun= line causes fio to have some errors; I'll
continue to investigate this.

I ran this fio workload in "readers":
[global]
directory=/mnt/iostestmnt/fio
runtime=30
time_based=1
group_reporting=1
exec_prerun='echo 3 > /proc/sys/vm/drop_caches'
cgroup_nodelete=1
bs=4K
size=512M

[iostest-read]
description="reader"
numjobs=16
rw=randread
new_group=1


....and this fio workload in "writers"
[global]
directory=/mnt/iostestmnt/fio
runtime=30
time_based=1
group_reporting=1
exec_prerun='echo 3 > /proc/sys/vm/drop_caches'
cgroup_nodelete=1
bs=4K
size=512M

[iostest-write]
description="writer"
cgroup=writers
numjobs=3
rw=write
new_group=1

I've pasted the results from the "read" workload inline.

Before patches
==============
Starting 16 processes

Jobs: 14 (f=14): [_rrrrrr_rrrrrrrr] [36.2% done] [352K/0K /s] [86 /0  iops] [eta 01m:00s]·············
iostest-read: (groupid=0, jobs=16): err= 0: pid=20606
  Description  : ["reader"]
  read : io=13532KB, bw=455814 B/s, iops=111 , runt= 30400msec
    clat (usec): min=2190 , max=30399K, avg=30395175.13, stdev= 0.20
     lat (usec): min=2190 , max=30399K, avg=30395177.07, stdev= 0.20
    bw (KB/s) : min=    0, max=  260, per=0.00%, avg= 0.00, stdev= 0.00
  cpu          : usr=0.00%, sys=0.03%, ctx=3691, majf=2, minf=468
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w/d: total=3383/0/0, short=0/0/0

     lat (msec): 4=0.03%, 10=2.66%, 20=74.84%, 50=21.90%, 100=0.09%
     lat (msec): 250=0.06%, >=2000=0.41%

Run status group 0 (all jobs):
   READ: io=13532KB, aggrb=445KB/s, minb=455KB/s, maxb=455KB/s, mint=30400msec, maxt=30400msec

Disk stats (read/write):
  sdb: ios=3744/18, merge=0/16, ticks=542713/1675, in_queue=550714, util=99.15%

iostest-write: (groupid=0, jobs=3): err= 0: pid=20654
 Description  : ["writer"]
 write: io=282444KB, bw=9410.5KB/s, iops=2352 , runt= 30014msec
   clat (usec): min=3 , max=28921K, avg=1468.79, stdev=108833.25
    lat (usec): min=3 , max=28921K, avg=1468.89, stdev=108833.25
   bw (KB/s) : min=  101, max= 5448, per=21.39%, avg=2013.25, stdev=1322.76
 cpu          : usr=0.11%, sys=0.41%, ctx=77, majf=0, minf=81
 IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
    submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
    complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
    issued r/w/d: total=0/70611/0, short=0/0/0
    lat (usec): 4=0.65%, 10=95.27%, 20=1.39%, 50=2.58%, 100=0.01%
    lat (usec): 250=0.01%
    lat (msec): 2=0.01%, 4=0.01%, 10=0.04%, 20=0.02%, 100=0.01%
    lat (msec): 250=0.01%, 500=0.01%, 750=0.01%, >=2000=0.01%

Run status group 0 (all jobs):
 WRITE: io=282444KB, aggrb=9410KB/s, minb=9636KB/s, maxb=9636KB/s,
mint=30014msec, maxt=30014msec

Disk stats (read/write):
 sdb: ios=3716/0, merge=0/0, ticks=157011/0, in_queue=506264, util=99.09%


After patches
=============
Starting 16 processes
Jobs: 16 (f=16): [rrrrrrrrrrrrrrrr] [100.0% done] [557K/0K /s] [136 /0  iops] [eta 00m:00s]
iostest-read: (groupid=0, jobs=16): err= 0: pid=14183
  Description  : ["reader"]
  read : io=14940KB, bw=506105 B/s, iops=123 , runt= 30228msec
    clat (msec): min=2 , max=29866 , avg=463.42, stdev=101.84
     lat (msec): min=2 , max=29866 , avg=463.42, stdev=101.84
    bw (KB/s) : min=    0, max=  198, per=31.69%, avg=156.52, stdev=17.83
  cpu          : usr=0.01%, sys=0.03%, ctx=4274, majf=2, minf=464
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w/d: total=3735/0/0, short=0/0/0

     lat (msec): 4=0.05%, 10=0.32%, 20=32.99%, 50=64.61%, 100=1.26%
     lat (msec): 250=0.11%, 500=0.11%, 750=0.16%, 1000=0.05%, >=2000=0.35%

Run status group 0 (all jobs):
   READ: io=14940KB, aggrb=494KB/s, minb=506KB/s, maxb=506KB/s, mint=30228msec, maxt=30228msec

Disk stats (read/write):
  sdb: ios=4189/0, merge=0/0, ticks=96428/0, in_queue=478798, util=100.00%

Jobs: 3 (f=3): [WWW] [100.0% done] [0K/0K /s] [0 /0  iops] [eta 00m:00s]
iostest-write: (groupid=0, jobs=3): err= 0: pid=14178
 Description  : ["writer"]
 write: io=90268KB, bw=3004.9KB/s, iops=751 , runt= 30041msec
   clat (usec): min=3 , max=29612K, avg=4086.42, stdev=197096.83
    lat (usec): min=3 , max=29612K, avg=4086.53, stdev=197096.83
   bw (KB/s) : min=  956, max= 1092, per=32.58%, avg=978.67, stdev= 0.00
 cpu          : usr=0.03%, sys=0.14%, ctx=44, majf=1, minf=83
 IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
    submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
    complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
    issued r/w/d: total=0/22567/0, short=0/0/0
    lat (usec): 4=1.06%, 10=94.20%, 20=2.11%, 50=2.50%, 100=0.01%
    lat (usec): 250=0.01%
    lat (msec): 10=0.04%, 20=0.03%, 50=0.01%, 250=0.01%, >=2000=0.01%

Run status group 0 (all jobs):
 WRITE: io=90268KB, aggrb=3004KB/s, minb=3076KB/s, maxb=3076KB/s,
mint=30041msec, maxt=30041msec

Disk stats (read/write):
 sdb: ios=4158/0, merge=0/0, ticks=95747/0, in_queue=475051, util=100.00%


Summary
=======
Read latencies are a bit worse, but this overhead is only imposed when users
ask for this feature by turning on CONFIG_BLKIOTRACK. We expect there to be
something of a latency vs isolation tradeoff.

The latency impact for reads can be seen in this table:
      Baseline        W/Patches
4      0.03             0.05
10     2.69             0.37
20     77.53            33.36
50     99.43            97.97
100    99.52            99.23
250    99.58            99.34
inf    99.99            100.01
