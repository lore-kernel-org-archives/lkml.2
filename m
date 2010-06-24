Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab0FXDPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:15:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:48425 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753660Ab0FXDPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:15:42 -0400
Message-Id: <20100624030212.676457061@suse.de>
User-Agent: quilt/0.48-4.4
Date: Thu, 24 Jun 2010 13:02:12 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: [patch 00/52] vfs scalability patches updated
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://www.kernel.org/pub/linux/kernel/people/npiggin/patches/fs-scale/

Update to vfs scalability patches:

- Lots of fixes, particularly RCU inode stuff
- Lots of cleanups and aesthetic to the code, ifdef reduction etc
- Use bit locks for inode and dentry hashes
- Small improvements to single-threaded performance
- Split inode LRU and writeback list locking
- Per-bdi inode writeback list locking
- Per-zone mm shrinker
- Per-zone dentry and inode LRU lists
- Several fixes brought in from -rt tree testing
- No global locks remain in any fastpaths (arguably, rename)

I have not included the store-free path walk patches in this posting. They
require a bit more work and they will need to be reworked after
->d_revalidate/->follow_mount changes that Al wants to do. I prefer to
concentrate on these locking patches first.

Autofs4 is sadly missing. It's a bit tricky, patches have to be reworked.

Performance:
Last time I was testing on a 32-node Altix which could be considered as not a
sweet-spot for Linux performance target (ie. improvements there may not justify
complexity). So recently I've been testing with a tightly interconnected
4-socket Nehalem (4s/32c/64t). Linux needs to perform well on this size of
system.

*** Single-thread microbenchmark (simple syscall loops, lower is better):
Test                    Difference at 95.0% confidence (50 runs)
open/close              -6.07% +/- 1.075%
creat/unlink            27.83% +/- 0.522%
Open/close is a little faster, which should be due to one less atomic in the
dput common case. Creat/unlink is significantly slower, which is due to RCU
freeing inodes. We have have made the same magnitude of performance regression
tradeoff when going to RCU freed dentries and files as well. Inode RCU is
required for reducing inode hash lookup locking and improve lock ordering,
also for store-free path-walk.

*** Let's take a look at this creat/unlink regression more closely. If we call
rdtsc around the creat/unlink loop, and just run it once (so as to avoid
much of the RCU induced problems):
vanilla: 5328 cycles
    vfs: 5960 cycles (+11.8%)
Not so bad when RCU is not being stressed.

*** 64 parallel git diff on 64 kernel trees fully cached (avg of 5 runs):
                vanilla         vfs
real            0m4.911s        0m0.183s
user            0m1.920s        0m1.610s
sys             4m58.670s       0m5.770s
After vfs patches, 26x increase in throughput, however parallelism is limited
by test spawning and exit phases. sys time improvement shows closer to 50x
improvement. vanilla is bottlenecked on dcache_lock.

*** Google sockets (http://marc.info/?l=linux-kernel&m=123215942507568&w=2):
                vanilla         vfs
real             1m 7.774s      0m 3.245s
user             0m19.230s      0m36.750s
sys             71m41.310s      2m47.320s
do_exit path for
the run took       24.755s         1.219s
After vfs patches, 20x increase in throughput for both the total duration and
the do_exit (teardown) time.

*** file-ops test (people.redhat.com/mingo/file-ops-test/file-ops-test.c)
Parallel open/close or creat/unlink in same or different cwds within the same
ramfs mount. Relative throughput percentages are given at each parallelism
point (higher is better):

open/close           vanilla          vfs
same cwd
1                      100.0        119.1
2                       74.2        187.4
4                       38.4         40.9
8                       18.7         27.0
16                       9.0         24.9
32                       5.9         24.2
64                       6.0         27.7
different cwd
1                      100.0        119.1
2                      133.0        238.6
4                       21.2        488.6
8                       19.7        932.6
16                      18.8       1784.1
32                      18.7       3469.5
64                      19.0       2858.0

creat/unlink         vanilla          vfs
same cwd
1                      100.0         75.0
2                       44.1         41.8
4                       28.7         24.6
8                       16.5         14.2
16                       8.7          8.9
32                       5.5          7.8
64                       5.9          7.4
different cwd
1                      100.0         75.0
2                       89.8        137.2
4                       20.1        267.4
8                       17.2        513.0
16                      16.2        901.9
32                      15.8       1724.0
64                      17.3       1161.8

Note that at 64, we start using sibling threads on the CPU, making results jump
around a bit. The drop at 64 in different-cwd cases seems to be hitting an RCU
or slab allocator issue (or maybe it's just the SMT).

The scalability regression I was seeing in same-cwd tests is no longer there
(is even improved now). It may still be present in some workloads doing
common-element path lookups. This can be solved by making d_count atomic again,
at the cost of more atomic ops in some cases, but scalability is still limited.
So I prefer to do store-free path walking which is much more scalable.

In the different cwd open/close case, cost to bounce cachelines over the
interconnect is putting absolute upper limit of 162K open/closes per second
over the entire machine in vanilla kernel. After vfs patches, it is around 30M.
On larger and less well connected machines, the lower limit will only get lower
while the vfs case should continue to keep going up (assuming mm subsystem
can keep up).

*** Reclaim
I have not done much reclaim testing yet. It should be more scalable and lower
latency due to significant reduction in lru locks interfering with other
critical sections in inode/dentry code, and because we have per-zone locks.
Per-zone LRUs mean that reclaim is targetted to the correct zone, and that
kswapd will operate on lists of node-local memory objects.


