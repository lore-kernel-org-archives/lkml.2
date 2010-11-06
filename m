Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab0KFI7f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 04:59:35 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63547 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab0KFI72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 04:59:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=wGlSJDiWHhGHrZOWbU5iY3+0SZ9if9Fkzwmhgf/XeAVU87CdKdL43nbnlA8YQk4kS7
         pzCSb5azIM7Ou5Gbb9rbRaGBRA/mgPfiW7dNGvYKYOZ+uR7H7BxDHDIBH463MIbLV+uA
         3MWFJXsO6gdnQ0AwqOMhabgQgh7Mq7+Jv2gwY=
Message-ID: <4CD51832.7070309@gmail.com>
Date: Sat, 06 Nov 2010 09:56:18 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 01/16 v2] pramfs: documentation
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

Documentation for PRAMFS.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
diff -Nurp linux-2.6.36-orig/Documentation/filesystems/pramfs.txt linux-2.6.36/Documentation/filesystems/pramfs.txt
--- linux-2.6.36-orig/Documentation/filesystems/pramfs.txt	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.36/Documentation/filesystems/pramfs.txt	2010-10-23 09:04:32.000000000 +0200
@@ -0,0 +1,296 @@
+
+PRAMFS Overview
+===============
+
+Many embedded systems have a block of non-volatile RAM separate from
+normal system memory, i.e. of which the kernel maintains no memory page
+descriptors. For such systems it would be beneficial to mount a
+fast read/write filesystem over this "I/O memory", for storing frequently
+accessed data that must survive system reboots and power cycles. An
+example usage might be system logs under /var/log, or a user address
+book in a cell phone or PDA.
+
+Linux traditionally had no support for a persistent, non-volatile RAM-based
+filesystem, persistent meaning the filesystem survives a system reboot
+or power cycle intact. The RAM-based filesystems such as tmpfs and ramfs
+have no actual backing store but exist entirely in the page and buffer
+caches, hence the filesystem disappears after a system reboot or
+power cycle.
+
+A relatively straightforward solution is to write a simple block driver
+for the non-volatile RAM, and mount over it any disk-based filesystem such
+as ext2, ext3, ext4, etc.
+
+But the disk-based fs over non-volatile RAM block driver approach has
+some drawbacks:
+
+1. Complexity of disk-based fs: disk-based filesystems such as ext2/ext3/ext4
+   were designed for optimum performance on spinning disk media, so they
+   implement features such as block groups, which attempts to group inode data
+   into a contiguous set of data blocks to minimize disk seeking when accessing
+   files. For RAM there is no such concern; a file's data blocks can be
+   scattered throughout the media with no access speed penalty at all. So block
+   groups in a filesystem mounted over RAM just adds unnecessary
+   complexity. A better approach is to use a filesystem specifically
+   tailored to RAM media which does away with these disk-based features.
+   This increases the efficient use of space on the media, i.e. more
+   space is dedicated to actual file data storage and less to meta-data
+   needed to maintain that file data.
+
+2. Different problems between disks and RAM: Because PRAMFS attempts to avoid
+   filesystem corruption caused by kernel bugs, dirty pages in the page cache
+   are not allowed to be written back to the backing-store RAM. This way, an
+   errant write into the page cache will not get written back to the filesystem.
+   However, if the backing-store RAM is comparable in access speed to system
+   memory, the penalty of not using caching is minimal. With this consideration
+   it's better to move file data directly between the user buffers and the backing
+   store RAM, i.e. use direct I/O. This prevents the unnecessary populating of
+   the page cache with dirty pages. However direct I/O has to be enabled at
+   every file open. To enable direct I/O at all times for all regular files
+   requires either that applications be modified to include the O_DIRECT flag on
+   all file opens, or that the filesystem used performs direct I/O by default.
+
+The Persistent/Protected RAM Special Filesystem (PRAMFS) is a read/write
+filesystem that has been designed to address these issues. PRAMFS is targeted
+to fast I/O memory, and if the memory is non-volatile, the filesystem will be
+persistent.
+
+In PRAMFS, direct I/O is enabled across all files in the filesystem, in other
+words the O_DIRECT flag is forced on every open of a PRAMFS file. Also, file
+I/O in the PRAMFS is always synchronous. There is no need to block the current
+process while the transfer to/from the PRAMFS is in progress, since one of
+the requirements of the PRAMFS is that the filesystem exists in fast RAM. So
+file I/O in PRAMFS is always direct, synchronous, and never blocks.
+
+The data organization in PRAMFS can be thought of as an extremely simplified
+version of ext2, such that the ratio of data to meta-data is very high.
+
+PRAMFS supports the execute-in-place. With XIP, instead of keeping data in the
+page cache, the need to have a page cache copy is eliminated completely.
+Read&write type operations are performed directly from/to the memory. For file
+mappings, the RAM itself is mapped directly into userspace. XIP, in addition,
+speed up the applications start-up time because it removes the needs of any
+copies.
+
+PRAMFS is write protected. The page table entries that map the backing-store
+RAM are normally marked read-only. Write operations into the filesystem
+temporarily mark the affected pages as writeable, the write operation is
+carried out with locks held, and then the page table entries is +marked read-only again.
+This feature provides protection against filesystem corruption caused by errant
+writes into the RAM due to kernel bugs for instance. In case there are systems
+where the write protection is not possible (for instance the RAM cannot be
+mapped with page tables), this feature can be disabled via the
+CONFIG_PRAMFS_WRITE_PROTECT config option.
+
+PRAMFS supports extended attributes, ACLs and security labels.
+
+In summary, PRAMFS is a light-weight, space-efficient special filesystem that
+is ideal for systems with a block of fast non-volatile RAM that need to access
+data on it using a standard filesytem interface.
+
+Supported mount options
+=======================
+
+The PRAMFS currently requires one mount option, and there are several
+optional mount options:
+
+physaddr=	Required. It tells PRAMFS the physical address of the
+		start of the RAM that makes up the filesystem. The
+		physical address must be located on a page boundary.
+
+init=		Optional. It is used to initialize the memory to an
+		empty filesystem. Any data in an existing filesystem
+		will be lost if this option is given. The parameter to
+		"init=" is the RAM in kilo/mega/giga bytes.
+
+bs=		Optional. It is used to specify a block size. It is
+		ignored if the "init=" option is not specified, since
+		otherwise the block size is read from the PRAMFS
+		super-block. The default blocksize is 2048 bytes,
+		and the allowed block sizes are 512, 1024, 2048, and
+		4096.
+
+bpi=		Optional. It is used to specify the bytes per inode
+		ratio, i.e. for every N bytes in the filesystem, an
+		inode will be created. This behaves the same as the "-i"
+		option to mke2fs. It is ignored if the "init=" option is
+		not specified.
+
+N=		Optional. It is used to specify the number of inodes to
+		allocate in the inode table. If the option is not
+		specified, the bytes-per-inode ratio is used to
+		calculate the number of inodes. If neither the "N=" or
+		"bpi=" options are specified, the default behavior is to
+		reserve 5% of the total space in the filesystem for the
+		inode table. This option behaves the same as the "-N"
+		option to mke2fs. It is ignored if the "init=" option is
+		not specified.
+
+Examples:
+
+mount -t pramfs -o physaddr=0x20000000,init=1M,bs=1k none /mnt/pram
+
+This example locates the filesystem at physical address 0x20000000, and
+also requests an empty filesystem be initialized, of total size of one
+megabyte and blocksize of one kilobyte. The mount point is /mnt/pram.
+
+mount -t pramfs -o physaddr=0x20000000 none /mnt/pram
+
+This example locates the filesystem at physical address 0x20000000 as in
+the first example, but uses the intact filesystem that already exists.
+
+Current Limitations
+===================
+
+- The RAM used for PRAMFS must be directly addressable.
+
+- PRAMFS does not support hard links.
+
+- PRAMFS supports only private memory mappings. This allows most
+  executables to run, but programs that attempt shared memory
+  mappings, such as X apps that use X shared memory, will fail.
+
+- PRAMFS does not support quota settings.
+
+Further Documentation
+=====================
+
+If you are interested in the internal design of PRAMFS, there is
+documentation available at the Sourceforge PRAMFS home page at
+http://pramfs.sourceforge.net/.
+
+Please send bug reports/comments/feedback to the pramfs development
+list at sourceforge: pramfs-devel@lists.sourceforge.net.
+
+
+ChangeLog
+=========
+
+1.2.1
+	- kernel 2.6.36
+	- replaced d_add with d_splice_alias in pram_lookup to support NFS
+	- reworked pram_get_parent
+	- added disable/enable irq in the pram_{memlock|memunlock}_range
+	  in order to avoid "open windows" with writeable memory
+	- when xattr support was enabled, the semaphore xattr_sem wasn't
+	  initialized
+	- implemented new truncate convention
+	- removed pram_truncate_page
+	- fixed a possible oops in pram_put_super, a super block field was
+	  used after iounmap
+	- fixed file holes management
+	- super block s_size field now is 64bit
+
+1.2.0
+	- kernel 2.6.35
+	- added support for setattr callback, now truncate command works
+	- added support for extended attributes, ACLs, security labels
+	- fixed scalability problem with truncate mutex
+	- fixed bitmap endianess and problems with 64bit archs (bug 3013785)
+	- replaced functions pram_fill_new_inode and pram_fill_inode with
+	  pram_read_inode and pram_iget
+	- added support for export operations, now it's possible to use
+	  NFS to export pram mount points
+	- added generation field in the inode struct for file versioning
+	  (for NFS)
+	- fixed the settings of fields s_maxbytes and s_time_gran in the super
+	  block struct
+	- removed any reference to quota operations, they are not supported
+
+1.1.6
+	- kernel 2.6.33
+	- added preempt_enable/disable in pram_{memlock|memunlock}_range in
+	  order to avoid race conditions
+	- replaced pram_unlock_* and pram_lock_* with pram_memlock_* and
+	  pram_memunlock_*
+
+1.1.5
+	- kernel 2.6.31
+	- reworked pram_writeable in order to use the funcions
+	  write_on_kernel_pte_range and write_off_kernel_pte_range
+	- added writeable_kernel_pte_range in order to compile on ARM arch
+	- added truncate_inode_pages() in pram_delete_inode()
+	- fixed an endianess conversion error in super.c, df command didn't work
+	- fixed an error in pram_find_data_block(), some code was relative to
+	  32-bit design yet
+	- fixed an error in pram_free_block(), endianess conversion not needed
+	- fixed lock usage, possible deadlock recognized by lockdep
+
+1.1.4
+	- fs layout now endianess indipendent
+	- debug functions replaced with pr_*
+	- changed CONFIG_PRAMFS_NOWP to CONFIG_PRAMFS_WRITE_PROTECT and
+	  revert the meaning
+	- removed the rootfs mounting
+	- redundant superblock
+	- crc performed with crc16
+	- moved out pte manipulations
+	- used only flush_kernel_tlb_range instead of non standard
+	  flush_kernel_tlb_page
+	- replaced BKL with a mutex
+
+1.1.3:
+	- kernel 2.6.30
+	- replaced DQUOT macros with vfs_dq_* functions in inode.c
+
+1.1.2:
+	- kernel 2.6.29
+	- replaced current->fsuid and current->fsgid in inode.c with
+	  current_fsuid() and current_fsgid() macro
+	- replaced pram_fsync with simple_file_sync (deleted fsync.c)
+	- removed ioctl.c
+	- fix the minus inside pram_sync_super and pram_sync_inode
+	  inline functions
+	- now flags must be explicit in pram_lock/unlock_inode,
+	  pram_lock/unlock_super and in pram_lock/unlock_block
+	- fix compiler warning about unused flags variable
+	- now multiple instances of pramfs are allowed
+	- added management of mode, uid and gid mount options
+	- renamed find_pramfs_super() in pram_get_super() and changed its
+	  behaviour to remove the dependecy from a kernel symbol not exported
+	- added superblock operation pram_show_options
+	- added pram_parse_options function
+	- added checks for some mount parameters to avoid kernel crashes
+	- now a physical address of zero is allowed
+	- added the use of request_mem_region_exclusive
+	- now phys_addr in the struct pram_sb_info is phys_addr_t type
+
+1.1.1:
+	- kernel 2.6.28.1
+	- now the code is compliant to kernel coding style
+	- replaced typedef pram_off_t with the standard off_t
+
+1.1.0
+	- kernel 2.6.27
+	- added xip feature.
+
+1.0.4:
+	- kernel 2.6.10
+	- include <asm/tlbflush.h> in wprotect.c for
+	  flush_tlb_kernel_range().
+	- fixed a bug in pram_mknod(). The pramfs inode needs
+	  updating after calling init_special_inode() to update
+	  the rdev.
+1.0.3:
+	- kernel 2.6.9.
+	- __ioremap() definition not consistent across archs, use
+	  ioremap() instead.
+	- flush_tlb_kernel_page() is only available on some archs.
+	- fixed bug in pram_fill_super(): root inode pointer needs
+	  to be recalculated after remapping whole fs.
+1.0.2:
+	- kernel 2.6.4.
+	- use pram_truncate() in pram_delete_inode().
+	- dangling pram_lock_inode() removed in pram_truncate_blocks().
+	- edits to this README
+
+1.0.1:
+	- port to kernel 2.6.3.
+	- implement direct_IO() method instead of custom file read/write
+	  methods.
+	- do away with __ioremap_readonly() requirement.
+	- implement inode truncate() method.
+
+1.0.0:
+	- Started ChangeLog (kernel 2.4.22).
diff -Nurp linux-2.6.36-orig/Documentation/filesystems/xip.txt linux-2.6.36/Documentation/filesystems/xip.txt
--- linux-2.6.36-orig/Documentation/filesystems/xip.txt	2010-09-13 01:07:37.000000000 +0200
+++ linux-2.6.36/Documentation/filesystems/xip.txt	2010-09-14 18:49:52.000000000 +0200
@@ -49,6 +49,8 @@ This address space operation is mutually
 do page cache read/write operations.
 The following filesystems support it as of today:
 - ext2: the second extended filesystem, see Documentation/filesystems/ext2.txt
+- pramfs: persistent and protected RAM filesystem, see
+  Documentation/filesystems/pramfs.txt
  A set of file operations that do utilize get_xip_page can be found in
 mm/filemap_xip.c . The following file operation implementations are provided:
