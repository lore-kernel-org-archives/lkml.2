Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab0JTFQq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 01:16:46 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60700 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab0JTFQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 01:16:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=gaYbuq1kj5NlRgE6VpcjDlKOmgMNIBTBTMtcydekSPh/x28VXwVQ4gvPhPeuIbZ7BX
         qRvWvl7m2eclRBplbeO6lAfEqBNBdh2lun2QDiSQIwDteGQaPmwK70uxLJhfzjIeRjp6
         cUPe5hLPABxtu1DtNPQ8HBZ/fqrr649c5VxzY=
Subject: Re: [PATCH 2/2]x86: spread tlb flush vector between nodes
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "hpa@zytor.com" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
In-Reply-To: <1287544023.4571.8.camel@sli10-conroe.sh.intel.com>
References: <1287544023.4571.8.camel@sli10-conroe.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Oct 2010 07:16:37 +0200
Message-ID: <1287551797.2700.76.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 20 octobre 2010 à 11:07 +0800, Shaohua Li a écrit :
> Currently flush tlb vector allocation is based on below equation:
> 	sender = smp_processor_id() % 8
> This isn't optimal, CPUs from different node can have the same vector, this
> causes a lot of lock contention. Instead, we can assign the same vectors to
> CPUs from the same node, while different node has different vectors. This has
> below advantages:
> a. if there is lock contention, the lock contention is between CPUs from one
> node. This should be much cheaper than the contention between nodes.
> b. completely avoid lock contention between nodes. This especially benefits
> kswapd, which is the biggest user of tlb flush, since kswapd sets its affinity
> to specific node.
> 
> In my test, this could reduce > 20% CPU overhead in extreme case.The test
> machine has 4 nodes and each node has 16 CPUs. I then bind each node's kswapd
> to the first CPU of the node. I run a workload with 4 sequential mmap file
> read thread. The files are empty sparse file. This workload will trigger a
> lot of page reclaim and tlbflush. The kswapd bind is to easy trigger the
> extreme tlb flush lock contention because otherwise kswapd keeps migrating
> between CPUs of a node and I can't get stable result. Sure in real workload,
> we can't always see so big tlb flush lock contention, but it's possible.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> ---
>  arch/x86/mm/tlb.c |   48 +++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 47 insertions(+), 1 deletion(-)
> 
> Index: linux/arch/x86/mm/tlb.c
> ===================================================================
> --- linux.orig/arch/x86/mm/tlb.c	2010-10-20 10:07:53.000000000 +0800
> +++ linux/arch/x86/mm/tlb.c	2010-10-20 10:09:26.000000000 +0800
> @@ -5,6 +5,7 @@
>  #include <linux/smp.h>
>  #include <linux/interrupt.h>
>  #include <linux/module.h>
> +#include <linux/cpu.h>
>  
>  #include <asm/tlbflush.h>
>  #include <asm/mmu_context.h>
> @@ -52,6 +53,8 @@ union smp_flush_state {
>     want false sharing in the per cpu data segment. */
>  static union smp_flush_state flush_state[NUM_INVALIDATE_TLB_VECTORS];
>  
> +static DEFINE_PER_CPU_READ_MOSTLY(int, tlb_vector_offset);
> +
>  /*
>   * We cannot call mmdrop() because we are in interrupt context,
>   * instead update mm->cpu_vm_mask.
> @@ -173,7 +176,7 @@ static void flush_tlb_others_ipi(const s
>  	union smp_flush_state *f;
>  
>  	/* Caller has disabled preemption */
> -	sender = smp_processor_id() % NUM_INVALIDATE_TLB_VECTORS;
> +	sender = per_cpu(tlb_vector_offset, smp_processor_id());

	sender = this_cpu_read(tlb_vector_offset);

>  	f = &flush_state[sender];
>  
>  	/*
> @@ -218,6 +221,47 @@ void native_flush_tlb_others(const struc
>  	flush_tlb_others_ipi(cpumask, mm, va);
>  }
>  


Thats a pretty good patch, thanks !

Maybe we should have a per_node memory infrastructure, so that we can
lower memory needs of currently per_cpu objects.



