Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab1EWNyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 09:54:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53155 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505Ab1EWNxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 09:53:16 -0400
X-Authority-Analysis: v=1.1 cv=ou1QuR4lBR9YeJgEH9ccYmbAdaWqVVq3lOvCKJtMpGM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=_RRW9DzEg2QA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=FytXeRmdpJLRMkgMge8A:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110523135315.190161723@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 23 May 2011 09:51:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4/6] ktest: Reboot after each patchcheck run
References: <20110523135120.309567301@goodmis.org>
Content-Disposition: inline; filename=0004-ktest-Reboot-after-each-patchcheck-run.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The patches being checked may not leave the kernel in a state
that the next run will allow the new kernel to be copied to the
machine. Reboot to a known good kernel before continuing to the
next kernel to test.

Added option PATCHCHECK_SLEEP_TIME for the max time to sleep between
patchcheck reboots.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl    |   13 +++++++++++++
 tools/testing/ktest/sample.conf |    4 ++++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 2011222..65003a1 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -36,6 +36,7 @@ $default{"REBOOT_ON_SUCCESS"}	= 1;
 $default{"POWEROFF_ON_SUCCESS"}	= 0;
 $default{"BUILD_OPTIONS"}	= "";
 $default{"BISECT_SLEEP_TIME"}	= 60;   # sleep time between bisects
+$default{"PATCHCHECK_SLEEP_TIME"} = 60; # sleep time between patch checks
 $default{"CLEAR_LOG"}		= 0;
 $default{"BISECT_MANUAL"}	= 0;
 $default{"BISECT_SKIP"}		= 1;
@@ -96,6 +97,7 @@ my $monitor_pid;
 my $monitor_cnt = 0;
 my $sleep_time;
 my $bisect_sleep_time;
+my $patchcheck_sleep_time;
 my $store_failures;
 my $timeout;
 my $booted_timeout;
@@ -1764,6 +1766,14 @@ sub config_bisect {
     success $i;
 }
 
+sub patchcheck_reboot {
+    doprint "Reboot and sleep $patchcheck_sleep_time seconds\n";
+    reboot;
+    start_monitor;
+    wait_for_monitor $patchcheck_sleep_time;
+    end_monitor;
+}
+
 sub patchcheck {
     my ($i) = @_;
 
@@ -1855,6 +1865,8 @@ sub patchcheck {
 	end_monitor;
 	return 0 if ($failed);
 
+	patchcheck_reboot;
+
     }
     $in_patchcheck = 0;
     success $i;
@@ -2004,6 +2016,7 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
     $poweroff_after_halt = set_test_option("POWEROFF_AFTER_HALT", $i);
     $sleep_time = set_test_option("SLEEP_TIME", $i);
     $bisect_sleep_time = set_test_option("BISECT_SLEEP_TIME", $i);
+    $patchcheck_sleep_time = set_test_option("PATCHCHECK_SLEEP_TIME", $i);
     $bisect_manual = set_test_option("BISECT_MANUAL", $i);
     $bisect_skip = set_test_option("BISECT_SKIP", $i);
     $store_failures = set_test_option("STORE_FAILURES", $i);
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.conf
index 4c5d6bd..87bf92a 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -366,6 +366,10 @@
 # (default 60)
 #BISECT_SLEEP_TIME = 60
 
+# The time in between patch checks to sleep (in seconds)
+# (default 60)
+#PATCHCHECK_SLEEP_TIME = 60
+
 # Reboot the target box on error (default 0)
 #REBOOT_ON_ERROR = 0
 
-- 
1.7.4.4


