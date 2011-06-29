Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945Ab1F2QFn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 12:05:43 -0400
Received: from mail.betterlinux.com ([199.58.199.50]:40983 "EHLO
	mail.betterlinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402Ab1F2QFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 12:05:40 -0400
Date: Wed, 29 Jun 2011 18:05:32 +0200
From: Andrea Righi <andrea@betterlinux.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/8][V2] blk-throttle: Throttle buffered WRITEs in
 balance_dirty_pages()
Message-ID: <20110629160532.GA1255@thinkpad>
References: <1309275309-12889-1-git-send-email-vgoyal@redhat.com>
 <20110628162138.GA1544@thinkpad>
 <20110628170624.GA12949@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110628170624.GA12949@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 01:06:24PM -0400, Vivek Goyal wrote:
> On Tue, Jun 28, 2011 at 06:21:38PM +0200, Andrea Righi wrote:
> > On Tue, Jun 28, 2011 at 11:35:01AM -0400, Vivek Goyal wrote:
> > > Hi,
> > > 
> > > This is V2 of the patches. First version is posted here.
> > > 
> > > https://lkml.org/lkml/2011/6/3/375
> > > 
> > > There are no changes from first version except that I have rebased it to
> > > for-3.1/core branch of Jens's block tree.
> > > 
> > > I have been trying to find ways to solve two problems with block IO controller
> > > cgroups.
> > > 
> > > - Current throttling logic in IO controller does not throttle buffered WRITES.
> > >   Well it does throttle all the WRITEs at device and by that time buffered
> > >   WRITE have lost the submitter's context and most of the IO comes in flusher
> > >   thread's context at device. Hence currently buffered write throttling is
> > >   not supported.
> > > 
> > > - All WRITEs are throttled at device level and this can easily lead to
> > >   filesystem serialization.
> > > 
> > >   One simple example is that if a process writes some pages to cache and
> > >   then does fsync(), and process gets throttled then it locks up the
> > >   filesystem. With ext4, I noticed that even a simple "ls" does not make
> > >   progress. The reason boils down to the fact that filesystems are not
> > >   aware of cgroups and one of the things which get serialized is journalling
> > >   in ordered mode.
> > > 
> > >   So even if we do something to carry submitter's cgroup information
> > >   to device and do throttling there, it will lead to serialization of
> > >   filesystems and is not a good idea.
> > > 
> > > So how to go about fixing it. There seem to be two options.
> > > 
> > > - Throttling should still be done at device level. Make filesystems aware
> > >   of cgroups so that multiple transactions can make progress in parallel
> > >   (per cgroup) and there are no shared resources across cgroups in
> > >   filesystems which can lead to serialization.
> > > 
> > > - Throttle WRITEs while they are entering the cache and not after that.
> > >   Something like balance_dirty_pages(). Direct IO is still throttled
> > >   at device level. That way, we can avoid these journalling related
> > >   serialization issues w.r.t trottling.
> > 
> > I think that O_DIRECT WRITEs can hit the same serialization problem if
> > we throttle them at device level.
> 
> I think it can but number of cases probably comes down significantly. One
> of the main problems seems to be sync related variants sync/fsync etc.
> And I think we do not make any gurantees for inflight requests
> (not completed yet).
> 
> So it will boil down to how dependent these sync primitives are on
> inflight direct WRITEs. I did basic testing with ext4 and it looked fine.
> On XFS, sync gets blocked behind inflight direct writes. Last time I
> raised that issue and looks like Christoph has plans to do something
> about it.
> 
> So currently my understanding is that dependency on direct writes might
> not be a major issue in practice. (Until and unless there is more to
> it I am not aware about).
> 
> > 
> > Have you tried to do some tests? (i.e. create multiple cgroups with very
> > low I/O limit doing parallel O_DIRECT WRITEs, and try to run at the same
> > time "ls" or other simple commands from the root cgroup or unlimited
> > cgroup).
> 
> I did. On ext4, I created a cgroup with limit 1byte per second and 
> started a direct write and did "ls", "sync" and some directory traversal
> operations in same diretory and it seems to work.

Confirm. Everything seems to work fine also on my side.

Tested-by: Andrea Righi <andrea@betterlinux.com>

FYI, I've used the following script to test it if you're interested.
I tested both with O_DIRECT=1 and O_DIRECT=0.

