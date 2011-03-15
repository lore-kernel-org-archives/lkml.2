Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539Ab1COWYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 18:24:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39300 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab1COWYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 18:24:37 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=W_sOucGnJj4A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=Xal8kI0dmHWorfSc298A:9 a=GSEYqw53bDqRDzKIzkQA:7 a=KIXpTeTQci0_A3T-3K5lGwFTvNwA:4 a=PUjeQqilurYA:10 a=AW57Wwxs2D36Qujg:21 a=CRlKJVSS6gU5B-wX:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [GIT PULL] ktest.pl: updates and features
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 15 Mar 2011 18:24:35 -0400
Message-ID: <1300227875.16880.13.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull the latest ktest tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-ktest.git
for-linus


Steven Rostedt (9):
      ktest: Print logfile name on failure
      ktest: Start failure timeout on panic too
      ktest: Handle kernels before make oldnoconfig
      ktest: Add manual bisect
      ktest: Add BISECT_SKIP
      ktest: Add BISECT_FILES to run git bisect on paths
      ktest: Fix bug where the test would not end after failure
      ktest: Monitor kernel while running of user tests
      ktest: Add STOP_TEST_AFTER to stop the test after a period of time

----
 tools/testing/ktest/ktest.pl    |  139 +++++++++++++++++++++++++++++++++------
 tools/testing/ktest/sample.conf |   42 ++++++++++++
 2 files changed, 161 insertions(+), 20 deletions(-)
---------------------------
diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index e1c62ee..a8b3292 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -37,6 +37,8 @@ $default{"POWEROFF_ON_SUCCESS"}	= 0;
 $default{"BUILD_OPTIONS"}	= "";
 $default{"BISECT_SLEEP_TIME"}	= 60;   # sleep time between bisects
 $default{"CLEAR_LOG"}		= 0;
+$default{"BISECT_MANUAL"}	= 0;
+$default{"BISECT_SKIP"}		= 1;
 $default{"SUCCESS_LINE"}	= "login:";
 $default{"BOOTED_TIMEOUT"}	= 1;
 $default{"DIE_ON_FAILURE"}	= 1;
@@ -45,6 +47,7 @@ $default{"SCP_TO_TARGET"}	= "scp \$SRC_FILE \$SSH_USER\@\$MACHINE:\$DST_FILE";
 $default{"REBOOT"}		= "ssh \$SSH_USER\@\$MACHINE reboot";
 $default{"STOP_AFTER_SUCCESS"}	= 10;
 $default{"STOP_AFTER_FAILURE"}	= 60;
+$default{"STOP_TEST_AFTER"}	= 600;
 $default{"LOCALVERSION"}	= "-test";
 
 my $ktest_config;
@@ -81,6 +84,8 @@ my $addconfig;
 my $in_bisect = 0;
 my $bisect_bad = "";
 my $reverse_bisect;
+my $bisect_manual;
+my $bisect_skip;
 my $in_patchcheck = 0;
 my $run_test;
 my $redirect;
@@ -98,6 +103,7 @@ my $console;
 my $success_line;
 my $stop_after_success;
 my $stop_after_failure;
+my $stop_test_after;
 my $build_target;
 my $target_image;
 my $localversion;
@@ -462,6 +468,10 @@ sub dodie {
 	`$power_off`;
     }
 
+    if (defined($opt{"LOG_FILE"})) {
+	print " See $opt{LOG_FILE} for more info.\n";
+    }
+
     die @_, "\n";
 }
 
