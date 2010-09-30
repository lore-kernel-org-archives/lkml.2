Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab0I3LGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 07:06:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56342 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab0I3LGV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 07:06:21 -0400
Subject: Re: [PATCH 3/7] Add IRQ_TIME_ACCOUNTING, finer accounting of irq
 time -v3
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <1285788096-29471-4-git-send-email-venki@google.com>
References: <1285788096-29471-1-git-send-email-venki@google.com>
	 <1285788096-29471-4-git-send-email-venki@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 30 Sep 2010 13:06:08 +0200
Message-ID: <1285844768.2144.11.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-29 at 12:21 -0700, Venkatesh Pallipadi wrote:
> +void account_system_vtime(struct task_struct *curr)
> +{
> +       unsigned long flags;
> +       int cpu;
> +       u64 now, delta;
> +
> +       if (!sched_clock_irqtime)
> +               return;
> +
> +       local_irq_save(flags);
> +
> +       now = sched_clock();
> +       cpu = smp_processor_id();

Like said before, that really wants to read like:

	cpu = smp_processor_id();
	now = sched_clock_cpu(cpu);

sched_clock() is raw tsc + ns conversion and can go all over the place.

> +       delta = now - per_cpu(irq_start_time, cpu);
> +       per_cpu(irq_start_time, cpu) = now;
> +       if (hardirq_count())
> +               per_cpu(cpu_hardirq_time, cpu) += delta;
> +       else if (in_serving_softirq())
> +               per_cpu(cpu_softirq_time, cpu) += delta;
> +
> +       local_irq_restore(flags);
> +} 
