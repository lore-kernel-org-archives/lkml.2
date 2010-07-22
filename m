Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683Ab0GVL4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 07:56:19 -0400
Received: from dtp.xs4all.nl ([80.101.171.8]:30847 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752942Ab0GVL4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 07:56:15 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Jul 2010 07:56:14 EDT
Date: Thu, 22 Jul 2010 13:49:32 +0200
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: linux-kernel@vger.kernel.org
Subject: Notes to filesystem developers.... 
Message-ID: <20100722114931.GA18205@bitwizard.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: BitWizard.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, 

I have some time on my hands so I'm writing this. My fileserver is
running fsck, as it has been for the past two hours.... 

I want to publish some notes about filesystem performance. 

First let's start with the requirements for filesystems: 
What do people want from their filessystems? 

- stable: Doesn't crash and lose data.
- efficient. 
--- efficient in time: should be fast. 
--- efficient in space: should not waste disk space. 

Linux filesystems do a good job at the "stable and space-efficient"
goals. However the "efficient in time" is lacking.
 
We've always done our best! Look, I can access my file in XX ms, which
is close to the performance of the disk!

Yup, you're right. But what really, really can and should be better is
the time to access lots of metadata.

Operations like: "find /data -.... " and "du /data" are taking WAY
longer than they should.

Lets take my another filesystem that I'm not currently waiting for as
an example. (That allows me to count the files and such because it's
mounted)

It is 6 marketing-Tb large (about 5.5 computer-Tb).  That's quite
big. It contains somewhere on the order of 34 million files. 

The "du" command on this filesystem takes 14 hours....

So, what is required for this "du" command to finish? It has to stat
all 34 million files. This requires CPU time. Let me estimate how
much: 

On my workstation, a du -s of the root filessytem with 3 million files
takes 0.7 seconds (after caching all the disk accesses). Allow a
factor of 11 for more files, and a factor of two for a slower machine
and we end up with 15 seconds CPU time. Negligable compared to 14
hours. We can disregard CPU time from our calculations from now on.

What seems to be taking all this time is that du is statting all the
files and that this requires the inode to be read into memory.

How much info are we talking about?

Inodes are 128 or 256 bytes. In the case at hand, according to the
superblock: 128 bytes.

So for 34M files, that comes to 4.3Gb of inode data. Reading that from
the disks can be done in: 35 seconds, assuming 120Mb/second
throughput. The filesystem is stored on 4 disks in a raid
configuration. So while each disk is capable of 120Mb per second, we
should be able to achieve 4 times this performance for the raid device.

So reading the actual inode data from disk takes about 2.5 times
longer than the CPU time required. Still negligable compared to
reality.

What else needs to be read from disk? The directories themselves of
course!

So we have 34M files. The directory doesn't store much besides the
filename and the inode number, so the required disk space is: 
number of files * (overhead + filenamelenght).

A 6 character filename is stored in a 16 character record, so we
can take 10 for the overhead (an 8 character filename is also stored
in 16 characters, so this is taking some margin). 

With an average filename length of 16 characters, that would come to
26 bytes per directory entry. Or for 34M files, to 900Mb of
data. Again an amount of data that can be read from disk in a
timeframe of less than a minute (I'm getting tired of getting out
the calculator). 

If we consider the case of an "fsck" (or delete), the system also has
to access all the indirect blocks. This is of course getting better as
ext4 is using extents instead of indirect blocks.

The cost of indirect blocks is 4096 bytes for 1024 indirect pointers
pointing to 1024 blocks of 4096 bytes (4M). That comes to 0.1%. So for
every Tb of data, we have a Gb of indirect blocks. With extents I
expect this data to reduce to insignificant amounts. (A file of 1Gb
will have around 8 extents each describing (in 16 bytes?) 128Mb
(assuming the block groups haven't grown as I'm advocating below). So
the cost of this drops to 100 bytes per Gb... For small files it'll be
16 bytes per file, already included in the inode.)

So where is all this time actually spent?

All the disk-performance figures are assuming linear reads. But in
reality there are some (understatement) seeks involved. In fact, if we
assume around 10ms (*) for every seek, about 5 million of them.

So the problem is that the filesystem metadata (inodes, directory
info) is fragmented into around 5 million small pieces!

The solution that this suggests is to make sure that this
fragmentation doesn't happen so radically.

There are several things we can and should do. 

In the beginning we decided that it would be nice to have block
groups. Partially for performance reasons partly for reliability
reasons. In those times filesystem blocks were 1k, and there was
headroom to have bigger filesystem blocks and with that the block
group size could grow quadratically with the filesystem block
size. That was a good idea back then, but with the filesystem block
size maxing out at the CPU page size of 4k, block groups maxed out at
128M per block group. Not good. In the beginning having 8 or 32 block
groups on a 1G disk was just fine. But having 50000 block groups on a
6T filesystem is way too much.

Why aren't block groups larger? Because it was thought that 1
filesystem block of block-in-use bits would be enough. What we need to
change is that this constant: number of filesystem blocks per block
group for the in-use bitmap. Was 1 -> Now configurable.

Next, we have the filesystem meta information scattered over 50
million places (judging from the running time).....

What filesystem meta information is there? There are the
bitmaps. Those are relevant for writing data: finding new blocks for a
file, etc. Not for the "du".

Next there are the inodes and the directories. The inodes are nicely
packed in the beginning of the block group. And because these are used
starting at the lowest number, with most usage patterns, there will be
an area with a high-density of in-use inodes. Great. 

The directories however are a different thing. Those mingle with the
actual data. This is not good for filesystem-walking applications.

A way that I think might go a long way fix this is to do the
following: Datablocks are allocated from the bottom of the block
group, the directory blocks and other metadata from the top. The
disadvantage is that IF we are linearly reading a file, the indirect
blocks will be located "somewhere else" With bad caching policies this
would cause two seeks for every 4Mb of data. So with a disk normally
capable of 100Mb/sec, we add 20ms of seek-time to read each

After doing all this, we need to do one more thing. Instead of reading
just the 4k of inode info that we need, we should read say an
additional 60k of inodes. Especially when something is traversing the
directory tree, the hit ratio of such a policy will greatly outweigh
the penalties. The same goes for the directory info. The chances that
we'll be reading directories that are going to be needed soon-ish are
large. But already, the 32M buffer in a modern disk will give a nice
performance boost if we do not implement this just yet.

Especially now that ext4 has already implemented extents, we should
not bother with the indirect blocks. They too would benefit from being
together at either the start or the end of a block group. However the
ext3 filesystem would recieve an enormous boost in delete-performance
if we were to allocate indirect blocks from the top of the block group
(#)....

	Roger Wolff. 


(*) You'll see manufacturers claim seek times of say 7ms. However,
they conveniently omit the rotational latency that is equally
important to us. Rotational latency for a 7200RPM drive is 4.2 ms on
average.

(#) When taking the topmost free block every time, when deleting a
file you will be accessing the blocks in decreasing order every
time. Some disks will then take exactly 8ms before delivering the next
block. Much better is to take the topmost free block, then scan
downward for a USED block, but a maximum of say 16 blocks. In either
case, use the next block. So you'll use BGE-15, BGE-14, BGE-13
... BGE-1, BGE-31, BGE-30 .... in that order (BGE is the Block Group
End). Now you'll only incur the 8ms penalty once every 16 accesses....
This is not an issue on disks that have a buffer that is larger than
the track or cylinder size. They will usually buffer the whole
track or cylinder.

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
