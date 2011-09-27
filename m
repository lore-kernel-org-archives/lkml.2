Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab1I0VBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 17:01:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45651 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab1I0VBa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 17:01:30 -0400
Subject: Re: [RFD 1/9] Change cpustat fields to an array.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, jbottomley@parallels.com
Date: Tue, 27 Sep 2011 23:00:52 +0200
In-Reply-To: <1316816432-9237-2-git-send-email-glommer@parallels.com>
References: <1316816432-9237-1-git-send-email-glommer@parallels.com>
	 <1316816432-9237-2-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317157252.21836.3.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-23 at 19:20 -0300, Glauber Costa wrote:
>  /* Must have preemption disabled for this to be meaningful. */
> -#define kstat_this_cpu __get_cpu_var(kstat)
> +#define kstat_this_cpu this_cpu_ptr(task_group_kstat(current))

This just lost you a debug check, the former would whinge when called
without preemption, the new one wont. Its part of the this_cpu feature
set to make debugging impossible.

> +#else
> +#define kstat_cpu(cpu) per_cpu(kstat, cpu)
> +#define kstat_this_cpu (&__get_cpu_var(kstat))
> +#endif
>  
>  extern unsigned long long nr_context_switches(void);
>  
> @@ -52,8 +62,8 @@ struct irq_desc;
>  static inline void kstat_incr_irqs_this_cpu(unsigned int irq,
>                                             struct irq_desc *desc)
>  {
> -       __this_cpu_inc(kstat.irqs[irq]);
> -       __this_cpu_inc(kstat.irqs_sum);
> +       kstat_this_cpu->irqs[irq]++;
> +       kstat_this_cpu->irqs_sum++;

It might be worth looking at the asm output of that, I think you made it
worse, but I'm not quite sure how smart gcc is, it might just figure out
what you meant.

>  } 
