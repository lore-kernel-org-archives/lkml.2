Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab1GZB0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 21:26:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48006 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061Ab1GZBYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 21:24:39 -0400
X-Authority-Analysis: v=1.1 cv=Pm0sEXe2MdIPK/rOEC7hwDW84D/yDsPO3JtCzsVYOFU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=0lq8jbhcEs8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=nFvwIAiyHt2SfVp-X24A:9 a=1lry_NLefjD3ZajdqioA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110726012428.392992823@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 25 Jul 2011 21:22:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 16/19] ktest: Use Kconfig dependencies to shorten time to make min_config
References: <20110726012238.271008621@goodmis.org>
Content-Disposition: inline; filename=0016-ktest-Use-Kconfig-dependencies-to-shorten-time-to-ma.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

To save time, the test does not just grab any option and test
it. The Kconfig files are examined to determine the dependencies
of the configs. If a config is chosen that depends on another
config, that config will be checked first. By checking the
parents first, we can eliminate whole groups of configs that
may have been enabled.

For example, if a USB device config is chosen and depends on
CONFIG_USB, the CONFIG_USB will be tested before the device.
If CONFIG_USB is found not to be needed, it, as well as all
configs that depend on it, will be disabled and removed from
the current min_config.

Note, the code from streamline_config (make localmodconfig)
was copied and used to find the dependencies in the Kconfig file.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl    |  283 ++++++++++++++++++++++++++++++++++++---
 tools/testing/ktest/sample.conf |   12 ++
 2 files changed, 273 insertions(+), 22 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 5323c6f..a9f2e10 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -2162,6 +2162,159 @@ sub patchcheck {
     return 1;
 }
 
