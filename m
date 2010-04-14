Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab0DNKGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 06:06:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:33077 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754830Ab0DNKGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 06:06:33 -0400
Date: Wed, 14 Apr 2010 10:06:11 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1270184365-8281-11-git-send-email-tzanussi@gmail.com>
References: <1270184365-8281-11-git-send-email-tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/live] perf trace/scripting: Enable scripting shell scripts for live mode
Message-ID: <tip-00b21a01935892a2b97613f10300434998f45093@git.kernel.org>
Git-Commit-ID: 00b21a01935892a2b97613f10300434998f45093
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 14 Apr 2010 10:06:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  00b21a01935892a2b97613f10300434998f45093
Gitweb:     http://git.kernel.org/tip/00b21a01935892a2b97613f10300434998f45093
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Thu, 1 Apr 2010 23:59:24 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 14 Apr 2010 11:56:08 +0200

perf trace/scripting: Enable scripting shell scripts for live mode

It should be possible to run any perf trace script in 'live
mode'. This requires being able to pass in e.g. '-i -' or other
args, which the current shell scripts aren't equipped to handle.
 In a few cases, there are required or optional args that also
need special handling. This patch makes changes the current set
of shell scripts as necessary.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: fweisbec@gmail.com
Cc: rostedt@goodmis.org
Cc: k-keiichi@bx.jp.nec.com
Cc: acme@ghostprotocols.net
LKML-Reference: <1270184365-8281-11-git-send-email-tzanussi@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/scripts/perl/bin/failed-syscalls-record |    2 +-
 tools/perf/scripts/perl/bin/failed-syscalls-report |    8 +++++++-
 tools/perf/scripts/perl/bin/rw-by-file-record      |    3 ++-
 tools/perf/scripts/perl/bin/rw-by-file-report      |    8 +++++++-
 tools/perf/scripts/perl/bin/rw-by-pid-record       |    2 +-
 tools/perf/scripts/perl/bin/rw-by-pid-report       |    2 +-
 tools/perf/scripts/perl/bin/wakeup-latency-record  |    2 +-
 tools/perf/scripts/perl/bin/wakeup-latency-report  |    2 +-
 tools/perf/scripts/perl/bin/workqueue-stats-record |    2 +-
 tools/perf/scripts/perl/bin/workqueue-stats-report |    2 +-
 .../python/bin/failed-syscalls-by-pid-record       |    2 +-
 .../python/bin/failed-syscalls-by-pid-report       |    8 +++++++-
 .../python/bin/syscall-counts-by-pid-record        |    2 +-
 .../python/bin/syscall-counts-by-pid-report        |    8 +++++++-
 .../perf/scripts/python/bin/syscall-counts-record  |    2 +-
 .../perf/scripts/python/bin/syscall-counts-report  |    8 +++++++-
 16 files changed, 47 insertions(+), 16 deletions(-)

diff --git a/tools/perf/scripts/perl/bin/failed-syscalls-record b/tools/perf/scripts/perl/bin/failed-syscalls-record
index f8885d3..6ad9b8f 100644
--- a/tools/perf/scripts/perl/bin/failed-syscalls-record
+++ b/tools/perf/scripts/perl/bin/failed-syscalls-record
@@ -1,2 +1,2 @@
 #!/bin/bash
-perf record -c 1 -f -a -M -R -e raw_syscalls:sys_exit
+perf record -c 1 -f -a -M -R -e raw_syscalls:sys_exit $@
diff --git a/tools/perf/scripts/perl/bin/failed-syscalls-report b/tools/perf/scripts/perl/bin/failed-syscalls-report
index 8bfc660..f634608 100644
--- a/tools/perf/scripts/perl/bin/failed-syscalls-report
+++ b/tools/perf/scripts/perl/bin/failed-syscalls-report
@@ -1,4 +1,10 @@
 #!/bin/bash
 # description: system-wide failed syscalls
 # args: [comm]
