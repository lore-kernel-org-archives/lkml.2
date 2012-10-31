Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422918Ab2JaOPU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 10:15:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24684 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422815Ab2JaOPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 10:15:16 -0400
X-Authority-Analysis: v=2.0 cv=NLdXCjGg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=ZINjJWKk7f8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=lJEFyBTRSOMA:10 a=pGLkceISAAAA:8 a=eWfoQJOYkE6zxK7xLYkA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=6qfZlBHHSjKd2DXR:21 a=HPD4q3nzEakandN2:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1351692914.4004.83.camel@gandalf.local.home>
Subject: Re: [PATCH] [RFC]IRQ CORE: irq_work_queue function return value not
 used.
From: Steven Rostedt <rostedt@goodmis.org>
To: anish kumar <anish198519851985@gmail.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
        akpm@linux-foundation.org, paul.gortmaker@windriver.com,
        tglx@linutronix.de, mingo@kernel.org, fweisbec@gmail.com
Date: Wed, 31 Oct 2012 10:15:14 -0400
In-Reply-To: <1351692126-8944-1-git-send-email-anish198519851985@gmail.com>
References: <1351692126-8944-1-git-send-email-anish198519851985@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-31 at 23:02 +0900, anish kumar wrote:
> From: anish kumar <anish198519851985@gmail.com>
> 
> As no one is using the return value of irq_work_queue function
> it is better to just make it void.
> 
> This patch is just a way to understand if there is some future
> plan to use it but in any case please let me know the reason.
> ---
>  kernel/irq_work.c |   21 ++++++++++-----------
>  1 files changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/kernel/irq_work.c b/kernel/irq_work.c
> index 1588e3b..4a9a44c 100644
> --- a/kernel/irq_work.c
> +++ b/kernel/irq_work.c
> @@ -32,21 +32,21 @@ static DEFINE_PER_CPU(struct llist_head, irq_work_list);
>  /*
>   * Claim the entry so that no one else will poke at it.
>   */
> -static bool irq_work_claim(struct irq_work *work)
> +static void irq_work_claim(struct irq_work *work)
>  {
>  	unsigned long flags, nflags;
>  
>  	for (;;) {
>  		flags = work->flags;
>  		if (flags & IRQ_WORK_PENDING)
> -			return false;
> +			return;
>  		nflags = flags | IRQ_WORK_FLAGS;
>  		if (cmpxchg(&work->flags, flags, nflags) == flags)
>  			break;
>  		cpu_relax();
>  	}
>  
> -	return true;
> +	return;
>  }
>  
>  void __weak arch_irq_work_raise(void)
> @@ -79,15 +79,14 @@ static void __irq_work_queue(struct irq_work *work)
>   *
>   * Can be re-enqueued while the callback is still in progress.
>   */
> -bool irq_work_queue(struct irq_work *work)
> +void irq_work_queue(struct irq_work *work)
>  {
> -	if (!irq_work_claim(work)) {
> -		/*
> -		 * Already enqueued, can't do!
> -		 */
> -		return false;
> -	}
> -
> +	/*
> +	 * This function either will claim the entry to queue
> +	 * the work or if the work is already queued and is in
> +	 * pending state then it will simply return.
> +	 */
> +	irq_work_claim(work)

Um, no.

If the state was already pending, we will corrupt the llist node of the
work if we call irq_work_queue(). You must check the return value of
irq_work_claim() and return if it fails. You can not call
__irq_work_queue() if irq_work_claim() does not succeed.

The return value of irq_work_queue() can be ignored, but not
irq_work_claim().

-- Steve

>  	__irq_work_queue(work);
>  	return true;
>  }


