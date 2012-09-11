Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab2IKXxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 19:53:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:42264 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab2IKXxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 19:53:22 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/18] perf tools: Do backtrace post unwind only if we regs and stack were captured
Date: Tue, 11 Sep 2012 20:53:01 -0300
Message-Id: <1347407590-30960-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1347407590-30960-1-git-send-email-acme@infradead.org>
References: <1347407590-30960-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Bail out without error if we want to do backtrace post unwind, but were
not able to capture user registers or user stack during the record
phase, which is possible and valid case.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1347295819-23177-2-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 3806ea4..0ecd62b 100644
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
1.7.9.2.358.g22243

