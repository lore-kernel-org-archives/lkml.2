Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab2E3RSy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 13:18:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:49500 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969Ab2E3RSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 13:18:53 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/3] perf report: Use the right symbol for annotation
Date: Wed, 30 May 2012 14:18:39 -0300
Message-Id: <1338398321-28327-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1338398321-28327-1-git-send-email-acme@infradead.org>
References: <1338398321-28327-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

In non symbolic views, i.e. --sort without "symbol", as in:

 perf report --sort comm

We're segfaulting in the --tui because we're testing the symbol resolved
and then trying to use the symbol on the histogram entry where we're
coalescing all hits for a COMM, and the first hist_entry for a comm may
have a NULL symbol, i.e. the RIP didn't resolve to any symbol.

In this case we're segfaulting, fix it by testing against the symbol in
the histogram entry.

Reported-by: William Cohen <wcohen@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-8ylwubbcmu27ucc9ffrku3yv@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 8c767c6..2400e00 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -162,7 +162,7 @@ static int perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 	 * so we don't allocated the extra space needed because the stdio
 	 * code will not use it.
 	 */
-	if (al->sym != NULL && use_browser > 0) {
+	if (he->ms.sym != NULL && use_browser > 0) {
 		struct annotation *notes = symbol__annotation(he->ms.sym);
 
 		assert(evsel != NULL);
-- 
1.7.9.2.358.g22243

