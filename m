Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab2JOXgt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 19:36:49 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:61981 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717Ab2JOXge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 19:36:34 -0400
From: Irina Tirdea <irina.tirdea@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH v4 6/6] perf stat: implement --big-num grouping
Date: Tue, 16 Oct 2012 02:33:40 +0300
Message-Id: <1350344020-8071-7-git-send-email-irina.tirdea@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350344020-8071-1-git-send-email-irina.tirdea@gmail.com>
References: <1350344020-8071-1-git-send-email-irina.tirdea@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Irina Tirdea <irina.tirdea@intel.com>

In glibc, printf supports ' to group numbers with thousands' grouping
characters. Bionic does not support ' for printf.

Implement thousands's grouping for numbers according to locale.
The implementation uses the algorithm from glibc
(http://www.gnu.org/software/libc/).

Bionic does not implement locales, so we need to add a configuration
option LOCALE_SUPPORT. If it is not defined, default values for thousands
separator and grouping are used.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 tools/perf/Makefile                 |    6 ++
 tools/perf/builtin-stat.c           |  106 ++++++++++++++++++++++++++++++++---
 tools/perf/config/feature-tests.mak |   18 ++++++
 3 files changed, 123 insertions(+), 7 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 5906adb..002e7c2 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -785,6 +785,12 @@ ifndef NO_BACKTRACE
        endif
 endif
 
+ifndef NO_LOCALE
+       ifeq ($(call try-cc,$(SOURCE_LOCALE),),y)
+               BASIC_CFLAGS += -DLOCALE_SUPPORT
+       endif
+endif
+
 ifdef ASCIIDOC8
 	export ASCIIDOC8
 endif
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 93b9011..d625f80 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -60,6 +60,8 @@
 #include <sys/prctl.h>
 #include <locale.h>
 
+/* max double number have E+308 + \0 + sign */
+#define MAX_NR_STR 310
 #define DEFAULT_SEPARATOR	" "
 #define CNTR_NOT_SUPPORTED	"<not supported>"
 #define CNTR_NOT_COUNTED	"<not counted>"
@@ -631,18 +633,106 @@ static void print_ll_cache_misses(int cpu,
 	fprintf(output, " of all LL-cache hits   ");
 }
 
+/* Group the digits according to the grouping rules of the current locale.
+   The interpretation of GROUPING is as in `struct lconv' from <locale.h>.  */
+static int group_number_locale(char *number, char **gnumber)
+{
+	const char *thousands_sep = NULL, *grouping = NULL;
+	int glen, tlen, dest_alloc_size, src_size, ret = -ENOMEM, cnt;
+	char *dest_alloc_ptr, *dest_end, *src_start, *src_end;
+
+#ifdef LOCALE_SUPPORT
+	struct lconv *lc = localeconv();
+	if (lc != NULL) {
+		thousands_sep = lc->thousands_sep;
+		grouping = lc->grouping;
+	}
+#else
+	thousands_sep = ",";
+	grouping = "\x3";
+#endif
+
+	*gnumber = NULL;
+	/* No grouping */
+	if (thousands_sep == NULL || grouping == NULL ||
+	    *thousands_sep == '\0' || *grouping == CHAR_MAX || *grouping <= 0) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	glen = *grouping++;
+	tlen = strlen(thousands_sep);
+
+	src_size = strlen(number);
+	/* Worst case scenario we have 1-character grouping */
+	dest_alloc_size = (src_size + src_size * tlen) * sizeof(char);
+	dest_alloc_ptr = zalloc(dest_alloc_size);
+	if (dest_alloc_ptr == NULL)
+		goto out;
+	/* -1 for '\0' */
+	dest_end = dest_alloc_ptr + dest_alloc_size - 1;
+
+	src_start = number;
+	src_end = number + src_size;
+
+	while (src_end > src_start) {
+		*--dest_end = *--src_end;
+		if (--glen == 0 && src_end > src_start) {
+			/* A new group */
+			cnt = tlen;
+			do
+				*--dest_end = thousands_sep[--cnt];
+			while (cnt > 0);
+
+			if (*grouping == CHAR_MAX || *grouping < 0) {
+				/* No further grouping to be done.
+				   Copy the rest of the number. */
+				do
+					*--dest_end = *--src_end;
+				while (src_end > src_start);
+				break;
+			} else if (*grouping != '\0') {
+				glen = *grouping++;
+			} else {
+				/* The previous grouping repeats ad infinitum */
+				glen = grouping[-1];
+			}
+		}
+	}
+
+	/* Make a copy with the exact needed size of the grouped number */
+	*gnumber = strdup(dest_end);
+	if (*gnumber == NULL)
+		goto out_free_dest;
+
+	ret = 0;
+out_free_dest:
+	free(dest_alloc_ptr);
+out:
+	return ret;
+}
+
 static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 {
 	double total, ratio = 0.0;
 	char cpustr[16] = { '\0', };
 	const char *fmt;
+	char avgstr[MAX_NR_STR], *pavgstr;
+	int ret;
 
-	if (csv_output)
-		fmt = "%s%.0f%s%s";
-	else if (big_num)
-		fmt = "%s%'18.0f%s%-25s";
-	else
-		fmt = "%s%18.0f%s%-25s";
+	sprintf(avgstr, "%.0f", avg);
+	pavgstr = avgstr;
+
+	if (csv_output) {
+		fmt = "%s%s%s%s";
+	} else {
+		fmt = "%s%18s%s%-25s";
+		if (big_num) {
+			ret = group_number_locale(avgstr, &pavgstr);
+			if (ret < 0)
+				pavgstr = avgstr;
+		}
+	}
 
 	if (no_aggr)
 		sprintf(cpustr, "CPU%*d%s",
@@ -651,7 +741,9 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 	else
 		cpu = 0;
 
-	fprintf(output, fmt, cpustr, avg, csv_sep, perf_evsel__name(evsel));
+	fprintf(output, fmt, cpustr, pavgstr, csv_sep, perf_evsel__name(evsel));
+	if (pavgstr != avgstr)
+		free(pavgstr);
 
 	if (evsel->cgrp)
 		fprintf(output, "%s%s", csv_sep, evsel->cgrp->name);
diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index 3ef5ec9..ec3a6f1 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -222,3 +222,21 @@ int main(void)
 	return on_exit(NULL, NULL);
 }
 endef
+
+ifndef NO_LOCALE
+define SOURCE_LOCALE
+#include <locale.h>
+
+int main(void)
+{
+	char *thousands_sep, *grouping;
+
+	struct lconv *lc = localeconv();
+	if (lc != NULL) {
+		thousands_sep = lc->thousands_sep;
+		grouping = lc->grouping;
+	}
+	return 0;
+}
+endef
+endif
-- 
1.7.9.5

