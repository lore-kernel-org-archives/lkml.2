Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab1HLNdU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 09:33:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809Ab1HLNcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 09:32:32 -0400
From: Andrew Jones <drjones@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: drjones@redhat.com, rostedt@goodmis.org
Subject: [PATCH 09/10] ktest: test faster, favor rsync over the tarball method
Date: Fri, 12 Aug 2011 15:32:11 +0200
Message-Id: <1313155932-20092-10-git-send-email-drjones@redhat.com>
In-Reply-To: <1313155932-20092-1-git-send-email-drjones@redhat.com>
References: <1313155932-20092-1-git-send-email-drjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we have rsync on the host and target, then use that to install
modules. It's faster, doesn't require as much free disk space, and
is more environmentally friendly. OK, maybe not the last one, but
it's still better.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/ktest/ktest.pl |   34 +++++++++++++++++++++++++---------
 1 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 719df19..ac0e688 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -81,6 +81,8 @@ my $powercycle_after_reboot;
 my $poweroff_after_halt;
 my $ssh_exec;
 my $scp_to_target;
+my $have_rsync;
+my %has_rsync = ();
 my $power_off;
 my $grub_menu;
 my $grub_number;
@@ -1137,25 +1139,39 @@ sub install {
 	dodie "Failed to install modules";
 
     my $modlib = "/lib/modules/$version";
-    my $modtar = "ktest-mods.tar.bz2";
 
-    run_ssh "rm -rf $modlib" or
+    if (!defined($have_rsync)) {
+	$have_rsync = run_command("which rsync");
+    }
+
+    if ($have_rsync && !defined($has_rsync{$machine})) {
+	$has_rsync{$machine} = run_ssh("which rsync");
+    }
+
+    if ($have_rsync && $has_rsync{$machine}) {
+	run_command
+	    "rsync -az --delete-before $tmpdir$modlib/ $target:$modlib" or
+		dodie "failed to rsync modules";
+    } else {
+	my $modtar = "ktest-mods.tar.bz2";
+
+	run_ssh "rm -rf $modlib" or
 	dodie "failed to remove old mods: $modlib";
 
-    # would be nice if scp -r did not follow symbolic links
-    run_command "cd $tmpdir && tar -cjf $modtar lib/modules/$version" or
+	# would be nice if scp -r did not follow symbolic links
+	run_command "cd $tmpdir && tar -cjf $modtar lib/modules/$version" or
 	dodie "making tarball";
 
-    run_scp "$tmpdir/$modtar", "/tmp" or
+	run_scp "$tmpdir/$modtar", "/tmp" or
 	dodie "failed to copy modules";
 
-    unlink "$tmpdir/$modtar";
+	unlink "$tmpdir/$modtar";
 
-    run_ssh "'(cd / && tar xjf /tmp/$modtar)'" or
+	run_ssh "'(cd / && tar xjf /tmp/$modtar)'" or
 	dodie "failed to tar modules";
 
-    run_ssh "rm -f /tmp/$modtar";
-
+	run_ssh "rm -f /tmp/$modtar";
+    }
     do_post_install;
 }
 
-- 
1.7.4.1

