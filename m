Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038Ab0ITRXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 13:23:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36756 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756030Ab0ITRX3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 13:23:29 -0400
Subject: Re: [PATCH 2/6] Add IRQ_TIME_ACCOUNTING, finer accounting of CPU
 irq time
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>
In-Reply-To: <AANLkTinu+2N7xnkuzMvhL+3V=vbRMDNT6ep-OHPrbT4y@mail.gmail.com>
References: <1284688596-6731-1-git-send-email-venki@google.com>
	 <1284688596-6731-3-git-send-email-venki@google.com>
	 <1284894708.2275.607.camel@laptop>
	 <AANLkTinu+2N7xnkuzMvhL+3V=vbRMDNT6ep-OHPrbT4y@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 20 Sep 2010 19:23:12 +0200
Message-ID: <1285003392.2275.755.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-20 at 10:13 -0700, Venkatesh Pallipadi wrote:

> >> +       local_irq_save(flags);
> >> +
> >> +       cpu = task_cpu(tsk);
> >
> > Can this ever be anything other can smp_processor_id() and current?
> >
> >> +       now = sched_clock();
> >
> > this should be using one of the kernel/sched_clock.c thingies, probably
> > local_clock(), or sched_clock_cpu(cpu).
> 
> I don't really need task there. I can use smp_processor_id() or
> task_cpu(tsk) and I think latter one would be cheaper.

Not sure, task_cpu() gets the cpu number from the task_info struct,
smp_processor_id() gets it from per-cpu storage, both are a single
memory read.

But I think its a tad confusing that this function has a task argument
at all, but if its always current, it would be slightly better to call
it 'curr' or something.

Also, local_irq_safe() followed by smp_processor_id() is clearly local,
task_cpu(tsk) can be anything.

> You mean sched_clock() is not the right interface to use here.
> sched_clock_cpu() uses either sched_clock or remote_cpu stuff which I
> don't really need here and local_clock() also has irq
> disable/smp_processor_id() and calls sched_clock_cpu in turn.
> sched_clock() seemed to be more appropriate.

yeah, use sched_clock_cpu(smp_processor_id()), sched_clock() can be
utter crap on x86, the code in kernel/sched_clock.c tries its best to
sanitize the crap we get from the hardware.



