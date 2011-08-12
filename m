Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab1HLNe1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 09:34:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655Ab1HLNc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 09:32:26 -0400
From: Andrew Jones <drjones@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: drjones@redhat.com, rostedt@goodmis.org
Subject: [PATCH 04/10] ktest: Introduce RESET_TIME
Date: Fri, 12 Aug 2011 15:32:06 +0200
Message-Id: <1313155932-20092-5-git-send-email-drjones@redhat.com>
In-Reply-To: <1313155932-20092-1-git-send-email-drjones@redhat.com>
References: <1313155932-20092-1-git-send-email-drjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When rebooting, some targets may lose their console connection. This
certainly happens with 'virsh console' when used with my xen guests.
Setting RESET_TIME will tell ktest to reconnect the console after
reboot.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/ktest/ktest.pl    |   28 +++++++++++++++++++++++-----
 tools/testing/ktest/sample.conf |    8 ++++++++
 2 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 12c392e..d954564 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -108,6 +108,7 @@ my $monitor_cnt = 0;
 my $sleep_time;
 my $bisect_sleep_time;
 my $patchcheck_sleep_time;
+my $reset_time;
 my $ignore_warnings;
 my $store_failures;
 my $test_name;
@@ -606,6 +607,7 @@ sub run_command;
 sub start_monitor;
 sub end_monitor;
 sub wait_for_monitor;
+sub reset_monitor;
 
 sub reboot {
     my ($time) = @_;
@@ -626,6 +628,7 @@ sub reboot {
 	wait_for_monitor $time;
 	end_monitor;
     }
+    reset_monitor;
 }
 
 sub do_not_reboot {
@@ -685,7 +688,9 @@ sub close_console {
 }
 
 sub start_monitor {
-    if ($monitor_cnt++) {
+    my ($force) = @_;
+
+    if ($monitor_cnt++ && !defined($force)) {
 	return;
     }
     $monitor_fp = \*MONFD;
@@ -697,12 +702,23 @@ sub start_monitor {
 }
 
 sub end_monitor {
-    if (--$monitor_cnt) {
+    my ($force) = @_;
+
+    if (--$monitor_cnt && !defined($force)) {
 	return;
     }
     close_console($monitor_fp, $monitor_pid);
 }
 
+sub reset_monitor {
+    if ($monitor_cnt <= 0 || !defined($reset_time)) {
+	return;
+    }
+    end_monitor 'force';
+    sleep $reset_time;
+    start_monitor 'force';
+}
+
 sub wait_for_monitor {
     my ($time) = @_;
     my $line;
@@ -911,10 +927,11 @@ sub wait_for_input
 sub reboot_to {
     if ($reboot_type eq "grub") {
 	run_ssh "'(echo \"savedefault --default=$grub_number --once\" | grub --batch && reboot)'";
-	return;
+    } else {
+	run_command "$reboot_script";
     }
-
-    run_command "$reboot_script";
+    wait_for_monitor $sleep_time;
+    reset_monitor;
 }
 
 sub get_sha1 {
@@ -2817,6 +2834,7 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
     $sleep_time = set_test_option("SLEEP_TIME", $i);
     $bisect_sleep_time = set_test_option("BISECT_SLEEP_TIME", $i);
     $patchcheck_sleep_time = set_test_option("PATCHCHECK_SLEEP_TIME", $i);
+    $reset_time = set_test_option("RESET_TIME", $i);
     $ignore_warnings = set_test_option("IGNORE_WARNINGS", $i);
     $bisect_manual = set_test_option("BISECT_MANUAL", $i);
     $bisect_skip = set_test_option("BISECT_SKIP", $i);
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.conf
index b8bcd14..23b2fbb 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -491,6 +491,14 @@
 # (default 60)
 #PATCHCHECK_SLEEP_TIME = 60
 
+# If the console needs to be reset during a reboot cycle in
+# order to reestablish it's connection, then set this option
+# to the number of seconds ktest should wait between disconnect
+# and reconnect. This is needed when using 'virsh console' to
+# connect to guests.
+# (default undefined)
+#RESET_TIME = 5
+
 # Reboot the target box on error (default 0)
 #REBOOT_ON_ERROR = 0
 
-- 
1.7.4.1

