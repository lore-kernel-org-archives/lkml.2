Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab2FKLNp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 07:13:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:50228 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab2FKLNo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 07:13:44 -0400
Message-ID: <1339413213.30462.11.camel@twins>
Subject: Re: [Patch][perf] Invoke __perf_event_disable without an IPI
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: prasad@linux.vnet.ibm.com
Cc: Paul Mackerras <paulus@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Edjunior Barbosa Machado <emachado@linux.vnet.ibm.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Date: Mon, 11 Jun 2012 13:13:33 +0200
In-Reply-To: <20120611060242.GA2538@in.ibm.com>
References: <20120611060242.GA2538@in.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-11 at 11:32 +0530, K.Prasad wrote:

> While debugging a warning message on PowerPC while using hardware
> breakpoints, it was discovered that when perf_event_disable is invoked
> through hw_breakpoint_handler function with interrupts disabled, a
> subsequent IPI in the code path would trigger a WARN_ON_ONCE message in
> smp_call_function_single function.
> 
> This patch avoids the use of an IPI to invoke __perf_event_disable when
> it is safe to do so i.e. when the process associated with the perf-event
> would run on the current CPU and interrupts are disabled on the system.
> Since interrupts are always disabled before hw_breakpoint_handler in
> PowerPC, the warning message will no longer be seen.
> 
> Reported-by: Edjunior Barbosa Machado <emachado@linux.vnet.ibm.com>
> Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> ---
>  kernel/events/core.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index fd126f8..0e2c1eb 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -1302,6 +1302,7 @@ static int __perf_event_disable(void *info)
>   */
>  void perf_event_disable(struct perf_event *event)
>  {
> +	int ret;
>  	struct perf_event_context *ctx = event->ctx;
>  	struct task_struct *task = ctx->task;
>  
> @@ -1314,6 +1315,17 @@ void perf_event_disable(struct perf_event *event)
>  	}
>  
>  retry:
> +	/*
> +	 * perf_event_disable may be called when interrupts are disabled.
> +	 * For e.g. hw_breakpoint_handler exception in PowerPC. Hence using
> +	 * IPIs to invoke __perf_event_disable is not always suitable. When
> +	 * possible invoke __perf_event_disable directly.
> +	 */
> +	if ((task_cpu(task) == smp_processor_id()) && irqs_disabled()) {

Urgh.. 

So what's the callchain for the ppc->hw_bp->perf that triggers this?


> +		ret = __perf_event_disable(event);
> +		if (!ret)
> +			return;
> +	}
>  	if (!task_function_call(task, __perf_event_disable, event))
>  		return;
>  
> 

