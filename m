Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab2DPJR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 05:17:27 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33862 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab2DPJR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 05:17:26 -0400
Date: Mon, 16 Apr 2012 11:17:20 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Subject: Please fix or revert: [PATCH] checkpatch: add --strict tests for
 braces, comments and casts
Message-ID: <20120416091719.GA4113@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This recent checkpatch commit, added in v3.4-rc1:

  aad4f6149831 checkpatch: add --strict tests for braces, comments and casts

made the default checkpatch run complain about the following 
perfectly fine multi-line comment block:

+               rdp->qlen_lazy = 0;
+               rdp->qlen = 0;
+
+               /*
+                * Adopt all callbacks.  The outgoing CPU was in no shape
+                * to advance them, so make them all go through a full
+                * grace period.
+                */
+               *receive_rdp->nxttail[RCU_NEXT_TAIL] = rdp->nxtlist;

With:

 CHECK: Don't begin block comments with only a /* line, use /* comment...

#80: FILE: kernel/rcutree.c:1428:
+
+		/*

Which is an obviously bogus warning: the comment is perfectly 
fine and it has the form that Documentation/CodingStyle 
specifically recommends:

|                 Chapter 8: Commenting
|
| [...]
|
| The preferred style for long (multi-line) comments is:
|
|        /*
|         * This is the preferred style for multi-line
|         * comments in the Linux kernel source code.
|         * Please use it consistently.
|         *
|         * Description:  A column of asterisks on the left side,
|         * with beginning and ending almost-blank lines.
|         */
|

Please turn this new warning off by default, or fix the check, 
or revert it. (The revert below applies cleanly on top of latest 
-git and solves the warning for me.)

Thanks,

	Ingo

This reverts commit aad4f61498314d41d047ea2161b7bd7237b72d33.

Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 scripts/checkpatch.pl |   40 ++++++++--------------------------------
 1 files changed, 8 insertions(+), 32 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index de639ee..6217093 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1864,17 +1864,6 @@ sub process {
 			}
 		}
 
-		if ($line =~ /^\+.*\*[ \t]*\)[ \t]+/) {
-			CHK("SPACING",
-			    "No space is necessary after a cast\n" . $hereprev);
-		}
-
-		if ($rawline =~ /^\+[ \t]*\/\*[ \t]*$/ &&
-		    $prevrawline =~ /^\+[ \t]*$/) {
-			CHK("BLOCK_COMMENT_STYLE",
-			    "Don't begin block comments with only a /* line, use /* comment...\n" . $hereprev);
-		}
-
 # check for spaces at the beginning of a line.
 # Exceptions:
 #  1) within comments
@@ -2987,8 +2976,7 @@ sub process {
 			#print "chunks<$#chunks> linenr<$linenr> endln<$endln> level<$level>\n";
 			#print "APW: <<$chunks[1][0]>><<$chunks[1][1]>>\n";
 			if ($#chunks > 0 && $level == 0) {
-				my @allowed = ();
-				my $allow = 0;
+				my $allowed = 0;
 				my $seen = 0;
 				my $herectx = $here . "\n";
 				my $ln = $linenr - 1;
@@ -2999,7 +2987,6 @@ sub process {
 					my ($whitespace) = ($cond =~ /^((?:\s*\n[+-])*\s*)/s);
 					my $offset = statement_rawlines($whitespace) - 1;
 
-					$allowed[$allow] = 0;
 					#print "COND<$cond> whitespace<$whitespace> offset<$offset>\n";
 
 					# We have looked at and allowed this specific line.
@@ -3012,34 +2999,23 @@ sub process {
 
 					$seen++ if ($block =~ /^\s*{/);
 
-					#print "cond<$cond> block<$block> allowed<$allowed[$allow]>\n";
+					#print "cond<$cond> block<$block> allowed<$allowed>\n";
 					if (statement_lines($cond) > 1) {
 						#print "APW: ALLOWED: cond<$cond>\n";
-						$allowed[$allow] = 1;
+						$allowed = 1;
 					}
 					if ($block =~/\b(?:if|for|while)\b/) {
 						#print "APW: ALLOWED: block<$block>\n";
-						$allowed[$allow] = 1;
+						$allowed = 1;
 					}
 					if (statement_block_size($block) > 1) {
 						#print "APW: ALLOWED: lines block<$block>\n";
-						$allowed[$allow] = 1;
+						$allowed = 1;
 					}
-					$allow++;
 				}
-				if ($seen) {
-					my $sum_allowed = 0;
-					foreach (@allowed) {
-						$sum_allowed += $_;
-					}
-					if ($sum_allowed == 0) {
-						WARN("BRACES",
-						     "braces {} are not necessary for any arm of this statement\n" . $herectx);
-					} elsif ($sum_allowed != $allow &&
-						 $seen != $allow) {
-						CHK("BRACES",
-						    "braces {} should be used on all arms of this statement\n" . $herectx);
-					}
+				if ($seen && !$allowed) {
+					WARN("BRACES",
+					     "braces {} are not necessary for any arm of this statement\n" . $herectx);
 				}
 			}
 		}
