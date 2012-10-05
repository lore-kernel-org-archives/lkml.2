Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab2JEKoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 06:44:24 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:53494 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207Ab2JEKoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 06:44:22 -0400
Message-ID: <506EB9D6.2070000@linux.vnet.ibm.com>
Date: Fri, 05 Oct 2012 16:13:34 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: a.p.zijlstra@chello.nl, mingo@kernel.org
CC: acme@infradead.org, paulus@samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf, cpu hotplug: Run CPU_STARTING notifiers with
 irqs disabled
References: <20120913144220.3426.22392.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120913144220.3426.22392.stgit@srivatsabhat.in.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12100510-2000-0000-0000-0000095C570C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2012 08:12 PM, Srivatsa S. Bhat wrote:
> The CPU_STARTING notifiers are supposed to be run with irqs disabled. But the
> perf_cpu_notifier() macro invokes them without doing that. Fix it.
> 
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---

Any thoughts on this?

Regards,
Srivatsa S. Bhat

> 
>  include/linux/perf_event.h |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 7602ccb..cc4574d 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -1346,10 +1346,13 @@ static inline void perf_event_task_tick(void)				{ }
>  do {									\
>  	static struct notifier_block fn##_nb __cpuinitdata =		\
>  		{ .notifier_call = fn, .priority = CPU_PRI_PERF };	\
> +	unsigned long flags;						\
>  	fn(&fn##_nb, (unsigned long)CPU_UP_PREPARE,			\
>  		(void *)(unsigned long)smp_processor_id());		\
> +	local_irq_save(flags);						\
>  	fn(&fn##_nb, (unsigned long)CPU_STARTING,			\
>  		(void *)(unsigned long)smp_processor_id());		\
> +	local_irq_restore(flags);					\
>  	fn(&fn##_nb, (unsigned long)CPU_ONLINE,				\
>  		(void *)(unsigned long)smp_processor_id());		\
>  	register_cpu_notifier(&fn##_nb);				\
> 

