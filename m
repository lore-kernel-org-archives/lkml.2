Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761368Ab0HMIiO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 04:38:14 -0400
Received: from smtp-out.google.com ([74.125.121.35]:23189 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761354Ab0HMIiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 04:38:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:from:date:to:reply-to:in-reply-to:references:cc:
	subject:x-system-of-record;
	b=YSRChgLooVuj/7UcV/mMFxTTqa74t3juezmRznmVXDnpq52XIY6HnUZ8xJ9Oz0PCv
	JiCeS977w8GaZpyMRuZig==
Message-ID: <4c65046e.cae9d80a.0d93.4def@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Fri, 13 Aug 2010 10:30:01 +0200
To: Tom Zanussi <tzanussi@gmail.com>
Reply-to: eranian@google.com
In-Reply-To: <1281635958-21177-1-git-send-email-tzanussi@gmail.com>
References: <1281635958-21177-1-git-send-email-tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, acme@infradead.org, mingo@elte.hu,
        acme@redhat.com, fweisbec@gmail.com, peterz@infradead.org
Subject: Re: [PATCH] perf trace: get rid of the hard-coded paths in the report scripts
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tom,

Here is version that works for me. Besides the stat() to access() change, I fixed
the pathname you were building, it was missing the language name. The way I solved
that is by leveraging the scripting_ops->name field, but for that I had to make sure
it would match the subdir name, i.e., all lower-case. I also add an error message
when the script is not found, so users understand what went wrong without turning
on any sort of debugging.

Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Tom Zanussi <tzanussi@gmail.com>

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
index e3a5e55..47cf0b7 100644
--- a/tools/perf/scripts/perl/bin/failed-syscalls-report
+++ b/tools/perf/scripts/perl/bin/failed-syscalls-report
@@ -7,4 +7,4 @@ if [ $# -gt 0 ] ; then
 	shift
     fi
 fi
-perf trace $@ -s ~/libexec/perf-core/scripts/perl/failed-syscalls.pl $comm
+perf trace $@ -s perl/failed-syscalls.pl $comm
diff --git a/tools/perf/scripts/perl/bin/rw-by-file-report b/tools/perf/scripts/perl/bin/rw-by-file-report
index d83070b..407ec70 100644
--- a/tools/perf/scripts/perl/bin/rw-by-file-report
+++ b/tools/perf/scripts/perl/bin/rw-by-file-report
@@ -7,7 +7,7 @@ if [ $# -lt 1 ] ; then
 fi
 comm=$1
 shift
-perf trace $@ -s ~/libexec/perf-core/scripts/perl/rw-by-file.pl $comm
+perf trace $@ -s perl/rw-by-file.pl $comm
 
 
 
diff --git a/tools/perf/scripts/perl/bin/rw-by-pid-report b/tools/perf/scripts/perl/bin/rw-by-pid-report
index 7ef4698..0c129e1 100644
--- a/tools/perf/scripts/perl/bin/rw-by-pid-report
+++ b/tools/perf/scripts/perl/bin/rw-by-pid-report
@@ -1,6 +1,6 @@
 #!/bin/bash
 # description: system-wide r/w activity
-perf trace $@ -s ~/libexec/perf-core/scripts/perl/rw-by-pid.pl
+perf trace $@ -s perl/rw-by-pid.pl
 
 
 
diff --git a/tools/perf/scripts/perl/bin/rwtop-report b/tools/perf/scripts/perl/bin/rwtop-report
index 93e698c..5bac5bb 100644
--- a/tools/perf/scripts/perl/bin/rwtop-report
+++ b/tools/perf/scripts/perl/bin/rwtop-report
@@ -17,7 +17,7 @@ if [ "$n_args" -gt 0 ] ; then
     interval=$1
     shift
 fi
-perf trace $@ -s ~/libexec/perf-core/scripts/perl/rwtop.pl $interval
+perf trace $@ -s perl/rwtop.pl $interval
 
 
 
diff --git a/tools/perf/scripts/perl/bin/wakeup-latency-report b/tools/perf/scripts/perl/bin/wakeup-latency-report
index a0d898f..dcfdd05 100644
--- a/tools/perf/scripts/perl/bin/wakeup-latency-report
+++ b/tools/perf/scripts/perl/bin/wakeup-latency-report
@@ -1,6 +1,6 @@
 #!/bin/bash
 # description: system-wide min/max/avg wakeup latency
-perf trace $@ -s ~/libexec/perf-core/scripts/perl/wakeup-latency.pl
+perf trace $@ -s perl/wakeup-latency.pl
 
 
 
diff --git a/tools/perf/scripts/perl/bin/workqueue-stats-report b/tools/perf/scripts/perl/bin/workqueue-stats-report
index 3508113..6ce9247 100644
--- a/tools/perf/scripts/perl/bin/workqueue-stats-report
+++ b/tools/perf/scripts/perl/bin/workqueue-stats-report
@@ -1,6 +1,6 @@
 #!/bin/bash
 # description: workqueue stats (ins/exe/create/destroy)
-perf trace $@ -s ~/libexec/perf-core/scripts/perl/workqueue-stats.pl
+perf trace $@ -s perl/workqueue-stats.pl
 
 
 
diff --git a/tools/perf/scripts/python/bin/failed-syscalls-by-pid-report b/tools/perf/scripts/python/bin/failed-syscalls-by-pid-report
index 3029354..b39182f 100644
--- a/tools/perf/scripts/python/bin/failed-syscalls-by-pid-report
+++ b/tools/perf/scripts/python/bin/failed-syscalls-by-pid-report
@@ -7,4 +7,4 @@ if [ $# -gt 0 ] ; then
 	shift
     fi
 fi
-perf trace $@ -s ~/libexec/perf-core/scripts/python/failed-syscalls-by-pid.py $comm
+perf trace $@ -s python/failed-syscalls-by-pid.py $comm
diff --git a/tools/perf/scripts/python/bin/sched-migration-report b/tools/perf/scripts/python/bin/sched-migration-report
index 61d05f7..8299b69 100644
--- a/tools/perf/scripts/python/bin/sched-migration-report
+++ b/tools/perf/scripts/python/bin/sched-migration-report
@@ -1,3 +1,3 @@
 #!/bin/bash
 # description: sched migration overview
-perf trace $@ -s ~/libexec/perf-core/scripts/python/sched-migration.py
+perf trace $@ -s python/sched-migration.py
diff --git a/tools/perf/scripts/python/bin/sctop-report b/tools/perf/scripts/python/bin/sctop-report
index b01c842..9fe812c 100644
--- a/tools/perf/scripts/python/bin/sctop-report
+++ b/tools/perf/scripts/python/bin/sctop-report
@@ -21,4 +21,4 @@ elif [ "$n_args" -gt 0 ] ; then
     interval=$1
     shift
 fi
-perf trace $@ -s ~/libexec/perf-core/scripts/python/sctop.py $comm $interval
+perf trace $@ -s python/sctop.py $comm $interval
diff --git a/tools/perf/scripts/python/bin/syscall-counts-by-pid-report b/tools/perf/scripts/python/bin/syscall-counts-by-pid-report
index 9e9d8dd..ec9d4d9 100644
--- a/tools/perf/scripts/python/bin/syscall-counts-by-pid-report
+++ b/tools/perf/scripts/python/bin/syscall-counts-by-pid-report
@@ -7,4 +7,4 @@ if [ $# -gt 0 ] ; then
 	shift
     fi
 fi
-perf trace $@ -s ~/libexec/perf-core/scripts/python/syscall-counts-by-pid.py $comm
+perf trace $@ -s python/syscall-counts-by-pid.py $comm
diff --git a/tools/perf/scripts/python/bin/syscall-counts-report b/tools/perf/scripts/python/bin/syscall-counts-report
index dc076b6..9ed7854 100644
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
+perf trace $@ -s python/syscall-counts.py $comm
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
