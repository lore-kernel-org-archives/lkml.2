Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab2JNMNm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 08:13:42 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56621 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab2JNMNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 08:13:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jaegeuk Kim <jaegeuk.kim@gmail.com>
Subject: Re: [PATCH 01/16] f2fs: add document
Date: Sun, 14 Oct 2012 12:13:22 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: =?utf-8?q?=EA=B9=80=EC=9E=AC=EA=B7=B9?= <jaegeuk.kim@samsung.com>,
        viro@zeniv.linux.org.uk, "'Theodore Ts'o'" <tytso@mit.edu>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
References: <000801cda2f0$672214f0$35663ed0$%kim@samsung.com> <201210131835.53600.arnd@arndb.de> <1350196828.1915.218.camel@kjgkr>
In-Reply-To: <1350196828.1915.218.camel@kjgkr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201210141213.22417.arnd@arndb.de>
X-Provags-ID: V02:K0:Q9wXuq1H9m0I6YKDI4U4K+uPJbzs3sjvwafAp6pwh94
 nZoSRaB4nBU527lMycT96r5WQvp3FoWriMI9DCJdAF/pyxyjse
 A6gm0TF3qtx7Uslhh27IGG4L/xj3oFr0JSL0HfAXdmwfmLZA7i
 FWvN1adREZ65Alq12a+HkbEL+6tJlm2k6zDFqJkAKXJJ1czxk0
 WgnIjv/D+WCN0kjYys4ncjnw7KjH4ULalzDd2sEyJLw3sn0mb0
 YxZRCWCxI1yLujTF2H6YTtPvc2du4rOL1BenfOZqy2b2puwfdc
 3F32ED1FUdkhnGp9ZhHf1O6uJDQefmCSQswoanuVMwEwRd2HZU
 EgLCf3bNOBY8JwxUIdM4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 October 2012, Jaegeuk Kim wrote:
> 2012-10-13 (토), 18:35 +0000, Arnd Bergmann:

> > > +================================================================================
> > > +DESIGN
> > > +================================================================================
> > > +
> > > +On-disk Layout
> > > +--------------
> > > +
> > > +F2FS divides whole volume into a number of segments each of which size is 2MB by
> > > +default. A section is composed of consecutive segments, and a zone consists of a
> > > +set of sections.
> > 
> > A segment size of 2MB should work fine for most eMMC, but there are a lot of
> > devices using TLC (three bit per cell MLC) flash with 1.5/3/6/12 MB erase blocks,
> > in particular cheap SD cards. Your design fundamentally won't work on those if you
> > only allow power-of-two multiples of 2 MB.
> > 
> > Would it be possible to change the segment size to 1.5 MB as a mkfs option?
> > I realize that the space utilization would be slightly worse in that case,
> > but if we allow power-of-two multiples of either 1.5 or 2 MB, that should cover
> > almost all media on the market today, and most likely for the forseeable
> > future.
> 
> Yes, definitely right.
> In the f2fs design, a segment with 2MB is a basic unit to manage the
> whole storage space, but not to align with the erase block size.
> Instead, we have a section for alignment.
> If the erase block size is 1.5MB, I think it is worth to set the
> section size to 6MB.
> The only thing that I have to do is to support configuring the section
> size as just multiples not power-of-two ones.
> How do you think about this?

I think I was confusing the terms 'section' and 'segment' here, I thought the
segment was the larger of the two, sorry about that.

For the 2011 generation of SD cards, changing the segment size to 1.5 MB would
probably give a better performance, as it reduces the overhead from garbage
collection compared to using 6 MB sections with 2 MB segments.

In future devices, I assume we will not see erase blocks under 4 or 6 MB,
so using arbitrary section sizes of multiples of 2 MB should indeed be
good enough. It will also help us if we ever see 5-bit-per-cell flash
and need 10 MB erase blocks, although I have not seen those on any roadmaps
so far.

