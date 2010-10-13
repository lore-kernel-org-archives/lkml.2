Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606Ab0JMFHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 01:07:20 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35732 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab0JMFHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 01:07:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=jZP4P4DTwnDzlo5wX9N6NkEdErFCGghbVjs+aGnojjKgtcVt1BaO5OfJlPtZsOyDas
         4Vsbaci8/0ZkaYZiA+xfhOTCKCwybyGpN93kpYlvP5kGltEpTirJ4rkm+7dlTkiHO23G
         bfQGbif1rLBFptkEI2DKl7r6d/X+5MBzqIjD0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [RFC PATCH 4/9] perf: Don't record frame pointer based user stacktraces if we dump stack and regs
Date: Wed, 13 Oct 2010 07:06:56 +0200
Message-Id: <1286946421-32202-5-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1286946421-32202-1-git-send-regression-fweisbec@gmail.com>
References: <1286946421-32202-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we record user stack and regs, then don't record frame pointer
based user callchain, because it means we will do the user callchain
with the dwarf CFI information.

I'm not sure this is a good thing. I don't even know why I'm sending
this patch.

User and kernel stack might be selected for other uses than callchain
in the future, this probably shouldn't mess with the regular callchain
code. Instead we should probably have an exclude_callchain_user
attribute, that could be also useful to filter out user callchains
when people don't want them.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Robert Richter <robert.richter@amd.com>
---
 kernel/perf_event.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 0a1f0df..018a098 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1958,7 +1958,8 @@ put_callchain_entry(int rctx)
 	put_recursion_context(__get_cpu_var(callchain_recursion), rctx);
 }
 
-static struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
+static struct perf_callchain_entry *
+perf_callchain(struct pt_regs *regs, struct perf_event *event, u64 sample_type)
 {
 	int rctx;
 	struct perf_callchain_entry *entry;
@@ -1983,8 +1984,16 @@ static struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
 	}
 
 	if (regs) {
-		perf_callchain_store(entry, PERF_CONTEXT_USER);
-		perf_callchain_user(entry, regs);
+		/*
+		 * CHECKME: if user regs and user stack dumps are used
+		 * for something else than callchains one day, we may
+		 * want a exclude_callchain_user?
+		 */
+		if (!(sample_type & PERF_SAMPLE_UREGS &&
+		      event->attr.ustack_dump_size)) {
+			perf_callchain_store(entry, PERF_CONTEXT_USER);
+			perf_callchain_user(entry, regs);
+		}
 	}
 
 exit_put:
@@ -3760,7 +3769,7 @@ void perf_prepare_sample(struct perf_event_header *header,
 	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
 		int size = 1;
 
-		data->callchain = perf_callchain(regs);
+		data->callchain = perf_callchain(regs, event, sample_type);
 
 		if (data->callchain)
 			size += data->callchain->nr;
-- 
1.6.2.3

