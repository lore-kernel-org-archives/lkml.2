Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab1GZB0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 21:26:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33228 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab1GZBYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 21:24:38 -0400
X-Authority-Analysis: v=1.1 cv=sbbt6Wn8j+VvNVI1Ftt/uHhinWyuFt+R57MN9Ty2Tys= c=1 sm=0 a=vhdKIqpQuCYA:10 a=WjivLzurx_4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=Wpen7k2RsFqHxqFA_YYA:9 a=5DX8hEAMPtuBEpnHCaYA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=F8-WUSYpUrPJDKp5:21 a=JUM3XJj_nw9kb0uK:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110726012428.163878581@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 25 Jul 2011 21:22:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 15/19] ktest: Add test type make_min_config
References: <20110726012238.271008621@goodmis.org>
Content-Disposition: inline; filename=0015-ktest-Add-test-type-make_min_config.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

After doing a make localyesconfig, your kernel configuration may
not be the most useful minimum configuration. Having a true minimum
config that you can use against other configs is very useful if
someone else has a config that breaks on your code. By only forcing
those configurations that are truly required to boot your machine
will give you less of a chance that one of your set configurations
will make the bug go away. This will give you a better chance to
be able to reproduce the reported bug matching the broken config.

Note, this does take some time, and may require you to run the
test over night, or perhaps over the weekend. But it also allows
you to interrupt it, and gives you the current minimum config
that was found till that time.

Note, this test automatically assumes a BUILD_TYPE of oldconfig
and its test type acts like boot.

TODO: add a test version that makes the config do more than just
      boot, like having network access.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl    |  255 ++++++++++++++++++++++++++++++++++++++-
 tools/testing/ktest/sample.conf |   50 ++++++++
 2 files changed, 301 insertions(+), 4 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 6166f3a..5323c6f 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -86,6 +86,9 @@ my $make;
 my $post_install;
 my $noclean;
 my $minconfig;
+my $start_minconfig;
+my $output_minconfig;
+my $ignore_config;
 my $addconfig;
 my $in_bisect = 0;
 my $bisect_bad = "";
