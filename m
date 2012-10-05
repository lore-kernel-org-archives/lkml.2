Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227Ab2JET4q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 15:56:46 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:34130 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757180Ab2JET4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 15:56:45 -0400
Message-ID: <506F3B67.5010201@xenotime.net>
Date: Fri, 05 Oct 2012 12:56:23 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: =?UTF-8?B?6rmA7J6s6re5?= <jaegeuk.kim@samsung.com>
CC: viro@zeniv.linux.org.uk, "'Theodore Ts'o'" <tytso@mit.edu>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Subject: Re: [PATCH 01/16] f2fs: add document
References: <000801cda2f0$672214f0$35663ed0$%kim@samsung.com>
In-Reply-To: <000801cda2f0$672214f0$35663ed0$%kim@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2012 04:56 AM, 김재극 wrote:

> This adds a document describing the mount options, proc entries, usage, and
> design of Flash-Friendly File System, namely F2FS.
> 
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> ---
>  Documentation/filesystems/00-INDEX |    2 +
>  Documentation/filesystems/f2fs.txt |  314 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 316 insertions(+)
>  create mode 100644 Documentation/filesystems/f2fs.txt
> 
> diff --git a/Documentation/filesystems/00-INDEX b/Documentation/filesystems/00-INDEX
> index 8c624a1..ce5fd46 100644
> --- a/Documentation/filesystems/00-INDEX
> +++ b/Documentation/filesystems/00-INDEX
> @@ -48,6 +48,8 @@ ext4.txt
>  	- info, mount options and specifications for the Ext4 filesystem.
>  files.txt
>  	- info on file management in the Linux kernel.
> +f2fs.txt
> +	- info and mount options for the F2FS filesystem.
>  fuse.txt
>  	- info on the Filesystem in User SpacE including mount options.
>  gfs2.txt
> diff --git a/Documentation/filesystems/f2fs.txt b/Documentation/filesystems/f2fs.txt
> new file mode 100644
> index 0000000..cd3f846
> --- /dev/null
> +++ b/Documentation/filesystems/f2fs.txt
> @@ -0,0 +1,314 @@
> +================================================================================
> +WHAT IS Flash-Friendly File System (F2FS)?
> +================================================================================
> +
> +NAND flash memory-based storage devices, such as SSD, eMMC, and SD cards, have
> +been widely being used for ranging from mobile to server systems. Since they are




   been widely used for devices ranging from
or
   been widely used for storage ranging from

> +known to have different characteristics from the conventional rotational disks,
> +a file system, an upper layer to the storage device, should adapt to the changes
> +from the sketch.




   from the start.
?

> +
> +F2FS is a file system exploiting NAND flash memory-based storage devices, which
> +is based on Log-structured File System (LFS). The design has been focused on
> +addressing the fundamental issues in LFS, which are snowball effect of wandering
> +tree and high cleaning overhead.
> +
> +Since a NAND flash memory-based storage device shows different characteristic
> +according to its internal geometry or flash memory management scheme aka FTL,
> +F2FS and its tools support various parameters not only for configuring on-disk
> +layout, but also for selecting allocation and cleaning algorithms.
> +
> +The file system formatting tool, "mkfs.f2fs", is available from the following
> +download page:		http://sourceforge.net/projects/f2fs-tools/
> +
> +================================================================================
> +MOUNT OPTIONS
> +================================================================================
> +
> +background_gc_off      Turn off the cleaning operation, aka garbage collection,




Some people won't know what "aka" means, so how about:

			  Turn off the cleaning operation [garbage collection]

> +		       in background triggered when I/O subsystem is idle.
> +disable_roll_forward   Disable the roll-forward recovery routine during SPOR.




what is SPOR?

> +discard                Issue discard/TRIM commands when a segment is cleaned.
> +no_heap                Disable heap-style segment allocation in which finds free




			                              drop:     in

> +                       segments for data from the beginning of main area, while
> +		       for node from the end of main area.
> +nouser_xattr           Disable Extened User Attributes. Note: xattr is enabled




			          Extended

> +                       by default if CONFIG_F2FS_FS_XATTR is selected.
> +noacl                  Disable POSIX Access Control List. Note: acl is enabled
> +                       by default if CONFIG_F2FS_FS_POSIX_ACL is selected.
> +
> +================================================================================
> +PROC ENTRIES
> +================================================================================
> +
> +/proc/fs/f2fs/ contains information about partitions mounted as f2fs. For each
> +partition, a corresponding directory, named as its device name, is provided with
> +the following proc entries.
> +
> +- f2fs_stat	major file system information managed by f2fs currently
> +- f2fs_sit_stat	average SIT information about whole segments




what is SIT?

