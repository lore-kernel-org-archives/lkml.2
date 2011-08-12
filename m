Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab1HLNc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 09:32:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51057 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643Ab1HLNcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 09:32:24 -0400
From: Andrew Jones <drjones@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: drjones@redhat.com, rostedt@goodmis.org
Subject: [PATCH 03/10] ktest: factor reboot code
Date: Fri, 12 Aug 2011 15:32:05 +0200
Message-Id: <1313155932-20092-4-git-send-email-drjones@redhat.com>
In-Reply-To: <1313155932-20092-1-git-send-email-drjones@redhat.com>
References: <1313155932-20092-1-git-send-email-drjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clean up redundant code and prepare for reset time patch

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/ktest/ktest.pl |   36 ++++++++++++++++--------------------
 1 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index f1358c5..12c392e 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -603,8 +603,13 @@ sub doprint {
 }
 
 sub run_command;
+sub start_monitor;
+sub end_monitor;
+sub wait_for_monitor;
 
 sub reboot {
+    my ($time) = @_;
+
     # try to reboot normally
     if (run_command $reboot) {
 	if (defined($powercycle_after_reboot)) {
@@ -615,6 +620,12 @@ sub reboot {
 	# nope? power cycle it.
 	run_command "$power_cycle";
     }
+
+    if (defined($time)) {
+	start_monitor;
+	wait_for_monitor $time;
+	end_monitor;
+    }
 }
 
 sub do_not_reboot {
@@ -719,10 +730,7 @@ sub fail {
 	# no need to reboot for just building.
 	if (!do_not_reboot) {
 	    doprint "REBOOTING\n";
-	    reboot;
-	    start_monitor;
-	    wait_for_monitor $sleep_time;
-	    end_monitor;
+	    reboot $sleep_time;
 	}
 
 	my $name = "";
@@ -1356,10 +1364,7 @@ sub success {
 
     if ($i != $opt{"NUM_TESTS"} && !do_not_reboot) {
 	doprint "Reboot and wait $sleep_time seconds\n";
-	reboot;
-	start_monitor;
-	wait_for_monitor $sleep_time;
-	end_monitor;
+	reboot $sleep_time;
     }
 }
 
@@ -1500,10 +1505,7 @@ sub run_git_bisect {
 
 sub bisect_reboot {
     doprint "Reboot and sleep $bisect_sleep_time seconds\n";
-    reboot;
-    start_monitor;
-    wait_for_monitor $bisect_sleep_time;
-    end_monitor;
+    reboot $bisect_sleep_time;
 }
 
 # returns 1 on success, 0 on failure, -1 on skip
@@ -2066,10 +2068,7 @@ sub config_bisect {
 
 sub patchcheck_reboot {
     doprint "Reboot and sleep $patchcheck_sleep_time seconds\n";
-    reboot;
-    start_monitor;
-    wait_for_monitor $patchcheck_sleep_time;
-    end_monitor;
+    reboot $patchcheck_sleep_time;
 }
 
 sub patchcheck {
@@ -2659,10 +2658,7 @@ sub make_min_config {
 	}
 
 	doprint "Reboot and wait $sleep_time seconds\n";
-	reboot;
-	start_monitor;
-	wait_for_monitor $sleep_time;
-	end_monitor;
+	reboot $sleep_time;
     }
 
     success $i;
-- 
1.7.4.1