> Yes, good point.
> Actually, apart from the device side, I've concerned for a long time how
> many logs should be needed and how to use them especially in order to
> reduce the cleaning overhead efficiently in f2fs.
> Finally, I got six logs.
> 
> As you mentioned, it's ok to support 4 log areas as an option.
> But, what I'm concerning is the cleaning overhead.
> In terms of write amplification, is it really beneficial to reduce the
> number of logs for flash storage even though the cleaning overhead
> increases?
> 
> BTW, if the cleaning overhead in 4 logs is not different from that in 6
> logs, absolutely we should use 4 logs.
> This is basically dependant on the workload, and I think it needs more
> research.

I would expect that using 6 rather than 4 is almost always a measurable win
when the hardware supports it, but a much bigger loss if the the hardware
cannot support it.

I believe we can measure the second case pretty well using Tixy's flashsim
tool from http://yxit.co.uk/public/flash-performance/ by taking a blocktrace
of the current code using 6 logs, and then simulating it on devices with
7 and 5 open erase blocks, respectively. On the former case it should
report a write amplification fact of close to '1' for the FTL, in the latter
case it will be significantly higher than that but also workload dependent.

> > > +Each area manages the following contents.
> > > +- CP         File system information, bitmaps for valid NAT/SIT sets, orphan
> > > +             inode lists, and summary entries of current active segments.
> > > +- NAT                Block address table for all the node blocks stored in Main area.
> > > +- SIT                Segment information such as valid block count and bitmap for the
> > > +             validity of all the blocks.
> > > +- SSA                Summary entries which contains the owner information of all the
> > > +             data and node blocks stored in Main area.
> > > +- Main               Node and data blocks.
> > > +
> > > +In order to avoid misalignment between file system and flash-based storage, F2FS
> > > +aligns the start block address of CP with the segment size. Also, it aligns the
> > > +start block address of Main area with the zone size by reserving some segments
> > > +in SSA area.
> > 
> > What do you do if the partition itself is misaligned? Do you align the start block
> > address to the start of the partition or the start of the device?
> 
> Yes, we got the start of the partition by ioctl.

Ok, good. Is it possible to override this manually? I have seen (very few) devices in the
past on which the first erase block is smaller than the others and the others are all
unaligned as a consequence. It's probably not worth supporting if this is a lot of work,
but if you think it's easy enough to add a command line option, it may come in handy.

FWIW, I have also seen devices that have a slightly different erase block size, namely
4128 (rather than 4096) KB, but I don't see any way to reasonably support that (or even
detect it programatically) at all.

> > There is one small difference to my design: instead of having the checkpoint area
> > in the front, the idea was to only record a pointer to the currently used segments
> > in the global metadata and treat the segment that carries the inodes as a journal.
> > The main advantage of that is that you only have to write a single block to
> > atomically update an inode, possibly including embedded data, while you always
> > have to write the inode first, and then make an update to the CP area to make
> > it visible.
> 
> As I understand, I think your design is not different from f2fs.
> The checkpoint in f2fs is used for the start of power-off-recovery,
> which contains current active segment numbers for six logs.
> And each direct node block including inode blocks contains the next log
> pointer (i.e., block address) in order to support roll-forward.
> I think this feature is also a kind of journaling inodes described by
> you, which means that f2fs does not need to update the CP area whenever
> inode is written or even if fsync is called.

Ok, I see.

> > - synchronous updates of indirect files require four writes (data, indirect
> >   block, inode, NAT) rather than just two as in my approach (data,
> >   inode journal).
> 
> I don't know exactly your approach, but, does it need to write inode_map
> finally?

Yes, the inode map is written every time one section is filled with
inodes.

> Normally in the case of fsync calls, f2fs writes data and direct node
> block only, since the data can be recovered by roll-forward.
> Instead, flusher will write the indirect node blocks afterwards.

Ok, good. So it's actually much more similar than I thought.

> > - f2fs has no embedded data in very small files, though this should be easy
> >   to add.
> 
> Yes, vyacheslav pointed out before.
> At this moment, I'd like to remain this feature for future.
> Instead, I totally would like to focus on validation and stabilization
> on many unexpected platforms.

Fair enough. This can be added as a backwards compatible (not forward
compatible) extension later. Maybe it's good to formalize the layout
for those files already though and reserve a flag in the inode for it.

