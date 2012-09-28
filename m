Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964886Ab2I1Xdi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 19:33:38 -0400
Received: from nm3.bullet.mail.sp2.yahoo.com ([98.139.91.73]:30349 "HELO
	nm3.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759072Ab2I1XdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 19:33:23 -0400
X-Yahoo-Newman-Id: 318041.11876.bm@omp1022.access.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Qbm4kpcVM1nEDmSshPNTi2WtbYEFuny6nxkAz7Vua4E06Ct
 aDRkoKfPUXPG70U8K0lcurlBRl1d2Tmj3qsbCqY3Yd9iv5nQvpE2qiU41HbM
 ilQkc9sZQib1ms6aSojPGocMD1WfIhYAQ11XOkGTEfWFnW_j7tG4qa9I3H0p
 gaMnvvrhTk.w1HI6Rbu8q_ikwZoitL2pS0HX3fbrig9R6mgHKWMnF3Unjbaf
 BW5iAyOV26GlFZDOOsnWKEl5.PVI4deDuzfQL_zdvxEjtaodTMgDL0OUrjVL
 YwasaSPQZ9D9eVEFTQPPu_9ZLuBDXklI0Emw9pF9eK5LnFZyazzqPP32aPQi
 z1AsSrQcNpNLGcavxY3z2uSE0eOO3q0pJJKjZTGFhAXr1G7AXblpxTS4sQ44
 1KLZM.bmETliglVxzC3HCsaxTHgjAayOP0HS54ddtCV2F1cIS3om2gzXORbq
 OBx0nxUMSLl8555cb7sNpgSk1RA63MBqn6urt4h5gEpazWtMQefk-
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: Daniel Santos <daniel.santos@pobox.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>
Cc: Daniel Santos <daniel.santos@pobox.com>
Subject: [PATCH 3/3] kernel-doc: Don't mangle whitespace in Example section
Date: Fri, 28 Sep 2012 18:32:58 -0500
Message-Id: <1348875178-28490-4-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348875178-28490-1-git-send-email-daniel.santos@pobox.com>
References: <1348875178-28490-1-git-send-email-daniel.santos@pobox.com>
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
index 2be2078..46e7aff 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -296,9 +296,10 @@ my $doc_special = "\@\%\$\&";
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
@@ -486,6 +487,9 @@ sub output_highlight {
 	$contents =~ s/\s+$//;
     }
     foreach $line (split "\n", $contents) {
+	if (! $output_preformatted) {
+	    $line =~ s/^\s*//;
+	}
 	if ($line eq ""){
 	    if (! $output_preformatted) {
 		print $lineprefix, local_unescape($blankline);
@@ -2344,7 +2348,7 @@ sub process_file($) {
 		    $descr= $1;
 		    $descr =~ s/^\s*//;
 		    $descr =~ s/\s*$//;
-		    $descr =~ s/\s+/ /;
+		    $descr =~ s/\s+/ /g;
 		    $declaration_purpose = xml_escape($descr);
 		    $in_purpose = 1;
 		} else {
@@ -2436,6 +2440,7 @@ sub process_file($) {
 		    # Continued declaration purpose
 		    chomp($declaration_purpose);
 		    $declaration_purpose .= " " . xml_escape($1);
+		    $declaration_purpose =~ s/\s+/ /g;
 		} else {
 		    $contents .= $1 . "\n";
 		}
-- 
1.7.3.4

