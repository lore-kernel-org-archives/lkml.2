Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab1HDO5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 10:57:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:59584 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab1HDO5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 10:57:32 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arun Sharma <asharma@fb.com>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>, Sam Liao <phyomh@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 4/4] perf report: Use ui__warning in some more places
Date: Thu,  4 Aug 2011 11:57:18 -0300
Message-Id: <1312469838-2884-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1312469838-2884-1-git-send-email-acme@infradead.org>
References: <1312469838-2884-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

So that we get a proper warning in the TUI in cases like:

 $ perf report --stdio -g fractal,0.5,caller --sort pid
 Selected -g but no callchain data. Did you call 'perf record' without -g?
 $

The --stdio case is ok because it uses fprintf, ui__warning is needed to
figure out if --stdio or --tui is being used.

Cc: Arun Sharma <asharma@fb.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sam Liao <phyomh@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-ag9fz2wd17mbbfjsbznq1wms@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index f854efd..d7ff277 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -162,23 +162,22 @@ static int perf_session__setup_sample_type(struct perf_session *self)
 {
 	if (!(self->sample_type & PERF_SAMPLE_CALLCHAIN)) {
 		if (sort__has_parent) {
-			fprintf(stderr, "selected --sort parent, but no"
-					" callchain data. Did you call"
-					" perf record without -g?\n");
+			ui__warning("Selected --sort parent, but no "
+				    "callchain data. Did you call "
+				    "'perf record' without -g?\n");
 			return -EINVAL;
 		}
 		if (symbol_conf.use_callchain) {
-			fprintf(stderr, "selected -g but no callchain data."
-					" Did you call perf record without"
-					" -g?\n");
+			ui__warning("Selected -g but no callchain data. Did "
+				    "you call 'perf record' without -g?\n");
 			return -1;
 		}
 	} else if (!dont_use_callchains && callchain_param.mode != CHAIN_NONE &&
 		   !symbol_conf.use_callchain) {
 			symbol_conf.use_callchain = true;
 			if (callchain_register_param(&callchain_param) < 0) {
-				fprintf(stderr, "Can't register callchain"
-						" params\n");
+				ui__warning("Can't register callchain "
+					    "params.\n");
 				return -EINVAL;
 			}
 	}
-- 
1.6.2.5

