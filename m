Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab2HUPu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:50:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60283 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab2HUPuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:50:52 -0400
Date: Tue, 21 Aug 2012 08:50:14 -0700
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Message-ID: <tip-d077526485d5c9b12fe85d0b2b3b7041e6bc5f91@git.kernel.org>
Cc: acme@redhat.com, eranian@google.com, mingo@kernel.org, gorcunov@openvz.org,
        a.p.zijlstra@chello.nl, benjamin.redelings@nescent.org,
        jolsa@redhat.com, drepper@gmail.com, robert.richter@amd.com,
        fweisbec@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        asharma@fb.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        fche@redhat.com, paulus@samba.org, tzanussi@gmail.com,
        masami.hiramatsu.pt@hitachi.com, mingo@elte.hu
Reply-To: mingo@kernel.org, eranian@google.com, acme@redhat.com,
        gorcunov@openvz.org, a.p.zijlstra@chello.nl,
        benjamin.redelings@nescent.org, jolsa@redhat.com, fweisbec@gmail.com,
        robert.richter@amd.com, drepper@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, asharma@fb.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
        tzanussi@gmail.com, masami.hiramatsu.pt@hitachi.com, mingo@elte.hu
In-Reply-To: <1344345647-11536-7-git-send-email-jolsa@redhat.com>
References: <1344345647-11536-7-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Add attribute to filter out callchains
Git-Commit-ID: d077526485d5c9b12fe85d0b2b3b7041e6bc5f91
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:50:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d077526485d5c9b12fe85d0b2b3b7041e6bc5f91
Gitweb:     http://git.kernel.org/tip/d077526485d5c9b12fe85d0b2b3b7041e6bc5f91
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Tue, 7 Aug 2012 15:20:41 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 10 Aug 2012 12:40:57 -0300

perf: Add attribute to filter out callchains

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
