Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751224Ab2BCF1j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 00:27:39 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:38266 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab2BCF1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 00:27:38 -0500
X-Originating-IP: 217.70.178.131
X-Originating-IP: 50.43.15.19
Date: Thu, 2 Feb 2012 21:27:28 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org
Cc: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Nick Bowler <nbowler@elliptictech.com>
Subject: [PATCH] checkpatch: Check for quoted strings broken across lines
Message-ID: <20120203052727.GA15035@leaf>
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
#10: FILE: test.c:10:
+	       " should produce a warning\n");

total: 0 errors, 1 warnings, 15 lines checked

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---

v2: Add the "after open parenthesis" heuristic which almost completely
eliminates non-user-visible strings, leaving only 12 in the entire
kernel, versus thousands of correct matches.  Change "breaks
greppability" to "breaks the ability to grep for the string".

 scripts/checkpatch.pl |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index e3bfcbe..b898df4 100755
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
+			     "quoted string split across lines\n" . $herecurr);
+		}
+
 # check for spaces before a quoted newline
 		if ($rawline =~ /^.*\".*\s\\n/) {
 			WARN("QUOTED_WHITESPACE_BEFORE_NEWLINE",
-- 
1.7.9

