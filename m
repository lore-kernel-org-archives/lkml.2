Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab1CHPZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 10:25:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55502 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755846Ab1CHPZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 10:25:32 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=hVPxbtuOsy8A:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=E_DdU4eWxq4ufJsO4CIA:9 a=FFywZfXYYL9EqSQz_OhCQDF1sMoA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110308152529.516028891@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 08 Mar 2011 10:22:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 9/9] ktest: Add STOP_TEST_AFTER to stop the test after a period of time
References: <20110308152158.799699072@goodmis.org>
Content-Disposition: inline; filename=0009-ktest-Add-STOP_TEST_AFTER-to-stop-the-test-after-a-p.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Currently, if a test causes constant output but never reaches a
boot prompt, or crashes, the test will never stop. Add STOP_TEST_AFTER
to create a variable that will stop (and fail) the test after it has run
for this amount of time. The default is 10 minutes. Setting this
variable to -1 will disable it.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl    |   13 ++++++++++++-
 tools/testing/ktest/sample.conf |    8 ++++++++
 2 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 8bbfcee..a8b3292 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -47,6 +47,7 @@ $default{"SCP_TO_TARGET"}	= "scp \$SRC_FILE \$SSH_USER\@\$MACHINE:\$DST_FILE";
 $default{"REBOOT"}		= "ssh \$SSH_USER\@\$MACHINE reboot";
 $default{"STOP_AFTER_SUCCESS"}	= 10;
 $default{"STOP_AFTER_FAILURE"}	= 60;
+$default{"STOP_TEST_AFTER"}	= 600;
 $default{"LOCALVERSION"}	= "-test";
 
 my $ktest_config;
@@ -102,6 +103,7 @@ my $console;
 my $success_line;
 my $stop_after_success;
 my $stop_after_failure;
+my $stop_test_after;
 my $build_target;
 my $target_image;
 my $localversion;
@@ -768,8 +770,10 @@ sub monitor {
 
     my $success_start;
     my $failure_start;
+    my $monitor_start = time;
+    my $done = 0;
 
-    for (;;) {
+    while (!$done) {
 
 	if ($booted) {
 	    $line = wait_for_input($monitor_fp, $booted_timeout);
@@ -831,6 +835,12 @@ sub monitor {
 	if ($line =~ /\n/) {
 	    $full_line = "";
 	}
+
+	if ($stop_test_after > 0 && !$booted && !$bug) {
+	    if (time - $monitor_start > $stop_test_after) {
+		$done = 1;
+	    }
+	}
     }
 
     close(DMESG);
@@ -2002,6 +2012,7 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
     $success_line = set_test_option("SUCCESS_LINE", $i);
     $stop_after_success = set_test_option("STOP_AFTER_SUCCESS", $i);
     $stop_after_failure = set_test_option("STOP_AFTER_FAILURE", $i);
+    $stop_test_after = set_test_option("STOP_TEST_AFTER", $i);
     $build_target = set_test_option("BUILD_TARGET", $i);
     $ssh_exec = set_test_option("SSH_EXEC", $i);
     $scp_to_target = set_test_option("SCP_TO_TARGET", $i);
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.conf
index 4c83ae7..4c5d6bd 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -306,6 +306,14 @@
 # (default 60)
 #STOP_AFTER_FAILURE = 60
 
+# In case the console constantly fills the screen, having
+# a specified time to stop the test if it never succeeds nor fails
+# is recommended.
+# Note: this is ignored if a success or failure is detected.
+# (in seconds)
+# (default 600, -1 is to never stop)
+#STOP_TEST_AFTER = 600
+
 # Stop testing if a build fails. If set, the script will end if
 # a failure is detected, otherwise it will save off the .config,
 # dmesg and bootlog in a directory called
-- 
1.7.2.3


