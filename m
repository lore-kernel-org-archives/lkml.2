Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933995Ab2J3Q0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 12:26:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17648 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933812Ab2J3Q0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 12:26:35 -0400
X-Authority-Analysis: v=2.0 cv=KcBQQHkD c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=gPGaiRUHczgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=rQ8w98ZuNmwA:10 a=pGLkceISAAAA:8 a=JfrnYn6hAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=t7CeM3EgAAAA:8 a=2ITF59WeXM4W8nZeUlMA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=3Rfx1nUSh_UA:10 a=LI9Vle30uBYA:10 a=Zh68SRI7RUMA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=2e6ZYRoF4I4A:10 a=6iqt2sy--kpHgZvv:21 a=seJcdWXrbRn7pwyi:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1351614394.8467.110.camel@gandalf.local.home>
Subject: Re: [PATCH 2/2] irq_work: Fix racy IRQ_WORK_BUSY flag setting
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Tue, 30 Oct 2012 12:26:34 -0400
In-Reply-To: <1351611301-3520-3-git-send-email-fweisbec@gmail.com>
References: <1351611301-3520-1-git-send-email-fweisbec@gmail.com>
	 <1351611301-3520-3-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-30 at 16:35 +0100, Frederic Weisbecker wrote:
> The IRQ_WORK_BUSY flag is set right before we execute the
> work. Once this flag value is set, the work enters a
> claimable state again.
> 
> This is necessary because if we want to enqueue a work but we
> fail the claim, we want to ensure that the CPU where that work
> is still pending will see and handle the data we expected the
> work to compute.
> 
> This might not work as expected though because IRQ_WORK_BUSY
> isn't set atomically. By the time a CPU fails a work claim,
> this work may well have been already executed by the CPU where
> it was previously pending.
> 
> Due to the lack of appropriate memory barrier, the IRQ_WORK_BUSY
> flag value may not be visible by the CPU trying to claim while
> the work is executing, and that until we clear the busy bit in
> the work flags using cmpxchg() that implies the full barrier.
> 
> One solution could involve a full barrier between setting
> IRQ_WORK_BUSY flag and the work execution. This way we
> ensure that the work execution site sees the expected data
> and the claim site sees the IRQ_WORK_BUSY:
> 
> CPU 0                                 CPU 1
> 
> data = something                     flags = IRQ_WORK_BUSY
> smp_mb() (implicit with cmpxchg      smp_mb()
>           on flags in claim)         execute_work (sees data from CPU 0)
> try to claim
> 
> As a shortcut, let's just use xchg() that implies a full memory
> barrier.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> ---
>  kernel/irq_work.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/irq_work.c b/kernel/irq_work.c
> index 764240a..ea79365 100644
> --- a/kernel/irq_work.c
> +++ b/kernel/irq_work.c
> @@ -130,9 +130,12 @@ void irq_work_run(void)
>  
>  		/*
>  		 * Clear the PENDING bit, after this point the @work
> -		 * can be re-used.
> +		 * can be re-used. Use xchg to force ordering against
> +		 * data to process, such that if claiming fails on
> +		 * another CPU, we see and handle the data it wants
> +		 * us to process on the work.
>  		 */
> -		work->flags = IRQ_WORK_BUSY;
> +		xchg(&work->flags, IRQ_WORK_BUSY);
>  		work->func(work);
>  		/*
>  		 * Clear the BUSY bit and return to the free state if


