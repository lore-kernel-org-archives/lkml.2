Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab2BBUGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 15:06:31 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:46439 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab2BBUG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 15:06:29 -0500
X-Originating-IP: 217.70.178.141
X-Originating-IP: 50.43.15.19
Date: Thu, 2 Feb 2012 12:06:21 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org
Cc: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH] checkpatch: Check for quoted strings broken across lines
Message-ID: <20120202200621.GB9279@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation/CodingStyle recommends not splitting quoted strings across
lines, because it breaks the ability to grep for the string.  checkpatch
already makes an exception to the 80-column rule for quoted strings to
allow this.  Rather than just allowing it, actively warn about quoted
strings split across lines.

Test case:

void context(void)
{
        pr_err("this string"
               " should produce a warning\n");
        pr_err("this multi-line string\n"
               "should not produce a warning\n");
        asm ("this asm\n\t"
             "should not produce a warning");
}

Results of checkpatch on that test case:

WARNING: quoted string split across lines
+	       " should produce a warning\n");

total: 0 errors, 1 warnings, 9 lines checked

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 scripts/checkpatch.pl |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index e3bfcbe..ce4d740 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1737,6 +1737,17 @@ sub process {
 			     "line over 80 characters\n" . $herecurr);
 		}
 
+# Check for strings broken across lines (breaks greppability).  Make an
+# exception when the previous string ends in a newline (multiple lines in one
+# string constant) or \n\t (common in inline assembly to indent the instruction
+# on the following line).
+		if ($line =~ /^\+\s*"/ &&
+		    $prevline =~ /"\s*$/ &&
+		    $prevrawline !~ /\\n(?:\\t)*"\s*$/) {
+			WARN("SPLIT_STRING",
+			     "quoted string split across lines\n" . $herecurr);
+		}
+
 # check for spaces before a quoted newline
 		if ($rawline =~ /^.*\".*\s\\n/) {
 			WARN("QUOTED_WHITESPACE_BEFORE_NEWLINE",
-- 
1.7.9

