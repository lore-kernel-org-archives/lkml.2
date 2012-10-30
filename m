Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965433Ab2J3Sd7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:33:59 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64266 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965234Ab2J3Sd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:33:57 -0400
Subject: Re: [PATCH 2/2] irq_work: Fix racy IRQ_WORK_BUSY flag setting
From: anish kumar <anish198519851985@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
In-Reply-To: <1351611301-3520-3-git-send-email-fweisbec@gmail.com>
References: <1351611301-3520-1-git-send-email-fweisbec@gmail.com>
	 <1351611301-3520-3-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Oct 2012 03:33:44 +0900
Message-ID: <1351622024.1504.13.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
>           on flags in claim)         execute_work (sees data from CPU
> 0)
> try to claim
> 
As I understand without the memory barrier proposed by you the situation
would be as below:
CPU 0                                 CPU 1
 
data = something                     flags = IRQ_WORK_BUSY
smp_mb() (implicit with cmpxchg      execute_work (sees data from CPU 0)
           on flags in claim)        
_success_ in claiming and goes
ahead and execute the work(wrong?)
		                     cmpxchg cause flag to IRQ_WORK_BUSY

Now knows the flag==IRQ_WORK_BUSY
                                
Am I right?

Probably a stupid question.Why do we return the bool from irq_work_queue
when no one bothers to check the return value?Wouldn't it be better if
this function is void as used by the users of this function or am I
looking at the wrong code.
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
>                 /*
>                  * Clear the PENDING bit, after this point the @work
> -                * can be re-used.
> +                * can be re-used. Use xchg to force ordering against
> +                * data to process, such that if claiming fails on
> +                * another CPU, we see and handle the data it wants
> +                * us to process on the work.
>                  */
> -               work->flags = IRQ_WORK_BUSY;
> +               xchg(&work->flags, IRQ_WORK_BUSY);
>                 work->func(work);
>                 /*
>                  * Clear the BUSY bit and return to the free state if
> -- 
> 1.7.5.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/ 

