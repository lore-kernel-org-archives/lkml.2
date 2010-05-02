Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab0EBNz2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 09:55:28 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:50630 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896Ab0EBNzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 09:55:24 -0400
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, mitake@dcl.info.waseda.ac.jp,
       h.mitake@gmail.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/4][RFC] perf bench: add "sample" subsystem and "sample" suite as sample benchmark program
Date: Sun,  2 May 2010 22:55:16 +0900
Message-Id: <1272808519-4743-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1272808519-4743-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1272808519-4743-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements "sample" subsystem and "sample" suite
for perf bench. As the name describes, these are sample stuff.

Detailed descriptions about new structure of perf bench
will be written in 4/4 of this patch series.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com> 
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
---
 tools/perf/bench/sample-sample.c |   98 ++++++++++++++++++++++++++++++++++++++
 tools/perf/bench/sample.h        |    4 ++
 2 files changed, 102 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/bench/sample-sample.c
 create mode 100644 tools/perf/bench/sample.h

diff --git a/tools/perf/bench/sample-sample.c b/tools/perf/bench/sample-sample.c
new file mode 100644
index 0000000..b5ad090
--- /dev/null
+++ b/tools/perf/bench/sample-sample.c
@@ -0,0 +1,98 @@
+/*
+ * sample benchmark suite for perf bench
+ */
+
+#include "../perf.h"
+#include "bench.h"
+#include "../util/util.h"
+#include "../util/parse-options.h"
+
+#include <sys/types.h>
+#include <unistd.h>
+#include <stdio.h>
+
+struct sample_param {
+	int boolean;
+	int integer;
+	const char *string;
+};
+
+struct sample_ctx {
+	int count;
+};
+
+static const char * const sample_sample_usage[] = {
+	"perf bench sample sample <options>",
+	NULL
+};
+
+static void *__sample_sample_parse_arg(int argc, const char **argv,
+				       const char *prefix __used,
+				       struct sample_param *param)
+{
+	struct option options[] = {
+		OPT_BOOLEAN('b', "boolean", &param->boolean,
+			    "Sample boolean argument"),
+		OPT_INTEGER('i', "integer", &param->integer,
+			    "Sample integer argument"),
+		OPT_STRING('s', "string", &param->string, "string-default",
+			   "Sample string argument"),
+		OPT_END()
+	};
+
+	argc = parse_options(argc, argv, options,
+			     sample_sample_usage, PARSE_OPT_KEEP_ARGV0);
+
+	printf("parameters for sample benchmark:\n");
+	printf("\tboolean:%d\n", param->boolean);
+	printf("\tinteger:%d\n", param->integer);
+	printf("\tstring:%s\n", param->string ? param->string : "(NULL)");
+
+	return param;
+}
+
+/*
+ * parse arguments
+ * returned object will be shared between every thread/process of benchmark
+ */
+void *sample_sample_parse_arg(int argc, const char **argv, const char *prefix)
+{
+	struct sample_param *param;
+
+	param = zalloc(sizeof(struct sample_param));
+	if (!param)
+		die("Memory allocation failed\n");
+
+	return __sample_sample_parse_arg(argc, argv, prefix, param);
+}
+
+/*
+ * prepare own state of thread/process
+ * returned object will not be shared
+ */
+void sample_sample_prepare(struct bench_ctx *ctx)
+{
+	struct sample_ctx *priv;
+
+	priv = zalloc(sizeof(struct sample_ctx));
+	if (!priv)
+		die("Memory allocation failed\n");
+
+	priv->count = ((struct sample_param *)ctx->param)->integer;
+	ctx->priv = priv;
+}
+
+void sample_sample_bench(struct bench_ctx *ctx)
+{
+	struct sample_ctx *priv = (struct sample_ctx *)ctx->priv;
+
+	while (priv->count--) {
+		printf("pid %d: %d...\n", getpid(), priv->count);
+		sleep(1);
+	}
+}
+
+void sample_sample_clean(struct bench_ctx *ctx)
+{
+	free(ctx->priv);
+}
diff --git a/tools/perf/bench/sample.h b/tools/perf/bench/sample.h
new file mode 100644
index 0000000..b514956
--- /dev/null
+++ b/tools/perf/bench/sample.h
@@ -0,0 +1,4 @@
+
+BENCH("sample", "Sample implementation of perf bench",
+      sample_sample_parse_arg, sample_sample_prepare,
+      sample_sample_bench, sample_sample_clean)
-- 
1.7.1

