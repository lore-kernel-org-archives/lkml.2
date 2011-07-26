Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab1GZB2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 21:28:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63368 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab1GZBY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 21:24:28 -0400
X-Authority-Analysis: v=1.1 cv=s3eDhkhcaTLnj7IEXy8aaXUiY7FbET0mf+/2Xe0elbc= c=1 sm=0 a=vhdKIqpQuCYA:10 a=f2MLOjB5aUMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=vOYlCKayjhgtVMNEyC8A:9 a=aJHzFVS8d_KJ-r0XhMYA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110726012426.629689308@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 25 Jul 2011 21:22:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 09/19] ktest: Add POST/PRE_BUILD options
References: <20110726012238.271008621@goodmis.org>
Content-Disposition: inline; filename=0009-ktest-Add-POST-PRE_BUILD-options.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

There are some cases that a patch may be needed to apply to the kernel
in patchcheck or bisect tests. Adding a PRE_BUILD option to apply the
patch and POST_BUILD to remove it, allows for this to be done easily.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl    |   31 ++++++++++++++++++++++++++++---
 tools/testing/ktest/sample.conf |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+), 3 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index fb46e12..d0e1de6 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -63,6 +63,10 @@ my $output_config;
 my $test_type;
 my $build_type;
 my $build_options;
+my $pre_build;
+my $post_build;
+my $pre_build_die;
+my $post_build_die;
 my $reboot_type;
 my $reboot_script;
 my $power_cycle;
@@ -1189,6 +1193,14 @@ sub build {
 
     unlink $buildlog;
 
+    if (defined($pre_build)) {
+	my $ret = run_command $pre_build;
+	if (!$ret && defined($pre_build_die) &&
+	    $pre_build_die) {
+	    dodie "failed to pre_build\n";
+	}
+    }
+
     if ($type =~ /^useconfig:(.*)/) {
 	run_command "cp $1 $output_config" or
 	    dodie "could not copy $1 to .config";
@@ -1236,13 +1248,22 @@ sub build {
     make_oldconfig;
 
     $redirect = "$buildlog";
-    if (!run_command "$make $build_options") {
-	undef $redirect;
+    my $build_ret = run_command "$make $build_options";
+    undef $redirect;
+
+    if (defined($post_build)) {
+	my $ret = run_command $post_build;
+	if (!$ret && defined($post_build_die) &&
+	    $post_build_die) {
+	    dodie "failed to post_build\n";
+	}
+    }
+
+    if (!$build_ret) {
 	# bisect may need this to pass
 	return 0 if ($in_bisect);
 	fail "failed build" and return 0;
     }
-    undef $redirect;
 
     return 1;
 }
@@ -2244,6 +2265,10 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
     $test_type = set_test_option("TEST_TYPE", $i);
     $build_type = set_test_option("BUILD_TYPE", $i);
     $build_options = set_test_option("BUILD_OPTIONS", $i);
+    $pre_build = set_test_option("PRE_BUILD", $i);
+    $post_build = set_test_option("POST_BUILD", $i);
+    $pre_build_die = set_test_option("PRE_BUILD_DIE", $i);
+    $post_build_die = set_test_option("POST_BUILD_DIE", $i);
     $power_cycle = set_test_option("POWER_CYCLE", $i);
     $reboot = set_test_option("REBOOT", $i);
     $noclean = set_test_option("BUILD_NOCLEAN", $i);
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.conf
index 0e5f764..1092e47 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -293,6 +293,38 @@
 # or on some systems:
 #POST_INSTALL = ssh user@target /sbin/dracut -f /boot/initramfs-test.img $KERNEL_VERSION
 
+# If there is a script that you require to run before the build is done
+# you can specify it with PRE_BUILD.
+#
+# One example may be if you must add a temporary patch to the build to
+# fix a unrelated bug to perform a patchcheck test. This will apply the
+# patch before each build that is made. Use the POST_BUILD to do a git reset --hard
+# to remove the patch.
+#
+# (default undef)
+#PRE_BUILD = cd ${BUILD_DIR} && patch -p1 < /tmp/temp.patch
+
+# To specify if the test should fail if the PRE_BUILD fails,
+# PRE_BUILD_DIE needs to be set to 1. Otherwise the PRE_BUILD
+# result is ignored.
+# (default 0)
+# PRE_BUILD_DIE = 1
+
+# If there is a script that should run after the build is done
+# you can specify it with POST_BUILD.
+#
+# As the example in PRE_BUILD, POST_BUILD can be used to reset modifications
+# made by the PRE_BUILD.
+#
+# (default undef)
+#POST_BUILD = cd ${BUILD_DIR} && git reset --hard
+
+# To specify if the test should fail if the POST_BUILD fails,
+# POST_BUILD_DIE needs to be set to 1. Otherwise the POST_BUILD
+# result is ignored.
+# (default 0)
+#POST_BUILD_DIE = 1
+
 # Way to reboot the box to the test kernel.
 # Only valid options so far are "grub" and "script"
 # (default grub)
-- 
1.7.5.4


