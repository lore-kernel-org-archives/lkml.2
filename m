Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759370Ab0JVTO6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:14:58 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49359 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759350Ab0JVTN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 15:13:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=UjXj+0jHuAecpYcmGp4mv4ohpulUuxxuiluec7vbDLx/+DjNEUyJOXSYWfMdcIoJ39
         kx9+PhFQONKk8HbGOFigf55PpHBW51TLZBZfA1Hkv1J9+BL/OasRe9oQSBKWxlgkCkej
         VwCwtZ/uLh+TWOCmqqYO3YWeAHSMOKyFtEP+4=
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
        Robert Richter <robert.richter@amd.com>,
        "Frank Ch. Eigler" <fche@redhat.com>
Subject: [RFC PATCH 05/11] perf: New attribute to filter out user callchains
Date: Fri, 22 Oct 2010 21:13:06 +0200
Message-Id: <1287774792-23123-6-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1287774792-23123-1-git-send-regression-fweisbec@gmail.com>
References: <1287774792-23123-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the new exclude_user_callchain attribute to filter out
frame pointer based user callchains. This is something we
want to select when we use the dwarf cfi callchain mode,
because frame pointer based user callchains are useless in
this mode.

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
Cc: Robert Richter <robert.richter@amd.com>
Cc: Frank Ch. Eigler <fche@redhat.com>
---
 include/linux/perf_event.h |    3 ++-
 kernel/perf_event.c        |    8 +++++---
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 87441b5..86c988e 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -215,8 +215,9 @@ struct perf_event_attr {
 				 */
 				precise_ip     :  2, /* skid constraint       */
 				mmap_data      :  1, /* non-exec mmap data    */
+				exclude_user_callchain : 1, /* only record kernel callchains */
 
-				__reserved_1   : 46;
+				__reserved_1   : 45;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 674ed25..e76623a 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2016,7 +2016,8 @@ put_callchain_entry(int rctx)
 	put_recursion_context(__get_cpu_var(callchain_recursion), rctx);
 }
 
-static struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
+static struct perf_callchain_entry *
+perf_callchain(struct pt_regs *regs, int user)
 {
 	int rctx;
 	struct perf_callchain_entry *entry;
@@ -2040,7 +2041,7 @@ static struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
 			regs = NULL;
 	}
 
-	if (regs) {
+	if (user && regs) {
 		perf_callchain_store(entry, PERF_CONTEXT_USER);
 		perf_callchain_user(entry, regs);
 	}
@@ -3738,8 +3739,9 @@ void perf_prepare_sample(struct perf_event_header *header,
 
 	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
 		int size = 1;
+		int user = !event->attr.exclude_user_callchain;
 
-		data->callchain = perf_callchain(regs);
+		data->callchain = perf_callchain(regs, user);
 
 		if (data->callchain)
 			size += data->callchain->nr;
-- 
1.6.2.3

