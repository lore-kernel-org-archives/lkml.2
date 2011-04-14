Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab1DNUz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 16:55:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751281Ab1DNUzZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 16:55:25 -0400
MIME-Version: 1.0
In-Reply-To: <20110414202445.GA6173@liondog.tnic>
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com> <20110414202445.GA6173@liondog.tnic>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 14 Apr 2011 13:55:02 -0700
Message-ID: <BANLkTi=h+NL+qqMDBNvOUmVDonORf4Qx2A@mail.gmail.com>
Subject: Re: Linux 2.6.39-rc3
To: Borislav Petkov <bp@alien8.de>, Jens Axboe <jaxboe@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 1:24 PM, Borislav Petkov <bp@alien8.de> wrote:
>
> Yep, I had to hit a buglet too. Looks like block layer, ->request_fn
> (do_ide_request) called in IRQ disabled region. Process is blkid, i.e.
> some udev helper. Kernel is -rc3 + Joerg's USB quirk fix which should be
> unrelated.

I think this particular backtrace should be fixed by commit
6631e635c65d ("block: don't flush plugged IO on forced preemtion
scheduling"), although even without preempt scheduling, I don't think
it's at all ok to sleep inside __blk_run_queue.

Jens? Even from a _regular_ schedule, it would not be ok if we end up
sleeping - we're caching things like the request-queue, and we have
preempt_disable() inside the scheduler for a very good reason.

So if the unplugging can cause sleeping, that's a problem. See the

        /* HLD do_request() callback might sleep, make sure it's okay */
        might_sleep();

comment in drivers/ide/ide-io.c. Hmm?

                    Linus

---
> Happens when I put a cd in the drive. More info upon request.
>
> [20933.365059] BUG: sleeping function called from invalid context at drivers/ide/ide-io.c:468
> [20933.365113] in_atomic(): 1, irqs_disabled(): 0, pid: 5817, name: blkid
> [20933.365166] no locks held by blkid/5817.
> [20933.365193] Pid: 5817, comm: blkid Not tainted 2.6.39-rc3-00001-g1b521ee #9
> [20933.365228] Call Trace:
> [20933.365282]  [<ffffffff8102db2b>] __might_sleep+0x103/0x108
> [20933.365312]  [<ffffffff812e61c8>] do_ide_request+0x4a/0x58e
> [20933.365362]  [<ffffffff811951af>] ? cfq_prio_tree_add+0xb3/0xc2
> [20933.365390]  [<ffffffff811974f3>] ? cfq_add_rq_rb+0xb1/0xc5
> [20933.365437]  [<ffffffff81197579>] ? cfq_insert_request+0x72/0x433
> [20933.365465]  [<ffffffff81187fd8>] __blk_run_queue+0x80/0xee
> [20933.365511]  [<ffffffff81188141>] flush_plug_list+0xfb/0x139
> [20933.365540]  [<ffffffff810a9a86>] ? sleep_on_page+0x12/0x12
> [20933.365586]  [<ffffffff81188199>] __blk_flush_plug+0x1a/0x3a
> [20933.365613]  [<ffffffff81442913>] schedule+0x3d2/0xb4b
> [20933.365663]  [<ffffffff811a2cee>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [20933.365692]  [<ffffffff8100387f>] ? do_softirq+0x77/0x85
> [20933.365739]  [<ffffffff81446244>] ? retint_restore_args+0xe/0xe
> [20933.365767]  [<ffffffff810a9a86>] ? sleep_on_page+0x12/0x12
> [20933.365812]  [<ffffffff81443377>] preempt_schedule+0x37/0x4b
> [20933.365839]  [<ffffffff81445f92>] _raw_spin_unlock_irqrestore+0x64/0x69
> [20933.365878]  [<ffffffff81057b3b>] prepare_to_wait_exclusive+0x6c/0x77
> [20933.365925]  [<ffffffff81443806>] __wait_on_bit_lock+0x34/0x8f
> [20933.365953]  [<ffffffff810a9a00>] __lock_page_killable+0x66/0x6d
> [20933.366000]  [<ffffffff810579a1>] ? autoremove_wake_function+0x3d/0x3d
> [20933.366090]  [<ffffffff810ab56d>] generic_file_aio_read+0x491/0x67c
> [20933.366123]  [<ffffffff810e8137>] do_sync_read+0xcb/0x108
> [20933.366183]  [<ffffffff81068f4d>] ? trace_hardirqs_on+0xd/0xf
> [20933.366217]  [<ffffffff810e8bce>] vfs_read+0xb3/0x13b
> [20933.366270]  [<ffffffff810e8d1f>] sys_read+0x4d/0x77
> [20933.366303]  [<ffffffff81446aeb>] system_call_fastpath+0x16/0x1b
>
> Thanks.
>
> --
> Regards/Gruss,
>    Boris.
>
