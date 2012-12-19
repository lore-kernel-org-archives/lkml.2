Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765Ab2LSRnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 12:43:51 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:51616 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754569Ab2LSRnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 12:43:42 -0500
Message-ID: <1355939022.7430.4.camel@joe-AO722>
Subject: Re: [PATCH] scripts: add checkmaintainers.py
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Michal Marek <mmarek@suse.cz>, Cesar Eduardo Barros <cesarb@cesarb.net>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Date: Wed, 19 Dec 2012 09:43:42 -0800
In-Reply-To: <20121219150732.GD24895@liondog.tnic>
References: <1355758544.13361.14.camel@joe-AO722>
	 <20121217170011.GC31866@liondog.tnic> <1355770579.13361.41.camel@joe-AO722>
	 <1355771383.13361.44.camel@joe-AO722> <20121218182838.GF31255@liondog.tnic>
	 <1355859281.30366.29.camel@joe-AO722> <20121218203159.GI31255@liondog.tnic>
	 <1355862997.30366.36.camel@joe-AO722> <20121218204716.GJ31255@liondog.tnic>
	 <1355866399.3297.2.camel@joe-AO722> <20121219150732.GD24895@liondog.tnic>
Content-Type: multipart/mixed; boundary="=-7hNZYUHMxRMwjEE3cXC2"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-7hNZYUHMxRMwjEE3cXC2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

On Wed, 2012-12-19 at 16:07 +0100, Borislav Petkov wrote:
> On Tue, Dec 18, 2012 at 01:33:19PM -0800, Joe Perches wrote:
> > On Tue, 2012-12-18 at 21:47 +0100, Borislav Petkov wrote:
> > > Oh well, enough games for today.
> > 
> > Maybe try this tomorrow?
> 
> $ git diff --cached HEAD -- | ./scripts/checkpatch.pl --strict -
> Use of uninitialized value $herecurr in concatenation (.) or string at ./scripts/checkpatch.pl line 1333.
> CHECK: Patch renames arch/x86/Kconfig to arch/x86/Kconfig.old, update MAINTAINERS?
> 
> yes, except the warning.
> 
> $ git commit -a
> arch/x86/Kconfig.old:451: trailing whitespace.
> +         Internet Device(MID) platform.

That's the output from a:
$ git diff-index --check --cached HEAD --

> This doesn't seem to work although I have the same pre-commit hook as
> the above line: " git diff --cached HEAD -- | ./scripts/checkpatch.pl --strict -"

perhaps you need an exec prefix

When I use this file
$ cat .git/hooks/pre-commit
exec  git diff --cached HEAD -- | ./scripts/checkpatch.pl --strict -
$

it works fine.

Here's the latest checkpatch diff without that
concatenation warning for you to try.



--=-7hNZYUHMxRMwjEE3cXC2
Content-Disposition: attachment; filename="cp_boris.diff"
Content-Type: text/x-patch; name="cp_boris.diff"; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

 scripts/checkpatch.pl |   40 ++++++++++++++++++++++++++++++++++++++--
 1 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 1d6e4c5..fe5750e 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1321,6 +1321,19 @@ sub check_absolute_file {
 	}
 }
 
+sub check_filenames_changed {
+    my ($oldfile, $newfile) = @_;
+
+    return if ($oldfile eq $newfile);
+
+    my $action = "renames $oldfile to $newfile";
+    $action = "creates file $newfile" if ($oldfile =~ m@dev/null@);
+    $action = "deletes file $oldfile" if ($newfile =~ m@dev/null@);
+
+    CHK("MAINTAINERS",
+	"Patch $action, update MAINTAINERS?\n");
+}
+
 sub pos_last_openparen {
 	my ($line) = @_;
 
@@ -1383,6 +1396,9 @@ sub process {
 	# Trace the real file/line as we go.
 	my $realfile = '';
 	my $realline = 0;
+	my $modifiedfile = '';
+	my $gitrealfile = '';
+	my $gitmodifiedfile = '';
 	my $realcnt = 0;
 	my $here = '';
 	my $in_comment = 0;
@@ -1542,10 +1558,17 @@ sub process {
 		$here = "#$realline: " if ($file);
 
 		# extract the filename as it passes
-		if ($line =~ /^diff --git.*?(\S+)$/) {
-			$realfile = $1;
+		if ($line =~ /^diff --git\s+(\S+)\s+(\S+)$/) {
+			$modifiedfile = $1;
+			$realfile = $2;
+			$modifiedfile =~ s@^([^/]*)/@@;
 			$realfile =~ s@^([^/]*)/@@;
+
+			$gitmodifiedfile = $modifiedfile;
+			$gitrealfile = $realfile;
 			$in_commit_log = 0;
+			check_filenames_changed($gitmodifiedfile, $gitrealfile);
+
 		} elsif ($line =~ /^\+\+\+\s+(\S+)/) {
 			$realfile = $1;
 			$realfile =~ s@^([^/]*)/@@;
@@ -1562,6 +1585,19 @@ sub process {
 				ERROR("MODIFIED_INCLUDE_ASM",
 				      "do not modify files in include/asm, change architecture specific files in include/asm-<architecture>\n" . "$here$rawline\n");
 			}
+
+			if ($modifiedfile ne $gitmodifiedfile ||
+			    $realfile ne $gitrealfile) {
+				check_filenames_changed($modifiedfile, $realfile);
+				$gitmodifiedfile = '';
+				$gitrealfile = '';
+			}
+
+			next;
+		} elsif ($line =~ /^\-\-\-\s+(\S+)/) {
+			$modifiedfile = $1;
+			$modifiedfile =~ s@^([^/]*)/@@;
+			$in_commit_log = 0;
 			next;
 		}
 

--=-7hNZYUHMxRMwjEE3cXC2--

