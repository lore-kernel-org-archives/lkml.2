Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab2HMSps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 14:45:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:45043 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab2HMShq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 14:37:46 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
        Arun Sharma <asharma@fb.com>,
        Benjamin Redelings <benjamin.redelings@nescent.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>, Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, Ulrich Drepper <drepper@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 15/38] perf: Add attribute to filter out callchains
Date: Mon, 13 Aug 2012 15:36:56 -0300
Message-Id: <1344883039-13495-16-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1344883039-13495-1-git-send-email-acme@infradead.org>
References: <1344883039-13495-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

Introducing following bits to the the perf_event_attr struct:

  - exclude_callchain_kernel to filter out kernel callchain
    from the sample dump

  - exclude_callchain_user to filter out user callchain
    from the sample dump

We need to be able to disable standard user callchain dump when we use
the dwarf cfi callchain mode, because frame pointer based user
callchains are useless in this mode.

Implementing also exclude_callchain_kernel to have complete set of
options.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
[ Added kernel callchains filtering ]
Cc: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Arun Sharma <asharma@fb.com>
Cc: Benjamin Redelings <benjamin.redelings@nescent.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Ulrich Drepper <drepper@gmail.com>
Link: http://lkml.kernel.org/r/1344345647-11536-7-git-send-email-jolsa@redhat.com
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/linux/perf_event.h |    5 ++++-
 kernel/events/callchain.c  |   38 ++++++++++++++++++++++++--------------
 2 files changed, 28 insertions(+), 15 deletions(-)

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
index 98d4597..c772061 100644
--- a/kernel/events/callchain.c
+++ b/kernel/events/callchain.c
@@ -159,6 +159,11 @@ perf_callchain(struct perf_event *event, struct pt_regs *regs)
 	int rctx;
 	struct perf_callchain_entry *entry;
 
+	int kernel = !event->attr.exclude_callchain_kernel;
+	int user   = !event->attr.exclude_callchain_user;
+
+	if (!kernel && !user)
+		return NULL;
 
 	entry = get_callchain_entry(&rctx);
 	if (rctx == -1)
@@ -169,24 +174,29 @@ perf_callchain(struct perf_event *event, struct pt_regs *regs)
 
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
-- 
1.7.1

