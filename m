Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab0IWD6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 23:58:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50745 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600Ab0IWD4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 23:56:09 -0400
X-Authority-Analysis: v=1.1 cv=GglhOq9PVtWDmzXFaQc2b9ix+3dKCE90LyQFAZ1FxMQ= c=1 sm=0 a=psu0DXbS6mkA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=rts_7bUoPt5dgaVSQ2UA:9 a=_52qpH_b1W8qyDsWck0A:7 a=rq2Rf6fPHzSXtX4v9iuU83sGB6gA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20100923035608.469217320@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 22 Sep 2010 23:49:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <compudj@krystal.dyndns.org>,
        Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>,
        David Miller <davem@davemloft.net>
Subject: [PATCH 04/11] jump label: Initialize workqueue tracepoints *before* they are registered
References: <20100923034910.867858597@goodmis.org>
Content-Disposition: inline; filename=0004-jump-label-Initialize-workqueue-tracepoints-before-t.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

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
-- 
1.7.1


