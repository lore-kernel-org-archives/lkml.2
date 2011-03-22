Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab1CVXky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 19:40:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:30689 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753531Ab1CVXkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 19:40:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,228,1299484800"; 
   d="scan'208";a="723117188"
Date: Tue, 22 Mar 2011 16:40:49 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [RFC v2] Checkpatch: add option to change warning return value.
Message-ID: <20110322234049.GA8083@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110322232246.GA7450@xanatos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a lot of warnings in checkpatch.pl that are rather subjective.
For instance, when a line is 81 characters long, and the patch submitter
is just cleaning up existing code, a maintainer may not care that
checkpatch.pl warns about the over 80-character line.  It should be up to
the maintainer what warnings they want to pay attention to.

Unfortunately, if you try to run checkpatch.pl as part of a git pre-commit
hook and a patch in a series being applied by git-am fails checkpatch.pl,
the whole process stops.  At that point I usually end up just disabling
that git hook, which means I don't see real errors in the patches.

Add an option to checkpatch.pl to print the warnings, but not return an
error code when the --lazy flag is present.  (Anyone with a better name
can pipe up, lazy just seemed to be the opposite to strict.)  This allows
the maintainer to view the warnings, but still allow the patch application
process to continue.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
---

Ok, I think this version works correctly.  My git hook returns an error
when the code to be submitted causes a checkpatch error, and doesn't
return an error code (but still prints the warnings) when the code to be
committed triggers checkpatch warnings, when --lazy is used.  This
version also changes the summary message to be unhappy when warnings are
found.

 scripts/checkpatch.pl |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 4c0383d..ad2d423 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -15,6 +15,7 @@ my $V = '0.31';
 use Getopt::Long qw(:config no_auto_abbrev);
 
 my $quiet = 0;
+my $lazy = 0;
 my $tree = 1;
 my $chk_signoff = 1;
 my $chk_patch = 1;
@@ -46,6 +47,7 @@ Options:
   --terse                    one line per report
   -f, --file                 treat FILE as regular source file
   --subjective, --strict     enable more subjective tests
+  --lazy                     print warnings, but don't return an error condition
   --root=PATH                PATH to the kernel tree root
   --no-summary               suppress the per-file summary
   --mailback                 only produce a report in case of warnings/errors
@@ -80,6 +82,7 @@ GetOptions(
 
 	'debug=s'	=> \%debug,
 	'test-only=s'	=> \$tst_only,
+	'lazy+'		=> \$lazy,
 	'h|help'	=> \$help,
 	'version'	=> \$help
 ) or help(1);
@@ -1109,7 +1112,9 @@ sub ERROR {
 }
 sub WARN {
 	if (report("WARNING: $_[0]\n")) {
-		our $clean = 0;
+		if ($lazy == 0) {
+			our $clean = 0;
+		}
 		our $cnt_warn++;
 	}
 }
@@ -2952,10 +2957,10 @@ sub process {
 		}
 	}
 
-	if ($clean == 1 && $quiet == 0) {
+	if ($clean == 1 && $quiet == 0 && ($lazy == 0 || $cnt_warn == 0)) {
 		print "$vname has no obvious style problems and is ready for submission.\n"
 	}
-	if ($clean == 0 && $quiet == 0) {
+	if (($clean == 0 && $quiet == 0) || ($lazy == 1 && $cnt_warn != 0)) {
 		print "$vname has style problems, please review.  If any of these errors\n";
 		print "are false positives report them to the maintainer, see\n";
 		print "CHECKPATCH in MAINTAINERS.\n";
-- 
1.7.1

