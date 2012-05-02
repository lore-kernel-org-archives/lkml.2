Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab2EBS1z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 14:27:55 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:12673
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755719Ab2EBS0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 14:26:53 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bh)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M3ER8K-01-6JQ-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 3/7] perf tools: Add parser for dynamic PMU events
Date: Wed, 2 May 2012 20:26:28 +0200
Message-ID: <1335983192-23731-4-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1335983192-23731-1-git-send-email-robert.richter@amd.com>
References: <1335983192-23731-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for pmu specific event parsers by extending
the pmu handler. The event syntax is the same as for tracepoints:

 <subsys>:<name>:<modifier>

In case of dynamically allocated pmus the sub-system's name is the
name of the pmu. For the IBS pmu we have events like the following:

 ibs_op:ALL                                         [PMU event: ibs_op]
 ibs_op:ALL_LOAD_STORE                              [PMU event: ibs_op]
 ibs_op:BANK_CONF_LOAD                              [PMU event: ibs_op]
 ibs_op:BANK_CONF_STORE                             [PMU event: ibs_op]
 ibs_op:BRANCH_RETIRED                              [PMU event: ibs_op]
 ibs_op:CANCELLED                                   [PMU event: ibs_op]
 ibs_op:COMP_TO_RET                                 [PMU event: ibs_op]
 ...

The parser for pmu events is implemented in the .parse_event()
function of the handler.

Since we share the same syntax with tracepoints, tracepoints are
preferred in case of name collisions. Thus, this implementation is
backward compatible.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 tools/perf/util/parse-events.c |   34 +++++++++++++++++++++++++++++++++-
 tools/perf/util/parse-events.h |    4 ++--
 tools/perf/util/parse-events.y |    6 +++---
 tools/perf/util/pmu-ibs.c      |   22 ++++++++++++++++++++++
 tools/perf/util/pmu.c          |   13 +++++++++++++
 tools/perf/util/pmu.h          |    4 ++++
 6 files changed, 77 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 8962544..d572204 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -519,7 +519,7 @@ static int add_tracepoint_multi(struct list_head *list, int *idx,
 	return ret;
 }
 