> +- f2fs_mem_stat	current memory footprint consumed by f2fs
> +
> +e.g., in /proc/fs/f2fs/sdb1/
> +
> +================================================================================
> +USAGE
> +================================================================================
> +
> +1. Download userland tools
> +
> +2. Insmod f2fs.ko module:
> + # insmod f2fs.ko
> +
> +3. Check the directory trying to mount
> + # mkdir /mnt/f2fs
> +
> +4. Format the block device, and then mount as f2fs
> + # mkfs.f2fs -l label /dev/block_device
> + # mount -t f2fs /dev/block_device /mnt/f2fs
> +
> +================================================================================
> +DESIGN
> +================================================================================
> +
> +On-disk Layout
> +--------------
> +
> +F2FS divides whole volume into a number of segments each of which size is 2MB by




        divides the whole volume into a number of segments, each of which is
   2MB in size by default.

> +default. A section is composed of consecutive segments, and a zone consists of a
> +set of sections.
> +
> +F2FS maintains logically six log areas. Except SB, all the log areas are managed
> +in a unit of multiple segments. SB is located at the beggining of the partition,




                                                        beginning

> +and there exist two superblocks to avoid file system crash. Other file system
> +metadata such as CP, NAT, SIT, and SSA are located in front part of the volume.




                                                      in the front part

> +Main area contains file and directory data including their indices.
> +
> +Each area manages the following contents.
> +- CP		File system information, bitmaps for valid NAT/SIT sets, orphan
> +		inode lists, and summary entries of current active segments.
> +- NAT		Block address table for all the node blocks stored in Main area.
> +- SIT		Segment information such as valid block count and bitmap for the
> +		validity of all the blocks.
> +- SSA		Summary entries which contains the owner information of all the
> +		data and node blocks stored in Main area.
> +- Main		Node and data blocks.
> +
> +In order to avoid misalignment between file system and flash-based storage, F2FS
> +aligns the start block address of CP with the segment size. Also, it aligns the
> +start block address of Main area with the zone size by reserving some segments
> +in SSA area.
> +
> +                                            align with the zone size <-|
> +                 |-> align with the segment size
> +     _________________________________________________________________________
> +    |            |            |    Node     |   Segment   |   Segment  |      |
> +    | Superblock | Checkpoint |   Address   |    Info.    |   Summary  | Main |
> +    |    (SB)    |   (CP)     | Table (NAT) | Table (SIT) | Area (SSA) |      |
> +    |____________|_____2______|______N______|______N______|______N_____|__N___|
> +                                                                       .      .
> +                                                             .                .
> +                                                 .                            .
> +                                    ._________________________________________.
> +                                    |_Segment_|_..._|_Segment_|_..._|_Segment_|
> +                                    .           .
> +                                    ._________._________
> +                                    |_section_|__...__|_
> +                                    .            .
> +		                    .________.
> +	                            |__zone__|
> +
> +
> +File System Metadata Structure
> +------------------------------
> +
> +F2FS adopts the checkpointing scheme to maintain file system consistency. At the




                                                                        drop:  the

> +mount time, F2FS first tries to find the last valid checkpoint data by scanning
> +CP area. In order to reduce the scanning time, F2FS uses only two copies of CP.
> +One of them always indicates the last valid data, which is called as shadow copy

> +mechanism. In addition to CP, NAT and SIT also adopts the shadow copy mechanism.




                                                  adopt

> +
> +For file system consistency, each CP points which NAT and SIT copies are valid,




                                        points to which

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
> +
> +Index Structure
> +---------------
> +
> +The key data structure to manage the data locations is a "node". As similar as




                                                                    Similar to

> +traditional file structures, F2FS has three types of node: inode, direct node,
> +indirect node. F2FS assigns 4KB to an inode block where contains 929 data block




                                                     which

> +indices, two direct node pointers, two indirect node pointers, and one double
> +indirect node pointer as described below. One direct node block contains 1018
> +data blocks, and one indirect node block contains also 1018 node blocks. Thus,
> +One inode block (i.e., a file) covers:




   one

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
> +			              `- direct node (1018)
> +	                                         `- data (1018)
> +
> +Note that, all the node blocks are mapped by NAT, which means the location of




   drop:    ,

> +each node is translated by the NAT table. In the consideration of the wandering
> +tree problem, F2FS is able to cut off the propagation of node updates caused by
> +leaf data writes.
> +
> +Directory Structure
> +-------------------
> +
> +A directory entry occupies 11 bytes, which consists of the following attributes.
> +
> +- hash		hash value of the file name
> +- ino		inode number
> +- len		the length of file name
> +- type		file type such as directory, symlink, etc
> +
> +A dentry block consists of 214 dentry slots and file names. There-in bitmap is




                                             maybe:            Therein a bitmap is

> +used to represent whether each dentry is valid or not. A dentry block occupies
> +4KB with the following composition.
> +
> +  Dentry Block(4 K) = bitmap (27 bytes) + reserved (3 bytes) +
> +	              dentries(11 * 214 bytes) + file name (8 * 214 bytes)
> +
> +                         [Bucket]
> +             +--------------------------------+
> +             |dentry block 1 | dentry block 2 |
> +             +--------------------------------+
> +             .               .
> +       .                             .
> +  .       [Dentry Block Structure: 4KB]       .
> +  +--------+----------+----------+------------+
> +  | bitmap | reserved | dentries | file names |
> +  +--------+----------+----------+------------+
> +  [Dentry Block: 4KB] .   .
> +		 .               .
> +            .                          .
> +            +------+------+-----+------+
> +            | hash | ino  | len | type |
> +            +------+------+-----+------+
> +            [Dentry Structure: 11 bytes]
> +
> +F2FS implements multi-level hash tables for directory structure. Each level has
> +a hash table with dedicated number of hash buckets as shown below. Note that,




                                                                    drop:      ,

