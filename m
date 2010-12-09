Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab0LIS4F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 13:56:05 -0500
Received: from canuck.infradead.org ([134.117.69.58]:59203 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab0LIS4D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 13:56:03 -0500
Subject: Re: [BUG] 2.6.37-rc3 massive interactivity regression on ARM
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mikael Pettersson <mikpe@it.uu.se>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Stultz <johnstul@us.ibm.com>
In-Reply-To: <AANLkTin+eO_jPceSOHL4e7vqd+tf0ZCMHJ-USoz8aZL1@mail.gmail.com>
References: <20101208142814.GE9777@n2100.arm.linux.org.uk>
	 <1291851079-27061-1-git-send-email-venki@google.com>
	 <1291899120.29292.7.camel@twins>
	 <AANLkTikd3X4pLs5De-LO6=XD+JqUz3-Ku7YM8+0-oK8t@mail.gmail.com>
	 <1291917330.6803.7.camel@twins>
	 <AANLkTin+eO_jPceSOHL4e7vqd+tf0ZCMHJ-USoz8aZL1@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 09 Dec 2010 19:55:39 +0100
Message-ID: <1291920939.6803.38.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-09 at 10:11 -0800, Venkatesh Pallipadi wrote:
> On Thu, Dec 9, 2010 at 9:55 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Thu, 2010-12-09 at 09:43 -0800, Venkatesh Pallipadi wrote:
> >>
> >> The same problem will be there with below code, with irq_delta >
> >> delta, clock_task can go backwards which is not good.
> >> +       delta -= irq_delta;
> >> +       rq->clock_task += delta;
> >>
> >> The reason for this is rq->clock and irqtime updates kind of happen
> >> independently and specifically, if a rq->clock update happens while we
> >> are in a softirq, we may have this case of going backwards on the next
> >> update.
> >
> > But how can irq_delta > delta?, we measure it using the same clock.
> >
> 
> This would be mostly a corner case like:
> - softirq start time t1
> - rq->clock updated at t2 and rq->clock_task updated at t2 without
> accounting for current softirq
> - softirq end time t3
> - cpu spends most time here in softirq or hardirq
> - next rq->clock update at t4 and rq->clock_task update, with delta =
> t4-t2 and irq_delta ~= t4 - t1

Ah, something like that would happen when we do a wakeup from
soft/hard-irq context, not an altogether uncommon occurrence.

Wouldn't that be cured by updating the irq-time when asking for it,
something like the below? (on top of my earlier patch)

---
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -1843,8 +1843,9 @@ void account_system_vtime(struct task_st
 }
 EXPORT_SYMBOL_GPL(account_system_vtime);
 
-static inline u64 irq_time_cpu(int cpu)
+static u64 irq_time_cpu(int cpu)
 {
+	account_system_vtime(current);
 	return per_cpu(cpu_softirq_time, cpu) + per_cpu(cpu_hardirq_time, cpu);
 }
 

