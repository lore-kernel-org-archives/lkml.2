Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802Ab0HPUtD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 16:49:03 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48430 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756750Ab0HPUsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 16:48:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=BOqe4wSsTCl4nhlJOQWCvCESmHPTDoziG3IGjRY70nXQXe2ygF8UCN1Lz98LmpHFsG
         IjzdWvoL9Cy+DDZ2P4UdQaSbVH3Jlfdnnv8qQdTRKQ99NviqW9J+lcB36daZxaxYsW7L
         dqjGfy6PhptlPBJFUBei+S2uhAA5hWa5Aqm/I=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [RFC PATCH 6/6] perf: Humanize the number of contexts
Date: Mon, 16 Aug 2010 22:48:35 +0200
Message-Id: <1281991715-10367-7-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1281991715-10367-1-git-send-regression-fweisbec@gmail.com>
References: <1281991715-10367-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of hardcoding the number of contexts for the recursions
barriers, define a cpp constant to make the code more
self-explanatory.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
---
 include/linux/perf_event.h |   14 ++++++++------
 kernel/perf_event.c        |    6 +++---
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index d7e8ea6..ae6fa60 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -808,6 +808,12 @@ struct perf_event_context {
 	struct rcu_head			rcu_head;
 };
 
+/*
+ * Number of contexts where an event can trigger:
+ * 	task, softirq, hardirq, nmi.
+ */
+#define PERF_NR_CONTEXTS	4
+
 /**
  * struct perf_event_cpu_context - per cpu event context structure
  */
@@ -821,12 +827,8 @@ struct perf_cpu_context {
 	struct mutex			hlist_mutex;
 	int				hlist_refcount;
 
-	/*
-	 * Recursion avoidance:
-	 *
-	 * task, softirq, irq, nmi context
-	 */
-	int				recursion[4];
+	/* Recursion avoidance in each contexts */
+	int				recursion[PERF_NR_CONTEXTS];
 };
 
 struct perf_output_handle {
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 6ad61fb..e41e29b 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1767,7 +1767,7 @@ static u64 perf_event_read(struct perf_event *event)
  * Callchain support
  */
 
-static DEFINE_PER_CPU(int, callchain_recursion[4]);
+static DEFINE_PER_CPU(int, callchain_recursion[PERF_NR_CONTEXTS]);
 static atomic_t nr_callchain_events;
 static DEFINE_MUTEX(callchain_mutex);
 static struct perf_callchain_entry **callchain_cpu_entries;
@@ -1812,8 +1812,8 @@ static int alloc_callchain_buffers(void)
 	callchain_cpu_entries = entries;
 
 	for_each_possible_cpu(cpu) {
-		entries[cpu] = kmalloc(sizeof(struct perf_callchain_entry) * 4,
-					GFP_KERNEL);
+		entries[cpu] = kmalloc(sizeof(struct perf_callchain_entry) *
+					PERF_NR_CONTEXTS, GFP_KERNEL);
 		if (!entries[cpu])
 			return -ENOMEM;
 	}
-- 
1.6.2.3

