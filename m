Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab2JEG5H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 02:57:07 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:60840 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab2JEG5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 02:57:04 -0400
X-AuditID: 9c930179-b7bf9ae000000e4c-d1-506e6c10f886
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 2/5] perf trace: Validate target task/user/cpu argument
Date: Fri,  5 Oct 2012 14:02:13 +0900
Message-Id: <1349413336-26936-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1349413336-26936-1-git-send-email-namhyung@kernel.org>
References: <1349413336-26936-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Those target options are mutually exclusive so check it before setting
up target thread/cpu maps.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-trace.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 9fc4bed8837d..7bb7e757c745 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -324,14 +324,21 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
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
1.7.11.4

