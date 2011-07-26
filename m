Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab1GZBZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 21:25:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33288 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab1GZBYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 21:24:39 -0400
X-Authority-Analysis: v=1.1 cv=sbbt6Wn8j+VvNVI1Ftt/uHhinWyuFt+R57MN9Ty2Tys= c=1 sm=0 a=vhdKIqpQuCYA:10 a=8opqq1d1oSAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=5ci9UVt6zelwpgQI5AMA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110726012429.229935886@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 25 Jul 2011 21:22:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 19/19] ktest: Fix bug when ADD_CONFIG is set but MIN_CONFIG is not
References: <20110726012238.271008621@goodmis.org>
Content-Disposition: inline; filename=0019-ktest-Fix-bug-when-ADD_CONFIG-is-set-but-MIN_CONFIG-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The MIN_CONFIG is a single config that is considered to have all the
configs that are required to boot the box.

ADD_CONFIG is a list of configs that we add that may contain configs
known to be broken (set off) or just configs that we want every box to
have and this can include shared configs.

If a config has no MIN_CONFIG defined, but has multiple files defined
for the ADD_CONFIG, the test will die, because the MIN_CONFIG will
default to ADD_CONFIG. The problem is the code to open MIN_CONFIG
expects a string of one file, not multiple, and the open will fail.

Since the real minconfig that is used is a concatination of MIN_CONFIG
and ADD_CONFIG files, we change the code to open that instead of
whatever MIN_CONFIG defaults to.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index e826704..8d02ccb 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1970,12 +1970,6 @@ sub config_bisect {
 	unlink $tmpconfig;
     }
 
-    # Add other configs
-    if (defined($addconfig)) {
-	run_command "cat $addconfig >> $tmpconfig" or
-	    dodie "failed to append $addconfig";
-    }
-
     if (-f $tmpconfig) {
 	load_force_config($tmpconfig);
 	process_config_ignore $tmpconfig;
@@ -1997,7 +1991,7 @@ sub config_bisect {
     }
     close(IN);
 
-    # Now run oldconfig with the minconfig (and addconfigs)
+    # Now run oldconfig with the minconfig
     make_oldconfig;
 
     # check to see what we lost (or gained)
@@ -2901,11 +2895,12 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
     unlink $dmesg;
     unlink $buildlog;
 
-    if (!defined($minconfig)) {
-	$minconfig = $addconfig;
-
-    } elsif (defined($addconfig)) {
-	run_command "cat $addconfig $minconfig > $tmpdir/add_config" or
+    if (defined($addconfig)) {
+	my $min = $minconfig;
+	if (!defined($minconfig)) {
+	    $min = "";
+	}
+	run_command "cat $addconfig $min > $tmpdir/add_config" or
 	    dodie "Failed to create temp config";
 	$minconfig = "$tmpdir/add_config";
     }
-- 
1.7.5.4


