Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966470Ab0CPPES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 11:04:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966326Ab0CPPER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 11:04:17 -0400
Subject: Re: Why we need to call cpu_idle() with preemption disabled
From: Steven Rostedt <srostedt@redhat.com>
To: wuzhangjin@gmail.com
Cc: Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1268730114.9552.34.camel@falcon>
References: <1268730114.9552.34.camel@falcon>
Content-Type: text/plain
Organization: Red Hat
Date: Tue, 16 Mar 2010 11:04:09 -0400
Message-Id: <1268751849.22564.38.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-16 at 17:01 +0800, Wu Zhangjin wrote:
> Hi, Thomas
> 
> Just traced the preemption latency of 2.6.33-rt7 on my Yeeloong netbook
> with the preemptoff tracer of Ftrace and found it is very big in
> cpu_idle(), more than 1000 us.
> 
> And found that we have called cpu_idle() in init/main.c with preemption
> disabled? why we need to do it? can we simply call it with preemption
> enabled?
> 
> diff --git a/init/main.c b/init/main.c
> index 48393c0..437ac34 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -428,9 +428,8 @@ static noinline void __init_refok rest_init(void)
>          */
>         init_idle_bootup_task(current);
>         preempt_enable_and_schedule();
> -       preempt_disable();
>  
> -       /* Call into cpu_idle with preempt disabled */
> +       /* There is no reason for calling cpu_idle with preemption
> disabled */
>         cpu_idle();
>  }
> 
> After removing that preempt_disable() and the related operations around
> the calling to __schedule() in the cpu_idle(), the result becomes around
> 200 us, which is acceptable for I have enabled several Ftrace tracers.

The preempt disable is needed for idle since cpu_idle() expects
preemption to be disabled.

But this can cause the latency tracer to do show false latencies. What
you need to add in arch/mips/kernel/process.c: cpu_idle()

+			stop_critical_timings();
			if (cpu_wait)
				(*cpu_wait)();
+			start_critical_timings();


This two functions tell the latency tracer to ignore the time spent in
idle, while idle will wake up when an interrupt happens anyway.

-- Steve


