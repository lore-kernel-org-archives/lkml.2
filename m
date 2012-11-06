Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943Ab2KFKf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 05:35:59 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:35083 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751877Ab2KFKf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 05:35:57 -0500
Message-ID: <1352198139.16194.21.camel@joe-AO722>
Subject: [RFC PATCH] checkpatch: Add a --strict test for macro argument reuse
From: Joe Perches <joe@perches.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Date: Tue, 06 Nov 2012 02:35:39 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a test for reuse of macro arguments to highlight
any possible side-effects from this reuse.

Avoid this check on token name pasting and when the
argument is used in a typeof or a __builtin.

Signed-off-by: Joe Perches <joe@perches.com>
---

There are times when using a temporary for macro arguments
is overkill.  This patch might be overkill too.

 scripts/checkpatch.pl |   42 ++++++++++++++++++++++++++++++++++--------
 1 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index d4f61a6..58fff6e 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2952,7 +2952,17 @@ sub process {
 			#print "dstat<$dstat> dcond<$dcond> cnt<$cnt> off<$off>\n";
 			#print "LINE<$lines[$ln-1]> len<" . length($lines[$ln-1]) . "\n";
 
-			$dstat =~ s/^.\s*\#\s*define\s+$Ident(?:\([^\)]*\))?\s*//;
+			$dstat =~ s/^.\s*\#\s*define\s+$Ident(\([^\)]*\))?\s*//;
+			my $define_args = $1;
+			my $define_stmt = $dstat;
+			my @def_args = ();
+
+			if (defined $define_args && $define_args ne "") {
+				$define_args = substr($define_args, 1, length($define_args) - 2);
+				$define_args =~ s/\s*//g;
+				@def_args = split(",", $define_args);
+			}
+
 			$dstat =~ s/$;//g;
 			$dstat =~ s/\\\n.//g;
 			$dstat =~ s/^\s*//s;
@@ -2984,6 +2994,15 @@ sub process {
 				^\"|\"$
 			}x;
 			#print "REST<$rest> dstat<$dstat> ctx<$ctx>\n";
+
+			$ctx =~ s/\n*$//;
+			my $herectx = $here . "\n";
+			my $stmt_cnt = statement_rawlines($ctx);
+
+			for (my $n = 0; $n < $stmt_cnt; $n++) {
+				$herectx .= raw_line($linenr, $n) . "\n";
+			}
+
 			if ($dstat ne '' &&
 			    $dstat !~ /^(?:$Ident|-?$Constant),$/ &&			# 10, // foo(),
 			    $dstat !~ /^(?:$Ident|-?$Constant);$/ &&			# foo();
@@ -2997,13 +3016,6 @@ sub process {
 			    $dstat !~ /^do\s*{/ &&					# do {...
 			    $dstat !~ /^\({/)						# ({...
 			{
-				$ctx =~ s/\n*$//;
-				my $herectx = $here . "\n";
-				my $cnt = statement_rawlines($ctx);
-
-				for (my $n = 0; $n < $cnt; $n++) {
-					$herectx .= raw_line($linenr, $n) . "\n";
-				}
 
 				if ($dstat =~ /;/) {
 					ERROR("MULTISTATEMENT_MACRO_USE_DO_WHILE",
@@ -3012,6 +3024,20 @@ sub process {
 					ERROR("COMPLEX_MACRO",
 					      "Macros with complex values should be enclosed in parenthesis\n" . "$herectx");
 				}
+
+			}
+
+			foreach my $arg (@def_args) {
+			        next if ($arg =~ /\.\.\./);
+				my $tmp = $define_stmt;
+				$tmp =~ s/\b(typeof|__typeof__|__builtin\w+|typecheck\s*\(\s*$Type\s*,|\#+)\s*\(*\s*$arg\s*\)*\b//g;
+				$tmp =~ s/\#\#\s*$arg\b//g;
+				$tmp =~ s/\b$arg\s*\#\#//g;
+				my $use_cnt = $tmp =~ s/\b$arg\b//g;
+				if ($use_cnt > 1) {
+					CHECK("MACRO_ARG_REUSE",
+					      "Macro argument reuse '$arg' - possible side-effects?\n" . "$herectx");
+				}
 			}
 
 # check for line continuations outside of #defines


