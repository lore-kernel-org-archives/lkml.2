Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab2K2GkQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 01:40:16 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:63188 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab2K2GjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 01:39:15 -0500
X-AuditID: 9c93016f-b7b86ae000003a75-e7-50b7030bc973
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 18/18] perf report: Add report.group config option
Date: Thu, 29 Nov 2012 15:38:46 +0900
Message-Id: <1354171126-14387-20-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1354171126-14387-1-git-send-email-namhyung@kernel.org>
References: <1354171126-14387-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
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
 tools/perf/builtin-report.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index c7079dff7411..f35e489156dc 100644
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
@@ -677,6 +688,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_END()
 	};
 
+	perf_config(perf_report_config, NULL);
+
 	argc = parse_options(argc, argv, options, report_usage, 0);
 
 	if (report.use_stdio)
-- 
1.7.11.7

