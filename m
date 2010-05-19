Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab0ESQY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 12:24:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754041Ab0ESQXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 12:23:00 -0400
Date: Wed, 19 May 2010 12:22:21 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
       fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
       vgoyal@redhat.com
Message-Id: <640f800a9493bf62064774263f3e6d77dbaf20fe.1274283321.git.jbaron@redhat.com>
In-Reply-To: <cover.1274283321.git.jbaron@redhat.com>
References: <cover.1274283321.git.jbaron@redhat.com>
Subject: [PATCH 08/13] jump label v8: initialize workqueue tracepoints *before* they are registered
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
index cc2d2fa..7705ad4 100644
--- a/kernel/trace/trace_workqueue.c
+++ b/kernel/trace/trace_workqueue.c
@@ -259,6 +259,11 @@ int __init trace_workqueue_early_init(void)
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
@@ -275,11 +280,6 @@ int __init trace_workqueue_early_init(void)
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

