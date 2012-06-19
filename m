Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab2FSPt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 11:49:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754566Ab2FSPtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 11:49:24 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: eranian@google.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, robert.richter@amd.com, fche@redhat.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        drepper@gmail.com, asharma@fb.com, benjamin.redelings@nescent.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 08/23] perf: Add attribute to filter out callchains
Date: Tue, 19 Jun 2012 17:47:59 +0200
Message-Id: <1340120894-9465-9-git-send-email-jolsa@redhat.com>
In-Reply-To: <1340120894-9465-1-git-send-email-jolsa@redhat.com>
References: <1340120894-9465-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introducing new bits to the into the perf_event_attr struct:
  - exclude_callchain_kernel to filter out kernel callchain
  - exclude_callchain_user to filter out user callchain
from the sample dump.

We need to be able to disable standard user callchain dump
when we use the dwarf cfi callchain mode, because frame
pointer based user callchains are useless in this mode.

Implementing also exclude_callchain_kernel to have complete
set of options.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 include/linux/perf_event.h |    5 ++++-
 kernel/events/callchain.c  |   25 +++++++++++++++----------
 kernel/events/core.c       |    5 ++++-
 kernel/events/internal.h   |    3 ++-
 4 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 62d6743..e048ff3 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -259,7 +259,10 @@ struct perf_event_attr {
 				exclude_host   :  1, /* don't count in host   */
 				exclude_guest  :  1, /* don't count in guest  */
 
-				__reserved_1   : 43;
+				exclude_callchain_kernel : 1, /* exclude kernel callchains */
+				exclude_callchain_user   : 1, /* exclude user callchains */
+
+				__reserved_1   : 41;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
diff --git a/kernel/events/callchain.c b/kernel/events/callchain.c
index 6581a04..905ffb2 100644
--- a/kernel/events/callchain.c
+++ b/kernel/events/callchain.c
@@ -153,12 +153,12 @@ put_callchain_entry(int rctx)
 	put_recursion_context(__get_cpu_var(callchain_recursion), rctx);
 }
 
-struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
+struct perf_callchain_entry *perf_callchain(struct pt_regs *regs,
+					    int kernel, int user)
 {
 	int rctx;
 	struct perf_callchain_entry *entry;
 
-
 	entry = get_callchain_entry(&rctx);
 	if (rctx == -1)
 		return NULL;
@@ -168,18 +168,23 @@ struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
 
 	entry->nr = 0;
 
-	if (!user_mode(regs)) {
+	if (kernel && !user_mode(regs)) {
 		perf_callchain_store(entry, PERF_CONTEXT_KERNEL);
 		perf_callchain_kernel(entry, regs);
-		if (current->mm)
-			regs = task_pt_regs(current);
-		else
-			regs = NULL;
 	}
 
-	if (regs) {
-		perf_callchain_store(entry, PERF_CONTEXT_USER);
-		perf_callchain_user(entry, regs);
+	if (user) {
+		if (!user_mode(regs)) {
+			if  (current->mm)
+				regs = task_pt_regs(current);
+			else
+				regs = NULL;
+		}
+
+		if (regs) {
+			perf_callchain_store(entry, PERF_CONTEXT_USER);
+			perf_callchain_user(entry, regs);
+		}
 	}
 
 exit_put:
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 68c1f02..26c573a 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4120,8 +4120,11 @@ void perf_prepare_sample(struct perf_event_header *header,
 
 	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
 		int size = 1;
+		int kernel = !event->attr.exclude_callchain_kernel;
+		int user   = !event->attr.exclude_callchain_user;
 
-		data->callchain = perf_callchain(regs);
+		if (kernel || user)
+			data->callchain = perf_callchain(regs, kernel, user);
 
 		if (data->callchain)
 			size += data->callchain->nr;
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index be1ef29..abcc03d 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -125,7 +125,8 @@ DEFINE_OUTPUT_COPY(__output_skip, MEMCPY_SKIP)
 DEFINE_OUTPUT_COPY(__output_copy_user, arch_perf_out_copy_user)
 
 /* Callchain handling */
-extern struct perf_callchain_entry *perf_callchain(struct pt_regs *regs);
+extern struct perf_callchain_entry *perf_callchain(struct pt_regs *regs,
+						   int kernel, int user);
 extern int get_callchain_buffers(void);
 extern void put_callchain_buffers(void);
 
-- 
1.7.7.6

