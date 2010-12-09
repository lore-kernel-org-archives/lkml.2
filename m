Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497Ab0LIFeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 00:34:08 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:36240 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab0LIFeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 00:34:07 -0500
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Ian Munsie <imunsie@au1.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4] perf record,report,annotate,diff: Process events in order
Date: Thu,  9 Dec 2010 16:33:53 +1100
Message-Id: <1291872833-839-1-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <20101207124527.868085529@linutronix.de>
References: <20101207124527.868085529@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

This patch changes perf report to ask for the ID info on all events be
default if recording from multiple CPUs.

Perf report, annotate and diff will now process the events in order if
the kernel is able to provide timestamps on all events. This ensures
that events such as COMM and MMAP which are necessary to correctly
interpret samples are processed prior to those samples so that they are
attributed correctly.

Before:
 # perf record ./cachetest
 # perf report

 # Events: 6K cycles
 #
 # Overhead  Command      Shared Object                           Symbol
 # ........  .......  .................  ...............................
 #
     74.11%    :3259  [unknown]          [k] 0x4a6c
      1.50%  cachetest  ld-2.11.2.so       [.] 0x1777c
      1.46%    :3259  [kernel.kallsyms]  [k] .perf_event_mmap_ctx
      1.25%    :3259  [kernel.kallsyms]  [k] restore
      0.74%    :3259  [kernel.kallsyms]  [k] ._raw_spin_lock
      0.71%    :3259  [kernel.kallsyms]  [k] .filemap_fault
      0.66%    :3259  [kernel.kallsyms]  [k] .memset
      0.54%  cachetest  [kernel.kallsyms]  [k] .sha_transform
      0.54%    :3259  [kernel.kallsyms]  [k] .copy_4K_page
      0.54%    :3259  [kernel.kallsyms]  [k] .find_get_page
      0.52%    :3259  [kernel.kallsyms]  [k] .trace_hardirqs_off
      0.50%    :3259  [kernel.kallsyms]  [k] .__do_fault
<SNIP>

After:
 # perf report

 # Events: 6K cycles
 #
 # Overhead  Command      Shared Object                           Symbol
 # ........  .......  .................  ...............................
 #
     44.28%  cachetest  cachetest          [.] sumArrayNaive
     22.53%  cachetest  cachetest          [.] sumArrayOptimal
      6.59%  cachetest  ld-2.11.2.so       [.] 0x1777c
      2.13%  cachetest  [unknown]          [k] 0x340
      1.46%  cachetest  [kernel.kallsyms]  [k] .perf_event_mmap_ctx
      1.25%  cachetest  [kernel.kallsyms]  [k] restore
      0.74%  cachetest  [kernel.kallsyms]  [k] ._raw_spin_lock
      0.71%  cachetest  [kernel.kallsyms]  [k] .filemap_fault
      0.66%  cachetest  [kernel.kallsyms]  [k] .memset
      0.54%  cachetest  [kernel.kallsyms]  [k] .copy_4K_page
      0.54%  cachetest  [kernel.kallsyms]  [k] .find_get_page
      0.54%  cachetest  [kernel.kallsyms]  [k] .sha_transform
      0.52%  cachetest  [kernel.kallsyms]  [k] .trace_hardirqs_off
      0.50%  cachetest  [kernel.kallsyms]  [k] .__do_fault
<SNIP>

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---

Changelog:
v4
- Rebased on Thomas' new userspace perf patches (with report -D reordering)
- Also cause perf annotate and perf diff to process events in order

v3
- Rebased on Thomas' userspace perf patch
- Dropped my userspace changes that Thomas' patch also addressed
- Dropped report -D reordering

v2
- Rebased on Arnaldo's ABI changes

v1
- Original patch with my ABI changes & report -D reordering

 tools/perf/builtin-annotate.c |    2 ++
 tools/perf/builtin-diff.c     |    2 ++
 tools/perf/builtin-record.c   |    5 ++++-
 tools/perf/builtin-report.c   |    2 ++
 4 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 569a276..793db36 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -375,6 +375,8 @@ static struct perf_event_ops event_ops = {
 	.mmap	= event__process_mmap,
 	.comm	= event__process_comm,
 	.fork	= event__process_task,
+	.ordered_samples = true,
+	.ordering_requires_timestamps = true,
 };
 
 static int __cmd_annotate(void)
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 5e1a043..d21dc25a 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -61,6 +61,8 @@ static struct perf_event_ops event_ops = {
 	.exit	= event__process_task,
 	.fork	= event__process_task,
 	.lost	= event__process_lost,
+	.ordered_samples = true,
+	.ordering_requires_timestamps = true,
 };
 
 static void perf_session__insert_hist_entry_by_name(struct rb_root *root,
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 699dd21..310dd21 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -285,7 +285,7 @@ static void create_counter(int counter, int cpu)
 	if (system_wide)
 		attr->sample_type	|= PERF_SAMPLE_CPU;
 
-	if (sample_time)
+	if (sample_time || system_wide || !no_inherit || cpu_list)
 		attr->sample_type	|= PERF_SAMPLE_TIME;
 
 	if (raw_samples) {
@@ -327,6 +327,9 @@ try_again:
 				 * Old kernel, no attr->sample_id_type_all field
 				 */
 				sample_id_all_avail = false;
+				if (!sample_time && !raw_samples)
+					attr->sample_type &= ~PERF_SAMPLE_TIME;
+
 				goto retry_sample_id;
 			}
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 904519f..5f01503 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -244,6 +244,8 @@ static struct perf_event_ops event_ops = {
 	.event_type = event__process_event_type,
 	.tracing_data = event__process_tracing_data,
 	.build_id = event__process_build_id,
+	.ordered_samples = true,
+	.ordering_requires_timestamps = true,
 };
 
 extern volatile int session_done;
-- 
1.7.2.3

