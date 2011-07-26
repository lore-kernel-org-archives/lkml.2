Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab1GZBZK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 21:25:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47975 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab1GZBY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 21:24:26 -0400
X-Authority-Analysis: v=1.1 cv=Pm0sEXe2MdIPK/rOEC7hwDW84D/yDsPO3JtCzsVYOFU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=H2NeYH4CkW0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=8XZI6hfnkMvbB_rqToIA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110726012425.059870904@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 25 Jul 2011 21:22:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 03/19] ktest: Add CONFIG_BISECT_GOOD option
References: <20110726012238.271008621@goodmis.org>
Content-Disposition: inline; filename=0003-ktest-Add-CONFIG_BISECT_GOOD-option.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Currently the config_bisect compares the min config with the
CONFIG_BISECT config. There may be another config that we know
is good that we want to ignore configs on. By passing in this
config it will ignore the options that are set in the good config.

Note: This only ignores the config, it does not (yet) handle
options that are different between the two configs. If the good
config has "SLAB" set and the bad config has "SLUB" it will not
find the bug if the bug had to do with changing these two options.

This is something that I intend to implement in the future.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl    |    6 ++++++
 tools/testing/ktest/sample.conf |   19 ++++++++++++-------
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index a8e1826..dbc02de 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -88,6 +88,7 @@ my $bisect_bad = "";
 my $reverse_bisect;
 my $bisect_manual;
 my $bisect_skip;
+my $config_bisect_good;
 my $in_patchcheck = 0;
 my $run_test;
 my $redirect;
@@ -1745,6 +1746,10 @@ sub config_bisect {
 
     my $tmpconfig = "$tmpdir/use_config";
 
+    if (defined($config_bisect_good)) {
+	process_config_ignore $config_bisect_good;
+    }
+
     # Make the file with the bad config and the min config
     if (defined($minconfig)) {
 	# read the min config for things to ignore
@@ -2174,6 +2179,7 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
     $patchcheck_sleep_time = set_test_option("PATCHCHECK_SLEEP_TIME", $i);
     $bisect_manual = set_test_option("BISECT_MANUAL", $i);
     $bisect_skip = set_test_option("BISECT_SKIP", $i);
+    $config_bisect_good = set_test_option("CONFIG_BISECT_GOOD", $i);
     $store_failures = set_test_option("STORE_FAILURES", $i);
     $timeout = set_test_option("TIMEOUT", $i);
     $booted_timeout = set_test_option("BOOTED_TIMEOUT", $i);
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.conf
index c2c072e..be531c2 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -749,13 +749,18 @@
 #	boot	- bad builds but fails to boot
 #	test	- bad boots but fails a test
 #
-#   CONFIG_BISECT is the config that failed to boot
-#
-#   If BISECT_MANUAL is set, it will pause between iterations.
-#   This is useful to use just ktest.pl just for the config bisect.
-#   If you set it to build, it will run the bisect and you can
-#   control what happens in between iterations. It will ask you if
-#   the test succeeded or not and continue the config bisect.
+#  CONFIG_BISECT is the config that failed to boot
+#
+#  If BISECT_MANUAL is set, it will pause between iterations.
+#  This is useful to use just ktest.pl just for the config bisect.
+#  If you set it to build, it will run the bisect and you can
+#  control what happens in between iterations. It will ask you if
+#  the test succeeded or not and continue the config bisect.
+#
+# CONFIG_BISECT_GOOD (optional)
+#  If you have a good config to start with, then you
+#  can specify it with CONFIG_BISECT_GOOD. Otherwise
+#  the MIN_CONFIG is the base.
 #
 # Example:
 #   TEST_START
-- 
1.7.5.4


