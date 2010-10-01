Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab0JAGpu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 02:45:50 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46505 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706Ab0JAGps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 02:45:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TfuLdqdsyZivsbo7tpwUXG53W2Wcj14B6KyFZx6u72ccYnUaznEuviRrAMJ/sJmqnv
         K8zmAbORJPNun/mjRKsGbXam7026MFTw3q79ime2u70If1mV+vhX1zFZwJ1y77n1if2k
         IijNTq7u4JnQJAHY9RcvDg9TTiXKFEKotfpU4=
Subject: Re: [PATCH] fs: inode per-cpu last_ino allocator
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101001061215.GJ32349@infradead.org>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
	 <1285762729-17928-16-git-send-email-david@fromorbit.com>
	 <20100929215312.5fcb6976.akpm@linux-foundation.org>
	 <1285824982.5211.675.camel@edumazet-laptop>
	 <1285833189.2615.31.camel@edumazet-laptop>
	 <20100930011417.6ca16ed7.akpm@linux-foundation.org>
	 <1285842136.2615.251.camel@edumazet-laptop>
	 <20100930094558.97c9afa2.akpm@linux-foundation.org>
	 <1285867685.2615.865.camel@edumazet-laptop>
	 <20101001061215.GJ32349@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Oct 2010 08:45:31 +0200
Message-ID: <1285915531.2705.130.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 01 octobre 2010 à 02:12 -0400, Christoph Hellwig a écrit :
> Eric,
> 
> what workload did this matter for?  As mentioned elsewhere we don't
> actually need to set i_ino in new_inode in many cases.  Normal
> disk/network filesystem already set their own i_ino anyway and don't
> need it at all.  Various in-kernel filesystems don't need any valid
> i_ino and Nick's full series actually has a patch dealing with it,
> which only leaves various user-mountable syntetic filesystems that
> want to generate an inode number, and IMHO they're better off using
> iunique.
> 

Dont focus on this small last_ino problem, it is only one problem out of
a huge pile.

As you might know, I am mostly a netdev guy ;)

In 2008, I tried to scale workloads that need to setup / dismantles
thousand of sockets per second. Then Nick took the challenge, because it
was clear nobody was interested to review my stuff, or maybe I was not
enough re-sending patches.

FS guys live in a closed world, it seems, they want to control every bit
of patches.

for (i = 0; i < LIMIT; i++)
	close(socket(...));

My results were impressive :

(From 27.5 seconds to 1.62 s, on a 8 cpus machine)


http://linux.derkeiler.com/Mailing-Lists/Kernel/2008-12/msg04479.html
(fs: Scalability of sockets/pipes allocation/deallocation on SMP)

<quote>
Hi Andrew

Take v2 of this patch serie got no new feedback, maybe its time for mm
inclusion for a while ?

In this third version I added last two patches, one intialy from
Christoph
Lameter, and one to avoid dirtying mnt->mnt_count on hardwired fs.

Many thanks to Christoph and Paul for this SLAB_DESTROY_PER_RCU work
done
on "struct file".

Thank you

Short summary : Nice speedups for allocation/deallocation of
sockets/pipes
(From 27.5 seconds to 1.62 s, on a 8 cpus machine)

Long version :

To allocate a socket or a pipe we :

0) Do the usual file table manipulation (pretty scalable these days,
but would be faster if 'struct file' were using SLAB_DESTROY_BY_RCU
and avoid call_rcu() cache killer). This point is addressed by 6th
patch.

1) allocate an inode with new_inode()
This function :
- locks inode_lock,
- dirties nr_inodes counter
- dirties inode_in_use list (for sockets/pipes, this is useless)
- dirties superblock s_inodes. - dirties last_ino counter
All these are in different cache lines unfortunatly.

2) allocate a dentry
d_alloc() takes dcache_lock,
insert dentry on its parent list (dirtying sock_mnt->mnt_sb->s_root)
dirties nr_dentry

3) d_instantiate() dentry (dcache_lock taken again)

4) init_file() -> atomic_inc() on sock_mnt->refcount


At close() time, we must undo the things. Its even more expensive
because
of the _atomic_dec_and_lock() that stress a lot, and because of two
cache
lines that are touched when an element is deleted from a list
(previous and next items)

This is really bad, since sockets/pipes dont need to be visible in
dcache
or an inode list per super block.

This patch series get rid of all but one contended cache lines for
sockets, pipes and anonymous fd (signalfd, timerfd, ...)

socketallocbench is a very simple program (attached to this mail) that
makes
a loop :

for (i = 0; i < 1000000; i++)
close(socket(AF_INET, SOCK_STREAM, 0));

Cost if one cpu runs the program :

real 1.561s
user 0.092s
sys 1.469s

Cost if 8 processes are launched on a 8 CPU machine
(socketallocbench -n 8) :

real 27.496s <<<< !!!! >>>>
user 0.657s
sys 3m39.092s

