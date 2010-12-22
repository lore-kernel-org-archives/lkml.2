Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426Ab0LVL37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 06:29:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:34660 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367Ab0LVL35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 06:29:57 -0500
Date: Wed, 22 Dec 2010 11:29:26 GMT
From: tip-bot for Ian Munsie <imunsie@au1.ibm.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        imunsie@au1.ibm.com, fweisbec@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
        peterz@infradead.org, tglx@linutronix.de, imunsie@au1.ibm.com,
        mingo@elte.hu
In-Reply-To: <1291872833-839-1-git-send-email-imunsie@au1.ibm.com>
References: <1291872833-839-1-git-send-email-imunsie@au1.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record,report,annotate,diff: Process events in order
Message-ID: <tip-eac23d1c384b55e4bbb89ea9e5a6bb77fb4d1140@git.kernel.org>
Git-Commit-ID: eac23d1c384b55e4bbb89ea9e5a6bb77fb4d1140
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 22 Dec 2010 11:29:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eac23d1c384b55e4bbb89ea9e5a6bb77fb4d1140
Gitweb:     http://git.kernel.org/tip/eac23d1c384b55e4bbb89ea9e5a6bb77fb4d1140
Author:     Ian Munsie <imunsie@au1.ibm.com>
AuthorDate: Thu, 9 Dec 2010 16:33:53 +1100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 21 Dec 2010 20:17:51 -0200

perf record,report,annotate,diff: Process events in order

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

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <1291872833-839-1-git-send-email-imunsie@au1.ibm.com>
Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c |    2 ++
 tools/perf/builtin-diff.c     |    2 ++
 tools/perf/builtin-record.c   |    5 ++++-
 tools/perf/builtin-report.c   |    2 ++
 4 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 48dbab4..c056cdc 100644
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
index af84e1c..97846dc 100644
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
index efd1b3c..5149e3d 100644
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
index fd4c450..4af7ce6 100644
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
