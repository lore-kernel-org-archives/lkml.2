Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946084Ab2K2Aja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 19:39:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422635Ab2K2Aj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 19:39:28 -0500
Date: Wed, 28 Nov 2012 19:38:37 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Jens Axboe <axboe@kernel.dk>, Jeff Chua <jeff.chua.linux@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jan Kara <jack@suse.cz>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] Introduce a method to catch mmap_region (was: Recent
 kernel "mount" slow)
In-Reply-To: <CA+55aFwbnQsvpsOLS6w_G35d4w+Ezv5tOx2SE7dShJhX4iP_0Q@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1211281904010.3957@file.rdu.redhat.com>
References: <CAAJw_ZtbhE5Jtd4PsWx8a23QdFTW7aMrKBmRf-bo5Wrean9Xhg@mail.gmail.com>
 <Pine.LNX.4.64.1211241555470.4300@file.rdu.redhat.com>
 <CAAJw_ZvUqRmCCQ5-2PdFPRyfdzZMuphGU=hgAjUOHGk=n9Mheg@mail.gmail.com>
 <CAAJw_ZuJXnAz1ukBwQa3xNbQaL1KUBSrbQMK2hn-7D6Ar1p3fQ@mail.gmail.com>
 <50B46E05.70906@kernel.dk> <CAAJw_ZsYuLCwCTc6U=ELO_PvyjnVKQdkPke2enfzm6zOeWAqjA@mail.gmail.com>
 <50B4B313.3030707@kernel.dk> <Pine.LNX.4.64.1211272252260.18338@file.rdu.redhat.com>
 <50B5CC5A.8060607@kernel.dk> <Pine.LNX.4.64.1211281222410.11599@file.rdu.redhat.com>
 <CA+55aFx4zYnEsUyGJurBjB0XZ0AgmyKqW-+KWVDvma3w6csnHQ@mail.gmail.com>
 <Pine.LNX.4.64.1211281422360.26389@file.rdu.redhat.com>
 <CA+55aFyXdtVJ=SG9bU4qfggCR6DPvz4vOFYxKJZx_WdyFv+3Fw@mail.gmail.com>
 <CA+55aFyXS0nkDB95c3pcdg1ctrNnUGO8aDuRNhKSEg3JrOqWhA@mail.gmail.com>
 <Pine.LNX.4.64.1211281540200.5283@file.rdu.redhat.com>
 <CA+55aFwbnQsvpsOLS6w_G35d4w+Ezv5tOx2SE7dShJhX4iP_0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 28 Nov 2012, Linus Torvalds wrote:

> > For example, __block_write_full_page and __block_write_begin do
> >         if (!page_has_buffers(page)) { create_empty_buffers... }
> > and then they do
> >         WARN_ON(bh->b_size != blocksize)
> >         err = get_block(inode, block, bh, 1)
> 
> Right. And none of this is new.
> 
> > ... so if the buffers were left over from some previous call to
> > create_empty_buffers with a different blocksize, that WARN_ON is trigged.
> 
> None of this can happen.

It can happen. Take your patch (the one that moves bd_block_size_semaphore 
into blkdev_readpage, blkdev_writepage and blkdev_write_begin).

Insert msleep(1000) into set_blocksize, just before sync_blockdev.

Run this program:
#define _XOPEN_SOURCE 500
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>

static char array[4096];

int main(void)
{
        int h;
        system("dmsetup remove test 2>/dev/null");
        if (system("dmsetup create test --table '0 1 zero'")) exit(1);
        h = open("/dev/mapper/test", O_RDWR);
        if (h < 0) perror("open"), exit(1);
        if (pread(h, array, 512, 0) != 512) perror("pread"), exit(1);
        if (system("dmsetup load test --table '0 8 zero'")) exit(1);
        if (system("dmsetup suspend test")) exit(1);
        if (system("dmsetup resume test")) exit(1);
        if (system("blockdev --setbsz 2048 /dev/mapper/test &")) exit(1);
        usleep(500000);
        if (pwrite(h, array, 4096, 0) != 4096) perror("pwrite"), exit(1);
        return 0;
}

--- it triggers WARNING: at fs/buffer.c:1830 in __block_write_begin
[ 1243.300000] Backtrace:
[ 1243.330000]  [<0000000040230ba8>] block_write_begin+0x70/0xd0
[ 1243.400000]  [<00000000402350cc>] blkdev_write_begin+0xb4/0x208
[ 1243.480000]  [<00000000401a9f10>] generic_file_buffered_write+0x248/0x348
[ 1243.570000]  [<00000000401ac8c4>] __generic_file_aio_write+0x1fc/0x388
[ 1243.660000]  [<0000000040235e74>] blkdev_aio_write+0x64/0xf0
[ 1243.740000]  [<00000000401f2108>] do_sync_write+0xd0/0x128
[ 1243.810000]  [<00000000401f2930>] vfs_write+0xa0/0x180
[ 1243.880000]  [<00000000401f2ecc>] sys_pwrite64+0xb4/0xd8
[ 1243.950000]  [<0000000040122104>] parisc_pwrite64+0x1c/0x28
[ 1244.020000]  [<0000000040106060>] syscall_exit+0x0/0x14


I'm not saying that your approach is wrong, you just have to carefuly
review all memory management code for assumptions that block size
doesn't change.

Mikulas
