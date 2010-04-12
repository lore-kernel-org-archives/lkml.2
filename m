Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab0DLSo7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 14:44:59 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59922 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab0DLSo5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 14:44:57 -0400
MIME-Version: 1.0
In-Reply-To: <20100311032843.GE6767@linux.vnet.ibm.com>
References: <a44ae5cd1003071726u1f94336h7ab6c7b80d16723b@mail.gmail.com>
	 <20100311032843.GE6767@linux.vnet.ibm.com>
Date: Mon, 12 Apr 2010 14:44:56 -0400
Message-ID: <q2x7e0fb38c1004121144rb097e521hd2a7d8cea77c54b7@mail.gmail.com>
Subject: Re: INFO: suspicious rcu_dereference_check() usage - 
	include/linux/cgroup.h:492 invoked rcu_dereference_check() without 
	protection!
From: Eric Paris <eparis@parisplace.org>
To: paulmck@linux.vnet.ibm.com
Cc: Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 11:28 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Sun, Mar 07, 2010 at 08:26:53PM -0500, Miles Lane wrote:
>> [    0.000000] Memory: 4004344k/5242880k available (5147k kernel code,
>> 1084452k absent, 154084k reserved, 5943k data, 520k init)
>> [    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0,
>> CPUs=2, Nodes=1
>> [    0.000000]
>> [    0.000000] ===================================================
>> [    0.000000] [ INFO: suspicious rcu_dereference_check() usage. ]
>> [    0.000000] ---------------------------------------------------
>> [    0.000000] include/linux/cgroup.h:492 invoked
>> rcu_dereference_check() without protection!
>
> Hello, Miles,
>
> This one is a false positive that is addressed by a set of boot-time
> fixes that have recently gone into mainline, this series of commits:
>
>        c598a070..71da8132
>
>                                                        Thanx, Paul

I know you indicated this was fixed in mainline and I see that set of
commits objects, but I'm seeing the below spew from linux-next today.

tree: git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
tag: next-20100412
commit: bbeecf185fe464ccd7ee97ce6d3646ad686995b4

[    0.035602] ===================================================
[    0.036003] [ INFO: suspicious rcu_dereference_check() usage. ]
[    0.037006] ---------------------------------------------------
[    0.038004] include/linux/cgroup.h:533 invoked
rcu_dereference_check() without protection!
[    0.039003]
[    0.039004] other info that might help us debug this:
[    0.039004]
[    0.040003]
[    0.040004] rcu_scheduler_active = 1, debug_locks = 0
[    0.041004] no locks held by swapper/0.
[    0.042003]
[    0.042004] stack backtrace:
[    0.043005] Pid: 0, comm: swapper Not tainted 2.6.34-rc3-next-20100412+ #65
[    0.044003] Call Trace:
[    0.045015]  [<ffffffff8108584f>] lockdep_rcu_dereference+0xaf/0xc0
[    0.046010]  [<ffffffff81044812>] set_task_cpu+0x2d2/0x370
[    0.047009]  [<ffffffff814dfef5>] ? _raw_spin_unlock_irqrestore+0x65/0x80
[    0.048006]  [<ffffffff81087aa0>] ? trace_hardirqs_on_caller+0x120/0x1a0
[    0.049006]  [<ffffffff81087b2d>] ? trace_hardirqs_on+0xd/0x10
[    0.050006]  [<ffffffff814dfed9>] ? _raw_spin_unlock_irqrestore+0x49/0x80
[    0.051005]  [<ffffffff8104a7a6>] ? task_fork_fair+0xc6/0x390
[    0.052005]  [<ffffffff810497b4>] sched_fork+0x74/0x170
[    0.053006]  [<ffffffff81054a3f>] copy_process+0x62f/0x11e0
[    0.054006]  [<ffffffff810882bd>] ? validate_chain+0x4fd/0x1360
[    0.055005]  [<ffffffff810556ae>] do_fork+0xbe/0x3e0
[    0.056008]  [<ffffffff81012519>] ? sched_clock+0x9/0x10
[    0.057008]  [<ffffffff81077485>] ? sched_clock_local+0x15/0x80
[    0.058005]  [<ffffffff810775ab>] ? sched_clock_cpu+0xbb/0xf0
[    0.059005]  [<ffffffff81076415>] ? up+0x35/0x50
[    0.060005]  [<ffffffff81083623>] ? get_lock_stats+0x23/0x70
[    0.061005]  [<ffffffff8108367e>] ? put_lock_stats+0xe/0x30
[    0.062011]  [<ffffffff81aa6e20>] ? kernel_init+0x0/0x2e0
[    0.063007]  [<ffffffff810136dd>] kernel_thread+0x8d/0xa0
[    0.064007]  [<ffffffff81aa6e20>] ? kernel_init+0x0/0x2e0
[    0.065009]  [<ffffffff8100bc20>] ? kernel_thread_helper+0x0/0x10
[    0.066006]  [<ffffffff81aa6140>] ? early_idt_handler+0x0/0x71
[    0.067006]  [<ffffffff814c5cf1>] rest_init+0x21/0x110
[    0.068006]  [<ffffffff81aa6d3f>] start_kernel+0x3af/0x490
[    0.069006]  [<ffffffff81aa629c>] x86_64_start_reservations+0x7c/0xd0
[    0.070006]  [<ffffffff81aa6000>] ? early_idt_handlers+0x0/0x140
[    0.071006]  [<ffffffff81aa63e8>] x86_64_start_kernel+0xf8/0x130
