Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112Ab0DBFFW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 01:05:22 -0400
Received: from mail-yw0-f172.google.com ([209.85.211.172]:41343 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244Ab0DBFFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 01:05:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wlVx++eBn5HOA5x/evy5XZzCBwEV3onUgaU56NZU62OYAE636gB4CGYtAh2F5v3x+s
         sNRBfNv/LqLBJy2iobuKceVflsETlXviyiCtPrZ5a+6oPWwd2MEtRcBOrhV7jfxM9hb9
         8yNXW3KTkaPyoiifSxWZPQOxmen3LAIAnYfis=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com, acme@ghostprotocols.net
Subject: [RFC v2][PATCH 09/11] perf trace/scripting: rwtop and sctop scripts
Date: Thu,  1 Apr 2010 23:59:23 -0500
Message-Id: <1270184365-8281-10-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1270184365-8281-1-git-send-email-tzanussi@gmail.com>
References: <1270184365-8281-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple of scripts, one in Python and the other in Perl, that
demonstrate 'live mode' tracing.  For each, the output of the perf
event stream is fed continuously to the script, which continuously
aggregates the data and reports the current results every 3 seconds,
or at the optionally specified interval.  After the current results
are displayed, the aggregations are cleared and the cycle begins anew.

To run the scripts, simply pipe the output of the 'perf trace record'
step as input to the corresponding 'perf trace report' step, using '-'
as the filename to -o and -i:

$ perf trace record sctop -o - | perf trace report sctop -i -

Also adds clear_term() utility functions to the Util.pm and Util.py
utility modules, for use by any script to clear the screen.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 .../perl/Perf-Trace-Util/lib/Perf/Trace/Util.pm    |    6 +
 tools/perf/scripts/perl/bin/rwtop-record           |    2 +
 tools/perf/scripts/perl/bin/rwtop-report           |   23 +++
 tools/perf/scripts/perl/rwtop.pl                   |  177 ++++++++++++++++++++
 .../python/Perf-Trace-Util/lib/Perf/Trace/Util.py  |    3 +
 tools/perf/scripts/python/bin/sctop-record         |    2 +
 tools/perf/scripts/python/bin/sctop-report         |   24 +++
 tools/perf/scripts/python/sctop.py                 |   78 +++++++++
 8 files changed, 315 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/scripts/perl/bin/rwtop-record
 create mode 100644 tools/perf/scripts/perl/bin/rwtop-report
 create mode 100644 tools/perf/scripts/perl/rwtop.pl
 create mode 100644 tools/perf/scripts/python/bin/sctop-record
 create mode 100644 tools/perf/scripts/python/bin/sctop-report
 create mode 100644 tools/perf/scripts/python/sctop.py

diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Util.pm b/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Util.pm
index f869c48..d94b40c 100644
--- a/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Util.pm
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Util.pm
@@ -15,6 +15,7 @@ our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
 
 our @EXPORT = qw(
 avg nsecs nsecs_secs nsecs_nsecs nsecs_usecs print_nsecs
+clear_term
 );
 
 our $VERSION = '0.01';
@@ -55,6 +56,11 @@ sub nsecs_str {
     return $str;
 }
 
+sub clear_term
+{
+    print "\x1b[H\x1b[2J";
+}
+
 1;
 __END__
 =head1 NAME
diff --git a/tools/perf/scripts/perl/bin/rwtop-record b/tools/perf/scripts/perl/bin/rwtop-record
new file mode 100644
index 0000000..63976bf
--- /dev/null
+++ b/tools/perf/scripts/perl/bin/rwtop-record
@@ -0,0 +1,2 @@
+#!/bin/bash
+perf record -c 1 -f -a -M -R -e syscalls:sys_enter_read -e syscalls:sys_exit_read -e syscalls:sys_enter_write -e syscalls:sys_exit_write $@
diff --git a/tools/perf/scripts/perl/bin/rwtop-report b/tools/perf/scripts/perl/bin/rwtop-report
new file mode 100644
index 0000000..93e698c
--- /dev/null
+++ b/tools/perf/scripts/perl/bin/rwtop-report
@@ -0,0 +1,23 @@
+#!/bin/bash
+# description: system-wide r/w top
+# args: [interval]
+n_args=0
+for i in "$@"
+do
+    if expr match "$i" "-" > /dev/null ; then
+	break
+    fi
+    n_args=$(( $n_args + 1 ))
+done
+if [ "$n_args" -gt 1 ] ; then
+    echo "usage: rwtop-report [interval]"
+    exit
+fi
+if [ "$n_args" -gt 0 ] ; then
+    interval=$1
+    shift
+fi
+perf trace $@ -s ~/libexec/perf-core/scripts/perl/rwtop.pl $interval
+
+
+
diff --git a/tools/perf/scripts/perl/rwtop.pl b/tools/perf/scripts/perl/rwtop.pl
new file mode 100644
index 0000000..ec2ab49
--- /dev/null
+++ b/tools/perf/scripts/perl/rwtop.pl
@@ -0,0 +1,177 @@
+#!/usr/bin/perl -w
+# (c) 2010, Tom Zanussi <tzanussi@gmail.com>
+# Licensed under the terms of the GNU GPL License version 2
+
+# read/write top
+#
+# Periodically displays system-wide r/w call activity, broken down by
+# pid.  If an [interval] arg is specified, the display will be
+# refreshed every [interval] seconds.  The default interval is 3
+# seconds.
+
+use 5.010000;
+use strict;
+use warnings;
+
+use lib "$ENV{'PERF_EXEC_PATH'}/scripts/perl/Perf-Trace-Util/lib";
+use lib "./Perf-Trace-Util/lib";
+use Perf::Trace::Core;
+use Perf::Trace::Util;
+
+my $default_interval = 3;
+my $nlines = 20;
+my $print_thread;
+
+my %reads;
+my %writes;
+
+my $interval = shift;
+if (!$interval) {
+    $interval = $default_interval;
+}
+
+sub syscalls::sys_exit_read
+{
+    my ($event_name, $context, $common_cpu, $common_secs, $common_nsecs,
+	$common_pid, $common_comm,
+	$nr, $ret) = @_;
+
+    if ($ret > 0) {
+	$reads{$common_pid}{bytes_read} += $ret;
+    } else {
+	if (!defined ($reads{$common_pid}{bytes_read})) {
+	    $reads{$common_pid}{bytes_read} = 0;
+	}
+	$reads{$common_pid}{errors}{$ret}++;
+    }
+}
+
+sub syscalls::sys_enter_read
+{
+    my ($event_name, $context, $common_cpu, $common_secs, $common_nsecs,
+	$common_pid, $common_comm,
+	$nr, $fd, $buf, $count) = @_;
+
+    $reads{$common_pid}{bytes_requested} += $count;
+    $reads{$common_pid}{total_reads}++;
+    $reads{$common_pid}{comm} = $common_comm;
+}
+
+sub syscalls::sys_exit_write
+{
+    my ($event_name, $context, $common_cpu, $common_secs, $common_nsecs,
+	$common_pid, $common_comm,
+	$nr, $ret) = @_;
+
+    if ($ret <= 0) {
+	$writes{$common_pid}{errors}{$ret}++;
+    }
+}
+
+sub syscalls::sys_enter_write
+{
+    my ($event_name, $context, $common_cpu, $common_secs, $common_nsecs,
+	$common_pid, $common_comm,
+	$nr, $fd, $buf, $count) = @_;
+
+    $writes{$common_pid}{bytes_written} += $count;
+    $writes{$common_pid}{total_writes}++;
+    $writes{$common_pid}{comm} = $common_comm;
+}
+
+sub trace_begin
+{
+    $SIG{ALRM} = \&print_totals;
+    alarm 1;
+}
+
+sub trace_end
+{
+    print_unhandled();
+    print_totals();
+}
+
+sub print_totals
+{
+    my $count;
+
+    $count = 0;
+
+    clear_term();
+
+    printf("\nread counts by pid:\n\n");
+
+    printf("%6s  %20s  %10s  %10s  %10s\n", "pid", "comm",
+	   "# reads", "bytes_req", "bytes_read");
+    printf("%6s  %-20s  %10s  %10s  %10s\n", "------", "--------------------",
+	   "----------", "----------", "----------");
+
+    foreach my $pid (sort {$reads{$b}{bytes_read} <=>
+			       $reads{$a}{bytes_read}} keys %reads) {
+	my $comm = $reads{$pid}{comm};
+	my $total_reads = $reads{$pid}{total_reads};
+	my $bytes_requested = $reads{$pid}{bytes_requested};
+	my $bytes_read = $reads{$pid}{bytes_read};
+
+	printf("%6s  %-20s  %10s  %10s  %10s\n", $pid, $comm,
+	       $total_reads, $bytes_requested, $bytes_read);
+
+	if (++$count == $nlines) {
+	    last;
+	}
+    }
+
+    $count = 0;
+
+    printf("\nwrite counts by pid:\n\n");
+
+    printf("%6s  %20s  %10s  %13s\n", "pid", "comm",
+	   "# writes", "bytes_written");
+    printf("%6s  %-20s  %10s  %13s\n", "------", "--------------------",
+	   "----------", "-------------");
+
+    foreach my $pid (sort {$writes{$b}{bytes_written} <=>
+			       $writes{$a}{bytes_written}} keys %writes) {
+	my $comm = $writes{$pid}{comm};
+	my $total_writes = $writes{$pid}{total_writes};
+	my $bytes_written = $writes{$pid}{bytes_written};
+
+	printf("%6s  %-20s  %10s  %13s\n", $pid, $comm,
+	       $total_writes, $bytes_written);
+
+	if (++$count == $nlines) {
+	    last;
+	}
+    }
+
+    %reads = ();
+    %writes = ();
+    alarm $interval;
+}
+
+my %unhandled;
+
+sub print_unhandled
+{
+    if ((scalar keys %unhandled) == 0) {
+	return;
+    }
+
+    print "\nunhandled events:\n\n";
+
+    printf("%-40s  %10s\n", "event", "count");
+    printf("%-40s  %10s\n", "----------------------------------------",
+	   "-----------");
+
+    foreach my $event_name (keys %unhandled) {
+	printf("%-40s  %10d\n", $event_name, $unhandled{$event_name});
+    }
+}
+
+sub trace_unhandled
+{
+    my ($event_name, $context, $common_cpu, $common_secs, $common_nsecs,
+	$common_pid, $common_comm) = @_;
+
+    $unhandled{$event_name}++;
+}
diff --git a/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Util.py b/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Util.py
index 83e9143..9689bc0 100644
--- a/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Util.py
+++ b/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Util.py
@@ -23,3 +23,6 @@ def nsecs_nsecs(nsecs):
 def nsecs_str(nsecs):
     str = "%5u.%09u" % (nsecs_secs(nsecs), nsecs_nsecs(nsecs)),
     return str
+
+def clear_term():
+    print("\x1b[H\x1b[2J")
diff --git a/tools/perf/scripts/python/bin/sctop-record b/tools/perf/scripts/python/bin/sctop-record
new file mode 100644
index 0000000..27ccffa
--- /dev/null
+++ b/tools/perf/scripts/python/bin/sctop-record
@@ -0,0 +1,2 @@
+#!/bin/bash
+perf record -c 1 -f -a -M -R -e raw_syscalls:sys_enter $@
diff --git a/tools/perf/scripts/python/bin/sctop-report b/tools/perf/scripts/python/bin/sctop-report
new file mode 100644
index 0000000..b01c842
--- /dev/null
+++ b/tools/perf/scripts/python/bin/sctop-report
@@ -0,0 +1,24 @@
+#!/bin/bash
+# description: syscall top
+# args: [comm] [interval]
+n_args=0
+for i in "$@"
+do
+    if expr match "$i" "-" > /dev/null ; then
+	break
+    fi
+    n_args=$(( $n_args + 1 ))
+done
+if [ "$n_args" -gt 2 ] ; then
+    echo "usage: sctop-report [comm] [interval]"
+    exit
+fi
+if [ "$n_args" -gt 1 ] ; then
+    comm=$1
+    interval=$2
+    shift 2
+elif [ "$n_args" -gt 0 ] ; then
+    interval=$1
+    shift
+fi
+perf trace $@ -s ~/libexec/perf-core/scripts/python/sctop.py $comm $interval
diff --git a/tools/perf/scripts/python/sctop.py b/tools/perf/scripts/python/sctop.py
new file mode 100644
index 0000000..6cafad4
--- /dev/null
+++ b/tools/perf/scripts/python/sctop.py
@@ -0,0 +1,78 @@
+# system call top
+# (c) 2010, Tom Zanussi <tzanussi@gmail.com>
+# Licensed under the terms of the GNU GPL License version 2
+#
+# Periodically displays system-wide system call totals, broken down by
+# syscall.  If a [comm] arg is specified, only syscalls called by
+# [comm] are displayed. If an [interval] arg is specified, the display
+# will be refreshed every [interval] seconds.  The default interval is
+# 3 seconds.
+
+import thread
+import time
+import os
+import sys
+
+sys.path.append(os.environ['PERF_EXEC_PATH'] + \
+	'/scripts/python/Perf-Trace-Util/lib/Perf/Trace')
+
+from perf_trace_context import *
+from Core import *
+from Util import *
+
+usage = "perf trace -s syscall-counts.py [comm] [interval]\n";
+
+for_comm = None
+default_interval = 3
+interval = default_interval
+
+if len(sys.argv) > 3:
+	sys.exit(usage)
+
+if len(sys.argv) > 2:
+	for_comm = sys.argv[1]
+	interval = int(sys.argv[2])
+elif len(sys.argv) > 1:
+	try:
+		interval = int(sys.argv[1])
+	except ValueError:
+		for_comm = sys.argv[1]
+		interval = default_interval
+
+syscalls = autodict()
+
+def trace_begin():
+	thread.start_new_thread(print_syscall_totals, (interval,))
+	pass
+
+def raw_syscalls__sys_enter(event_name, context, common_cpu,
+	common_secs, common_nsecs, common_pid, common_comm,
+	id, args):
+	if for_comm is not None:
+		if common_comm != for_comm:
+			return
+	try:
+		syscalls[id] += 1
+	except TypeError:
+		syscalls[id] = 1
+
+def print_syscall_totals(interval):
+	while 1:
+		clear_term()
+		if for_comm is not None:
+			print "\nsyscall events for %s:\n\n" % (for_comm),
+		else:
+			print "\nsyscall events:\n\n",
+
+		print "%-40s  %10s\n" % ("event", "count"),
+		print "%-40s  %10s\n" % ("----------------------------------------", \
+						 "----------"),
+
+		for id, val in sorted(syscalls.iteritems(), key = lambda(k, v): (v, k), \
+					      reverse = True):
+			try:
+				print "%-40d  %10d\n" % (id, val),
+			except TypeError:
+				pass
+		syscalls.clear()
+		time.sleep(interval)
-- 
1.6.4.GIT

