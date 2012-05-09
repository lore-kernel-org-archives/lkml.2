Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097Ab2EIKV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 06:21:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60502 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab2EIKVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 06:21:55 -0400
Message-ID: <4FAA452A.1070909@gmail.com>
Date: Wed, 09 May 2012 18:21:30 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Igor Mammedov <imammedo@redhat.com>
CC: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@kernel.org,
        pjt@google.com, tglx@linutronix.de, seto.hidetoshi@jp.fujitsu.com
Subject: Re: [PATCH] sched_groups are expected to be circular linked list,
 make it so right after allocation
References: <1336559908-32533-1-git-send-email-imammedo@redhat.com>
In-Reply-To: <1336559908-32533-1-git-send-email-imammedo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Igor,
	Thanks for fixing this bug! We encountered the same issue with an
IA64 systems too. That system could boot with 2.6.32, but can't boot with
any 3.x.x kernels. We have just found the root cause today.
	--gerry

On 05/09/2012 06:38 PM, Igor Mammedov wrote:
> if we have one cpu that failed to boot and boot cpu gave up on waiting for it
> and then another cpu is being booted, kernel might crash with following OOPS:
> 
> [  723.865765] BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
> [  723.866616] IP: [<ffffffff812c3630>] __bitmap_weight+0x30/0x80
> [  723.866616] PGD 7ba91067 PUD 7a205067 PMD 0
> [  723.866616] Oops: 0000 [#1] SMP
> [  723.898527] CPU 1
> ...
> [  723.898527] Pid: 1221, comm: offV2.sh Tainted: G        W    3.4.0-rc4+ #213 Red Hat KVM
> [  723.898527] RIP: 0010:[<ffffffff812c3630>]  [<ffffffff812c3630>] __bitmap_weight+0x30/0x80
> [  723.898527] RSP: 0018:ffff88007ab9dc18  EFLAGS: 00010246
> [  723.898527] RAX: 0000000000000003 RBX: 0000000000000000 RCX: 0000000000000000
> [  723.898527] RDX: 0000000000000018 RSI: 0000000000000100 RDI: 0000000000000018
> [  723.898527] RBP: ffff88007ab9dc18 R08: 0000000000000000 R09: 0000000000000020
> [  723.898527] R10: 0000000000000004 R11: 0000000000000000 R12: ffff88007c06ed60
> [  723.898527] R13: ffff880037a94000 R14: 0000000000000003 R15: ffff88007c06ed60
> [  723.898527] FS:  00007f1d6a7d8700(0000) GS:ffff88007fc80000(0000) knlGS:0000000000000000
> [  723.898527] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  723.898527] CR2: 0000000000000018 CR3: 000000007bb7f000 CR4: 00000000000007e0
> [  723.898527] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  723.898527] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  723.898527] Process offV2.sh (pid: 1221, threadinfo ffff88007ab9c000, task ffff88007b358000)
> [  723.898527] Stack:
> [  723.898527]  ffff88007ab9dcc8 ffffffff8108b9b6 ffff88007ab9dc58 ffff88007b4f2a00
> [  723.898527]  ffff88007c06ed60 0000000000000003 000000037ab9dc58 0000000000010008
> [  723.898527]  ffffffff81a308e8 0000000000000003 ffff88007b489cc0 ffff880037b6bd20
> [  723.898527] Call Trace:
> [  723.898527]  [<ffffffff8108b9b6>] build_sched_domains+0x7b6/0xa50
> [  723.898527]  [<ffffffff8108bea9>] partition_sched_domains+0x259/0x3f0
> [  723.898527]  [<ffffffff810c4485>] cpuset_update_active_cpus+0x85/0x90
> [  723.898527]  [<ffffffff81084f65>] cpuset_cpu_active+0x25/0x30
> [  723.898527]  [<ffffffff81545b45>] notifier_call_chain+0x55/0x80
> [  723.898527]  [<ffffffff8107e59e>] __raw_notifier_call_chain+0xe/0x10
> [  723.898527]  [<ffffffff81058be0>] __cpu_notify+0x20/0x40
> [  723.898527]  [<ffffffff8153af08>] _cpu_up+0xc7/0x10e
> [  723.898527]  [<ffffffff8153af9b>] cpu_up+0x4c/0x5c
> 
> crash happens in  init_sched_groups_power() that expects sched_groups to be
> circular linked list. However it is not always true, since sched_groups
> preallocated in __sdt_alloc are initialized in build_sched_groups and it
> may exit early
> 
>         if (cpu != cpumask_first(sched_domain_span(sd)))
>                 return 0;
> 
> without initializing sd->groups->next field.
> 
> Fix bug by initializing next field right after sched_group was allocated.
> 
> Signed-off-by: Igor Mammedov <imammedo@redhat.com>
> ---
>  kernel/sched/core.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 0533a68..e5212ae 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -6382,6 +6382,8 @@ static int __sdt_alloc(const struct cpumask *cpu_map)
>  			if (!sg)
>  				return -ENOMEM;
>  
> +			sg->next = sg;
> +
>  			*per_cpu_ptr(sdd->sg, j) = sg;
>  
>  			sgp = kzalloc_node(sizeof(struct sched_group_power),

