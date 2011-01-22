Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab1AVJn2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 04:43:28 -0500
Received: from www.tglx.de ([62.245.132.106]:46026 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204Ab1AVJn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 04:43:26 -0500
Date: Sat, 22 Jan 2011 10:43:17 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vernon Mauery <vernux@us.ibm.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Wait to remove active timer when rescheduling hrtimer
In-Reply-To: <AANLkTinG5RmVERMKWFaJRNki+1NGbLLWudc2jtw=igPV@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1101221031330.2971@localhost6.localdomain6>
References: <1295632350-10215-1-git-send-email-vernux@us.ibm.com> <alpine.LFD.2.00.1101212232210.2971@localhost6.localdomain6> <AANLkTinG5RmVERMKWFaJRNki+1NGbLLWudc2jtw=igPV@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jan 2011, Vernon Mauery wrote:
> > Hmm, why does it hang ?
> 
> 
> After running the script, I run a netperf command similar to the one
> that the script prints, that runs traffic over the interface that we
> just set up QoS on.  Within 10-15 seconds, the machine goes silent.
> (this is on a 2.6.33.7-rt29 kernel)
> 
> My guess would be that without this patch, it is possible to have a
> timer currently in the tree, not delete it and then schedule it again.
>  Not on this machine or on this kernel, I saw a similar problem
> (caused by the same thing: using sch_htb on -rt kernel), but instead
> of a silent hang, it gave me an oops that looked like this:
>
>  [<ffffffff81054dfc>] __remove_hrtimer+0x6e/0x7b
>  [<ffffffff81227401>] ? qdisc_watchdog+0x0/0x23
>  [<ffffffff81055cbb>] run_hrtimer_softirq+0x7a/0x14e
>  [<ffffffff81043d26>] ksoftirqd+0x16a/0x26f
>  [<ffffffff81043bbc>] ? ksoftirqd+0x0/0x26f
>  [<ffffffff81043bbc>] ? ksoftirqd+0x0/0x26f
>  [<ffffffff8105261c>] kthread+0x49/0x79
>  [<ffffffff8100d088>] child_rip+0xa/0x12
>  [<ffffffff810525d3>] ? kthread+0x0/0x79
>  [<ffffffff8100d07e>] ? child_rip+0x0/0x12

 
> Any ideas on this?  The patch I sent fixes the problem.  The idea came
> from a proposed patch a long time ago that just added a hrtimer_cancel
> call just before the hrtimer_start call in the sch_api.c watchdog
> code.  I figured if the explicit cancel before the start fixed the
> problem, there was something that the cancel did that the start alone
> didn't.  What I found was that the cancel waits if the timer is
> currently running, while start just brute-force cancels the timer.

Hmm. That's weird. The remove in start() and in the softirq code is
protected by the base lock. So whoever comes first, removes the
timer. So if the timer call back runs then the remove in start() will
be a noop. And if the timer is removed right before the softirq wants
to run the callback then the softirq wont see it anymore.

So I fear while your patch makes the hang/oops go away it is papering
over the real bug. Can you try to reproduce with function tracing (add
timer events as well) enabled ? If yes, set ftrace_dump_on_oops. So we
should see the history which led to this problem.

Thanks,

	tglx
