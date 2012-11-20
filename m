Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab2KTPh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 10:37:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51519 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab2KTPh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 10:37:56 -0500
Date: Tue, 20 Nov 2012 15:37:51 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Joe Perches <joe@perches.com>
Cc: Constantine Shulyupin <const@makelinux.com>, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: [PATCH] checkpatch: consolidate if (foo) bar(foo) checks and add
 debugfs_remove
Message-ID: <20121120153751.GJ7955@dm>
References: <1353190818-10070-1-git-send-email-const@MakeLinux.com>
 <20121120142906.GD7955@dm>
 <1353422629.11235.10.camel@joe-AO722>
 <20121120144742.GG7955@dm>
 <CAE7jHC8LsxPaQHqy5-H4-wZp6q+_0s7arnPa3jG7R9x=tf_Oww@mail.gmail.com>
 <1353423503.11235.12.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353423503.11235.12.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consolidate the if (foo) bar(foo) detectors into a single check.  Add
debugfs_remove and family.

Based on a patch by Constantine Shulyupin <const@MakeLinux.com>.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

This is a fully merged version as the fix patch was bigger than the
whole merged patch and this is much clearer as to purpose.  Hope that
makes sense.
	
-apw

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index ae01b90..e83a137 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3239,20 +3239,16 @@ sub process {
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
-				WARN("NEEDLESS_KFREE",
-				     "kfree(NULL) is safe this check is probably not required\n" . $hereprev);
-			}
-		}
 # check for needless usb_free_urb() checks
-		if ($prevline =~ /\bif\s*\(([^\)]*)\)/) {
-			my $expr = $1;
-			if ($line =~ /\busb_free_urb\(\Q$expr\E\);/) {
-				WARN("NEEDLESS_USB_FREE_URB",
-				     "usb_free_urb(NULL) is safe this check is probably not required\n" . $hereprev);
+# check for needless debugfs_remove() and debugfs_remove_recursive*() checks
+			if ($line =~ /\b(kfree|usb_free_urb|debugfs_remove(?:_recursive)?)$expr/) {
+				WARN('NEEDLESS_IF',
+				     "$1(NULL) is safe this check is probably not required\n" . $hereprev);
 			}
 		}
 
-- 
1.7.10.4

