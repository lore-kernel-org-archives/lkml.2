Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab2LRVdW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 16:33:22 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:48745 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754203Ab2LRVdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 16:33:19 -0500
Message-ID: <1355866399.3297.2.camel@joe-AO722>
Subject: Re: [PATCH] scripts: add checkmaintainers.py
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Michal Marek <mmarek@suse.cz>, Cesar Eduardo Barros <cesarb@cesarb.net>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Date: Tue, 18 Dec 2012 13:33:19 -0800
In-Reply-To: <20121218204716.GJ31255@liondog.tnic>
References: <50CEF080.8010208@suse.cz> <20121217102714.GB31947@liondog.tnic>
	 <1355758544.13361.14.camel@joe-AO722> <20121217170011.GC31866@liondog.tnic>
	 <1355770579.13361.41.camel@joe-AO722> <1355771383.13361.44.camel@joe-AO722>
	 <20121218182838.GF31255@liondog.tnic> <1355859281.30366.29.camel@joe-AO722>
	 <20121218203159.GI31255@liondog.tnic> <1355862997.30366.36.camel@joe-AO722>
	 <20121218204716.GJ31255@liondog.tnic>
Content-Type: multipart/mixed; boundary="=-8G+dVzka4wcc8jkXKYvC"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8G+dVzka4wcc8jkXKYvC
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

On Tue, 2012-12-18 at 21:47 +0100, Borislav Petkov wrote:
> Oh well, enough games for today.

Maybe try this tomorrow?

--=-8G+dVzka4wcc8jkXKYvC
Content-Type: text/x-patch; name="cp.diff"; charset="ISO-8859-1"
Content-Description: 
Content-Disposition: attachment; filename="cp.diff"
Content-Transfer-Encoding: 7bit

 scripts/checkpatch.pl |   40 ++++++++++++++++++++++++++++++++++++++--
 1 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 725c596..adc8de1 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1317,6 +1317,19 @@ sub check_absolute_file {
 	}
 }
 
+sub check_filenames_changed {
+    my ($oldfile, $newfile, $herecurr) = @_;
+
+    return if ($oldfile eq $newfile);
+
+    my $action = "renames $oldfile to $newfile";
+    $action = "creates file $newfile" if ($oldfile =~ m@dev/null@);
+    $action = "deletes file $oldfile" if ($newfile =~ m@dev/null@);
+
+    CHK("MAINTAINERS",
+	"Patch $action, update MAINTAINERS?\n" . $herecurr);
+}
+
 sub pos_last_openparen {
 	my ($line) = @_;
 
@@ -1379,6 +1392,9 @@ sub process {
 	# Trace the real file/line as we go.
 	my $realfile = '';
 	my $realline = 0;
+	my $modifiedfile = '';
+	my $gitrealfile = '';
+	my $gitmodifiedfile = '';
 	my $realcnt = 0;
 	my $here = '';
 	my $in_comment = 0;
@@ -1536,10 +1552,17 @@ sub process {
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
@@ -1556,6 +1579,19 @@ sub process {
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
 

--=-8G+dVzka4wcc8jkXKYvC--

