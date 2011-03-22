Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693Ab1CVXJa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 19:09:30 -0400
Received: from smtp-out.google.com ([216.239.44.51]:6665 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575Ab1CVXJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 19:09:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:mime-version:
	content-type:content-transfer-encoding;
	b=VhaxEAZcMnyLSjkvXEa5VPY6fLH8TmIYItDHHz1N6/WrBQEgcwOBlijOvPxrTiUF1
	R5+JgAHp2NT/GntGJW7UA==
From: Justin TerAvest <teravest@google.com>
To: vgoyal@redhat.com, jaxboe@fusionio.com
Cc: m-ikeda@ds.jp.nec.com, ryov@valinux.co.jp, taka@valinux.co.jp,
        kamezawa.hiroyu@jp.fujitsu.com, righi.andrea@gmail.com,
        guijianfeng@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
        ctalbott@google.com, linux-kernel@vger.kernel.org,
        Justin TerAvest <teravest@google.com>
Subject: =?UTF-8?q?=5BRFC=5D=20=5BPATCH=20v2=200/8=5D=20Provide=20cgroup=20isolation=20for=20buffered=20writes=2E?=
Date: Tue, 22 Mar 2011 16:08:47 -0700
Message-Id: <1300835335-2777-1-git-send-email-teravest@google.com>
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

For version 2:
  - I collected more statistics and provided data in the cover sheet
  - blkio id is now stored inside "flags" in page_cgroup, with cmpxchg
  - I cleaned up some patch names
  - Added symmetric reference wrappers in cfq-iosched

There are a couple lingering issues that exist in this patchset-- it's meant
to be an RFC to discuss the overall design for tracking of buffered writes.
I have at least a couple of patches to finish to make absolutely sure that
refcounts and locking are handled properly, I just need to do more testing.

 Documentation/block/biodoc.txt |   10 +
 block/blk-cgroup.c             |  203 +++++++++++++++++-
 block/blk-cgroup.h             |    9 +-
 block/blk-core.c               |  218 +++++++++++++------
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
 28 files changed, 1066 insertions(+), 240 deletions(-)


8f0b0f4 cfq: Don't allow preemption across cgroups
a47cdc6 block: Per cgroup request descriptor counts
8dd7adb cfq: add per cgroup writeout done by flusher stat
1fa0b6d cfq: Fix up tracked async workload length.
e9e85d3 block: Modify CFQ to use IO tracking information.
f8ffb19 cfq-iosched: Make async queues per cgroup
1d9ee09 block,fs,mm: IO cgroup tracking for buffered write
31c7321 cfq-iosched: add symmetric reference wrappers


===================================== Isolation experiment results

For isolation testing, we run a test that's available at:
  git://google3-2.osuosl.org/tests/blkcgroup.git

It creates containers, runs workloads, and checks to see how well we meet
isolation targets. For the purposes of this patchset, I only ran
tests among buffered writers.

Before patches
==============
10:32:06 INFO experiment 0 achieved DTFs: 666, 333
10:32:06 INFO experiment 0 FAILED: max observed error is 167, allowed is 150
10:32:51 INFO experiment 1 achieved DTFs: 647, 352
10:32:51 INFO experiment 1 FAILED: max observed error is 253, allowed is 150
10:33:35 INFO experiment 2 achieved DTFs: 298, 701
10:33:35 INFO experiment 2 FAILED: max observed error is 199, allowed is 150
10:34:19 INFO experiment 3 achieved DTFs: 445, 277, 277
10:34:19 INFO experiment 3 FAILED: max observed error is 155, allowed is 150
10:35:05 INFO experiment 4 achieved DTFs: 418, 104, 261, 215
10:35:05 INFO experiment 4 FAILED: max observed error is 232, allowed is 150
10:35:53 INFO experiment 5 achieved DTFs: 213, 136, 68, 102, 170, 136, 170
10:35:53 INFO experiment 5 PASSED: max observed error is 73, allowed is 150
10:36:04 INFO -----ran 6 experiments, 1 passed, 5 failed

After patches
=============
11:05:22 INFO experiment 0 achieved DTFs: 501, 498
11:05:22 INFO experiment 0 PASSED: max observed error is 2, allowed is 150
11:06:07 INFO experiment 1 achieved DTFs: 874, 125
11:06:07 INFO experiment 1 PASSED: max observed error is 26, allowed is 150
11:06:53 INFO experiment 2 achieved DTFs: 121, 878
11:06:53 INFO experiment 2 PASSED: max observed error is 22, allowed is 150
11:07:46 INFO experiment 3 achieved DTFs: 589, 205, 204
11:07:46 INFO experiment 3 PASSED: max observed error is 11, allowed is 150
11:08:34 INFO experiment 4 achieved DTFs: 616, 109, 109, 163
11:08:34 INFO experiment 4 PASSED: max observed error is 34, allowed is 150
11:09:29 INFO experiment 5 achieved DTFs: 139, 139, 139, 139, 140, 141, 160
11:09:29 INFO experiment 5 PASSED: max observed error is 1, allowed is 150
11:09:46 INFO -----ran 6 experiments, 6 passed, 0 failed

Summary
=======
Isolation between buffered writers is clearly better with this patch.


=============================== Read latency results
To test read latency, I created two containers:
  - One called "readers", with weight 900
  - One called "writers", with weight 100

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



After patches
=============
tarting 16 processes
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



Summary
=======
Read latencies are a bit worse, but this overhead is only imposed when users
ask for this feature by turning on CONFIG_BLKIOTRACK. We expect there to be =
a something of a latency vs isolation tradeoff.
