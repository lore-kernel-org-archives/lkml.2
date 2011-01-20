Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab1ATOhd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 09:37:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755667Ab1ATOhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 09:37:32 -0500
Date: Thu, 20 Jan 2011 09:35:46 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] loop: queue_lock NULL pointer derefence in
 blk_throtl_exit (v2)
Message-ID: <20110120143546.GA18875@redhat.com>
References: <20110114192532.GA4274@swordfish>
 <20110120113211.GB16184@redhat.com>
 <20110120125849.GA4172@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110120125849.GA4172@swordfish>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 02:58:49PM +0200, Sergey Senozhatsky wrote:
> Performing
> $ sudo mount -o loop -o umask=0 /dev/sdb1 /mnt/
> mount: wrong fs type, bad option, bad superblock on /dev/loop0,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail  or so
> 
> $ sudo modprobe -r loop
> 
> results in oops:
> 
>  BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
>  IP: [<ffffffff812479d4>] do_raw_spin_lock+0x14/0x122
>  Process modprobe (pid: 6189, threadinfo ffff88009a898000, task ffff880154a88000)
>  Call Trace:
>   [<ffffffff81486788>] _raw_spin_lock_irq+0x4a/0x51
>   [<ffffffff8123404b>] ? blk_throtl_exit+0x3b/0xa0
>   [<ffffffff8105b120>] ? cancel_delayed_work_sync+0xd/0xf
>   [<ffffffff8123404b>] blk_throtl_exit+0x3b/0xa0
>   [<ffffffff81229bc8>] blk_release_queue+0x21/0x65
>   [<ffffffff8123bb06>] kobject_release+0x51/0x66
>   [<ffffffff8123bab5>] ? kobject_release+0x0/0x66
>   [<ffffffff8123ce1e>] kref_put+0x43/0x4d
>   [<ffffffff8123ba27>] kobject_put+0x47/0x4b
>   [<ffffffff8122717c>] blk_cleanup_queue+0x56/0x5b
>   [<ffffffffa01c3824>] loop_exit+0x68/0x844 [loop]
>   [<ffffffff8107cccc>] sys_delete_module+0x1e8/0x25b
>   [<ffffffff814864c9>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>   [<ffffffff81002112>] system_call_fastpath+0x16/0x1b
> 
> 
> because of an attempt to acquire NULL queue_lock.
> I added the same lines as in blk_queue_make_request -
> `fall back to embedded per-queue lock'.
> 
> v2: According to comment by Vivek Goyal, queue_lock NULL check and fix moved 
> out from loop driver code to blk_cleanup_queue, which is more general approach.
> 
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> 
> ---
> 
>  block/blk-core.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 2f4002f..45073ab 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -458,6 +458,10 @@ void blk_put_queue(struct request_queue *q)
>  
>  void blk_cleanup_queue(struct request_queue *q)
>  {
> +	/* fall back to our embedded per-queue locks */
> +	if (!q->queue_lock)
> +		q->queue_lock = &q->__queue_lock;
> +

Hi Sergey,

Can we expand a little bit on comment that why do we need to have
q->queue_lock initialized here now. Basically in the past nobody tried
to take q->queue_lock in blk_cleanup_queue() path hence things just
worked. Now blk throttling code is new and it takes q->queue_lock hence we
run into issues. This could be true for some other future code too.

Secondly currently blk throttle code seems to be the only user dependent
on this lock initialization. So it might make sense to move this code
closer to the actual call and blk_release_queue() might be even better
place to do it atleast for now.

Thanks
Vivek
