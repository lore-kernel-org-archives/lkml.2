Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab2KQWU0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 17:20:26 -0500
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:39044 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752255Ab2KQWUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 17:20:25 -0500
From: Constantine Shulyupin <const@MakeLinux.com>
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        Andy Whitcroft <apw@canonical.com>, joe@perches.com
Cc: Constantine Shulyupin <const@MakeLinux.com>
Subject: [PATCH v4] checkpatch: debugfs_remove() can take NULL
Date: Sun, 18 Nov 2012 00:20:18 +0200
Message-Id: <1353190818-10070-1-git-send-email-const@MakeLinux.com>
X-Mailer: git-send-email 1.7.9.5
X-Identified-User: {1470:box668.bluehost.com:makelinu:makelinux.net} {sentby:smtp auth 77.126.70.233 authed with poster@makelinux.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Constantine Shulyupin <const@MakeLinux.com>

debugfs_remove() and  debugfs_remove_recursive() can take a NULL, so let's check and warn about that.

Changes since v3, as Joe Perches suggested:
- removed redundant check

Changes since v2, as Joe Perches suggested:
- match whitespace around argument

Changes since v1, as Joe Perches suggested:
- added debugfs_remove_recursive
- all tests for patterns are "if (a) xxx(a)" are consolidated

Signed-off-by: Constantine Shulyupin <const@MakeLinux.com>
---
 scripts/checkpatch.pl |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index f18750e..76ad9f2 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3213,21 +3213,25 @@ sub process {
 				$herecurr);
 		}
 
+# check for needless "if (<foo>) fn(<foo>)" uses
+		if ($prevline =~ /\bif\s*\(\s*($Lval)\s*\)/) {
+			my $expr = '\s*\(\s*' . quotemeta($1) . '\s*\)\s*;';
+
 # check for needless kfree() checks
-		if ($prevline =~ /\bif\s*\(([^\)]*)\)/) {
-			my $expr = $1;
-			if ($line =~ /\bkfree\(\Q$expr\E\);/) {
+			if ($line =~ /\bkfree$expr/) {
 				WARN("NEEDLESS_KFREE",
 				     "kfree(NULL) is safe this check is probably not required\n" . $hereprev);
 			}
-		}
 # check for needless usb_free_urb() checks
-		if ($prevline =~ /\bif\s*\(([^\)]*)\)/) {
-			my $expr = $1;
-			if ($line =~ /\busb_free_urb\(\Q$expr\E\);/) {
+			if ($line =~ /\busb_free_urb$expr/) {
 				WARN("NEEDLESS_USB_FREE_URB",
 				     "usb_free_urb(NULL) is safe this check is probably not required\n" . $hereprev);
 			}
+# check for needless debugfs_remove() and debugfs_remove_recursive*() checks
+			if ($line =~ /\b(debugfs_remove(?:_recursive)?)$expr/) {
+				WARN("NEEDLESS_DEBUGFS_REMOVE",
+				     "$1(NULL) is safe this check is probably not required\n" . $hereprev);
+			}
 		}
 
 # prefer usleep_range over udelay
-- 
1.7.9.5