-Andrea

---
#!/bin/bash
#
# blkio.throttle unit test
#
# This script creates many cgroups and spawns many parallel IO workers inside
# each cgroup.

# cgroupfs mount point
CGROUP_MP=/sys/fs/cgroup/blkio
# temporary directory used to generate IO
TMPDIR=/tmp

# how many cgroups?
CGROUPS=16
# how many IO workers per cgroup?
WORKERS=16
# max IO bandwidth of each cgroup
BW_MAX=$((1 * 1024 * 1024))
# max IO operations per second of each cgroup
IOPS_MAX=0

# IO block size
IO_BLOCK_SIZE=$((1 * 1024 * 1024))
# how many blocks to read/write (for each worker)
IO_BLOCK_NUM=4
# how many times each worker have to repeat the IO operation?
IO_COUNT=16

# enable O_DIRECT?
O_DIRECT=0

# timeout to consider a task blocked for too much time and dump a
# message in the kernel log (set to 0 to disable this check)
HUNG_TASK_TIMEOUT=60

cleanup_handler() {
 	pkill sleep
	pkill dd
	echo "terminating..."
	sleep 10
	rmdir $CGROUP_MP/grp_*
	rm -rf $TMPDIR/grp_*
	sleep 1
	exit 1
}

worker() {
	out=$1

	if [ "z$O_DIRECT" = "z1" ]; then
		out_flags=oflag=direct
		in_flags=iflag=direct
	else
		out_flag=
		in_flag=
	fi
	sleep 5
	for i in `seq 1 16`; do
		dd if=/dev/zero of=$out \
			bs=$IO_BLOCK_SIZE count=$IO_BLOCK_NUM \
			$out_flags 2>/dev/null
	done
	for i in `seq 1 16`; do
		dd if=$out of=/dev/null \
			bs=$IO_BLOCK_SIZE count=$IO_BLOCK_NUM \
			$in_flags 2>/dev/null
	done
	rm -f $out
	unset out
}

spawn_workers() {
	grp=$1
	device=`df $TMPDIR | sed '1d' | awk '{print $1}' | sed 's/[0-9]$//'`
	devnum=`grep $(basename $device)$ /proc/partitions | awk '{print $1":"$2}'`

	mkdir $CGROUP_MP/$grp

	echo $devnum $BW_MAX > $CGROUP_MP/$grp/blkio.throttle.read_bps_device
	echo $devnum $BW_MAX > $CGROUP_MP/$grp/blkio.throttle.write_bps_device

	echo $devnum $IOPS_MAX > $CGROUP_MP/$grp/blkio.throttle.read_iops_device
	echo $devnum $IOPS_MAX > $CGROUP_MP/$grp/blkio.throttle.write_iops_device

	mkdir -p $TMPDIR/$grp
	for i in `seq 1 $WORKERS`; do
		worker $TMPDIR/$grp/zero$i &
		echo $! > $CGROUP_MP/$grp/tasks
	done
	for i in `seq 1 $WORKERS`; do
		wait
	done
	rmdir $TMPDIR/$grp
	rmdir $CGROUP_MP/$grp
	unset grp
}

# mount cgroupfs
mount -t cgroup -o blkio none $CGROUP_MP

# set hung task check timeout (help to catch system-wide lockups)
echo $HUNG_TASK_TIMEOUT > /proc/sys/kernel/hung_task_timeout_secs

# invalidate page cache
sync
echo 3 > /proc/sys/vm/drop_caches

# show expected bandwidth
bw=$(($CGROUPS * $BW_MAX / 1024))
space=$(($CGROUPS * $WORKERS * $IO_BLOCK_SIZE * $IO_BLOCK_NUM / 1024 / 1024))
echo -ne "\n\n"
echo creating $CGROUPS cgroups, $WORKERS tasks per cgroup, bw=$BW_MAX
echo required disk space: $space MiB
echo expected average bandwith: $bw MiB/s
echo -ne "\n\n"

# trap SIGINT and SIGTERM to quit cleanly
trap cleanup_handler SIGINT SIGTERM

# run workers
for i in `seq 1 $CGROUPS`; do
	spawn_workers grp_$i &
done

# wait the completion of the workers
for i in `seq 1 $CGROUPS`; do
	wait
done

echo "test completed."