-perf trace -s ~/libexec/perf-core/scripts/perl/failed-syscalls.pl $1
+if [ $# -gt 0 ] ; then
+    if ! expr match "$1" "-" ; then
+	comm=$1
+	shift
+    fi
+fi
+perf trace $@ -s ~/libexec/perf-core/scripts/perl/failed-syscalls.pl $comm
diff --git a/tools/perf/scripts/perl/bin/rw-by-file-record b/tools/perf/scripts/perl/bin/rw-by-file-record
index b25056e..a828679 100644
--- a/tools/perf/scripts/perl/bin/rw-by-file-record
+++ b/tools/perf/scripts/perl/bin/rw-by-file-record
@@ -1,2 +1,3 @@
 #!/bin/bash
-perf record -c 1 -f -a -M -R -e syscalls:sys_enter_read -e syscalls:sys_enter_write
+perf record -c 1 -f -a -M -R -e syscalls:sys_enter_read -e syscalls:sys_enter_write $@
+
diff --git a/tools/perf/scripts/perl/bin/rw-by-file-report b/tools/perf/scripts/perl/bin/rw-by-file-report
index eddb9cc..d83070b 100644
--- a/tools/perf/scripts/perl/bin/rw-by-file-report
+++ b/tools/perf/scripts/perl/bin/rw-by-file-report
@@ -1,7 +1,13 @@
 #!/bin/bash
 # description: r/w activity for a program, by file
 # args: <comm>
-perf trace -s ~/libexec/perf-core/scripts/perl/rw-by-file.pl $1
+if [ $# -lt 1 ] ; then
+    echo "usage: rw-by-file <comm>"
+    exit
+fi
+comm=$1
+shift
+perf trace $@ -s ~/libexec/perf-core/scripts/perl/rw-by-file.pl $comm
 
 
 
diff --git a/tools/perf/scripts/perl/bin/rw-by-pid-record b/tools/perf/scripts/perl/bin/rw-by-pid-record
index 8903979..63976bf 100644
--- a/tools/perf/scripts/perl/bin/rw-by-pid-record
+++ b/tools/perf/scripts/perl/bin/rw-by-pid-record
@@ -1,2 +1,2 @@
 #!/bin/bash
-perf record -c 1 -f -a -M -R -e syscalls:sys_enter_read -e syscalls:sys_exit_read -e syscalls:sys_enter_write -e syscalls:sys_exit_write
+perf record -c 1 -f -a -M -R -e syscalls:sys_enter_read -e syscalls:sys_exit_read -e syscalls:sys_enter_write -e syscalls:sys_exit_write $@
diff --git a/tools/perf/scripts/perl/bin/rw-by-pid-report b/tools/perf/scripts/perl/bin/rw-by-pid-report
index 7f44c25..7ef4698 100644
--- a/tools/perf/scripts/perl/bin/rw-by-pid-report
+++ b/tools/perf/scripts/perl/bin/rw-by-pid-report
@@ -1,6 +1,6 @@
 #!/bin/bash
 # description: system-wide r/w activity
-perf trace -s ~/libexec/perf-core/scripts/perl/rw-by-pid.pl
+perf trace $@ -s ~/libexec/perf-core/scripts/perl/rw-by-pid.pl
 
 
 
diff --git a/tools/perf/scripts/perl/bin/wakeup-latency-record b/tools/perf/scripts/perl/bin/wakeup-latency-record
index 6abedda..9c0cf58 100644
--- a/tools/perf/scripts/perl/bin/wakeup-latency-record
+++ b/tools/perf/scripts/perl/bin/wakeup-latency-record
@@ -1,5 +1,5 @@
 #!/bin/bash
-perf record -c 1 -f -a -M -R -e sched:sched_switch -e sched:sched_wakeup
+perf record -c 1 -f -a -M -R -e sched:sched_switch -e sched:sched_wakeup $@
 
 
 
diff --git a/tools/perf/scripts/perl/bin/wakeup-latency-report b/tools/perf/scripts/perl/bin/wakeup-latency-report
index fce3adc..a0d898f 100644
--- a/tools/perf/scripts/perl/bin/wakeup-latency-report
+++ b/tools/perf/scripts/perl/bin/wakeup-latency-report
@@ -1,6 +1,6 @@
 #!/bin/bash
 # description: system-wide min/max/avg wakeup latency
-perf trace -s ~/libexec/perf-core/scripts/perl/wakeup-latency.pl
+perf trace $@ -s ~/libexec/perf-core/scripts/perl/wakeup-latency.pl
 
 
 
diff --git a/tools/perf/scripts/perl/bin/workqueue-stats-record b/tools/perf/scripts/perl/bin/workqueue-stats-record
index fce6637..c2a1a94 100644
--- a/tools/perf/scripts/perl/bin/workqueue-stats-record
+++ b/tools/perf/scripts/perl/bin/workqueue-stats-record
@@ -1,2 +1,2 @@
 #!/bin/bash
-perf record -c 1 -f -a -M -R -e workqueue:workqueue_creation -e workqueue:workqueue_destruction -e workqueue:workqueue_execution -e workqueue:workqueue_insertion
+perf record -c 1 -f -a -M -R -e workqueue:workqueue_creation -e workqueue:workqueue_destruction -e workqueue:workqueue_execution -e workqueue:workqueue_insertion $@
diff --git a/tools/perf/scripts/perl/bin/workqueue-stats-report b/tools/perf/scripts/perl/bin/workqueue-stats-report
index 71cfbd1..3508113 100644
--- a/tools/perf/scripts/perl/bin/workqueue-stats-report
+++ b/tools/perf/scripts/perl/bin/workqueue-stats-report
@@ -1,6 +1,6 @@
 #!/bin/bash
 # description: workqueue stats (ins/exe/create/destroy)
-perf trace -s ~/libexec/perf-core/scripts/perl/workqueue-stats.pl
+perf trace $@ -s ~/libexec/perf-core/scripts/perl/workqueue-stats.pl
 
 
 
diff --git a/tools/perf/scripts/python/bin/failed-syscalls-by-pid-record b/tools/perf/scripts/python/bin/failed-syscalls-by-pid-record
index f8885d3..6ad9b8f 100644
--- a/tools/perf/scripts/python/bin/failed-syscalls-by-pid-record
+++ b/tools/perf/scripts/python/bin/failed-syscalls-by-pid-record
@@ -1,2 +1,2 @@
 #!/bin/bash
-perf record -c 1 -f -a -M -R -e raw_syscalls:sys_exit
+perf record -c 1 -f -a -M -R -e raw_syscalls:sys_exit $@
diff --git a/tools/perf/scripts/python/bin/failed-syscalls-by-pid-report b/tools/perf/scripts/python/bin/failed-syscalls-by-pid-report
index 1e0c0a8..8c128ef 100644
--- a/tools/perf/scripts/python/bin/failed-syscalls-by-pid-report
+++ b/tools/perf/scripts/python/bin/failed-syscalls-by-pid-report
@@ -1,4 +1,10 @@
 #!/bin/bash
 # description: system-wide failed syscalls, by pid
 # args: [comm]
-perf trace -s ~/libexec/perf-core/scripts/python/failed-syscalls-by-pid.py $1
+if [ $# -gt 0 ] ; then
+    if ! expr match "$1" "-" ; then
+	comm=$1
+	shift
+    fi
+fi
+perf trace $@ -s ~/libexec/perf-core/scripts/python/failed-syscalls-by-pid.py $comm
diff --git a/tools/perf/scripts/python/bin/syscall-counts-by-pid-record b/tools/perf/scripts/python/bin/syscall-counts-by-pid-record
index 45a8c50..27ccffa 100644
--- a/tools/perf/scripts/python/bin/syscall-counts-by-pid-record
+++ b/tools/perf/scripts/python/bin/syscall-counts-by-pid-record
@@ -1,2 +1,2 @@
 #!/bin/bash
-perf record -c 1 -f -a -M -R -e raw_syscalls:sys_enter
+perf record -c 1 -f -a -M -R -e raw_syscalls:sys_enter $@
diff --git a/tools/perf/scripts/python/bin/syscall-counts-by-pid-report b/tools/perf/scripts/python/bin/syscall-counts-by-pid-report
index f8044d1..c53362e 100644
--- a/tools/perf/scripts/python/bin/syscall-counts-by-pid-report
+++ b/tools/perf/scripts/python/bin/syscall-counts-by-pid-report
@@ -1,4 +1,10 @@
 #!/bin/bash
 # description: system-wide syscall counts, by pid
 # args: [comm]
-perf trace -s ~/libexec/perf-core/scripts/python/syscall-counts-by-pid.py $1
+if [ $# -gt 0 ] ; then
+    if ! expr match "$1" "-" ; then
+	comm=$1
+	shift
+    fi
+fi
+perf trace $@ -s ~/libexec/perf-core/scripts/python/syscall-counts-by-pid.py $comm
diff --git a/tools/perf/scripts/python/bin/syscall-counts-record b/tools/perf/scripts/python/bin/syscall-counts-record
index 45a8c50..27ccffa 100644
--- a/tools/perf/scripts/python/bin/syscall-counts-record
+++ b/tools/perf/scripts/python/bin/syscall-counts-record
@@ -1,2 +1,2 @@
 #!/bin/bash
-perf record -c 1 -f -a -M -R -e raw_syscalls:sys_enter
+perf record -c 1 -f -a -M -R -e raw_syscalls:sys_enter $@
diff --git a/tools/perf/scripts/python/bin/syscall-counts-report b/tools/perf/scripts/python/bin/syscall-counts-report
index a366aa6..8c21552 100644
--- a/tools/perf/scripts/python/bin/syscall-counts-report
+++ b/tools/perf/scripts/python/bin/syscall-counts-report
@@ -1,4 +1,10 @@
 #!/bin/bash
 # description: system-wide syscall counts
 # args: [comm]
-perf trace -s ~/libexec/perf-core/scripts/python/syscall-counts.py $1
+if [ $# -gt 0 ] ; then
+    if ! expr match "$1" "-" ; then
+	comm=$1
+	shift
+    fi
+fi
+perf trace $@ -s ~/libexec/perf-core/scripts/python/syscall-counts.py $comm
