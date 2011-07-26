Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291Ab1GZB0h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 21:26:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48006 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004Ab1GZBYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 21:24:34 -0400
X-Authority-Analysis: v=1.1 cv=Pm0sEXe2MdIPK/rOEC7hwDW84D/yDsPO3JtCzsVYOFU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=f2KTFbI185IA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=BKzKR_3JWOd3TP60N2oA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110726012427.428483303@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 25 Jul 2011 21:22:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 12/19] ktest: Add IGNORE_WARNINGS to ignore warnings in some patches
References: <20110726012238.271008621@goodmis.org>
Content-Disposition: inline; filename=0012-ktest-Add-IGNORE_WARNINGS-to-ignore-warnings-in-some.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Doing a patchcheck test, there may be warnings that gcc produces which
may be OK, and the test should not fail on that commit. By adding a
IGNORE_WARNINGS option to list a space delimited SHA1s that are ignored
lets the user avoid having the test fail on certain commits.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl    |   14 +++++++++++++-
 tools/testing/ktest/sample.conf |    8 +++++++-
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 5b35fa0..5924f14 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -104,6 +104,7 @@ my $monitor_cnt = 0;
 my $sleep_time;
 my $bisect_sleep_time;
 my $patchcheck_sleep_time;
+my $ignore_warnings;
 my $store_failures;
 my $test_name;
 my $timeout;
@@ -2074,6 +2075,13 @@ sub patchcheck {
     @list = reverse @list;
 
     my $save_clean = $noclean;
+    my %ignored_warnings;
+
+    if (defined($ignore_warnings)) {
+	foreach my $sha1 (split /\s+/, $ignore_warnings) {
+	    $ignored_warnings{$sha1} = 1;
+	}
+    }
 
     $in_patchcheck = 1;
     foreach my $item (@list) {
@@ -2100,7 +2108,10 @@ sub patchcheck {
 	    build "oldconfig" or return 0;
 	}
 
-	check_buildlog $sha1 or return 0;
+
+	if (!defined($ignored_warnings{$sha1})) {
+	    check_buildlog $sha1 or return 0;
+	}
 
 	next if ($type eq "build");
 
@@ -2288,6 +2299,7 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
     $sleep_time = set_test_option("SLEEP_TIME", $i);
     $bisect_sleep_time = set_test_option("BISECT_SLEEP_TIME", $i);
     $patchcheck_sleep_time = set_test_option("PATCHCHECK_SLEEP_TIME", $i);
+    $ignore_warnings = set_test_option("IGNORE_WARNINGS", $i);
     $bisect_manual = set_test_option("BISECT_MANUAL", $i);
     $bisect_skip = set_test_option("BISECT_SKIP", $i);
     $config_bisect_good = set_test_option("CONFIG_BISECT_GOOD", $i);
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.conf
index e2d8d83..82c966c 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -604,7 +604,12 @@
 #      build, boot, test.
 #
 #   Note, the build test will look for warnings, if a warning occurred
-#     in a file that a commit touches, the build will fail.
+#     in a file that a commit touches, the build will fail, unless
+#     IGNORE_WARNINGS is set for the given commit's sha1
+#
+#   IGNORE_WARNINGS can be used to disable the failure of patchcheck
+#     on a particuler commit (SHA1). You can add more than one commit
+#     by adding a list of SHA1s that are space delimited.
 #
 #   If BUILD_NOCLEAN is set, then make mrproper will not be run on
 #   any of the builds, just like all other TEST_TYPE tests. But
@@ -619,6 +624,7 @@
 #   PATCHCHECK_TYPE = boot
 #   PATCHCHECK_START = 747e94ae3d1b4c9bf5380e569f614eb9040b79e7
 #   PATCHCHECK_END = HEAD~2
+#   IGNORE_WARNINGS = 42f9c6b69b54946ffc0515f57d01dc7f5c0e4712 0c17ca2c7187f431d8ffc79e81addc730f33d128
 #
 #
 #
-- 
1.7.5.4


