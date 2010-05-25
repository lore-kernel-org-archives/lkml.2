Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178Ab0EYGfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 02:35:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:49122 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109Ab0EYGfa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 02:35:30 -0400
Subject: Re: [RFC PATCH 2/4] x86: Add IRQ_TIME_ACCOUNTING, finer accounting
 of irq time to task
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Paul Turner <pjt@google.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <1274746282-21533-3-git-send-email-venki@google.com>
References: <1274746282-21533-1-git-send-email-venki@google.com>
	 <1274746282-21533-2-git-send-email-venki@google.com>
	 <1274746282-21533-3-git-send-email-venki@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 25 May 2010 08:35:11 +0200
Message-ID: <1274769311.5882.96.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-24 at 17:11 -0700, Venkatesh Pallipadi wrote:
> +void account_system_vtime(struct task_struct *tsk)
> +{
> +       unsigned long flags;
> +       int cpu;
> +       u64 now;
> +
> +       local_irq_save(flags);
> +       cpu = task_cpu(tsk);
> +       now = sched_clock_cpu(cpu);
> +       if (hardirq_count())
> +               tsk->hi_time += now - per_cpu(irq_start_time, cpu);
> +       else if (softirq_count())
> +               tsk->si_time += now - per_cpu(irq_start_time, cpu);
> +
> +       per_cpu(irq_start_time, cpu) = now;
> +       local_irq_restore(flags);
> +} 

Right, so this gets called from irq_enter/exit() and __do_softirq().

The reason I never pressed onwards with this (I had patches to add IRQ
time accounting) is that it sucks terribly for anything falling back to
jiffies -- maybe find some smart way to disable the whole call when
there's no TSC available, preferably without adding conditionals, using
alternatives maybe?

I guess you mostly side-stepped that by adding a IRQ_TIME_ACCOUNTING
config (but forgot to make it depend on X86_TSC).

Another thing I dislike about this account_system_vtime() is that its
the same call for both IRQ and SoftIRQ, leaving us to add conditionals
inside the call to figure out what context we got called from.

[ Adedd the s390 and ppc guys who already use this stuff ]

Anyway, once we have this, please also add it to sched_rt_avg_update()
(which should really be called sched_!fair_avg_update()).

Also, did you measure the overhead of doing this? sched_clock_cpu() adds
a cmpxchg64 on all systems that don't have a rock solid TSC (ie. most of
todays machines).

Another thing that would be real nice is if you could find a way to not
make all of this x86 specific.
