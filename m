Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab1CHPZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 10:25:32 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48092 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755499Ab1CHPZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 10:25:29 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=F4WAOCV8yzkA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=rsZ3HKq3mQpPV7094goA:9 a=ZDHblQRzQd9DKhVaXKofq5DwrSoA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110308152528.036486067@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 08 Mar 2011 10:22:01 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/9] ktest: Handle kernels before make oldnoconfig
References: <20110308152158.799699072@goodmis.org>
Content-Disposition: inline; filename=0003-ktest-Handle-kernels-before-make-oldnoconfig.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

When bisecting, one may come across a kernel that does not have
make oldnoconfig. In this case, we need to run the command "yes"
into a make oldconfig. This will select defaults instead of 'n'
into each command, but it works as a work around.

Note, "yes n" will not work because a config may have a value that
"n" is not acceptable for.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |   27 ++++++++++++++++++++-------
 1 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 6620fe4..c95209b 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -930,6 +930,18 @@ sub check_buildlog {
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
@@ -975,8 +987,12 @@ sub build {
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
@@ -1395,9 +1411,7 @@ sub create_config {
     close(OUT);
 
 #    exit;
-    run_command "$make oldnoconfig" or
-	dodie "failed make config oldconfig";
-
+    make_oldconfig "";
 }
 
 sub compare_configs {
@@ -1599,8 +1613,7 @@ sub config_bisect {
     close(IN);
 
     # Now run oldconfig with the minconfig (and addconfigs)
-    run_command "$defconfig $make oldnoconfig" or
-	dodie "failed make config oldconfig";
+    make_oldconfig $defconfig;
 
     # check to see what we lost (or gained)
     open (IN, $output_config)
-- 
1.7.2.3


