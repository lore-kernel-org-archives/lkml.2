Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab1GZB1u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 21:27:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33288 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886Ab1GZBY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 21:24:29 -0400
X-Authority-Analysis: v=1.1 cv=sbbt6Wn8j+VvNVI1Ftt/uHhinWyuFt+R57MN9Ty2Tys= c=1 sm=0 a=vhdKIqpQuCYA:10 a=2bBbyewA2CcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=ia4HO-0qDdbZQb9UKg0A:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110726012426.339856907@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 25 Jul 2011 21:22:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 08/19] ktest: Allow initrd processing without modules defined
References: <20110726012238.271008621@goodmis.org>
Content-Disposition: inline; filename=0008-ktest-Allow-initrd-processing-without-modules-define.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

When a config is set with CONFIG_MODULES=n, it does not mean that the
kernel does not need an initrd to boot. For systems that depend on LVM
and such, an initrd must run first.

If POST_INSTALL is defined, then run the post install regardless if
modules are needed or not.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 83dcfaf..fb46e12 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1031,6 +1031,16 @@ sub monitor {
     return 1;
 }
 
+sub do_post_install {
+
+    return if (!defined($post_install));
+
+    my $cp_post_install = $post_install;
+    $cp_post_install =~ s/\$KERNEL_VERSION/$version/g;
+    run_command "$cp_post_install" or
+	dodie "Failed to run post install";
+}
+
 sub install {
 
     run_scp "$outputdir/$build_target", "$target_image" or
@@ -1050,6 +1060,7 @@ sub install {
     close(IN);
 
     if (!$install_mods) {
+	do_post_install;
 	doprint "No modules needed\n";
 	return;
     }
@@ -1077,12 +1088,7 @@ sub install {
 
     run_ssh "rm -f /tmp/$modtar";
 
-    return if (!defined($post_install));
-
-    my $cp_post_install = $post_install;
-    $cp_post_install =~ s/\$KERNEL_VERSION/$version/g;
-    run_command "$cp_post_install" or
-	dodie "Failed to run post install";
+    do_post_install;
 }
 
 sub check_buildlog {
-- 
1.7.5.4


