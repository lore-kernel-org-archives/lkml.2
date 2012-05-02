Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085Ab2EBAyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 20:54:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8272 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756111Ab2EBAyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 20:54:18 -0400
X-Authority-Analysis: v=2.0 cv=T/EOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=eqDETgwSSdwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=lqO4YY3mrN0Bq_cNv1UA:9 a=RlzdXDXsfuA9bhvFPu4A:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=ZWHlxdTANv_F9W9w:21 a=Ew3lk9S_y-LDrS0u:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120502005415.978821492@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 01 May 2012 20:44:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 2/2] ktest: Fix reboot on success stopping all reboots
References: <20120502004439.965120020@goodmis.org>
Content-Disposition: inline; filename=0002-ktest-Fix-reboot-on-success-stopping-all-reboots.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The change to let individual tests decide to reboot the machine on
success of the entire test also prevented errors from rebooting
when an error was detected.

The "no_reboot" variable was only cleared if the test had
reboot_on_success set. But the no_reboot variable also prevents the test
rebooting when an error was detected even when REBOOT_ON_ERROR was set.

Add a new "reboot_success" variable that is used to determine if the
test should reboot on success and not touch the no_reboot variable.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index d2ede59..4915408 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -183,6 +183,9 @@ my %force_config;
 # do not force reboots on config problems
 my $no_reboot = 1;
 
+# reboot on success
+my $reboot_success = 0;
+
 my %option_map = (
     "MACHINE"			=> \$machine,
     "SSH_USER"			=> \$ssh_user,
@@ -3469,6 +3472,7 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
 
     # Do not reboot on failing test options
     $no_reboot = 1;
+    $reboot_success = 0;
 
     $iteration = $i;
 
@@ -3554,9 +3558,11 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
 	    die "failed to checkout $checkout";
     }
 
+    $no_reboot = 0;
+
     # A test may opt to not reboot the box
     if ($reboot_on_success) {
-	$no_reboot = 0;
+	$reboot_success = 1;
     }
 
     if ($test_type eq "bisect") {
@@ -3600,7 +3606,7 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
 
 if ($opt{"POWEROFF_ON_SUCCESS"}) {
     halt;
-} elsif ($opt{"REBOOT_ON_SUCCESS"} && !do_not_reboot) {
+} elsif ($opt{"REBOOT_ON_SUCCESS"} && !do_not_reboot && $reboot_success) {
     reboot_to_good;
 } elsif (defined($switch_to_good)) {
     # still need to get to the good kernel
-- 
1.7.9.5


