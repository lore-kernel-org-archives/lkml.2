Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759123Ab2I1XdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 19:33:25 -0400
Received: from nm10.bullet.mail.sp2.yahoo.com ([98.139.91.80]:39969 "HELO
	nm10.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758911Ab2I1XdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 19:33:20 -0400
X-Yahoo-Newman-Id: 744554.52075.bm@omp1027.access.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: GWAgvJ4VM1nGfcOASgjikK9fuNmzGSi3.Ja_wgtcNIfTyJd
 6WSVw.yVU1_1noet.5V1MnJAFoNH10RwHpEMU3IfDQmEXO3DHtVJ5WnBu3hr
 p1V04wd2Y6nfhy9d1sl30LJWUQMbAogISCmP.rhRtxIfK1Pe3n9QoqEQbqWs
 Yuld0HdoyUXd77OKJIx.thx6aIcsLR4Xr3Y.K4etfRxF.rXF.SWgNZ4GIdAZ
 ZUsN_4AyPAe8Nw2fbytdDdorLYbSdTkFCV4ojqMqdPdkHnd8q1HMZriK2edM
 DThdtGZVMt1teYPl.Z.UMvLLhKpo8iklSVG4C1FtILo_fmtO4xOUGIYLBJcy
 BRXfJkK69gGf7z5yn1Y.pe4aD7orG1QwqDffKfg8xIctdrZj21HHcLvgMEle
 dgByCLZ1LnGgV.6m5HSOzqoCoC7Or1f8mXdhWjkwaDzdewxEyRStJ
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: Daniel Santos <daniel.santos@pobox.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>
Cc: Daniel Santos <daniel.santos@pobox.com>
Subject: [PATCH 2/3] kernel-doc: bugfix - empty line in Example section
Date: Fri, 28 Sep 2012 18:32:57 -0500
Message-Id: <1348875178-28490-3-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348875178-28490-1-git-send-email-daniel.santos@pobox.com>
References: <1348875178-28490-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you have a section named "Example" that contains an empty line,
attempting to generate htmldocs give you the error:

/path/Documentation/DocBook/kernel-api.xml:3455: parser error : Opening and ending tag mismatch: programlisting line 3449 and para
   </para><para>
          ^
/path/Documentation/DocBook/kernel-api.xml:3473: parser error : Opening and ending tag mismatch: para line 3467 and programlisting
</programlisting></informalexample>
                 ^
/path/Documentation/DocBook/kernel-api.xml:3678: parser error : Opening and ending tag mismatch: programlisting line 3672 and para
   </para><para>
          ^
/path/Documentation/DocBook/kernel-api.xml:3701: parser error : Opening and ending tag mismatch: para line 3690 and programlisting
</programlisting></informalexample>
                 ^
unable to parse
/path/Documentation/DocBook/kernel-api.xml

Essentially, the script attempts to close a <programlisting> with a
closing tag for a <para> block.  This patch corrects the problem by
simply not outputting anything extra when we're dumping pre-formatted
text, since the empty line will be rendered correctly anyway.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 scripts/kernel-doc |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index e6bc9db..2be2078 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -245,6 +245,7 @@ my $dohighlight = "";
 
 my $verbose = 0;
 my $output_mode = "man";
+my $output_preformatted = 0;
 my $no_doc_sections = 0;
 my %highlights = %highlights_man;
 my $blankline = $blankline_man;
@@ -486,7 +487,9 @@ sub output_highlight {
     }
     foreach $line (split "\n", $contents) {
 	if ($line eq ""){
-	    print $lineprefix, local_unescape($blankline);
+	    if (! $output_preformatted) {
+		print $lineprefix, local_unescape($blankline);
+	    }
 	} else {
 	    $line =~ s/\\\\\\/\&/g;
 	    if ($output_mode eq "man" && substr($line, 0, 1) eq ".") {
@@ -902,10 +905,12 @@ sub output_section_xml(%) {
 	print "<title>$section</title>\n";
 	if ($section =~ m/EXAMPLE/i) {
 	    print "<informalexample><programlisting>\n";
+	    $output_preformatted = 1;
 	} else {
 	    print "<para>\n";
 	}
 	output_highlight($args{'sections'}{$section});
+	$output_preformatted = 0;
 	if ($section =~ m/EXAMPLE/i) {
 	    print "</programlisting></informalexample>\n";
 	} else {
@@ -1208,10 +1213,12 @@ sub output_blockhead_xml(%) {
 	}
 	if ($section =~ m/EXAMPLE/i) {
 	    print "<example><para>\n";
+	    $output_preformatted = 1;
 	} else {
 	    print "<para>\n";
 	}
 	output_highlight($args{'sections'}{$section});
+	$output_preformatted = 0;
 	if ($section =~ m/EXAMPLE/i) {
 	    print "</para></example>\n";
 	} else {
@@ -1287,10 +1294,12 @@ sub output_function_gnome {
 	print "<simplesect>\n <title>$section</title>\n";
 	if ($section =~ m/EXAMPLE/i) {
 	    print "<example><programlisting>\n";
+	    $output_preformatted = 1;
 	} else {
 	}
 	print "<para>\n";
 	output_highlight($args{'sections'}{$section});
+	$output_preformatted = 0;
 	print "</para>\n";
 	if ($section =~ m/EXAMPLE/i) {
 	    print "</programlisting></example>\n";
-- 
1.7.3.4

