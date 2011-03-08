Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab1CHP0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 10:26:53 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:55482 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682Ab1CHPZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 10:25:30 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=AvHriW1wnYUA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=oNGoG1hOOy7x4Em2gdgA:9 a=vnxF4fM7jYt-08egoJfXJXnFcqEA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110308152528.275834988@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 08 Mar 2011 10:22:02 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4/9] ktest: Add manual bisect
References: <20110308152158.799699072@goodmis.org>
Content-Disposition: inline; filename=0004-ktest-Add-manual-bisect.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

For both git bisect and config bisect, if BISECT_MANUAL is set to 1,
then bisect will stop between iterations and ask the user for the
result. The actual result is ignored. This makes it possible to
use ktest.pl for bisecting configs and git and let the user examine
the results themselves and enter their own results.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl    |   33 +++++++++++++++++++++++++++++++--
 tools/testing/ktest/sample.conf |   16 ++++++++++++++++
 2 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index c95209b..e55bd52 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -37,6 +37,7 @@ $default{"POWEROFF_ON_SUCCESS"}	= 0;
 $default{"BUILD_OPTIONS"}	= "";
 $default{"BISECT_SLEEP_TIME"}	= 60;   # sleep time between bisects
 $default{"CLEAR_LOG"}		= 0;
+$default{"BISECT_MANUAL"}	= 0;
 $default{"SUCCESS_LINE"}	= "login:";
 $default{"BOOTED_TIMEOUT"}	= 1;
 $default{"DIE_ON_FAILURE"}	= 1;
@@ -81,6 +82,7 @@ my $addconfig;
 my $in_bisect = 0;
 my $bisect_bad = "";
 my $reverse_bisect;
+my $bisect_manual;
 my $in_patchcheck = 0;
 my $run_test;
 my $redirect;
@@ -1046,6 +1048,21 @@ sub get_version {
     doprint "$version\n";
 }
 
+sub answer_bisect {
+    for (;;) {
+	doprint "Pass or fail? [p/f]";
+	my $ans = <STDIN>;
+	chomp $ans;
+	if ($ans eq "p" || $ans eq "P") {
+	    return 1;
+	} elsif ($ans eq "f" || $ans eq "F") {
+	    return 0;
+	} else {
+	    print "Please answer 'P' or 'F'\n";
+	}
+    }
+}
+
 sub child_run_test {
     my $failed = 0;
 
@@ -1214,6 +1231,9 @@ sub run_bisect {
 
     my $ret = run_bisect_test $type, $buildtype;
 
+    if ($bisect_manual) {
+	$ret = answer_bisect;
+    }
 
     # Are we looking for where it worked, not failed?
     if ($reverse_bisect) {
@@ -1524,7 +1544,9 @@ sub run_config_bisect {
 	}
 
 	$ret = run_config_bisect_test $type;
-
+	if ($bisect_manual) {
+	    $ret = answer_bisect;
+	}
 	if ($ret) {
 	    process_passed %current_config;
 	    return 0;
@@ -1555,7 +1577,13 @@ sub run_config_bisect {
 	$half = int($#start_list / 2);
     } while ($half > 0);
 
-    # we found a single config, try it again
+    # we found a single config, try it again unless we are running manually
+
+    if ($bisect_manual) {
+	process_failed $start_list[0];
+	return 1;
+    }
+
     my @tophalf = @start_list[0 .. 0];
 
     $ret = run_config_bisect_test $type;
@@ -1925,6 +1953,7 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
     $poweroff_after_halt = set_test_option("POWEROFF_AFTER_HALT", $i);
     $sleep_time = set_test_option("SLEEP_TIME", $i);
     $bisect_sleep_time = set_test_option("BISECT_SLEEP_TIME", $i);
+    $bisect_manual = set_test_option("BISECT_MANUAL", $i);
     $store_failures = set_test_option("STORE_FAILURES", $i);
     $timeout = set_test_option("TIMEOUT", $i);
     $booted_timeout = set_test_option("BOOTED_TIMEOUT", $i);
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.conf
index 3408c59..af82ac2 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -528,6 +528,15 @@
 #   With BISECT_REVERSE = 1, The test will consider failures as
 #   good, and success as bad.
 #
+# BISECT_MANUAL = 1 (optional, default 0)
+#
+#   In case there's a problem with automating the bisect for
+#   whatever reason. (Can't reboot, want to inspect each iteration)
+#   Doing a BISECT_MANUAL will have the test wait for you to
+#   tell it if the test passed or failed after each iteration.
+#   This is basicall the same as running git bisect yourself
+#   but ktest will rebuild and install the kernel for you.
+#
 # BISECT_CHECK = 1 (optional, default 0)
 #
 #   Just to be sure the good is good and bad is bad, setting
@@ -613,10 +622,17 @@
 #
 #   CONFIG_BISECT is the config that failed to boot
 #
+#   If BISECT_MANUAL is set, it will pause between iterations.
+#   This is useful to use just ktest.pl just for the config bisect.
+#   If you set it to build, it will run the bisect and you can
+#   control what happens in between iterations. It will ask you if
+#   the test succeeded or not and continue the config bisect.
+#
 # Example:
 #   TEST_START
 #   TEST_TYPE = config_bisect
 #   CONFIG_BISECT_TYPE = build
 #   CONFIG_BISECT = /home/test/¢onfig-bad
 #   MIN_CONFIG = /home/test/config-min
+#   BISECT_MANUAL = 1
 #
-- 
1.7.2.3


