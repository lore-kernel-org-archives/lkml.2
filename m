Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab1CHPZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 10:25:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48092 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662Ab1CHPZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 10:25:30 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=BBzDQFhYHs0A:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=lwPq98dktvRkvEL2pp0A:9 a=2HlrUBlnpBF73NW52RoBk6lT6KUA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110308152528.498803514@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 08 Mar 2011 10:22:03 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5/9] ktest: Add BISECT_SKIP
References: <20110308152158.799699072@goodmis.org>
Content-Disposition: inline; filename=0005-ktest-Add-BISECT_SKIP.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

If a during a git bisect, ktest fails on something other than
what it is testing (if BISECT_TYPE is test but it fails on build),
if BISECT_SKIP is set, then it will do a "git bisect skip" instead
of just failing the bisect and letting the user find a good commit
to test.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl    |   36 ++++++++++++++++++++++++++++--------
 tools/testing/ktest/sample.conf |    9 +++++++++
 2 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index e55bd52..0f62916 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -38,6 +38,7 @@ $default{"BUILD_OPTIONS"}	= "";
 $default{"BISECT_SLEEP_TIME"}	= 60;   # sleep time between bisects
 $default{"CLEAR_LOG"}		= 0;
 $default{"BISECT_MANUAL"}	= 0;
+$default{"BISECT_SKIP"}		= 1;
 $default{"SUCCESS_LINE"}	= "login:";
 $default{"BOOTED_TIMEOUT"}	= 1;
 $default{"DIE_ON_FAILURE"}	= 1;
@@ -83,6 +84,7 @@ my $in_bisect = 0;
 my $bisect_bad = "";
 my $reverse_bisect;
 my $bisect_manual;
+my $bisect_skip;
 my $in_patchcheck = 0;
 my $run_test;
 my $redirect;
@@ -1169,7 +1171,15 @@ sub run_git_bisect {
     return 1;
 }
 
-# returns 1 on success, 0 on failure
+sub bisect_reboot {
+    doprint "Reboot and sleep $bisect_sleep_time seconds\n";
+    reboot;
+    start_monitor;
+    wait_for_monitor $bisect_sleep_time;
+    end_monitor;
+}
+
+# returns 1 on success, 0 on failure, -1 on skip
 sub run_bisect_test {
     my ($type, $buildtype) = @_;
 
@@ -1183,6 +1193,10 @@ sub run_bisect_test {
     build $buildtype or $failed = 1;
 
     if ($type ne "build") {
+	if ($failed && $bisect_skip) {
+	    $in_bisect = 0;
+	    return -1;
+	}
 	dodie "Failed on build" if $failed;
 
 	# Now boot the box
@@ -1194,6 +1208,12 @@ sub run_bisect_test {
 	monitor or $failed = 1;
 
 	if ($type ne "boot") {
+	    if ($failed && $bisect_skip) {
+		end_monitor;
+		bisect_reboot;
+		$in_bisect = 0;
+		return -1;
+	    }
 	    dodie "Failed on boot" if $failed;
 
 	    do_run_test or $failed = 1;
@@ -1206,11 +1226,7 @@ sub run_bisect_test {
 
 	# reboot the box to a good kernel
 	if ($type ne "build") {
-	    doprint "Reboot and sleep $bisect_sleep_time seconds\n";
-	    reboot;
-	    start_monitor;
-	    wait_for_monitor $bisect_sleep_time;
-	    end_monitor;
+	    bisect_reboot;
 	}
     } else {
 	$result = 1;
@@ -1240,10 +1256,13 @@ sub run_bisect {
 	$ret = !$ret;
     }
 
-    if ($ret) {
+    if ($ret > 0) {
 	return "good";
-    } else {
+    } elsif ($ret == 0) {
 	return  "bad";
+    } elsif ($bisect_skip) {
+	doprint "HIT A BAD COMMIT ... SKIPPING\n";
+	return "skip";
     }
 }
 
@@ -1954,6 +1973,7 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
     $sleep_time = set_test_option("SLEEP_TIME", $i);
     $bisect_sleep_time = set_test_option("BISECT_SLEEP_TIME", $i);
     $bisect_manual = set_test_option("BISECT_MANUAL", $i);
+    $bisect_skip = set_test_option("BISECT_SKIP", $i);
     $store_failures = set_test_option("STORE_FAILURES", $i);
     $timeout = set_test_option("TIMEOUT", $i);
     $booted_timeout = set_test_option("BOOTED_TIMEOUT", $i);
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.conf
index af82ac2..4c46b7e 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -519,6 +519,15 @@
 #   git bisect good, git bisect bad, and running the git bisect replay
 #   if the BISECT_REPLAY is set.
 #
+# BISECT_SKIP = 1 (optional, default 0)
+#
+#   If BISECT_TYPE is set to test but the build fails, ktest will
+#   simply fail the test and end their. You could use BISECT_REPLAY
+#   and BISECT_START to resume after you found a new starting point,
+#   or you could set BISECT_SKIP to 1. If BISECT_SKIP is set to 1,
+#   when something other than the BISECT_TYPE fails, ktest.pl will
+#   run "git bisect skip" and try again.
+#
 # BISECT_REVERSE = 1 (optional, default 0)
 #
 #   In those strange instances where it was broken forever
-- 
1.7.2.3


