Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab2DNKTI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 06:19:08 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:49012 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab2DNKTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 06:19:06 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: Re: [PATCH v2 4/4] fat: switch to fsinfo_inode
References: <1334326795-2446-1-git-send-email-dedekind1@gmail.com>
	<1334326795-2446-5-git-send-email-dedekind1@gmail.com>
Date: Sat, 14 Apr 2012 19:19:00 +0900
In-Reply-To: <1334326795-2446-5-git-send-email-dedekind1@gmail.com> (Artem
	Bityutskiy's message of "Fri, 13 Apr 2012 17:19:55 +0300")
Message-ID: <87fwc6hazv.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy <dedekind1@gmail.com> writes:

> From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
>
> Currently FAT file-system maps the VFS "superblock" abstraction to the FSINFO
> block. The FSINFO block contains non-essential data about the amount of free
> clusters and the next free cluster. FAT file-system can always find out this
> information by scanning the FAT table, but having it in the FSINFO block may
> speed things up sometimes. So FAT file-system relies on the VFS superblock
> write-out services to make sure the FSINFO block is written out to the media
> from time to time.
>
> The whole "superblock write-out" VFS infrastructure is served by the
> 'sync_supers()' kernel thread, which wakes up every 5 (by default) seconds and
> writes out all dirty superblock using the '->write_super()' call-back. But the
> problem with this thread is that it wastes power by waking up the system every
> 5 seconds no matter what. So we want to kill it completely and thus, we need to
> make file-systems to stop using the '->write_super' VFS service, and then
> remove it together with the kernel thread.
>
> This patch switches the FAT FSINFO block management from
> '->write_super()'/'->s_dirt' to 'fsinfo_inode'/'->write_inode'. Now, instead of
> setting the 's_dirt' flag, we just mark the special 'fsinfo_inode' inode as
> dirty and let VFS invoke the '->write_inode' call-back when needed, where we
> write-out the FSINFO block.
>
> This patch also makes sure we do not mark the 'fsinfo_inode' inode as dirty if
> we are not FAT32 (FAT16 and FAT12 do not have the FSINFO block) or if we are in
> R/O mode.
>
> As a bonus, we can also remove the '->sync_fs()' and '->write_super()' FAT
> call-back function because they become unneeded.

Hm, does this guarantee to flush FSINFO at umount?

FSINFO is last part of data dependency. I.e. inode change can dirty
FSINFO. So, FSINFO has to be flushed after normal inodes.

Roughly, the prefer order to flush would be,

1) user data
2) dirent
3) cluster chain
4) fsinfo
5) wait next period

current scheme (sync_supers thread, and writeback) also doesn't above
order though, I think the change to use inode is bad direction...

For above reason, I don't like to use inode for FSINFO is proper.

If we can do above order, it would be minimize chance of corruption on
disk structure. IOW, wrong order keeps corrupt on-disk structure.

So, I prefer to allow customize writeback order (this might not be your
target though). E.g. add ->writeback_sb_inodes handler to sb, and
helpers (iirc, reiserfs4 had it). The pesudo code of this is

fat_writeback()
{
	writeback_sb_inodes()
        fat_clusters_flush()   <= flush FSINFO, not only dirty buffer
}

super_operation = {
	.writeback = fat_writeback,
}

However, I feel this is too big to satisfy your target..., hmm...

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
