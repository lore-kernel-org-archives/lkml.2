Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab2KMVNM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 16:13:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9110 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857Ab2KMVNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 16:13:11 -0500
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wwYNr3E5ImgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=rQ8w98ZuNmwA:10 a=pGLkceISAAAA:8 a=JfrnYn6hAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=t7CeM3EgAAAA:8 a=vawaw7_0AAAA:20 a=eLaRjLrNJ-9mr4-bopEA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=3Rfx1nUSh_UA:10 a=LI9Vle30uBYA:10 a=Zh68SRI7RUMA:10 a=jbrJJM5MRmoA:10 a=2e6ZYRoF4I4A:10 a=NWVoK91CQyQA:10 a=-6pmPWeWyzzm75a6:21 a=SdEBH_75Gg9eNLh7:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1352841189.18025.44.camel@gandalf.local.home>
Subject: Re: [PATCH 1/2] irq_work: Fix racy IRQ_WORK_BUSY flag setting
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Anish Kumar <anish198519851985@gmail.com>
Date: Tue, 13 Nov 2012 16:13:09 -0500
In-Reply-To: <1351877716-28911-1-git-send-email-fweisbec@gmail.com>
References: <1351877609-28856-1-git-send-email-fweisbec@gmail.com>
	 <1351877716-28911-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-02 at 18:35 +0100, Frederic Weisbecker wrote:
> The IRQ_WORK_BUSY flag is set right before we execute the
> work. Once this flag value is set, the work enters a
> claimable state again.
> 
> So if we have specific data to compute in our work, we ensure it's
> either handled by another CPU or locally by enqueuing the work again.
> This state machine is guanranteed by atomic operations on the flags.
> 
> So when we set IRQ_WORK_BUSY without using an xchg-like operation,
> we break this guarantee as in the following summarized scenario:
> 
>         CPU 1                                   CPU 2
>         -----                                   -----
>                                                 (flags = 0)
>                                                 old_flags = flags;
>         (flags = 0)
>         cmpxchg(flags, old_flags,
>                 old_flags | IRQ_WORK_FLAGS)
>         (flags = 3)
>         [...]
>         flags = IRQ_WORK_BUSY
>         (flags = 2)
>         func()
>                                                 (sees flags = 3)
>                                                 cmpxchg(flags, old_flags,
>                                                         old_flags | IRQ_WORK_FLAGS)
>                                                 (give up)
> 
>         cmpxchg(flags, 2, 0);
>         (flags = 0)
> 
> CPU 1 claims a work and executes it, so it sets IRQ_WORK_BUSY and
> the work is again in a claimable state. Now CPU 2 has new data to process
> and try to claim that work but it may see a stale value of the flags
> and think the work is still pending somewhere that will handle our data.
> This is because CPU 1 doesn't set IRQ_WORK_BUSY atomically.
> 
> As a result, the data expected to be handle by CPU 2 won't get handled.
> 
> To fix this, use xchg() to set IRQ_WORK_BUSY, this way we ensure the CPU 2
> will see the correct value with cmpxchg() using the expected ordering.
> 
> Changelog-heavily-inspired-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> Cc: Anish Kumar <anish198519851985@gmail.com>
> ---
>  kernel/irq_work.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/irq_work.c b/kernel/irq_work.c
> index 1588e3b..57be1a6 100644
> --- a/kernel/irq_work.c
> +++ b/kernel/irq_work.c
> @@ -119,8 +119,11 @@ void irq_work_run(void)
>  		/*
>  		 * Clear the PENDING bit, after this point the @work
>  		 * can be re-used.
> +		 * Make it immediately visible so that other CPUs trying
> +		 * to claim that work don't rely on us to handle their data
> +		 * while we are in the middle of the func.
>  		 */
> -		work->flags = IRQ_WORK_BUSY;
> +		xchg(&work->flags, IRQ_WORK_BUSY);
>  		work->func(work);
>  		/*
>  		 * Clear the BUSY bit and return to the free state if


