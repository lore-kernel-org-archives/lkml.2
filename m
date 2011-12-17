Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367Ab1LQWWz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 17:22:55 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34426 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab1LQWWx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 17:22:53 -0500
Date: Sun, 18 Dec 2011 01:19:28 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, Namhyung Kim <namhyung@gmail.com>,
        Lukas Czerner <lczerner@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] loop: fput() called in loop_clr_fd() may cause bd_mutex
 recursive locking
Message-ID: <20111217221928.GB3313@swordfish>
References: <20111217215333.GA3313@swordfish>
 <20111217221232.GA2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20111217221232.GA2203@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (12/17/11 22:12), Al Viro wrote:
> > 
> > [23044.654647] umount/24442 is trying to acquire lock:
> > [23044.654652]  (&bdev->bd_mutex){+.+.+.}, at: [<ffffffff81144311>] blkdev_put+0x1f/0x131
> > [23044.654670] 
> > [23044.654672] but task is already holding lock:
> > [23044.654677]  (&bdev->bd_mutex){+.+.+.}, at: [<ffffffff811441a1>] __blkdev_put+0x33/0x184
> > [23044.654690] 
> > [23044.654692] other info that might help us debug this:
> > [23044.654697]  Possible unsafe locking scenario:
> > [23044.654727] 
> > [23044.654731] 1 lock held by umount/24442:
> > [23044.654735]  #0:  (&bdev->bd_mutex){+.+.+.}, at: [<ffffffff811441a1>] __blkdev_put+0x33/0x184
> > [23044.654748] 
> > [23044.654762] Call Trace:
> > [23044.654773]  [<ffffffff81075611>] __lock_acquire+0x15bf/0x1659
> > [23044.654784]  [<ffffffff8114b3e3>] ? inotify_free_group_priv+0x4f/0x4f
> > [23044.654792]  [<ffffffff81144311>] ? blkdev_put+0x1f/0x131
> > [23044.654799]  [<ffffffff81075c6a>] lock_acquire+0x138/0x1b3
> > [23044.654807]  [<ffffffff81144311>] ? blkdev_put+0x1f/0x131
> > [23044.654814]  [<ffffffff81144311>] ? blkdev_put+0x1f/0x131
> > [23044.654824]  [<ffffffff8147ce67>] mutex_lock_nested+0x5e/0x325
> > [23044.654831]  [<ffffffff81144311>] ? blkdev_put+0x1f/0x131
> > [23044.654838]  [<ffffffff81149963>] ? fsnotify+0x441/0x459
> > [23044.654846]  [<ffffffff81144311>] blkdev_put+0x1f/0x131
> > [23044.654853]  [<ffffffff81144443>] blkdev_close+0x20/0x22
> > [23044.654863]  [<ffffffff81116b21>] fput+0x117/0x1cf
> > [23044.654874]  [<ffffffffa016eb71>] loop_clr_fd+0x1f2/0x201 [loop]
> > [23044.654882]  [<ffffffffa016f861>] lo_release+0x40/0x6f [loop]
> > [23044.654890]  [<ffffffff81144244>] __blkdev_put+0xd6/0x184
> > [23044.654898]  [<ffffffff8114441a>] blkdev_put+0x128/0x131
> > [23044.654906]  [<ffffffff8111704e>] kill_block_super+0x60/0x65
> > [23044.654914]  [<ffffffff81117366>] deactivate_locked_super+0x32/0x63
> > [23044.654922]  [<ffffffff81117cc9>] deactivate_super+0x3a/0x3e
> > [23044.654931]  [<ffffffff8112fc5d>] mntput_no_expire+0xbf/0xc4
> > [23044.654939]  [<ffffffff811309c7>] sys_umount+0x2c5/0x2f3
> > [23044.654949]  [<ffffffff81484b12>] system_call_fastpath+0x16/0x1b
[..]
> 
> NAK - you've "fixed" a false positive from lock checker by failing to close
> the underlying device.
> 

Sorry, why is that a false positive?

blkdev_put() calls lo_release() while holding bd_mutex,
lo_release() calls loop_clr_fd() -> fput(). fput() once again
attempts to grub already held bd_mutex calling blkdev_put().
Looks like a recursion to me.


	Sergey
