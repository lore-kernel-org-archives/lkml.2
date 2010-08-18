Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab0HRPrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 11:47:51 -0400
Received: from adelie.canonical.com ([91.189.90.139]:51951 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292Ab0HRPrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 11:47:15 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 15/16] checkpatch: statement/block context analyser should look at sanitised lines
Date: Wed, 18 Aug 2010 16:46:48 +0100
Message-Id: <1282146409-30544-16-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282146409-30544-1-git-send-email-apw@canonical.com>
References: <1282146409-30544-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When tracking context to find a block or statement we need to use the
sanitised lines, else perentheses '(' & ')' and braces '{' & '}' can
throw the scanner out.  Also fix up a couple of error outputs which
include those sanitised lines incorrectly.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 8ab45b7..d086ffe 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -691,15 +691,15 @@ sub ctx_block_get {
 		$blk .= $rawlines[$line];
 
 		# Handle nested #if/#else.
-		if ($rawlines[$line] =~ /^.\s*#\s*(?:ifndef|ifdef|if)\s/) {
+		if ($lines[$line] =~ /^.\s*#\s*(?:ifndef|ifdef|if)\s/) {
 			push(@stack, $level);
-		} elsif ($rawlines[$line] =~ /^.\s*#\s*(?:else|elif)\b/) {
+		} elsif ($lines[$line] =~ /^.\s*#\s*(?:else|elif)\b/) {
 			$level = $stack[$#stack - 1];
-		} elsif ($rawlines[$line] =~ /^.\s*#\s*endif\b/) {
+		} elsif ($lines[$line] =~ /^.\s*#\s*endif\b/) {
 			$level = pop(@stack);
 		}
 
-		foreach my $c (split(//, $rawlines[$line])) {
+		foreach my $c (split(//, $lines[$line])) {
 			##print "C<$c>L<$level><$open$close>O<$off>\n";
 			if ($off > 0) {
 				$off--;
@@ -1652,7 +1652,7 @@ sub process {
 
 			if ($ctx !~ /{\s*/ && defined($lines[$ctx_ln -1]) && $lines[$ctx_ln - 1] =~ /^\+\s*{/) {
 				ERROR("that open brace { should be on the previous line\n" .
-					"$here\n$ctx\n$lines[$ctx_ln - 1]\n");
+					"$here\n$ctx\n$rawlines[$ctx_ln - 1]\n");
 			}
 			if ($level == 0 && $pre_ctx !~ /}\s*while\s*\($/ &&
 			    $ctx =~ /\)\s*\;\s*$/ &&
@@ -1661,7 +1661,7 @@ sub process {
 				my ($nlength, $nindent) = line_stats($lines[$ctx_ln - 1]);
 				if ($nindent > $indent) {
 					WARN("trailing semicolon indicates no statements, indent implies otherwise\n" .
-						"$here\n$ctx\n$lines[$ctx_ln - 1]\n");
+						"$here\n$ctx\n$rawlines[$ctx_ln - 1]\n");
 				}
 			}
 		}
-- 
1.7.0.4

