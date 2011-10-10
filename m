Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab1JJWcb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 18:32:31 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:48638 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751830Ab1JJWca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 18:32:30 -0400
Message-ID: <1318285950.2149.24.camel@Joe-Laptop>
Subject: [PATCH] checkpatch: Add a --strict check for utf-8 in commit logs
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>
Date: Mon, 10 Oct 2011 15:32:30 -0700
In-Reply-To: <20111010151027.bc397b85.akpm@linux-foundation.org>
References: <1318226216-5317-1-git-send-email-olof@lixom.net>
	 <1318266599.27825.12.camel@Joe-Laptop>
	 <20111010151027.bc397b85.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some find using utf-8 in commit logs inappropriate.

Some patch commit logs contain unintended utf-8 characters
when doing things like copy/pasting compilation output.

Look for the start of any commit log by skipping initial
lines that look like email headers and "From: " lines.

Stop looking for utf-8 at the first signature line.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Joe Perches <joe@perches.com>

---

I don't feel strongly that this patch should be applied,
that's why it's a --strict check and not on by default,
but Andrew Morton seems to want something like it...

 scripts/checkpatch.pl |   30 ++++++++++++++++++++++++++----
 1 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 3dfc471..04c0a55 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -240,9 +240,8 @@ our $NonptrType;
 our $Type;
 our $Declare;
 
-our $UTF8	= qr {
-	[\x09\x0A\x0D\x20-\x7E]              # ASCII
-	| [\xC2-\xDF][\x80-\xBF]             # non-overlong 2-byte
+our $NON_ASCII_UTF8	= qr{
+	[\xC2-\xDF][\x80-\xBF]               # non-overlong 2-byte
 	|  \xE0[\xA0-\xBF][\x80-\xBF]        # excluding overlongs
 	| [\xE1-\xEC\xEE\xEF][\x80-\xBF]{2}  # straight 3-byte
 	|  \xED[\x80-\x9F][\x80-\xBF]        # excluding surrogates
@@ -251,6 +250,11 @@ our $UTF8	= qr {
 	|  \xF4[\x80-\x8F][\x80-\xBF]{2}     # plane 16
 }x;
 
+our $UTF8	= qr{
+	[\x09\x0A\x0D\x20-\x7E]              # ASCII
+	| $NON_ASCII_UTF8
+}x;
+
 our $typeTypedefs = qr{(?x:
 	(?:__)?(?:u|s|be|le)(?:8|16|32|64)|
 	atomic_t
@@ -1330,6 +1334,9 @@ sub process {
 	my $signoff = 0;
 	my $is_patch = 0;
 
+	my $in_header_lines = 1;
+	my $in_commit_log = 0;		#Scanning lines before patch
+
 	our @report = ();
 	our $cnt_lines = 0;
 	our $cnt_error = 0;
@@ -1497,7 +1504,6 @@ sub process {
 		if ($line =~ /^diff --git.*?(\S+)$/) {
 			$realfile = $1;
 			$realfile =~ s@^([^/]*)/@@;
-
 		} elsif ($line =~ /^\+\+\+\s+(\S+)/) {
 			$realfile = $1;
 			$realfile =~ s@^([^/]*)/@@;
@@ -1536,6 +1542,7 @@ sub process {
 # Check the patch for a signoff:
 		if ($line =~ /^\s*signed-off-by:/i) {
 			$signoff++;
+			$in_commit_log = 0;
 		}
 
 # Check signature styles
@@ -1613,6 +1620,21 @@ sub process {
 			    "Invalid UTF-8, patch and commit message should be encoded in UTF-8\n" . $hereptr);
 		}
 
+# Check if it's the start of a commit log
+# (not a header line and we haven't seen the patch filename)
+		if ($in_header_lines && $realfile =~ /^$/ &&
+		    $rawline !~ /^(commit\b|from\b|\w+:).+$/i) {
+			$in_header_lines = 0;
+			$in_commit_log = 1;
+		}
+
+# Still not yet in a patch, check for any UTF-8
+		if ($in_commit_log && $realfile =~ /^$/ &&
+		    $rawline =~ /$NON_ASCII_UTF8/) {
+			CHK("UTF8_BEFORE_PATCH",
+			    "8-bit UTF-8 used in possible commit log\n" . $herecurr);
+		}
+
 # ignore non-hunk lines and lines being removed
 		next if (!$hunk_line || $line =~ /^-/);
 


