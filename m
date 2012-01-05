Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365Ab2AEDsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 22:48:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34876 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309Ab2AEDs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 22:48:28 -0500
X-Authority-Analysis: v=2.0 cv=Pb19d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=kPWDAkjBtBAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=Q867z75FbTLS50EAobYA:9 a=yp7_jk0IDUzu6w7Q4YEA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=iNc5euUnBxEHx6Qp1u4A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120105034826.129076235@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 04 Jan 2012 22:48:12 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 17/20] ktest: Detect typos in option names
References: <20120105034755.793909214@goodmis.org>
Content-Disposition: inline; filename=0017-ktest-Detect-typos-in-option-names.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

It becomes quite annoying when you go to run a test and then
realize that you typed an option name wrong, and the test starts
doing the default action and not what you expected it to do.

It is even more annoying when you wake up the next day after
running the test over night when you discover this.

By testing if all options specified in a config file are
used by either ktest or were used in one of the option's values
we can see if there are any dangling options that were not used.
In such a case, show the user the options that were not used
and ask them if they want to continue or not.

The option IGNORE_UNUSED was also added to allow the user to
override this feature.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl    |  208 ++++++++++++++++++++++++-----------=
----
 tools/testing/ktest/sample.conf |   11 ++
 2 files changed, 139 insertions(+), 80 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 5ba9ad4..f360cbd 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -58,6 +58,9 @@ my %default =3D (
     "SSH_USER"			=3D> "root",
     "BUILD_TARGET"	 	=3D> "arch/x86/boot/bzImage",
     "TARGET_IMAGE"		=3D> "/boot/vmlinuz-test",
+
+    "LOG_FILE"			=3D> undef,
+    "IGNORE_UNUSED"		=3D> 0,
 );
=20
 my $ktest_config;
@@ -176,6 +179,92 @@ my %force_config;
 # do not force reboots on config problems
 my $no_reboot =3D 1;
