Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435Ab0HQXY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 19:24:57 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:47067 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052Ab0HQXXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 19:23:34 -0400
Message-Id: <20100817232150.509599208@efficios.com>
User-Agent: quilt/0.48-1
Date: Tue, 17 Aug 2010 19:16:21 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: ltt-dev@lists.casi.polymtl.ca,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>
Subject: [RFC PATCH 02/20] Notifier atomic call chain notrace
References: <20100817231619.277457797@efficios.com>
Content-Disposition: inline; filename=notifier-atomic-call-chain-notrace.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Tue, 17 Aug 2010 23:21:50 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Being able to use the atomic notifier from cpu idle entry to ensure the tracer
flush the last events in the current subbuffer requires the rcu read-side to be
marked "notrace".

Also apply to the the die notifier.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Masami Hiramatsu <mhiramat@redhat.com>
CC: Jason Baron <jbaron@redhat.com>
CC: mingo@elte.hu
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

