Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab1GZB0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 21:26:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63368 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975Ab1GZBYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 21:24:33 -0400
X-Authority-Analysis: v=1.1 cv=s3eDhkhcaTLnj7IEXy8aaXUiY7FbET0mf+/2Xe0elbc= c=1 sm=0 a=vhdKIqpQuCYA:10 a=CCGmx1JjyEYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=ldREUjFaPskXgB4td7kA:9 a=vYz2As05XzRJIwlBf18A:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110726012428.679814765@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 25 Jul 2011 21:22:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 17/19] ktest: Add prompt to use OUTPUT_MIN_CONFIG
References: <20110726012238.271008621@goodmis.org>
Content-Disposition: inline; filename=0017-ktest-Add-prompt-to-use-OUTPUT_MIN_CONFIG.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

If the defined OUTPUT_MIN_CONFIG in the make_min_config test exists,
then give a prompt to ask the user if they want to use that config
instead, as it is very often the case, especially when the test has been
interrupted. The OUTPUT_MIN_CONFIG is usually the config that one wants
to use to continue the test where they left off.

But if START_MIN_CONFIG is defined (thus the MIN_CONFIG is not the
default), then do not prompt, as it will be annoying if the user has
this as one of many tests, and the test pauses waiting for input, while
the user is sleeping.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl    |   70 +++++++++++++++++++++++++++++++--------
 tools/testing/ktest/sample.conf |    3 ++
 2 files changed, 59 insertions(+), 14 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index a9f2e10..cf45f58 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -87,6 +87,7 @@ my $post_install;
 my $noclean;
 my $minconfig;
 my $start_minconfig;
+my $start_minconfig_defined;
 my $output_minconfig;
 my $ignore_config;
 my $addconfig;
@@ -217,6 +218,26 @@ $config_help{"REBOOT_SCRIPT"} = << "EOF"
 EOF
     ;
 
+sub read_yn {
+    my ($prompt) = @_;
+
+    my $ans;
+
+    for (;;) {
+	print "$prompt [Y/n] ";
+	$ans = <STDIN>;
+	chomp $ans;
+	if ($ans =~ /^\s*$/) {
+	    $ans = "y";
+	}
+	last if ($ans =~ /^y$/i || $ans =~ /^n$/i);
+	print "Please answer either 'y' or 'n'.\n";
+    }
+    if ($ans !~ /^y$/i) {
+	return 0;
+    }
+    return 1;
+}
 
 sub get_ktest_config {
     my ($config) = @_;
@@ -2445,10 +2466,23 @@ sub make_min_config {
     if (!defined($output_minconfig)) {
 	fail "OUTPUT_MIN_CONFIG not defined" and return;
     }
+
+    # If output_minconfig exists, and the start_minconfig
+    # came from min_config, than ask if we should use
+    # that instead.
+    if (-f $output_minconfig && !$start_minconfig_defined) {
+	print "$output_minconfig exists\n";
+	if (read_yn " Use it as minconfig?") {
+	    $start_minconfig = $output_minconfig;
+	}
+    }
+
     if (!defined($start_minconfig)) {
 	fail "START_MIN_CONFIG or MIN_CONFIG not defined" and return;
     }
 
+    my $temp_config = "$tmpdir/temp_config";
+
     # First things first. We build an allnoconfig to find
     # out what the defaults are that we can't touch.
     # Some are selections, but we really can't handle selections.
@@ -2581,6 +2615,19 @@ sub make_min_config {
 	    # this config is needed, add it to the ignore list.
 	    $keep_configs{$config} = $min_configs{$config};
 	    delete $min_configs{$config};
+
+	    # update new ignore configs
+	    if (defined($ignore_config)) {
+		open (OUT, ">$temp_config")
+		    or die "Can't write to $temp_config";
+		foreach my $config (keys %keep_configs) {
+		    print OUT "$keep_configs{$config}\n";
+		}
+		close OUT;
+		run_command "mv $temp_config $ignore_config" or
+		    dodie "failed to copy update to $ignore_config";
+	    }
+
 	} else {
 	    # We booted without this config, remove it from the minconfigs.
 	    doprint "$config is not needed, disabling\n";
@@ -2599,8 +2646,8 @@ sub make_min_config {
 	    }
 
 	    # Save off all the current mandidory configs
-	    open (OUT, ">$output_minconfig")
-		or die "Can't write to $output_minconfig";
+	    open (OUT, ">$temp_config")
+		or die "Can't write to $temp_config";
 	    foreach my $config (keys %keep_configs) {
 		print OUT "$keep_configs{$config}\n";
 	    }
@@ -2608,6 +2655,9 @@ sub make_min_config {
 		print OUT "$min_configs{$config}\n";
 	    }
 	    close OUT;
+
+	    run_command "mv $temp_config $output_minconfig" or
+		dodie "failed to copy update to $output_minconfig";
 	}
 
 	doprint "Reboot and wait $sleep_time seconds\n";
@@ -2627,18 +2677,7 @@ if ($#ARGV == 0) {
     $ktest_config = $ARGV[0];
     if (! -f $ktest_config) {
 	print "$ktest_config does not exist.\n";
-	my $ans;
-        for (;;) {
-	    print "Create it? [Y/n] ";
-	    $ans = <STDIN>;
-	    chomp $ans;
-	    if ($ans =~ /^\s*$/) {
-		$ans = "y";
-	    }
-	    last if ($ans =~ /^y$/i || $ans =~ /^n$/i);
-	    print "Please answer either 'y' or 'n'.\n";
-	}
-	if ($ans !~ /^y$/i) {
+	if (!read_yn "Create it?") {
 	    exit 0;
 	}
     }
@@ -2804,7 +2843,10 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
     $target_image = set_test_option("TARGET_IMAGE", $i);
     $localversion = set_test_option("LOCALVERSION", $i);
 
+    $start_minconfig_defined = 1;
+
     if (!defined($start_minconfig)) {
+	$start_minconfig_defined = 0;
 	$start_minconfig = $minconfig;
     }
 
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.conf
index d096a0c..b8bcd14 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -854,6 +854,9 @@
 #   this file as your new min config, and use it to continue the test.
 #   This file does not need to exist on start of test.
 #   This file is not created until a config is found that can be removed.
+#   If this file exists, you will be prompted if you want to use it
+#   as the min_config (overriding MIN_CONFIG) if START_MIN_CONFIG
+#   is not defined.
 #   (required field)
 #
 #  START_MIN_CONFIG is the config to use to start the test with.
-- 
1.7.5.4


