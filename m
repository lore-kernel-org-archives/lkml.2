Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab0INRqZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 13:46:25 -0400
Received: from mail.openrapids.net ([64.15.138.104]:58501 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752113Ab0INRqY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 13:46:24 -0400
Date: Tue, 14 Sep 2010 13:46:21 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>
Subject: Re: [RFC PATCH] sched: START_NICE feature (temporarily niced forks)
Message-ID: <20100914174621.GA28620@Krystal>
References: <20100914070718.GA25117@Krystal> <20100914174345.GB3822@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20100914174345.GB3822@elte.hu>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 13:44:23 up 234 days, 20:21,  4 users,  load average: 0.21, 0.15,
	0.10
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
> > This patch tweaks the nice value of both the parent and the child 
> > after a fork to a higher nice value, but this is only applied to their 
> > first slice after the fork. The goal of this scheme is that their 
> > respective vruntime will increment faster in the first slice after the 
> > fork, so a workload doing many forks (e.g. make -j10) will have a 
> > limited impact on latency-sensitive workloads.
> > 
> > This is an alternative to START_DEBIT which does not have the downside 
> > of moving newly forked threads to the end of the runqueue.
> > 
> > Latency benchmark:
> > 
> > * wakeup-latency.c (SIGEV_THREAD) with make -j10 on UP 2.0GHz
> > 
> > Kernel used: mainline 2.6.35.2 with smaller min_granularity and check_preempt
> > vruntime vs runtime comparison patches applied.
> > 
> > - START_DEBIT (vanilla setting)
> > 
> > maximum latency: 26409.0 탎
> > average latency: 6762.1 탎
> > missed timer events: 0
> > 
> > - NO_START_DEBIT, NO_START_NICE
> > 
> > maximum latency: 10001.8 탎
> > average latency: 1618.7 탎
> > missed timer events: 0
> 
> Tempting ...
> 
> > 
> > - START_NICE
> > 
> > maximum latency: 9873.9 탎
> > average latency: 901.2 탎
> > missed timer events: 0
> 
> Even more tempting! :)
> 
> > On the Xorg interactivity aspect, I notice a major improvement with 
> > START_NICE compared to the two other settings. I just came up with a 
> > very simple repeatable low-tech test that takes into account both 
> > input and video update responsiveness:
> > 
> > Start make -j10 in a gnome-terminal In another gnome-terminal, start 
> > pressing the space bar, holding it. Use the cursor speed (my cursor is 
> > a full rectangle) as latency indicator. With low latency, its speed 
> > should be constant, no stopping and no sudden acceleration.
> 
> You may want to run this by Mike - he's the expert on finding 
> interactivity corner-case workloads with scheduler patches. Mike,
> got time to try out Mathieu's patch?

I'm working on a new version at the moment. The previous one had a few bugs in
it when it comes to weight updates, and I fear some of the latency improvements
I've seen were caused by the whole build process ending up being niced all the
time. I'm currently working on a "simplified but not optimal" version, with
added sched_debug output, to make sure I get it right.

I'll keep you posted.

Thanks!

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
