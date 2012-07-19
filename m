Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326Ab2GSWL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 18:11:28 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:33668 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751856Ab2GSWL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 18:11:26 -0400
Message-ID: <1342735885.17350.3.camel@joe2Laptop>
Subject: [PATCH] checkpatch: Add checks for do {} while (0) macro misuses
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Date: Thu, 19 Jul 2012 15:11:25 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These types of macros should not be used for either a
single statement nor should the macro end with a semi-colon.

Add tests for these conditions.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl |   39 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index a743622..da8232b 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2988,6 +2988,45 @@ sub process {
 			}
 		}
 
+# do {} while (0) macro tests:
+# single-statement macros do not need to be enclosed in do while (0) loop,
+# macro should not end with a semicolon
+		if ($^V && $^V ge 5.10.0 &&
+		    $realfile !~ m@/vmlinux.lds.h$@ &&
+		    $line =~ /^.\s*\#\s*define\s+$Ident(\()?/) {
+			my $ln = $linenr;
+			my $cnt = $realcnt;
+			my ($off, $dstat, $dcond, $rest);
+			my $ctx = '';
+			($dstat, $dcond, $ln, $cnt, $off) =
+				ctx_statement_block($linenr, $realcnt, 0);
+			$ctx = $dstat;
+
+			$dstat =~ s/\\\n.//g;
+
+			if ($dstat =~ /^\+\s*#\s*define\s+$Ident\s*${balanced_parens}\s*do\s*{(.*)\s*}\s*while\s*\(\s*0\s*\)\s*([;\s]*)\s*$/) {
+				my $stmts = $2;
+				my $semis = $3;
+
+				$ctx =~ s/\n*$//;
+				my $cnt = statement_rawlines($ctx);
+				my $herectx = $here . "\n";
+
+				for (my $n = 0; $n < $cnt; $n++) {
+					$herectx .= raw_line($linenr, $n) . "\n";
+				}
+
+				if (($stmts =~ tr/;/;/) == 1) {
+					WARN("SINGLE_STATEMENT_DO_WHILE_MACRO",
+					     "Single statement macros should not use a do {} while (0) loop\n" . "$herectx");
+				}
+				if (defined $semis && $semis ne "") {
+					WARN("DO_WHILE_MACRO_WITH_TRAILING_SEMICOLON",
+					     "do {} while (0) macros should not be semicolon terminated\n" . "$herectx");
+				}
+			}
+		}
+
 # make sure symbols are always wrapped with VMLINUX_SYMBOL() ...
 # all assignments may have only one of the following with an assignment:
 #	.


