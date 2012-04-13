Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970Ab2DMANB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 20:13:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54052 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab2DMAM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 20:12:59 -0400
Date: Thu, 12 Apr 2012 17:12:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v1 0/3] do not use s_dirt in FAT FS
Message-Id: <20120412171257.a0fc35b4.akpm@linux-foundation.org>
In-Reply-To: <1334144707-9729-1-git-send-email-dedekind1@gmail.com>
References: <1334144707-9729-1-git-send-email-dedekind1@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2012 14:45:04 +0300
Artem Bityutskiy <dedekind1@gmail.com> wrote:

> The FAT file-system uses the VFS '->write_super()' method for writing out
> the FSINFO block, which contains useful but not critical information like
> the amount of free clusters.
> 
> This patch-set makes FAT FS use its own mechanisms for writing-out the FSINFO
> block and stop using the '->write_super()' VFS method. Namely, the FAT FS now
> submits a delayed work for writing out the FSINFO block once it becomes dirty.
> 
> The reason of this exercises is to get rid of the 'sync_supers()' kernel thread.
> This kernel thread wakes up every 5 (by default) and calls '->write_super()'
> for all mounted file-systems. And the bad thing is that this is done even if
> all the superblocks are clean. Moreover, some file-systems do not even need this
> end they do not register the '->write_super()' method at all (e.g., btrfs).
> 
> So 'sync_supers()' most often just generates useless wake-ups and wastes
> power. I am trying to make all file-systems independent of '->write_super()'
> and plan to remove 'sync_supers()' and '->write_super' completely once there
> are no more users.
> 
> Tested with xfstests.
> 
> Note: in the past I was trying to upstream patches which optimized 'sync_super()',
> but Al Viro wanted me to kill it completely instead, which I am trying to do now.

hm, I hadn't actually noticed the arrival of the sync_supers kernel
thread.

I don't think that the old scheme of calling sync_supers() via the
writeback (kudate) code was really appropriate.  ->write_super() is
mainly an fs-level function whose role is to push data from in-kernel
data structures down into the buffer_head layer (typically).  That
isn't a writeback function.

> ======
> Overall status:
> 
> 1. ext4: patches submitted, waiting for reply from Ted Ts'o:
>    https://lkml.org/lkml/2012/4/2/111
> 2. ext2: patches are in the ext2 tree maintained by Jan Kara:
>    git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_next
>    However, one patch is still not there:
>    http://www.spinics.net/lists/linux-ext4/msg31492.html
> 
> TODO: affs, exofs, hfs, hfsplus, jffs2, reiserfs, sysv, udf, ufs

That's a lot of work.

I don't really like the implementation.  It implies that we'll be
copying and pasting quite a lot of boilerplate delayed-work code into
many different filesystems.  Surely there is a way of hoisting the
common code up into the vfs library layer.

That implies that we retain ->write_super, probably in a modified form.
Modified to permit the VFS to determine whether the superblock needs
treatment, if ->s_dirt doesn't suffice.

The code as you've proposed it will cause more wakeups than needed - if
multiple filesystems are mounted and active, their timers will get out
of sync.  Which rather defeats the intent of the whole work!  This
problem should be addressable via some new centralised way of managing
things.


