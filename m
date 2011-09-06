Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957Ab1IFP3H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 11:29:07 -0400
Received: from www.linutronix.de ([62.245.132.108]:37142 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941Ab1IFP3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 11:29:00 -0400
Date: Tue, 6 Sep 2011 17:28:57 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/3] broadcast-tick: Move oneshot broadcast mask to per
 cpu variables v2
In-Reply-To: <1314652136-11350-2-git-send-email-andi@firstfloor.org>
Message-ID: <alpine.LFD.2.02.1109061704330.2723@ionos>
References: <1314652136-11350-1-git-send-email-andi@firstfloor.org> <1314652136-11350-2-git-send-email-andi@firstfloor.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Aug 2011, Andi Kleen wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> Avoid a global cache line hotspot in the oneshot cpu mask. Maintain
> this information in per cpu variables instead.

<SNIP>

> @@ -411,7 +418,9 @@ again:
>  	cpumask_clear(to_cpumask(tmpmask));
>  	now = ktime_get();
>  	/* Find all expired events */
> -	for_each_cpu(cpu, tick_get_broadcast_oneshot_mask()) {
> +	for_each_online_cpu(cpu) {
> +		if (!per_cpu(state, cpu).need_oneshot)
> +			continue;

So we iterate over each online CPU instead. I'm really not convinced
that this is better performing especially if the number of CPUs in
broadcast mode is way smaller than the number of online CPUs.

Also having a separate per cpu variable which is just a boolean marker
is silly. If we really want move that to per cpu storage then the
marker should simply be the expiry time of that CPU so you don't have
to evaluate two per cpu variables, which are in completely different
cachelines. If a CPU is not in that mode that expiry time should
simply read KTIME_MAX.

But again, I'm not convinced that iterating over a large number of
CPUs to find a single one in oneshot mode is a good idea.

Thanks,

	tglx
