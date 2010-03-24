Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab0CXKYt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 06:24:49 -0400
Received: from mail.openrapids.net ([64.15.138.104]:48228 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753041Ab0CXKYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 06:24:47 -0400
Date: Wed, 24 Mar 2010 06:24:45 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] tracing: Reduce overhead of module tracepoints
Message-ID: <20100324102445.GA23811@Krystal>
References: <4BA97FA7.6040406@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA97FA7.6040406@cn.fujitsu.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 06:24:17 up 60 days, 13:01,  4 users,  load average: 1.00, 1.00,
	1.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Li Zefan (lizf@cn.fujitsu.com) wrote:
> Remove the @refcnt argument, because it has side-effects, and
> arguments with side-effects are not skipped by the jump over
> disabled instrumentation, so it adds overhead even when the
> tracepoints are disabled.


Thanks Li.

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  include/linux/module.h        |    6 ++----
>  include/trace/events/module.h |   14 +++++++-------
>  kernel/module.c               |    3 +--
>  3 files changed, 10 insertions(+), 13 deletions(-)
> 
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 5e869ff..393ec39 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -460,8 +460,7 @@ static inline void __module_get(struct module *module)
>  	if (module) {
>  		preempt_disable();
>  		__this_cpu_inc(module->refptr->count);
> -		trace_module_get(module, _THIS_IP_,
> -				 __this_cpu_read(module->refptr->count));
> +		trace_module_get(module, _THIS_IP_);
>  		preempt_enable();
>  	}
>  }
> @@ -475,8 +474,7 @@ static inline int try_module_get(struct module *module)
>  
>  		if (likely(module_is_live(module))) {
>  			__this_cpu_inc(module->refptr->count);
> -			trace_module_get(module, _THIS_IP_,
> -				__this_cpu_read(module->refptr->count));
> +			trace_module_get(module, _THIS_IP_);
>  		}
>  		else
>  			ret = 0;
> diff --git a/include/trace/events/module.h b/include/trace/events/module.h
> index 4b0f48b..a585f81 100644
> --- a/include/trace/events/module.h
> +++ b/include/trace/events/module.h
> @@ -53,9 +53,9 @@ TRACE_EVENT(module_free,
>  
>  DECLARE_EVENT_CLASS(module_refcnt,
>  
> -	TP_PROTO(struct module *mod, unsigned long ip, int refcnt),
> +	TP_PROTO(struct module *mod, unsigned long ip),
>  
> -	TP_ARGS(mod, ip, refcnt),
> +	TP_ARGS(mod, ip),
>  
>  	TP_STRUCT__entry(
>  		__field(	unsigned long,	ip		)
> @@ -65,7 +65,7 @@ DECLARE_EVENT_CLASS(module_refcnt,
>  
>  	TP_fast_assign(
>  		__entry->ip	= ip;
> -		__entry->refcnt	= refcnt;
> +		__entry->refcnt	= __this_cpu_read(mod->refptr->count);
>  		__assign_str(name, mod->name);
>  	),
>  
> @@ -75,16 +75,16 @@ DECLARE_EVENT_CLASS(module_refcnt,
>  
>  DEFINE_EVENT(module_refcnt, module_get,
>  
> -	TP_PROTO(struct module *mod, unsigned long ip, int refcnt),
> +	TP_PROTO(struct module *mod, unsigned long ip),
>  
> -	TP_ARGS(mod, ip, refcnt)
> +	TP_ARGS(mod, ip)
>  );
>  
>  DEFINE_EVENT(module_refcnt, module_put,
>  
> -	TP_PROTO(struct module *mod, unsigned long ip, int refcnt),
> +	TP_PROTO(struct module *mod, unsigned long ip),
>  
> -	TP_ARGS(mod, ip, refcnt)
> +	TP_ARGS(mod, ip)
>  );
>  
>  TRACE_EVENT(module_request,
> diff --git a/kernel/module.c b/kernel/module.c
> index c968d36..21591ad 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -800,8 +800,7 @@ void module_put(struct module *module)
>  		preempt_disable();
>  		__this_cpu_dec(module->refptr->count);
>  
> -		trace_module_put(module, _RET_IP_,
> -				 __this_cpu_read(module->refptr->count));
> +		trace_module_put(module, _RET_IP_);
>  		/* Maybe they're waiting for us to drop reference? */
>  		if (unlikely(!module_is_live(module)))
>  			wake_up_process(module->waiter);
> -- 
> 1.6.3
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
