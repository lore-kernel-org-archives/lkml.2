Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab0IXI76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 04:59:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:35428 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438Ab0IXI75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 04:59:57 -0400
Date: Fri, 24 Sep 2010 08:59:40 GMT
From: tip-bot for Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, jbaron@redhat.com
In-Reply-To: <e3a3383fc370ac7086625bebe89d9480d7caf372.1284733808.git.jbaron@redhat.com>
References: <e3a3383fc370ac7086625bebe89d9480d7caf372.1284733808.git.jbaron@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] jump label: Initialize workqueue tracepoints *before* they are registered
Message-ID: <tip-e0cf0cd49632552f063fb3ae58691946da45fb2e@git.kernel.org>
Git-Commit-ID: e0cf0cd49632552f063fb3ae58691946da45fb2e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 24 Sep 2010 08:59:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e0cf0cd49632552f063fb3ae58691946da45fb2e
Gitweb:     http://git.kernel.org/tip/e0cf0cd49632552f063fb3ae58691946da45fb2e
Author:     Jason Baron <jbaron@redhat.com>
AuthorDate: Fri, 17 Sep 2010 11:09:04 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 22 Sep 2010 16:30:03 -0400

jump label: Initialize workqueue tracepoints *before* they are registered

Initialize the workqueue data structures *before* they are registered
so that they are ready for callbacks.

Signed-off-by: Jason Baron <jbaron@redhat.com>
LKML-Reference: <e3a3383fc370ac7086625bebe89d9480d7caf372.1284733808.git.jbaron@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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