+my %depends;
+my $iflevel = 0;
+my @ifdeps;
+
+# prevent recursion
+my %read_kconfigs;
+
+# taken from streamline_config.pl
+sub read_kconfig {
+    my ($kconfig) = @_;
+
+    my $state = "NONE";
+    my $config;
+    my @kconfigs;
+
+    my $cont = 0;
+    my $line;
+
+
+    if (! -f $kconfig) {
+	doprint "file $kconfig does not exist, skipping\n";
+	return;
+    }
+
+    open(KIN, "$kconfig")
+	or die "Can't open $kconfig";
+    while (<KIN>) {
+	chomp;
+
+	# Make sure that lines ending with \ continue
+	if ($cont) {
+	    $_ = $line . " " . $_;
+	}
+
+	if (s/\\$//) {
+	    $cont = 1;
+	    $line = $_;
+	    next;
+	}
+
+	$cont = 0;
+
+	# collect any Kconfig sources
+	if (/^source\s*"(.*)"/) {
+	    $kconfigs[$#kconfigs+1] = $1;
+	}
+
+	# configs found
+	if (/^\s*(menu)?config\s+(\S+)\s*$/) {
+	    $state = "NEW";
+	    $config = $2;
+
+	    for (my $i = 0; $i < $iflevel; $i++) {
+		if ($i) {
+		    $depends{$config} .= " " . $ifdeps[$i];
+		} else {
+		    $depends{$config} = $ifdeps[$i];
+		}
+		$state = "DEP";
+	    }
+
+	# collect the depends for the config
+	} elsif ($state eq "NEW" && /^\s*depends\s+on\s+(.*)$/) {
+
+	    if (defined($depends{$1})) {
+		$depends{$config} .= " " . $1;
+	    } else {
+		$depends{$config} = $1;
+	    }
+
+	# Get the configs that select this config
+	} elsif ($state ne "NONE" && /^\s*select\s+(\S+)/) {
+	    if (defined($depends{$1})) {
+		$depends{$1} .= " " . $config;
+	    } else {
+		$depends{$1} = $config;
+	    }
+
+	# Check for if statements
+	} elsif (/^if\s+(.*\S)\s*$/) {
+	    my $deps = $1;
+	    # remove beginning and ending non text
+	    $deps =~ s/^[^a-zA-Z0-9_]*//;
+	    $deps =~ s/[^a-zA-Z0-9_]*$//;
+
+	    my @deps = split /[^a-zA-Z0-9_]+/, $deps;
+
+	    $ifdeps[$iflevel++] = join ':', @deps;
+
+	} elsif (/^endif/) {
+
+	    $iflevel-- if ($iflevel);
+
+	# stop on "help"
+	} elsif (/^\s*help\s*$/) {
+	    $state = "NONE";
+	}
+    }
+    close(KIN);
+
+    # read in any configs that were found.
+    foreach $kconfig (@kconfigs) {
+	if (!defined($read_kconfigs{$kconfig})) {
+	    $read_kconfigs{$kconfig} = 1;
+	    read_kconfig("$builddir/$kconfig");
+	}
+    }
+}
+
+sub read_depends {
+    # find out which arch this is by the kconfig file
+    open (IN, $output_config)
+	or dodie "Failed to read $output_config";
+    my $arch;
+    while (<IN>) {
+	if (m,Linux/(\S+)\s+\S+\s+Kernel Configuration,) {
+	    $arch = $1;
+	    last;
+	}
+    }
+    close IN;
+
+    if (!defined($arch)) {
+	doprint "Could not find arch from config file\n";
+	doprint "no dependencies used\n";
+	return;
+    }
+
+    # arch is really the subarch, we need to know
+    # what directory to look at.
+    if ($arch eq "i386" || $arch eq "x86_64") {
+	$arch = "x86";
+    } elsif ($arch =~ /^tile/) {
+	$arch = "tile";
+    }
+
+    my $kconfig = "$builddir/arch/$arch/Kconfig";
+
+    if (! -f $kconfig && $arch =~ /\d$/) {
+	my $orig = $arch;
+ 	# some subarchs have numbers, truncate them
+	$arch =~ s/\d*$//;
+	$kconfig = "$builddir/arch/$arch/Kconfig";
+	if (! -f $kconfig) {
+	    doprint "No idea what arch dir $orig is for\n";
+	    doprint "no dependencies used\n";
+	    return;
+	}
+    }
+
+    read_kconfig($kconfig);
+}
+
 sub read_config_list {
     my ($config) = @_;
 
@@ -2197,6 +2350,95 @@ sub make_new_config {
     close OUT;
 }
 
+sub get_depends {
+    my ($dep) = @_;
+
+    my $kconfig = $dep;
+    $kconfig =~ s/CONFIG_//;
+
+    $dep = $depends{"$kconfig"};
+
+    # the dep string we have saves the dependencies as they
+    # were found, including expressions like ! && ||. We
+    # want to split this out into just an array of configs.
+
+    my $valid = "A-Za-z_0-9";
+
+    my @configs;
+
+    while ($dep =~ /[$valid]/) {
+
+	if ($dep =~ /^[^$valid]*([$valid]+)/) {
+	    my $conf = "CONFIG_" . $1;
+
+	    $configs[$#configs + 1] = $conf;
+
+	    $dep =~ s/^[^$valid]*[$valid]+//;
+	} else {
+	    die "this should never happen";
+	}
+    }
+
+    return @configs;
+}
+
+my %min_configs;
+my %keep_configs;
+my %processed_configs;
+my %nochange_config;
+
+sub test_this_config {
+    my ($config) = @_;
+
+    my $found;
+
+    # if we already processed this config, skip it
+    if (defined($processed_configs{$config})) {
+	return undef;
+    }
+    $processed_configs{$config} = 1;
+
+    # if this config failed during this round, skip it
+    if (defined($nochange_config{$config})) {
+	return undef;
+    }
+
+    my $kconfig = $config;
+    $kconfig =~ s/CONFIG_//;
+
+    # Test dependencies first
+    if (defined($depends{"$kconfig"})) {
+	my @parents = get_depends $config;
+	foreach my $parent (@parents) {
+	    # if the parent is in the min config, check it first
+	    next if (!defined($min_configs{$parent}));
+	    $found = test_this_config($parent);
+	    if (defined($found)) {
+		return $found;
+	    }
+	}
+    }
+
+    # Remove this config from the list of configs
+    # do a make oldnoconfig and then read the resulting
+    # .config to make sure it is missing the config that
+    # we had before
+    my %configs = %min_configs;
+    delete $configs{$config};
+    make_new_config ((values %configs), (values %keep_configs));
+    make_oldconfig;
+    undef %configs;
+    assign_configs \%configs, $output_config;
+
+    return $config if (!defined($configs{$config}));
+
+    doprint "disabling config $config did not change .config\n";
+
+    $nochange_config{$config} = 1;
+
+    return undef;
+}
+
 sub make_min_config {
     my ($i) = @_;
 
@@ -2216,8 +2458,12 @@ sub make_min_config {
 
     run_command "$make allnoconfig" or return 0;
 
+    read_depends;
+
     process_config_ignore $output_config;
-    my %keep_configs;
+
+    undef %keep_configs;
+    undef %min_configs;
 
     if (defined($ignore_config)) {
 	# make sure the file exists
@@ -2229,7 +2475,6 @@ sub make_min_config {
 
     # Look at the current min configs, and save off all the
     # ones that were set via the allnoconfig
-    my %min_configs;
     assign_configs \%min_configs, $start_minconfig;
 
     my @config_keys = keys %min_configs;
@@ -2261,9 +2506,8 @@ sub make_min_config {
 	}
     }
 
-    my %nochange_config;
-
     my $done = 0;
+    my $take_two = 0;
 
     while (!$done) {
 
@@ -2293,35 +2537,30 @@ sub make_min_config {
 	    undef %nochange_config;
 	}
 
-	foreach my $config (@test_configs) {
+	undef %processed_configs;
 
-	    # Remove this config from the list of configs
-	    # do a make oldnoconfig and then read the resulting
-	    # .config to make sure it is missing the config that
-	    # we had before
-	    my %configs = %min_configs;
-	    delete $configs{$config};
-	    make_new_config ((values %configs), (values %keep_configs));
-	    make_oldconfig;
-	    undef %configs;
-	    assign_configs \%configs, $output_config;
+	foreach my $config (@test_configs) {
 
-	    if (!defined($configs{$config})) {
-		$found = $config;
-		last;
-	    }
+	    $found = test_this_config $config;
 
-	    doprint "disabling config $config did not change .config\n";
+	    last if (defined($found));
 
 	    # oh well, try another config
-	    $nochange_config{$config} = 1;
 	}
 
 	if (!defined($found)) {
+	    # we could have failed due to the nochange_config hash
+	    # reset and try again
+	    if (!$take_two) {
+		undef %nochange_config;
+		$take_two = 1;
+		next;
+	    }
 	    doprint "No more configs found that we can disable\n";
 	    $done = 1;
 	    last;
 	}
+	$take_two = 0;
 
 	$config = $found;
 
@@ -2338,7 +2577,7 @@ sub make_min_config {
 	$in_bisect = 0;
 
 	if ($failed) {
-	    doprint "$config is needed to boot the box... keeping\n";
+	    doprint "$min_configs{$config} is needed to boot the box... keeping\n";
 	    # this config is needed, add it to the ignore list.
 	    $keep_configs{$config} = $min_configs{$config};
 	    delete $min_configs{$config};
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.conf
index a83846d..d096a0c 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -837,6 +837,18 @@
 #  TODO: add a test version that makes the config do more than just
 #   boot, like having network access.
 #
+#  To save time, the test does not just grab any option and test
+#  it. The Kconfig files are examined to determine the dependencies
+#  of the configs. If a config is chosen that depends on another
+#  config, that config will be checked first. By checking the
+#  parents first, we can eliminate whole groups of configs that
+#  may have been enabled.
+#
+#  For example, if a USB device config is chosen and depends on CONFIG_USB,
+#  the CONFIG_USB will be tested before the device. If CONFIG_USB is
+#  found not to be needed, it, as well as all configs that depend on
+#  it, will be disabled and removed from the current min_config.
+#
 #  OUTPUT_MIN_CONFIG is the path and filename of the file that will
 #   be created from the MIN_CONFIG. If you interrupt the test, set
 #   this file as your new min config, and use it to continue the test.
-- 
1.7.5.4