=20
+my %option_map =3D (
+    "MACHINE"			=3D> \$machine,
+    "SSH_USER"			=3D> \$ssh_user,
+    "TMP_DIR"			=3D> \$tmpdir,
+    "OUTPUT_DIR"		=3D> \$outputdir,
+    "BUILD_DIR"			=3D> \$builddir,
+    "TEST_TYPE"			=3D> \$test_type,
+    "BUILD_TYPE"		=3D> \$build_type,
+    "BUILD_OPTIONS"		=3D> \$build_options,
+    "PRE_BUILD"			=3D> \$pre_build,
+    "POST_BUILD"		=3D> \$post_build,
+    "PRE_BUILD_DIE"		=3D> \$pre_build_die,
+    "POST_BUILD_DIE"		=3D> \$post_build_die,
+    "POWER_CYCLE"		=3D> \$power_cycle,
+    "REBOOT"			=3D> \$reboot,
+    "BUILD_NOCLEAN"		=3D> \$noclean,
+    "MIN_CONFIG"		=3D> \$minconfig,
+    "OUTPUT_MIN_CONFIG"		=3D> \$output_minconfig,
+    "START_MIN_CONFIG"		=3D> \$start_minconfig,
+    "IGNORE_CONFIG"		=3D> \$ignore_config,
+    "TEST"			=3D> \$run_test,
+    "ADD_CONFIG"		=3D> \$addconfig,
+    "REBOOT_TYPE"		=3D> \$reboot_type,
+    "GRUB_MENU"			=3D> \$grub_menu,
+    "POST_INSTALL"		=3D> \$post_install,
+    "NO_INSTALL"		=3D> \$no_install,
+    "REBOOT_SCRIPT"		=3D> \$reboot_script,
+    "REBOOT_ON_ERROR"		=3D> \$reboot_on_error,
+    "SWITCH_TO_GOOD"		=3D> \$switch_to_good,
+    "SWITCH_TO_TEST"		=3D> \$switch_to_test,
+    "POWEROFF_ON_ERROR"		=3D> \$poweroff_on_error,
+    "DIE_ON_FAILURE"		=3D> \$die_on_failure,
+    "POWER_OFF"			=3D> \$power_off,
+    "POWERCYCLE_AFTER_REBOOT"	=3D> \$powercycle_after_reboot,
+    "POWEROFF_AFTER_HALT"	=3D> \$poweroff_after_halt,
+    "SLEEP_TIME"		=3D> \$sleep_time,
+    "BISECT_SLEEP_TIME"		=3D> \$bisect_sleep_time,
+    "PATCHCHECK_SLEEP_TIME"	=3D> \$patchcheck_sleep_time,
+    "IGNORE_WARNINGS"		=3D> \$ignore_warnings,
+    "BISECT_MANUAL"		=3D> \$bisect_manual,
+    "BISECT_SKIP"		=3D> \$bisect_skip,
+    "CONFIG_BISECT_GOOD"	=3D> \$config_bisect_good,
+    "BISECT_RET_GOOD"		=3D> \$bisect_ret_good,
+    "BISECT_RET_BAD"		=3D> \$bisect_ret_bad,
+    "BISECT_RET_SKIP"		=3D> \$bisect_ret_skip,
+    "BISECT_RET_ABORT"		=3D> \$bisect_ret_abort,
+    "BISECT_RET_DEFAULT"	=3D> \$bisect_ret_default,
+    "STORE_FAILURES"		=3D> \$store_failures,
+    "STORE_SUCCESSES"		=3D> \$store_successes,
+    "TEST_NAME"			=3D> \$test_name,
+    "TIMEOUT"			=3D> \$timeout,
+    "BOOTED_TIMEOUT"		=3D> \$booted_timeout,
+    "CONSOLE"			=3D> \$console,
+    "DETECT_TRIPLE_FAULT"	=3D> \$detect_triplefault,
+    "SUCCESS_LINE"		=3D> \$success_line,
+    "REBOOT_SUCCESS_LINE"	=3D> \$reboot_success_line,
+    "STOP_AFTER_SUCCESS"	=3D> \$stop_after_success,
+    "STOP_AFTER_FAILURE"	=3D> \$stop_after_failure,
+    "STOP_TEST_AFTER"		=3D> \$stop_test_after,
+    "BUILD_TARGET"		=3D> \$build_target,
+    "SSH_EXEC"			=3D> \$ssh_exec,
+    "SCP_TO_TARGET"		=3D> \$scp_to_target,
+    "CHECKOUT"			=3D> \$checkout,
+    "TARGET_IMAGE"		=3D> \$target_image,
+    "LOCALVERSION"		=3D> \$localversion,
+
+    "BISECT_GOOD"		=3D> \$bisect_good,
+    "BISECT_BAD"		=3D> \$bisect_bad,
+    "BISECT_TYPE"		=3D> \$bisect_type,
+    "BISECT_START"		=3D> \$bisect_start,
+    "BISECT_REPLAY"		=3D> \$bisect_replay,
+    "BISECT_FILES"		=3D> \$bisect_files,
+    "BISECT_REVERSE"		=3D> \$bisect_reverse,
+    "BISECT_CHECK"		=3D> \$bisect_check,
+
+    "CONFIG_BISECT"		=3D> \$config_bisect,
+    "CONFIG_BISECT_TYPE"	=3D> \$config_bisect_type,
+
+    "PATCHCHECK_TYPE"		=3D> \$patchcheck_type,
+    "PATCHCHECK_START"		=3D> \$patchcheck_start,
+    "PATCHCHECK_END"		=3D> \$patchcheck_end,
+);
+
+# Options may be used by other options, record them.
+my %used_options;
+
 # default variables that can be used
 chomp ($variable{"PWD"} =3D `pwd`);
=20
@@ -427,6 +516,10 @@ sub process_variables {
 	} else {
 	    # put back the origin piece.
 	    $retval =3D "$retval\$\{$var\}";
+	    # This could be an option that is used later, save
+	    # it so we don't warn if this option is not one of
+	    # ktests options.
+	    $used_options{$var} =3D 1;
 	}
 	$value =3D $end;
     }
@@ -850,6 +943,37 @@ sub read_config {
 	    $opt{$default} =3D $default{$default};
 	}
     }
+
+    if ($opt{"IGNORE_UNUSED"} =3D=3D 1) {
+	return;
+    }
+
+    my %not_used;
+
+    # check if there are any stragglers (typos?)
+    foreach my $option (keys %opt) {
+	my $op =3D $option;
+	# remove per test labels.
+	$op =3D~ s/\[.*\]//;
+	if (!exists($option_map{$op}) &&
+	    !exists($default{$op}) &&
+	    !exists($used_options{$op})) {
+	    $not_used{$op} =3D 1;
+	}
+    }
+
+    if (%not_used) {
+	my $s =3D "s are";
+	$s =3D " is" if (keys %not_used =3D=3D 1);
+	print "The following option$s not used; could be a typo:\n";
+	foreach my $option (keys %not_used) {
+	    print "$option\n";
+	}
+	print "Set IGRNORE_UNUSED =3D 1 to have ktest ignore unused variables\n";
+	if (!read_yn "Do you want to continue?") {
+	    exit -1;
+	}
+    }
 }