> > > +LFS has two schemes for free space management: threaded log and copy-and-compac-
> > > +tion. The copy-and-compaction scheme, aka cleaning, is well-suited for devices
> > > +showing very good sequential write performance, since free segments are served
> > > +all the time for writing new data. However, it suffers from cleaning overhead
> > > +under high utilization. Contrarily, the threaded log scheme suffers from random
> > > +writes, but no cleaning process is needed. F2FS adopts a hybrid scheme where the
> > > +copy-and-compaction scheme is adopted by default, but the policy is dynamically
> > > +changed to the threaded log scheme according to the file system status.
> > 
> > Compared to my design, this uses the exact same two methods, but applies them
> > in different scenarios: I would always use the copy-and-compaction method
> > for small and medium sized files (up to a few megabytes) but use in-place
> > overwriting in large files, similar to (but not the same as) your threaded
> > log.
> > 
> > Using the threaded log sounds like a good idea to use when there is little
> > free space. I had briefly considered that but thought it would be too
> > hard to fit in with my design.
> > 
> > What do you think about adding support for in-place updates on large files
> > as I described? I believe this would be a win in most cases, although
> > it is clearly workload dependent.
> 
> I also considered writing data in place, and sometimes it can be a good
> choice instead of reusing obsolete space.
> So, I implemented this in f2fs, but I disabled in the current design,
> since I suspect that there is a recovery problem.
> Due to the roll-back model, I'm not sure we can overwrite data before
> checkpoint.
> How do you think?

In-place updates in general can be hard for two reaons I see:

* writes that are smaller than the page size might not be done
atomically on low-quality media, and more generally writing to one
file might during power-fail might cause contents of another file to
get lost (write-disturb).

* ordering between data and metadata updates is harder.

I think in the specific case that my design has where in-place
updates are only done in segment-indirect files, neither of these
is a serious problem. The write-disturb case here will only ever
have the chance to destroy contents of the same file, and only
for hardware that doesn't handle this already. This is still
better than any other file system we have can do. Further, you never
really have to update metadata for an in-place update in these
cases, since you do not need to maintain per-segment summaries.

> > Do you take the type of data into account in the cleaner? In particular, do you
> > try to group blocks together in a segment based on any of:
> > 
> > * file modification age,
> > * access patterns seen on the file (random vs linear writes),
> > * multiple degrees of cold/hot files
> > * file name (e.g. extension),
> > * file size,
> > * directory/data/inode/block-pointer blocks
> > * ...
> > 
> > I spent a lot of time thinking about possible optimizations based on these but have
> > not actually done any simulations on what would be a good strategy. I'm curious
> > to learn if you considered the above.
> 
> In f2fs, a background cleaner loads victim valid blocks and marks them
> as dirty in the page cache. Then, flusher will write them with user
> data to the proper log areas determined by their types.
> An on-demand cleaner loads and moves the victim blocks right away to the
> logs also determined by their types.
> In the background cleaner, a victim section is selected by a
> cost-benefit function which takes into account section ages.
> 
> In summary, f2fs uses the following information to try group blocks
> in order to reduce the cleaning overhead.
> 
> * segment age,
> * file name (extension),
> * directory/data/inode/block-pointer blocks
> 
> Maybe there are another optimization items.
> But as you know, if we try to optimize somthing, we have to add or
> maintain additional information, resulting in an overhead.
> We'd better take more discussions on this issue.

Loading blocks to immediately mark them dirty is a nice simplification
of the algorithm that avoids adding long latencies for the gargabe
collection phase as it gets intermixed with regular writes.
I intentionally did the opposite though: the algorithm for the prototype
as implemented by Volker Schneider is:

* when one segment is filled with data (nodes or user data), determine
  whether garbage collection should be done or not.
* if we should do garbage collection, decide on one type of data (by
  some form of categorization), and copy data from one old segment
  into a new segment
* until the new segment is full, keep adding more data of the same kind
  from other segments that should be garbage collected.

This incurs a noticeable write latency every time we go into GC, basically
the time to read and write an entire segment, but it also reduces
fragmentation by grouping similar data together more than your approach,
and it means that we never mix new data with old data from GC into the
same segments. It also lets us record the segment age more accurately
for the new segment in GC, because the age of the data is still what
it was, unlike data that gets freshly written.

	Arnd
