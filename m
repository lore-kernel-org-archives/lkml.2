Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab1KRLhK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 06:37:10 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61547 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772Ab1KRLhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 06:37:03 -0500
From: Rabin Vincent <rabin@rab.in>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Rabin Vincent <rabin@rab.in>
Subject: [PATCH 3/3] ktest: allow success logs to be stored
Date: Fri, 18 Nov 2011 17:05:31 +0530
Message-Id: <1321616131-21352-3-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1321616131-21352-1-git-send-email-rabin@rab.in>
References: <1321616131-21352-1-git-send-email-rabin@rab.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a STORE_SUCCESSES option, to allow success logs to be stored, for
example to double-check or otherwise post-process the test logs.

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 tools/testing/ktest/ktest.pl    |   80 ++++++++++++++++++++++----------------
 tools/testing/ktest/sample.conf |    6 +++
 2 files changed, 52 insertions(+), 34 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index e93c21c..6ef104e 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -113,6 +113,7 @@ my $bisect_sleep_time;
 my $patchcheck_sleep_time;
 my $ignore_warnings;
 my $store_failures;
+my $store_successes;
 my $test_name;
 my $timeout;
 my $booted_timeout;
@@ -976,6 +977,43 @@ sub wait_for_monitor {
     print "** Monitor flushed **\n";
 }
 
+sub save_logs {
+	my ($result, $basedir) = @_;
+	my @t = localtime;
+	my $date = sprintf "%04d%02d%02d%02d%02d%02d",
+		1900+$t[5],$t[4],$t[3],$t[2],$t[1],$t[0];
+
+	my $type = $build_type;
+	if ($type =~ /useconfig/) {
+	    $type = "useconfig";
+	}
+
+	my $dir = "$machine-$test_type-$type-$result-$date";
+
+	$dir = "$basedir/$dir";
+
+	if (!-d $dir) {
+	    mkpath($dir) or
+		die "can't create $dir";
+	}
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
+			cp "$source", "$dir/$name" or
+				die "failed to copy $source";
+		}
+	}
+
+	doprint "*** Saved info to $dir ***\n";
+}
+
 sub fail {
 
 	if ($die_on_failure) {
@@ -1004,40 +1042,9 @@ sub fail {
 	doprint "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n";
 	doprint "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n";
 
-	return 1 if (!defined($store_failures));
-
-	my @t = localtime;
-	my $date = sprintf "%04d%02d%02d%02d%02d%02d",
-		1900+$t[5],$t[4],$t[3],$t[2],$t[1],$t[0];
-
-	my $type = $build_type;
-	if ($type =~ /useconfig/) {
-	    $type = "useconfig";
-	}
-
-	my $dir = "$machine-$test_type-$type-fail-$date";
-	my $faildir = "$store_failures/$dir";
-
-	if (!-d $faildir) {
-	    mkpath($faildir) or
-		die "can't create $faildir";
-	}
-
-	my %files = (
-		"config" => $output_config,
-		"buildlog" => $buildlog,
-		"dmesg" => $dmesg,
-		"testlog" => $testlog,
-	);
-
-	while (my ($name, $source) = each(%files)) {
-		if (-f "$source") {
-			cp "$source", "$faildir/$name" or
-				die "failed to copy $source";
-		}
-	}
-
-	doprint "*** Saved info to $faildir ***\n";
+	if (defined($store_failures)) {
+	    save_logs "fail", $store_failures;
+        }
 
 	return 1;
 }
@@ -1643,6 +1650,10 @@ sub success {
     doprint     "*******************************************\n";
     doprint     "*******************************************\n";
 
+    if (defined($store_successes)) {
+        save_logs "success", $store_successes;
+    }
+
     if ($i != $opt{"NUM_TESTS"} && !do_not_reboot) {
 	doprint "Reboot and wait $sleep_time seconds\n";
 	reboot $sleep_time;
@@ -3137,6 +3148,7 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
     $bisect_skip = set_test_option("BISECT_SKIP", $i);
     $config_bisect_good = set_test_option("CONFIG_BISECT_GOOD", $i);
     $store_failures = set_test_option("STORE_FAILURES", $i);
+    $store_successes = set_test_option("STORE_SUCCESSES", $i);
     $test_name = set_test_option("TEST_NAME", $i);
     $timeout = set_test_option("TIMEOUT", $i);
     $booted_timeout = set_test_option("BOOTED_TIMEOUT", $i);
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.conf
index dbedfa1..42e0eb9 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -589,6 +589,12 @@
 # (default undefined)
 #STORE_FAILURES = /home/test/failures
 
+# Directory to store success directories on success. If this is not
+# set, the .config, dmesg and bootlog will not be saved if a
+# test succeeds.
+# (default undefined)
+#STORE_SUCCESSES = /home/test/successes
+
 # Build without doing a make mrproper, or removing .config
 # (default 0)
 #BUILD_NOCLEAN = 0
-- 
1.7.7.3

