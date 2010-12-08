Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544Ab0LHCjv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 21:39:51 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:46214 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501Ab0LHCju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 21:39:50 -0500
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.59,314,1288569600"; 
   d="scan'208";a="632489589"
From: David Ahern <daahern@cisco.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: David Ahern <daahern@cisco.com>
Subject: [PATCH] perf report: Allow user to specify path to kallsyms file
Date: Tue,  7 Dec 2010 19:39:46 -0700
Message-Id: <1291775986-16475-1-git-send-email-daahern@cisco.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is useful for analyzing a perf data file on a different system
than the one data was collected on and still include symbols from
loaded kernel modules in the output.

Signed-off-by: David Ahern <daahern@cisco.com>
---
 tools/perf/builtin-report.c |    2 ++
 tools/perf/util/symbol.c    |    9 +++++++--
 tools/perf/util/symbol.h    |    1 +
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 904519f..b6a2a89 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -443,6 +443,8 @@ static const struct option options[] = {
 		    "dump raw trace in ASCII"),
 	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
 		   "file", "vmlinux pathname"),
+	OPT_STRING(0, "kallsyms", &symbol_conf.kallsyms_name,
+		   "file", "kallsyms pathname"),
 	OPT_BOOLEAN('f', "force", &force, "don't complain, do it"),
 	OPT_BOOLEAN('m', "modules", &symbol_conf.use_modules,
 		    "load module symbols - WARNING: use only with -k and LIVE kernel"),
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index a348906..f40c076 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1830,8 +1830,8 @@ static int dso__load_kernel_sym(struct dso *self, struct map *map,
 	const char *kallsyms_filename = NULL;
 	char *kallsyms_allocated_filename = NULL;
 	/*
-	 * Step 1: if the user specified a vmlinux filename, use it and only
-	 * it, reporting errors to the user if it cannot be used.
+	 * Step 1: if the user specified a kallsyms or vmlinux filename, use
+	 * it and only it, reporting errors to the user if it cannot be used.
 	 *
 	 * For instance, try to analyse an ARM perf.data file _without_ a
 	 * build-id, or if the user specifies the wrong path to the right
@@ -1844,6 +1844,11 @@ static int dso__load_kernel_sym(struct dso *self, struct map *map,
 	 * validation in dso__load_vmlinux and will bail out if they don't
 	 * match.
 	 */
+	if (symbol_conf.kallsyms_name != NULL) {
+		kallsyms_filename = symbol_conf.kallsyms_name;
+		goto do_kallsyms;
+	}
+
 	if (symbol_conf.vmlinux_name != NULL) {
 		err = dso__load_vmlinux(self, map,
 					symbol_conf.vmlinux_name, filter);
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 038f220..12defbe 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -72,6 +72,7 @@ struct symbol_conf {
 			show_cpu_utilization,
 			initialized;
 	const char	*vmlinux_name,
+			*kallsyms_name,
 			*source_prefix,
 			*field_sep;
 	const char	*default_guest_vmlinux_name,
-- 
1.7.2.3