=20
 sub __eval_option {
@@ -3321,86 +3445,10 @@ for (my $i =3D 1; $i <=3D $opt{"NUM_TESTS"}; $i++) {
=20
     my $makecmd =3D set_test_option("MAKE_CMD", $i);
=20
-    $machine =3D set_test_option("MACHINE", $i);
-    $ssh_user =3D set_test_option("SSH_USER", $i);
-    $tmpdir =3D set_test_option("TMP_DIR", $i);
-    $outputdir =3D set_test_option("OUTPUT_DIR", $i);
-    $builddir =3D set_test_option("BUILD_DIR", $i);
-    $test_type =3D set_test_option("TEST_TYPE", $i);
-    $build_type =3D set_test_option("BUILD_TYPE", $i);
-    $build_options =3D set_test_option("BUILD_OPTIONS", $i);
-    $pre_build =3D set_test_option("PRE_BUILD", $i);
-    $post_build =3D set_test_option("POST_BUILD", $i);
-    $pre_build_die =3D set_test_option("PRE_BUILD_DIE", $i);
-    $post_build_die =3D set_test_option("POST_BUILD_DIE", $i);
-    $power_cycle =3D set_test_option("POWER_CYCLE", $i);
-    $reboot =3D set_test_option("REBOOT", $i);
-    $noclean =3D set_test_option("BUILD_NOCLEAN", $i);
-    $minconfig =3D set_test_option("MIN_CONFIG", $i);
-    $output_minconfig =3D set_test_option("OUTPUT_MIN_CONFIG", $i);
-    $start_minconfig =3D set_test_option("START_MIN_CONFIG", $i);
-    $ignore_config =3D set_test_option("IGNORE_CONFIG", $i);
-    $run_test =3D set_test_option("TEST", $i);
-    $addconfig =3D set_test_option("ADD_CONFIG", $i);
-    $reboot_type =3D set_test_option("REBOOT_TYPE", $i);
-    $grub_menu =3D set_test_option("GRUB_MENU", $i);
-    $post_install =3D set_test_option("POST_INSTALL", $i);
-    $no_install =3D set_test_option("NO_INSTALL", $i);
-    $reboot_script =3D set_test_option("REBOOT_SCRIPT", $i);
-    $reboot_on_error =3D set_test_option("REBOOT_ON_ERROR", $i);
-    $switch_to_good =3D set_test_option("SWITCH_TO_GOOD", $i);
-    $switch_to_test =3D set_test_option("SWITCH_TO_TEST", $i);
-    $poweroff_on_error =3D set_test_option("POWEROFF_ON_ERROR", $i);
-    $die_on_failure =3D set_test_option("DIE_ON_FAILURE", $i);
-    $power_off =3D set_test_option("POWER_OFF", $i);
-    $powercycle_after_reboot =3D set_test_option("POWERCYCLE_AFTER_REBOOT"=
, $i);
-    $poweroff_after_halt =3D set_test_option("POWEROFF_AFTER_HALT", $i);
-    $sleep_time =3D set_test_option("SLEEP_TIME", $i);
-    $bisect_sleep_time =3D set_test_option("BISECT_SLEEP_TIME", $i);
-    $patchcheck_sleep_time =3D set_test_option("PATCHCHECK_SLEEP_TIME", $i=
);
-    $ignore_warnings =3D set_test_option("IGNORE_WARNINGS", $i);
-    $bisect_manual =3D set_test_option("BISECT_MANUAL", $i);
-    $bisect_skip =3D set_test_option("BISECT_SKIP", $i);
-    $config_bisect_good =3D set_test_option("CONFIG_BISECT_GOOD", $i);
-    $bisect_ret_good =3D set_test_option("BISECT_RET_GOOD", $i);
-    $bisect_ret_bad =3D set_test_option("BISECT_RET_BAD", $i);
-    $bisect_ret_skip =3D set_test_option("BISECT_RET_SKIP", $i);
-    $bisect_ret_abort =3D set_test_option("BISECT_RET_ABORT", $i);
-    $bisect_ret_default =3D set_test_option("BISECT_RET_DEFAULT", $i);
-    $store_failures =3D set_test_option("STORE_FAILURES", $i);
-    $store_successes =3D set_test_option("STORE_SUCCESSES", $i);
-    $test_name =3D set_test_option("TEST_NAME", $i);
-    $timeout =3D set_test_option("TIMEOUT", $i);
-    $booted_timeout =3D set_test_option("BOOTED_TIMEOUT", $i);
-    $console =3D set_test_option("CONSOLE", $i);
-    $detect_triplefault =3D set_test_option("DETECT_TRIPLE_FAULT", $i);
-    $success_line =3D set_test_option("SUCCESS_LINE", $i);
-    $reboot_success_line =3D set_test_option("REBOOT_SUCCESS_LINE", $i);
-    $stop_after_success =3D set_test_option("STOP_AFTER_SUCCESS", $i);
-    $stop_after_failure =3D set_test_option("STOP_AFTER_FAILURE", $i);
-    $stop_test_after =3D set_test_option("STOP_TEST_AFTER", $i);
-    $build_target =3D set_test_option("BUILD_TARGET", $i);
-    $ssh_exec =3D set_test_option("SSH_EXEC", $i);
-    $scp_to_target =3D set_test_option("SCP_TO_TARGET", $i);
-    $checkout =3D set_test_option("CHECKOUT", $i);
-    $target_image =3D set_test_option("TARGET_IMAGE", $i);
-    $localversion =3D set_test_option("LOCALVERSION", $i);
-
-    $bisect_good =3D set_test_option("BISECT_GOOD", $i);
-    $bisect_bad =3D set_test_option("BISECT_BAD", $i);
-    $bisect_type =3D set_test_option("BISECT_TYPE", $i);
-    $bisect_start =3D set_test_option("BISECT_START", $i);
-    $bisect_replay =3D set_test_option("BISECT_REPLAY", $i);
-    $bisect_files =3D set_test_option("BISECT_FILES", $i);
-    $bisect_reverse =3D set_test_option("BISECT_REVERSE", $i);
-    $bisect_check =3D set_test_option("BISECT_CHECK", $i);
-
-    $config_bisect =3D set_test_option("CONFIG_BISECT", $i);
-    $config_bisect_type =3D set_test_option("CONFIG_BISECT_TYPE", $i);
-
-    $patchcheck_type =3D set_test_option("PATCHCHECK_TYPE", $i);
-    $patchcheck_start =3D set_test_option("PATCHCHECK_START", $i);
-    $patchcheck_end =3D set_test_option("PATCHCHECK_END", $i);
+    # Load all the options into their mapped variable names
+    foreach my $opt (keys %option_map) {
+	${$option_map{$opt}} =3D set_test_option($opt, $i);
+    }
=20
     $start_minconfig_defined =3D 1;
=20
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.c=
onf
index c8dc757..86ce62c 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -727,6 +727,17 @@
 # (default 1)
 #DETECT_TRIPLE_FAULT =3D 0
=20
+# All options in the config file should be either used by ktest
+# or could be used within a value of another option. If an option
+# in the config file is not used, ktest will warn about it and ask
+# if you want to continue.
+#
+# If you don't care if there are non-used options, enable this
+# option. Be careful though, a non-used option is usually a sign
+# of an option name being typed incorrectly.
+# (default 0)
+#IGNORE_UNUSED =3D 1
+
 #### Per test run options ####
 # The following options are only allowed in TEST_START sections.
 # They are ignored in the DEFAULTS sections.
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPBR2KAAoJEIy3vGnGbaoA9D8P/RunTXfbCR62MIAWe+p/5MXm
doJ3UHqSP2gmi+3iFwUOk1LFW06oP8ibW9yNVXD7IdBh+Ch/MvYPXA10ge1PfDfx
Spa0QcblvND4c43U9uPAbj3yaub4GBZDo9dEJE5CrcB5aolZX8a1rde/D0RnRVMj
0kwGs81k3dz1bo+8r4YL2TxcgDk97U+O+Ss3aOnK4i3kOW86xHZUb6pNQWbELVwW
VKp2wfVtBxOYxL6dhscXZ7a/2+5ZE06dWHCzoGlT/OChIfGvaMsIa8bsTe0JIqgd
Hv4xM2E2ZnGYO61oAiBqGiwU5wS7AizGjza+gfXvnwyXHmsqrg0GeuFsy0rXC6nq
9Flg8RG+4Fi03YeB8jv5GQY1D1MPEM/WCGwsFa6uc4PqoK//xQ7tOAT2ICMI+JeY
94C1dEYnl5loSB3FwseB+TjcYd/1ZBeiS0tlNAAkOhGnfhTgLfQ29RSJDA7uykHv
OYLhFk4oBTWFNrz7eUkkciHwQEb5YdyAYKOJDOXP9GiRXdu82mlYeK+BeaJxlZzq
n2+razb2dMyBy05nkBCFgTuE2ZvdwgNnQ932MgwE00Ej8rAnGBuJrpz+6QI2vaOz
TDBkyGoVZFStez5AZTx6CyW4dgRcq0Z+CUbnS/YD4A1AmWhhJLNqPKiR8TCiigXm
/zq5U+LmodzpPSIAyCa1
=mRKj
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
