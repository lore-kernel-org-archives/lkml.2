Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab0EJEsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 00:48:41 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55381 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab0EJErI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 00:47:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=aRj3TXeD0u9FXBSPyvz0JE4QHXFqd77DwT4BkBWfBBERjf2kr92cHhy0kfUe6kMC6V
         RQ/4Dvp0fK+ldDF/oAoPFqGUtxzCeK4hBlH8HVJCUrm5cqC6rZ5Jxnr41zTxN0BbN9J7
         XY5Vuvlxr1Y869DjNbwOLNcPYxskPSnhx7sVU=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, acme@ghostprotocols.net
Subject: [PATCH 2/9] perf/trace/scripting: rw-by-pid script cleanup
Date: Sun,  9 May 2010 23:46:53 -0500
Message-Id: <1273466820-9330-3-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1273466820-9330-1-git-send-email-tzanussi@gmail.com>
References: <1273466820-9330-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some minor fixes for the rw-by-pid script:

- Fix nuisance 'use of uninitialized value' warnings

- Change the failed read/write sections to sort by error counts

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
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
1.6.4.GIT

