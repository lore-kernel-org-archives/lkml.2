Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab3AHUXg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 15:23:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27230 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab3AHUXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 15:23:35 -0500
X-Authority-Analysis: v=2.0 cv=O9a7TWBW c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=S0zgfAou480A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=-V7fij46oSQA:10 a=A_6YqKSnuX1M2ra_L3cA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1357676611.5190.26.camel@gandalf.local.home>
Subject: Re: [PATCH 03/33] cputime: Generic on-demand virtual cputime
 accounting
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 08 Jan 2013 15:23:31 -0500
In-Reply-To: <1357610913-1080-4-git-send-email-fweisbec@gmail.com>
References: <1357610913-1080-1-git-send-email-fweisbec@gmail.com>
	 <1357610913-1080-4-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-08 at 03:08 +0100, Frederic Weisbecker wrote:

> +++ b/kernel/sched/cputime.c
> @@ -3,6 +3,7 @@
>  #include <linux/tsacct_kern.h>
>  #include <linux/kernel_stat.h>
>  #include <linux/static_key.h>
> +#include <linux/context_tracking.h>
>  #include "sched.h"
>  
> 
> @@ -495,10 +496,24 @@ void vtime_task_switch(struct task_struct *prev)
>  #ifndef __ARCH_HAS_VTIME_ACCOUNT
>  void vtime_account(struct task_struct *tsk)
>  {
> -	if (in_interrupt() || !is_idle_task(tsk))
> -		vtime_account_system(tsk);
> -	else
> -		vtime_account_idle(tsk);
> +	if (!in_interrupt()) {
> +		/*
> +		 * If we interrupted user, context_tracking_in_user()
> +		 * is 1 because the context tracking don't hook

s/don't/doesn't/

> +		 * on irq entry/exit. This way we know if
> +		 * we need to flush user time on kernel entry.

Also, the above comment is simply confusing. Why not just say something
like:

 Context tracking doesn't hook on irq entry/exit. The context will still
 be user context if the interrupt preempted user space.

No need to explain the implementation details of
"context_tracing_in_user() is 1 ...".

-- Steve

> +		 */
> +		if (context_tracking_in_user()) {
> +			vtime_account_user(tsk);
> +			return;
> +		}
> +
> +		if (is_idle_task(tsk)) {
> +			vtime_account_idle(tsk);
> +			return;
> +		}
> +	}
> +	vtime_account_system(tsk);
>  }
>  EXPORT_SYMBOL_GPL(vtime_account);
>  #endif /* __ARCH_HAS_VTIME_ACCOUNT */
> @@ -587,3 +602,72 @@ void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime
>  	cputime_adjust(&cputime, &p->signal->prev_cputime, ut, st);
>  }
>  #endif


