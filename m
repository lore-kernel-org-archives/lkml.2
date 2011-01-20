Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab1ATAdK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 19:33:10 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:49645 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751Ab1ATAdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 19:33:08 -0500
Message-ID: <4D3782BB.9080705@fusionio.com>
Date: Wed, 19 Jan 2011 17:32:59 -0700
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
CC: Philipp Reisner <philipp.reisner@linbit.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] loop: queue_lock NULL pointer derefence in blk_throtl_exit
References: <20110114192532.GA4274@swordfish>
In-Reply-To: <20110114192532.GA4274@swordfish>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-01-14 12:25, Sergey Senozhatsky wrote:
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

Queued up for 2.6.38, thanks.

-- 
Jens Axboe

