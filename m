Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab2HAKL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 06:11:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754177Ab2HAKLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 06:11:55 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: eranian@google.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, robert.richter@amd.com, fche@redhat.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        drepper@gmail.com, asharma@fb.com, benjamin.redelings@nescent.org,
        Jiri Olsa <jolsa@redhat.com>, Andrew Vagin <avagin@openvz.org>
Subject: [PATCH 07/13] perf: Add attribute to filter out callchains
Date: Wed,  1 Aug 2012 12:10:59 +0200
Message-Id: <1343815865-5511-8-git-send-email-jolsa@redhat.com>
In-Reply-To: <1343815865-5511-1-git-send-email-jolsa@redhat.com>
References: <1343815865-5511-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com> 

Introducing following bits to the the perf_event_attr struct:
  - exclude_callchain_kernel to filter out kernel callchain
    from the sample dump
  - exclude_callchain_user to filter out user callchain
    from the sample dump

We need to be able to disable standard user callchain dump
when we use the dwarf cfi callchain mode, because frame
pointer based user callchains are useless in this mode.

Implementing also exclude_callchain_kernel to have complete
set of options.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
[ Added kernel callchains filtering ]
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
CC: Andrew Vagin <avagin@openvz.org>
---
 include/linux/perf_event.h |    5 ++++-
 kernel/events/callchain.c  |   36 +++++++++++++++++++++---------------
 kernel/events/core.c       |    6 +++++-
 kernel/events/internal.h   |    3 ++-
 4 files changed, 32 insertions(+), 18 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index d1d25f6..297ca3d 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -268,7 +268,10 @@ struct perf_event_attr {
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
index 98d4597..cbed627 100644
--- a/kernel/events/callchain.c
+++ b/kernel/events/callchain.c
@@ -154,7 +154,8 @@ put_callchain_entry(int rctx)
 }
 
 struct perf_callchain_entry *
-perf_callchain(struct perf_event *event, struct pt_regs *regs)
+perf_callchain(struct perf_event *event, struct pt_regs *regs,
+	       int kernel, int user)
 {
 	int rctx;
 	struct perf_callchain_entry *entry;
@@ -169,24 +170,29 @@ perf_callchain(struct perf_event *event, struct pt_regs *regs)
 
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
-		/*
-		 * Disallow cross-task user callchains.
-		 */
-		if (event->ctx->task && event->ctx->task != current)
-			goto exit_put;
-
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
+			/*
+			 * Disallow cross-task user callchains.
+			 */
+			if (event->ctx->task && event->ctx->task != current)
+				goto exit_put;
+
+			perf_callchain_store(entry, PERF_CONTEXT_USER);
+			perf_callchain_user(entry, regs);
+		}
 	}
 
 exit_put:
diff --git a/kernel/events/core.c b/kernel/events/core.c
index c4582bb..0902d4a 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4130,8 +4130,12 @@ void perf_prepare_sample(struct perf_event_header *header,
 
 	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
 		int size = 1;
+		int kernel = !event->attr.exclude_callchain_kernel;
+		int user   = !event->attr.exclude_callchain_user;
 
-		data->callchain = perf_callchain(event, regs);
+		if (kernel || user)
+			data->callchain = perf_callchain(event, regs,
+							 kernel, user);
 
 		if (data->callchain)
 			size += data->callchain->nr;
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index ce7bdfc..95d0215 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -126,7 +126,8 @@ DEFINE_OUTPUT_COPY(__output_copy_user, arch_perf_out_copy_user)
 
 /* Callchain handling */
 extern struct perf_callchain_entry *
-perf_callchain(struct perf_event *event, struct pt_regs *regs);
+perf_callchain(struct perf_event *event, struct pt_regs *regs,
+	       int kernel, int user);
 extern int get_callchain_buffers(void);
 extern void put_callchain_buffers(void);
 
-- 
1.7.7.6

