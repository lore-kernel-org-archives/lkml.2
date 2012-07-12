Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971Ab2GLTVu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 15:21:50 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:44175 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755774Ab2GLTVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 15:21:48 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "Steven J. Magnani" <steve@digidescorp.com>
Cc: Stevie Trujillo <stevie.trujillo@gmail.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: mount -o loop with truncated dosdisk.img uses 100% cpu and can't be killed
References: <20120712162828.3f561315@localhost>
	<1342106206.2156.2.camel@iscandar.digidescorp.com>
Date: Fri, 13 Jul 2012 04:21:44 +0900
In-Reply-To: <1342106206.2156.2.camel@iscandar.digidescorp.com> (Steven
	J. Magnani's message of "Thu, 12 Jul 2012 10:16:46 -0500")
Message-ID: <87k3y8yed3.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Steven J. Magnani" <steve@digidescorp.com> writes:

> On Thu, 2012-07-12 at 16:28 +0200, Stevie Trujillo wrote: 
>> Hello,
>> 
>> I was trying to create a bootdisk to update my BIOS, and accidentially
>> made a 512byte image with only the FreeDOS header in it.
>> 
>> ( Linux 3.4.4 )
>> # mount -o loop dosdisk.img /tmp
>> ^C^C^C
>> It uses 100% CPU and doesn't listen to me when I do ^C, kill -9 etc. I
>> think this means it's stuck in the kernel?
>
> Here is the stack trace I get for the mount process:
>
> [root@telezart smagnani]# cat /proc/1334/stack
> [<ffffffff81077a5a>] __cond_resched+0x2a/0x40
> [<ffffffff8110c4bb>] find_lock_page+0x3b/0x80
> [<ffffffff8110cbaf>] find_or_create_page+0x3f/0xb0
> [<ffffffff8119a692>] __getblk+0xf2/0x2a0
> [<ffffffff8119a893>] __bread+0x13/0xb0
> [<ffffffffa00fd1fe>] fat__get_entry+0x14e/0x220 [fat]
> [<ffffffffa00fd596>] fat_get_short_entry+0x66/0xc0 [fat]
> [<ffffffffa00ff765>] fat_subdirs+0x55/0x80 [fat]
> [<ffffffffa0103d30>] fat_fill_super+0x810/0xa80 [fat]
> [<ffffffffa00e821a>] vfat_fill_super+0x1a/0x20 [vfat]
> [<ffffffff8116d61b>] mount_bdev+0x1cb/0x210
> [<ffffffffa00e81f5>] vfat_mount+0x15/0x20 [vfat]
> [<ffffffff8116e410>] mount_fs+0x20/0xd0
> [<ffffffff81186e4f>] vfs_kern_mount+0x6f/0x100
> [<ffffffff81187804>] do_kern_mount+0x54/0x110
> [<ffffffff811891d6>] do_mount+0x306/0x8b0
> [<ffffffff811898cd>] sys_mount+0x8d/0xe0
> [<ffffffff81583629>] system_call_fastpath+0x16/0x1b
> [<ffffffffffffffff>] 0xffffffffffffffff
>
> I would think this is more likely a bug in the loopback driver than the
> FAT filesystem...

It looks like the bug of __getblk_slow(). If requested block was beyond
end of device, __find_get_block() will find buffer_mapped()'s buffer,
but block >= end_block is unmapped. So, it can be loop.

The following patch fixes it? If it fix, there are some options to check
it.

a) Check it like this patch and warn.
b) (a), but without warn.
c) Check it in init_page_buffers() and return -EIO or such

Well, anyway, Cc to Jens.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/buffer.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN fs/buffer.c~debug fs/buffer.c
--- tux3fs/fs/buffer.c~debug	2012-07-13 04:10:40.000000000 +0900
+++ tux3fs-hirofumi/fs/buffer.c	2012-07-13 04:11:50.000000000 +0900
@@ -1055,6 +1055,13 @@ __getblk_slow(struct block_device *bdev,
 		dump_stack();
 		return NULL;
 	}
+	if (block >= blkdev_max_block(I_BDEV(bdev->bd_inode))) {
+		printk(KERN_ERR "getblk(): block %llu, end_block %llu\n",
+		       (unsigned long long)block,
+		       (unsigned long long)blkdev_max_block(I_BDEV(bdev->bd_inode)));
+		dump_stack();
+		return NULL;
+	}
 
 	for (;;) {
 		struct buffer_head * bh;
_

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
