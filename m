Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab2JMSgD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 14:36:03 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:52755 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422Ab2JMSgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 14:36:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: =?utf-8?q?=EA=B9=80=EC=9E=AC=EA=B7=B9?= <jaegeuk.kim@samsung.com>
Subject: Re: [PATCH 01/16] f2fs: add document
Date: Sat, 13 Oct 2012 18:35:53 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: viro@zeniv.linux.org.uk, "'Theodore Ts'o'" <tytso@mit.edu>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
References: <000801cda2f0$672214f0$35663ed0$%kim@samsung.com>
In-Reply-To: <000801cda2f0$672214f0$35663ed0$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201210131835.53600.arnd@arndb.de>
X-Provags-ID: V02:K0:NiO8wRTDuviioYqmO+ts626tiyeDG365tCb+WmYTecD
 NMhDDTIdk4NhpnTVTP+6fcY8TAKOB1B5ZisZgJpAHKhsp9jY3d
 Et4aYTSD81DOLjjXsFs6HFZP/uiIm9i1R7Hxnyav86CKhlhGNk
 +xx1zo2RtnWuE/8qorZXoUqL2Xp9xFYVHQlEmDnim/Fi7Yalwx
 RFtIyomPH5stl5yAhdq5BV4lz3iDvWzNXkcOv0YGQcIxAIgITh
 6qVpR9/yJHAZiINNj7GL5wvReYDhAVsxf3X/KR+XkU3mhqYWPQ
 tXEbgxB043yZP8/H2IZGZEevaKTiqrJSA1wxNr725QttehhTIl
 j0oGtyqJgluGF3KU8+vs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 October 2012 20:56:06 김재극 wrote:
> This adds a document describing the mount options, proc entries, usage, and
> design of Flash-Friendly File System, namely F2FS.

Nice document!

This is a lot like the design I came up with for an experimental file system
last year, so I'll try to go through and talk about the differences to
what I had. I believe there are a few points where you are missing
optimizations that I had and that could be added.

> +================================================================================
> +PROC ENTRIES
> +================================================================================
> +
> +/proc/fs/f2fs/ contains information about partitions mounted as f2fs. For each
> +partition, a corresponding directory, named as its device name, is provided with
> +the following proc entries.
> +
> +- f2fs_stat  major file system information managed by f2fs currently
> +- f2fs_sit_stat      average SIT information about whole segments
> +- f2fs_mem_stat      current memory footprint consumed by f2fs
> +
> +e.g., in /proc/fs/f2fs/sdb1/

Unrelated to the file system design, these should not be part of procfs at
all. You can probably convert them to debugfs files easily though and perhaps
even simplify the implementation in the process (I haven't looked at how it's
done at the moment).

> +================================================================================
> +DESIGN
> +================================================================================
> +
> +On-disk Layout
> +--------------
> +
> +F2FS divides whole volume into a number of segments each of which size is 2MB by
> +default. A section is composed of consecutive segments, and a zone consists of a
> +set of sections.

A segment size of 2MB should work fine for most eMMC, but there are a lot of
devices using TLC (three bit per cell MLC) flash with 1.5/3/6/12 MB erase blocks,
in particular cheap SD cards. Your design fundamentally won't work on those if you
only allow power-of-two multiples of 2 MB.

Would it be possible to change the segment size to 1.5 MB as a mkfs option?
I realize that the space utilization would be slightly worse in that case,
but if we allow power-of-two multiples of either 1.5 or 2 MB, that should cover
almost all media on the market today, and most likely for the forseeable
future.

> +F2FS maintains logically six log areas. Except SB, all the log areas are managed
> +in a unit of multiple segments. SB is located at the beggining of the partition,
> +and there exist two superblocks to avoid file system crash. Other file system
> +metadata such as CP, NAT, SIT, and SSA are located in front part of the volume.
> +Main area contains file and directory data including their indices.

This is almost identical to what I had come up with.

The main difference is the number of log areas. Given that you need seven erase
blocks (six log areas, plus a random access area), quite a number of devices
are excluded from working ideally. Making use of six log areas is definitely
a win if you manage to split the data well between hot/warm/cold blocks, but
on devices that can only handle 5, this is also clearly a loss.

I understand that all Samsung eMMC handles this well, and so would the Samsung
Class 10 'Plus' SDHC cards. The Samsung Class 4 'Essential' cards can only do
2 blocks of 6 MB plus the FAT area that you need for random access, so that
won't work well with your current design.

