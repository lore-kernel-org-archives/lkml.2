Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab3AALwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 06:52:46 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:30176 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab3AALwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 06:52:44 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=aTVRNjW1y6NjoOpVf0TT9V0PHXDfZZQvid8DyjJaX1w= c=1 sm=1
 a=z4rSCaSvssEA:10 a=Du29GOhDAGUA:10 a=FGLzUi7B6sIA:10 a=BLceEmwcHowA:10
 a=kj9zAlcOel0A:10 a=eeMGdU6VVFt2UVJcxx6VzA==:17 a=07d9gI8wAAAA:8
 a=m0bHr2FCAAAA:8 a=6WXkX7kQAAAA:8 a=UYjFafxSK8EXK-4bZuUA:9
 a=CjuIK1q_8ugA:10 a=UZYMrmiIyDoA:10 a=Q0GbjdkhIAgA:10 a=OvKJlHuG_2ZTSCyB:21
 a=wyU1xzNQNs7fh0c3:21 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
From: Daniel Phillips <lkml@phunq.net>
To: linux-kernel@vger.kernel.org
Subject: Tux3 report: New news for the new year
Date: Tue, 01 Jan 2013 03:52:43 -0800
Message-ID: <2597526.usDRg4h3X1@mars>
Organization: tux3.org
User-Agent: KMail/4.8.5 (Linux/3.2.0-35-generic-pae; KDE/4.8.5; i686; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody,

The Tux3 project has some interesting news to report for the new year. In 
brief, the first time Hirofumi ever put together all the kernel pieces in his 
magical lab over in Tokyo, our Tux3 rocket took off and made it straight to 
orbit. Or in less metaphorical terms, our first meaningful benchmarks turned in 
numbers that meet or even slightly beat the illustrious incumbent, Ext4:

    fsstress -f dread=0 -f dwrite=0 -f fsync=0 -f fdatasync=0 \
          -s 1000 -l 200 -n 200 -p 3

    ext4

        time       cpu      wait
        46.338, 1.244, 5.096
        49.101, 1.144, 5.896
        49.838, 1.152, 5.776

    tux3

        time       cpu      wait
        46.684, 0.592, 1.860
        44.011, 0.684, 1.764
        43.773, 0.556, 1.888

Fsstress runs a mix of filesystem operations typical of a Linux system under 
heavy load. In this test, Tux3 spends less time waiting than Ext4, uses less 
CPU (see below) and finishes faster on average. This was exciting for us, 
though we must temper our enthusiasm by noting that these are still early 
results and several important bits of Tux3 are as yet unfinished. While we do 
not expect the current code to excel at extreme scales just yet, it seems we 
are already doing well at the scale that resembles computers you are running 
at this very moment.

About Tux3

Here is a short Tux3 primer. Tux3 is a general purpose LInux filesystem 
developed by a group of us mainly for the fun of it. Tux3 started in summer of 
2008, as a container for a new storage versioning algorithm originally meant 
to serve as a new engine for the ddsnap volume snapshot virtual device:

    http://lwn.net/Articles/288896/
    "Versioned pointers: a new method of representing snapshots"

As design work proceeded on a suitably simple filesystem with modern features, 
the focus shifted from versioning to the filesystem itself, as the latter is a 
notoriously challenging and engaging project. Initial prototyping was done in 
user space by me and others, and later ran under Fuse, a spectacular driveby 
contribution from one Tero Roponen. Hirofumi joined the team with an amazing 
utility that makes graphs of the disk structure of Tux3 volumes, and soon took 
charge of the kernel port. I stand in awe of Hirofumi's design sense, detail 
work and general developer prowess.

Like a German car, Tux3 is both old school and modern. Closer in spirit to 
Ext4 than Btrfs, Tux3 sports an inode table, allocates blocks with bitmaps, 
puts directories in files, and stores attributes in inodes. Like Ext4 and 
Btrfs, Tux3 uses extents indexed by btrees. Source file names are familiar: 
balloc.c, namei.c etc. But Tux3 has some new files like filemap.c and log.c that 
help make it fast, compact, and very ACID.

Unlike Ext4, Tux3 keeps inodes in a btree, inodes are variable length, and all 
inode attributes are variable length and optional. Also unlike Ext4, Tux3 
writes nondestructively and uses a write-anywhere log instead of a journal.

Differences with Btrfs are larger. The code base is considerably smaller, 
though to be sure, some of that can be accounted for by incomplete features. 
The Tux3 filesystem tree is single-rooted, there is no forest of shared trees. 
There is no built-in volume manager. Names and inodes are stored separately. 
And so on. But our goal is the same: a modern, snapshotting, replicating 
general purpose filesystem, which I am happy to say, seems to have just gotten 
a lot closer.

Front/Back Separation

At the heart of Tux3's kernel implementation lies a technique we call 
"front/back separation", which partly accounts for the surprising kernel CPU 
advantage in the above benchmark results. Tux3 runs as two, loosely coupled 
pieces: the frontend, which handles Posix filesystem operations entirely in 
cache, and the backend, which does the brute work of preparing dirty cache for 
atomic transfer to media. The frontend shows up as kernel CPU accounted to the 
Fsstress task, while the backend is largely invisible, running on some 
otherwise idle CPU. We suspect that the total of frontend and backend CPU is 
less than Ext4 as well, but so far nobody has checked. What we do know, is 
that filesystem operations tend to complete faster when they only need to deal 
with cache and not little details such as backing store.

Front/back separtion is like taking delayed allocation to its logical 
conclusion: every kind of structural change is delayed, not just block 
allocation. I credit Matt Dillon of Dragonfly fame for this idea. He described 
the way he used it in Hammer as part of this dialog:

   http://kerneltrap.org/Linux/Comparing_HAMMER_And_Tux3
   "Comparing HAMMER And Tux3"

Hammer is a cluster filesystem, but front/back separation turns out to be 
equally effective on a single node. Of course, the tricky part is making the 
two pieces run asynchronously without stalling on each other. Which brings us 
to...

Block Forking

Block forking is an idea that has been part of Tux3 from the beginning, and 
roughly resembles the "stable pages" work now underway. Unlike stable pages, 
block forking does not reduce performance. Quite the contrary - block forking 
enables front/back separation, which boosted Tux3 Fsstress performance about 
40%. The basic idea of block forking is to never wait on pages under IO, but 
clone them instead. This protects in-flight pages  from damage by VFS syscalls 
without forcing page cache updates to stall on writeback.

Implementing this simple idea is harder than it sounds. We need to deal with 
multiple blocks being accessed asynchronously on the same page, and we need to 
worry a lot about cache object lifetimes and locking. Especially in truncate, 
things can get pretty crazy. Hirofumi's work here can only be described by one 
word:  brilliant.

Deltas and Strong Consistency

Tux3 groups frontend update transactions into "deltas". According to some 
heuristic, one delta ends and the next one begins, such that all dirty cache 
objects affected by the operations belonging to a given delta may be 
transferred to media in a single atomic operation. In particular, we take care 
that directory updates always lie in the same delta as associated updates such 
as creating or deleting inode representations in the inode table.

Tux3 always cleans dirty cache completely on each delta commit. This is not 
traditional behavior for Linux filesystems, which normally let the core VM 
memory flusher tell them which dirty pages of which inodes should be flushed to 
disk. We largely ignore the VM's opinion about that and flush everything, every 
delta. You might think this would hurt performance, but apparently it does 
not. It does allow us to implement stronger consistency guarantees than 
typical for Linux.

We provide two main guarantees:

   *  Atomicity: File data never appears on media in an intermediate state, 
      with the single exception of large file writes, which may be broken
      across multiple deltas, but with write ordering preserved.

   * Ordering: If one filesystem transaction ends before another transaction 
      begins, then the second transaction will never appear on durable media
      unless the first does too.

Our atomicity guarantee resembles Ext4's data=journal but performs more like 
data=ordered. This is interesting, considering that Tux3 always writes 
nondestructively. Finding a new, empty location for each block written and 
updating the associated metadata would seem to carry a fairly hefty cost, but 
apparently it does not.

Our ordering guarantee has not been seen on Linux before, as far as we know. 
We get it "for free" from Tux3's atomic update algorithm. This could possibly 
prove useful to developers of file-based databases, for example, mailers and 
MTAs. (Kmail devs, please take note!)

Logging and Rollup

Tux3 goes out of its way to avoid recursive copy on write, that is, the 
expensive behavior where a change to a data leaf must be propagated all the 
way up the filesystem tree to the root, to avoid altering data that belongs to 
a previously committed consistent filesystem image. (Btrfs extends this 
recursive copy on write idea to implement snapshots, but Tux3 does not.)

Instead of writing out changes to parents of altered blocks, Tux3 only changes 
the parents in cache, and writes a description of each change to a log on 
media. This prevents recursive copy-on-write. Tux3 will eventually write out 
such retained dirty metadata blocks in a process we call "rollup", which 
retires log blocks and writes out dirty metadata blocks in full. A delta 
containing a rollup also tidily avoids recursive copy on write: just like any 
other delta, changes to the parents of redirected blocks are made only in 
cache, and new log entries are generated.

Tux3 further employs logging to make the allocation bitmap overhead largely 
vanish. Tux3 retains dirty bitmaps in memory and writes a description of each 
allocate/free to the log. It is much cheaper to write out one log block than 
potentially many dirty bitmap blocks, each containing only a few changed bits.

Tux3's rollup not only avoids expensive recursive copy on write, it optimizes 
updating in a least three ways.

  * Multiple deltas may dirty the same metadata block multiple times but
     rollup only writes those blocks once.

  * Multiple metadata blocks may be written out in a single, linear pass
     across spinning media.

  * Backend structure changes are batched in a cache friendly way.

One curious side effect of Tux3's log+rollup strategy is that in normal 
operation, the image of a Tux3 filesystem is never entirely consistent if 
considered only as literal block images. Instead, the log must be replayed in 
order to reconstruct dirty cache, then the view of the filesystem tree from 
dirty cache is consistent.

This is more or less the inverse of the traditional view where a replay 
changes the media image. Tux3 replay is a true read-only operation that leaves 
media untouched and changes cache instead. In fact, this theme runs 
consistently through Tux3's entire design. As a filesystem, Tux3 cares about 
updating cache, moving data between cache and media, and little else.

Tux3 does not normally update the media view of its filesystem tree  even at 
unmount. Instead, it replays the log on each mount. One excellent reason for 
doing this is to exercise our replay code. (You surely would not want to 
discover replay flaws only on the rare occasions you crash.) Another reason is 
that we view sudden interruption as the normal way a filesystem should shut 
down. We uphold your right to hit the power switch on a computing device and 
expect to find nothing but consistent data when you turn it back on.

Fast Sync

Tux3 can sync a minimal file data change to disk by writing four blocks, or a 
minimal file create and write with seven blocks:

    http://phunq.net/pipermail/tux3/2012-December/000011.html
    "Full volume sync performance"

This is so fast that we are tempted to implement fsync as sync. However, we 
intend to resist that temptation in the long run, and implement an optimized 
fsync that "jumps the queue" of Tux3's delta update pipeline and completes 
without waiting for a potentially large amount of unrelated dirty cache to be 
flushed to media.

Still to do

There is a significant amount of work still needed to bring Tux3 to a 
production state. As of today, Tux3 does not have snapshots, in spite of that 
being the main motivation for starting on this in the first place. The new 
PHtree directory index is designed, not implemented. Freespace management 
needs acceleration before it will benchmark well at extreme scale. Block 
allocation needs to be much smarter before it will age well and resist read 
fragmentation. There are several major optimizations still left to implement. 
We need a good fsck that approaches the effectiveness of e2fsck. There is a 
long list of shiny features to add:  block migration, volume growing and 
shrinking, defragmentation, dedupilcation, replication, and so on.

We have made plausible plans for all of the above, but indeed the devil is in 
the doing. So we are considering the merits of invoking the "many hands make 
light work" principle. Tux3 is pretty well documented and the code base is, if 
not completely obvious, at least small and orthogonal. Tux3 runs in userspace 
in two different ways: the tux3 command and fuse. Prototyping in user space is 
a rare luxury that could almost make one lazy. Tux3 is an entirely grassroots 
effort driven by volunteers. Nonetheless, we would welcome offers of 
assistance from wherever they may come, especially testers.

Regards,

Daniel
