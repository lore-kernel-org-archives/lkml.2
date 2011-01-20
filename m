Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab1ATLd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 06:33:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755056Ab1ATLd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 06:33:57 -0500
Date: Thu, 20 Jan 2011 06:32:11 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] loop: queue_lock NULL pointer derefence in
 blk_throtl_exit
Message-ID: <20110120113211.GB16184@redhat.com>
References: <20110114192532.GA4274@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110114192532.GA4274@swordfish>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 09:25:32PM +0200, Sergey Senozhatsky wrote:
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
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> 
> ---
> 
>  drivers/block/loop.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index 44e18c0..49e6a54 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -1641,6 +1641,9 @@ out:
>  
>  static void loop_free(struct loop_device *lo)
>  {
> +	if (!lo->lo_queue->queue_lock)
> +		lo->lo_queue->queue_lock = &lo->lo_queue->__queue_lock;
> +
>  	blk_cleanup_queue(lo->lo_queue);
>  	put_disk(lo->lo_disk);
>  	list_del(&lo->lo_list);

IIUC, the issue here seems to be that we allocated a request queue but
never initiliazed it and then called blk_cleanup_queue() on that. 

I noticed in loop driver there is another blk_cleanup_queue() call
in loop_alloc() if memory allocation fails. There also we will run into
similar issue.

IMHO, a better place to fix this might be blk_release_queue() where we
can default to q->__spin_lock if we are cleaning up an uninitialized queue.
That way we shall not have to fix inidividual drivers. And it also
does not sound right to expect a driver to make sure queue lock is
initialized before it calls blk_cleanup_queue() on the queue.

Thanks
Vivek