Excluding some of your main competitor's eMMC seems more problematic. My view
is that if we include the file system, it should fundamentally work across
all devices in the industry. It's definitely ok to use 6 log areas by default
to optimize for sane devices like yours, but please consider offering at
least using just 4 log areas as an mkfs option in order to include all other
eMMC and the main SD card brands (many Sandisk, Lexar, and a bunch of the 
noname ones). I don't think it's worth including the Toshiba/Phison/Kingston
SD card controllers though, as they are basically broken for use with a
proper file system anyway and attempting to support a single log area (plus
random area in the front) would require tradeoffs that sacrifice performance
on proper devices.

> +Each area manages the following contents.
> +- CP         File system information, bitmaps for valid NAT/SIT sets, orphan
> +             inode lists, and summary entries of current active segments.
> +- NAT                Block address table for all the node blocks stored in Main area.
> +- SIT                Segment information such as valid block count and bitmap for the
> +             validity of all the blocks.
> +- SSA                Summary entries which contains the owner information of all the
> +             data and node blocks stored in Main area.
> +- Main               Node and data blocks.
> +
> +In order to avoid misalignment between file system and flash-based storage, F2FS
> +aligns the start block address of CP with the segment size. Also, it aligns the
> +start block address of Main area with the zone size by reserving some segments
> +in SSA area.

What do you do if the partition itself is misaligned? Do you align the start block
address to the start of the partition or the start of the device?

> +File System Metadata Structure
> +------------------------------
> +
> +F2FS adopts the checkpointing scheme to maintain file system consistency. At the
> +mount time, F2FS first tries to find the last valid checkpoint data by scanning
> +CP area. In order to reduce the scanning time, F2FS uses only two copies of CP.
> +One of them always indicates the last valid data, which is called as shadow copy
> +mechanism. In addition to CP, NAT and SIT also adopts the shadow copy mechanism.
> +
> +For file system consistency, each CP points which NAT and SIT copies are valid,
> +as shown as below.
> +
> +  +--------+----------+---------+
> +  |   CP   |    NAT   |   SIT   |
> +  +--------+----------+---------+
> +  .         .          .          .
> +  .            .              .              .
> +  .               .                 .                 .
> +  +-------+-------+--------+--------+--------+--------+
> +  | CP #0 | CP #1 | NAT #0 | NAT #1 | SIT #0 | SIT #1 |
> +  +-------+-------+--------+--------+--------+--------+
> +     |             ^                          ^
> +     |             |                          |
> +     `----------------------------------------'

There is one small difference to my design: instead of having the checkpoint area
in the front, the idea was to only record a pointer to the currently used segments
in the global metadata and treat the segment that carries the inodes as a journal.
The main advantage of that is that you only have to write a single block to
atomically update an inode, possibly including embedded data, while you always
have to write the inode first, and then make an update to the CP area to make
it visible.

> +Index Structure
> +---------------
> +
> +The key data structure to manage the data locations is a "node". As similar as
> +traditional file structures, F2FS has three types of node: inode, direct node,
> +indirect node. F2FS assigns 4KB to an inode block where contains 929 data block
> +indices, two direct node pointers, two indirect node pointers, and one double
> +indirect node pointer as described below. One direct node block contains 1018
> +data blocks, and one indirect node block contains also 1018 node blocks. Thus,
> +One inode block (i.e., a file) covers:
> +  4KB * (929 + 2 * 1018 + 2 * 1018 * 1018 + 1018 * 1018 * 1018) := 3.94TB.
> +
> +   Inode block (4KB)
> +     |- data (929)
> +     |- direct node (2)
> +     |          `- data (1018)
> +     |- indirect node (2)
> +     |            `- direct node (1018)
> +     |                       `- data (1018)
> +     `- triple indirect node (1)
> +                         `- indirect node (1018)
> +                                   `- direct node (1018)
> +                                              `- data (1018)

You use two different naming schemes here: you call the last-level indirect
block the "double indirect" node pointer in the text, but the "triple
indirect" node pointer in the illustration.

> +Note that, all the node blocks are mapped by NAT, which means the location of
> +each node is translated by the NAT table. In the consideration of the wandering
> +tree problem, F2FS is able to cut off the propagation of node updates caused by
> +leaf data writes.

Ah, that is very clever!

My solution to the same problem was to have a gigantic fan-out in the inode
in order to only ever need one level of indirection:

* I make the cluster that is addressed by a pointer larger than 4k by
  aligning it to e.g. the flash page size, typically 16KB to 64KB.
* in a 64KB inode, you can fit some 16000 pointers
* each pointer then points to a cluster of that size, so you get up to
  64KB * 16000 = 1GB file size with this method on 64 KB clusters, or
  16KB * 4000 = 64 MB file size on 16 KB clusters, or just under 4 MB
  file size on 4 KB clusters.
