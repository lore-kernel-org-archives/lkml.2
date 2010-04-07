Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402Ab0DGBOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 21:14:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35520 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932357Ab0DGBON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 21:14:13 -0400
X-Authority-Analysis: v=1.1 cv=y+tbl+pgjD85AC0RC2zTiF8go2AgkSUZvDTCp5uBjks= c=1 sm=0 a=3QrV72MeG1gA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=J1Y8HTJGAAAA:8 a=meVymXHHAAAA:8 a=KDFsiA_Z2WxQuNh0Gc0A:9 a=BjW4-Egl3ghN-vCDuNgA:7 a=2nPtcSjI9M4Y3WjpiKf70N9j3rYA:4 a=PUjeQqilurYA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 2/2] ftrace: Use local_irq_{save,restore}_nmi() in
 tracers.
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: David Miller <davem@davemloft.net>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, acme@redhat.com, paulus@samba.org,
       efault@gmx.de, fweisbec@gmail.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <20100406.164002.40105966.davem@davemloft.net>
References: <20100406.164002.40105966.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 06 Apr 2010 21:14:10 -0400
Message-ID: <1270602850.19685.15604.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-06 at 16:40 -0700, David Miller wrote:
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  kernel/trace/ftrace.c             |    4 ++--
>  kernel/trace/trace_functions.c    |    8 ++++----
>  kernel/trace/trace_sched_wakeup.c |    4 ++--
>  kernel/trace/trace_stack.c        |    4 ++--
>  4 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index d9062f5..41d4282 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -612,7 +612,7 @@ function_profile_call(unsigned long ip, unsigned long parent_ip)
>  	if (!ftrace_profile_enabled)
>  		return;
>  
> -	local_irq_save(flags);
> +	local_irq_save_nmi(flags);

These are equivalent for non sparc archs, correct?

If so,

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

>  
>  	stat = &__get_cpu_var(ftrace_profile_stats);
>  	if (!stat->hash || !ftrace_profile_enabled)
> @@ -627,7 +627,7 @@ function_profile_call(unsigned long ip, unsigned long parent_ip)
>  
>  	rec->counter++;
>   out:
> -	local_irq_restore(flags);
> +	local_irq_restore_nmi(flags);
>  }
>  
>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
> diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
> index b3f3776..cac3f8d 100644
> --- a/kernel/trace/trace_functions.c
> +++ b/kernel/trace/trace_functions.c
> @@ -91,7 +91,7 @@ function_trace_call(unsigned long ip, unsigned long parent_ip)
>  	 * Need to use raw, since this must be called before the
>  	 * recursive protection is performed.
>  	 */
> -	local_irq_save(flags);
> +	local_irq_save_nmi(flags);
>  	cpu = raw_smp_processor_id();
>  	data = tr->data[cpu];
>  	disabled = atomic_inc_return(&data->disabled);
> @@ -102,7 +102,7 @@ function_trace_call(unsigned long ip, unsigned long parent_ip)
>  	}
>  
>  	atomic_dec(&data->disabled);
> -	local_irq_restore(flags);
> +	local_irq_restore_nmi(flags);
>  }
>  
>  static void
> @@ -122,7 +122,7 @@ function_stack_trace_call(unsigned long ip, unsigned long parent_ip)
>  	 * Need to use raw, since this must be called before the
>  	 * recursive protection is performed.
>  	 */
> -	local_irq_save(flags);
> +	local_irq_save_nmi(flags);
>  	cpu = raw_smp_processor_id();
>  	data = tr->data[cpu];
>  	disabled = atomic_inc_return(&data->disabled);
> @@ -142,7 +142,7 @@ function_stack_trace_call(unsigned long ip, unsigned long parent_ip)
>  	}
>  
>  	atomic_dec(&data->disabled);
> -	local_irq_restore(flags);
> +	local_irq_restore_nmi(flags);
>  }
>  
> 
> diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
> index 0271742..891d3a0 100644
> --- a/kernel/trace/trace_sched_wakeup.c
> +++ b/kernel/trace/trace_sched_wakeup.c
> @@ -65,11 +65,11 @@ wakeup_tracer_call(unsigned long ip, unsigned long parent_ip)
>  	if (unlikely(disabled != 1))
>  		goto out;
>  
> -	local_irq_save(flags);
> +	local_irq_save_nmi(flags);
>  
>  	trace_function(tr, ip, parent_ip, flags, pc);
>  
> -	local_irq_restore(flags);
> +	local_irq_restore_nmi(flags);
>  
>   out:
>  	atomic_dec(&data->disabled);
> diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
> index f4bc9b2..14fa61c 100644
> --- a/kernel/trace/trace_stack.c
> +++ b/kernel/trace/trace_stack.c
> @@ -53,7 +53,7 @@ static inline void check_stack(void)
>  	if (!object_is_on_stack(&this_size))
>  		return;
>  
> -	local_irq_save(flags);
> +	local_irq_save_nmi(flags);
>  	arch_spin_lock(&max_stack_lock);
>  
>  	/* a race could have already updated it */
> @@ -104,7 +104,7 @@ static inline void check_stack(void)
>  
>   out:
>  	arch_spin_unlock(&max_stack_lock);
> -	local_irq_restore(flags);
> +	local_irq_restore_nmi(flags);
>  }
>  
>  static void


