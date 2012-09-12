Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337Ab2ILObc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 10:31:32 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44473 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759109Ab2ILOb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:31:28 -0400
MIME-Version: 1.0
In-Reply-To: <1347373645-2119-1-git-send-email-zwu.kernel@gmail.com>
References: <1347373645-2119-1-git-send-email-zwu.kernel@gmail.com>
Date: Wed, 12 Sep 2012 22:31:27 +0800
Message-ID: <CAEH94LgarUjzAY7iKeuztaQ3ZpPS-=v0wqBHZ=vqS4QvMg93Tg@mail.gmail.com>
Subject: Re: [RFC 00/11] VFS: hot data tracking
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dave@linux.vnet.ibm.com,
        viro@zeniv.linux.org.uk, hch@lst.de, chris.mason@fusionio.com,
        cmm@us.ibm.com, linuxram@us.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
        tytso@mit.edu, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, forgot CCed to Ted.

On Tue, Sep 11, 2012 at 10:27 PM,  <zwu.kernel@gmail.com> wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>
> HI, folks
>   I have pushed the patchset to my kernel dev git tree:
> git@github.com:wuzhy/kernel.git
>
>   Also, you can review it via
> https://github.com/wuzhy/kernel/commits/hottrack
>
> NOTE:
>
> The patchset still has a lot of bugfix and cleanup to do. It is post
> out mainly to make sure it is going in the correct direction and
> hope to get some helpful comments from other guys.
>
> TODO List:
>
>  1.) Need to do scalability or performance tests.
>  2.) Fix up bugs.
>  3.) Strictly split this patchset to keep them in order
>         This patchset is in RFC state, i haven't strictly split it
>      When it is in PATCH state, i will strictly split it and let
>      them in order.
>  4.) Turn some Micro in to tunables
>         TIME_TO_KICK, and HEAT_UPDATE_DELAY
>  5.) Rafactor hot_hash_is_aging()
>         If you just made the timeout value a timespec and compared
>      the _timespecs_, you would be doing a lot fewer conversions.
>  6.) Cleanup some unnecessary lock protect
>  7.) Add more comments to explain how to calc temperature
>
> Ben Chociej, Matt Lupfer and Conor Scott originally wrote this code to
>  be very btrfs-specific.  I've taken their code and attempted to
> make it more generic and integrate it at the VFS level.
>
> INTRODUCTION:
>
> Essentially, this means maintaining some key stats
> (like number of reads/writes, last read/write time, frequency of
> reads/writes), then distilling those numbers down to a single
> "temperature" value that reflects what data is "hot," and using that
> temperature to move data to SSDs.
>
> The long-term goal of these patches is to allow some FSs,
> e.g. Btrfs to intelligently utilize SSDs in a heterogenous volume.
> Incidentally, this project has been motivated by
> the Project Ideas page on the Btrfs wiki.
>
> Of course, users are warned not to run this code outside of development
> environments. These patches are EXPERIMENTAL, and as such they might eat
> your data and/or memory. That said, the code should be relatively safe
> when the hottrack mount option are disabled.
>
> MOTIVATION:
>
> The overall goal of enabling hot data relocation to SSD has been
> motivated by the Project Ideas page on the Btrfs wiki at
> <https://btrfs.wiki.kernel.org/index.php/Project_ideas>.
> It will divide into two steps. VFS provide hot data tracking function
> while specific FS will provide hot data relocation function.
> So as the first step of this goal, it is hoped that the patchset
> for hot data tracking will eventually mature into VFS.
>
> This is essentially the traditional cache argument: SSD is fast and
> expensive; HDD is cheap but slow. ZFS, for example, can already take
> advantage of SSD caching. Btrfs should also be able to take advantage of
> hybrid storage without many broad, sweeping changes to existing code.
>
> SUMMARY:
>
> - Hooks in existing vfs functions to track data access frequency
>
> - New rbtrees for tracking access frequency of inodes and sub-file
> ranges (hot_rb.c)
>     The relationship between super_block and rbtree is as below:
>   super_block->s_hotinfo.hot_inode_tree
>     In include/linux/fs.h, one struct hot_info s_hotinfo is added to
>   super_block struct. Each FS instance can find hot tracking info
>   s_hotinfo via its super_block. In this hot_info, it store a lot of hot
>   tracking info such as hot_inode_tree, inode and range hash list, etc.
>
> - A hash list for indexing data by its temperature (hot_hash.c)
>
> - A debugfs interface for dumping data from the rbtrees (hot_debugfs.c)
>
> - A background kthread for updating inode heat info
>
> - Mount options for enabling temperature tracking(-o hottrack, default mean disabled)
>   (hot_track.c)
>
> - An ioctl to retrieve the frequency information collected for a certain
> file
>
> - Ioctls to enable/disable frequency tracking per inode.
>
> Usage syntax:
>
> root@debian-i386:~# mount -o hottrack /dev/sdb /mnt
> [ 1505.894078] device label test devid 1 transid 29 /dev/sdb
> [ 1505.952977] btrfs: disk space caching is enabled
> [ 1506.069678] vfs: turning on hot data tracking
> root@debian-i386:~# mount -t debugfs none /sys/kernel/debug
> root@debian-i386:~# ls -l /sys/kernel/debug/vfs_hotdata/
> total 0
> drwxr-xr-x 2 root root 0 Aug  8 04:40 sdb
> root@debian-i386:~# ls -l /sys/kernel/debug/vfs_hotdata/sdb
> total 0
> -rw-r--r-- 1 root root 0 Aug  8 04:40 inode_data
> -rw-r--r-- 1 root root 0 Aug  8 04:40 range_data
> root@debian-i386:~# vi /mnt/file
> root@debian-i386:~# cat /sys/kernel/debug/hot_track/sdb/inode_data
> inode #279, reads 0, writes 1, avg read time 18446744073709551615,
> avg write time 5251566408153596, temp 109
> root@debian-i386:~# cat /sys/kernel/debug/hot_track/sdb/range_data
> inode #279, range start 0 (range len 1048576) reads 0, writes 1,
> avg read time 18446744073709551615, avg write time 1128690176623144209, temp 64
> root@debian-i386:~# echo "hot data tracking test" >> /mnt/file
> root@debian-i386:~# cat /sys/kernel/debug/hot_track/sdb/inode_data
> inode #279, reads 0, writes 2, avg read time 18446744073709551615,
> avg write time 4923343766042451, temp 109
> root@debian-i386:~# cat /sys/kernel/debug/hot_track/sdb/range_data
> inode #279, range start 0 (range len 1048576) reads 0, writes 2,
> avg read time 18446744073709551615, avg write time 1058147040842596150, temp 64
> root@debian-i386:~#
>
> Zhi Yong Wu (11):
>   vfs: introduce one structure hot_info
>   vfs: introduce one rb tree - hot_inode_tree
>   vfs: introduce 2 rb tree items - inode and range
>   vfs: add support for updating access frequency
>   vfs: add one new mount option -o hottrack
>   vfs: add init and exit support
>   vfs: introduce one hash table
>   vfs: enable hot data tracking
>   vfs: fork one private kthread to update temperature info
>   vfs: add 3 new ioctl interfaces
>   vfs: add debugfs support
>
>  fs/Makefile               |    3 +-
>  fs/compat_ioctl.c         |    8 +
>  fs/dcache.c               |    2 +
>  fs/direct-io.c            |   10 +
>  fs/hot_debugfs.c          |  488 ++++++++++++++++++++++++++++++++++
>  fs/hot_debugfs.h          |   60 +++++
>  fs/hot_hash.c             |  382 ++++++++++++++++++++++++++
>  fs/hot_hash.h             |  112 ++++++++
>  fs/hot_rb.c               |  648 +++++++++++++++++++++++++++++++++++++++++++++
>  fs/hot_rb.h               |   81 ++++++
>  fs/hot_track.c            |   85 ++++++
>  fs/hot_track.h            |   23 ++
>  fs/ioctl.c                |  132 +++++++++
>  fs/namespace.c            |   10 +
>  fs/super.c                |   11 +
>  include/linux/fs.h        |   15 +
>  include/linux/hot_track.h |  169 ++++++++++++
>  mm/filemap.c              |    8 +
>  mm/page-writeback.c       |   21 ++
>  mm/readahead.c            |    9 +
>  20 files changed, 2276 insertions(+), 1 deletions(-)
>  create mode 100644 fs/hot_debugfs.c
>  create mode 100644 fs/hot_debugfs.h
>  create mode 100644 fs/hot_hash.c
>  create mode 100644 fs/hot_hash.h
>  create mode 100644 fs/hot_rb.c
>  create mode 100644 fs/hot_rb.h
>  create mode 100644 fs/hot_track.c
>  create mode 100644 fs/hot_track.h
>  create mode 100644 include/linux/hot_track.h
>
> --
> 1.7.6.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Regards,

Zhi Yong Wu
