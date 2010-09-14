Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab0INRoC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 13:44:02 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56957 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499Ab0INRoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 13:44:00 -0400
Date: Tue, 14 Sep 2010 19:43:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>
Subject: Re: [RFC PATCH] sched: START_NICE feature (temporarily niced forks)
Message-ID: <20100914174345.GB3822@elte.hu>
References: <20100914070718.GA25117@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100914070718.GA25117@Krystal>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0330]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> This patch tweaks the nice value of both the parent and the child 
> after a fork to a higher nice value, but this is only applied to their 
> first slice after the fork. The goal of this scheme is that their 
> respective vruntime will increment faster in the first slice after the 
> fork, so a workload doing many forks (e.g. make -j10) will have a 
> limited impact on latency-sensitive workloads.
> 
> This is an alternative to START_DEBIT which does not have the downside 
> of moving newly forked threads to the end of the runqueue.
> 
> Latency benchmark:
> 
> * wakeup-latency.c (SIGEV_THREAD) with make -j10 on UP 2.0GHz
> 
> Kernel used: mainline 2.6.35.2 with smaller min_granularity and check_preempt
> vruntime vs runtime comparison patches applied.
> 
> - START_DEBIT (vanilla setting)
> 
> maximum latency: 26409.0 탎
> average latency: 6762.1 탎
> missed timer events: 0
> 
> - NO_START_DEBIT, NO_START_NICE
> 
> maximum latency: 10001.8 탎
> average latency: 1618.7 탎
> missed timer events: 0

Tempting ...

> 
> - START_NICE
> 
> maximum latency: 9873.9 탎
> average latency: 901.2 탎
> missed timer events: 0

Even more tempting! :)

> On the Xorg interactivity aspect, I notice a major improvement with 
> START_NICE compared to the two other settings. I just came up with a 
> very simple repeatable low-tech test that takes into account both 
> input and video update responsiveness:
> 
> Start make -j10 in a gnome-terminal In another gnome-terminal, start 
> pressing the space bar, holding it. Use the cursor speed (my cursor is 
> a full rectangle) as latency indicator. With low latency, its speed 
> should be constant, no stopping and no sudden acceleration.

You may want to run this by Mike - he's the expert on finding 
interactivity corner-case workloads with scheduler patches. Mike,
got time to try out Mathieu's patch?

	Ingo
