Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab2AaBYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 20:24:53 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54877 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab2AaBYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 20:24:51 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>, yrl.pp-manager.tt@hitachi.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/9] perf script: Print branch_from and branch_to of BTS events
Date: Mon, 30 Jan 2012 23:24:33 -0200
Message-Id: <1327973079-29426-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.rc2.1.g69204
In-Reply-To: <1327973079-29426-1-git-send-email-acme@infradead.org>
References: <1327973079-29426-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>

BTS records branch_from_addr and branch_to_addr in IP and ADDR field in perf_sample.
This patch enables to print them in following format,

<from_addr> <from_symbol> (<from_dso>) => <to_addr> <to_symbol> (<to_dso>)

Sample:
 ffffffff814675d2 irq_return ([kernel.kallsyms]) => 3f03e016b0    _start (/lib64/ld-2.14.so)
 ffffffff814675d2 irq_return ([kernel.kallsyms]) => 3f03e016b0    _start (/lib64/ld-2.14.so)
       3f03e016b3     _start (/lib64/ld-2.14.so) => 3f03e04b80 _dl_start (/lib64/ld-2.14.so)
 ffffffff814675d2 irq_return ([kernel.kallsyms]) => 3f03e04b80 _dl_start (/lib64/ld-2.14.so)
 ffffffff814675d2 irq_return ([kernel.kallsyms]) => 3f03e04ba6 _dl_start (/lib64/ld-2.14.so)
 ffffffff814675d2 irq_return ([kernel.kallsyms]) => 3f03e04bad _dl_start (/lib64/ld-2.14.so)
       3f03e04bfb  _dl_start (/lib64/ld-2.14.so) => 3f03e04c1d _dl_start (/lib64/ld-2.14.so)
[snip]

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: yrl.pp-manager.tt@hitachi.com
Link: http://lkml.kernel.org/r/20120130044309.2384.44252.stgit@linux3
Signed-off-by: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index add13ec..414d49a 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -304,6 +304,13 @@ static void print_sample_start(struct perf_sample *sample,
 	}
 }
 
+static bool is_bts_event(struct perf_event_attr *attr)
+{
+	return ((attr->type == PERF_TYPE_HARDWARE) &&
+		(attr->config & PERF_COUNT_HW_BRANCH_INSTRUCTIONS) &&
+		(attr->sample_period == 1));
+}
+
 static bool sample_addr_correlates_sym(struct perf_event_attr *attr)
 {
 	if ((attr->type == PERF_TYPE_SOFTWARE) &&
@@ -312,6 +319,9 @@ static bool sample_addr_correlates_sym(struct perf_event_attr *attr)
 	     (attr->config == PERF_COUNT_SW_PAGE_FAULTS_MAJ)))
 		return true;
 
+	if (is_bts_event(attr))
+		return true;
+
 	return false;
 }
 
@@ -353,6 +363,33 @@ static void print_sample_addr(union perf_event *event,
 	}
 }
 
+static void print_sample_bts(union perf_event *event,
+			     struct perf_sample *sample,
+			     struct perf_evsel *evsel,
+			     struct machine *machine,
+			     struct thread *thread)
+{
+	struct perf_event_attr *attr = &evsel->attr;
+
+	/* print branch_from information */
+	if (PRINT_FIELD(IP)) {
+		if (!symbol_conf.use_callchain)
+			printf(" ");
+		else
+			printf("\n");
+		perf_event__print_ip(event, sample, machine, evsel,
+				     PRINT_FIELD(SYM), PRINT_FIELD(DSO));
+	}
+
+	printf(" => ");
+
+	/* print branch_to information */
+	if (PRINT_FIELD(ADDR))
+		print_sample_addr(event, sample, machine, thread, attr);
+
+	printf("\n");
+}
+
 static void process_event(union perf_event *event __unused,
 			  struct perf_sample *sample,
 			  struct perf_evsel *evsel,
@@ -366,6 +403,11 @@ static void process_event(union perf_event *event __unused,
 
 	print_sample_start(sample, thread, attr);
 
+	if (is_bts_event(attr)) {
+		print_sample_bts(event, sample, evsel, machine, thread);
+		return;
+	}
+
 	if (PRINT_FIELD(TRACE))
 		print_trace_event(sample->cpu, sample->raw_data,
 				  sample->raw_size);
-- 
1.7.9.rc2.1.g69204

