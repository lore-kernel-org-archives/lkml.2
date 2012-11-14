Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423313Ab2KNTYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 14:24:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6478 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423142Ab2KNTYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 14:24:53 -0500
X-Authority-Analysis: v=2.0 cv=RoZH3VaK c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=1feq8IG3Eo8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=kafnXrAn3csA:10 a=pGLkceISAAAA:8 a=JfrnYn6hAAAA:8 a=VwQbUJbxAAAA:8 a=t7CeM3EgAAAA:8 a=QyXUC8HyAAAA:8 a=wMNdZWldAAAA:8 a=hGzw-44bAAAA:8 a=VnNF1IyMAAAA:8 a=BxVdd2Agee-ougCqM3QA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=3Rfx1nUSh_UA:10 a=LI9Vle30uBYA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=2e6ZYRoF4I4A:10 a=dGJ0OcVc7YAA:10 a=dowx1zmaLagA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1352921090.18025.73.camel@gandalf.local.home>
Subject: Re: [PATCH 4/4] vtime: No need to disable irqs on vtime_account()
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Wed, 14 Nov 2012 14:24:50 -0500
In-Reply-To: <1352910413-10759-5-git-send-email-fweisbec@gmail.com>
References: <1352910413-10759-1-git-send-email-fweisbec@gmail.com>
	 <1352910413-10759-5-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-14 at 17:26 +0100, Frederic Weisbecker wrote:
> vtime_account() is only called from irq entry. irqs
> are always disabled at this point so we can safely
> remove the irq disabling guards on that function.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Fenghua Yu <fenghua.yu@intel.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  kernel/sched/cputime.c |    6 ------
>  1 files changed, 0 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
> index 2e8d34a..80b2fd5 100644
> --- a/kernel/sched/cputime.c
> +++ b/kernel/sched/cputime.c
> @@ -467,16 +467,10 @@ void vtime_task_switch(struct task_struct *prev)
>  #ifndef __ARCH_HAS_VTIME_ACCOUNT
>  void vtime_account(struct task_struct *tsk)
>  {
> -	unsigned long flags;
> -
> -	local_irq_save(flags);
> -

I'd add a WARN_ON_ONCE(!irqs_disabled()) again here, or is this also
covered by the vtime_delta()?

-- Steve

>  	if (in_interrupt() || !is_idle_task(tsk))
>  		vtime_account_system(tsk);
>  	else
>  		vtime_account_idle(tsk);
> -
> -	local_irq_restore(flags);
>  }
>  EXPORT_SYMBOL_GPL(vtime_account);
>  #endif /* __ARCH_HAS_VTIME_ACCOUNT */


