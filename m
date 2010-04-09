Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364Ab0DITtw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 15:49:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756339Ab0DITtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 15:49:50 -0400
Date: Fri, 9 Apr 2010 15:49:20 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
       fweisbec@gmail.com, avi@redhat.com
Message-Id: <b4a73181d8da704ecaf0e4570caf577a205d8fd1.1270839564.git.jbaron@redhat.com>
In-Reply-To: <cover.1270839564.git.jbaron@redhat.com>
References: <cover.1270839564.git.jbaron@redhat.com>
Subject: [PATCH 1/9] jump label: notifier atomic call chain notrace
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In LTTng, being able to use the atomic notifier from cpu idle entry to
ensure the tracer flush the last events in the current subbuffer
requires the rcu read-side to be marked "notrace", otherwise it can end
up calling back into lockdep and the tracer.

Also apply to the the die notifier.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Jason Baron <jbaron@redhat.com>
Reviewed-by: Masami Hiramatsu <mhiramat@redhat.com>
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
1.7.0.1

