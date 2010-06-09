Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758467Ab0FIVjt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 17:39:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758447Ab0FIVjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 17:39:46 -0400
Date: Wed, 9 Jun 2010 17:39:21 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
       fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
       vgoyal@redhat.com, sam@ravnborg.org
Message-Id: <cbfd94a3e39893951d101726aa9eb2fa548aec88.1276116186.git.jbaron@redhat.com>
In-Reply-To: <cover.1276116186.git.jbaron@redhat.com>
References: <cover.1276116186.git.jbaron@redhat.com>
Subject: [PATCH 08/13] jump label v9: initialize workqueue tracepoints *before* they are registered
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
index a7cc379..209b379 100644
--- a/kernel/trace/trace_workqueue.c
+++ b/kernel/trace/trace_workqueue.c
@@ -263,6 +263,11 @@ int __init trace_workqueue_early_init(void)
 {
 	int ret, cpu;
 
+	for_each_possible_cpu(cpu) {
+		spin_lock_init(&workqueue_cpu_stat(cpu)->lock);
+		INIT_LIST_HEAD(&workqueue_cpu_stat(cpu)->list);
+	}
+
 	ret = register_trace_workqueue_insertion(probe_workqueue_insertion, NULL);
 	if (ret)
 		goto out;
@@ -279,11 +284,6 @@ int __init trace_workqueue_early_init(void)
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
1.7.1

