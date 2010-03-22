Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab0CVQnj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 12:43:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:52504 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab0CVQni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 12:43:38 -0400
X-Authority-Analysis: v=1.0 c=1 a=i2IbFqu-QsYA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=20KFwNOVAAAA:8 a=8dKhW-9Dc8ooV2TIDAAA:9 a=mUQmdB-cJXDWBT1fcQoA:7 a=o-rNazGlxWiy9cmYtQxErAxLWx8A:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 4/5] jump label: tracepoint support
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
       hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
       fweisbec@gmail.com
In-Reply-To: <6ede473837c2c7c55dde179690c2ae73223417c6.1269272444.git.jbaron@redhat.com>
References: <cover.1269272444.git.jbaron@redhat.com>
	 <6ede473837c2c7c55dde179690c2ae73223417c6.1269272444.git.jbaron@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 22 Mar 2010 12:43:34 -0400
Message-ID: <1269276214.2957.7.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-22 at 12:07 -0400, Jason Baron wrote:
> Make use of the jump label infrastructure for tracepoints.
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> ---
>  include/linux/tracepoint.h |   34 +++++++++++++++++++---------------
>  kernel/tracepoint.c        |    8 ++++++++
>  2 files changed, 27 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> index f59604e..c18b9c0 100644
> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -16,6 +16,7 @@
>  
>  #include <linux/types.h>
>  #include <linux/rcupdate.h>
> +#include <linux/jump_label.h>
>  
>  struct module;
>  struct tracepoint;
> @@ -63,20 +64,22 @@ struct tracepoint {
>   * not add unwanted padding between the beginning of the section and the
>   * structure. Force alignment to the same alignment as the section start.
>   */
> -#define DECLARE_TRACE(name, proto, args)				\
> -	extern struct tracepoint __tracepoint_##name;			\
> -	static inline void trace_##name(proto)				\
> -	{								\
> -		if (unlikely(__tracepoint_##name.state))		\
> -			__DO_TRACE(&__tracepoint_##name,		\
> -				TP_PROTO(proto), TP_ARGS(args));	\
> -	}								\
> -	static inline int register_trace_##name(void (*probe)(proto))	\
> -	{								\
> -		return tracepoint_probe_register(#name, (void *)probe);	\
> -	}								\
> -	static inline int unregister_trace_##name(void (*probe)(proto))	\
> -	{								\
> +#define DECLARE_TRACE(name, proto, args)				 \
> +	extern struct tracepoint __tracepoint_##name;			 \
> +	static inline void trace_##name(proto)				 \
> +	{								 \
> +		JUMP_LABEL(name, do_trace, __tracepoint_##name.state);   \
> +		return;							 \
> +do_trace:								 \
> +		__DO_TRACE(&__tracepoint_##name,			 \
> +			   TP_PROTO(proto), TP_ARGS(args));		 \

Does this still work on all archs, and when jump labels are not
supported?

I may have missed a patch (I have not received patch 2 yet).

-- Steve

> +	}								 \
> +	static inline int register_trace_##name(void (*probe)(proto))	 \
> +	{								 \
> +		return tracepoint_probe_register(#name, (void *)probe);	 \
> +	}								 \
> +	static inline int unregister_trace_##name(void (*probe)(proto))	 \
> +	{								 \
>  		return tracepoint_probe_unregister(#name, (void *)probe);\
>  	}
>  
> @@ -86,7 +89,8 @@ struct tracepoint {
>  	__attribute__((section("__tracepoints_strings"))) = #name;	\
>  	struct tracepoint __tracepoint_##name				\
>  	__attribute__((section("__tracepoints"), aligned(32))) =	\
> -		{ __tpstrtab_##name, 0, reg, unreg, NULL }
> +		{ __tpstrtab_##name, 0, reg, unreg, NULL };		\
> +	DEFINE_JUMP_LABEL(name);
>  
>  #define DEFINE_TRACE(name)						\
>  	DEFINE_TRACE_FN(name, NULL, NULL);
> diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> index cc89be5..8acced8 100644
> --- a/kernel/tracepoint.c
> +++ b/kernel/tracepoint.c
> @@ -25,6 +25,7 @@
>  #include <linux/err.h>
>  #include <linux/slab.h>
>  #include <linux/sched.h>
> +#include <linux/jump_label.h>
>  
>  extern struct tracepoint __start___tracepoints[];
>  extern struct tracepoint __stop___tracepoints[];
> @@ -256,6 +257,10 @@ static void set_tracepoint(struct tracepoint_entry **entry,
>  	 * is used.
>  	 */
>  	rcu_assign_pointer(elem->funcs, (*entry)->funcs);
> +	if (!elem->state && active)
> +		enable_jump_label(elem->name);
> +	if (elem->state && !active)
> +		disable_jump_label(elem->name);
>  	elem->state = active;
>  }
>  
> @@ -270,6 +275,9 @@ static void disable_tracepoint(struct tracepoint *elem)
>  	if (elem->unregfunc && elem->state)
>  		elem->unregfunc();
>  
> +	if (elem->state)
> +		disable_jump_label(elem->name);
> +
>  	elem->state = 0;
>  	rcu_assign_pointer(elem->funcs, NULL);
>  }