-int parse_events_add_tracepoint(struct list_head *list, int *idx,
+static int parse_events_add_tracepoint(struct list_head *list, int *idx,
 				char *sys, char *event)
 {
 	int ret;
@@ -533,6 +533,38 @@ int parse_events_add_tracepoint(struct list_head *list, int *idx,
 	       add_tracepoint(list, idx, sys, event);
 }
 
+static int __parse_events_add_generic_event(struct list_head *list, int *idx,
+					    char *sys, char *event)
+{
+	struct perf_event_attr attr;
+	char name[MAX_NAME_LEN];
+	int ret;
+
+	memset(&attr, 0, sizeof(attr));
+	ret = perf_pmu__parse_event(&attr, sys, event);
+	if (ret)
+		return ret;
+
+	snprintf(name, MAX_NAME_LEN, "%s:%s", sys, event);
+	return add_event(list, idx, &attr, name);
+}
+
+int parse_events_add_generic_event(struct list_head *list, int *idx,
+				   char *sys, char *event)
+{
+	int ret1, ret2;
+
+	ret1 = parse_events_add_tracepoint(list, idx, sys, event);
+	if (!ret1)
+		return 0;
+
+	ret2 = __parse_events_add_generic_event(list, idx, sys, event);
+	if (!ret2)
+		return 0;
+
+	return ret1 == -ENOENT ? ret2 : ret1;
+}
+
 static int
 parse_breakpoint_type(const char *type, struct perf_event_attr *attr)
 {
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index ca069f8..e9df741 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -62,8 +62,8 @@ int parse_events__new_term(struct parse_events__term **term, int type,
 			   char *config, char *str, long num);
 void parse_events__free_terms(struct list_head *terms);
 int parse_events_modifier(struct list_head *list __used, char *str __used);
-int parse_events_add_tracepoint(struct list_head *list, int *idx,
-				char *sys, char *event);
+int parse_events_add_generic_event(struct list_head *list, int *idx,
+				   char *sys, char *event);
 int parse_events_add_raw(struct perf_evlist *evlist, unsigned long config,
 			 unsigned long config1, unsigned long config2,
 			 char *mod);
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index d9637da..659b5e8 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -75,7 +75,7 @@ event_def: event_pmu |
 	   event_legacy_symbol |
 	   event_legacy_cache sep_dc |
 	   event_legacy_mem |
-	   event_legacy_tracepoint sep_dc |
+	   event_legacy_generic sep_dc |
 	   event_legacy_numeric sep_dc |
 	   event_legacy_raw sep_dc
 
@@ -131,10 +131,10 @@ PE_PREFIX_MEM PE_VALUE sep_dc
 	ABORT_ON(parse_events_add_breakpoint(list_event, idx, (void *) $2, NULL));
 }
 
-event_legacy_tracepoint:
+event_legacy_generic:
 PE_NAME ':' PE_NAME
 {
-	ABORT_ON(parse_events_add_tracepoint(list_event, idx, $1, $3));
+	ABORT_ON(parse_events_add_generic_event(list_event, idx, $1, $3));
 }
 
 event_legacy_numeric:
diff --git a/tools/perf/util/pmu-ibs.c b/tools/perf/util/pmu-ibs.c
index 5cf8601..07acb82 100644
--- a/tools/perf/util/pmu-ibs.c
+++ b/tools/perf/util/pmu-ibs.c
@@ -8,6 +8,7 @@
 
 #include <stdio.h>
 #include <string.h>
+#include <errno.h>
 #include <linux/compiler.h>
 #include "pmu.h"
 
@@ -75,6 +76,25 @@ static const char *events[] = {
 	NULL
 };
 
+static int ibs_parse_event(struct perf_event_attr *attr, char *sys, char *name)
+{
+	const char **event;
+
+	if (strcmp("ibs_op", sys) && strcmp("ibs_fetch", sys))
+		return -ENOENT;
+
+	for (event = events; *event; event++) {
+		if (!strcmp(*event + strlen(sys) + 1, name))
+			goto match;
+	}
+
+	return -EINVAL;
+match:
+	attr->sample_type = PERF_SAMPLE_CPU;
+
+	return 0;
+}
+
 static void ibs_print_events(const char *sys)
 {
 	const char **event;
@@ -89,10 +109,12 @@ static void ibs_print_events(const char *sys)
 
 struct pmu_handler pmu_ibs_fetch = {
 	.name		= "ibs_fetch",
+	.parse_event	= ibs_parse_event,
 	.print_events	= ibs_print_events,
 };
 
 struct pmu_handler pmu_ibs_op = {
 	.name		= "ibs_op",
+	.parse_event	= ibs_parse_event,
 	.print_events	= ibs_print_events,
 };
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 7bfaba1..5767a9c 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -29,6 +29,19 @@ static struct pmu_handler *pmu_handlers[] = {
 	NULL		/* terminator */
 };
 
+int perf_pmu__parse_event(struct perf_event_attr *attr,
+			  char *sys, char *event)
+{
+	struct perf_pmu *pmu = perf_pmu__find(sys);
+
+	if (pmu && pmu->handler) {
+		attr->type = pmu->type;
+		return pmu->handler->parse_event(attr, sys, event);
+	}
+
+	return -ENOENT;
+}
+
 void perf_pmu__print_events(const char *sys)
 {
 	struct perf_pmu *pmu = NULL;
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index e5788aa..20b4e39 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -22,6 +22,8 @@ struct perf_pmu__format {
 struct pmu_handler {
 	const char *name;
 
+	int (*parse_event)(struct perf_event_attr *attr,
+			   char *sys, char *event);
 	void(*print_events)(const char *sys);
 };
 
@@ -47,6 +49,8 @@ void perf_pmu__set_format(unsigned long *bits, long from, long to);
 int perf_pmu__test(void);
 
 struct perf_pmu *perf_pmu__scan(struct perf_pmu *pmu);
+int perf_pmu__parse_event(struct perf_event_attr *attr,
+			  char *sys, char *event);
 void perf_pmu__print_events(const char *sys);
 
 /* supported pmus: */
-- 
1.7.8.4