Oprofile results (for the 8 process run, 3 times):

CPU: Core 2, speed 3000.03 MHz (estimated)
Counted CPU_CLK_UNHALTED events (Clock cycles when not halted) with a
unit
mask of 0x00 (Unhalted core cycles) count 100000
samples cum. samples % cum. % symbol name
3347352 3347352 28.0232 28.0232 _atomic_dec_and_lock
3301428 6648780 27.6388 55.6620 d_instantiate
2971130 9619910 24.8736 80.5355 d_alloc
241318 9861228 2.0203 82.5558 init_file
146190 10007418 1.2239 83.7797 __slab_free
144149 10151567 1.2068 84.9864 inotify_d_instantiate
143971 10295538 1.2053 86.1917 inet_create
137168 10432706 1.1483 87.3401 new_inode
117549 10550255 0.9841 88.3242 add_partial
110795 10661050 0.9275 89.2517 generic_drop_inode
107137 10768187 0.8969 90.1486 kmem_cache_alloc
94029 10862216 0.7872 90.9358 tcp_close
82837 10945053 0.6935 91.6293 dput
67486 11012539 0.5650 92.1943 dentry_iput
57751 11070290 0.4835 92.6778 iput
54327 11124617 0.4548 93.1326 tcp_v4_init_sock
49921 11174538 0.4179 93.5505 sysenter_past_esp
47616 11222154 0.3986 93.9491 kmem_cache_free
30792 11252946 0.2578 94.2069 clear_inode
27540 11280486 0.2306 94.4375 copy_from_user
26509 11306995 0.2219 94.6594 init_timer
26363 11333358 0.2207 94.8801 discard_slab
25284 11358642 0.2117 95.0918 __fput
22482 11381124 0.1882 95.2800 __percpu_counter_add
20369 11401493 0.1705 95.4505 sock_alloc
18501 11419994 0.1549 95.6054 inet_csk_destroy_sock
17923 11437917 0.1500 95.7555 sys_close


This patch serie avoids all contented cache lines and makes this "bench"
pretty fast.


New cost if run on one cpu :

real 1.245s (instead of 1.561s)
user 0.074s
sys 1.161s


If run on 8 CPUS :

real 1.624s
user 0.580s
sys 12.296s


On oprofile, we finally can see network stuff coming at the front of
expensive stuff. (with the exception of kmem_cache_[z]alloc(), because
it has to clear 192 bytes of file structures, this takes half of the
time)

CPU: Core 2, speed 3000.09 MHz (estimated)
Counted CPU_CLK_UNHALTED events (Clock cycles when not halted) with a
unit mask of 0x00 (Unhalted core cycles) count 100
000
samples cum. samples % cum. % symbol name
176586 176586 10.9376 10.9376 kmem_cache_alloc
169838 346424 10.5196 21.4572 tcp_close
105331 451755 6.5241 27.9813 tcp_v4_init_sock
105146 556901 6.5126 34.4939 tcp_v4_destroy_sock
83307 640208 5.1600 39.6539 sysenter_past_esp
80241 720449 4.9701 44.6239 inet_csk_destroy_sock
74263 794712 4.5998 49.2237 kmem_cache_free
56806 851518 3.5185 52.7422 __percpu_counter_add
48619 900137 3.0114 55.7536 copy_from_user
44803 944940 2.7751 58.5287 init_timer
28539 973479 1.7677 60.2964 d_alloc
27795 1001274 1.7216 62.0180 alloc_fd
26747 1028021 1.6567 63.6747 __fput
24312 1052333 1.5059 65.1805 sys_close
24205 1076538 1.4992 66.6798 inet_create
22409 1098947 1.3880 68.0677 alloc_inode
21359 1120306 1.3230 69.3907 release_sock
19865 1140171 1.2304 70.6211 fd_install
19472 1159643 1.2061 71.8272 lock_sock_nested
18956 1178599 1.1741 73.0013 sock_init_data
17301 1195900 1.0716 74.0729 drop_file_write_access
17113 1213013 1.0600 75.1329 inotify_d_instantiate
16384 1229397 1.0148 76.1477 dput
15173 1244570 0.9398 77.0875 local_bh_enable_ip
15017 1259587 0.9301 78.0176 local_bh_enable
13354 1272941 0.8271 78.8448 __sock_create
13139 1286080 0.8138 79.6586 inet_release
13062 1299142 0.8090 80.4676 sysenter_do_call
11935 1311077 0.7392 81.2069 iput_single


This patch serie contains 7 patches, against linux-2.6 tree,
plus one patch in mm (fs: filp_cachep can be static in fs/file_table.c)

[PATCH 1/7] fs: Use a percpu_counter to track nr_dentry

Adding a percpu_counter nr_dentry avoids cache line ping pongs
between cpus to maintain this metric, and dcache_lock is
no more needed to protect dentry_stat.nr_dentry

We centralize nr_dentry updates at the right place :
- increments in d_alloc()
- decrements in d_free()

