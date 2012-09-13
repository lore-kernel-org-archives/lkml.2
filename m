Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953Ab2IMWKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 18:10:08 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:60022 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab2IMWKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 18:10:03 -0400
From: Irina Tirdea <irina.tirdea@gmail.com>
To: mingo@redhat.com, acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        rostedt@goodmis.org
Cc: paulus@samba.org, dsahern@gmail.com, namhyung.kim@lge.com,
        linux-kernel@vger.kernel.org, Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH 2/4] perf stat: add compile-time option to disable --big-num
Date: Fri, 14 Sep 2012 01:07:41 +0300
Message-Id: <1347574063-22521-3-git-send-email-irina.tirdea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347574063-22521-1-git-send-email-irina.tirdea@intel.com>
References: <1347574063-22521-1-git-send-email-irina.tirdea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Irina Tirdea <irina.tirdea@intel.com>

In printf's format, ' is used to group the output with thousands' grouping
characters for decimal conversion. Bionic does not support ' for printf.

Add a compile-time option (NO_BIG_NUM) to disable the --big-num option from
perf stat.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 tools/perf/Makefile                 |    8 ++++++++
 tools/perf/builtin-stat.c           |    8 ++++++++
 tools/perf/config/feature-tests.mak |   12 ++++++++++++
 3 files changed, 28 insertions(+)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 209774b..8daa781 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -768,6 +768,14 @@ else
        endif
 endif
 
+ifdef NO_BIG_NUM
+	BASIC_CFLAGS += -DNO_BIG_NUM
+else
+	ifneq ($(call try-cc,$(SOURCE_BIG_NUM),),y)
+		BASIC_CFLAGS += -DNO_BIG_NUM
+	endif
+endif
+
 ifdef ASCIIDOC8
 	export ASCIIDOC8
 endif
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index dab347d..ad8013e 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -188,7 +188,11 @@ static pid_t			child_pid			= -1;
 static bool			null_run			=  false;
 static int			detailed_run			=  0;
 static bool			sync_run			=  false;
+#ifdef NO_BIG_NUM
+static bool			big_num				=  false;
+#else
 static bool			big_num				=  true;
+#endif
 static int			big_num_opt			=  -1;
 static const char		*csv_sep			= NULL;
 static bool			csv_output			= false;
@@ -1075,12 +1079,14 @@ static const char * const stat_usage[] = {
 	NULL
 };
 
+#ifndef NO_BIG_NUM
 static int stat__set_big_num(const struct option *opt __maybe_unused,
 			     const char *s __maybe_unused, int unset)
 {
 	big_num_opt = unset ? 0 : 1;
 	return 0;
 }
+#endif
 
 static bool append_file;
 
@@ -1112,9 +1118,11 @@ static const struct option options[] = {
 		    "detailed run - start a lot of events"),
 	OPT_BOOLEAN('S', "sync", &sync_run,
 		    "call sync() before starting a run"),
+#ifndef NO_BIG_NUM
 	OPT_CALLBACK_NOOPT('B', "big-num", NULL, NULL, 
 			   "print large numbers with thousands\' separators",
 			   stat__set_big_num),
+#endif
 	OPT_STRING('C', "cpu", &target.cpu_list, "cpu",
 		    "list of cpus to monitor in system-wide"),
 	OPT_BOOLEAN('A', "no-aggr", &no_aggr,
diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index 116690a..2e5fad7 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -193,3 +193,15 @@ int main(void)
 }
 endef
 endif
+
+ifndef NO_BIG_NUM
+define SOURCE_BIG_NUM
+#include <stdio.h>
+
+int main(void)
+{
+	printf(\"%'\''.2f\", 1234567.89);
+	return 0;
+}
+endef
+endif
-- 
1.7.9.5

