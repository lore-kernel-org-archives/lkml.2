Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab1IGRAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:00:38 -0400
Received: from gate.crashing.org ([63.228.1.57]:51129 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754536Ab1IGRAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 13:00:01 -0400
Subject: Re: [PATCH tip/core/rcu 55/55] powerpc: Work around tracing from
 dyntick-idle mode
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org, anton@samba.org,
        paulus@samba.org
In-Reply-To: <1315332049-2604-55-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
	 <1315332049-2604-55-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Sep 2011 07:00:22 -0300
Message-ID: <1315389622.26118.17.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-06 at 11:00 -0700, Paul E. McKenney wrote:
> PowerPC LPAR's __trace_hcall_exit() can invoke event tracing at a
> point where RCU has been told that the CPU is in dyntick-idle mode.
> Because event tracing uses RCU, this can result in failures.
> 
> A correct fix would arrange for RCU to be told about dyntick-idle
> mode after tracing had completed, however, this will require some care
> because it appears that __trace_hcall_exit() can also be called from
> non-dyntick-idle mode.

This obviously needs to be fixed properly. hcall tracing is very useful
and if I understand your patch properly, it just comments it out :-)

I'm not sure what the best approach is, maybe have the hcall tracing
test for the dyntick-idle mode and skip tracing in that case ?

Cheers,
Ben.

> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: anton@samba.org
> Cc: benh@kernel.crashing.org
> Cc: paulus@samba.org
> ---
>  arch/powerpc/platforms/pseries/lpar.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platforms/pseries/lpar.c
> index 39e6e0a..668f300 100644
> --- a/arch/powerpc/platforms/pseries/lpar.c
> +++ b/arch/powerpc/platforms/pseries/lpar.c
> @@ -715,12 +715,14 @@ EXPORT_SYMBOL(arch_free_page);
>  /* NB: reg/unreg are called while guarded with the tracepoints_mutex */
>  extern long hcall_tracepoint_refcount;
>  
> +#if 0 /* work around buggy use of RCU from dyntick-idle mode */
>  /* 
>   * Since the tracing code might execute hcalls we need to guard against
>   * recursion. One example of this are spinlocks calling H_YIELD on
>   * shared processor partitions.
>   */
>  static DEFINE_PER_CPU(unsigned int, hcall_trace_depth);
> +#endif /* #if 0 work around buggy use of RCU from dyntick-idle mode */
>  
>  void hcall_tracepoint_regfunc(void)
>  {
> @@ -734,6 +736,7 @@ void hcall_tracepoint_unregfunc(void)
>  
>  void __trace_hcall_entry(unsigned long opcode, unsigned long *args)
>  {
> +#if 0 /* work around buggy use of RCU from dyntick-idle mode */
>  	unsigned long flags;
>  	unsigned int *depth;
>  
> @@ -750,11 +753,13 @@ void __trace_hcall_entry(unsigned long opcode, unsigned long *args)
>  
>  out:
>  	local_irq_restore(flags);
> +#endif /* #if 0 work around buggy use of RCU from dyntick-idle mode */
>  }
>  
>  void __trace_hcall_exit(long opcode, unsigned long retval,
>  			unsigned long *retbuf)
>  {
> +#if 0 /* work around buggy use of RCU from dyntick-idle mode */
>  	unsigned long flags;
>  	unsigned int *depth;
>  
> @@ -771,6 +776,7 @@ void __trace_hcall_exit(long opcode, unsigned long retval,
>  
>  out:
>  	local_irq_restore(flags);
> +#endif /* #if 0 work around buggy use of RCU from dyntick-idle mode */
>  }
>  #endif
>  


