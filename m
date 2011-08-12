Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab1HLNeL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 09:34:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667Ab1HLNc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 09:32:27 -0400
From: Andrew Jones <drjones@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: drjones@redhat.com, rostedt@goodmis.org
Subject: [PATCH 05/10] ktest: refactor monitor/boot/test code
Date: Fri, 12 Aug 2011 15:32:07 +0200
Message-Id: <1313155932-20092-6-git-send-email-drjones@redhat.com>
In-Reply-To: <1313155932-20092-1-git-send-email-drjones@redhat.com>
References: <1313155932-20092-1-git-send-email-drjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The monitor/boot code was already refactored, but we need to pull the
test part of the monitor/boot/test code sequences in as well to prepare for
the next patch.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/ktest/ktest.pl |   60 +++++++++++++++++------------------------
 1 files changed, 25 insertions(+), 35 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index d954564..a42f8bf 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1490,6 +1490,24 @@ sub do_run_test {
     return 1;
 }
 
+sub do_test {
+    my ($type) = @_;
+    my $failed = 0;
+
+    start_monitor_and_boot or $failed = 1;
+
+    if ($failed && $in_bisect && $type ne "boot") {
+	end_monitor;
+	return -1;
+    }
+
+    if (!$failed && $type ne "boot" && defined($run_test)) {
+	do_run_test or $failed = 1;
+    }
+    end_monitor;
+    return !$failed;
+}
+
 sub run_git_bisect {
     my ($command) = @_;
 
@@ -1531,8 +1549,6 @@ sub run_bisect_test {
 
     my $failed = 0;
     my $result;
-    my $output;
-    my $ret;
 
     $in_bisect = 1;
 
@@ -1545,27 +1561,17 @@ sub run_bisect_test {
 	}
 	dodie "Failed on build" if $failed;
 
-	# Now boot the box
-	start_monitor_and_boot or $failed = 1;
+	# Now boot the box and test
+	$result = do_test($type);
 
-	if ($type ne "boot") {
-	    if ($failed && $bisect_skip) {
-		end_monitor;
+	if ($result == -1) {
+	    if ($bisect_skip) {
 		bisect_reboot;
 		$in_bisect = 0;
 		return -1;
 	    }
-	    dodie "Failed on boot" if $failed;
-
-	    do_run_test or $failed = 1;
+	    dodie "Failed on boot";
 	}
-	end_monitor;
-    }
-
-    if ($failed) {
-	$result = 0;
-    } else {
-	$result = 1;
     }
 
     # reboot the box to a kernel we can ssh to
@@ -2174,18 +2180,9 @@ sub patchcheck {
 
 	next if ($type eq "build");
 
-	my $failed = 0;
-
-	start_monitor_and_boot or $failed = 1;
-
-	if (!$failed && $type ne "boot"){
-	    do_run_test or $failed = 1;
-	}
-	end_monitor;
-	return 0 if ($failed);
+	do_test($type) or return 0;
 
 	patchcheck_reboot;
-
     }
     $in_patchcheck = 0;
     success $i;
@@ -2946,14 +2943,7 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
     }
 
     if ($test_type ne "build") {
-	my $failed = 0;
-	start_monitor_and_boot or $failed = 1;
-
-	if (!$failed && $test_type ne "boot" && defined($run_test)) {
-	    do_run_test or $failed = 1;
-	}
-	end_monitor;
-	next if ($failed);
+	do_test($test_type) or next;
     }
 
     success $i;
-- 
1.7.4.1

