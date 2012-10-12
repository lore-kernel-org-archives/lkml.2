Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760003Ab2JLRzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 13:55:25 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47999 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757703Ab2JLRzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 13:55:23 -0400
MIME-Version: 1.0
In-Reply-To: <1349884374.6336.67.camel@deadeye.wl.decadent.org.uk>
References: <505E2108.2060108@gmail.com> <CA+1xoqc1Bc1rPgH+9Xs9-BV7qp3N7mDpNLj1mPwZHdF=H4mHTg@mail.gmail.com>
 <20121008172207.GB14767@quack.suse.cz> <alpine.LNX.2.00.1210082340501.19980@pobox.suse.cz>
 <507424F7.60801@gmail.com> <50742600.10606@gmail.com> <1349884374.6336.67.camel@deadeye.wl.decadent.org.uk>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Fri, 12 Oct 2012 13:55:01 -0400
Message-ID: <CA+1xoqcGN1xYP5-N17eZQ=F_JTG-8gr43DAxREa-Wf+n8=P7Og@mail.gmail.com>
Subject: Re: blk: NULL ptr deref in blk_dequeue_request()
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Jiri Kosina <jkosina@suse.cz>, Jan Kara <jack@suse.cz>,
        Tejun Heo <tj@kernel.org>, axboe@kernel.dk,
        Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Wed, Oct 10, 2012 at 11:52 AM, Ben Hutchings <ben@decadent.org.uk> wrote:
