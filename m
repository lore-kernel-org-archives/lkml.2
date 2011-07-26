Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab1GZB1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 21:27:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48170 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898Ab1GZBYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 21:24:31 -0400
X-Authority-Analysis: v=1.1 cv=YhhhcVvq/Bf3xBNEvzTEV9JHGW2mXul7kEbaqsyQnMQ= c=1 sm=0 a=vhdKIqpQuCYA:10 a=g_TIhG7R8tcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=hN0_tmeC4hIGLAX55XYA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110726012428.983785183@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 25 Jul 2011 21:22:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 18/19] ktest: Keep fonud configs separate from default configs
References: <20110726012238.271008621@goodmis.org>
Content-Disposition: inline; filename=0018-ktest-Keep-fonud-configs-separate-from-default-confi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The IGNORE_CONFIG file holds the configs that we don't want to change
(with their proper settings). But on start up, the make noconfig is
executed, and the configs that are on are also put into the ignore
config category. But these are configs that were forced on by the
kconfig scripts and not something that we found must be enabled to boot
our machine. By keeping the configs that are forced on by default,
separate from the configs we found that are required to boot the box, we
can get a much more interesting IGNORE_CONFIG. In fact, the
IGNORE_CONFIG can usually end up being the must have configs to boot,
and only have 6 or 7 configs set.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index cf45f58..e826704 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -2405,6 +2405,7 @@ sub get_depends {
 
 my %min_configs;
 my %keep_configs;
+my %save_configs;
 my %processed_configs;
 my %nochange_config;
 
@@ -2496,15 +2497,17 @@ sub make_min_config {
 
     process_config_ignore $output_config;
 
-    undef %keep_configs;
+    undef %save_configs;
     undef %min_configs;
 
     if (defined($ignore_config)) {
 	# make sure the file exists
 	`touch $ignore_config`;
-	assign_configs \%keep_configs, $ignore_config;
+	assign_configs \%save_configs, $ignore_config;
     }
 
+    %keep_configs = %save_configs;
+
     doprint "Load initial configs from $start_minconfig\n";
 
     # Look at the current min configs, and save off all the
@@ -2614,14 +2617,15 @@ sub make_min_config {
 	    doprint "$min_configs{$config} is needed to boot the box... keeping\n";
 	    # this config is needed, add it to the ignore list.
 	    $keep_configs{$config} = $min_configs{$config};
+	    $save_configs{$config} = $min_configs{$config};
 	    delete $min_configs{$config};
 
 	    # update new ignore configs
 	    if (defined($ignore_config)) {
 		open (OUT, ">$temp_config")
 		    or die "Can't write to $temp_config";
-		foreach my $config (keys %keep_configs) {
-		    print OUT "$keep_configs{$config}\n";
+		foreach my $config (keys %save_configs) {
+		    print OUT "$save_configs{$config}\n";
 		}
 		close OUT;
 		run_command "mv $temp_config $ignore_config" or
-- 
1.7.5.4


