Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab1HLNcj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 09:32:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855Ab1HLNcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 09:32:33 -0400
From: Andrew Jones <drjones@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: drjones@redhat.com, rostedt@goodmis.org
Subject: [PATCH 10/10] ktest: Introduce FAILURE_LINE
Date: Fri, 12 Aug 2011 15:32:12 +0200
Message-Id: <1313155932-20092-11-git-send-email-drjones@redhat.com>
In-Reply-To: <1313155932-20092-1-git-send-email-drjones@redhat.com>
References: <1313155932-20092-1-git-send-email-drjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the counterpart to SUCCESS_LINE. In some cases the boot will
succeed, but the console will display a message that means that the
boot test failed (such as a warning) while it boots. Use this option
to detect this and fail the test.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/ktest/ktest.pl    |    7 +++++++
 tools/testing/ktest/sample.conf |    7 +++++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index ac0e688..35af7e2 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -122,6 +122,7 @@ my $booted_timeout;
 my $detect_triplefault;
 my $console;
 my $success_line;
+my $failure_line;
 my $stop_after_success;
 my $stop_after_failure;
 my $stop_test_after;
@@ -1015,6 +1016,11 @@ sub monitor {
 	# we are not guaranteed to get a full line
 	$full_line .= $line;
 
+	if (defined($failure_line) && $full_line =~ /$failure_line/) {
+	    $bug = 1;
+	    last;
+	}
+
 	if ($full_line =~ /$success_line/) {
 	    $booted = 1;
 	    $success_start = time;
@@ -2872,6 +2878,7 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
     $console = set_test_option("CONSOLE", $i);
     $detect_triplefault = set_test_option("DETECT_TRIPLE_FAULT", $i);
     $success_line = set_test_option("SUCCESS_LINE", $i);
+    $failure_line = set_test_option("FAILURE_LINE", $i);
     $stop_after_success = set_test_option("STOP_AFTER_SUCCESS", $i);
     $stop_after_failure = set_test_option("STOP_AFTER_FAILURE", $i);
     $stop_test_after = set_test_option("STOP_TEST_AFTER", $i);
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.conf
index 36521c8..98df23c 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -421,6 +421,13 @@
 # (default "login:")
 #SUCCESS_LINE = login:
 
+# Line indicating a failed boot. This is what the line contains, not
+# the entire line. If you need the entire line to match, then use
+# regular expression syntax like with SUCCESS_LINE. This is useful
+# for testing boot issues that don't stop the boot from completing.
+# (default undefined)
+#FAILURE_LINE = WARNING
+
 # In case the console constantly fills the screen, having
 # a specified time to stop the test after success is recommended.
 # (in seconds)
-- 
1.7.4.1

