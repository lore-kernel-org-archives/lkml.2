Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab1CaKhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 06:37:48 -0400
Received: from ist.d-labs.de ([213.239.218.44]:48932 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478Ab1CaKhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 06:37:47 -0400
From: Florian Mickler <florian@mickler.org>
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org, rdunlap@xenotime.net,
        linux-doc@vger.kernel.org, Florian Mickler <florian@mickler.org>
Subject: [PATCH] workqueue: document debugging tricks
Date: Thu, 31 Mar 2011 12:37:06 +0200
Message-Id: <1301567826-6116-1-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <20110331065642.GA3385@htj.dyndns.org>
References: <20110331065642.GA3385@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not obvious how to debug run-away workers.

These are some tips given by Tejun on lkml.

Signed-off-by: Florian Mickler <florian@mickler.org>
CC: Tejun Heo <tj@kernel.org>
---
 Documentation/workqueue.txt |   38 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/Documentation/workqueue.txt b/Documentation/workqueue.txt
index 01c513f..cdbc3c6 100644
--- a/Documentation/workqueue.txt
+++ b/Documentation/workqueue.txt
@@ -12,6 +12,7 @@ CONTENTS
 4. Application Programming Interface (API)
 5. Example Execution Scenarios
 6. Guidelines
+7. Debugging
 
 
 1. Introduction
@@ -379,3 +380,40 @@ If q1 has WQ_CPU_INTENSIVE set,
 * Unless work items are expected to consume a huge amount of CPU
   cycles, using a bound wq is usually beneficial due to the increased
   level of locality in wq operations and work item execution.
+
+
+7. Debugging
+
+Because the work functions are executed by generic worker threads there are a
+few tricks needed to shed some light on misbehaving workqueue users.
+
+Worker threads show up in the process list as:
+
+root      5671  0.0  0.0      0     0 ?        S    12:07   0:00 [kworker/0:1]
+root      5672  0.0  0.0      0     0 ?        S    12:07   0:00 [kworker/1:2]
+root      5673  0.0  0.0      0     0 ?        S    12:12   0:00 [kworker/0:0]
+root      5674  0.0  0.0      0     0 ?        S    12:13   0:00 [kworker/1:0]
+
+If kworkers are going crazy (using too much cpu), there are two types of
+possible problems:
+
+	1. Something beeing scheduled in rapid succession
+	2. a single work item that consumes lots of cpu cycles
+
+The first one can be tracked using tracing:
+
+	$ echo workqueue:workqueue_queue_work > /sys/kernel/debug/tracing/set_event
+	$ cat /sys/kernel/debug/tracing/trace_pipe > out.txt
+	(wait a few secs)
+	^C
+
+If something is busy looping on work queueing, it would be dominating
+the output and the offender can be determined with the work item
+function.
+
+For the second type of problem it should be possible to just check the stack
+trace of the offending worker thread.
+
+	$ cat /proc/THE_OFFENDING_KWORKER/stack
+
+The work item's function should be trivially visible in the stack trace.
-- 
1.7.4.1

