Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655Ab2IJQvC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 12:51:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756502Ab2IJQuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 12:50:54 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 1/4] perf tools: Do backtrace post unwind only if we regs and stack were captured
Date: Mon, 10 Sep 2012 18:50:16 +0200
Message-Id: <1347295819-23177-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1347295819-23177-1-git-send-email-jolsa@redhat.com>
References: <1347295819-23177-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bail out without error if we want to do backtrace post unwind,
back were not able to capture user registers or user stack
during the record phase, which is possible and valid case.

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/session.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 9453758..90278ee 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -388,6 +388,11 @@ int machine__resolve_callchain(struct machine *machine,
 	      (evsel->attr.sample_type & PERF_SAMPLE_STACK_USER)))
 		return 0;
 
+	/* Bail out if nothing was captured. */
+	if ((!sample->user_regs.regs) ||
+	    (!sample->user_stack.size))
+		return 0;
+
 	return unwind__get_entries(unwind_entry, &callchain_cursor, machine,
 				   thread, evsel->attr.sample_regs_user,
 				   sample);
-- 
1.7.11.4

