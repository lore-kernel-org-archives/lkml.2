Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab1GOOa7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 10:30:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:41991 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978Ab1GOOaC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 10:30:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,535,1304319600"; 
   d="scan'208";a="26267136"
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 6/6] perf tool: Parse general/raw events from sysfs
Date: Fri, 15 Jul 2011 14:35:03 +0000
Message-Id: <1310740503-15608-7-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1310740503-15608-1-git-send-email-ming.m.lin@intel.com>
References: <1310740503-15608-1-git-send-email-ming.m.lin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PMU can export general events to sysfs, for example,

/sys/bus/event_source/devices/uncore/events
└── cycle

Then specify the event as <pmu>:<event>,

$ sudo perf stat -a -C 0 -e uncore:cycle
^C
 Performance counter stats for 'CPU 0':

        56,547,314 uncore:cycle

Raw event can be specified as <pmu>:rXXXX

$ sudo perf stat -a -C 0 -e uncore:r0101
^C
 Performance counter stats for 'CPU 0':

             8,504 uncore:r0101

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 tools/perf/util/parse-events.c |   84 +++++++++++++++++++++++++++++++++++++++-
 1 files changed, 82 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 41982c3..2de52f9 100644
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
@@ -703,6 +702,83 @@ parse_raw_event(const char **strp, struct perf_event_attr *attr)
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
+static u64 read_sysfs_entry(const char *path)
+{
+	char buf[19];
+	int fd;
+
+	fd = open(path, O_RDONLY);
+	if (fd < 0)
+		return -1;
+
+	if (read(fd, buf, sizeof(buf)) < 0) {
+		close(fd);
+		return -1;
+	}
+
+	close(fd);
+	return atoll(buf);
+}
+
+static u64 get_pmu_type(const char *pmu_name)
+{
+	char evt_path[MAXPATHLEN];
+
+	snprintf(evt_path, MAXPATHLEN, "%s/%s/type", EVENT_SOURCE_DIR,
+		 pmu_name);
+
+	return read_sysfs_entry(evt_path);
+}
+
+static u64 get_pmu_event_config(const char *pmu_name, const char *evt_name)
+{
+	char evt_path[MAXPATHLEN];
+
+	snprintf(evt_path, MAXPATHLEN, "%s/%s/events/%s", EVENT_SOURCE_DIR,
+		 pmu_name, evt_name);
+
+	return read_sysfs_entry(evt_path);
+}
+
+static enum event_result
+parse_sysfs_event(const char **strp, struct perf_event_attr *attr)
+{
+	char *pmu_name, *evt_name;
+	u64 type, config;
+
+	pmu_name = strchr(*strp, ':');
+	if (!pmu_name)
+		return EVT_FAILED;
+	pmu_name = strndup(*strp, pmu_name - *strp);
+	type = get_pmu_type(pmu_name);
+	if ((int)type < 0)
+		return EVT_FAILED;
+	attr->type = type;
+
+	evt_name = strchr(*strp, ':') + 1;
+	config = get_pmu_event_config(pmu_name, evt_name);
+	*strp += strlen(pmu_name) + 1; /* + 1 for the ':' */
+
+	if ((int)config < 0)
+		return parse_raw_config(strp, attr);
+
+	attr->config = config;
+	*strp += strlen(evt_name);
+	return EVT_HANDLED;
+}
+
+static enum event_result
 parse_numeric_event(const char **strp, struct perf_event_attr *attr)
 {
 	const char *str = *strp;
@@ -783,6 +859,10 @@ parse_event_symbols(const struct option *opt, const char **str,
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

