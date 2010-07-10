Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab0GJAa3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 20:30:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:58471 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab0GJAa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 20:30:27 -0400
X-Authority-Analysis: v=1.1 cv=iR3a2x+wy8z+UqYHl7KFtKHYySPA0Tf/DXXAzrkvAHo= c=1 sm=0 a=-TRnPmo8vm0A:10 a=uEzv4HemXiYA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VnNF1IyMAAAA:8 a=JfrnYn6hAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=YyMF1Dys4DWpe-2ipnwA:9 a=8UJDUG-lhAAGm64wQk8A:7 a=bxsN-4n8S6T-tnypjBaJfIr2aBsA:4 a=PUjeQqilurYA:10 a=Zh68SRI7RUMA:10 a=3Rfx1nUSh_UA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=_RhRFcbxBZMA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 2/4] rtmutex: add BUG_ON if a task attempts to block on
 two locks
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Darren Hart <dvhltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>, John Kacur <jkacur@redhat.com>,
       Mike Galbraith <efault@gmx.de>, linux-rt-users@vger.kernel.org
In-Reply-To: <1278714780-788-3-git-send-email-dvhltc@us.ibm.com>
References: <1278714780-788-1-git-send-email-dvhltc@us.ibm.com>
	 <1278714780-788-3-git-send-email-dvhltc@us.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 09 Jul 2010 20:30:25 -0400
Message-ID: <1278721825.1537.171.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-09 at 15:32 -0700, Darren Hart wrote:
> rtmutex proxy locking complicates the logic a bit and opens up
> the possibility for a task to wake and attempt to take another
> sleeping lock without knowing it has been enqueued on another
> lock already. Add a BUG_ON to catch this scenario early.
> 
> Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: John Kacur <jkacur@redhat.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Mike Galbraith <efault@gmx.de>
> ---
>  kernel/rtmutex.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
> index baac7d9..22f9d18 100644
> --- a/kernel/rtmutex.c
> +++ b/kernel/rtmutex.c
> @@ -459,6 +459,9 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
>  		top_waiter = rt_mutex_top_waiter(lock);
>  	plist_add(&waiter->list_entry, &lock->wait_list);
>  
> +	/* Tasks can only block on one lock at a time. */
> +	BUG_ON(task->pi_blocked_on != NULL);

WARN_ON may be better. Since it may not cause a system crash or other
huge bug if it is not true.

-- Steve

> +
>  	task->pi_blocked_on = waiter;
>  
>  	raw_spin_unlock(&task->pi_lock);


