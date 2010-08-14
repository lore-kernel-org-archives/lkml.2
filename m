Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932863Ab0HNEkN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 00:40:13 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:49304 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932661Ab0HNEkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 00:40:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=aJt8zk8fP8+stVmR5S/CWQ8Yjf3ivSeP1Hyq2Vj3bippwkjGxPQPoOJGN96aFIGhaL
         yMmtl46mgVUx4A9nvucLmt9VcEYEV2KQbb7T5MdMpdnR5/xBb1n4Ax6X61NO3uOBbbc5
         QwPZWPcI0+DdUDEe4L1HA08cfSgMGD1gt692Q=
Subject: [PATCH] perf trace: get rid of the hard-coded paths in the report
 scripts, v3
From: Tom Zanussi <tzanussi@gmail.com>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, acme@infradead.org, mingo@elte.hu,
        acme@redhat.com, fweisbec@gmail.com, peterz@infradead.org
Content-Type: text/plain
Date: Fri, 13 Aug 2010 23:40:08 -0500
Message-Id: <1281760808.6598.56.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The perf trace report shell scripts hard-code the exec path of the
scripts into their command-lines, which doesn't work if perf has been
installed somewhere else.

Instead, perf trace should create the paths at run-time.  This patch
does that and removes the hard-coded paths from all the report scripts.

v2 changes: The first version inadvertently caused scripts run from
outside the perf exec path to fail e.g. 'perf trace -s test.py'.  The
fix is to try the script name without the exec path first, then the
version using the exec path, which restores the expected behavior.

v3 changes, from Stephane Eranian: Besides the stat() to access()
change, I fixed the pathname you were building, it was missing the
language name. The way I solved that is by leveraging the
scripting_ops->name field, but for that I had to make sure it would
match the subdir name, i.e., all lower-case. I also add an error
message when the script is not found, so users understand what went
wrong without turning on any sort of debugging.

Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/builtin-trace.c                         |   23 ++++++++++++++++++-
 tools/perf/scripts/perl/bin/failed-syscalls-report |    2 +-
 tools/perf/scripts/perl/bin/rw-by-file-report      |    2 +-
 tools/perf/scripts/perl/bin/rw-by-pid-report       |    2 +-
 tools/perf/scripts/perl/bin/rwtop-report           |    2 +-
 tools/perf/scripts/perl/bin/wakeup-latency-report  |    2 +-
 tools/perf/scripts/perl/bin/workqueue-stats-report |    2 +-
 .../python/bin/failed-syscalls-by-pid-report       |    2 +-
 .../perf/scripts/python/bin/sched-migration-report |    2 +-
 tools/perf/scripts/python/bin/sctop-report         |    2 +-
 .../python/bin/syscall-counts-by-pid-report        |    2 +-
 .../perf/scripts/python/bin/syscall-counts-report  |    3 +-
 .../perf/util/scripting-engines/trace-event-perl.c |    2 +-
 .../util/scripting-engines/trace-event-python.c    |    2 +-
 14 files changed, 35 insertions(+), 15 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 40a6a29..db1d950 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -719,10 +719,29 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 	}
 
 	if (script_name) {
-		err = scripting_ops->start_script(script_name, argc, argv);
+		char script_exec_path[MAXPATHLEN];
+
+		snprintf(script_exec_path, MAXPATHLEN, "%s", script_name);
+
+		if (access(script_exec_path, R_OK)) {
+
+			snprintf(script_exec_path, MAXPATHLEN, "%s/scripts/%s/%s",
+				 perf_exec_path(), scripting_ops->name, script_name);
+
+			err = access(script_exec_path, R_OK);
+			if (err) {
+				fprintf(stderr, "script %s not found\n", script_name);
+				goto out;
+			}
+		}
+
+		err = scripting_ops->start_script(script_exec_path,
+						  argc, argv);
 		if (err)
 			goto out;
-		pr_debug("perf trace started with script %s\n\n", script_name);
+
+		pr_debug("perf trace started with script %s\n\n",
+			 script_exec_path);
 	}
 
 	err = __cmd_trace(session);
