Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab0CVQHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 12:07:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020Ab0CVQHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 12:07:46 -0400
Date: Mon, 22 Mar 2010 12:07:20 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
       fweisbec@gmail.com
Message-Id: <48e5099e36e4e69d0671e4c16fa8c2f5f3cf5d59.1269272444.git.jbaron@redhat.com>
In-Reply-To: <cover.1269272444.git.jbaron@redhat.com>
References: <cover.1269272444.git.jbaron@redhat.com>
Subject: [PATCH 1/5] jump label: notifier atomic call chain notrace
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

In LTTng, being able to use the atomic notifier from cpu idle entry to
ensure the tracer flush the last events in the current subbuffer
requires the rcu read-side to be marked "notrace", otherwise it can end
up calling back into lockdep and the tracer.

Also apply to the the die notifier.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 kernel/notifier.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/notifier.c b/kernel/notifier.c
index 2488ba7..88453a7 100644
--- a/kernel/notifier.c
+++ b/kernel/notifier.c
@@ -148,7 +148,7 @@ int atomic_notifier_chain_unregister(struct atomic_notifier_head *nh,
 	spin_lock_irqsave(&nh->lock, flags);
 	ret = notifier_chain_unregister(&nh->head, n);
 	spin_unlock_irqrestore(&nh->lock, flags);
-	synchronize_rcu();
+	synchronize_sched();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(atomic_notifier_chain_unregister);
@@ -178,9 +178,9 @@ int __kprobes __atomic_notifier_call_chain(struct atomic_notifier_head *nh,
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
1.6.5.1