d_alloc() can avoid taking dcache_lock if parent is NULL

("socketallocbench -n 8" bench result : 27.5s to 25s)

[PATCH 2/7] fs: Use a percpu_counter to track nr_inodes

Avoids cache line ping pongs between cpus and prepare next patch,
because updates of nr_inodes dont need inode_lock anymore.

("socketallocbench -n 8" bench result : no difference at this point)

[PATCH 3/7] fs: Introduce a per_cpu last_ino allocator

new_inode() dirties a contended cache line to get increasing
inode numbers.

Solve this problem by providing to each cpu a per_cpu variable,
feeded by the shared last_ino, but once every 1024 allocations.

This reduce contention on the shared last_ino, and give same
spreading ino numbers than before.
(same wraparound after 232 allocations)

("socketallocbench -n 8" result : no difference)


[PATCH 4/7] fs: Introduce SINGLE dentries for pipes, socket, anon fd

Sockets, pipes and anonymous fds have interesting properties.

Like other files, they use a dentry and an inode.

But dentries for these kind of files are not hashed into dcache,
since there is no way someone can lookup such a file in the vfs tree.
(/proc/{pid}/fd/{number} uses a different mechanism)

Still, allocating and freeing such dentries are expensive processes,
because we currently take dcache_lock inside d_alloc(), d_instantiate(),
and dput(). This lock is very contended on SMP machines.

This patch defines a new DCACHE_SINGLE flag, to mark a dentry as
a single one (for sockets, pipes, anonymous fd), and a new
d_alloc_single(const struct qstr *name, struct inode *inode)
method, called by the three subsystems.

Internally, dput() can take a fast path to dput_single() for
SINGLE dentries. No more atomic_dec_and_lock()
for such dentries.


Differences betwen an SINGLE dentry and a normal one are :

1) SINGLE dentry has the DCACHE_SINGLE flag
2) SINGLE dentry's parent is itself (DCACHE_DISCONNECTED)
This to avoid taking a reference on sb 'root' dentry, shared
by too many dentries.
3) They are not hashed into global hash table (DCACHE_UNHASHED)
4) Their d_alias list is empty

(socket8 bench result : from 25s to 19.9s)

[PATCH 5/7] fs: new_inode_single() and iput_single()

Goal of this patch is to not touch inode_lock for socket/pipes/anonfd
inodes allocation/freeing.

SINGLE dentries are attached to inodes that dont need to be linked
in a list of inodes, being "inode_in_use" or "sb->s_inodes"
As inode_lock was taken only to protect these lists, we avoid taking it
as well.

Using iput_single() from dput_single() avoids taking inode_lock
at freeing time.

This patch has a very noticeable effect, because we avoid dirtying of
three contended cache lines in new_inode(), and five cache lines
in iput()

("socketallocbench -n 8" result : from 19.9s to 3.01s)


[PATH 6/7] fs: struct file move from call_rcu() to SLAB_DESTROY_BY_RCU

From: Christoph Lameter <cl@xxxxxxxxxxxxxxxxxxxx>

Currently we schedule RCU frees for each file we free separately. That
has
several drawbacks against the earlier file handling (in 2.6.5 f.e.),
which
did not require RCU callbacks:

1. Excessive number of RCU callbacks can be generated causing long RCU
queues that in turn cause long latencies. We hit SLUB page allocation
more often than necessary.

2. The cache hot object is not preserved between free and realloc. A
close
followed by another open is very fast with the RCUless approach because
the last freed object is returned by the slab allocator that is
still cache hot. RCU free means that the object is not immediately
available again. The new object is cache cold and therefore open/close
performance tests show a significant degradation with the RCU
implementation.

One solution to this problem is to move the RCU freeing into the Slab
allocator by specifying SLAB_DESTROY_BY_RCU as an option at slab
creation
time. The slab allocator will do RCU frees only when it is necessary
to dispose of slabs of objects (rare). So with that approach we can cut
out the RCU overhead significantly.

However, the slab allocator may return the object for another use even
before the RCU period has expired under SLAB_DESTROY_BY_RCU. This means
there is the (unlikely) possibility that the object is going to be
switched under us in sections protected by rcu_read_lock() and
rcu_read_unlock(). So we need to verify that we have acquired the
correct
object after establishing a stable object reference (incrementing the
refcounter does that).

</quote>

http://linux.derkeiler.com/Mailing-Lists/Kernel/2008-12/msg04475.html
(1/7 fs: Use a percpu_counter to track nr_dentry)

http://patchwork.ozlabs.org/patch/13602/
(2/7 Use a percpu_counter to track nr_inodes)

http://patchwork.ozlabs.org/patch/13603/
(3/7 Introduce a per_cpu last_ino allocator)

http://patchwork.ozlabs.org/patch/13605/ 
(4/7 Introduce SINGLE dentries for pipes, socket, anon fd)

...


