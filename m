Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab1K1Pon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 10:44:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54194 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab1K1Pm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 10:42:59 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 04/11] checkpatch: optimise statement scanner when mid-statement
Date: Mon, 28 Nov 2011 15:42:46 +0000
Message-Id: <1322494973-29225-5-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1322494973-29225-1-git-send-email-apw@canonical.com>
References: <1322494973-29225-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the middle of a long definition or similar, there is no possibility
of finding a smaller sub-statement.  Optimise this case by skipping
statement aquirey where there are no starts of statement (open brace
'{' or semi-colon ';').  We are likely to scan slightly more than needed
still but this is safest.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |   22 ++++++++++++++++++++--
 1 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 6dad5dd..74d3d65 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1372,6 +1372,7 @@ sub process {
 	my %suppress_ifbraces;
 	my %suppress_whiletrailers;
 	my %suppress_export;
+	my $suppress_statement = 0;
 
 	# Pre-scan the patch sanitizing the lines.
 	# Pre-scan the patch looking for any __setup documentation.
@@ -1481,6 +1482,7 @@ sub process {
 			%suppress_ifbraces = ();
 			%suppress_whiletrailers = ();
 			%suppress_export = ();
+			$suppress_statement = 0;
 			next;
 
 # track the line number as we move through the hunk, note that
@@ -1805,13 +1807,23 @@ sub process {
 # Check for potential 'bare' types
 		my ($stat, $cond, $line_nr_next, $remain_next, $off_next,
 		    $realline_next);
-		if ($realcnt && $line =~ /.\s*\S/) {
+#print "LINE<$line>\n";
+		if ($linenr >= $suppress_statement &&
+		    $realcnt && $line =~ /.\s*\S/) {
 			($stat, $cond, $line_nr_next, $remain_next, $off_next) =
 				ctx_statement_block($linenr, $realcnt, 0);
 			$stat =~ s/\n./\n /g;
 			$cond =~ s/\n./\n /g;
 
-#print "stat<$stat>\n";
+#print "linenr<$linenr> <$stat>\n";
+			# If this statement has no statement boundaries within
+			# it there is no point in retrying a statement scan
+			# until we hit end of it.
+			my $frag = $stat; $frag =~ s/;+\s*$//;
+			if ($frag !~ /(?:{|;)/) {
+#print "skip<$line_nr_next>\n";
+				$suppress_statement = $line_nr_next;
+			}
 
 			# Find the real next line.
 			$realline_next = $line_nr_next;
@@ -1938,6 +1950,9 @@ sub process {
 
 # Check relative indent for conditionals and blocks.
 		if ($line =~ /\b(?:(?:if|while|for)\s*\(|do\b)/ && $line !~ /^.\s*#/ && $line !~ /\}\s*while\s*/) {
+			($stat, $cond, $line_nr_next, $remain_next, $off_next) =
+				ctx_statement_block($linenr, $realcnt, 0)
+					if (!defined $stat);
 			my ($s, $c) = ($stat, $cond);
 
 			substr($s, 0, length($c), '');
@@ -2638,6 +2653,9 @@ sub process {
 # Check for illegal assignment in if conditional -- and check for trailing
 # statements after the conditional.
 		if ($line =~ /do\s*(?!{)/) {
+			($stat, $cond, $line_nr_next, $remain_next, $off_next) =
+				ctx_statement_block($linenr, $realcnt, 0)
+					if (!defined $stat);
 			my ($stat_next) = ctx_statement_block($line_nr_next,
 						$remain_next, $off_next);
 			$stat_next =~ s/\n./\n /g;
-- 
1.7.5.4

