Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab2AOW24 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 17:28:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603Ab2AOW2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 17:28:55 -0500
Date: Sun, 15 Jan 2012 17:28:40 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        axboe@kernel.dk, jmoyer@redhat.com
Subject: Re: [RFC 0/3]block: An IOPS based ioscheduler
Message-ID: <20120115222840.GB3174@redhat.com>
References: <20120104065337.230911609@sli10-conroe.sh.intel.com>
 <20120104071931.GB17026@dastard>
 <1325746241.22361.503.camel@sli10-conroe>
 <1325826750.22361.533.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325826750.22361.533.camel@sli10-conroe>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 06, 2012 at 01:12:29PM +0800, Shaohua Li wrote:
> On Thu, 2012-01-05 at 14:50 +0800, Shaohua Li wrote:
> > On Wed, 2012-01-04 at 18:19 +1100, Dave Chinner wrote:
> > > On Wed, Jan 04, 2012 at 02:53:37PM +0800, Shaohua Li wrote:
> > > > An IOPS based I/O scheduler
> > > > 
> > > > Flash based storage has some different characteristics against rotate disk.
> > > > 1. no I/O seek.
> > > > 2. read and write I/O cost usually is much different.
> > > > 3. Time which a request takes depends on request size.
> > > > 4. High throughput and IOPS, low latency.
> > > > 
> > > > CFQ iosched does well for rotate disk, for example fair dispatching, idle
> > > > for sequential read. It also has optimization for flash based storage (for
> > > > item 1 above), but overall it's not designed for flash based storage. It's
> > > > a slice based algorithm. Since flash based storage request cost is very
> > > > low, and drive has big queue_depth is quite popular now which makes
> > > > dispatching cost even lower, CFQ's slice accounting (jiffy based)
> > > > doesn't work well. CFQ doesn't consider above item 2 & 3.
> > > > 
> > > > FIOPS (Fair IOPS) ioscheduler is trying to fix the gaps. It's IOPS based, so
> > > > only targets for drive without I/O seek. It's quite similar like CFQ, but
> > > > the dispatch decision is made according to IOPS instead of slice.
> > > > 
> > > > The algorithm is simple. Drive has a service tree, and each task lives in
> > > > the tree. The key into the tree is called vios (virtual I/O). Every request
> > > > has vios, which is calculated according to its ioprio, request size and so
> > > > on. Task's vios is the sum of vios of all requests it dispatches. FIOPS
> > > > always selects task with minimum vios in the service tree and let the task
> > > > dispatch request. The dispatched request's vios is then added to the task's
> > > > vios and the task is repositioned in the sevice tree.
> > > > 
> > > > The series are orgnized as:
> > > > Patch 1: separate CFQ's io context management code. FIOPS will use it too.
> > > > Patch 2: The core FIOPS.
> > > > Patch 3: request read/write vios scale. This demontrates how the vios scale.
> > > > 
> > > > To make the code simple for easy view, some scale code isn't included here,
> > > > some not implementated yet.
> > > > 
> > > > TODO:
> > > > 1. ioprio support (have patch already)
> > > > 2. request size vios scale
> > > > 3. cgroup support
> > > > 4. tracing support
> > > > 5. automatically select default iosched according to QUEUE_FLAG_NONROT.
> > > > 
> > > > Comments and suggestions are welcome!
> > > 
> > > Benchmark results?
> > I didn't have data yet. The patches are still in earlier stage, I want
> > to focus on the basic idea first.
> since you asked, I tested in a 4 socket machine with 12 X25M SSD jbod,
> fs is ext4.
> 
> workload		percentage change with fiops against cfq
> fio_sync_read_4k        -2
> fio_mediaplay_64k       0
> fio_mediaplay_128k      0
> fio_mediaplay_rr_64k    0
> fio_sync_read_rr_4k     0
> fio_sync_write_128k     0
> fio_sync_write_64k      -1
> fio_sync_write_4k       -2
> fio_sync_write_64k_create       0
> fio_sync_write_rr_64k_create    0
> fio_sync_write_128k_create      0
> fio_aio_randread_4k     -4
> fio_aio_randread_64k    0
> fio_aio_randwrite_4k    1
> fio_aio_randwrite_64k   0
> fio_aio_randrw_4k       -1
> fio_aio_randrw_64k      0
> fio_tpch        9
> fio_tpcc        0
> fio_mmap_randread_4k    -1
> fio_mmap_randread_64k   1
> fio_mmap_randread_1k    -8
> fio_mmap_randwrite_4k   35
> fio_mmap_randwrite_64k  22
> fio_mmap_randwrite_1k   28
> fio_mmap_randwrite_4k_halfbusy  24
> fio_mmap_randrw_4k      23
> fio_mmap_randrw_64k     4
> fio_mmap_randrw_1k      22
> fio_mmap_randrw_4k_halfbusy     35
> fio_mmap_sync_read_4k   0
> fio_mmap_sync_read_64k  -1
> fio_mmap_sync_read_128k         -1
> fio_mmap_sync_read_rr_64k       5
> fio_mmap_sync_read_rr_4k        3
> 
> The fio_mmap_randread_1k has regression against 3.2-rc7, but no
> regression against 3.2-rc6 kernel, still checking why. The fiops has
> improvement for read/write mixed workload. CFQ is known not good for
> read/write mixed workload.

Set the slice_idle=0 and possibly increase quantum to 32 or 64 and you
should get better performance. I think practically it should become a
IOPS based scheduler with little imprecise accounting.

Thanks
Vivek
