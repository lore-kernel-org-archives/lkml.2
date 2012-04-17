Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab2DQLWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 07:22:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755748Ab2DQLSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 07:18:22 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: eranian@google.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, rostedt@goodmis.org, robert.richter@amd.com,
        fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 05/16] perf: Add attribute to filter out user callchains
Date: Tue, 17 Apr 2012 13:17:10 +0200
Message-Id: <1334661441-4420-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1334661441-4420-1-git-send-email-jolsa@redhat.com>
References: <1334661441-4420-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the new exclude_user_callchain attribute to filter out
frame pointer based user callchains. This is something we
want to select when we use the dwarf cfi callchain mode,
because frame pointer based user callchains are useless in
this mode.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 include/linux/perf_event.h |    4 +++-
 kernel/events/callchain.c  |    4 ++--
 kernel/events/core.c       |    3 ++-
 kernel/events/internal.h   |    3 ++-
 4 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index e40bac5..b121c05 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -255,7 +255,9 @@ struct perf_event_attr {
 				exclude_host   :  1, /* don't count in host   */
 				exclude_guest  :  1, /* don't count in guest  */
 
-				__reserved_1   : 43;
+				exclude_user_callchain : 1, /* only record kernel callchains */
+
+				__reserved_1   : 42;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
diff --git a/kernel/events/callchain.c b/kernel/events/callchain.c
index 6581a04..884e997 100644
--- a/kernel/events/callchain.c
+++ b/kernel/events/callchain.c
@@ -153,7 +153,7 @@ put_callchain_entry(int rctx)
 	put_recursion_context(__get_cpu_var(callchain_recursion), rctx);
 }
 
-struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
+struct perf_callchain_entry *perf_callchain(struct pt_regs *regs, int user)
 {
 	int rctx;
 	struct perf_callchain_entry *entry;
@@ -177,7 +177,7 @@ struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
 			regs = NULL;
 	}
 
-	if (regs) {
+	if (user && regs) {
 		perf_callchain_store(entry, PERF_CONTEXT_USER);
 		perf_callchain_user(entry, regs);
 	}
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 5bae705..35c28f5 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4114,8 +4114,9 @@ void perf_prepare_sample(struct perf_event_header *header,
 
 	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
 		int size = 1;
+		int user = !event->attr.exclude_user_callchain;
 
-		data->callchain = perf_callchain(regs);
+		data->callchain = perf_callchain(regs, user);
 
 		if (data->callchain)
 			size += data->callchain->nr;
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index 1ae5270..b3ade19 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -115,7 +115,8 @@ DEFINE_PERF_OUTPUT_COPY(__output_copy, memcpy_common)
 DEFINE_PERF_OUTPUT_COPY(__output_copy_user_gup, copy_from_user_gup)
 
 /* Callchain handling */
-extern struct perf_callchain_entry *perf_callchain(struct pt_regs *regs);
+extern struct perf_callchain_entry *perf_callchain(struct pt_regs *regs,
+						   int user);
 extern int get_callchain_buffers(void);
 extern void put_callchain_buffers(void);
 
-- 
1.7.7.6

