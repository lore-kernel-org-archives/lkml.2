Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160Ab2JVQal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 12:30:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:56218 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540Ab2JVQai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 12:30:38 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/5] perf trace: Check if sample raw_data field is set
Date: Mon, 22 Oct 2012 14:30:22 -0200
Message-Id: <1350923425-15400-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1350923425-15400-1-git-send-email-acme@infradead.org>
References: <1350923425-15400-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Sometimes we're segfaulting because we were expecting that the
perf_sample.raw_data field was set as requested, but in some cases
that needs further investigation, that field can be NULL, leading
to segfaults.

Make the tool more robust by checking that before calling any per event
handlers that may try to use that field.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-g1fmodl6ys4lq8honbj1igoi@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 83c6515..7aaee39 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -268,6 +268,13 @@ again:
 			if (evlist->threads->map[0] == -1 || evlist->threads->nr > 1)
 				printf("%d ", sample.tid);
 
+			if (sample.raw_data == NULL) {
+				printf("%s sample with no payload for tid: %d, cpu %d, raw_size=%d, skipping...\n",
+				       perf_evsel__name(evsel), sample.tid,
+				       sample.cpu, sample.raw_size);
+				continue;
+			}
+
 			handler = evsel->handler.func;
 			handler(trace, evsel, &sample);
 		}
-- 
1.7.1

