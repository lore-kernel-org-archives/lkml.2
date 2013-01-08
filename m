Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab3AHU0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 15:26:14 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9151 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab3AHU0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 15:26:13 -0500
X-Authority-Analysis: v=2.0 cv=Jaw+XD2V c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=S0zgfAou480A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=-V7fij46oSQA:10 a=J0lIusKqhG1g-MNCFQsA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1357676771.5190.29.camel@gandalf.local.home>
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
Date: Tue, 08 Jan 2013 15:26:11 -0500
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

> diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
> index c952770..bd461ad 100644
> --- a/kernel/context_tracking.c
> +++ b/kernel/context_tracking.c
> @@ -56,7 +56,7 @@ void user_enter(void)
>  	local_irq_save(flags);
>  	if (__this_cpu_read(context_tracking.active) &&
>  	    __this_cpu_read(context_tracking.state) != IN_USER) {
> -		__this_cpu_write(context_tracking.state, IN_USER);
> +		vtime_user_enter(current);
>  		/*
>  		 * At this stage, only low level arch entry code remains and
>  		 * then we'll run in userspace. We can assume there won't be
> @@ -65,6 +65,7 @@ void user_enter(void)
>  		 * on the tick.
>  		 */
>  		rcu_user_enter();

Hmm, the rcu_user_enter() can do quite a bit. Too bad we are accounting
it as user time. I wonder if we could move the vtime_user_enter() below
it. But then if vtime_user_enter() calls rcu_read_lock() it breaks.

The notorious chicken vs egg ordeal!

-- Steve
 
> +		__this_cpu_write(context_tracking.state, IN_USER);
>  	}
>  	local_irq_restore(flags);
>  }
> @@ -90,12 +91,13 @@ void user_exit(void)
>  
>  	local_irq_save(flags);
>  	if (__this_cpu_read(context_tracking.state) == IN_USER) {
> -		__this_cpu_write(context_tracking.state, IN_KERNEL);
>  		/*
>  		 * We are going to run code that may use RCU. Inform
>  		 * RCU core about that (ie: we may need the tick again).
>  		 */
>  		rcu_user_exit();
> +		vtime_user_exit(current);
> +		__this_cpu_write(context_tracking.state, IN_KERNEL);
>  	}
>  	local_irq_restore(flags);
>  }


