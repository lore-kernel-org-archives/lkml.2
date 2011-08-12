Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab1HLR6R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 13:58:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752849Ab1HLR6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 13:58:14 -0400
From: Andrew Jones <drjones@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: drjones@redhat.com, rostedt@goodmis.org
Subject: [PATCH 07/10 v2] ktest: Introduce RERUN
Date: Fri, 12 Aug 2011 19:58:05 +0200
Message-Id: <1313171885-18148-1-git-send-email-drjones@redhat.com>
In-Reply-To: <1313155932-20092-8-git-send-email-drjones@redhat.com>
References: <1313155932-20092-8-git-send-email-drjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add another config variable that defines the number of additional
times a test must pass before it really passes. This is good for
bisecting boot problems, where the failure doesn't occur every time.
---
 tools/testing/ktest/ktest.pl    |   23 +++++++++++++++--------
 tools/testing/ktest/sample.conf |    7 +++++++
 2 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index e37c67e..28658b4 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -24,6 +24,7 @@ my %default;
 $default{"NUM_TESTS"}		= 1;
 $default{"REBOOT_TYPE"}		= "grub";
 $default{"TEST_TYPE"}		= "test";
+$default{"RERUN"}		= 0;
 $default{"BUILD_TYPE"}		= "randconfig";
 $default{"MAKE_CMD"}		= "make";
 $default{"TIMEOUT"}		= 120;
@@ -61,6 +62,7 @@ my $builddir;
 my $outputdir;
 my $output_config;
 my $test_type;
+my $rerun;
 my $build_type;
 my $build_options;
 my $pre_build;
@@ -1495,19 +1497,23 @@ sub do_run_test {
 sub do_test {
     my ($type) = @_;
     my $failed = 0;
+    my $runs = $rerun + 1; # run at least once
 
     grub_install;
-    start_monitor_and_boot or $failed = 1;
 
-    if ($failed && $in_bisect && $type ne "boot") {
-	end_monitor;
-	return -1;
-    }
+    while (!$failed && $runs--) {
+	start_monitor_and_boot or $failed = 1;
 
-    if (!$failed && $type ne "boot" && defined($run_test)) {
-	do_run_test or $failed = 1;
+	if ($failed && $in_bisect && $type ne "boot") {
+	    end_monitor;
+	    return -1;
+	}
+
+	if (!$failed && $type ne "boot" && defined($run_test)) {
+	    do_run_test or $failed = 1;
+	}
+	end_monitor;
     }
-    end_monitor;
     return !$failed;
 }
 
@@ -2807,6 +2813,7 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
     $outputdir = set_test_option("OUTPUT_DIR", $i);
     $builddir = set_test_option("BUILD_DIR", $i);
     $test_type = set_test_option("TEST_TYPE", $i);
+    $rerun = set_test_option("RERUN", $i);
     $build_type = set_test_option("BUILD_TYPE", $i);
     $build_options = set_test_option("BUILD_OPTIONS", $i);
     $pre_build = set_test_option("PRE_BUILD", $i);
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.conf
index ba430a7..8d0d33e 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -266,6 +266,13 @@
 # default (undefined)
 #TEST = ssh user@machine /root/run_test
 
+# The number of times the test must pass before we really believe
+# it passes. Generally you could put a loop in the 'TEST' program,
+# but this option makes it easier to do boot testing for problems
+# that don't occur on every boot.
+# (default 0)
+#RERUN = 10
+
 # The build type is any make config type or special command
 #  (default randconfig)
 #   nobuild - skip the clean and build step
-- 
1.7.4.1

