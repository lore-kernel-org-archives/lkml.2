Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab0HZSP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:15:59 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:38818 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000Ab0HZSOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:14:41 -0400
Message-Id: <20100826180908.648103531@efficios.com>
User-Agent: quilt/0.48-1
Date: Thu, 26 Aug 2010 14:09:08 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tony Lindgren <tony@atomide.com>, Mike Galbraith <efault@gmx.de>
Subject: [RFC PATCH 00/11] sched: CFS low-latency features
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu, 26 Aug 2010 18:13:39 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Following the findings I presented a few months ago
(http://lkml.org/lkml/2010/4/18/13) about CFS having large vruntime spread
issues, Peter Zijlstra and I pursued the discussion and the implementation
effort (my work on this is funded by Nokia). I recently put the result together
and came up with this patchset, combining both his work and mine.

With this patchset, I got the following results with wakeup-latency.c (a 10ms
periodic timer), running periodic-fork.sh, Xorg, make -j3 and firefox (playing a
youtube video), with Xorg moving terminal windows around, in parallel on a UP
system (links to the test program source in the dyn min_vruntime patch). The
Xorg interactivity is very good with the new features enabled, but was poor
originally with the vanilla mainline scheduler. The 10ms timer delays are as
follow:

                         2.6.35.2 mainline*   with low-latency features**
maximum latency:                34465.2 µs                    8261.4 µs
average latency:                 6445.5 µs                     211.2 µs
missed timer events:                yes                           no

* 2.6.35.2 mainline test needs to run periodic-fork.sh for a few minutes first
  to let it rip the spread apart.

** low-latency features:

with the patchset applied and CONFIG_SCHED_DEBUG=y
(with debugfs mounted in /sys/debugfs)

for opt in DYN_MIN_VRUNTIME \
        NO_FAIR_SLEEPERS FAIR_SLEEPERS_INTERACTIVE FAIR_SLEEPERS_TIMER \
        INTERACTIVE TIMER \
        INTERACTIVE_FORK_EXPEDITED TIMER_FORK_EXPEDITED;
do echo $opt > /sys/debugfs/sched_features;
done

These patches are designed to allow individual enabling of each feature and to
make sure that the object size of sched.o does not grow when the features are
disabled on a CONFIG_SCHED_DEBUG=n kernel. Optimization of the try_to_wake_up()
fast path when features are enabled could be done later by merging some of these
features together. This patchset is based on 2.6.35.2.

Feedback is welcome,

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
