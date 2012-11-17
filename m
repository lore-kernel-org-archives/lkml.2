Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab2KQSy3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 13:54:29 -0500
Received: from oproxy9.bluehost.com ([69.89.24.6]:46973 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751996Ab2KQSy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 13:54:28 -0500
From: Constantine Shulyupin <const@MakeLinux.com>
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        Andy Whitcroft <apw@canonical.com>, joe@perches.com
Cc: Constantine Shulyupin <const@MakeLinux.com>
Subject: [PATCH v3] checkpatch: debugfs_remove() can take NULL
Date: Sat, 17 Nov 2012 20:54:22 +0200
Message-Id: <1353178462-3868-1-git-send-email-const@MakeLinux.com>
X-Mailer: git-send-email 1.7.9.5
X-Identified-User: {1470:box668.bluehost.com:makelinu:makelinux.net} {sentby:smtp auth 77.126.70.233 authed with poster@makelinux.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Constantine Shulyupin <const@MakeLinux.com>

debugfs_remove() and  debugfs_remove_recursive() can take a NULL, so let's check and warn about that.

Changes since v2, as Joe Perches suggested:
- match whitespace around argument

Changes since v1, as Joe Perches suggested:
- added debugfs_remove_recursive
- all tests for patterns are "if (a) xxx(a)" are consolidates

Signed-off-by: Constantine Shulyupin <const@MakeLinux.com>
---
 scripts/checkpatch.pl |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index f18750e..c041e97 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3213,21 +3213,30 @@ sub process {
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
+# check for needless debugfs_remove_recursive() and debugfs_remove_recursive*() checks
+			if ($line =~ /\b(debugfs_remove_recursive(?:_recursive)?)$expr/) {
+				WARN("NEEDLESS_DEBUGFS_REMOVE_RECURSIVE",
+				     "$1(NULL) is safe this check is probably not required\n" . $hereprev);
+			}
 		}
 
 # prefer usleep_range over udelay
-- 
1.7.9.5

