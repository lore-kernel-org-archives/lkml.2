Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab2DNLvR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 07:51:17 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:49056 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952Ab2DNLvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 07:51:14 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: dedekind1@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: Re: [PATCH v2 4/4] fat: switch to fsinfo_inode
References: <1334326795-2446-1-git-send-email-dedekind1@gmail.com>
	<1334326795-2446-5-git-send-email-dedekind1@gmail.com>
	<87fwc6hazv.fsf@devron.myhome.or.jp> <1334399379.2263.8.camel@koala>
	<87bomuha77.fsf@devron.myhome.or.jp> <1334401307.2263.24.camel@koala>
Date: Sat, 14 Apr 2012 20:51:09 +0900
In-Reply-To: <1334401307.2263.24.camel@koala> (Artem Bityutskiy's message of
	"Sat, 14 Apr 2012 14:01:45 +0300")
Message-ID: <873986h6qa.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy <dedekind1@gmail.com> writes:

>> > Sorry, I do not see how this can be true. You have a just bunch of dirty
>> > inodes, and it does not matter in which order you flush them. See
>> > __fat_write_inode() - it does not change the FAT table and does not
>> > affect the FSINFO block.
>> >
>> > Besides, the _current_ code first writes out FSINFO, because VFS calls
>> > ->sync_fs() first, then it starts writing back, then VFS calls
>> > ->sync_fs() for the second time.
>
> This is actually not exactly correct, but anyway, the first
> ->sync_fs(sb, 0) may come to FAT FS while it is in the middle of writing
> out the inodes.
>
> BTW, fat_clusters_flush() does not wait on the FSINFO block, which I
> think is a bug. I mean, it should call 'sync_dirty_buffer()'. I can
> submit a separate patch later.

write_super() is update and dirty buffer. Actual flush is via blockdev
(by historical reason), right? So, I think we don't need to wait at
sync_fs() in FATfs case.

>> Common case is delayed allocation though, in the case of FATfs, it would
>> be only truncate by last iput().
>
> Sorry, I do not understand what you mean. Do you still want me to take
> care of the order or not? If yes, could you please explain why?

Yes, I still worry about order. About ->sync_fs(), you are looking the
following?

__sync_filesystem(sb, 0)
__sync_filesystem(sb, 1)

Those are doing

1) try flush dirty all data at first without blocking
	__sync_filesystem(sb, 0)
2) wait some data of (1), and complete inodes work
	part of __sync_filesystem(sb, 1)
3) write super block to buffer
	->sync_fs() in __sync_filesystem(sb, 1)
4) flush and wait all metadata on blockdev
	__sync_blockdev() in __sync_filesystem(sb, 1)

right?

In your patch, we lose (3). (And I can't remember why I did it though,
your patch lose write_super() in ->put_super() too.)
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
