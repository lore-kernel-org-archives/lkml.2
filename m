Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab1KWQkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 11:40:22 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:38139 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab1KWQkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 11:40:21 -0500
Message-ID: <1322066417.17693.56.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [PATCH 1/2] trace_events_filter: use rcu_assign_pointer() when
 setting ftrace_event_call->filter
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 23 Nov 2011 17:40:17 +0100
In-Reply-To: <20111123014603.GA19630@google.com>
References: <20111123014603.GA19630@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 22 novembre 2011 à 17:46 -0800, Tejun Heo a écrit :
> ftrace_event_call->filter is sched RCU protected but didn't use
> rcu_assign_pointer().  Fix it.
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
>  		filter_item->filter = filter;
>  
>  		fail = false;
> @@ -1741,7 +1741,7 @@ int apply_event_filter(struct ftrace_eve
>  		filter = call->filter;
>  		if (!filter)
>  			goto out_unlock;
> -		call->filter = NULL;
> +		rcu_assign_pointer(call->filter, NULL);

Its a minor point, but setting a pointer to NULL certainly doesnt need a
smp_wmb() barrier, so you can use RCU_INIT_POINTER(call->filter, NULL);



