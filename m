Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab0DRNNK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 09:13:10 -0400
Received: from mail.openrapids.net ([64.15.138.104]:43090 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752144Ab0DRNNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 09:13:08 -0400
Date: Sun, 18 Apr 2010 09:13:02 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jarkko Nikula <jhnikula@gmail.com>, Tony Lindgren <tony@atomide.com>,
       linux-kernel@vger.kernel.org
Subject: [RFC patch] CFS fix place entity spread issue (v2)
Message-ID: <20100418131302.GA3614@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 09:11:49 up 85 days, 15:48,  3 users,  load average: 0.01, 0.01,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CFS fix place entity spread issue (v2)

Huge CFS vruntime spread (18 minutes) has been observed with LTTng while simply
running Xorg on a uniprocessor machine. Detailed explanation in my ELC2010
presentation at:

http://www.efficios.com/elc2010

(includes slides, ad-hoc CFS instrumentation patches and wakeup latency test
program)

Changelog since v1:

* Keep max(se->vruntime, vruntime). It's needed to ensure that tasks already
  within the spread window do not get an extra unfair vruntime boost just
  because they slept.

I've torn the CFS scheduler apart in the past days to figure out what is causing
this weird behavior, and the culprit seems to be place_entity(). The problem
appears to be the cumulative effect of letting the min_vruntime go backward when
putting sleepers back on the runqueue. It lets the vruntime spread grow to
"entertaining" values (it is supposed to be in the 5ms range, not 18 minutes!).

In the original code, a max between the sched entity vruntime and the calculated
vruntime was supposed to "ensure that the thread time never go backward". But I
don't see why we even care about that. The key point is that the min_vruntime
of the runqueue should not go backward.

I propose to fix this by calculating the relative offset from
min_vruntime + sysctl_sched_latency rather than directly from min_vruntime. I
also ensure that the value never goes below min_vruntime.

Under the Xorg workload, moving a few windows around and starting firefox while
executing the wakeup-latency.c program (program waking up every 10ms and
reporting wakeup latency), this patch brings worse latency from 60ms down to
12ms. Even doing a kernel compilation at the same time, the worse latency stays
around 20ms now.

I'm submitting this patch ASAP, since it seems to fix CFS issues that many
people have been complaining about. I'm sending it as RFC because testing its
effect on more workloads would be welcome.

I can see that place_entity() has stayed more or less the same since 2.6.24 (and
maybe even before, as code has just been reorganised between 2.6.23 and 2.6.24),
so we can expect this to be a problem people have been experiencing for a while.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Mike Galbraith <efault@gmx.de>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Greg Kroah-Hartman <greg@kroah.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Jarkko Nikula <jhnikula@gmail.com>
CC: Tony Lindgren <tony@atomide.com>
---
 kernel/sched_fair.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

Index: linux-2.6-lttng.git/kernel/sched_fair.c
===================================================================
--- linux-2.6-lttng.git.orig/kernel/sched_fair.c	2010-04-18 01:48:04.000000000 -0400
+++ linux-2.6-lttng.git/kernel/sched_fair.c	2010-04-18 08:58:30.000000000 -0400
@@ -738,6 +738,14 @@
 		unsigned long thresh = sysctl_sched_latency;
 
 		/*
+		 * Place the woken up task relative to
+		 * min_vruntime + sysctl_sched_latency.
+		 * We must _never_ decrement min_vruntime, because the effect is
+		 * that spread increases progressively under the Xorg workload.
+		 */
+		vruntime += sysctl_sched_latency;
+
+		/*
 		 * Convert the sleeper threshold into virtual time.
 		 * SCHED_IDLE is a special sub-class.  We care about
 		 * fairness only relative to other SCHED_IDLE tasks,
@@ -755,6 +763,9 @@
 			thresh >>= 1;
 
 		vruntime -= thresh;
+
+		/* ensure min_vruntime never go backwards. */
+		vruntime = max_t(u64, vruntime, cfs_rq->min_vruntime);
 	}
 
 	/* ensure we never gain time by being placed backwards. */
-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
