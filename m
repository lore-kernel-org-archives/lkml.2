Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297Ab2CTVGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 17:06:55 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:45475 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757729Ab2CTVGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 17:06:53 -0400
X-Originating-IP: 217.70.178.136
X-Originating-IP: 131.252.102.37
Date: Tue, 20 Mar 2012 14:06:44 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] checkpatch: Check for quoted strings broken across lines
Message-ID: <20120320210644.GA2493@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

checkpatch already makes an exception to the 80-column rule for quoted
strings, and Documentation/CodingStyle recommends not splitting quoted
strings across lines, because it breaks the ability to grep for the
string.  Rather than just permitting this, actively warn about quoted
strings split across lines.

Test case:

void context(void)
{
	struct { unsigned magic; const char *strdata; } foo[] = {
		{ 42, "these strings"
		      "do not produce warnings" },
		{ 256, "though perhaps"
		       "they should" },
	};
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

total: 0 errors, 1 warnings, 15 lines checked

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---

Resending now that the merge window has opened.

 scripts/checkpatch.pl |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index e3bfcbe..01a5e4b 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1737,6 +1737,21 @@ sub process {
 			     "line over 80 characters\n" . $herecurr);
 		}
 
+# Check for user-visible strings broken across lines, which breaks the ability
+# to grep for the string.  Limited to strings used as parameters (those
+# following an open parenthesis), which almost completely eliminates false
+# positives, as well as warning only once per parameter rather than once per
+# line of the string.  Make an exception when the previous string ends in a
+# newline (multiple lines in one string constant) or \n\t (common in inline
+# assembly to indent the instruction on the following line).
+		if ($line =~ /^\+\s*"/ &&
+		    $prevline =~ /"\s*$/ &&
+		    $prevline =~ /\(/ &&
+		    $prevrawline !~ /\\n(?:\\t)*"\s*$/) {
+			WARN("SPLIT_STRING",
+			     "quoted string split across lines\n" . $hereprev);
+		}
+
 # check for spaces before a quoted newline
 		if ($rawline =~ /^.*\".*\s\\n/) {
 			WARN("QUOTED_WHITESPACE_BEFORE_NEWLINE",
-- 
1.7.9

