Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065Ab1G2Bif (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 21:38:35 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:65472 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755228Ab1G2Bie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 21:38:34 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqwFAHIOMk55LCkBgWdsb2JhbAB8ICUaaQEqA0GYV48GFQEBFiYlymoOhVRfBKNv
Date: Fri, 29 Jul 2011 11:38:30 +1000
From: Dave Chinner <david@fromorbit.com>
To: linux-kernel@vger.kernel.org
Cc: luto@MIT.EDU, mingo@elte.hu
Subject: [3.0-rc0 Regression]: legacy vsyscall emulation increases user CPU
 time by 20%
Message-ID: <20110729013830.GC5404@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

It-s merge window again, which means I'm doing my usual "where did
the XFS performance go" bisects again. The usual workload:

$ time sudo mkfs.xfs -f -d agcount=32 -l size=131072b /dev/vda
meta-data=/dev/vda               isize=256    agcount=32, agsize=134217728 blks
         =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=4294967296, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=131072, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

real    0m4.496s
user    0m0.012s
sys     0m0.196s
$ sudo mount -o nobarrier,logbsize=262144,inode64 /dev/vda /mnt/scratch
$ sudo chmod 777 /mnt/scratch
$ cd /home/dave/src/fs_mark-3.3/
$ /usr/bin/time ./fs_mark -D 10000 -S0 -n 100000 -s 0 -L 63 -d /mnt/scratch/0 -d /mnt/scratch/1 -d /mnt/scratch/2 -d /mnt/scratch/3 -d /mnt/scratch/4 -d /mnt/scratch/5 -d /mnt/scratch/6 -d /mnt/scratch/7

On a 8p 4GB RAM VM and a 16TB filesystem. On 3.0, this completes in:

     0     48000000            0     110068.2          7165149
     0     48800000            0     112275.1          7523326
     0     49600000            0     111725.3          9002077
     0     50400000            0     109074.4          7111665
246.67user 2903.42system 8:16.96elapsed 633%CPU (0avgtext+0avgdata 82544maxresident)k
0inputs+0outputs (1639major+2603202minor)pagefaults 0swaps
$

The completion time over multiple runs is ~8m10s +/-5s, and the user
CPU time is roughly 245s +/-5s

Enter 5cec93c2 ("x86-64: Emulate legacy vsyscalls") and the result
ends up at:

     0     48000000            0     108975.2          9507483
     0     48800000            0     114676.5          8604471
     0     49600000            0      98062.0          8921525
     0     50400000            0     103864.7          8218302
287.35user 2933.90system 8:33.11elapsed 627%CPU (0avgtext+0avgdata 82560maxresident)k
0inputs+0outputs (1664major+2603457minor)pagefaults 0swaps

Noticable slow wall time with more variance - it's at 8m30s +/-10s,
and the user CPU time is at 290s +/-5s. So the benchmark is slower to
complete and consumes 20% more CPU in userspace. The following commit
c971294 x86-64: ("Improve vsyscall emulation CS and RIP handling")
also contributes to the slowdown a bit.

FYI, fs_mark does a lot of gettimeofday() calls - one before and
after every syscall that does filesystem work so it can calculate
the syscall times and the amount of time spent not doing syscalls.
I'm assuming this is the problem based on the commit message.
Issuing hundreds of thousands of getimeofday calls per second spread
across multiple CPUs is not uncommon, especially in benchmark or
performance measuring software. If that is the cause, then these
commits add -significant- overhead to that process.

Assuming this is the problem, can this be fixed without requiring
the whole world having to wait for the current glibc dev tree to
filter down into distro repositories?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
