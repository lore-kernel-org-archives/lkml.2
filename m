Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458Ab1KRLg7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 06:36:59 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63110 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757052Ab1KRLg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 06:36:56 -0500
From: Rabin Vincent <rabin@rab.in>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Rabin Vincent <rabin@rab.in>
Subject: [PATCH 1/3] ktest: save test output
Date: Fri, 18 Nov 2011 17:05:29 +0530
Message-Id: <1321616131-21352-1-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The test output may contain useful information; save it along with the
already-saved buildlog, dmesg, and .config.

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 tools/testing/ktest/ktest.pl |   30 +++++++++++++++++++-----------
 1 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 30e2bef..3185e0a 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -103,6 +103,7 @@ my $in_patchcheck = 0;
 my $run_test;
 my $redirect;
 my $buildlog;
+my $testlog;
 my $dmesg;
 my $monitor_fp;
 my $monitor_pid;
@@ -1005,17 +1006,19 @@ sub fail {
 	    mkpath($faildir) or
 		die "can't create $faildir";
 	}
-	if (-f "$output_config") {
-	    cp "$output_config", "$faildir/config" or
-		die "failed to copy .config";
-	}
-	if (-f $buildlog) {
-	    cp $buildlog, "$faildir/buildlog" or
-		die "failed to move $buildlog";
-	}
-	if (-f $dmesg) {
-	    cp $dmesg, "$faildir/dmesg" or
-		die "failed to move $dmesg";
+
+	my %files = (
+		"config" => $output_config,
+		"buildlog" => $buildlog,
+		"dmesg" => $dmesg,
+		"testlog" => $testlog,
+	);
+
+	while (my ($name, $source) = each(%files)) {
+		if (-f "$source") {
+			cp "$source", "$faildir/$name" or
+				die "failed to copy $source";
+		}
 	}
 
 	doprint "*** Saved info to $faildir ***\n";
@@ -1653,7 +1656,10 @@ sub child_run_test {
     $poweroff_on_error = 0;
     $die_on_failure = 1;
 
+    $redirect = "$testlog";
     run_command $run_test or $failed = 1;
+    undef $redirect;
+
     exit $failed;
 }
 
@@ -3153,6 +3159,7 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
     $target = "$ssh_user\@$machine";
 
     $buildlog = "$tmpdir/buildlog-$machine";
+    $testlog = "$tmpdir/testlog-$machine";
     $dmesg = "$tmpdir/dmesg-$machine";
     $make = "$makecmd O=$outputdir";
     $output_config = "$outputdir/.config";
@@ -3189,6 +3196,7 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
 
     unlink $dmesg;
     unlink $buildlog;
+    unlink $testlog;
 
     if (defined($addconfig)) {
 	my $min = $minconfig;
-- 
1.7.7.3

