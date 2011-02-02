Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab1BBQYG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 11:24:06 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35918 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397Ab1BBQYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 11:24:05 -0500
Subject: Re: [PATCH] softirq: Avoid stack switch from ksoftirqd
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        David Miller <davem@davemloft.net>, Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <alpine.LFD.2.00.1102021704530.31804@localhost6.localdomain6>
References: <alpine.LFD.2.00.1102021704530.31804@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Feb 2011 17:24:56 +0100
Message-ID: <1296663896.26581.341.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-02 at 17:10 +0100, Thomas Gleixner wrote:
> ksoftirqd() calls do_softirq() which switches stacks on several
> architectures. That makes no sense at all. ksoftirqd's stack is
> sufficient.
> 
> Call __do_softirq() directly.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> ---
>  kernel/softirq.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6-tip/kernel/softirq.c
> ===================================================================
> --- linux-2.6-tip.orig/kernel/softirq.c
> +++ linux-2.6-tip/kernel/softirq.c
> @@ -738,7 +738,10 @@ static int run_ksoftirqd(void * __bind_c
>  			   don't process */
>  			if (cpu_is_offline((long)__bind_cpu))
>  				goto wait_to_die;
> -			do_softirq();
> +			local_irq_disable();
> +			if (local_softirq_pending())
> +				__do_softirq();
> +			local_irq_enable();
>  			preempt_enable_no_resched();
>  			cond_resched();
>  			preempt_disable();



