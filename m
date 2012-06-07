Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab2FGTh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 15:37:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832Ab2FGThz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 15:37:55 -0400
Date: Thu, 7 Jun 2012 21:37:47 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Zhouping Liu <zliu@redhat.com>
Cc: Hillf Danton <dhillf@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: AutoNUMA15
Message-ID: <20120607193747.GH21339@redhat.com>
References: <CAJd=RBAQiKC1Np7qzNrD1AEXcoPwfSLwTh9ZjUkvAb7F6eUX9A@mail.gmail.com>
 <097fc79d-1e82-4633-8cf0-c47612e5f729@zmail13.collab.prod.int.phx2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <097fc79d-1e82-4633-8cf0-c47612e5f729@zmail13.collab.prod.int.phx2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 10:08:52AM -0400, Zhouping Liu wrote:
> > On Thu, Jun 7, 2012 at 10:30 AM, Zhouping Liu <zliu@redhat.com>
> > wrote:
> > >
> > > [    3.114024] ---[ end trace e696d6ddf3adb276 ]---
> > > [    3.121541] swapper/0 used greatest stack depth: 4768 bytes left
> > > [    3.143784] Kernel panic - not syncing: Attempted to kill init!
> > > exitcode=0x0000000b
> > > [    3.143784]
> > >
> > > such above errors occurred in my two boxes:
> > > in one machine, which has 120Gb RAM and 8 numa nodes with AMD CPU,
> > > kernel
> > > panic occurred in autonuma15 and Linus tree(3.5.0-rc1)
> > > but in another one, which has 16Gb RAM and 4 numa nodes with AMD
> > > CPU, kernel
> > > panic only occurred in autonuma15, no such issues in Linus tree,
> > >
> > Related to fix at https://lkml.org/lkml/2012/6/5/31  ?
> >
> 
> hi, Hillf
> 
> Thanks! but the Linus tree I tested has contained the patch,
> also I tested it in autunuma15 with the patch just now, and
> the panic is still alive, so maybe it's a new issues...

I guess this 74a5ce20e6eeeb3751340b390e7ac1d1d07bbf55 or this
8e7fbcbc22c12414bcc9dfdd683637f58fb32759 may have introduced a problem
with sgp->power being null.

After applying the zalloc_node it oopses in a different place here:

	/* Adjust by relative CPU power of the group */
	sgs->avg_load = (sgs->group_load*SCHED_POWER_SCALE) / group->sgp->power;

power is zero.

[    3.243773] divide error: 0000 [#1] SMP
[    3.244564] CPU 5
[    3.245016] Modules linked in:
[    3.245642]
[    3.245939] Pid: 0, comm: swapper/5 Not tainted 3.5.0-rc1+ #1 HP ProLiant DL785 G6   
[    3.247640] RIP: 0010:[<ffffffff810afbeb>]  [<ffffffff810afbeb>] update_sd_lb_stats+0x27b/0x620
[    3.249534] RSP: 0000:ffff880411207b48  EFLAGS: 00010056
[    3.250636] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff880811496d00
[    3.252174] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8818116a0548
[    3.253509] RBP: ffff880411207c28 R08: 0000000000000000 R09: 0000000000000000
[    3.255073] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
[    3.256607] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000030
[    3.258278] FS:  0000000000000000(0000) GS:ffff881817200000(0000) knlGS:0000000000000000
[    3.260010] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    3.261250] CR2: 0000000000000000 CR3: 000000000196f000 CR4: 00000000000007e0
[    3.262586] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    3.263912] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    3.265320] Process swapper/5 (pid: 0, threadinfo ffff880411206000, task ffff8804111fa680)
[    3.267150] Stack:
[    3.267670]  0000000000000001 ffff880411207e34 ffff880411207bb8 ffff880411207d90
[    3.269344]  00000000ffffffff ffff8818116a0548 00000000001d4780 00000000001d4780
[    3.270953]  ffff880416c21000 ffff880411207c38 ffff8818116a0560 0000000000000000
[    3.272379] Call Trace:
[    3.272933]  [<ffffffff810affc9>] find_busiest_group+0x39/0x4b0
[    3.274214]  [<ffffffff810b0545>] load_balance+0x105/0xac0
[    3.275408]  [<ffffffff810ceefd>] ? trace_hardirqs_off+0xd/0x10
[    3.276695]  [<ffffffff810aa26f>] ? local_clock+0x6f/0x80
[    3.277925]  [<ffffffff810b1500>] idle_balance+0x130/0x2d0
[    3.279137]  [<ffffffff810b1420>] ? idle_balance+0x50/0x2d0
[    3.280224]  [<ffffffff81683e40>] __schedule+0x910/0xa00
[    3.281229]  [<ffffffff81684269>] schedule+0x29/0x70
[    3.282165]  [<ffffffff8102352f>] cpu_idle+0x12f/0x140
[    3.283130]  [<ffffffff8166bf85>] start_secondary+0x262/0x264

Please let me know if it rings a bell, it looks an upstream problem.

Thanks,
Andrea
