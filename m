Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab1AQOLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 09:11:20 -0500
Received: from canuck.infradead.org ([134.117.69.58]:45418 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab1AQOLT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 09:11:19 -0500
Subject: Re: [wake_afine fixes/improvements 1/3] sched: update
 effective_load() to use global share weights
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Nick Piggin <npiggin@kernel.dk>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
In-Reply-To: <20110115015817.069769529@google.com>
References: <20110115015749.692623529@google.com>
	 <20110115015817.069769529@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 17 Jan 2011 15:11:37 +0100
Message-ID: <1295273497.30950.119.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-14 at 17:57 -0800, Paul Turner wrote:
> plain text document attachment (fix_wake_affine.patch)
> Previously effective_load would approximate the global load weight present on
> a group taking advantage of:
> 
> entity_weight = tg->shares ( lw / global_lw ), where entity_weight was provided
> by tg_shares_up.
> 
> This worked (approximately) for an 'empty' (at tg level) cpu since we would
> place boost load representative of what a newly woken task would receive.
> 
> However, now that load is instantaneously updated this assumption is no longer
> true and the load calculation is rather incorrect in this case.
> 
> Fix this (and improve the general case) by re-writing effective_load to take
> advantage of the new shares distribution code.
> 
> Signed-off-by: Paul Turner <pjt@google.com>
> 
> ---
>  kernel/sched_fair.c |   32 ++++++++++++++++----------------
>  1 file changed, 16 insertions(+), 16 deletions(-)
> 
> Index: tip3/kernel/sched_fair.c
> ===================================================================
> --- tip3.orig/kernel/sched_fair.c
> +++ tip3/kernel/sched_fair.c
> @@ -1362,27 +1362,27 @@ static long effective_load(struct task_g
>  		return wl;
>  
>  	for_each_sched_entity(se) {
> +		long lw, w;
>  
> +		tg = se->my_q->tg;
> +		w = se->my_q->load.weight;

weight of this cpu's part of the task-group

> +		/* use this cpu's instantaneous contribution */
> +		lw = atomic_read(&tg->load_weight);
> +		lw -= se->my_q->load_contribution;
> +		lw += w + wg;

total weight of this task_group + new load
 
> +		wl += w;

this cpu's weight + new load

> +		if (lw > 0 && wl < lw)
> +			wl = (wl * tg->shares) / lw;
> +		else
> +			wl = tg->shares;

OK, so this computes the new load for this cpu, by taking the
appropriate proportion of tg->shares, it clips on large wl, and does
something funny for !lw -- on purpose?


> +		/* zero point is MIN_SHARES */
> +		if (wl < MIN_SHARES)
> +			wl = MIN_SHARES;

*nod*

> +		wl -= se->load.weight;

Take the weight delta up to the next level..

>  		wg = 0;

And assume all further groups are already enqueued and stay enqueued.

>  	}




 
