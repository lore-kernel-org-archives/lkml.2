Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab0IAT2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 15:28:48 -0400
Received: from mail.openrapids.net ([64.15.138.104]:49971 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755017Ab0IAT2r convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 15:28:47 -0400
Date: Wed, 1 Sep 2010 15:28:44 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: ltt-dev@lists.casi.polymtl.ca,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jason Baron <jbaron@redhat.com>
Subject: [PATCH for -tip] Notifiers: atomic notifier "notrace" call chain
Message-ID: <20100901192844.GA28116@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 15:07:15 up 221 days, 21:44,  4 users,  load average: 0.00, 0.01,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The impact of this patch is that the RCU read-side is now marked "notrace" in
the atomic call chain notifier. It also switch this atomic notifier call chain
from RCU to "sched RCU". Disabling preemption in the atomic notifier does not
have any significant side-effect, because atomic notifiers already expect to
execute in atomic context. The notifier unregistration is adapted to use "sched
RCU".

The "Generic Ring Buffer Library" needs to be able to use the atomic notifier
from cpu idle entry. The aim is to ensure the ring buffer makes the last events
ready for reading before the CPU goes idle. This is required by the Generic Ring
Buffer Library because it uses deferrable timers for trace streaming.

This is also useful to the die notifier, which makes breakpoint insertion valid
in more code paths.

I submit this patch for inclusion in -tip. Meanwhile, I will add this patch to
the tip-pull-queue in the ringbuffer git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/compudj/linux-2.6-ringbuffer.git
branch: tip-pull-queue

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Masami Hiramatsu <mhiramat@redhat.com>
CC: Jason Baron <jbaron@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/notifier.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6-lttng/kernel/notifier.c
===================================================================
--- linux-2.6-lttng.orig/kernel/notifier.c	2009-11-12 17:58:56.000000000 -0500
+++ linux-2.6-lttng/kernel/notifier.c	2009-11-12 18:03:28.000000000 -0500
@@ -148,7 +148,7 @@ int atomic_notifier_chain_unregister(str
 	spin_lock_irqsave(&nh->lock, flags);
 	ret = notifier_chain_unregister(&nh->head, n);
 	spin_unlock_irqrestore(&nh->lock, flags);
-	synchronize_rcu();
+	synchronize_sched();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(atomic_notifier_chain_unregister);
@@ -178,9 +178,9 @@ int __kprobes __atomic_notifier_call_cha
 {
 	int ret;
 
-	rcu_read_lock();
+	rcu_read_lock_sched_notrace();
 	ret = notifier_call_chain(&nh->head, val, v, nr_to_call, nr_calls);
-	rcu_read_unlock();
+	rcu_read_unlock_sched_notrace();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(__atomic_notifier_call_chain);
-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
