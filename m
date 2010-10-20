Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab0JTTzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 15:55:42 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:36681 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060Ab0JTTzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 15:55:38 -0400
Date: Wed, 20 Oct 2010 12:54:59 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH 01/16] pramfs: documentation
Message-Id: <20101020125459.c183c286.randy.dunlap@oracle.com>
In-Reply-To: <4CB1E976.7080607@gmail.com>
References: <4CB1E976.7080607@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Oct 2010 18:27:34 +0200 Marco Stornelli wrote:

> From: Marco Stornelli <marco.stornelli@gmail.com>
> 
> Documentation for PRAMFS.
> 
> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
> ---
> diff -Nurp linux-2.6.36-orig/Documentation/filesystems/pramfs.txt linux-2.6.36/Documentation/filesystems/pramfs.txt
> --- linux-2.6.36-orig/Documentation/filesystems/pramfs.txt	1970-01-01 01:00:00.000000000 +0100
> +++ linux-2.6.36/Documentation/filesystems/pramfs.txt	2010-09-25 15:10:41.000000000 +0200
> @@ -0,0 +1,295 @@
> +
> +PRAMFS Overview
> +===============
> +
> +Many embedded systems have a block of non-volatile RAM seperate from

                                                          separate

> +normal system memory, i.e. of which the kernel maintains no memory page
> +descriptors. For such systems it would be beneficial to mount a
> +fast read/write filesystem over this "I/O memory", for storing frequently
> +accessed data that must survive system reboots and power cycles. An
> +example usage might be system logs under /var/log, or a user address
> +book in a cell phone or PDA.
> +
> +Linux traditionally had no support for a persistent, non-volatile RAM-based
> +filesystem, persistent meaning the filesystem survives a system reboot
> +or power cycle intact. The RAM-based filesystems such as tmpfs and ramfs
> +have no actual backing store but exist entirely in the page and buffer
> +caches, hence the filesystem disappears after a system reboot or
> +power cycle.
> +
> +A relatively straight-forward solution is to write a simple block driver

                straightforward

> +for the non-volatile RAM, and mount over it any disk-based filesystem such
> +as ext2, ext3, ext4, etc.
> +
> +But the disk-based fs over non-volatile RAM block driver approach has
> +some drawbacks:
> +
> +1. Complexity of disk-based fs: disk-based filesystems such as ext2/ext3/ext4
> +   were designed for optimum performance on spinning disk media, so they
> +   implement features such as block groups, which attempts to group inode data
> +   into a contiguous set of data blocks to minimize disk seeking when accessing
> +   files. For RAM there is no such concern; a file's data blocks can be
> +   scattered throughout the media with no access speed penalty at all. So block
> +   groups in a filesystem mounted over RAM just adds unnecessary
> +   complexity. A better approach is to use a filesystem specifically
> +   tailored to RAM media which does away with these disk-based features.
> +   This increases the efficient use of space on the media, i.e. more
> +   space is dedicated to actual file data storage and less to meta-data
> +   needed to maintain that file data.
> +
> +2. Different problems between disks and RAM: Because PRAMFS attempts to avoid
> +   filesystem corruption caused by kernel bugs, dirty pages in the page cache
> +   are not allowed to be written back to the backing-store RAM. This way, an
> +   errant write into the page cache will not get written back to the filesystem.
> +   However, if the backing-store RAM is comparable in access speed to system
> +   memory, the penalty of not using caching is minimal. With this consideration
> +   better to move file data directly between the user buffers and the backing

      it is better (?)

> +   store RAM, i.e. use direct I/O. This prevents the unnecessary populating of
> +   the page cache with dirty pages. However direct I/O has to be enabled at
> +   every file open. To enable direct I/O at all times for all regular files
> +   requires either that applications be modified to include the O_DIRECT flag on
> +   all file opens, or that the filesystem used performs direct I/O by default.
> +
> +The Persistent/Protected RAM Special Filesystem (PRAMFS) is a read/write
> +filesystem that has been designed to address these issues. PRAMFS is targeted
> +to fast I/O memory, and if the memory is non-volatile, the filesystem will be
> +persistent.
> +
> +In PRAMFS, direct I/O is enabled across all files in the filesystem, in other
> +words the O_DIRECT flag is forced on every open of a PRAMFS file. Also, file
> +I/O in the PRAMFS is always synchronous. There is no need to block the current
> +process while the transfer to/from the PRAMFS is in progress, since one of
> +the requirements of the PRAMFS is that the filesystem exist in fast RAM. So

                                                         exists

