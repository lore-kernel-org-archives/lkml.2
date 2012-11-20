Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab2KTTRu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 14:17:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52973 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab2KTTRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 14:17:49 -0500
Date: Tue, 20 Nov 2012 19:17:39 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Joe Perches <joe@perches.com>
Cc: Constantine Shulyupin <const@makelinux.com>, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH V2] checkpatch: consolidate if (foo) bar(foo) checks and add
 debugfs_remove
Message-ID: <20121120191739.GG17797@dm>
References: <1353190818-10070-1-git-send-email-const@MakeLinux.com>
 <20121120142906.GD7955@dm>
 <1353422629.11235.10.camel@joe-AO722>
 <20121120144742.GG7955@dm>
 <CAE7jHC8LsxPaQHqy5-H4-wZp6q+_0s7arnPa3jG7R9x=tf_Oww@mail.gmail.com>
 <1353423503.11235.12.camel@joe-AO722>
 <20121120153751.GJ7955@dm>
 <1353426677.11235.15.camel@joe-AO722>
 <20121120163956.GD17797@dm>
 <1353436648.17387.3.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353436648.17387.3.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consolidate the if (foo) bar(foo) detectors into a single check.  Add
debugfs_remove and family.

Based on a patch by Constantine Shulyupin <const@MakeLinux.com>.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |   20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index ae01b90..a1e2471 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3239,20 +3239,12 @@ sub process {
 				$herecurr);
 		}
 
-# check for needless kfree() checks
-		if ($prevline =~ /\bif\s*\(([^\)]*)\)/) {
-			my $expr = $1;
-			if ($line =~ /\bkfree\(\Q$expr\E\);/) {
-				WARN("NEEDLESS_KFREE",
-				     "kfree(NULL) is safe this check is probably not required\n" . $hereprev);
-			}
-		}
-# check for needless usb_free_urb() checks
-		if ($prevline =~ /\bif\s*\(([^\)]*)\)/) {
-			my $expr = $1;
-			if ($line =~ /\busb_free_urb\(\Q$expr\E\);/) {
-				WARN("NEEDLESS_USB_FREE_URB",
-				     "usb_free_urb(NULL) is safe this check is probably not required\n" . $hereprev);
+# check for needless "if (<foo>) fn(<foo>)" uses
+		if ($prevline =~ /\bif\s*\(\s*($Lval)\s*\)/) {
+			my $expr = '\s*\(\s*' . quotemeta($1) . '\s*\)\s*;';
+			if ($line =~ /\b(kfree|usb_free_urb|debugfs_remove(?:_recursive)?)$expr/) {
+				WARN('NEEDLESS_IF',
+				     "$1(NULL) is safe this check is probably not required\n" . $hereprev);
 			}
 		}
 
-- 
1.7.10.4

