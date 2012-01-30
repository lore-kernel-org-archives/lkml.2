Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab2A3Eof (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 23:44:35 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:53930 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445Ab2A3Eoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 23:44:32 -0500
X-AuditID: b753bd60-9825fba00000359c-52-4f26202ef544
X-AuditID: b753bd60-9825fba00000359c-52-4f26202ef544
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Subject: [PATCH -tip v5 3/5] perf script: print branch_from and branch_to of
 BTS events
To: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Mon, 30 Jan 2012 13:43:09 +0900
Message-ID: <20120130044309.2384.44252.stgit@linux3>
In-Reply-To: <20120130044242.2384.23076.stgit@linux3>
References: <20120130044242.2384.23076.stgit@linux3>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BTS records branch_from_addr and branch_to_addr in IP and ADDR field in perf_sample.
This patch enables to print them in following format,

<from_addr> <from_symbol> (<from_dso>) => <to_addr> <to_symbol> (<to_dso>)

Sample:
# perf script -f ip,addr,dso,sym
 ffffffff814675d2 irq_return ([kernel.kallsyms]) => 3f03e016b0    _start (/lib64/ld-2.14.so)
 ffffffff814675d2 irq_return ([kernel.kallsyms]) => 3f03e016b0    _start (/lib64/ld-2.14.so)
       3f03e016b3     _start (/lib64/ld-2.14.so) => 3f03e04b80 _dl_start (/lib64/ld-2.14.so)
 ffffffff814675d2 irq_return ([kernel.kallsyms]) => 3f03e04b80 _dl_start (/lib64/ld-2.14.so)
 ffffffff814675d2 irq_return ([kernel.kallsyms]) => 3f03e04ba6 _dl_start (/lib64/ld-2.14.so)
 ffffffff814675d2 irq_return ([kernel.kallsyms]) => 3f03e04bad _dl_start (/lib64/ld-2.14.so)
       3f03e04bfb  _dl_start (/lib64/ld-2.14.so) => 3f03e04c1d _dl_start (/lib64/ld-2.14.so)
[snip]

Changes in v5:
 - Change the output format "<branch_to> <branch_from>" to
   "<branch_from> => <branch_to>"

Signed-off-by: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
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