@@ -1189,7 +1192,11 @@ sub apply_min_config {
 
 sub make_oldconfig {
 
-    apply_min_config;
+    my @force_list = keys %force_config;
+
+    if ($#force_list >= 0) {
+	apply_min_config;
+    }
 
     if (!run_command "$make oldnoconfig") {
 	# Perhaps oldnoconfig doesn't exist in this version of the kernel
@@ -1678,21 +1685,27 @@ my %null_config;
 
 my %dependency;
 
-sub process_config_ignore {
-    my ($config) = @_;
+sub assign_configs {
+    my ($hash, $config) = @_;
 
     open (IN, $config)
 	or dodie "Failed to read $config";
 
     while (<IN>) {
 	if (/^((CONFIG\S*)=.*)/) {
-	    $config_ignore{$2} = $1;
+	    ${$hash}{$2} = $1;
 	}
     }
 
     close(IN);
 }
 
+sub process_config_ignore {
+    my ($config) = @_;
+
+    assign_configs \%config_ignore, $config;
+}
+
 sub read_current_config {
     my ($config_ref) = @_;
 
@@ -2149,6 +2162,226 @@ sub patchcheck {
     return 1;
 }
 
+sub read_config_list {
+    my ($config) = @_;
+
+    open (IN, $config)
+	or dodie "Failed to read $config";
+
+    while (<IN>) {
+	if (/^((CONFIG\S*)=.*)/) {
+	    if (!defined($config_ignore{$2})) {
+		$config_list{$2} = $1;
+	    }
+	}
+    }
+
+    close(IN);
+}
+
+sub read_output_config {
+    my ($config) = @_;
+
+    assign_configs \%config_ignore, $config;
+}
+
+sub make_new_config {
+    my @configs = @_;
+
+    open (OUT, ">$output_config")
+	or dodie "Failed to write $output_config";
+
+    foreach my $config (@configs) {
+	print OUT "$config\n";
+    }
+    close OUT;
+}
+
+sub make_min_config {
+    my ($i) = @_;
+
+    if (!defined($output_minconfig)) {
+	fail "OUTPUT_MIN_CONFIG not defined" and return;
+    }
+    if (!defined($start_minconfig)) {
+	fail "START_MIN_CONFIG or MIN_CONFIG not defined" and return;
+    }
+
+    # First things first. We build an allnoconfig to find
+    # out what the defaults are that we can't touch.
+    # Some are selections, but we really can't handle selections.
+
+    my $save_minconfig = $minconfig;
+    undef $minconfig;
+
+    run_command "$make allnoconfig" or return 0;
+
+    process_config_ignore $output_config;
+    my %keep_configs;
+
+    if (defined($ignore_config)) {
+	# make sure the file exists
+	`touch $ignore_config`;
+	assign_configs \%keep_configs, $ignore_config;
+    }
+
+    doprint "Load initial configs from $start_minconfig\n";
+
+    # Look at the current min configs, and save off all the
+    # ones that were set via the allnoconfig
+    my %min_configs;
+    assign_configs \%min_configs, $start_minconfig;
+
+    my @config_keys = keys %min_configs;
+
+    # Remove anything that was set by the make allnoconfig
+    # we shouldn't need them as they get set for us anyway.
+    foreach my $config (@config_keys) {
+	# Remove anything in the ignore_config
+	if (defined($keep_configs{$config})) {
+	    my $file = $ignore_config;
+	    $file =~ s,.*/(.*?)$,$1,;
+	    doprint "$config set by $file ... ignored\n";
+	    delete $min_configs{$config};
+	    next;
+	}
+	# But make sure the settings are the same. If a min config
+	# sets a selection, we do not want to get rid of it if
+	# it is not the same as what we have. Just move it into
+	# the keep configs.
+	if (defined($config_ignore{$config})) {
+	    if ($config_ignore{$config} ne $min_configs{$config}) {
+		doprint "$config is in allnoconfig as '$config_ignore{$config}'";
+		doprint " but it is '$min_configs{$config}' in minconfig .. keeping\n";
+		$keep_configs{$config} = $min_configs{$config};
+	    } else {
+		doprint "$config set by allnoconfig ... ignored\n";
+	    }
+	    delete $min_configs{$config};
+	}
+    }
+
+    my %nochange_config;
+
+    my $done = 0;
+
+    while (!$done) {
+
+	my $config;
+	my $found;
+
+	# Now disable each config one by one and do a make oldconfig
+	# till we find a config that changes our list.
+
+	# Put configs that did not modify the config at the end.
+	my @test_configs = keys %min_configs;
+	my $reset = 1;
+	for (my $i = 0; $i < $#test_configs; $i++) {
+	    if (!defined($nochange_config{$test_configs[0]})) {
+		$reset = 0;
+		last;
+	    }
+	    # This config didn't change the .config last time.
+	    # Place it at the end
+	    my $config = shift @test_configs;
+	    push @test_configs, $config;
+	}
+
+	# if every test config has failed to modify the .config file
+	# in the past, then reset and start over.
+	if ($reset) {
+	    undef %nochange_config;
+	}
+
+	foreach my $config (@test_configs) {
+
+	    # Remove this config from the list of configs
+	    # do a make oldnoconfig and then read the resulting
+	    # .config to make sure it is missing the config that
+	    # we had before
+	    my %configs = %min_configs;
+	    delete $configs{$config};
+	    make_new_config ((values %configs), (values %keep_configs));
+	    make_oldconfig;
+	    undef %configs;
+	    assign_configs \%configs, $output_config;
+
+	    if (!defined($configs{$config})) {
+		$found = $config;
+		last;
+	    }
+
+	    doprint "disabling config $config did not change .config\n";
+
+	    # oh well, try another config
+	    $nochange_config{$config} = 1;
+	}
+
+	if (!defined($found)) {
+	    doprint "No more configs found that we can disable\n";
+	    $done = 1;
+	    last;
+	}
+
+	$config = $found;
+
+	doprint "Test with $config disabled\n";
+
+	# set in_bisect to keep build and monitor from dieing
+	$in_bisect = 1;
+
+	my $failed = 0;
+	build "oldconfig";
+	start_monitor_and_boot or $failed = 1;
+	end_monitor;
+
+	$in_bisect = 0;
+
+	if ($failed) {
+	    doprint "$config is needed to boot the box... keeping\n";
+	    # this config is needed, add it to the ignore list.
+	    $keep_configs{$config} = $min_configs{$config};
+	    delete $min_configs{$config};
+	} else {
+	    # We booted without this config, remove it from the minconfigs.
+	    doprint "$config is not needed, disabling\n";
+
+	    delete $min_configs{$config};
+
+	    # Also disable anything that is not enabled in this config
+	    my %configs;
+	    assign_configs \%configs, $output_config;
+	    my @config_keys = keys %min_configs;
+	    foreach my $config (@config_keys) {
+		if (!defined($configs{$config})) {
+		    doprint "$config is not set, disabling\n";
+		    delete $min_configs{$config};
+		}
+	    }
+
+	    # Save off all the current mandidory configs
+	    open (OUT, ">$output_minconfig")
+		or die "Can't write to $output_minconfig";
+	    foreach my $config (keys %keep_configs) {
+		print OUT "$keep_configs{$config}\n";
+	    }
+	    foreach my $config (keys %min_configs) {
+		print OUT "$min_configs{$config}\n";
+	    }
+	    close OUT;
+	}
+
+	doprint "Reboot and wait $sleep_time seconds\n";
+	reboot;
+	start_monitor;
+	wait_for_monitor $sleep_time;
+	end_monitor;
+    }
+
+    success $i;
+    return 1;
+}
+
 $#ARGV < 1 or die "ktest.pl version: $VERSION\n   usage: ktest.pl config-file\n";
 
 if ($#ARGV == 0) {
@@ -2294,6 +2527,9 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
     $reboot = set_test_option("REBOOT", $i);
     $noclean = set_test_option("BUILD_NOCLEAN", $i);
     $minconfig = set_test_option("MIN_CONFIG", $i);
+    $output_minconfig = set_test_option("OUTPUT_MIN_CONFIG", $i);
+    $start_minconfig = set_test_option("START_MIN_CONFIG", $i);
+    $ignore_config = set_test_option("IGNORE_CONFIG", $i);
     $run_test = set_test_option("TEST", $i);
     $addconfig = set_test_option("ADD_CONFIG", $i);
     $reboot_type = set_test_option("REBOOT_TYPE", $i);
@@ -2329,6 +2565,10 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
     $target_image = set_test_option("TARGET_IMAGE", $i);
     $localversion = set_test_option("LOCALVERSION", $i);
 
+    if (!defined($start_minconfig)) {
+	$start_minconfig = $minconfig;
+    }
+
     chdir $builddir || die "can't change directory to $builddir";
 
     if (!-d $tmpdir) {
@@ -2361,6 +2601,10 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
 	$run_type = $opt{"CONFIG_BISECT_TYPE[$i]"};
     }
 
+    if ($test_type eq "make_min_config") {
+	$run_type = "";
+    }
+
     # mistake in config file?
     if (!defined($run_type)) {
 	$run_type = "ERROR";
@@ -2396,6 +2640,9 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
     } elsif ($test_type eq "patchcheck") {
 	patchcheck $i;
 	next;
+    } elsif ($test_type eq "make_min_config") {
+	make_min_config $i;
+	next;
     }
 
     if ($build_type ne "nobuild") {
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.conf
index 82c966c..a83846d 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -814,3 +814,53 @@
 #   MIN_CONFIG = /home/test/config-min
 #   BISECT_MANUAL = 1
 #
+#
+#
+# For TEST_TYPE = make_min_config
+#
+#  After doing a make localyesconfig, your kernel configuration may
+#  not be the most useful minimum configuration. Having a true minimum
+#  config that you can use against other configs is very useful if
+#  someone else has a config that breaks on your code. By only forcing
+#  those configurations that are truly required to boot your machine
+#  will give you less of a chance that one of your set configurations
+#  will make the bug go away. This will give you a better chance to
+#  be able to reproduce the reported bug matching the broken config.
+#
+#  Note, this does take some time, and may require you to run the
+#  test over night, or perhaps over the weekend. But it also allows
+#  you to interrupt it, and gives you the current minimum config
+#  that was found till that time.
+#
+#  Note, this test automatically assumes a BUILD_TYPE of oldconfig
+#  and its test type acts like boot.
+#  TODO: add a test version that makes the config do more than just
+#   boot, like having network access.
+#
+#  OUTPUT_MIN_CONFIG is the path and filename of the file that will
+#   be created from the MIN_CONFIG. If you interrupt the test, set
+#   this file as your new min config, and use it to continue the test.
+#   This file does not need to exist on start of test.
+#   This file is not created until a config is found that can be removed.
+#   (required field)
+#
+#  START_MIN_CONFIG is the config to use to start the test with.
+#   you can set this as the same OUTPUT_MIN_CONFIG, but if you do
+#   the OUTPUT_MIN_CONFIG file must exist.
+#   (default MIN_CONFIG)
+#
+#  IGNORE_CONFIG is used to specify a config file that has configs that
+#   you already know must be set. Configs are written here that have
+#   been tested and proved to be required. It is best to define this
+#   file if you intend on interrupting the test and running it where
+#   it left off. New configs that it finds will be written to this file
+#   and will not be tested again in later runs.
+#   (optional)
+#
+# Example:
+#
+#  TEST_TYPE = make_min_config
+#  OUTPUT_MIN_CONFIG = /path/to/config-new-min
+#  START_MIN_CONFIG = /path/to/config-min
+#  IGNORE_CONFIG = /path/to/config-tested
+#
-- 
1.7.5.4


