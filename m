Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405Ab0CXXmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 19:42:55 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:32256 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab0CXXmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 19:42:54 -0400
Message-ID: <4BAAA32B.3050405@oracle.com>
Date: Wed, 24 Mar 2010 16:41:31 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] tracing: Reduce overhead of module tracepoints
References: <4BA97FA7.6040406@cn.fujitsu.com>
In-Reply-To: <4BA97FA7.6040406@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4BAAA370.00CF:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/10 19:57, Li Zefan wrote:
> Remove the @refcnt argument, because it has side-effects, and
> arguments with side-effects are not skipped by the jump over
> disabled instrumentation, so it adds overhead even when the
> tracepoints are disabled.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Tested-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

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


-- 
~Randy
