Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab2EBS0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 14:26:54 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:36820
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755861Ab2EBS0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 14:26:52 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bh)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M3ER8L-02-FJD-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 5/7] perf, tools: Add raw event support for dynamic allocated pmus
Date: Wed, 2 May 2012 20:26:30 +0200
Message-ID: <1335983192-23731-6-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1335983192-23731-1-git-send-email-robert.richter@amd.com>
References: <1335983192-23731-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends the event parser to pass raw config values to a
dynamic allocated pmu. The following event syntax is supported now:

 <pmu_name>:<raw_config_value>:<modifier>

Example for the ibs pmu:

 # perf record -a -e ibs_op:r000 ...

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 tools/perf/util/parse-events.c |   20 +++++++++++++++-----
 tools/perf/util/parse-events.h |    2 +-
 tools/perf/util/parse-events.y |    7 ++++++-
 tools/perf/util/pmu-ibs.c      |    4 ++++
 4 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index d572204..8ad536c 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -524,6 +524,9 @@ static int parse_events_add_tracepoint(struct list_head *list, int *idx,
 {
 	int ret;
 
+	if (!event)
+		return -ENOENT;
+
 	ret = debugfs_valid_mountpoint(tracing_events_path);
 	if (ret)
 		return ret;
@@ -533,8 +536,9 @@ static int parse_events_add_tracepoint(struct list_head *list, int *idx,
 	       add_tracepoint(list, idx, sys, event);
 }
 
-static int __parse_events_add_generic_event(struct list_head *list, int *idx,
-					    char *sys, char *event)
+static int
+__parse_events_add_generic_event(struct list_head *list, int *idx, char *sys,
+				 char *event, unsigned long config)
 {
 	struct perf_event_attr attr;
 	char name[MAX_NAME_LEN];
@@ -545,12 +549,18 @@ static int __parse_events_add_generic_event(struct list_head *list, int *idx,
 	if (ret)
 		return ret;
 
-	snprintf(name, MAX_NAME_LEN, "%s:%s", sys, event);
+	if (event)
+		snprintf(name, MAX_NAME_LEN, "%s:%s", sys, event);
+	else
+		snprintf(name, MAX_NAME_LEN, "%s:r%lx", sys, config);
+
+	attr.config |= config;
+
 	return add_event(list, idx, &attr, name);
 }
 
 int parse_events_add_generic_event(struct list_head *list, int *idx,
-				   char *sys, char *event)
+				   char *sys, char *event, unsigned long config)
 {
 	int ret1, ret2;
 
@@ -558,7 +568,7 @@ int parse_events_add_generic_event(struct list_head *list, int *idx,
 	if (!ret1)
 		return 0;
 
-	ret2 = __parse_events_add_generic_event(list, idx, sys, event);
+	ret2 = __parse_events_add_generic_event(list, idx, sys, event, config);
 	if (!ret2)
 		return 0;
 
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index e9df741..88950d8 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -63,7 +63,7 @@ int parse_events__new_term(struct parse_events__term **term, int type,
 void parse_events__free_terms(struct list_head *terms);
 int parse_events_modifier(struct list_head *list __used, char *str __used);
 int parse_events_add_generic_event(struct list_head *list, int *idx,
-				   char *sys, char *event);
+				   char *sys, char *event, unsigned long config);
 int parse_events_add_raw(struct perf_evlist *evlist, unsigned long config,
 			 unsigned long config1, unsigned long config2,
 			 char *mod);
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 659b5e8..d07fddd 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -134,7 +134,12 @@ PE_PREFIX_MEM PE_VALUE sep_dc
 event_legacy_generic:
 PE_NAME ':' PE_NAME
 {
-	ABORT_ON(parse_events_add_generic_event(list_event, idx, $1, $3));
+	ABORT_ON(parse_events_add_generic_event(list_event, idx, $1, $3, 0));
+}
+|
+PE_NAME ':' PE_RAW
+{
+	ABORT_ON(parse_events_add_generic_event(list_event, idx, $1, NULL, $3));
 }
 
 event_legacy_numeric:
diff --git a/tools/perf/util/pmu-ibs.c b/tools/perf/util/pmu-ibs.c
index 604cb8c..a5468c8 100644
--- a/tools/perf/util/pmu-ibs.c
+++ b/tools/perf/util/pmu-ibs.c
@@ -375,6 +375,9 @@ static int ibs_parse_event(struct perf_event_attr *attr, char *sys, char *name)
 	if (strcmp("ibs_op", sys) && strcmp("ibs_fetch", sys))
 		return -ENOENT;
 
+	if (!name)
+		goto out;	/* raw event if name is NULL */
+
 	for (event = events; event->id; event++) {
 		if (!strcmp(event->name + strlen(sys) + 1, name))
 			goto match;
@@ -384,6 +387,7 @@ static int ibs_parse_event(struct perf_event_attr *attr, char *sys, char *name)
 match:
 	/* pseudo event found */
 	attr->config1 = event->config;
+out:
 	attr->sample_type = PERF_SAMPLE_CPU;
 
 	return 0;
-- 
1.7.8.4


