Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab1HLNci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 09:32:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793Ab1HLNcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 09:32:31 -0400
From: Andrew Jones <drjones@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: drjones@redhat.com, rostedt@goodmis.org
Subject: [PATCH 08/10] ktest: test faster, put REBOOT_ON_SUCCESS to more work
Date: Fri, 12 Aug 2011 15:32:10 +0200
Message-Id: <1313155932-20092-9-git-send-email-drjones@redhat.com>
In-Reply-To: <1313155932-20092-1-git-send-email-drjones@redhat.com>
References: <1313155932-20092-1-git-send-email-drjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the user to decide if it's necessary to reboot after each
successful test or not. If a successfully booted target supports
installation of another kernel, then we might as well save the
time to reboot (which may be long on some systems) to a known-good
kernel. We already have REBOOT_ON_SUCCESS, which defaults to true,
and was underutilized. It only controlled the rebooting of the
target after all testing completed successfully. Now, if the user
sets this to false, we assume that rebooting isn't necessary at
any stage of the testing, assuming the tests are successful. The
option is now also a per-test config option, so the top-level,
default behavior may remain the same.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/ktest/ktest.pl    |    8 +++++---
 tools/testing/ktest/sample.conf |    1 -
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 38c4532..719df19 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -74,6 +74,7 @@ my $reboot_script;
 my $power_cycle;
 my $reboot;
 my $reboot_on_error;
+my $reboot_on_success;
 my $poweroff_on_error;
 my $die_on_failure;
 my $powercycle_after_reboot;
@@ -1383,7 +1384,7 @@ sub success {
     doprint     "*******************************************\n";
     doprint     "*******************************************\n";
 
-    if ($i != $opt{"NUM_TESTS"} && !do_not_reboot) {
+    if ($i != $opt{"NUM_TESTS"} && !do_not_reboot && $reboot_on_success) {
 	doprint "Reboot and wait $sleep_time seconds\n";
 	reboot $sleep_time;
     }
@@ -1585,7 +1586,7 @@ sub run_bisect_test {
 
     # reboot the box to a kernel we can ssh to
     if ($type ne "build") {
-	bisect_reboot;
+	bisect_reboot if ($result == 0 || $reboot_on_success);
     }
     $in_bisect = 0;
 
@@ -2191,7 +2192,7 @@ sub patchcheck {
 
 	do_test($type) or return 0;
 
-	patchcheck_reboot;
+	patchcheck_reboot if ($reboot_on_success);
     }
     $in_patchcheck = 0;
     success $i;
@@ -2834,6 +2835,7 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
     $post_install = set_test_option("POST_INSTALL", $i);
     $reboot_script = set_test_option("REBOOT_SCRIPT", $i);
     $reboot_on_error = set_test_option("REBOOT_ON_ERROR", $i);
+    $reboot_on_success = set_test_option("REBOOT_ON_SUCCESS", $i);
     $poweroff_on_error = set_test_option("POWEROFF_ON_ERROR", $i);
     $die_on_failure = set_test_option("DIE_ON_FAILURE", $i);
     $power_off = set_test_option("POWER_OFF", $i);
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.conf
index fe7630a..36521c8 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -11,7 +11,6 @@
 #  LOG_FILE
 #  CLEAR_LOG
 #  POWEROFF_ON_SUCCESS
-#  REBOOT_ON_SUCCESS
 #
 # Test specific options are set after the label:
 #
-- 
1.7.4.1

