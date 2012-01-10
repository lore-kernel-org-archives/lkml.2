Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494Ab2AJRLD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 12:11:03 -0500
Received: from alice.et.bocholt.fh-gelsenkirchen.de ([193.175.197.63]:57193
	"EHLO alice.et.bocholt.fh-gelsenkirchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932143Ab2AJRLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 12:11:01 -0500
X-DKIM: Sendmail DKIM Filter v2.8.3 alice.et.bocholt.fh-gelsenkirchen.de q0AHArZ8019842
From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
To: Tejun Heo <tj@kernel.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] Problem since "block: make gendisk hold a reference to its queue"
In-Reply-To: <20120110162234.GA20446@google.com> (Tejun Heo's message of "Tue,
	10 Jan 2012 08:22:34 -0800")
References: <gik44z4phd.fsf@karga.hank.lab>
	<20120110162234.GA20446@google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Date: Tue, 10 Jan 2012 18:10:51 +0100
Message-ID: <gir4z7zdno.fsf@mx10.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender succeeded STARTTLS authentication, not delayed by milter-greylist-4.2.3 (alice.et.bocholt.fh-gelsenkirchen.de [192.168.0.63]); Tue, 10 Jan 2012 18:10:53 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Hello,
>
> On Tue, Jan 10, 2012 at 03:11:10PM +0100, Dirk Gouders wrote:
>> I noticed problematic kernel messages when my laptop boots, bisecting
>> this issue lead me to commit 523e1d399c.  I attach the messages that I
>> currently (commit e4e11180df) see, please let me know if further
>> information is needed.
>
> Thank you very much for bisecting the problem.
>
>> floppy0: no floppy controllers found
>> =============================================================================
>> BUG blkdev_queue: Poison overwritten
>> -----------------------------------------------------------------------------
>
> Yeah, floppy does some funky stuff during init.
>
>> Object ffff88006ec30420: 6b 6b 6b 6b 6b 6b 6b 6b 6a 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkjkkkkkkk
>
> This looks like refcnt is dec'd after released.  Can you please apply
> the following patch and see whether the WARN_ON() triggers?

I applied the patch and attached the output.

I did another test and reverted 523e1d399c.  After that the kernel
messages didn't show up but that did not help with wakeup from suspend.

I guess these problems are unrelated and Kay probably wants to deal
with them separately?

Dirk

> diff --git a/block/blk-core.c b/block/blk-core.c
> index 15de223..c3de15e 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -342,6 +342,7 @@ EXPORT_SYMBOL(blk_run_queue);
>  
>  void blk_put_queue(struct request_queue *q)
>  {
> +	WARN_ON(atomic_read(&q->kobj.kref.refcount) == 0x6b6b6b6b);
>  	kobject_put(&q->kobj);
>  }
>  EXPORT_SYMBOL(blk_put_queue);

floppy0: no floppy controllers found
------------[ cut here ]------------
WARNING: at block/blk-core.c:345 blk_put_queue+0x22/0x2f()
Hardware name: 08946MG
Modules linked in:
Pid: 1, comm: swapper/0 Not tainted 3.2.0-04874-ge4e1118-dirty #86
Call Trace:
 [<ffffffff81032f12>] ? warn_slowpath_common+0x78/0x8c
 [<ffffffff8120436b>] ? blk_put_queue+0x22/0x2f
 [<ffffffff8120a72a>] ? disk_release+0xa1/0xaf
 [<ffffffff812b99d9>] ? device_release+0x41/0x73
 [<ffffffff81214dae>] ? kobject_release+0x48/0x5e
 [<ffffffff817beb2f>] ? floppy_init+0xd81/0xd96
 [<ffffffff81490d0b>] ? register_cpu_notifier+0x25/0x2f
 [<ffffffff817bddae>] ? daring+0x67/0x67
 [<ffffffff810002e5>] ? do_one_initcall+0x78/0x12b
 [<ffffffff81798b2c>] ? kernel_init+0x95/0x113
 [<ffffffff814a9154>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff81798a97>] ? start_kernel+0x32c/0x32c
 [<ffffffff814a9150>] ? gs_change+0xb/0xb
---[ end trace f96f3959e84427e9 ]---
------------[ cut here ]------------
WARNING: at block/blk-core.c:345 blk_put_queue+0x22/0x2f()
Hardware name: 08946MG
Modules linked in:
Pid: 1, comm: swapper/0 Tainted: G        W    3.2.0-04874-ge4e1118-dirty #86
Call Trace:
 [<ffffffff81032f12>] ? warn_slowpath_common+0x78/0x8c
 [<ffffffff8120436b>] ? blk_put_queue+0x22/0x2f
 [<ffffffff8120a72a>] ? disk_release+0xa1/0xaf
 [<ffffffff812b99d9>] ? device_release+0x41/0x73
 [<ffffffff81214dae>] ? kobject_release+0x48/0x5e
 [<ffffffff817beb2f>] ? floppy_init+0xd81/0xd96
 [<ffffffff81490d0b>] ? register_cpu_notifier+0x25/0x2f
 [<ffffffff817bddae>] ? daring+0x67/0x67
 [<ffffffff810002e5>] ? do_one_initcall+0x78/0x12b
 [<ffffffff81798b2c>] ? kernel_init+0x95/0x113
 [<ffffffff814a9154>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff81798a97>] ? start_kernel+0x32c/0x32c
 [<ffffffff814a9150>] ? gs_change+0xb/0xb
---[ end trace f96f3959e84427ea ]---
------------[ cut here ]------------
WARNING: at block/blk-core.c:345 blk_put_queue+0x22/0x2f()
Hardware name: 08946MG
Modules linked in:
Pid: 1, comm: swapper/0 Tainted: G        W    3.2.0-04874-ge4e1118-dirty #86
Call Trace:
 [<ffffffff81032f12>] ? warn_slowpath_common+0x78/0x8c
 [<ffffffff8120436b>] ? blk_put_queue+0x22/0x2f
 [<ffffffff8120a72a>] ? disk_release+0xa1/0xaf
 [<ffffffff812b99d9>] ? device_release+0x41/0x73
 [<ffffffff81214dae>] ? kobject_release+0x48/0x5e
 [<ffffffff817beb2f>] ? floppy_init+0xd81/0xd96
 [<ffffffff81490d0b>] ? register_cpu_notifier+0x25/0x2f
 [<ffffffff817bddae>] ? daring+0x67/0x67
 [<ffffffff810002e5>] ? do_one_initcall+0x78/0x12b
 [<ffffffff81798b2c>] ? kernel_init+0x95/0x113
 [<ffffffff814a9154>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff81798a97>] ? start_kernel+0x32c/0x32c
 [<ffffffff814a9150>] ? gs_change+0xb/0xb
---[ end trace f96f3959e84427eb ]---
------------[ cut here ]------------
WARNING: at block/blk-core.c:345 blk_put_queue+0x22/0x2f()
Hardware name: 08946MG
Modules linked in:
Pid: 1, comm: swapper/0 Tainted: G        W    3.2.0-04874-ge4e1118-dirty #86
Call Trace:
 [<ffffffff81032f12>] ? warn_slowpath_common+0x78/0x8c
 [<ffffffff8120436b>] ? blk_put_queue+0x22/0x2f
 [<ffffffff8120a72a>] ? disk_release+0xa1/0xaf
 [<ffffffff812b99d9>] ? device_release+0x41/0x73
 [<ffffffff81214dae>] ? kobject_release+0x48/0x5e
 [<ffffffff817beb2f>] ? floppy_init+0xd81/0xd96
 [<ffffffff81490d0b>] ? register_cpu_notifier+0x25/0x2f
 [<ffffffff817bddae>] ? daring+0x67/0x67
 [<ffffffff810002e5>] ? do_one_initcall+0x78/0x12b
 [<ffffffff81798b2c>] ? kernel_init+0x95/0x113
 [<ffffffff814a9154>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff81798a97>] ? start_kernel+0x32c/0x32c
 [<ffffffff814a9150>] ? gs_change+0xb/0xb
---[ end trace f96f3959e84427ec ]---
------------[ cut here ]------------
WARNING: at block/blk-core.c:345 blk_put_queue+0x22/0x2f()
Hardware name: 08946MG
Modules linked in:
Pid: 1, comm: swapper/0 Tainted: G        W    3.2.0-04874-ge4e1118-dirty #86
Call Trace:
 [<ffffffff81032f12>] ? warn_slowpath_common+0x78/0x8c
 [<ffffffff8120436b>] ? blk_put_queue+0x22/0x2f
 [<ffffffff8120a72a>] ? disk_release+0xa1/0xaf
 [<ffffffff812b99d9>] ? device_release+0x41/0x73
 [<ffffffff81214dae>] ? kobject_release+0x48/0x5e
 [<ffffffff817beb2f>] ? floppy_init+0xd81/0xd96
 [<ffffffff81490d0b>] ? register_cpu_notifier+0x25/0x2f
 [<ffffffff817bddae>] ? daring+0x67/0x67
 [<ffffffff810002e5>] ? do_one_initcall+0x78/0x12b
 [<ffffffff81798b2c>] ? kernel_init+0x95/0x113
 [<ffffffff814a9154>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff81798a97>] ? start_kernel+0x32c/0x32c
 [<ffffffff814a9150>] ? gs_change+0xb/0xb
---[ end trace f96f3959e84427ed ]---
------------[ cut here ]------------
WARNING: at block/blk-core.c:345 blk_put_queue+0x22/0x2f()
Hardware name: 08946MG
Modules linked in:
Pid: 1, comm: swapper/0 Tainted: G        W    3.2.0-04874-ge4e1118-dirty #86
Call Trace:
 [<ffffffff81032f12>] ? warn_slowpath_common+0x78/0x8c
 [<ffffffff8120436b>] ? blk_put_queue+0x22/0x2f
 [<ffffffff8120a72a>] ? disk_release+0xa1/0xaf
 [<ffffffff812b99d9>] ? device_release+0x41/0x73
 [<ffffffff81214dae>] ? kobject_release+0x48/0x5e
 [<ffffffff817beb2f>] ? floppy_init+0xd81/0xd96
 [<ffffffff81490d0b>] ? register_cpu_notifier+0x25/0x2f
 [<ffffffff817bddae>] ? daring+0x67/0x67
 [<ffffffff810002e5>] ? do_one_initcall+0x78/0x12b
 [<ffffffff81798b2c>] ? kernel_init+0x95/0x113
 [<ffffffff814a9154>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff81798a97>] ? start_kernel+0x32c/0x32c
 [<ffffffff814a9150>] ? gs_change+0xb/0xb
---[ end trace f96f3959e84427ee ]---
------------[ cut here ]------------
WARNING: at block/blk-core.c:345 blk_put_queue+0x22/0x2f()
Hardware name: 08946MG
Modules linked in:
Pid: 1, comm: swapper/0 Tainted: G        W    3.2.0-04874-ge4e1118-dirty #86
Call Trace:
 [<ffffffff81032f12>] ? warn_slowpath_common+0x78/0x8c
 [<ffffffff8120436b>] ? blk_put_queue+0x22/0x2f
 [<ffffffff8120a72a>] ? disk_release+0xa1/0xaf
 [<ffffffff812b99d9>] ? device_release+0x41/0x73
 [<ffffffff81214dae>] ? kobject_release+0x48/0x5e
 [<ffffffff817beb2f>] ? floppy_init+0xd81/0xd96
 [<ffffffff81490d0b>] ? register_cpu_notifier+0x25/0x2f
 [<ffffffff817bddae>] ? daring+0x67/0x67
 [<ffffffff810002e5>] ? do_one_initcall+0x78/0x12b
 [<ffffffff81798b2c>] ? kernel_init+0x95/0x113
 [<ffffffff814a9154>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff81798a97>] ? start_kernel+0x32c/0x32c
 [<ffffffff814a9150>] ? gs_change+0xb/0xb
---[ end trace f96f3959e84427ef ]---
------------[ cut here ]------------
WARNING: at block/blk-core.c:345 blk_put_queue+0x22/0x2f()
Hardware name: 08946MG
Modules linked in:
Pid: 1, comm: swapper/0 Tainted: G        W    3.2.0-04874-ge4e1118-dirty #86
Call Trace:
 [<ffffffff81032f12>] ? warn_slowpath_common+0x78/0x8c
 [<ffffffff8120436b>] ? blk_put_queue+0x22/0x2f
 [<ffffffff8120a72a>] ? disk_release+0xa1/0xaf
 [<ffffffff812b99d9>] ? device_release+0x41/0x73
 [<ffffffff81214dae>] ? kobject_release+0x48/0x5e
 [<ffffffff817beb2f>] ? floppy_init+0xd81/0xd96
 [<ffffffff81490d0b>] ? register_cpu_notifier+0x25/0x2f
 [<ffffffff817bddae>] ? daring+0x67/0x67
 [<ffffffff810002e5>] ? do_one_initcall+0x78/0x12b
 [<ffffffff81798b2c>] ? kernel_init+0x95/0x113
 [<ffffffff814a9154>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff81798a97>] ? start_kernel+0x32c/0x32c
 [<ffffffff814a9150>] ? gs_change+0xb/0xb
---[ end trace f96f3959e84427f0 ]---
=============================================================================
BUG blkdev_queue: Poison overwritten
-----------------------------------------------------------------------------

INFO: 0xffff88006ec18428-0xffff88006ec18428. First byte 0x6a instead of 0x6b
INFO: Allocated in blk_alloc_queue_node+0x1e/0x1a2 age=760 cpu=0 pid=1
	set_track+0x5e/0xd6
	alloc_debug_processing+0xbd/0x15e
	__slab_alloc.clone.34+0x3c2/0x402
	blk_alloc_queue_node+0x1e/0x1a2
	rb_insert_color+0xb1/0xd9
	rand_initialize_disk+0x1f/0x34
	kmem_cache_alloc_node+0x5a/0x153
	get_parent_ip+0x9/0x1b
	blk_alloc_queue_node+0x1e/0x1a2
	do_fd_request+0x0/0xa8
	blk_init_queue_node+0x1a/0x52
	alloc_disk_node+0xba/0xdd
	floppy_init+0x78/0xd96
	register_cpu_notifier+0x25/0x2f
	floppy_init+0x0/0xd96
	do_one_initcall+0x78/0x12b
INFO: Freed in kobject_release+0x48/0x5e age=0 cpu=0 pid=1
	set_track+0x5e/0xd6
	free_debug_processing+0x195/0x25b
	__slab_free+0x29/0x343
	add_preempt_count+0x9a/0x9c
	_raw_spin_lock_irqsave+0x16/0x37
	get_parent_ip+0x9/0x1b
	pcpu_free_area+0xae/0x124
	get_parent_ip+0x9/0x1b
	pcpu_free_area+0xfb/0x124
	pcpu_chunk_relocate+0xc/0x72
	kobject_release+0x48/0x5e
	kmem_cache_free+0x9b/0x111
	kobject_release+0x48/0x5e
	floppy_init+0xd71/0xd96
	register_cpu_notifier+0x25/0x2f
	floppy_init+0x0/0xd96
INFO: Slab 0xffffea0001bb0600 objects=15 used=15 fp=0x          (null) flags=0x100000000004080
INFO: Object 0xffff88006ec18000 @offset=0 fp=0xffff88006ec1f310

Object ffff88006ec18000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18020: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18030: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18040: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18050: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18060: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18070: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18080: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18090: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec180a0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec180b0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec180c0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec180d0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec180e0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec180f0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18100: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18110: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18120: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18130: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18140: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18150: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18160: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18170: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18180: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18190: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec181a0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec181b0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec181c0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec181d0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec181e0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec181f0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18200: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18210: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18220: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18230: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18240: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18250: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18260: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18270: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18280: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18290: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec182a0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec182b0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec182c0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec182d0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec182e0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec182f0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18300: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18310: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18320: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18330: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18340: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18350: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18360: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18370: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18380: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18390: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec183a0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec183b0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec183c0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec183d0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec183e0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec183f0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18400: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18410: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18420: 6b 6b 6b 6b 6b 6b 6b 6b 6a 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkjkkkkkkk
Object ffff88006ec18430: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18440: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18450: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18460: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18470: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18480: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18490: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec184a0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec184b0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec184c0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec184d0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec184e0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec184f0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18500: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18510: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18520: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18530: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18540: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18550: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18560: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18570: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18580: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18590: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec185a0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec185b0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec185c0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec185d0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec185e0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec185f0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18600: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18610: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18620: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18630: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18640: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18650: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18660: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18670: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18680: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec18690: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec186a0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec186b0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec186c0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec186d0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff88006ec186e0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5  kkkkkkkkkkkkkkk.
Redzone ffff88006ec186f0: bb bb bb bb bb bb bb bb                          ........
Padding ffff88006ec18830: 5a 5a 5a 5a 5a 5a 5a 5a                          ZZZZZZZZ
Pid: 1, comm: swapper/0 Tainted: G        W    3.2.0-04874-ge4e1118-dirty #86
Call Trace:
 [<ffffffff810e41fb>] ? check_bytes_and_report+0xad/0xe6
 [<ffffffff810e42ef>] ? check_object+0xbb/0x1f7
 [<ffffffff812041b5>] ? blk_alloc_queue_node+0x1e/0x1a2
 [<ffffffff810e5bd8>] ? alloc_debug_processing+0xa3/0x15e
 [<ffffffff810e6f74>] ? __slab_alloc.clone.34+0x3c2/0x402
 [<ffffffff812041b5>] ? blk_alloc_queue_node+0x1e/0x1a2
 [<ffffffff812cd126>] ? brd_alloc+0x2e/0x170
 [<ffffffff810e736e>] ? kmem_cache_alloc_node+0x5a/0x153
 [<ffffffff812041b5>] ? blk_alloc_queue_node+0x1e/0x1a2
 [<ffffffff812cd162>] ? brd_alloc+0x6a/0x170
 [<ffffffff817bec1f>] ? brd_init+0xbe/0x1b7
 [<ffffffff817beb61>] ? ramdisk_size+0x1d/0x1d
 [<ffffffff810002e5>] ? do_one_initcall+0x78/0x12b
 [<ffffffff81798b2c>] ? kernel_init+0x95/0x113
 [<ffffffff814a9154>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff81798a97>] ? start_kernel+0x32c/0x32c
 [<ffffffff814a9150>] ? gs_change+0xb/0xb
FIX blkdev_queue: Restoring 0xffff88006ec18428-0xffff88006ec18428=0x6b

FIX blkdev_queue: Marking all objects used
brd: module loaded
loop: module loaded
