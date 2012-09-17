Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab2IQRSa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:18:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57881 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663Ab2IQRS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 13:18:27 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Dong Hao <haodong@linux.vnet.ibm.com>, Avi Kivity <avi@redhat.com>,
        David Ahern <dsahern@gmail.com>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/18] perf stat: Move stats related code to util/stat.c
Date: Mon, 17 Sep 2012 14:18:03 -0300
Message-Id: <1347902292-14536-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1347902292-14536-1-git-send-email-acme@infradead.org>
References: <1347902292-14536-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

Then, the code can be shared between kvm events and perf stat.

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
[ Dong Hao <haodong@linux.vnet.ibm.com>: rebase it on acme's git tree ]
Signed-off-by: Dong Hao <haodong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: kvm@vger.kernel.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Runzhen Wang <runzhen@linux.vnet.ibm.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com
Link: http://lkml.kernel.org/r/1347870675-31495-3-git-send-email-haodong@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile       |    1 +
 tools/perf/builtin-stat.c |   56 +------------------------------------------
 tools/perf/util/stat.c    |   57 +++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/stat.h    |   16 ++++++++++++
 4 files changed, 76 insertions(+), 54 deletions(-)
 create mode 100644 tools/perf/util/stat.c
 create mode 100644 tools/perf/util/stat.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 209774b..5077f8e 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -406,6 +406,7 @@ LIB_OBJS += $(OUTPUT)util/target.o
 LIB_OBJS += $(OUTPUT)util/rblist.o
 LIB_OBJS += $(OUTPUT)util/intlist.o
 LIB_OBJS += $(OUTPUT)util/vdso.o
+LIB_OBJS += $(OUTPUT)util/stat.o
 
 LIB_OBJS += $(OUTPUT)ui/helpline.o
 LIB_OBJS += $(OUTPUT)ui/hist.o
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index dab347d..3c43a35 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -51,13 +51,13 @@
 #include "util/evsel.h"
 #include "util/debug.h"
 #include "util/color.h"
+#include "util/stat.h"
 #include "util/header.h"
 #include "util/cpumap.h"
 #include "util/thread.h"
 #include "util/thread_map.h"
 
 #include <sys/prctl.h>
-#include <math.h>
 #include <locale.h>
 
 #define DEFAULT_SEPARATOR	" "
@@ -199,11 +199,6 @@ static int			output_fd;
 
 static volatile int done = 0;
 
-struct stats
-{
-	double n, mean, M2;
-};
-
 struct perf_stat {
 	struct stats	  res_stats[3];
 };
@@ -220,50 +215,6 @@ static void perf_evsel__free_stat_priv(struct perf_evsel *evsel)
 	evsel->priv = NULL;
 }
 
-static void update_stats(struct stats *stats, u64 val)
-{
-	double delta;
-
-	stats->n++;
-	delta = val - stats->mean;
-	stats->mean += delta / stats->n;
-	stats->M2 += delta*(val - stats->mean);
-}
-
-static double avg_stats(struct stats *stats)
-{
-	return stats->mean;
-}
-
-/*
- * http://en.wikipedia.org/wiki/Algorithms_for_calculating_variance
- *
- *       (\Sum n_i^2) - ((\Sum n_i)^2)/n
- * s^2 = -------------------------------
- *                  n - 1
- *
- * http://en.wikipedia.org/wiki/Stddev
- *
- * The std dev of the mean is related to the std dev by:
- *
- *             s
- * s_mean = -------
- *          sqrt(n)
- *
- */
-static double stddev_stats(struct stats *stats)
-{
-	double variance, variance_mean;
-
-	if (!stats->n)
-		return 0.0;
-
-	variance = stats->M2 / (stats->n - 1);
-	variance_mean = variance / stats->n;
-
-	return sqrt(variance_mean);
-}
-
 static struct stats runtime_nsecs_stats[MAX_NR_CPUS];
 static struct stats runtime_cycles_stats[MAX_NR_CPUS];
 static struct stats runtime_stalled_cycles_front_stats[MAX_NR_CPUS];
@@ -559,10 +510,7 @@ static int run_perf_stat(int argc __maybe_unused, const char **argv)
 
 static void print_noise_pct(double total, double avg)
 {
-	double pct = 0.0;
-
-	if (avg)
-		pct = 100.0*total/avg;
+	double pct = rel_stddev_stats(total, avg);
 
 	if (csv_output)
 		fprintf(output, "%s%.2f%%", csv_sep, pct);
diff --git a/tools/perf/util/stat.c b/tools/perf/util/stat.c
new file mode 100644
index 0000000..2374212
--- /dev/null
+++ b/tools/perf/util/stat.c
@@ -0,0 +1,57 @@
+#include <math.h>
+
+#include "stat.h"
+
+void update_stats(struct stats *stats, u64 val)
+{
+	double delta;
+
+	stats->n++;
+	delta = val - stats->mean;
+	stats->mean += delta / stats->n;
+	stats->M2 += delta*(val - stats->mean);
+}
+
+double avg_stats(struct stats *stats)
+{
+	return stats->mean;
+}
+
+/*
+ * http://en.wikipedia.org/wiki/Algorithms_for_calculating_variance
+ *
+ *       (\Sum n_i^2) - ((\Sum n_i)^2)/n
+ * s^2 = -------------------------------
+ *                  n - 1
+ *
+ * http://en.wikipedia.org/wiki/Stddev
+ *
+ * The std dev of the mean is related to the std dev by:
+ *
+ *             s
+ * s_mean = -------
+ *          sqrt(n)
+ *
+ */
+double stddev_stats(struct stats *stats)
+{
+	double variance, variance_mean;
+
+	if (!stats->n)
+		return 0.0;
+
+	variance = stats->M2 / (stats->n - 1);
+	variance_mean = variance / stats->n;
+
+	return sqrt(variance_mean);
+}
+
+double rel_stddev_stats(double stddev, double avg)
+{
+	double pct = 0.0;
+
+	if (avg)
+		pct = 100.0 * stddev/avg;
+
+	return pct;
+}
diff --git a/tools/perf/util/stat.h b/tools/perf/util/stat.h
new file mode 100644
index 0000000..588367c
--- /dev/null
+++ b/tools/perf/util/stat.h
@@ -0,0 +1,16 @@
+#ifndef __PERF_STATS_H
+#define __PERF_STATS_H
+
+#include "types.h"
+
+struct stats
+{
+	double n, mean, M2;
+};
+
+void update_stats(struct stats *stats, u64 val);
+double avg_stats(struct stats *stats);
+double stddev_stats(struct stats *stats);
+double rel_stddev_stats(double stddev, double avg);
+
+#endif
-- 
1.7.1