diff --git a/tools/perf/scripts/perl/bin/failed-syscalls-report b/tools/perf/scripts/perl/bin/failed-syscalls-report
index e3a5e55..d58b39d 100644
--- a/tools/perf/scripts/perl/bin/failed-syscalls-report
+++ b/tools/perf/scripts/perl/bin/failed-syscalls-report
@@ -7,4 +7,4 @@ if [ $# -gt 0 ] ; then
 	shift
     fi
 fi
-perf trace $@ -s ~/libexec/perf-core/scripts/perl/failed-syscalls.pl $comm
+perf trace $@ -s failed-syscalls.pl $comm
diff --git a/tools/perf/scripts/perl/bin/rw-by-file-report b/tools/perf/scripts/perl/bin/rw-by-file-report
index d83070b..02cd821 100644
--- a/tools/perf/scripts/perl/bin/rw-by-file-report
+++ b/tools/perf/scripts/perl/bin/rw-by-file-report
@@ -7,7 +7,7 @@ if [ $# -lt 1 ] ; then
 fi
 comm=$1
 shift
-perf trace $@ -s ~/libexec/perf-core/scripts/perl/rw-by-file.pl $comm
+perf trace $@ -s rw-by-file.pl $comm
 
 
 
diff --git a/tools/perf/scripts/perl/bin/rw-by-pid-report b/tools/perf/scripts/perl/bin/rw-by-pid-report
index 7ef4698..86f5afc 100644
--- a/tools/perf/scripts/perl/bin/rw-by-pid-report
+++ b/tools/perf/scripts/perl/bin/rw-by-pid-report
@@ -1,6 +1,6 @@
 #!/bin/bash
 # description: system-wide r/w activity
-perf trace $@ -s ~/libexec/perf-core/scripts/perl/rw-by-pid.pl
+perf trace $@ -s rw-by-pid.pl
 
 
 
diff --git a/tools/perf/scripts/perl/bin/rwtop-report b/tools/perf/scripts/perl/bin/rwtop-report
index 93e698c..5475fff 100644
--- a/tools/perf/scripts/perl/bin/rwtop-report
+++ b/tools/perf/scripts/perl/bin/rwtop-report
@@ -17,7 +17,7 @@ if [ "$n_args" -gt 0 ] ; then
     interval=$1
     shift
 fi
-perf trace $@ -s ~/libexec/perf-core/scripts/perl/rwtop.pl $interval
+perf trace $@ -s rwtop.pl $interval
 
 
 
diff --git a/tools/perf/scripts/perl/bin/wakeup-latency-report b/tools/perf/scripts/perl/bin/wakeup-latency-report
index a0d898f..78c2f57 100644
--- a/tools/perf/scripts/perl/bin/wakeup-latency-report
+++ b/tools/perf/scripts/perl/bin/wakeup-latency-report
@@ -1,6 +1,6 @@
 #!/bin/bash
 # description: system-wide min/max/avg wakeup latency
-perf trace $@ -s ~/libexec/perf-core/scripts/perl/wakeup-latency.pl
+perf trace $@ -s wakeup-latency.pl
 
 
 
diff --git a/tools/perf/scripts/perl/bin/workqueue-stats-report b/tools/perf/scripts/perl/bin/workqueue-stats-report
index 3508113..ee6800f 100644
--- a/tools/perf/scripts/perl/bin/workqueue-stats-report
+++ b/tools/perf/scripts/perl/bin/workqueue-stats-report
@@ -1,6 +1,6 @@
 #!/bin/bash
 # description: workqueue stats (ins/exe/create/destroy)
-perf trace $@ -s ~/libexec/perf-core/scripts/perl/workqueue-stats.pl
+perf trace $@ -s workqueue-stats.pl
 
 
 
diff --git a/tools/perf/scripts/python/bin/failed-syscalls-by-pid-report b/tools/perf/scripts/python/bin/failed-syscalls-by-pid-report
index 3029354..9c07aa4 100644
--- a/tools/perf/scripts/python/bin/failed-syscalls-by-pid-report
+++ b/tools/perf/scripts/python/bin/failed-syscalls-by-pid-report
@@ -7,4 +7,4 @@ if [ $# -gt 0 ] ; then
 	shift
     fi
 fi
-perf trace $@ -s ~/libexec/perf-core/scripts/python/failed-syscalls-by-pid.py $comm
+perf trace $@ -s failed-syscalls-by-pid.py $comm
diff --git a/tools/perf/scripts/python/bin/sched-migration-report b/tools/perf/scripts/python/bin/sched-migration-report
index 61d05f7..2b724d1 100644
--- a/tools/perf/scripts/python/bin/sched-migration-report
+++ b/tools/perf/scripts/python/bin/sched-migration-report
@@ -1,3 +1,3 @@
 #!/bin/bash
 # description: sched migration overview
-perf trace $@ -s ~/libexec/perf-core/scripts/python/sched-migration.py
+perf trace $@ -s sched-migration.py
diff --git a/tools/perf/scripts/python/bin/sctop-report b/tools/perf/scripts/python/bin/sctop-report
index b01c842..0368461 100644
--- a/tools/perf/scripts/python/bin/sctop-report
+++ b/tools/perf/scripts/python/bin/sctop-report
@@ -21,4 +21,4 @@ elif [ "$n_args" -gt 0 ] ; then
     interval=$1
     shift
 fi
-perf trace $@ -s ~/libexec/perf-core/scripts/python/sctop.py $comm $interval
+perf trace $@ -s sctop.py $comm $interval
diff --git a/tools/perf/scripts/python/bin/syscall-counts-by-pid-report b/tools/perf/scripts/python/bin/syscall-counts-by-pid-report
index 9e9d8dd..2822281 100644
--- a/tools/perf/scripts/python/bin/syscall-counts-by-pid-report
+++ b/tools/perf/scripts/python/bin/syscall-counts-by-pid-report
@@ -7,4 +7,4 @@ if [ $# -gt 0 ] ; then
 	shift
     fi
 fi
-perf trace $@ -s ~/libexec/perf-core/scripts/python/syscall-counts-by-pid.py $comm
+perf trace $@ -s syscall-counts-by-pid.py $comm
diff --git a/tools/perf/scripts/python/bin/syscall-counts-report b/tools/perf/scripts/python/bin/syscall-counts-report
index dc076b6..6e97501 100644
--- a/tools/perf/scripts/python/bin/syscall-counts-report
+++ b/tools/perf/scripts/python/bin/syscall-counts-report
@@ -1,3 +1,4 @@
+
 #!/bin/bash
 # description: system-wide syscall counts
 # args: [comm]
@@ -7,4 +8,4 @@ if [ $# -gt 0 ] ; then
 	shift
     fi
 fi
-perf trace $@ -s ~/libexec/perf-core/scripts/python/syscall-counts.py $comm
+perf trace $@ -s syscall-counts.py $comm
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index b059dc5..97e8c6d 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -557,7 +557,7 @@ static int perl_generate_script(const char *outfile)
 }
 
 struct scripting_ops perl_scripting_ops = {
-	.name = "Perl",
+	.name = "perl",
 	.start_script = perl_start_script,
 	.stop_script = perl_stop_script,
 	.process_event = perl_process_event,
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 33a6325..49655a8 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -586,7 +586,7 @@ static int python_generate_script(const char *outfile)
 }
 
 struct scripting_ops python_scripting_ops = {
-	.name = "Python",
+	.name = "python",
 	.start_script = python_start_script,
 	.stop_script = python_stop_script,
 	.process_event = python_process_event,
-- 
1.6.4.GIT



