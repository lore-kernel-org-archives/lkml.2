Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138Ab1CXRtA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 13:49:00 -0400
Received: from flusers.ccur.com ([173.221.59.2]:29460 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756542Ab1CXRs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 13:48:57 -0400
Date: Thu, 24 Mar 2011 13:48:03 -0400
From: Joe Korty <joe.korty@ccur.com>
To: paulmck@linux.vnet.ibm.com
Cc: fweisbec@gmail.com, peterz@infradead.org, laijs@cn.fujitsu.com,
        mathieu.desnoyers@efficios.com, dhowells@redhat.com,
        loic.minier@linaro.org, dhaval.giani@gmail.com, tglx@linutronix.de,
        josh@joshtriplett.org, houston.jim@comcast.net, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 19/24] jrcu: bugfix: init cpu wait state on every scan
Message-ID: <20110324174803.GA18936@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jrcu: re-init cpu wait state on every scan, not just at
scans that mark beginning of batch.

This fixes a hard to hit bug.  To have a chance of hitting
it, these conditions must be true: we have a cpu running a
user application 100% of the time, not making any system
calls, and no interrupts of any type being delivered to
that cpu.

jrcu is designed to allow transitioning values of every
description to be fuzzy for a while before settling down.
Therefore, if a batch ends (and a new one starts) at about
the time a cpu is transitioning from a normal state to the
above mentioned user-dedicated state, the value the cpu
->wait state is set to will be somewhat random.  That is,
most of the time it will be correct but on occasion it
will take the opposite value.  This is OK, it is expected,
but for things to work we must periodically re-sample and
re-init the ->wait state so that later on, we will catch
the sampled value again, after it has become stable.

Without periodic re-sampling we could set ->wait =1 when it
should be =0, and once it is =1 it will stay =1 (because a
user-dedicated cpu crosses no quiescent point taps which
by definition would set ->wait =0).  JRCU thus stops
advancing batches until the watchdog fires and tickles
the offending cpu.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: b/kernel/jrcu.c
===================================================================
--- a/kernel/jrcu.c
+++ b/kernel/jrcu.c
@@ -319,8 +319,11 @@ static void __rcu_delimit_batches(struct
 	for_each_online_cpu(cpu) {
 		rd = &rcu_data[cpu];
 		if (rd->wait) {
-			eob = 0;
-			break;
+			rd->wait = preempt_count_cpu(cpu) > idle_cpu(cpu);
+			if (rd->wait) {
+				eob = 0;
+				break;
+			}
 		}
 	}
 
