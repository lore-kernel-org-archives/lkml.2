Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab0JWRRN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 13:17:13 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:43639 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751Ab0JWRRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 13:17:12 -0400
Message-ID: <4CC318AE.8010209@fusionio.com>
Date: Sat, 23 Oct 2010 19:17:34 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [origin tree boot failure] Re: [GIT PULL] core block bits for
  2.6.37-rc1
References: <4CC143F5.3060202@fusionio.com> <20101023152959.GA20930@elte.hu> <4CC31283.1060607@fusionio.com>
In-Reply-To: <4CC31283.1060607@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-23 18:51, Jens Axboe wrote:
> On 2010-10-23 17:29, Ingo Molnar wrote:
>>
>> Hi,
>>
>> * Jens Axboe <jaxboe@fusionio.com> wrote:
>>
>>> Hi Linus,
>>>
>>> This first pull request is the core bits, meaning general
>>> block layer changes or core support. Should be clean this time,
>>> only 'weird bit' is the seemingly duplicate entry from Malahal.
>>> This is caused by the first patch being buggy (and later
>>> reverted), second patch used the same single line description.
>>>
>>> Nothing really exciting in here. A good collection of fixes, some of
>>> which are marked for stable as well.
>>>
>>> The biggest addition this time around is the block IO throttling support
>>> from Vivek.
>>
>> The upstream block bits pulled in this merge window (or maybe the workqueue bits) 
>> are possibly the cause a boot crash on today's -tip, using a trivial x86 bootup test 
>> (64-bit allyesconfig):
>>
>> [  116.064281] calling  hd_init+0x0/0x302 @ 1
>> [  116.068529] hd: no drives specified - use hd=cyl,head,sectors on kernel command line
>> [  116.076334] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
>> [  116.080274] last sysfs file: 
>> [  116.080274] CPU 0 
>> [  116.080274] Modules linked in:
>> [  116.080274] 
>> [  116.080274] Pid: 1, comm: swapper Tainted: G        W   2.6.36-tip-03555-g825d9ec-dirty #51843 A8N-E/System Product Name
>> [  116.080274] RIP: 0010:[<ffffffff81064380>]  [<ffffffff81064380>] __ticket_spin_trylock+0x4/0x21
>> [  116.080274] RSP: 0018:ffff88003c417c10  EFLAGS: 00010082
>> [  116.080274] RAX: ffff88003c418000 RBX: 6b6b6b6b6b6b6b6a RCX: 0000000000000000
>> [  116.080274] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 6b6b6b6b6b6b6b6a
>> [  116.080274] RBP: ffff88003c417c10 R08: 0000000000000002 R09: 0000000000000001
>> [  116.080274] R10: 0000000000000286 R11: ffff880032498738 R12: 6b6b6b6b6b6b6b82
>> [  116.080274] R13: 0000000000000286 R14: 6b6b6b6b6b6b6b6b R15: 0000000000000001
>> [  116.080274] FS:  0000000000000000(0000) GS:ffff88003e200000(0000) knlGS:0000000000000000
>> [  116.080274] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> [  116.080274] CR2: 0000000000000000 CR3: 0000000004071000 CR4: 00000000000006f0
>> [  116.080274] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> [  116.080274] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> [  116.080274] Process swapper (pid: 1, threadinfo ffff88003c416000, task ffff88003c418000)
>> [  116.080274] Stack:
>> [  116.080274]  ffff88003c417c30 ffffffff8168c6ee 6b6b6b6b6b6b6b6b 6b6b6b6b6b6b6b6a
>> [  116.080274] <0> ffff88003c417c70 ffffffff82d37a20 ffffffff810a1b65 ffff88003c418000
>> [  116.080274] <0> ffffffff82d3836b 6b6b6b6b6b6b6b6a ffff8800330fcc20 ffff88003c417cb8
>> [  116.080274] Call Trace:
>> [  116.080274]  [<ffffffff8168c6ee>] do_raw_spin_trylock+0x1f/0x41
>> [  116.080274]  [<ffffffff82d37a20>] _raw_spin_lock_irqsave+0x72/0xa4
>> [  116.080274]  [<ffffffff810a1b65>] ? lock_timer_base+0x2c/0x52
>> [  116.080274]  [<ffffffff82d3836b>] ? _raw_spin_unlock_irqrestore+0x55/0x72
>> [  116.080274]  [<ffffffff810a1b65>] lock_timer_base+0x2c/0x52
>> [  116.080274]  [<ffffffff810a1c43>] del_timer+0x2f/0x82
>> [  116.080274]  [<ffffffff810ac906>] ? wait_on_work+0x0/0xdb
>> [  116.080274]  [<ffffffff810aca18>] __cancel_work_timer+0x37/0x130
>> [  116.080274]  [<ffffffff810acb23>] cancel_delayed_work_sync+0x12/0x14
>> [  116.080274]  [<ffffffff8166974a>] throtl_shutdown_timer_wq+0x1c/0x1e
>> [  116.080274]  [<ffffffff8165dbec>] blk_sync_queue+0x3d/0x41
>> [  116.080274]  [<ffffffff8165f872>] blk_release_queue+0x1e/0x6a
>> [  116.080274]  [<ffffffff81673ce3>] kobject_release+0xf4/0x122
>> [  116.080274]  [<ffffffff81673bef>] ? kobject_release+0x0/0x122
>> [  116.080274]  [<ffffffff81674e7e>] kref_put+0x43/0x4d
>> [  116.080274]  [<ffffffff81673b46>] kobject_put+0x47/0x4c
>> [  116.080274]  [<ffffffff8165dc53>] blk_cleanup_queue+0x63/0x68
>> [  116.080274]  [<ffffffff84883c80>] ? hd_init+0x0/0x302
>> [  116.080274]  [<ffffffff84883f54>] hd_init+0x2d4/0x302
>> [  116.080274]  [<ffffffff81910778>] ? device_pm_unlock+0x15/0x17
>> [  116.080274]  [<ffffffff84883c80>] ? hd_init+0x0/0x302
>> [  116.080274]  [<ffffffff81002062>] do_one_initcall+0x57/0x15a
>> [  116.080274]  [<ffffffff8482f78b>] kernel_init+0x194/0x222
>> [  116.080274]  [<ffffffff8103ad04>] kernel_thread_helper+0x4/0x10
>> [  116.080274]  [<ffffffff82d38710>] ? restore_args+0x0/0x30
>> [  116.080274]  [<ffffffff8482f5f7>] ? kernel_init+0x0/0x222
>> [  116.080274]  [<ffffffff8103ad00>] ? kernel_thread_helper+0x0/0x10
>> [  116.080274] Code: ff ff c9 c3 90 90 90 55 b8 00 00 01 00 48 89 e5 f0 0f c1 07 0f b7 d0 c1 e8 10 39 c2 74 07 f3 90 0f b7 17 eb f5 c9 c3 55 48 89 e5 <8b> 07 89 c2 c1 c0 10 39 c2 8d 90 00 00 01 00 75 04 f0 0f b1 17 
> 
> Looks like a fairly straight forward case of uninitialized memory and
> blk_sync_queue() -> throtl_shutdown_timer() ->
> cancel_delayed_work_sync().
> 
> Will get that fixed up.

It frees q->td in blk_cleanup_queue(), but doesn't clear q->td. When the
final put happens, blk_sync_queue() is called and then ends up doing the
cancel_delayed_work_sync() on freed memory.

Two possible fixes:

- Clear ->td when the queue is goin dead. May require other ->td == NULL
  checks in the code, so I opted for:

- Move the free to when the queue is really going away, post doing the
  blk_sync_queue() call.

The below should fix it.

Signed-off-by: Jens Axboe <jaxboe@fusionio.com>

diff --git a/block/blk-core.c b/block/blk-core.c
index 4514146..51efd83 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -462,8 +462,6 @@ void blk_cleanup_queue(struct request_queue *q)
 	if (q->elevator)
 		elevator_exit(q->elevator);
 
-	blk_throtl_exit(q);
-
 	blk_put_queue(q);
 }
 EXPORT_SYMBOL(blk_cleanup_queue);
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index da8a8a4..013457f 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -471,6 +471,8 @@ static void blk_release_queue(struct kobject *kobj)
 
 	blk_sync_queue(q);
 
+	blk_throtl_exit(q);
+
 	if (rl->rq_pool)
 		mempool_destroy(rl->rq_pool);
 


-- 
Jens Axboe

