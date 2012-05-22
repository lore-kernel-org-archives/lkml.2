Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759640Ab2EVCQ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 22:16:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51310 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab2EVCQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 22:16:55 -0400
Date: Mon, 21 May 2012 19:16:53 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@kernel.org>
cc: hpa@zytor.com, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, pjt@google.com, cl@linux.com,
        riel@redhat.com, bharata.rao@gmail.com, akpm@linux-foundation.org,
        Lee.Schermerhorn@hp.com, aarcange@redhat.com, danms@us.ibm.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/numa] sched/numa: Introduce sys_numa_{t,m}bind()
In-Reply-To: <20120521084046.GB31407@gmail.com>
Message-ID: <alpine.DEB.2.00.1205211914100.13682@chino.kir.corp.google.com>
References: <tip-nf7brf1b88w0ojwuf689xeet@git.kernel.org> <alpine.DEB.2.00.1205191922250.24674@chino.kir.corp.google.com> <20120521084046.GB31407@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2012, Ingo Molnar wrote:

> Fundamentally, do people agree with the 'single home node' 
> approach to begin with? We could turn it into a node mask,
> but that complicates things.
> 

I merged core/rcu locally to get a kernel that builds but ran into a 
divide by zero:

[    0.602181] divide error: 0000 [#1] SMP 
[    0.606159] CPU 0 
[    0.608003] Modules linked in:
[    0.611266] 
[    0.612767] Pid: 1, comm: swapper/0 Not tainted 3.4.0 #1
[    0.620912] RIP: 0010:[<ffffffff810af9ab>]  [<ffffffff810af9ab>] update_sd_lb_stats+0x38b/0x740
[    0.629630] RSP: 0018:ffff880275471870  EFLAGS: 00010056
[    0.634927] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[    0.642042] RDX: 0000000000000000 RSI: ffff880475969ca0 RDI: 0000000000000000
[    0.649181] RBP: ffff880275471970 R08: ffff88027545ff60 R09: 0000000000000000
[    0.656294] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000020
[    0.663419] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[    0.670559] FS:  0000000000000000(0000) GS:ffff88027fc00000(0000) knlGS:0000000000000000
[    0.678633] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.684364] CR2: 0000000000000000 CR3: 000000000180b000 CR4: 00000000000007f0
[    0.691499] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    0.698628] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    0.705755] Process swapper/0 (pid: 1, threadinfo ffff880275470000, task ffff88027545b800)
[    0.714001] Stack:
[    0.716021]  000000000000000b 0000000000012000 0000000000000000 ffff88087fd92000
[    0.723455]  ffff880275471b5c 00000000754718b8 fffffffffffffff8 ffff880275471ab0
[    0.730884]  00000000003f5e37 00000000ffffffff ffff880275471988 ffff88027545ff60
[    0.738320] Call Trace:
[    0.740772]  [<ffffffff810afda5>] find_busiest_group+0x45/0x480
[    0.746692]  [<ffffffff810b02da>] load_balance+0xfa/0x6e0
[    0.752084]  [<ffffffff810ae820>] ? active_load_balance_cpu_stop+0x1d0/0x1d0
[    0.759127]  [<ffffffff810b0c7c>] idle_balance+0xcc/0x130
[    0.764529]  [<ffffffff81530686>] __schedule+0x756/0x760
[    0.769829]  [<ffffffff81530749>] schedule+0x29/0x70
[    0.774795]  [<ffffffff8152ee45>] schedule_timeout+0x1b5/0x2e0
[    0.780623]  [<ffffffff8106986e>] ? physflat_send_IPI_mask+0xe/0x10
[    0.786885]  [<ffffffff810655e6>] ? native_smp_send_reschedule+0x46/0x60
[    0.793584]  [<ffffffff810a6fd0>] ? resched_task+0x60/0x70
[    0.799052]  [<ffffffff810a7565>] ? check_preempt_curr+0x75/0xa0
[    0.805051]  [<ffffffff8152fdb6>] wait_for_common+0xc6/0x160
[    0.810716]  [<ffffffff810aa420>] ? try_to_wake_up+0x2a0/0x2a0
[    0.816541]  [<ffffffff8152ff2d>] wait_for_completion+0x1d/0x20
[    0.822461]  [<ffffffff81099fe9>] kthread_create_on_node+0xa9/0x130
[    0.828714]  [<ffffffff8152ac86>] ? alternate_node_alloc+0x9d/0xa6
[    0.834890]  [<ffffffff81093cd0>] ? worker_maybe_bind_and_lock.isra.27+0xd0/0xd0
[    0.842266]  [<ffffffff81160201>] ? kmem_freepages.isra.41+0x91/0x150
[    0.848701]  [<ffffffff81095d2d>] __alloc_workqueue_key+0x1dd/0x3f0
[    0.854963]  [<ffffffff818c7d26>] ? sched_init_smp+0x300/0x30f
[    0.860787]  [<ffffffff818c9891>] cpuset_init_smp+0x40/0x50
[    0.866356]  [<ffffffff818b2c49>] kernel_init+0xb9/0x1ad
[    0.871662]  [<ffffffff8153a0d4>] kernel_thread_helper+0x4/0x10
[    0.877573]  [<ffffffff818b2b90>] ? start_kernel+0x37e/0x37e
[    0.883216]  [<ffffffff8153a0d0>] ? gs_change+0xb/0xb