> +"A(2B)" means a bucket includes 2 data blocks.
> +
> +----------------------
> +A : bucket
> +B : block
> +N : MAX_DIR_HASH_DEPTH
> +----------------------
> +
> +level #0   | A(2B)
> +           |
> +level #1   | A(2B) - A(2B)
> +           |
> +level #2   | A(2B) - A(2B) - A(2B) - A(2B)
> +     .     |   .       .       .       .
> +level #N/2 | A(2B) - A(2B) - A(2B) - A(2B) - A(2B) - ... - A(2B)
> +     .     |   .       .       .       .
> +level #N   | A(4B) - A(4B) - A(4B) - A(4B) - A(4B) - ... - A(4B)
> +
> +The number of blocks and buckets are determined by,
> +
> +                            ,- 2, if n < MAX_DIR_HASH_DEPTH / 2,
> +  # of blocks in level #n = |
> +                            `- 4, Otherwise
> +
> +                             ,- 2^n, if n < MAX_DIR_HASH_DEPTH / 2,
> +  # of buckets in level #n = |
> +                             `- 2^((MAX_DIR_HASH_DEPTH / 2) - 1), Otherwise
> +

> +When F2FS finds a file name in a directory, at first a hash value of the file

> +name is calculated. Then, F2FS scans the hash table in level #0 to find the
> +dentry consisting of the file name and its inode number. If not found, F2FS
> +scans the next hash table in level #1. In this way, F2FS scans hash tables in
> +each levels incrementally from 1 to N. In each levels, F2FS needs to scan only


        level                                     level,

> +one bucket determined by the follow equation, which shows O(log(# of files))


                                following

> +complexity.
> +
> +  bucket number to scan in level #n = (hash value) % (# of buckets in level #n)
> +
> +In the case of file creation, F2FS finds an empty consecutive slots that covers


                                    drop:   an                         that cover

> +the file name. F2FS searches the empty slots in the hash tables of whole levels
> +from 1 to N in the same way as the lookup operation.
> +
> +The following figure shows an example of two cases holding children.
> +       --------------> Dir <--------------
> +       |                                 |
> +    child                             child
> +
> +    child - child                     [hole] - child
> +
> +    child - child - child             [hole] - [hole] - child
> +
> +   Case 1:                           Case 2:
> +   Number of children = 6,           Number of children = 3,
> +   File size = 7                     File size = 7
> +
> +Default Block Allocation
> +------------------------
> +
> +In runtime, F2FS manages six active logs inside "Main" area: Hot/Warm/Cold node


   At runtime,

> +and Hot/Warm/Cold data.
> +
> +- Hot node	contains direct node blocks of directories.
> +- Warm node	contains direct node blocks except hot node blocks.
> +- Cold node	contains indirect node blocks
> +- Hot data	contains dentry blocks
> +- Warm data	contains data blocks except hot and cold data blocks
> +- Cold data	contains multimedia data or migrated data blocks
> +
> +LFS has two schemes for free space management: threaded log and copy-and-compac-
> +tion. The copy-and-compaction scheme, aka cleaning, is well-suited for devices


"aka" usage is not nice IMO.

> +showing very good sequential write performance, since free segments are served
> +all the time for writing new data. However, it suffers from cleaning overhead
> +under high utilization. Contrarily, the threaded log scheme suffers from random
> +writes, but no cleaning process is needed. F2FS adopts a hybrid scheme where the
> +copy-and-compaction scheme is adopted by default, but the policy is dynamically
> +changed to the threaded log scheme according to the file system status.
> +
> +In order to align F2FS with underlying flash-based storages, F2FS allocates a


                                                      storage,

> +segment in a unit of section. F2FS expects that the section size would be the
> +same as the unit size of garbage collection in FTL. Furthermore, with respect
> +to the mapping granularity in FTL, F2FS allocates each sections of the active


                                                          section

> +logs from different zones as much as possible, since FTL can write the data in
> +the active logs into one allocation unit according to its mapping granularity.
> +
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


   In the greedy

> +valid blocks. In cost-benefit algorithm, F2FS selects a victim segment according


                 In the cost-benefit

> +to the segment age and the number of valid blocks in order to address log block
> +thrashing problem in greedy algorithm. F2FS adopts greedy algorithm for on-demand


                     in the greedy             adopts the greedy


> +cleaner, while background cleaner adopts cost-benefit algorithm.


                                     adopts the

> +
> +In order to identify what the data in the victim segment are valid or not, F2FS


                        if the data
or
                        whether the data

> +manages a bitmap. Each bit represents the validity of a block, and the bitmap is
> +composed of a bit stream covering whole blocks in main area.





-- 
~Randy
