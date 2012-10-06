Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab2JFHTQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 03:19:16 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:50259 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab2JFHTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 03:19:14 -0400
Date: Sat, 6 Oct 2012 09:19:05 +0200
From: Stefan Hajnoczi <stefanha@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/16] f2fs: add document
Message-ID: <20121006071905.GA28760@stefanha-thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000801cda2f0$672214f0$35663ed0$%kim@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This adds a document describing the mount options, proc entries, usage, and
> design of Flash-Friendly File System, namely F2FS.
> 
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim <at> samsung.com>
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
> +known to have different characteristics from the conventional rotational disks,
> +a file system, an upper layer to the storage device, should adapt to the changes
> +from the sketch.
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

This is pretty high-level, can you list the main F2FS design points that are
optimized for NAND flash characteristics?

First I thought it's log-structured so it automatically performs write
wear-leveling.  But F2FS is intended to be used on top of FTL?  So the FTL
already handles that, and also it appears F2FS is a hybrid between append-only
and write in-place.

Who will choose "various parameters" and select "allocation and cleaning
algorithms" appropriate for the device?  I wouldn't know what to parameter
values to use.

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
> +			              `- direct node (1018)
> +	                                         `- data (1018)

Earlier it says "one double indirect node pointer" but this diagram shows a
"triple indirect node".  The diagram itself suggests this should really be
"double indirect node" because it points to 1 indirect node.

Stefan
