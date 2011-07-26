Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab1GZBYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 21:24:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47975 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab1GZBY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 21:24:27 -0400
X-Authority-Analysis: v=1.1 cv=Pm0sEXe2MdIPK/rOEC7hwDW84D/yDsPO3JtCzsVYOFU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=OQTkKaIk0vgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=iAfohtV5MmtaVvbjUVcA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110726012425.555745364@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 25 Jul 2011 21:22:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 05/19] ktest: Implement our own force min config
References: <20110726012238.271008621@goodmis.org>
Content-Disposition: inline; filename=0005-ktest-Implement-our-own-force-min-config.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Using the build KCONFIG_ALLCONFIG environment variable to force
the min config may not always work properly. Since ktest is
written in perl, it is trivial to read and replace the current
config with the configs specified by the min config.

Now the min config (and add configs) are read by perl and before
a make is done, these configs in the .config file are replaced
by the version in the min config.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |   74 ++++++++++++++++++++++++++++++++++-------
 1 files changed, 61 insertions(+), 13 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 579569f..aa442a9 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -119,6 +119,7 @@ my $successes = 0;
 my %entered_configs;
 my %config_help;
 my %variable;
+my %force_config;
 
 $config_help{"MACHINE"} = << "EOF"
  The machine hostname that you will test.
@@ -1044,21 +1045,69 @@ sub check_buildlog {
     return 1;
 }
 
+sub apply_min_config {
+    my $outconfig = "$output_config.new";
+
+    # Read the config file and remove anything that
+    # is in the force_config hash (from minconfig and others)
+    # then add the force config back.
+
+    doprint "Applying minimum configurations into $output_config.new\n";
+
+    open (OUT, ">$outconfig") or
+	dodie "Can't create $outconfig";
+
+    if (-f $output_config) {
+	open (IN, $output_config) or
+	    dodie "Failed to open $output_config";
+	while (<IN>) {
+	    if (/^(# )?(CONFIG_[^\s=]*)/) {
+		next if (defined($force_config{$2}));
+	    }
+	    print OUT;
+	}
+	close IN;
+    }
+    foreach my $config (keys %force_config) {
+	print OUT "$force_config{$config}\n";
+    }
+    close OUT;
+
+    run_command "mv $outconfig $output_config";
+}
+
 sub make_oldconfig {
-    my ($defconfig) = @_;
 
-    if (!run_command "$defconfig $make oldnoconfig") {
+    apply_min_config;
+
+    if (!run_command "$make oldnoconfig") {
 	# Perhaps oldnoconfig doesn't exist in this version of the kernel
 	# try a yes '' | oldconfig
 	doprint "oldnoconfig failed, trying yes '' | make oldconfig\n";
-	run_command "yes '' | $defconfig $make oldconfig" or
+	run_command "yes '' | $make oldconfig" or
 	    dodie "failed make config oldconfig";
     }
 }
 
+# read a config file and use this to force new configs.
+sub load_force_config {
+    my ($config) = @_;
+
+    open(IN, $config) or
+	dodie "failed to read $config";
+    while (<IN>) {
+	chomp;
+	if (/^(CONFIG[^\s=]*)(\s*=.*)/) {
+	    $force_config{$1} = $_;
+	} elsif (/^# (CONFIG_\S*) is not set/) {
+	    $force_config{$1} = $_;
+	}
+    }
+    close IN;
+}
+
 sub build {
     my ($type) = @_;
-    my $defconfig = "";
 
     unlink $buildlog;
 
@@ -1098,15 +1147,15 @@ sub build {
     close(OUT);
 
     if (defined($minconfig)) {
-	$defconfig = "KCONFIG_ALLCONFIG=$minconfig";
+	load_force_config($minconfig);
     }
 
-    if ($type eq "oldnoconfig") {
-	make_oldconfig $defconfig;
-    } else {
-	run_command "$defconfig $make $type" or
+    if ($type ne "oldnoconfig") {
+	run_command "$make $type" or
 	    dodie "failed make config";
     }
+    # Run old config regardless, to enforce min configurations
+    make_oldconfig;
 
     $redirect = "$buildlog";
     if (!run_command "$make $build_options") {
@@ -1587,7 +1636,7 @@ sub create_config {
     close(OUT);
 
 #    exit;
-    make_oldconfig "";
+    make_oldconfig;
 }
 
 sub compare_configs {
@@ -1778,9 +1827,8 @@ sub config_bisect {
 	    dodie "failed to append $addconfig";
     }
 
-    my $defconfig = "";
     if (-f $tmpconfig) {
-	$defconfig = "KCONFIG_ALLCONFIG=$tmpconfig";
+	load_force_config($tmpconfig);
 	process_config_ignore $tmpconfig;
     }
 
@@ -1801,7 +1849,7 @@ sub config_bisect {
     close(IN);
 
     # Now run oldconfig with the minconfig (and addconfigs)
-    make_oldconfig $defconfig;
+    make_oldconfig;
 
     # check to see what we lost (or gained)
     open (IN, $output_config)
-- 
1.7.5.4


