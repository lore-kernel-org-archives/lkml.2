Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab0EDOAV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 10:00:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58987 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932295Ab0EDOAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 10:00:18 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 2/3] perf inject: Add missing bits
Date: Tue,  4 May 2010 11:00:06 -0300
Message-Id: <1272981607-28723-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1272981607-28723-1-git-send-email-acme@infradead.org>
References: <1272981607-28723-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

New commands need to have Documentation and be added to command-list.txt
so that they can appear when 'perf' is called withouth any subcommand:

[root@doppio linux-2.6-tip]# perf

 usage: perf [--version] [--help] COMMAND [ARGS]

 The most commonly used perf commands are:
   annotate        Read perf.data (created by perf record) and display annotated code
   archive         Create archive with object files with build-ids found in perf.data file
   bench           General framework for benchmark suites
   buildid-cache   Manage build-id cache.
   buildid-list    List the buildids in a perf.data file
   diff            Read two perf.data files and display the differential profile
   inject          Filter to augment the events stream with additional information
   kmem            Tool to trace/measure kernel memory(slab) properties
   kvm             Tool to trace/measure kvm guest os
   list            List all symbolic event types
   lock            Analyze lock events
   probe           Define new dynamic tracepoints
   record          Run a command and record its profile into perf.data
   report          Read perf.data (created by perf record) and display the profile
   sched           Tool to trace/measure scheduler properties (latencies)
   stat            Run a command and gather performance counter statistics
   test            Runs sanity tests.
   timechart       Tool to visualize total system behavior during a workload
   top             System profiling tool.
   trace           Read perf.data (created by perf record) and display trace output

 See 'perf help COMMAND' for more information on a specific command.

[root@doppio linux-2.6-tip]#

The new 'perf inject' command hadn't so it wasn't appearing on that list.

Also fix the long option, that should have no spaces in it, rename the faulty one
to be '--build-ids', instead of '--inject build-ids'.

Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-buildid-cache.txt |    4 +-
 tools/perf/Documentation/perf-inject.txt        |   35 +++++++++++++++++++++++
 tools/perf/builtin-inject.c                     |    2 +-
 tools/perf/command-list.txt                     |    1 +
 4 files changed, 39 insertions(+), 3 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-inject.txt

diff --git a/tools/perf/Documentation/perf-buildid-cache.txt b/tools/perf/Documentation/perf-buildid-cache.txt
index 88bc3b5..5d1a950 100644
--- a/tools/perf/Documentation/perf-buildid-cache.txt
+++ b/tools/perf/Documentation/perf-buildid-cache.txt
@@ -8,7 +8,7 @@ perf-buildid-cache - Manage build-id cache.
 SYNOPSIS
 --------
 [verse]
-'perf buildid-list <options>'
+'perf buildid-cache <options>'
 
 DESCRIPTION
 -----------
@@ -30,4 +30,4 @@ OPTIONS
 
 SEE ALSO
 --------
-linkperf:perf-record[1], linkperf:perf-report[1]
+linkperf:perf-record[1], linkperf:perf-report[1], linkperf:perf-buildid-list[1]
diff --git a/tools/perf/Documentation/perf-inject.txt b/tools/perf/Documentation/perf-inject.txt
new file mode 100644
index 0000000..025630d
--- /dev/null
+++ b/tools/perf/Documentation/perf-inject.txt
@@ -0,0 +1,35 @@
+perf-inject(1)
+==============
+
+NAME
+----
+perf-inject - Filter to augment the events stream with additional information
+
+SYNOPSIS
+--------
+[verse]
+'perf inject <options>'
+
+DESCRIPTION
+-----------
+perf-inject reads a perf-record event stream and repipes it to stdout.  At any
+point the processing code can inject other events into the event stream - in
+this case build-ids (-b option) are read and injected as needed into the event
+stream.
+
+Build-ids are just the first user of perf-inject - potentially anything that
+needs userspace processing to augment the events stream with additional
+information could make use of this facility.
+
+OPTIONS
+-------
+-b::
+--build-ids=::
+        Inject build-ids into the output stream
+-v::
+--verbose::
+	Be more verbose.
+
+SEE ALSO
+--------
+linkperf:perf-record[1], linkperf:perf-report[1], linkperf:perf-archive[1]
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 59e981a..8e3e47b 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -204,7 +204,7 @@ static const char * const report_usage[] = {
 };
 
 static const struct option options[] = {
-	OPT_BOOLEAN('b', "inject build-ids", &inject_build_ids,
+	OPT_BOOLEAN('b', "build-ids", &inject_build_ids,
 		    "Inject build-ids into the output stream"),
 	OPT_INCR('v', "verbose", &verbose,
 		 "be more verbose (show build ids, etc)"),
diff --git a/tools/perf/command-list.txt b/tools/perf/command-list.txt
index 80a1a44..949d77f 100644
--- a/tools/perf/command-list.txt
+++ b/tools/perf/command-list.txt
@@ -8,6 +8,7 @@ perf-bench			mainporcelain common
 perf-buildid-cache		mainporcelain common
 perf-buildid-list		mainporcelain common
 perf-diff			mainporcelain common
+perf-inject			mainporcelain common
 perf-list			mainporcelain common
 perf-sched			mainporcelain common
 perf-record			mainporcelain common
-- 
1.6.2.5

