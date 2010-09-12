Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab0ILUhP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 16:37:15 -0400
Received: from mail.openrapids.net ([64.15.138.104]:46639 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753530Ab0ILUhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 16:37:14 -0400
Date: Sun, 12 Sep 2010 16:37:12 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [RFC patch 1/2] sched: dynamically adapt granularity with
	nr_running
Message-ID: <20100912203712.GD32327@Krystal>
References: <20100911173732.551632040@efficios.com> <20100911174003.051303123@efficios.com> <1284231470.2251.52.camel@laptop> <20100911195708.GA9273@Krystal> <1284288072.2251.91.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284288072.2251.91.camel@laptop>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 16:35:55 up 232 days, 23:12,  4 users,  load average: 0.21, 0.11,
	0.02
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Sat, 2010-09-11 at 15:57 -0400, Mathieu Desnoyers wrote:
> > The interesting part is in the range from 4 to 8 tasks. I diminish the scheduler
> > granularity as the number of tasks increases rather than increasing latency.
> > This leads to more scheduler preemptions than usual, but only in the 4-8 running
> > tasks range. 
> 
> I really don't get it.. that's exactly what it does from the 1..3 range
> too, if you want to extend that, simply set a lower min_gran, it will
> update nr_latency and you get it from 1..(latency/min_gran) range.
> 
> And you didn't touch sched_proc_update_handler(), which recomputes
> sched_nr_latency when you change sched_latency or sched_min_gran.
> 
> So the current stuff is:
> 
>   period := max(latency, min_gran * nr_running)
> 
> or, conversely:
> 
>   gran := max(min_gran, latency / nr_running)
> 
> Which seems to be exactly what you want, no? Its doing that!
> 
> Except that in the one place we used 'gran' directly we avoided the
> division and used the minimal value: min_gran in all cases, which is a
> trade-of favouring latency.

The whole point of my patch is not to have to do this latency vs performance
tradeoff for low number of running threads. With your approach, lowering the
granularity even when there are few threads running will very likely hurt
performance, no ?

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
