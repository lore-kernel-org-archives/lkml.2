Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932734Ab0EJXZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:25:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:50143 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932561Ab0EJWxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:53:17 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tzanussi@gmail.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/10] perf/trace/scripting: rwtop script cleanup
Date: Mon, 10 May 2010 19:53:02 -0300
Message-Id: <1273531987-28956-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1273531987-28956-1-git-send-email-acme@infradead.org>
References: <1273531987-28956-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <tzanussi@gmail.com>

A couple of fixes for the rwtop script:

- printing the totals and clearing the hashes in the signal handler
  eventually leads to various random and serious problems when running
  the rwtop script continuously.  Moving the print_totals() calls to
  the event handlers solves that problem, and the event handlers are
  invoked frequently enough that it doesn't affect the timeliness of
  the output.

- Fix nuisance 'use of uninitialized value' warnings

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Message-Id: <1273466820-9330-4-git-send-email-tzanussi@gmail.com>
Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/scripts/perl/rwtop.pl |   48 +++++++++++++++++++++++++++----------
 1 files changed, 35 insertions(+), 13 deletions(-)

diff --git a/tools/perf/scripts/perl/rwtop.pl b/tools/perf/scripts/perl/rwtop.pl
index ec2ab49..4bb3ecd 100644
--- a/tools/perf/scripts/perl/rwtop.pl
+++ b/tools/perf/scripts/perl/rwtop.pl
@@ -21,6 +21,7 @@ use Perf::Trace::Util;
 my $default_interval = 3;
 my $nlines = 20;
 my $print_thread;
+my $print_pending = 0;
 
 my %reads;
 my %writes;
@@ -36,6 +37,8 @@ sub syscalls::sys_exit_read
 	$common_pid, $common_comm,
 	$nr, $ret) = @_;
 
+    print_check();
+
     if ($ret > 0) {
 	$reads{$common_pid}{bytes_read} += $ret;
     } else {
@@ -52,6 +55,8 @@ sub syscalls::sys_enter_read
 	$common_pid, $common_comm,
 	$nr, $fd, $buf, $count) = @_;
 
+    print_check();
+
     $reads{$common_pid}{bytes_requested} += $count;
     $reads{$common_pid}{total_reads}++;
     $reads{$common_pid}{comm} = $common_comm;
@@ -63,6 +68,8 @@ sub syscalls::sys_exit_write
 	$common_pid, $common_comm,
 	$nr, $ret) = @_;
 
+    print_check();
+
     if ($ret <= 0) {
 	$writes{$common_pid}{errors}{$ret}++;
     }
@@ -74,6 +81,8 @@ sub syscalls::sys_enter_write
 	$common_pid, $common_comm,
 	$nr, $fd, $buf, $count) = @_;
 
+    print_check();
+
     $writes{$common_pid}{bytes_written} += $count;
     $writes{$common_pid}{total_writes}++;
     $writes{$common_pid}{comm} = $common_comm;
@@ -81,7 +90,7 @@ sub syscalls::sys_enter_write
 
 sub trace_begin
 {
-    $SIG{ALRM} = \&print_totals;
+    $SIG{ALRM} = \&set_print_pending;
     alarm 1;
 }
 
@@ -91,6 +100,20 @@ sub trace_end
     print_totals();
 }
 
+sub print_check()
+{
+    if ($print_pending == 1) {
+	$print_pending = 0;
+	print_totals();
+    }
+}
+
+sub set_print_pending()
+{
+    $print_pending = 1;
+    alarm $interval;
+}
+
 sub print_totals
 {
     my $count;
@@ -106,12 +129,12 @@ sub print_totals
     printf("%6s  %-20s  %10s  %10s  %10s\n", "------", "--------------------",
 	   "----------", "----------", "----------");
 
-    foreach my $pid (sort {$reads{$b}{bytes_read} <=>
-			       $reads{$a}{bytes_read}} keys %reads) {
-	my $comm = $reads{$pid}{comm};
-	my $total_reads = $reads{$pid}{total_reads};
-	my $bytes_requested = $reads{$pid}{bytes_requested};
-	my $bytes_read = $reads{$pid}{bytes_read};
+    foreach my $pid (sort { ($reads{$b}{bytes_read} || 0) <=>
+			       ($reads{$a}{bytes_read} || 0) } keys %reads) {
+	my $comm = $reads{$pid}{comm} || "";
+	my $total_reads = $reads{$pid}{total_reads} || 0;
+	my $bytes_requested = $reads{$pid}{bytes_requested} || 0;
+	my $bytes_read = $reads{$pid}{bytes_read} || 0;
 
 	printf("%6s  %-20s  %10s  %10s  %10s\n", $pid, $comm,
 	       $total_reads, $bytes_requested, $bytes_read);
@@ -130,11 +153,11 @@ sub print_totals
     printf("%6s  %-20s  %10s  %13s\n", "------", "--------------------",
 	   "----------", "-------------");
 
-    foreach my $pid (sort {$writes{$b}{bytes_written} <=>
-			       $writes{$a}{bytes_written}} keys %writes) {
-	my $comm = $writes{$pid}{comm};
-	my $total_writes = $writes{$pid}{total_writes};
-	my $bytes_written = $writes{$pid}{bytes_written};
+    foreach my $pid (sort { ($writes{$b}{bytes_written} || 0) <=>
+			($writes{$a}{bytes_written} || 0)} keys %writes) {
+	my $comm = $writes{$pid}{comm} || "";
+	my $total_writes = $writes{$pid}{total_writes} || 0;
+	my $bytes_written = $writes{$pid}{bytes_written} || 0;
 
 	printf("%6s  %-20s  %10s  %13s\n", $pid, $comm,
 	       $total_writes, $bytes_written);
@@ -146,7 +169,6 @@ sub print_totals
 
     %reads = ();
     %writes = ();
-    alarm $interval;
 }
 
 my %unhandled;
-- 
1.6.2.5

