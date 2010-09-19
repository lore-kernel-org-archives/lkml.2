Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab0ISLVq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 07:21:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:45248 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab0ISLVp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 07:21:45 -0400
Subject: Re: [PATCH 2/6] Add IRQ_TIME_ACCOUNTING, finer accounting of CPU
 irq time
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>
In-Reply-To: <1284688596-6731-3-git-send-email-venki@google.com>
References: <1284688596-6731-1-git-send-email-venki@google.com>
	 <1284688596-6731-3-git-send-email-venki@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 19 Sep 2010 13:21:31 +0200
Message-ID: <1284895291.2275.617.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-16 at 18:56 -0700, Venkatesh Pallipadi wrote:
> +void account_system_vtime(struct task_struct *tsk)
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
> +       cpu = task_cpu(tsk);
> +       now = sched_clock();
> +       delta = now - per_cpu(irq_start_time, cpu);
> +       per_cpu(irq_start_time, cpu) = now;
> +       if (hardirq_count())
> +               per_cpu(cpu_hardirq_time, cpu) += delta;
> +       else if (softirq_count())
> +               per_cpu(cpu_softirq_time, cpu) += delta;
> +
> +       local_irq_restore(flags);
> +} 

This seems to suggest you count time double if a hardirq hits while
we're doing softirqs, but being as this is an incomplete api its very
hard to tell indeed.
