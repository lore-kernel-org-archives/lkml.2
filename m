Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab2A3HH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 02:07:26 -0500
Received: from mga14.intel.com ([143.182.124.37]:5268 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006Ab2A3HHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 02:07:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="61168558"
Message-Id: <20120130070213.793690895@sli10-conroe.sh.intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 30 Jan 2012 15:02:13 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, vgoyal@redhat.com, david@fromorbit.com,
        jack@suse.cz, zhu.yanhai@gmail.com, namhyung.kim@lge.com,
        shaohua.li@intel.com
Subject: [patch v2 0/8]block: An IOPS based ioscheduler
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An IOPS based I/O scheduler

Flash based storage has some different characteristics against rotate disk.
1. no I/O seek.
2. read and write I/O cost usually is much different.
3. Time which a request takes depends on request size.
4. High throughput and IOPS, low latency.

CFQ iosched does well for rotate disk, for example fair dispatching, idle
for sequential read. It also has optimization for flash based storage (for
item 1 above), but overall it's not designed for flash based storage. It's
a slice based algorithm. Since flash based storage request cost is very
low, and drive has big queue_depth is quite popular now which makes
dispatching cost even lower, CFQ's slice accounting (jiffy based)
doesn't work well. CFQ doesn't consider above item 2 & 3.

FIOPS (Fair IOPS) ioscheduler is trying to fix the gaps. It's IOPS based, so
only targets for drive without I/O seek. It's quite similar like CFQ, but
the dispatch decision is made according to IOPS instead of slice.

To illustrate the design goals, let's compare Noop and CFQ:
Noop: best throughput; No fairness and high latency for sync.
CFQ: lower throughput in some cases; fairness and low latency for sync.
CFQ throughput is slow sometimes because it doesn't drive deep queue depth.
FIOPS adopts some merits of CFQ, for example, fairness and bias sync workload.
And it will be faster than CFQ in general.

Note, if workload iodepth is low, there is no way to maintain fairness without
performance sacrifice. Neither with CFQ. In such case, FIOPS will choose to not
lose performance because flash based storage is usually very fast and expensive,
performance is more important.

The algorithm is simple. Drive has a service tree, and each task lives in
the tree. The key into the tree is called vios (virtual I/O). Every request
has vios, which is calculated according to its ioprio, request size and so
on. Task's vios is the sum of vios of all requests it dispatches. FIOPS
always selects task with minimum vios in the service tree and let the task
dispatch request. The dispatched request's vios is then added to the task's
vios and the task is repositioned in the sevice tree.

Benchmarks results:
SSD I'm using: max throughput read: 250m/s; write: 80m/s. max IOPS for 4k
request read 40k/s; write 20k/s
Latency and fairness tests are done in a desktop with one SSD and kernel
parameter mem=1G. I'll compare noop, cfq and fiops in such workload. The test
script and result is attached. Throughput tests are done in a 4 socket
server and 8 SSD. I'll compare cfq and fiops.

Latency
--------------------------
latency-1read-iodepth32-test
latency-8read-iodepth1-test
latency-8read-iodepth4-test
latency-32read-iodepth1-test
latency-32read-iodepth4-test
In all the tests, sync workloads have less latency with CFQ. FIOPS is worse
than CFQ but much better than noop, because it doesn't do preempt and
strictly follow 2.5:1 ratio of sync/async shares.
If preemption is added (I had a debug patch - the last patch in the series),
FIOPS will get similar result as CFQ.

Fairness
-------------------------
fairness-2read-iodepth8-test
fairness-2read-iodepth32-test
fairness-8read-iodepth4-test
fairness-32read-iodepth2-test

In the tests, thread group 2 should get about 2.33 more IOPS than thread group 1.

The first test doesn't drive big io depth (drive io depth is 31). No ioscheduler
is fair. The thread2/thread1 ratio is: 0.8(CFQ), 1(NOOP, FIOPS).
In the last 3 tests, ratios with CFQ is 2.69, 2.78, 7.54; ratios with FIOPS is
2.33, 2.32, 2.32; NOOP always gives 1.

FIOPS is more fair than CFQ, because CFQ uses jiffies to measure slice, 1
jiffy is too big for SSD and NCQ disk.

Note in all the tests, NOOP and FIOPS can drive the peek IOPS, while CFQ can
only drive peek IOPS for the second test.

Throughput
------------------------
                    workload    cfq     fiops   changes
              fio_sync_read_4k  3186.3  3304.0  3.6%
             fio_mediaplay_64k  3303.7  3372.0  2.0%
            fio_mediaplay_128k  3256.3  3405.7  4.4%
           fio_sync_read_rr_4k  4058.3  4071.3  0.3%
              fio_media_rr_64k  3946.0  4013.3  1.7%
  fio_sync_write_rr_64k_create  700.7   692.7   -1.2%
     fio_sync_write_64k_create  697.0   696.7   -0.0%
    fio_sync_write_128k_create  672.7   675.7   0.4%
             fio_sync_write_4k  667.7   682.3   2.1%
            fio_sync_write_64k  721.3   714.7   -0.9%
           fio_sync_write_128k  704.7   703.0   -0.2%
           fio_aio_randread_4k  534.3   656.7   18.6%
          fio_aio_randread_64k  1877.0  1881.3  0.2%
          fio_aio_randwrite_4k  306.0   366.0   16.4%
         fio_aio_randwrite_64k  481.0   485.3   0.9%
             fio_aio_randrw_4k  92.5    215.7   57.1%
            fio_aio_randrw_64k  352.0   346.3   -1.6%
                      fio_tpcc  328/98  341.6/99.1 3.9%/1.1%
                      fio_tpch  11576.3 11583.3 0.1%
          fio_mmap_randread_1k  6464.0  6472.0  0.1%
          fio_mmap_randread_4k  9321.3  9636.0  3.3%
         fio_mmap_randread_64k  11507.7 11420.0 -0.8%
         fio_mmap_randwrite_1k  68.1    63.4    -7.4%
         fio_mmap_randwrite_4k  261.7   250.3   -4.5%
        fio_mmap_randwrite_64k  414.0   414.7   0.2%
            fio_mmap_randrw_1k  65.8    64.5    -2.1%
            fio_mmap_randrw_4k  260.7   241.3   -8.0%
           fio_mmap_randrw_64k  424.0   429.7   1.3%
         fio_mmap_sync_read_4k  3235.3  3239.7  0.1%
        fio_mmap_sync_read_64k  3265.3  3208.3  -1.8%
       fio_mmap_sync_read_128k  3202.3  3250.3  1.5%
      fio_mmap_sync_read_rr_4k  2328.7  2368.0  1.7%
     fio_mmap_sync_read_rr_64k  2425.0  2416.0  -0.4%

FIOPS is much better for some aio workloads, because it can drive deep
queue depth. For workloads low queue depth already saturates the SSD,
CFQ and FIOPS has no difference.

For some mmap rand read/write workloads, CFQ is better. Again this is
because CFQ has sync preemption. The debug patch, last one in the series,
can fix the gap.

Benchmark Summary
------------------------
FIOPS is more fair and has higher throughput. The throughput gain is because
it can drive deeper queue depth. The fairness gain is because IOPS based
accounting is more accurate.
FIOPS is worse to bias sync workload and has lower throughput in some tests.
This is fixable (like the debug patch mentioned above). But I didn't want
to push the patch in, because it will starve async workload (The same with
CFQ). When we talk about bias sync, I thought we should have a degree how
much the bias should be. Starvation of async sounds not optimal too.

CGROUP
-----------------------
CGROUP isn't implemented yet. FIOPS is more fair, which is very important
for CGROUP. Givin FIOPS uses vios to index service tree, implementing CGROUP
should be relative easy. Hierarchy CGROUP can be easily implemented too,
which CFQ is still lacking.

The series are orgnized as:
Patch 1: The core FIOPS.
Patch 2: request read/write vios scale. This demontrates how the vios scale.
Patch 3: sync/async scale.
Patch 4: ioprio support
Patch 5: a tweak to preserve deep iodepth task share
Patch 6: a tweek to further bias sync task
Patch 7: basic trace mesage support
Patch 8: a debug patch to do sync workload preemption

TODO:
1. request size based vios scale
2. cgroup support
3. automatically select default iosched according to QUEUE_FLAG_NONROT.

Comments and suggestions are welcome!
