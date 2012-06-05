Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab2FEHQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 03:16:21 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:37113 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab2FEHQS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 03:16:18 -0400
MIME-Version: 1.0
In-Reply-To: <1337931080.9783.154.camel@laptop>
References: <tip-r74n3n8hhuc2ynbrnp3vt954@git.kernel.org>
	<CA+8MBbJknmrUXG7U_hBaTs4vJ-1Fa-ENq5g3Qzzh6EmsNiSfXg@mail.gmail.com>
	<1337931080.9783.154.camel@laptop>
Date: Tue, 5 Jun 2012 15:16:17 +0800
Message-ID: <CAGjg+kEH8Be7tVhBaHtgDBeoLzk6yDja72YwnpF32zKS0K=rAA@mail.gmail.com>
Subject: Re: [tip:sched/core] sched/numa: Rewrite the CONFIG_NUMA sched domain support
From: Alex Shi <lkml.alex@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tony Luck <tony.luck@intel.com>, mingo@kernel.org,
        torvalds@linux-foundation.org, cmetcalf@tilera.com, sivanich@sgi.com,
        akpm@linux-foundation.org, ralf@linux-mips.org, greg.pearson@hp.com,
        ink@jurassic.park.msu.ru, tglx@linutronix.de, rth@twiddle.net,
        kamezawa.hiroyu@jp.fujitsu.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com, anton@samba.org,
        lethal@linux-sh.org, davem@davemloft.net, benh@kernel.crashing.org,
        dhowells@redhat.com, mattst88@gmail.com, fenghua.yu@intel.com,
        Alex Shi <alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LKP performance set 'mem=2g' for some benchmarks, that cmdline hit
kernel panic on __alloc_pages_mask on 3.5-rc1. and this patch can fix
it.
Thanks!

reported-tested-by alex.shi@intel.com


On Fri, May 25, 2012 at 3:31 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Thu, 2012-05-24 at 14:23 -0700, Tony Luck wrote:
>> Changing both the kzalloc_node() calls in sched_init_numa()
>> into plain kzalloc() calls seems to fix things. So it looks like we are trying
>> to allocate on a node before the node has been fully set up.
>
> Right,.. and its not too important either, so lets just use regular
> allocations.
>
> That said, I can only find the 1 alloc_node() in sched_init_numa()
>
>
> ---
> Subject: sched: Don't try allocating memory from offline nodes
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Fri May 25 09:26:43 CEST 2012
>
> Allocators don't appreciate it when you try and allocate memory from
> offline nodes.
>
> Reported-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/sched/core.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> Index: linux-2.6/kernel/sched/core.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched/core.c
> +++ linux-2.6/kernel/sched/core.c
> @@ -6449,7 +6449,7 @@ static void sched_init_numa(void)
>                        return;
>
>                for (j = 0; j < nr_node_ids; j++) {
> -                       struct cpumask *mask = kzalloc_node(cpumask_size(), GFP_KERNEL, j);
> +                       struct cpumask *mask = kzalloc(cpumask_size(), GFP_KERNEL);
>                        if (!mask)
>                                return;
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
