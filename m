Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035Ab0JVOOV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 10:14:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46398 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755537Ab0JVOOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 10:14:20 -0400
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=-j11qYhtcssA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=hGzw-44bAAAA:8 a=meVymXHHAAAA:8 a=W2z2RPBFBLbHjK5PWLcA:9 a=JUXkIJTlmem-xNqbAsAA:7 a=gEqV31MNDU_cGTEPtw_B1VTlT0gA:4 a=PUjeQqilurYA:10 a=dowx1zmaLagA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] powerpc: Fix hcall tracepoint recursion
From: Steven Rostedt <rostedt@goodmis.org>
To: Anton Blanchard <anton@samba.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, subrata@linux.vnet.ibm.com,
        ltp-list@lists.sourceforge.net, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org
In-Reply-To: <20101021215212.4a982c85@kryten>
References: <4C85A88D.10700@cn.fujitsu.com>
	 <1285689961.11429.12.camel@subratamodak.linux.ibm.com>
	 <1286954486.4893.15.camel@subratamodak.linux.ibm.com>
	 <4CB55FE6.6000604@cn.fujitsu.com> <4CB5615C.4070406@cn.fujitsu.com>
	 <4CB59825.7060504@cn.fujitsu.com>
	 <1286995066.4893.17.camel@subratamodak.linux.ibm.com>
	 <4CBBBCB0.8070406@cn.fujitsu.com>  <20101021215212.4a982c85@kryten>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 22 Oct 2010 10:14:16 -0400
Message-ID: <1287756856.16971.637.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-21 at 21:52 +1100, Anton Blanchard wrote:

> Anton
> --
> 
> Subject: [PATCH] powerpc: Fix hcall tracepoint recursion
> 
> Spinlocks on shared processor partitions use H_YIELD to notify the
> hypervisor we are waiting on another virtual CPU. Unfortunately this means
> the hcall tracepoints can recurse.
> 
> The patch below adds a percpu depth and checks it on both the entry and
> exit hcall tracepoints.
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>
> ---
> 
> Index: powerpc.git/arch/powerpc/platforms/pseries/lpar.c
> ===================================================================
> --- powerpc.git.orig/arch/powerpc/platforms/pseries/lpar.c	2010-10-21 17:32:00.980003644 +1100
> +++ powerpc.git/arch/powerpc/platforms/pseries/lpar.c	2010-10-21 17:34:54.942681273 +1100
> @@ -701,6 +701,13 @@ EXPORT_SYMBOL(arch_free_page);
>  /* NB: reg/unreg are called while guarded with the tracepoints_mutex */
>  extern long hcall_tracepoint_refcount;
>  
> +/* 
> + * Since the tracing code might execute hcalls we need to guard against
> + * recursion. One example of this are spinlocks calling H_YIELD on
> + * shared processor partitions.
> + */
> +static DEFINE_PER_CPU(unsigned int, hcall_trace_depth);
> +
>  void hcall_tracepoint_regfunc(void)
>  {
>  	hcall_tracepoint_refcount++;
> @@ -713,12 +720,42 @@ void hcall_tracepoint_unregfunc(void)
>  
>  void __trace_hcall_entry(unsigned long opcode, unsigned long *args)
>  {
> +	unsigned long flags;
> +	unsigned int *depth;
> +
> +	local_irq_save(flags);
> +
> +	depth = &__get_cpu_var(hcall_trace_depth);
> +
> +	if (*depth)
> +		goto out;
> +
> +	(*depth)++;
>  	trace_hcall_entry(opcode, args);
> +	(*depth)--;
> +
> +out:
> +	local_irq_restore(flags);
>  }
>  
>  void __trace_hcall_exit(long opcode, unsigned long retval,
>  			unsigned long *retbuf)
>  {
> +	unsigned long flags;
> +	unsigned int *depth;
> +
> +	local_irq_save(flags);
> +
> +	depth = &__get_cpu_var(hcall_trace_depth);
> +
> +	if (*depth)
> +		goto out;
> +
> +	(*depth)++;
>  	trace_hcall_exit(opcode, retval, retbuf);
> +	(*depth)--;
> +
> +out:
> +	local_irq_restore(flags);
>  }
>  #endif

That's similar to the example that I wrote, but without the encapsulated
code and with disabling interrupts for the reasons you gave.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


