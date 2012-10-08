Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab2JHWdK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 18:33:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:41325 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab2JHWdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 18:33:07 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/25] perf trace: Validate target task/user/cpu argument
Date: Mon,  8 Oct 2012 19:32:26 -0300
Message-Id: <1349735570-19339-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1349735570-19339-1-git-send-email-acme@infradead.org>
References: <1349735570-19339-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Those target options are mutually exclusive so check it before setting
up target thread/cpu maps.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1349413336-26936-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index dec8ced..f01fa6f 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -323,14 +323,21 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_END()
 	};
 	int err;
+	char bf[BUFSIZ];
 
 	argc = parse_options(argc, argv, trace_options, trace_usage, 0);
 	if (argc)
 		usage_with_options(trace_usage, trace_options);
 
+	err = perf_target__validate(&trace.opts.target);
+	if (err) {
+		perf_target__strerror(&trace.opts.target, err, bf, sizeof(bf));
+		printf("%s", bf);
+		return err;
+	}
+
 	err = perf_target__parse_uid(&trace.opts.target);
 	if (err) {
-		char bf[BUFSIZ];
 		perf_target__strerror(&trace.opts.target, err, bf, sizeof(bf));
 		printf("%s", bf);
 		return err;
-- 
1.7.9.2.358.g22243

