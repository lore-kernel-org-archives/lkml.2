Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922Ab0EBW7R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 18:59:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51465 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758827Ab0EBW7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 18:59:15 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 4/5] perf record: Don't exit in live mode when no tracepoints are enabled
Date: Sun,  2 May 2010 19:59:01 -0300
Message-Id: <1272841142-26029-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1272841142-26029-1-git-send-email-acme@infradead.org>
References: <1272841142-26029-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

With this I was able to actually test Tom Zanussi's two previous patches
in my usual perf testing ways, i.e. without any tracepoints activated.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index e382d93..ac989e9 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -666,12 +666,15 @@ static int __cmd_record(int argc, const char **argv)
 						     nr_counters,
 						     process_synthesized_event,
 						     session);
-		if (err <= 0) {
-			pr_err("Couldn't record tracing data.\n");
-			return err;
-		}
-
-		advance_output(err);
+		/*
+		 * FIXME err <= 0 here actually means that there were no tracepoints
+		 * so its not really an error, just that we don't need to synthesize
+		 * anything.
+		 * We really have to return this more properly and also propagate
+		 * errors that now are calling die()
+		 */
+		if (err > 0)
+			advance_output(err);
 	}
 
 	machine = perf_session__find_host_machine(session);
-- 
1.6.2.5

