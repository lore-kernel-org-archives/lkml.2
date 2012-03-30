Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760471Ab2C3DuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 23:50:21 -0400
Received: from intmgw002.ash2.facebook.com ([66.220.155.179]:38369 "EHLO
	intmgw003.ash2.facebook.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759006Ab2C3DuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 23:50:17 -0400
From: Arun Sharma <asharma@fb.com>
To: linux-kernel@vger.kernel.org
Cc: Arun Sharma <asharma@fb.com>, Stephane Eranian <eranian@google.com>,
        peterz@infradead.org, acme@redhat.com, ravitillo@lbl.gov,
        vweaver1@eecs.utk.edu, khandual@linux.vnet.ibm.com, dsahern@gmail.com,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH] perf: Add branch stack support to perf script (v2)
Date: Thu, 29 Mar 2012 20:49:57 -0700
Message-Id: <1333079397-1772-1-git-send-email-asharma@fb.com>
X-Mailer: git-send-email 1.7.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes it easier to write tools that consume the
branch stack data.

Sample usage:

perf record -jany_call,u -o perf.data.anycallu -- ./foo
perf script -i perf.data.anycallu -fip,sym

Signed-off-by: Arun Sharma <asharma@fb.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: peterz@infradead.org
Cc: acme@redhat.com
Cc: ravitillo@lbl.gov
Cc: vweaver1@eecs.utk.edu
Cc: khandual@linux.vnet.ibm.com
Cc: dsahern@gmail.com
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/builtin-script.c |   56 ++++++++++++++++++++++++++++++++++++++----
 1 files changed, 50 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index d4ce733..f71c54c 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -318,6 +318,11 @@ static bool is_bts_event(struct perf_event_attr *attr)
 		(attr->sample_period == 1));
 }
 
+static bool is_branch_stack_event(struct perf_event_attr *attr)
+{
+	return (attr->sample_type & PERF_SAMPLE_BRANCH_STACK);
+}
+
 static bool sample_addr_correlates_sym(struct perf_event_attr *attr)
 {
 	if ((attr->type == PERF_TYPE_SOFTWARE) &&
@@ -326,31 +331,32 @@ static bool sample_addr_correlates_sym(struct perf_event_attr *attr)
 	     (attr->config == PERF_COUNT_SW_PAGE_FAULTS_MAJ)))
 		return true;
 
-	if (is_bts_event(attr))
+	if (is_bts_event(attr) || is_branch_stack_event(attr))
 		return true;
 
 	return false;
 }
 
-static void print_sample_addr(union perf_event *event,
+static void __print_sample_addr(union perf_event *event,
 			  struct perf_sample *sample,
 			  struct machine *machine,
 			  struct thread *thread,
-			  struct perf_event_attr *attr)
+			  struct perf_event_attr *attr,
+			  u64 addr)
 {
 	struct addr_location al;
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 
-	printf("%16" PRIx64, sample->addr);
+	printf("%16" PRIx64, addr);
 
 	if (!sample_addr_correlates_sym(attr))
 		return;
 
 	thread__find_addr_map(thread, machine, cpumode, MAP__FUNCTION,
-			      sample->addr, &al);
+			      addr, &al);
 	if (!al.map)
 		thread__find_addr_map(thread, machine, cpumode, MAP__VARIABLE,
-				      sample->addr, &al);
+				      addr, &al);
 
 	al.cpu = sample->cpu;
 	al.sym = NULL;
@@ -373,6 +379,17 @@ static void print_sample_addr(union perf_event *event,
 	}
 }
 
+static void print_sample_addr(union perf_event *event,
+			  struct perf_sample *sample,
+			  struct machine *machine,
+			  struct thread *thread,
+			  struct perf_event_attr *attr)
+			  
+{
+	return __print_sample_addr(event, sample, machine, thread, attr,
+				   sample->addr);
+}
+
 static void print_sample_bts(union perf_event *event,
 			     struct perf_sample *sample,
 			     struct perf_evsel *evsel,
@@ -401,6 +418,28 @@ static void print_sample_bts(union perf_event *event,
 	printf("\n");
 }
 
+static void print_sample_branch_stack(union perf_event *event,
+			     struct perf_sample *sample,
+			     struct perf_evsel *evsel,
+			     struct machine *machine,
+			     struct thread *thread)
+{
+	uint64_t i;
+	struct perf_event_attr *attr = &evsel->attr;
+
+	printf("... branch stack: nr:%" PRIu64 "\n", sample->branch_stack->nr);
+
+	for (i = 0; i < sample->branch_stack->nr; i++) {
+		printf("\t..... %2"PRIu64": ", i); 
+		__print_sample_addr(event, sample, machine, thread, attr,
+			            sample->branch_stack->entries[i].from);
+		printf(" => ");
+		__print_sample_addr(event, sample, machine, thread, attr,
+			            sample->branch_stack->entries[i].to);
+		printf("\n");
+	}
+}
+
 static void process_event(union perf_event *event __unused,
 			  struct perf_sample *sample,
 			  struct perf_evsel *evsel,
@@ -417,6 +456,11 @@ static void process_event(union perf_event *event __unused,
 	if (is_bts_event(attr)) {
 		print_sample_bts(event, sample, evsel, machine, thread);
 		return;
+	} 
+
+	if (is_branch_stack_event(attr)) {
+		print_sample_branch_stack(event, sample, evsel, machine, thread);
+		return;
 	}
 
 	if (PRINT_FIELD(TRACE))
-- 
1.7.8.4

