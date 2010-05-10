Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748Ab0EJXZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:25:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:50144 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932588Ab0EJWxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:53:17 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tzanussi@gmail.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/10] perf/trace/scripting: rw-by-pid script cleanup
Date: Mon, 10 May 2010 19:53:01 -0300
Message-Id: <1273531987-28956-4-git-send-email-acme@infradead.org>
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

Some minor fixes for the rw-by-pid script:

- Fix nuisance 'use of uninitialized value' warnings

- Change the failed read/write sections to sort by error counts

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <1273466820-9330-3-git-send-email-tzanussi@gmail.com>
Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/scripts/perl/rw-by-pid.pl |   60 +++++++++++++++++++++-------------
 1 files changed, 37 insertions(+), 23 deletions(-)

diff --git a/tools/perf/scripts/perl/rw-by-pid.pl b/tools/perf/scripts/perl/rw-by-pid.pl
index da601fa..9db23c9 100644
--- a/tools/perf/scripts/perl/rw-by-pid.pl
+++ b/tools/perf/scripts/perl/rw-by-pid.pl
@@ -79,12 +79,12 @@ sub trace_end
     printf("%6s  %-20s  %10s  %10s  %10s\n", "------", "--------------------",
 	   "-----------", "----------", "----------");
 
-    foreach my $pid (sort {$reads{$b}{bytes_read} <=>
-			       $reads{$a}{bytes_read}} keys %reads) {
-	my $comm = $reads{$pid}{comm};
-	my $total_reads = $reads{$pid}{total_reads};
-	my $bytes_requested = $reads{$pid}{bytes_requested};
-	my $bytes_read = $reads{$pid}{bytes_read};
+    foreach my $pid (sort { ($reads{$b}{bytes_read} || 0) <=>
+				($reads{$a}{bytes_read} || 0) } keys %reads) {
+	my $comm = $reads{$pid}{comm} || "";
+	my $total_reads = $reads{$pid}{total_reads} || 0;
+	my $bytes_requested = $reads{$pid}{bytes_requested} || 0;
+	my $bytes_read = $reads{$pid}{bytes_read} || 0;
 
 	printf("%6s  %-20s  %10s  %10s  %10s\n", $pid, $comm,
 	       $total_reads, $bytes_requested, $bytes_read);
@@ -96,16 +96,23 @@ sub trace_end
     printf("%6s  %20s  %6s  %10s\n", "------", "--------------------",
 	   "------", "----------");
 
-    foreach my $pid (keys %reads) {
-	my $comm = $reads{$pid}{comm};
-	foreach my $err (sort {$reads{$b}{comm} cmp $reads{$a}{comm}}
-			 keys %{$reads{$pid}{errors}}) {
-	    my $errors = $reads{$pid}{errors}{$err};
+    my @errcounts = ();
 
-	    printf("%6d  %-20s  %6d  %10s\n", $pid, $comm, $err, $errors);
+    foreach my $pid (keys %reads) {
+	foreach my $error (keys %{$reads{$pid}{errors}}) {
+	    my $comm = $reads{$pid}{comm} || "";
+	    my $errcount = $reads{$pid}{errors}{$error} || 0;
+	    push @errcounts, [$pid, $comm, $error, $errcount];
 	}
     }
 
+    @errcounts = sort { $b->[3] <=> $a->[3] } @errcounts;
+
+    for my $i (0 .. $#errcounts) {
+	printf("%6d  %-20s  %6d  %10s\n", $errcounts[$i][0],
+	       $errcounts[$i][1], $errcounts[$i][2], $errcounts[$i][3]);
+    }
+
     printf("\nwrite counts by pid:\n\n");
 
     printf("%6s  %20s  %10s  %10s\n", "pid", "comm",
@@ -113,11 +120,11 @@ sub trace_end
     printf("%6s  %-20s  %10s  %10s\n", "------", "--------------------",
 	   "-----------", "----------");
 
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
 
 	printf("%6s  %-20s  %10s  %10s\n", $pid, $comm,
 	       $total_writes, $bytes_written);
@@ -129,16 +136,23 @@ sub trace_end
     printf("%6s  %20s  %6s  %10s\n", "------", "--------------------",
 	   "------", "----------");
 
-    foreach my $pid (keys %writes) {
-	my $comm = $writes{$pid}{comm};
-	foreach my $err (sort {$writes{$b}{comm} cmp $writes{$a}{comm}}
-			 keys %{$writes{$pid}{errors}}) {
-	    my $errors = $writes{$pid}{errors}{$err};
+    @errcounts = ();
 
-	    printf("%6d  %-20s  %6d  %10s\n", $pid, $comm, $err, $errors);
+    foreach my $pid (keys %writes) {
+	foreach my $error (keys %{$writes{$pid}{errors}}) {
+	    my $comm = $writes{$pid}{comm} || "";
+	    my $errcount = $writes{$pid}{errors}{$error} || 0;
+	    push @errcounts, [$pid, $comm, $error, $errcount];
 	}
     }
 
+    @errcounts = sort { $b->[3] <=> $a->[3] } @errcounts;
+
+    for my $i (0 .. $#errcounts) {
+	printf("%6d  %-20s  %6d  %10s\n", $errcounts[$i][0],
+	       $errcounts[$i][1], $errcounts[$i][2], $errcounts[$i][3]);
+    }
+
     print_unhandled();
 }
 
-- 
1.6.2.5