> On Tue, 2012-10-09 at 09:26 -0400, Sasha Levin wrote:
>> On 10/09/2012 09:21 AM, Sasha Levin wrote:
>> > On 10/08/2012 05:45 PM, Jiri Kosina wrote:
>> >> On Mon, 8 Oct 2012, Jan Kara wrote:
>> >>
>> >>>>>> I'm still seeing this on linux-next.
>> >>>>   I think this is floppy related (see redo_fd_request() in the stack
>> >>>> trace). And there were quite some changes to the area recently. Adding
>> >>>> maintainer to CC.
>> >> Hmm ... I don't immediately see how this is happening.
>> >>
>> >> Sasha, could you please do git bisect on drivers/block/floppy.c between
>> >> f6365201d and your git HEAD for starters (assuming that f6365201d works
>> >> well for you?).
>> >>
>> >
>> > A bisect on floppy.c yielded the following:
>> >
>> > b33d002f4b6bae912463e5a66387c498aa69b6fe is the first bad commit
>> > commit b33d002f4b6bae912463e5a66387c498aa69b6fe
>> > Author: Ben Hutchings <ben@decadent.org.uk>
>> > Date:   Mon Aug 27 20:56:53 2012 -0300
>> >
>> >     genhd: Make put_disk() safe for disks that have not been registered
>>
>> 2 more things:
>>
>>  1. The guest vm which I'm testing on doesn't emulate anything which even looks like a floppy.
>>  2. I'm seeing the following lines before the BUG:
>>
>> [    9.836604] floppy0: no floppy controllers found
>> [    9.837246] work still pending
>> [    9.837743] floppy0: floppy_shutdown: timeout handler died.
>
> I see two problems:
>
> 1. redo_fd_request() races with tear-down of the disks, but because
> set_next_request() checks disk->queue before doing anything this was
> usually harmless.  Now that do_floppy_init() doesn't clear disk->queue,
> the race condition is much easier to hit.  This may fix that problem in
> do_floppy_init(), though there appear to be worse bugs in tear-down
> order in floppy_module_exit():
>
> --- a/drivers/block/floppy.c
> +++ b/drivers/block/floppy.c
> @@ -4320,13 +4320,13 @@ out_unreg_region:
>  out_unreg_blkdev:
>         unregister_blkdev(FLOPPY_MAJOR, "fd");
>  out_put_disk:
> +       destroy_workqueue(floppy_wq);
>         while (dr--) {
>                 del_timer_sync(&motor_off_timer[dr]);
>                 if (disks[dr]->queue)
>                         blk_cleanup_queue(disks[dr]->queue);
>                 put_disk(disks[dr]);
>         }
> -       destroy_workqueue(floppy_wq);
>         return err;
>  }
>
> --- END ---
>
> 2. I made a big mistake in using the existing GENHD_FL_UP flag, as it is
> cleared by del_gendisk().  Incremental patch below, but it should be
> squashed into the previous patch if that branch is still rebase-able.
>
> Ben.
>
> ---
> From: Ben Hutchings <ben@decadent.org.uk>
> Date: Wed, 10 Oct 2012 16:17:01 +0100
> Subject: [PATCH] genhd: Make put_disk() safe again for disks that *have* been
>  registered
>
> Commit b33d002 ('genhd: Make put_disk() safe for disks that have not
> been registered') wrongly used the GENHD_FL_UP flag to test whether a
> disk held a reference to its queue.  Since this is cleared by
> del_gendisk(), queues will not be properly cleaned up if a disk has
> been registered and then torn down in the normal way.  Introduce a
> new flag for this purpose.
>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  block/genhd.c         |    7 +++++--
>  include/linux/genhd.h |    1 +
>  2 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/block/genhd.c b/block/genhd.c
> index 633751d..b5f482f 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -617,7 +617,10 @@ void add_disk(struct gendisk *disk)
>          * Take an extra ref on queue which will be put on disk_release()
>          * so that it sticks around as long as @disk is there.
>          */
> -       WARN_ON_ONCE(!blk_get_queue(disk->queue));
> +       if (blk_get_queue(disk->queue))
> +               disk->flags |= GENHD_FL_GOT_QUEUE;
> +       else
> +               WARN_ON(1);
>
>         retval = sysfs_create_link(&disk_to_dev(disk)->kobj, &bdi->dev->kobj,
>                                    "bdi");
> @@ -1105,7 +1108,7 @@ static void disk_release(struct device *dev)
>         disk_replace_part_tbl(disk, NULL);
>         free_part_stats(&disk->part0);
>         free_part_info(&disk->part0);
> -       if (disk->queue && disk->flags & GENHD_FL_UP)
> +       if (disk->queue && disk->flags & GENHD_FL_GOT_QUEUE)
>                 blk_put_queue(disk->queue);
>         kfree(disk);
>  }
> diff --git a/include/linux/genhd.h b/include/linux/genhd.h
> index 4f440b3..7c2560c 100644
> --- a/include/linux/genhd.h
> +++ b/include/linux/genhd.h
> @@ -134,6 +134,7 @@ struct hd_struct {
>  #define GENHD_FL_NATIVE_CAPACITY               128
>  #define GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE    256
>  #define GENHD_FL_NO_PART_SCAN                  512
> +#define GENHD_FL_GOT_QUEUE                     1024
>
>  enum {
>         DISK_EVENT_MEDIA_CHANGE                 = 1 << 0, /* media changed */

I'm now seeing these instead:

[   34.823972] general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[   34.830888] Dumping ftrace buffer:
[   34.830888]    (ftrace buffer empty)
[   34.830888] CPU 5
[   34.830888] Pid: 6, comm: kworker/u:0 Tainted: G        W
3.6.0-next-20121012-sasha-00002-gae01a05-dirty #650
[   34.830888] RIP: 0010:[<ffffffff8112dfe8>]  [<ffffffff8112dfe8>]
flush_workqueue_prep_cwqs+0xf8/0x260
[   34.830888] RSP: 0000:ffff8801bf059a58  EFLAGS: 00010287
[   34.830888] RAX: 0000000000000000 RBX: ffff100b833d8000 RCX: 0000000000000000
[   34.830888] RDX: 0000000000000000 RSI: 0000000000000078 RDI: 0000000000000078
[   34.830888] RBP: ffff8801bf059aa8 R08: ffffffff858bb800 R09: 0000000000000000
[   34.830888] R10: 2222222222222222 R11: 0000000000000078 R12: ffff8809c1610600
[   34.830888] R13: 0000000000000003 R14: 0000000000000000 R15: 0000000000000002
[   34.830888] FS:  0000000000000000(0000) GS:ffff8809c4000000(0000)
knlGS:0000000000000000
[   34.830888] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   34.830888] CR2: 00000000ffffffff CR3: 0000000004e25000 CR4: 00000000000006e0
[   34.830888] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   34.830888] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   34.830888] Process kworker/u:0 (pid: 6, threadinfo
ffff8801bf058000, task ffff8801bf053000)
[   34.830888] Stack:
[   34.830888]  ffff8801bf059a88 00ff8809c1610620 0000000000000006
ffff8809c16106d0
[   34.830888]  ffffffff8480a53f ffff8809c1610600 ffff8801bf059ae8
0000000000000003
[   34.830888]  ffff8809c16106f0 ffff8809c1610620 ffff8801bf059c08
ffffffff8112e3ba
[   34.830888] Call Trace:
[   34.830888]  [<ffffffff8112e3ba>] flush_workqueue+0x26a/0x5c0
[   34.991665]  [<ffffffff8112e150>] ? flush_workqueue_prep_cwqs+0x260/0x260
[   34.991665]  [<ffffffff8112f9c0>] drain_workqueue+0x70/0x270
[   34.991665]  [<ffffffff819d1a25>] ? kobject_cleanup+0x145/0x190
[   34.991665]  [<ffffffff8112fbd3>] destroy_workqueue+0x13/0x200
[   34.991665]  [<ffffffff85b038dc>] do_floppy_init+0x672/0x70c
[   34.991665]  [<ffffffff85b0397f>] floppy_async_init+0x9/0xb
[   34.991665]  [<ffffffff81143f5b>] async_run_entry_fn+0xab/0x180
[   34.991665]  [<ffffffff8112ec46>] process_one_work+0x386/0x570
[   34.991665]  [<ffffffff8112eb18>] ? process_one_work+0x258/0x570
[   34.991665]  [<ffffffff81143eb0>] ? async_schedule+0x20/0x20
[   34.991665]  [<ffffffff8113062a>] worker_thread+0x20a/0x340
[   34.991665]  [<ffffffff81130420>] ? manage_workers+0x160/0x160
[   34.991665]  [<ffffffff81139c52>] kthread+0xe2/0xf0
[   34.991665]  [<ffffffff8118386a>] ? __lock_release+0x1ba/0x1d0
[   34.991665]  [<ffffffff81139b70>] ? __init_kthread_worker+0x70/0x70
[   34.991665]  [<ffffffff83a645bc>] ret_from_fork+0x7c/0x90
[   34.991665]  [<ffffffff81139b70>] ? __init_kthread_worker+0x70/0x70
[   34.991665] Code: 5c 24 08 44 89 f0 48 03 1c c5 00 13 8b 85 eb 1b
0f 1f 00 41 81 fe 00 10 00 00 75 07 49 8b 5c 24 08 eb 08 31 db 66 0f
1f 44 00 00 <48> 8b 03 48 8b 08 48 89 cf 48 89 4d b0 e8 46 4c 93 02 45
85 ff
[   34.991665] RIP  [<ffffffff8112dfe8>] flush_workqueue_prep_cwqs+0xf8/0x260
[   34.991665]  RSP <ffff8801bf059a58>
[   35.151058] ---[ end trace 48a38e4c9e8f037d ]---
