Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab1GZBZQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 21:25:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63368 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab1GZBY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 21:24:26 -0400
X-Authority-Analysis: v=1.1 cv=s3eDhkhcaTLnj7IEXy8aaXUiY7FbET0mf+/2Xe0elbc= c=1 sm=0 a=vhdKIqpQuCYA:10 a=DUG38Vp4498A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=3jspyiCFyKLk6jh2vqoA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110726012424.793325780@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 25 Jul 2011 21:22:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 02/19] ktest: Add detection of triple faults
References: <20110726012238.271008621@goodmis.org>
Content-Disposition: inline; filename=0002-ktest-Add-detection-of-triple-faults.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

When a triple fault happens in a test, no call trace nor panic
is displayed. Instead, the system reboots to the good kernel.
Since the good kernel may display a boot prompt that matches the
success string, ktest may think that the test succeeded, when it
did not.

Detecting triple faults is tricky because it is hard to generalize
what a reboot looks like. The best that we can come up with for now
is to examine the Linux banner. If we detect that the Linux banner
matches the test we want to test, then look to see if we hit another
Linux banner with a different kernel is booted. This can be assumed
to be a triple fault.

We can't just check for two Linux banners because things like
early printk may cause the Linux banner to be displayed twice. Checking
for different kernel versions should be the safe bet.

If this for some reason detects a false triple boot. A new ktest
config option is also created:

 DETECT_TRIPLE_FAULT

This can be set to 0 to disable this checking.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl    |   20 ++++++++++++++++++++
 tools/testing/ktest/sample.conf |   10 ++++++++++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index b96d381..a8e1826 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -41,6 +41,7 @@ $default{"CLEAR_LOG"}		= 0;
 $default{"BISECT_MANUAL"}	= 0;
 $default{"BISECT_SKIP"}		= 1;
 $default{"SUCCESS_LINE"}	= "login:";
+$default{"DETECT_TRIPLE_FAULT"} = 1;
 $default{"BOOTED_TIMEOUT"}	= 1;
 $default{"DIE_ON_FAILURE"}	= 1;
 $default{"SSH_EXEC"}		= "ssh \$SSH_USER\@\$MACHINE \$SSH_COMMAND";
@@ -101,6 +102,7 @@ my $patchcheck_sleep_time;
 my $store_failures;
 my $timeout;
 my $booted_timeout;
+my $detect_triplefault;
 my $console;
 my $success_line;
 my $stop_after_success;
@@ -836,6 +838,7 @@ sub monitor {
     my $failure_start;
     my $monitor_start = time;
     my $done = 0;
+    my $version_found = 0;
 
     while (!$done) {
 
@@ -904,6 +907,22 @@ sub monitor {
 	    $bug = 1;
 	}
 
+	# Detect triple faults by testing the banner
+	if ($full_line =~ /\bLinux version (\S+).*\n/) {
+	    if ($1 eq $version) {
+		$version_found = 1;
+	    } elsif ($version_found && $detect_triplefault) {
+		# We already booted into the kernel we are testing,
+		# but now we booted into another kernel?
+		# Consider this a triple fault.
+		doprint "Aleady booted in Linux kernel $version, but now\n";
+		doprint "we booted into Linux kernel $1.\n";
+		doprint "Assuming that this is a triple fault.\n";
+		doprint "To disable this: set DETECT_TRIPLE_FAULT to 0\n";
+		last;
+	    }
+	}
+
 	if ($line =~ /\n/) {
 	    $full_line = "";
 	}
@@ -2159,6 +2178,7 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
     $timeout = set_test_option("TIMEOUT", $i);
     $booted_timeout = set_test_option("BOOTED_TIMEOUT", $i);
     $console = set_test_option("CONSOLE", $i);
+    $detect_triplefault = set_test_option("DETECT_TRIPLE_FAULT", $i);
     $success_line = set_test_option("SUCCESS_LINE", $i);
     $stop_after_success = set_test_option("STOP_AFTER_SUCCESS", $i);
     $stop_after_failure = set_test_option("STOP_AFTER_FAILURE", $i);
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.conf
index 48cbcc80..c2c072e 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -518,6 +518,16 @@
 # The variables SSH_USER and MACHINE are defined.
 #REBOOT = ssh $SSH_USER@$MACHINE reboot
 
+# The way triple faults are detected is by testing the kernel
+# banner. If the kernel banner for the kernel we are testing is
+# found, and then later a kernel banner for another kernel version
+# is found, it is considered that we encountered a triple fault,
+# and there is no panic or callback, but simply a reboot.
+# To disable this (because it did a false positive) set the following
+# to 0.
+# (default 1)
+#DETECT_TRIPLE_FAULT = 0
+
 #### Per test run options ####
 # The following options are only allowed in TEST_START sections.
 # They are ignored in the DEFAULTS sections.
-- 
1.7.5.4


