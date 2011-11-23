Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440Ab1KWPQw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 10:16:52 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64600 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756112Ab1KWPQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 10:16:51 -0500
X-Authority-Analysis: v=2.0 cv=NJxXCjGg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=c8QOUBVbWuQA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=VwQbUJbxAAAA:8 a=AFnIbC12NZItKXfCGA4A:9 a=QEXdDO2ut3YA:10 a=LI9Vle30uBYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 1/2] trace_events_filter: use rcu_assign_pointer() when
 setting ftrace_event_call->filter
From: Steven Rostedt <rostedt@goodmis.org>
To: Tejun Heo <tj@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20111123014603.GA19630@google.com>
References: <20111123014603.GA19630@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Nov 2011 10:16:47 -0500
Message-ID: <1322061407.20742.51.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Added Paul to Cc ]

On Tue, 2011-11-22 at 17:46 -0800, Tejun Heo wrote:
> ftrace_event_call->filter is sched RCU protected but didn't use
> rcu_assign_pointer().  Fix it.

Is it really needed? Maybe just for documentation but I'm not sure this
use is required because all use cases have synchronize_sched() used,
which is a big hammer compared to the rcu_assign_pointer().

> 
> TODO: Add proper __rcu annotation to call->filter and all its users.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  kernel/trace/trace_events_filter.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> Index: work/kernel/trace/trace_events_filter.c
> ===================================================================
> --- work.orig/kernel/trace/trace_events_filter.c
> +++ work/kernel/trace/trace_events_filter.c
> @@ -1686,7 +1686,7 @@ static int replace_system_preds(struct e
>  		 * replace the filter for the call.
>  		 */
>  		filter = call->filter;
> -		call->filter = filter_item->filter;
> +		rcu_assign_pointer(call->filter, filter_item->filter);

We update filter here, and then call synchronize_sched() before we free
the filter_item->filter.

>  		filter_item->filter = filter;
>  
>  		fail = false;
> @@ -1741,7 +1741,7 @@ int apply_event_filter(struct ftrace_eve
>  		filter = call->filter;
>  		if (!filter)
>  			goto out_unlock;
> -		call->filter = NULL;
> +		rcu_assign_pointer(call->filter, NULL);
>  		/* Make sure the filter is not being used */

Again you can see that synchronize_sched() is called here.

>  		synchronize_sched();
>  		__free_filter(filter);
> @@ -1782,7 +1782,7 @@ out:
>  	 * string
>  	 */
>  	tmp = call->filter;
> -	call->filter = filter;
> +	rcu_assign_pointer(call->filter, filter);

We only call synchronize_sched if call->filter wasn't NULL, because we
are going to free tmp. We need to make sure all users are done with tmp
before we free it.

>  	if (tmp) {
>  		/* Make sure the call is done with the filter */
>  		synchronize_sched();

Thus my question is, do we really need to add the rcu_assign_pointer().
I have no problem if we only do so to document that this is an rcu sched
protected variable. But it should be commented as such.

-- Steve


