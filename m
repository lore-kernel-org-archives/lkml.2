Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351Ab0DITud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 15:50:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756535Ab0DITu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 15:50:28 -0400
Date: Fri, 9 Apr 2010 15:50:03 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
       fweisbec@gmail.com, avi@redhat.com
Message-Id: <e9cf60b7a01690cef53a3fc05a8e94ac2b9bd12d.1270839564.git.jbaron@redhat.com>
In-Reply-To: <cover.1270839564.git.jbaron@redhat.com>
References: <cover.1270839564.git.jbaron@redhat.com>
Subject: [PATCH 8/9] jump label: initialize workqueue tracepoints *before* they are registered
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize the workqueue data structures *before* they are registered
so that they are ready for callbacks.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 kernel/trace/trace_workqueue.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index 40cafb0..487d821 100644
--- a/kernel/trace/trace_workqueue.c
+++ b/kernel/trace/trace_workqueue.c
@@ -258,6 +258,11 @@ int __init trace_workqueue_early_init(void)
 {
 	int ret, cpu;
 
+	for_each_possible_cpu(cpu) {
+		spin_lock_init(&workqueue_cpu_stat(cpu)->lock);
+		INIT_LIST_HEAD(&workqueue_cpu_stat(cpu)->list);
+	}
+
 	ret = register_trace_workqueue_insertion(probe_workqueue_insertion);
 	if (ret)
 		goto out;
@@ -274,11 +279,6 @@ int __init trace_workqueue_early_init(void)
 	if (ret)
 		goto no_creation;
 
-	for_each_possible_cpu(cpu) {
-		spin_lock_init(&workqueue_cpu_stat(cpu)->lock);
-		INIT_LIST_HEAD(&workqueue_cpu_stat(cpu)->list);
-	}
-
 	return 0;
 
 no_creation:
-- 
1.7.0.1