* To allow larger files, a flag in the inode signifies that the pointers
  address entire segments instead of clusters, which allows files up
  to the partition size even with 4 KB clusters on most media (erase block
  size is usually coupled to drive size)

To compare the two approaches:

+ f2fs does not need a clever algorithm to determine when to pick a
  segment indirect layout over a cluster indirect, and does not need
  to copy data when a file grows over the cut-off
+ f2fs does not waste an average of half a segment for large files.
- large files are less efficient to read because they are not in
  contiguous segment chunks
- synchronous updates of indirect files require four writes (data, indirect
  block, inode, NAT) rather than just two as in my approach (data,
  inode journal).
- f2fs has no embedded data in very small files, though this should be easy
  to add.
+/- random writes in database files get turned into log-structured writes,
  which is often more efficient to write, but also means more fragmentation
  and the user application cannot optimize the accesses for the underlying
  storage as a lot of databases do.

> +Default Block Allocation
> +------------------------
> +
> +In runtime, F2FS manages six active logs inside "Main" area: Hot/Warm/Cold node
> +and Hot/Warm/Cold data.
> +
> +- Hot node   contains direct node blocks of directories.
> +- Warm node  contains direct node blocks except hot node blocks.
> +- Cold node  contains indirect node blocks
> +- Hot data   contains dentry blocks
> +- Warm data  contains data blocks except hot and cold data blocks
> +- Cold data  contains multimedia data or migrated data blocks

This categorization looks like you could easily reduce the number of active
logs if the hardware cannot handle all six, e.g.:

1 hardware segment: not easily possible, I suppose
2 segments: node + data
3 segments: node + hot data + warm/cold data
4 segments: hot node + warm/cold node + hot data + warm/cold data
5 segments: hot node + warm/cold node + hot data + warm data + cold data

> +LFS has two schemes for free space management: threaded log and copy-and-compac-
> +tion. The copy-and-compaction scheme, aka cleaning, is well-suited for devices
> +showing very good sequential write performance, since free segments are served
> +all the time for writing new data. However, it suffers from cleaning overhead
> +under high utilization. Contrarily, the threaded log scheme suffers from random
> +writes, but no cleaning process is needed. F2FS adopts a hybrid scheme where the
> +copy-and-compaction scheme is adopted by default, but the policy is dynamically
> +changed to the threaded log scheme according to the file system status.

Compared to my design, this uses the exact same two methods, but applies them
in different scenarios: I would always use the copy-and-compaction method
for small and medium sized files (up to a few megabytes) but use in-place
overwriting in large files, similar to (but not the same as) your threaded
log.

Using the threaded log sounds like a good idea to use when there is little
free space. I had briefly considered that but thought it would be too
hard to fit in with my design.

What do you think about adding support for in-place updates on large files
as I described? I believe this would be a win in most cases, although
it is clearly workload dependent.

> +In order to align F2FS with underlying flash-based storages, F2FS allocates a
> +segment in a unit of section. F2FS expects that the section size would be the
> +same as the unit size of garbage collection in FTL. Furthermore, with respect
> +to the mapping granularity in FTL, F2FS allocates each sections of the active
> +logs from different zones as much as possible, since FTL can write the data in
> +the active logs into one allocation unit according to its mapping granularity.

I did not know about the benefit of using different zones, but it makes a lot
of sense now that you mention it.

> +Cleaning process
> +----------------
> +
> +F2FS does cleaning both on demand and in the background. On-demand cleaning is
> +triggered when there are not enough free segments to serve VFS calls. Background
> +cleaner is operated by a kernel thread, and triggers the cleaning job when the
> +system is idle.
> +
> +F2FS supports two victim selection policies: greedy and cost-benefit algorithms.
> +In greedy algorithm, F2FS selects a victim segment having the smallest number of
> +valid blocks. In cost-benefit algorithm, F2FS selects a victim segment according
> +to the segment age and the number of valid blocks in order to address log block
> +thrashing problem in greedy algorithm. F2FS adopts greedy algorithm for on-demand
> +cleaner, while background cleaner adopts cost-benefit algorithm.
> +
> +In order to identify what the data in the victim segment are valid or not, F2FS
> +manages a bitmap. Each bit represents the validity of a block, and the bitmap is
> +composed of a bit stream covering whole blocks in main area.

Do you take the type of data into account in the cleaner? In particular, do you
try to group blocks together in a segment based on any of:

* file modification age,
* access patterns seen on the file (random vs linear writes),
* multiple degrees of cold/hot files
* file name (e.g. extension),
* file size,
* directory/data/inode/block-pointer blocks
* ...

I spent a lot of time thinking about possible optimizations based on these but have
not actually done any simulations on what would be a good strategy. I'm curious
to learn if you considered the above.

	Arnd
