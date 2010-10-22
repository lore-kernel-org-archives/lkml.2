Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab0JVHVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 03:21:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49937 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752703Ab0JVHVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 03:21:38 -0400
Message-ID: <4CC13BB8.7090003@cn.fujitsu.com>
Date: Fri, 22 Oct 2010 15:22:32 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Anton Blanchard <anton@samba.org>, subrata@linux.vnet.ibm.com
CC: ltp-list@lists.sourceforge.net, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] powerpc: Fix hcall tracepoint recursion
References: <4C85A88D.10700@cn.fujitsu.com>	<1285689961.11429.12.camel@subratamodak.linux.ibm.com>	<1286954486.4893.15.camel@subratamodak.linux.ibm.com>	<4CB55FE6.6000604@cn.fujitsu.com>	<4CB5615C.4070406@cn.fujitsu.com>	<4CB59825.7060504@cn.fujitsu.com>	<1286995066.4893.17.camel@subratamodak.linux.ibm.com>	<4CBBBCB0.8070406@cn.fujitsu.com> <20101021215212.4a982c85@kryten>
In-Reply-To: <20101021215212.4a982c85@kryten>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Blanchard wrote:
> Hi,
> 
>> This is a dead loop:
>>
>> trace_hcall_entry() -> trace_clock_global() -> trace_hcall_entry() ..
>>
>> And this is a PPC specific bug. Hope some ppc guys will fix it?
>> Or we kill trace_clock_global() if no one actually uses it..
> 
> Nasty! How does the patch below look? I had to disable irqs otherwise
> we would sometimes drop valid events (if we take an interrupt anywhere
> in the region where depth is elevated, then the entire interrupt will
> be blocked from calling hcall tracepoints.
> 

Thanks!

Subrata, could you test the patch below?

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
> 
> 
