Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab1CVXNQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 19:13:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:35083 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430Ab1CVXNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 19:13:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,228,1299484800"; 
   d="scan'208";a="616459202"
Date: Tue, 22 Mar 2011 16:13:10 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [RFC] checkpatch: add option to change warning return value.
Message-ID: <20110322231310.GA7338@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
 scripts/checkpatch.pl |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 4c0383d..4519b5b 100755
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
@@ -1096,6 +1099,9 @@ sub report {
 
 	push(our @report, $line);
 
+	if ($lazy == 1) {
+		return 0;
+	}
 	return 1;
 }
 sub report_dump {
-- 
1.7.1

