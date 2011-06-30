Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668Ab1F3IEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 04:04:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:12112 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758656Ab1F3IEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 04:04:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,449,1304319600"; 
   d="scan'208";a="20764722"
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] perf tool: Get PMU type id from sysfs
Date: Thu, 30 Jun 2011 08:09:56 +0000
Message-Id: <1309421396-17438-5-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1309421396-17438-1-git-send-email-ming.m.lin@intel.com>
References: <1309421396-17438-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PMU type id can be allocated dynamically, for example

$ perf stat -e uncore:r0101 ls

$ cat /sys/bus/event_source/devices/uncore/type 
6

Uncore pmu type is read from sysfs and set into attr->type.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 tools/perf/util/parse-events.c |   55 ++++++++++++++++++++++++++++++++++++++-
 1 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 41982c3..6cbbeda 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -684,7 +684,7 @@ parse_symbolic_event(const char **strp, struct perf_event_attr *attr)
 }
 
 static enum event_result
-parse_raw_event(const char **strp, struct perf_event_attr *attr)
+parse_raw_config(const char **strp, struct perf_event_attr *attr)
 {
 	const char *str = *strp;
 	u64 config;
@@ -695,7 +695,6 @@ parse_raw_event(const char **strp, struct perf_event_attr *attr)
 	n = hex2u64(str + 1, &config);
 	if (n > 0) {
 		*strp = str + n + 1;
-		attr->type = PERF_TYPE_RAW;
 		attr->config = config;
 		return EVT_HANDLED;
 	}
@@ -703,6 +702,54 @@ parse_raw_event(const char **strp, struct perf_event_attr *attr)
 }
 
 static enum event_result
+parse_raw_event(const char **strp, struct perf_event_attr *attr)
+{
+	if (parse_raw_config(strp, attr) != EVT_HANDLED)
+		return EVT_FAILED;
+
+	attr->type = PERF_TYPE_RAW;
+	return EVT_HANDLED;
+}
+
+#define EVENT_SOURCE_DIR "/sys/bus/event_source/devices"
+
+static enum event_result
+parse_sysfs_event(const char **strp, struct perf_event_attr *attr)
+{
+	char *pmu_name;
+	char evt_path[MAXPATHLEN];
+	char type_buf[4];
+	u64 type;
+	int fd;
+
+	pmu_name = strchr(*strp, ':');
+	if (!pmu_name)
+		return EVT_FAILED;
+
+	pmu_name = strndup(*strp, pmu_name - *strp);
+
+	snprintf(evt_path, MAXPATHLEN, "%s/%s/type", EVENT_SOURCE_DIR,
+		 pmu_name);
+
+	fd = open(evt_path, O_RDONLY);
+	if (fd < 0)
+		return EVT_FAILED;
+
+	if (read(fd, type_buf, sizeof(type_buf)) < 0) {
+		close(fd);
+		return EVT_FAILED;
+	}
+
+	close(fd);
+	type = atoll(type_buf);
+	attr->type = type;
+	*strp += strlen(pmu_name) + 1; /* + 1 for the ':' */
+	free(pmu_name);
+
+	return parse_raw_config(strp, attr);
+}
+
+static enum event_result
 parse_numeric_event(const char **strp, struct perf_event_attr *attr)
 {
 	const char *str = *strp;
@@ -783,6 +830,10 @@ parse_event_symbols(const struct option *opt, const char **str,
 {
 	enum event_result ret;
 
+	ret = parse_sysfs_event(str, attr);
+	if (ret != EVT_FAILED)
+		goto modifier;
+
 	ret = parse_tracepoint_event(opt, str, attr);
 	if (ret != EVT_FAILED)
 		goto modifier;
-- 
1.7.5.1

