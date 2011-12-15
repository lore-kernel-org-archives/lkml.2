Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292Ab1LORYL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 12:24:11 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:42394
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759238Ab1LORYH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 12:24:07 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzc89bhzz1202hzz8275bhz2dh668h839h93fh)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LW99NY-02-0QU-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH 1/4] perf tool: Parse general/raw events from sysfs
Date: Thu, 15 Dec 2011 18:23:41 +0100
Message-ID: <1323969824-9711-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1323969824-9711-1-git-send-email-robert.richter@amd.com>
References: <1323969824-9711-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lin Ming <ming.m.lin@intel.com>

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
index 586ab3f..4ce9404 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -685,7 +685,7 @@ parse_symbolic_event(const char **strp, struct perf_event_attr *attr)
 }
 
 static enum event_result
-parse_raw_event(const char **strp, struct perf_event_attr *attr)
+parse_raw_config(const char **strp, struct perf_event_attr *attr)
 {
 	const char *str = *strp;
 	u64 config;
@@ -700,7 +700,6 @@ parse_raw_event(const char **strp, struct perf_event_attr *attr)
 			return EVT_FAILED;
 
 		*strp = end;
-		attr->type = PERF_TYPE_RAW;
 		attr->config = config;
 		return EVT_HANDLED;
 	}
@@ -708,6 +707,83 @@ parse_raw_event(const char **strp, struct perf_event_attr *attr)
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
@@ -788,6 +864,10 @@ parse_event_symbols(struct perf_evlist *evlist, const char **str,
 {
 	enum event_result ret;
 
+	ret = parse_sysfs_event(str, attr);
+	if (ret != EVT_FAILED)
+		goto modifier;
+
 	ret = parse_tracepoint_event(evlist, str, attr);
 	if (ret != EVT_FAILED)
 		goto modifier;
-- 
1.7.7


