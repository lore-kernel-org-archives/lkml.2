Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465Ab0LNXQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 18:16:51 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:59702 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177Ab0LNXQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 18:16:50 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=wum_O5HyHpgA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=nKFSn0YcsHqh7drt8YsA:9 a=PhQpr79kknwOPv43XewA:7 a=qlOhKJKGjDoKVVrFELaFJ2iZBAoA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] rtmutex: multiple candidate owners without unrelated
 boosting
From: Steven Rostedt <rostedt@goodmis.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <4D07330A.7020600@cn.fujitsu.com>
References: <4D07330A.7020600@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 14 Dec 2010 18:16:46 -0500
Message-ID: <1292368606.5015.1822.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-14 at 17:04 +0800, Lai Jiangshan wrote:

>  	/* Release the task */
>  	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
> +	if (!rt_mutex_owner(lock)) {
> +		/*
> +		 * the lock is free and has waiters, set the top waiter
> +		 * as a new candidate owner when it is not set.
> +		 */
> +		if (top_waiter != rt_mutex_top_waiter(lock)) {
> +			top_waiter = rt_mutex_top_waiter(lock);
> +			top_waiter->cand_seq = lock->cand_seq;

Shouldn't this be:

			top_waiter->cand_seq = ++lock->cand_seq;

?

-- Steve

> +			if (!top_waiter->cand_owner) {
> +				top_waiter->cand_owner = 1;
> +				wake_up_process(top_waiter->task);
> +			}
> +		}
> +		raw_spin_unlock(&lock->wait_lock);
> +		goto out_put_task;
> +	}
>  	put_task_struct(task);
>  
>  	/* Grab the next task */
> @@ -296,78 +303,16 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
>  }
>  