@@ -760,8 +770,10 @@ sub monitor {
 
     my $success_start;
     my $failure_start;
+    my $monitor_start = time;
+    my $done = 0;
 
-    for (;;) {
+    while (!$done) {
 
 	if ($booted) {
 	    $line = wait_for_input($monitor_fp, $booted_timeout);
@@ -796,7 +808,7 @@ sub monitor {
 	}
 
 	if ($full_line =~ /call trace:/i) {
-	    if (!$skip_call_trace) {
+	    if (!$bug && !$skip_call_trace) {
 		$bug = 1;
 		$failure_start = time;
 	    }
@@ -816,12 +828,19 @@ sub monitor {
 	}
 
 	if ($full_line =~ /Kernel panic -/) {
+	    $failure_start = time;
 	    $bug = 1;
 	}
 
 	if ($line =~ /\n/) {
 	    $full_line = "";
 	}
+
+	if ($stop_test_after > 0 && !$booted && !$bug) {
+	    if (time - $monitor_start > $stop_test_after) {
+		$done = 1;
+	    }
+	}
     }
 
     close(DMESG);
@@ -925,6 +944,18 @@ sub check_buildlog {
     return 1;
 }
 
+sub make_oldconfig {
+    my ($defconfig) = @_;
+
+    if (!run_command "$defconfig $make oldnoconfig") {
+	# Perhaps oldnoconfig doesn't exist in this version of the kernel
+	# try a yes '' | oldconfig
+	doprint "oldnoconfig failed, trying yes '' | make oldconfig\n";
+	run_command "yes '' | $defconfig $make oldconfig" or
+	    dodie "failed make config oldconfig";
+    }
+}
+
 sub build {
     my ($type) = @_;
     my $defconfig = "";
@@ -970,8 +1001,12 @@ sub build {
 	$defconfig = "KCONFIG_ALLCONFIG=$minconfig";
     }
 
-    run_command "$defconfig $make $type" or
-	dodie "failed make config";
+    if ($type eq "oldnoconfig") {
+	make_oldconfig $defconfig;
+    } else {
+	run_command "$defconfig $make $type" or
+	    dodie "failed make config";
+    }
 
     $redirect = "$buildlog";
     if (!run_command "$make $build_options") {
@@ -1025,6 +1060,21 @@ sub get_version {
     doprint "$version\n";
 }
 
+sub answer_bisect {
+    for (;;) {
+	doprint "Pass or fail? [p/f]";
+	my $ans = <STDIN>;
+	chomp $ans;
+	if ($ans eq "p" || $ans eq "P") {
+	    return 1;
+	} elsif ($ans eq "f" || $ans eq "F") {
+	    return 0;
+	} else {
+	    print "Please answer 'P' or 'F'\n";
+	}
+    }
+}
+
 sub child_run_test {
     my $failed = 0;
 
@@ -1070,6 +1120,7 @@ sub do_run_test {
 
 	    # we are not guaranteed to get a full line
 	    $full_line .= $line;
+	    doprint $line;
 
 	    if ($full_line =~ /call trace:/i) {
 		$bug = 1;
@@ -1086,6 +1137,19 @@ sub do_run_test {
     } while (!$child_done && !$bug);
 
     if ($bug) {
+	my $failure_start = time;
+	my $now;
+	do {
+	    $line = wait_for_input($monitor_fp, 1);
+	    if (defined($line)) {
+		doprint $line;
+	    }
+	    $now = time;
+	    if ($now - $failure_start >= $stop_after_failure) {
+		last;
+	    }
+	} while (defined($line));
+
 	doprint "Detected kernel crash!\n";
 	# kill the child with extreme prejudice
 	kill 9, $child_pid;
@@ -1131,7 +1195,15 @@ sub run_git_bisect {
     return 1;
 }
 
-# returns 1 on success, 0 on failure
+sub bisect_reboot {
+    doprint "Reboot and sleep $bisect_sleep_time seconds\n";
+    reboot;
+    start_monitor;
+    wait_for_monitor $bisect_sleep_time;
+    end_monitor;
+}
+
+# returns 1 on success, 0 on failure, -1 on skip
 sub run_bisect_test {
     my ($type, $buildtype) = @_;
 
@@ -1145,6 +1217,10 @@ sub run_bisect_test {
     build $buildtype or $failed = 1;
 
     if ($type ne "build") {
+	if ($failed && $bisect_skip) {
+	    $in_bisect = 0;
+	    return -1;
+	}
 	dodie "Failed on build" if $failed;
 
 	# Now boot the box
@@ -1156,6 +1232,12 @@ sub run_bisect_test {
 	monitor or $failed = 1;
 
 	if ($type ne "boot") {
+	    if ($failed && $bisect_skip) {
+		end_monitor;
+		bisect_reboot;
+		$in_bisect = 0;
+		return -1;
+	    }
 	    dodie "Failed on boot" if $failed;
 
 	    do_run_test or $failed = 1;
@@ -1168,11 +1250,7 @@ sub run_bisect_test {
 
 	# reboot the box to a good kernel
 	if ($type ne "build") {
-	    doprint "Reboot and sleep $bisect_sleep_time seconds\n";
-	    reboot;
-	    start_monitor;
-	    wait_for_monitor $bisect_sleep_time;
-	    end_monitor;
+	    bisect_reboot;
 	}
     } else {
 	$result = 1;
@@ -1193,16 +1271,22 @@ sub run_bisect {
 
     my $ret = run_bisect_test $type, $buildtype;
 
+    if ($bisect_manual) {
+	$ret = answer_bisect;
+    }
 
     # Are we looking for where it worked, not failed?
     if ($reverse_bisect) {
 	$ret = !$ret;
     }
 
-    if ($ret) {
+    if ($ret > 0) {
 	return "good";
-    } else {
+    } elsif ($ret == 0) {
 	return  "bad";
+    } elsif ($bisect_skip) {
+	doprint "HIT A BAD COMMIT ... SKIPPING\n";
+	return "skip";
     }
 }
 
@@ -1220,6 +1304,13 @@ sub bisect {
     my $type = $opt{"BISECT_TYPE[$i]"};
     my $start = $opt{"BISECT_START[$i]"};
     my $replay = $opt{"BISECT_REPLAY[$i]"};
+    my $start_files = $opt{"BISECT_FILES[$i]"};
+
+    if (defined($start_files)) {
+	$start_files = " -- " . $start_files;
+    } else {
+	$start_files = "";
+    }
 
     # convert to true sha1's
     $good = get_sha1($good);
@@ -1273,7 +1364,7 @@ sub bisect {
 	    die "Failed to checkout $head";
     }
 
-    run_command "git bisect start" or
+    run_command "git bisect start$start_files" or
 	dodie "could not start bisect";
 
     run_command "git bisect good $good" or
@@ -1390,9 +1481,7 @@ sub create_config {
     close(OUT);
 
 #    exit;
-    run_command "$make oldnoconfig" or
-	dodie "failed make config oldconfig";
-
+    make_oldconfig "";
 }
 
 sub compare_configs {
@@ -1505,7 +1594,9 @@ sub run_config_bisect {
 	}
 
 	$ret = run_config_bisect_test $type;
-
+	if ($bisect_manual) {
+	    $ret = answer_bisect;
+	}
 	if ($ret) {
 	    process_passed %current_config;
 	    return 0;
@@ -1536,7 +1627,13 @@ sub run_config_bisect {
 	$half = int($#start_list / 2);
     } while ($half > 0);
 
-    # we found a single config, try it again
+    # we found a single config, try it again unless we are running manually
+
+    if ($bisect_manual) {
+	process_failed $start_list[0];
+	return 1;
+    }
+
     my @tophalf = @start_list[0 .. 0];
 
     $ret = run_config_bisect_test $type;
@@ -1594,8 +1691,7 @@ sub config_bisect {
     close(IN);
 
     # Now run oldconfig with the minconfig (and addconfigs)
-    run_command "$defconfig $make oldnoconfig" or
-	dodie "failed make config oldconfig";
+    make_oldconfig $defconfig;
 
     # check to see what we lost (or gained)
     open (IN, $output_config)
@@ -1907,6 +2003,8 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
     $poweroff_after_halt = set_test_option("POWEROFF_AFTER_HALT", $i);
     $sleep_time = set_test_option("SLEEP_TIME", $i);
     $bisect_sleep_time = set_test_option("BISECT_SLEEP_TIME", $i);
+    $bisect_manual = set_test_option("BISECT_MANUAL", $i);
+    $bisect_skip = set_test_option("BISECT_SKIP", $i);
     $store_failures = set_test_option("STORE_FAILURES", $i);
     $timeout = set_test_option("TIMEOUT", $i);
     $booted_timeout = set_test_option("BOOTED_TIMEOUT", $i);
@@ -1914,6 +2012,7 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
     $success_line = set_test_option("SUCCESS_LINE", $i);
     $stop_after_success = set_test_option("STOP_AFTER_SUCCESS", $i);
     $stop_after_failure = set_test_option("STOP_AFTER_FAILURE", $i);
+    $stop_test_after = set_test_option("STOP_TEST_AFTER", $i);
     $build_target = set_test_option("BUILD_TARGET", $i);
     $ssh_exec = set_test_option("SSH_EXEC", $i);
     $scp_to_target = set_test_option("SCP_TO_TARGET", $i);
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.conf
index 3408c59..4c5d6bd 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -306,6 +306,14 @@
 # (default 60)
 #STOP_AFTER_FAILURE = 60
 
+# In case the console constantly fills the screen, having
+# a specified time to stop the test if it never succeeds nor fails
+# is recommended.
+# Note: this is ignored if a success or failure is detected.
+# (in seconds)
+# (default 600, -1 is to never stop)
+#STOP_TEST_AFTER = 600
+
 # Stop testing if a build fails. If set, the script will end if
 # a failure is detected, otherwise it will save off the .config,
 # dmesg and bootlog in a directory called
@@ -519,6 +527,24 @@
 #   git bisect good, git bisect bad, and running the git bisect replay
 #   if the BISECT_REPLAY is set.
 #
+# BISECT_SKIP = 1 (optional, default 0)
+#
+#   If BISECT_TYPE is set to test but the build fails, ktest will
+#   simply fail the test and end their. You could use BISECT_REPLAY
+#   and BISECT_START to resume after you found a new starting point,
+#   or you could set BISECT_SKIP to 1. If BISECT_SKIP is set to 1,
+#   when something other than the BISECT_TYPE fails, ktest.pl will
+#   run "git bisect skip" and try again.
+#
+# BISECT_FILES = <path> (optional, default undefined)
+#
+#   To just run the git bisect on a specific path, set BISECT_FILES.
+#   For example:
+#
+#     BISECT_FILES = arch/x86 kernel/time
+#
+#   Will run the bisect with "git bisect start -- arch/x86 kernel/time"
+#
 # BISECT_REVERSE = 1 (optional, default 0)
 #
 #   In those strange instances where it was broken forever
@@ -528,6 +554,15 @@
 #   With BISECT_REVERSE = 1, The test will consider failures as
 #   good, and success as bad.
 #
+# BISECT_MANUAL = 1 (optional, default 0)
+#
+#   In case there's a problem with automating the bisect for
+#   whatever reason. (Can't reboot, want to inspect each iteration)
+#   Doing a BISECT_MANUAL will have the test wait for you to
+#   tell it if the test passed or failed after each iteration.
+#   This is basicall the same as running git bisect yourself
+#   but ktest will rebuild and install the kernel for you.
+#
 # BISECT_CHECK = 1 (optional, default 0)
 #
 #   Just to be sure the good is good and bad is bad, setting
@@ -613,10 +648,17 @@
 #
 #   CONFIG_BISECT is the config that failed to boot
 #
+#   If BISECT_MANUAL is set, it will pause between iterations.
+#   This is useful to use just ktest.pl just for the config bisect.
+#   If you set it to build, it will run the bisect and you can
+#   control what happens in between iterations. It will ask you if
+#   the test succeeded or not and continue the config bisect.
+#
 # Example:
 #   TEST_START
 #   TEST_TYPE = config_bisect
 #   CONFIG_BISECT_TYPE = build
 #   CONFIG_BISECT = /home/test/config-bad
 #   MIN_CONFIG = /home/test/config-min
+#   BISECT_MANUAL = 1
 #


