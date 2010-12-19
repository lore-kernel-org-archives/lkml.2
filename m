Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494Ab0LSUqj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 15:46:39 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932471Ab0LSUqi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 15:46:38 -0500
MIME-Version: 1.0
In-Reply-To: <20101219152713.GA20101@elte.hu>
References: <20101219152713.GA20101@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 19 Dec 2010 12:45:43 -0800
Message-ID: <AANLkTinJ8hAG1TpyC+CSYPR47p48+1=E7fiC45hMXT_1@mail.gmail.com>
Subject: Re: [GIT PULL] scheduler fixes
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 19, 2010 at 7:27 AM, Ingo Molnar <mingo@elte.hu> wrote:
> @@ -3943,6 +4128,7 @@ need_resched_nonpreemptible:
>                rq->nr_switches++;
>                rq->curr = next;
>                ++*switch_count;
> +               WARN_ON_ONCE(test_tsk_need_resched(next));
>
>                context_switch(rq, prev, next); /* unlocks the rq */
>                /*
> diff --git a/kernel/timer.c b/kern

Please don't add like this in an -rc. It looks like it's some
debugging aid, I don't think it should have gone in now.

And yes, it triggers for me.

                             Linus

[ 1321.625764] ------------[ cut here ]------------
[ 1321.625773] WARNING: at kernel/sched.c:4131 schedule+0x5d1/0x978()
[ 1321.625774] Hardware name: System Product Name
[ 1321.625776] Modules linked in: [last unloaded: scsi_wait_scan]
[ 1321.625779] Pid: 3630, comm: chrome Not tainted 2.6.37-rc6-00132-g55ec86f #56
[ 1321.625781] Call Trace:
[ 1321.625787]  [<ffffffff810385c5>] warn_slowpath_common+0x80/0x98
[ 1321.625790]  [<ffffffff810385f2>] warn_slowpath_null+0x15/0x17
[ 1321.625792]  [<ffffffff8153b2ed>] schedule+0x5d1/0x978
[ 1321.625795]  [<ffffffff810324d0>] ? sub_preempt_count+0x92/0xa5
[ 1321.625798]  [<ffffffff8153e0aa>] ? _raw_spin_unlock_irqrestore+0x46/0x64
[ 1321.625802]  [<ffffffff810536fe>] ? __hrtimer_start_range_ns+0x328/0x33a
[ 1321.625805]  [<ffffffff8153cb6c>] schedule_hrtimeout_range_clock+0xc8/0xfa
[ 1321.625808]  [<ffffffff81052f0a>] ? hrtimer_wakeup+0x0/0x21
[ 1321.625810]  [<ffffffff81050497>] ? add_wait_queue+0x3f/0x44
[ 1321.625812]  [<ffffffff8153cbac>] schedule_hrtimeout_range+0xe/0x10
[ 1321.625816]  [<ffffffff810cc3b0>] poll_schedule_timeout+0x43/0x5f
[ 1321.625818]  [<ffffffff810cd65f>] do_sys_poll+0x351/0x3e8
[ 1321.625820]  [<ffffffff810cc45b>] ? __pollwait+0x0/0xc7
[ 1321.625822]  [<ffffffff810cc522>] ? pollwake+0x0/0x4f
[ 1321.625824]  [<ffffffff810cc522>] ? pollwake+0x0/0x4f
[ 1321.625827]  [<ffffffff810cc522>] ? pollwake+0x0/0x4f
[ 1321.625829]  [<ffffffff8103240e>] ? get_parent_ip+0x11/0x41
[ 1321.625832]  [<ffffffff811e7000>] ? sys_semtimedop+0x8bc/0x972
[ 1321.625834]  [<ffffffff811e704c>] ? sys_semtimedop+0x908/0x972
[ 1321.625838]  [<ffffffff81462299>] ? sock_aio_read+0x123/0x13b
[ 1321.625842]  [<ffffffff8103d001>] ? timespec_add_safe+0x32/0x61
[ 1321.625844]  [<ffffffff810cc6c2>] ? poll_select_set_timeout+0x61/0x75
[ 1321.625847]  [<ffffffff810cd793>] sys_poll+0x50/0xba
[ 1321.625851]  [<ffffffff81001ffb>] system_call_fastpath+0x16/0x1b
[ 1321.625853] ---[ end trace 3ba46a028c3b4324 ]---
