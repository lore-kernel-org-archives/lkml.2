Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821Ab2IYXbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 19:31:55 -0400
Received: from nm19-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.216]:36651 "HELO
	nm19-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752632Ab2IYXbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 19:31:53 -0400
X-Yahoo-Newman-Id: 788661.91656.bm@omp1010.access.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: fNmyMcwVM1ltfNmzOIa5cQ5JmugJji366AMmN_OXXDSWFeJ
 sKGAM2L3EIJDGhpPLfGu8lAIEKblUKYG39AmzxR4ugP9pdpZ3mJTk64pnAyy
 k0VRBNzhxKVtAS3fhnB88GGswU87TZYYOhduUo.kLda.MpBhLgERIBuGSogW
 65PbuxaKSPM61Jv.Znc3nJ9W9nI6F3z.scKKpf3eJoMQiOsIVqwCbl0Gp_pa
 GNePz5HhJNO9Xd2x3YumrsFJkxwEzujGw65_zDX0ZW7Zxus8JfNM0CDQB10p
 5swLBlAKnPGuwIS3pplR8j0b3FEu8qe5yiKKjWou9sf3dMxQDzATpKaDljns
 PQkYwmCLLuhmCklXwS0Y_SnVjp6BPbSgx.C0FyIYjlCXlAVDQGnZ1dXc5z3F
 lMilCOh8Umb4h0xqXzyBXYmPrpmYYdi5ujSLK_THhLuCozjW8kKdZesitMag
 UzOyd4R0vhWjjblrP.VTJobpfPHIhbzA5Qb9iHWT9NwDADCEziDOt
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: Daniel Santos <daniel.santos@pobox.com>
To: Randy Dunlap <rdunlap@xenotime.net>, Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Richard Weinberger <richard@nod.at>,
        LKML <linux-kernel@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>
Cc: Daniel Santos <daniel.santos@pobox.com>
Subject: [PATCH v5 17/25] kernel-doc: Don't mangle whitespace in Example section
Date: Tue, 25 Sep 2012 18:31:47 -0500
Message-Id: <1348615907-10524-1-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
References: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A section with the name "Example" (case-insensitive) has a special
meaning to kernel-doc.  These sections are output using mono-type fonts.
However, leading whitespace is stripped, thus robbing a lot of meaning
from this, as indented code examples will be mangled.

This patch preserves the leading whitespace for "Example" sections.
More accurately, it preserves it for all sections, but removes it later
if the section isn't an "Example" section.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 scripts/kernel-doc |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 69efb2f..976e28c 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -281,9 +281,10 @@ my $doc_special = "\@\%\$\&";
 my $doc_start = '^/\*\*\s*$'; # Allow whitespace at end of comment start.
 my $doc_end = '\*/';
 my $doc_com = '\s*\*\s*';
+my $doc_com_body = '\s*\* ?';
 my $doc_decl = $doc_com . '(\w+)';
 my $doc_sect = $doc_com . '([' . $doc_special . ']?[\w\s]+):(.*)';
-my $doc_content = $doc_com . '(.*)';
+my $doc_content = $doc_com_body . '(.*)';
 my $doc_block = $doc_com . 'DOC:\s*(.*)?';
 
 my %constants;
@@ -460,6 +461,9 @@ sub output_highlight {
 #   print STDERR "contents af:$contents\n";
 
     foreach $line (split "\n", $contents) {
+	if (! $output_preformatted) {
+	    $line =~ s/^\s*//;
+	}
 	if ($line eq ""){
 	    if (! $output_preformatted) {
 		print $lineprefix, local_unescape($blankline);
@@ -2084,7 +2088,7 @@ sub process_file($) {
 		    $descr= $1;
 		    $descr =~ s/^\s*//;
 		    $descr =~ s/\s*$//;
-		    $descr =~ s/\s+/ /;
+		    $descr =~ s/\s+/ /g;
 		    $declaration_purpose = xml_escape($descr);
 		    $in_purpose = 1;
 		} else {
@@ -2176,6 +2180,7 @@ sub process_file($) {
 		    # Continued declaration purpose
 		    chomp($declaration_purpose);
 		    $declaration_purpose .= " " . xml_escape($1);
+		    $declaration_purpose =~ s/\s+/ /g;
 		} else {
 		    $contents .= $1 . "\n";
 		}
-- 
1.7.3.4

