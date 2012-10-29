Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759128Ab2J2Nru (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 09:47:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9767 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758795Ab2J2Nrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 09:47:49 -0400
X-Authority-Analysis: v=2.0 cv=NLdXCjGg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=_U3GF9pqmcoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=8-zqv9V26p4A:10 a=pGLkceISAAAA:8 a=JfrnYn6hAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=t7CeM3EgAAAA:8 a=3oc9M9_CAAAA:8 a=G4XkzanEVm6l1QmfK2YA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=3Rfx1nUSh_UA:10 a=LI9Vle30uBYA:10 a=Zh68SRI7RUMA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=2e6ZYRoF4I4A:10 a=U8Ie8EnqySEA:10 a=5pcfcLwreGxdOZmm:21 a=QxGwDa8-OTKnIWjK:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1351518466.8467.65.camel@gandalf.local.home>
Subject: Re: [RFC PATCH 1/9] irq_work: Fix racy check on work pending flag
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Mon, 29 Oct 2012 09:47:46 -0400
In-Reply-To: <1351517296-9173-2-git-send-email-fweisbec@gmail.com>
References: <1351517296-9173-1-git-send-email-fweisbec@gmail.com>
	 <1351517296-9173-2-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-29 at 14:28 +0100, Frederic Weisbecker wrote:
> Context requirements on irq work claim are not entirely
> clear. But it appears that we can try to claim a work that
> may be already claimed by another CPU.
> 
> If so then the early check on IRQ_WORK_PENDING in
> irq_work_claim() is racy because another CPU may be
> changing the flags concurrently and we have nothing
> to synchronize against that. So the value we deal with
> may be stale for a while already.
> 
> To fix this, start with our best wish as the initial
> value for the work flags and feed cmpxchg with it. But
> only do the check against IRQ_WORK_PENDING flag with the
> cmpxchg result.
> 
> Nonetheless, if the work is not pending but our best wish
> was wrong, restart with the old value returned by cmpxchg.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---
>  kernel/irq_work.c |   17 ++++++++++++-----
>  1 files changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/irq_work.c b/kernel/irq_work.c
> index 1588e3b..679c13e 100644
> --- a/kernel/irq_work.c
> +++ b/kernel/irq_work.c
> @@ -34,15 +34,22 @@ static DEFINE_PER_CPU(struct llist_head, irq_work_list);
>   */
>  static bool irq_work_claim(struct irq_work *work)
>  {
> -	unsigned long flags, nflags;
> +	unsigned long flags, oflags, nflags;
>  
> +	/*
> +	 * Can't check IRQ_WORK_PENDING bit right now because the work
> +	 * can be running on another CPU and we are not sync with its
> +	 * changes to work flags. Only cmpxchg can reliably check for us.
> +	 */
> +	flags = work->flags & ~IRQ_WORK_PENDING;
>  	for (;;) {
> -		flags = work->flags;

I wonder if the bug is just a memory barrier missing here? But that also
suggests that the other CPU used a memory barrier too (or cmpxchg()
which implies one).

But this change looks fine too.

-- Steve

> -		if (flags & IRQ_WORK_PENDING)
> -			return false;
>  		nflags = flags | IRQ_WORK_FLAGS;
> -		if (cmpxchg(&work->flags, flags, nflags) == flags)
> +		oflags = cmpxchg(&work->flags, flags, nflags);
> +		if (oflags == flags)
>  			break;
> +		if (oflags & IRQ_WORK_PENDING)
> +			return false;
> +		flags = oflags;
>  		cpu_relax();
>  	}
>  


