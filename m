Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab1GZB0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 21:26:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33288 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab1GZBYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 21:24:35 -0400
X-Authority-Analysis: v=1.1 cv=sbbt6Wn8j+VvNVI1Ftt/uHhinWyuFt+R57MN9Ty2Tys= c=1 sm=0 a=vhdKIqpQuCYA:10 a=oHhQ7b2FRNAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=iQrS6CaZQkZ67G2ASmAA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110726012427.670574619@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 25 Jul 2011 21:22:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 13/19] ktest: Add helper function to avoid duplicate code
References: <20110726012238.271008621@goodmis.org>
Content-Disposition: inline; filename=0013-ktest-Add-helper-function-to-avoid-duplicate-code.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Several places had the following code:

    get_grub_index;
    get_version;
    install;

    start_monitor;
    return monitor;

Creating a function "start_monitor_and_boot()" replaces these mulitple
uses with a single call.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |   46 ++++++++++++++++++-----------------------
 1 files changed, 20 insertions(+), 26 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 5924f14..099ceee 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1096,6 +1096,23 @@ sub install {
     do_post_install;
 }
 
+sub get_version {
+    # get the release name
+    doprint "$make kernelrelease ... ";
+    $version = `$make kernelrelease | tail -1`;
+    chomp($version);
+    doprint "$version\n";
+}
+
+sub start_monitor_and_boot {
+    get_grub_index;
+    get_version;
+    install;
+
+    start_monitor;
+    return monitor;
+}
+
 sub check_buildlog {
     my ($patch) = @_;
 
@@ -1307,14 +1324,6 @@ sub success {
     }
 }
 
-sub get_version {
-    # get the release name
-    doprint "$make kernelrelease ... ";
-    $version = `$make kernelrelease | tail -1`;
-    chomp($version);
-    doprint "$version\n";
-}
-
 sub answer_bisect {
     for (;;) {
 	doprint "Pass or fail? [p/f]";
@@ -1479,12 +1488,7 @@ sub run_bisect_test {
 	dodie "Failed on build" if $failed;
 
 	# Now boot the box
-	get_grub_index;
-	get_version;
-	install;
-
-	start_monitor;
-	monitor or $failed = 1;
+	start_monitor_and_boot or $failed = 1;
 
 	if ($type ne "boot") {
 	    if ($failed && $bisect_skip) {
@@ -2115,14 +2119,9 @@ sub patchcheck {
 
 	next if ($type eq "build");
 
-	get_grub_index;
-	get_version;
-	install;
-
 	my $failed = 0;
 
-	start_monitor;
-	monitor or $failed = 1;
+	start_monitor_and_boot or $failed = 1;
 
 	if (!$failed && $type ne "boot"){
 	    do_run_test or $failed = 1;
@@ -2393,13 +2392,8 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
     }
 
     if ($test_type ne "build") {
-	get_grub_index;
-	get_version;
-	install;
-
 	my $failed = 0;
-	start_monitor;
-	monitor or $failed = 1;;
+	start_monitor_and_boot or $failed = 1;
 
 	if (!$failed && $test_type ne "boot" && defined($run_test)) {
 	    do_run_test or $failed = 1;
-- 
1.7.5.4


