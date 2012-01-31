Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab2AaNSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 08:18:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55067 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab2AaNSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 08:18:51 -0500
Date: Tue, 31 Jan 2012 05:18:32 -0800
From: tip-bot for Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Message-ID: <tip-9558259697b827106b464648e850e568e0b0c931@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, akihiro.nagai.hw@hitachi.com,
        peterz@infradead.org, fweisbec@gmail.com,
        masami.hiramatsu.pt@hitachi.com, dsahern@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com,
        akihiro.nagai.hw@hitachi.com, peterz@infradead.org,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20120130044309.2384.44252.stgit@linux3>
References: <20120130044309.2384.44252.stgit@linux3>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script:
  Print branch_from and branch_to of BTS events
Git-Commit-ID: 9558259697b827106b464648e850e568e0b0c931
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 31 Jan 2012 05:18:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9558259697b827106b464648e850e568e0b0c931
Gitweb:     http://git.kernel.org/tip/9558259697b827106b464648e850e568e0b0c931
Author:     Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
AuthorDate: Mon, 30 Jan 2012 13:43:09 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 30 Jan 2012 18:08:43 -0200

perf script: Print branch_from and branch_to of BTS events

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
