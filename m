Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab2KIQp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 11:45:28 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63528 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790Ab2KIQpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 11:45:24 -0500
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 12/12] perf report: Add report.group config option
Date: Sat, 10 Nov 2012 01:43:34 +0900
Message-Id: <1352479414-2324-13-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1352479414-2324-1-git-send-email-namhyung@kernel.org>
References: <1352479414-2324-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Add report.group config option for setting default value of event
group view.  It affects the report output only if perf.data contains
event group info.

A user can write .perfconfig file like below to enable group view by
default:

  $ cat ~/.perfconfig
  [report]
  group = true

And it can be disabled through command line:

  $ perf report --no-group

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 1a1a650fe952..b7419cd3889a 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -8,6 +8,7 @@
 #include "builtin.h"
 
 #include "util/util.h"
+#include "util/cache.h"
 
 #include "util/annotate.h"
 #include "util/color.h"
@@ -54,6 +55,16 @@ struct perf_report {
 	DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
 };
 
+static int perf_report_config(const char *var, const char *value, void *cb)
+{
+	if (!strcmp(var, "report.group")) {
+		symbol_conf.event_group = perf_config_bool(var, value);
+		return 0;
+	}
+
+	return perf_default_config(var, value, cb);
+}
+
 static int perf_report__add_branch_hist_entry(struct perf_tool *tool,
 					struct addr_location *al,
 					struct perf_sample *sample,
@@ -674,6 +685,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_END()
 	};
 
+	perf_config(perf_report_config, NULL);
+
 	argc = parse_options(argc, argv, options, report_usage, 0);
 
 	if (report.use_stdio)
-- 
1.7.9.2

