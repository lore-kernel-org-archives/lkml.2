Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899Ab0FREl6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 00:41:58 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53248 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab0FREl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 00:41:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=kszbMBaDr3ZIRZxjeoObfhnfGp4t1fZeVK0t8ZDRbq8bW27NxB5lRtwlV37C7nfGgz
         lYUQrtfs0KTgzvqU2mpJRBEoBtqm6+Do5XfIAMAT/3d2Tt6sDaY4kQL0nebTIVlBZo5v
         DMq9crI7K/zZrqnIAs7eCwQ2xT/OyGAyxBhA4=
Subject: [PATCH] perf trace: get rid of the hard-coded paths in the report
 scripts
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Stephane Eranian <eranian@google.com>, mingo@elte.hu, fweisbec@gmail.com,
       acme@ghostprotocols.net
Content-Type: text/plain
Date: Thu, 17 Jun 2010 23:41:54 -0500
Message-Id: <1276836114.7762.17.camel@tropicana>
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

Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/builtin-trace.c                         |   11 +++++++++--
 tools/perf/scripts/perl/bin/failed-syscalls-report |    2 +-
 tools/perf/scripts/perl/bin/rw-by-file-report      |    2 +-
 tools/perf/scripts/perl/bin/rw-by-pid-report       |    2 +-
 tools/perf/scripts/perl/bin/rwtop-report           |    2 +-
 tools/perf/scripts/perl/bin/wakeup-latency-report  |    2 +-
 tools/perf/scripts/perl/bin/workqueue-stats-report |    2 +-
 .../python/bin/failed-syscalls-by-pid-report       |    2 +-
 tools/perf/scripts/python/bin/sctop-report         |    2 +-
 .../python/bin/syscall-counts-by-pid-report        |    2 +-
 .../perf/scripts/python/bin/syscall-counts-report  |    3 ++-
 11 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index dddf3f0..4bb67eb 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -702,10 +702,17 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 	}
 
 	if (script_name) {
-		err = scripting_ops->start_script(script_name, argc, argv);
+		char script_exec_path[MAXPATHLEN];
+
+		snprintf(script_exec_path, MAXPATHLEN, "%s/scripts/%s",
+			 perf_exec_path(), script_name);
+
+		err = scripting_ops->start_script(script_exec_path,
+						  argc, argv);
 		if (err)
 			goto out;
-		pr_debug("perf trace started with script %s\n\n", script_name);
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
-- 
1.6.4.GIT