> +file I/O in PRAMFS is always direct, synchronous, and never blocks.
> +
> +The data organization in PRAMFS can be thought of as an extremely simplified
> +version of ext2, such that the ratio of data to meta-data is very high.
> +
> +PRAMFS supports the execute-in-place. With Xip, instead of keeping data in the

          supports execute-in-place.  With XIP,

> +page cache, the need to have a page cache copy is eliminated completely.
> +Read&write type operations are performed directly from/to the memory. For file

  Read & write

> +mappings, the RAM itself is mapped directly into userspace. Xip, in addition,

                                                               XIP,

> +speed-up the applications start-up time because it removes the needs of any

   speeds up
> +copies.
> +
> +PRAMFS is write protected. The page table entries that map the backing-store
> +RAM are normally marked read-only. Write operations into the filesystem
> +temporarily mark the affected pages as writeable, the write operation is
> +carried out with locks held, and then the pte is marked read-only again.

s/pte/page table entry/

> +This feature provides protection against filesystem corruption caused by errant
> +writes into the RAM due to kernel bugs for instance. In case there are systems
> +where the write protection is not possible (for instance the RAM cannot be
> +mapped with page tables), this feature can be disabled via

                                                          via the

> +CONFIG_PRAMFS_WRITE_PROTECT config option.
> +
> +PRAMFS supports extended attributes, ACLs and security labels.
> +
> +In summary, PRAMFS is a light-weight, space-efficient special filesystem that
> +is ideal for systems with a block of fast non-volatile RAM that need to access
> +data on it using a standard filesytem interface.
> +
> +Supported mount options
> +=======================
> +
> +The PRAMFS currently requires one mount option, and there are several
> +optional mount options:
> +
> +physaddr=	Required. It tells PRAMFS the physical address of the
> +		start of the RAM that makes up the filesystem. The
> +		physical address must be located on a page boundary.
> +
> +init=		Optional. It is used to initialize the memory to an
> +		empty filesystem. Any data in an existing filesystem
> +		will be lost if this option is given. The parameter to
> +		"init=" is the RAM in kilo/mega/giga bytes.
> +
> +bs=		Optional. It is used to specify a block size. It is
> +		ignored if the "init=" option is not specified, since
> +		otherwise the block size is read from the PRAMFS
> +		super-block. The default blocksize is 2048 bytes,
> +		and the allowed block sizes are 512, 1024, 2048, and
> +		4096.
> +
> +bpi=		Optional. It is used to specify the bytes per inode
> +		ratio, i.e. For every N bytes in the filesystem, an

		            for

> +		inode will be created. This behaves the same as the "-i"
> +		option to mke2fs. It is ignored if the "init=" option is
> +		not specified.
> +
> +N=		Optional. It is used to specify the number of inodes to
> +		allocate in the inode table. If the option is not
> +		specified, the bytes-per-inode ratio is used the

		                                     is used to

> +		calculate the number of inodes. If neither the "N=" or
> +		"bpi=" options are specified, the default behavior is to
> +		reserve 5% of the total space in the filesystem for the
> +		inode table. This option behaves the same as the "-N"
> +		option to mke2fs. It is ignored if the "init=" option is
> +		not specified.
> +
> +Examples:
> +
> +mount -t pramfs -o physaddr=0x20000000,init=1M,bs=1k none /mnt/pram
> +
> +This example locates the filesystem at physical address 0x20000000, and
> +also requests an empty filesystem be initialized, of total size of one
> +megabytes and blocksize of one kilobytes. The mount point is /mnt/pram.

I would use "megabyte" and "kilobyte" since there is only "one" of each of them.

> +
> +mount -t pramfs -o physaddr=0x20000000 none /mnt/pram
> +
> +This example locates the filesystem at physical address 0x20000000 as in
> +the first example, but uses the intact filesystem that already exists.
> +
> +Current Limitations
> +===================
> +
> +- The RAM used for PRAMFS must be directly addressable.
> +
> +- PRAMFS does not support hard links.
> +
> +- PRAMFS supports only private memory mappings. This allows most
> +  executables to run, but programs that attempt shared memory
> +  mappings, such as X apps that use X shared memory, will fail.
> +
> +- PRAMFS does not support quota settings.
> +
> +Further Documentation
> +=====================
> +
> +If you are interested in the internal design of PRAMFS, there is
> +documentation available at the Sourceforge PRAMFS home page at
> +http://pramfs.sourceforge.net/.
> +
> +Please send bug reports/comments/feedback to the pramfs development
> +list at sourceforge: pramfs-devel@lists.sourceforge.net.
> +
> +
> +ChangeLog
> +=========

[snip]


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
