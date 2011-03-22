Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab1CVT7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 15:59:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091Ab1CVT7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 15:59:22 -0400
Date: Tue, 22 Mar 2011 15:58:31 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jonathan Corbet <corbet@lwn.net>, LKML <linux-kernel@vger.kernel.org>,
        Andy Whitcroft <apw@shadowen.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: checkpatch: introduce --nocs to disable CodingStyle warnings.
Message-ID: <20110322195831.GA15838@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Jonathan Corbet <corbet@lwn.net>,
	LKML <linux-kernel@vger.kernel.org>,
	Andy Whitcroft <apw@shadowen.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <1300416744.16880.904.camel@gandalf.stny.rr.com>
 <20110317211548.646b04d2@tpl.lwn.net>
 <20110319193954.GA2032@redhat.com>
 <1300713980.16880.5813.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300713980.16880.5813.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > I would really like to disable warnings, as the patches to my magic
 > macros break all sorts of checkpatch formatting rules, but real errors
 > may still exist. 

How about this ?  running checkpatch with --nocs will now only print
non-CodingStyle related warnings.   I may have missed some of the
conversions, but this seems to silence the more egregious 'noise'.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 58848e3..a2b0086 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -19,6 +19,7 @@ my $tree = 1;
 my $chk_signoff = 1;
 my $chk_patch = 1;
 my $tst_only;
+my $nocs = 0;
 my $emacs = 0;
 my $terse = 0;
 my $file = 0;
@@ -55,6 +56,7 @@ Options:
                              is all off)
   --test-only=WORD           report only warnings/errors containing WORD
                              literally
+  --nocs                     don't display warnings about CodingStyle.
   -h, --help, --version      display this help and exit
 
 When FILE is - read standard input.
@@ -80,6 +82,7 @@ GetOptions(
 
 	'debug=s'	=> \%debug,
 	'test-only=s'	=> \$tst_only,
+	'nocs'		=> \$nocs,
 	'h|help'	=> \$help,
 	'version'	=> \$help
 ) or help(1);
@@ -1113,6 +1116,22 @@ sub WARN {
 		our $cnt_warn++;
 	}
 }
+sub CS_ERROR {
+	if ($nocs == 0) {
+		if (report("ERROR: $_[0]\n")) {
+			our $clean = 0;
+			our $cnt_error++;
+		}
+	}
+}
+sub CS_WARN {
+	if ($nocs == 0) {
+		if (report("WARNING: $_[0]\n")) {
+			our $clean = 0;
+			our $cnt_warn++;
+		}
+	}
+}
 sub CHK {
 	if ($check && report("CHECK: $_[0]\n")) {
 		our $clean = 0;
@@ -1417,11 +1436,11 @@ sub process {
 #trailing whitespace
 		if ($line =~ /^\+.*\015/) {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
-			ERROR("DOS line endings\n" . $herevet);
+			CS_ERROR("DOS line endings\n" . $herevet);
 
 		} elsif ($rawline =~ /^\+.*\S\s+$/ || $rawline =~ /^\+\s+$/) {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
-			ERROR("trailing whitespace\n" . $herevet);
+			CS_ERROR("trailing whitespace\n" . $herevet);
 			$rpt_cleaners = 1;
 		}
 
@@ -1466,17 +1485,17 @@ sub process {
 		    $line =~ /^\+\s*"[^"]*"\s*(?:\s*|,|\)\s*;)\s*$/) &&
 		    $length > 80)
 		{
-			WARN("line over 80 characters\n" . $herecurr);
+			CS_WARN("line over 80 characters\n" . $herecurr);
 		}
 
 # check for spaces before a quoted newline
 		if ($rawline =~ /^.*\".*\s\\n/) {
-			WARN("unnecessary whitespace before a quoted newline\n" . $herecurr);
+			CS_WARN("unnecessary whitespace before a quoted newline\n" . $herecurr);
 		}
 
 # check for adding lines without a newline.
 		if ($line =~ /^\+/ && defined $lines[$linenr] && $lines[$linenr] =~ /^\\ No newline at end of file/) {
-			WARN("adding a line without newline at end of file\n" . $herecurr);
+			CS_WARN("adding a line without newline at end of file\n" . $herecurr);
 		}
 
 # Blackfin: use hi/lo macros
@@ -1499,14 +1518,14 @@ sub process {
 		if ($rawline =~ /^\+\s* \t\s*\S/ ||
 		    $rawline =~ /^\+\s*        \s*/) {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
-			ERROR("code indent should use tabs where possible\n" . $herevet);
+			CS_ERROR("code indent should use tabs where possible\n" . $herevet);
 			$rpt_cleaners = 1;
 		}
 
 # check for space before tabs.
 		if ($rawline =~ /^\+/ && $rawline =~ / \t/) {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
-			WARN("please, no space before tabs\n" . $herevet);
+			CS_WARN("please, no space before tabs\n" . $herevet);
 		}
 
 # check for spaces at the beginning of a line.
@@ -1516,7 +1535,7 @@ sub process {
 #  3) hanging labels
 		if ($rawline =~ /^\+ / && $line !~ /\+ *(?:$;|#|$Ident:)/)  {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
-			WARN("please, no spaces at the start of a line\n" . $herevet);
+			CS_WARN("please, no spaces at the start of a line\n" . $herevet);
 		}
 
 # check we are in a valid C source file if not then ignore this hunk
@@ -1623,7 +1642,7 @@ sub process {
 				}
 			}
 			if ($err ne '') {
-				ERROR("switch and case should be at the same indent\n$hereline$err");
+				CS_ERROR("switch and case should be at the same indent\n$hereline$err");
 			}
 		}
 
@@ -1651,7 +1670,7 @@ sub process {
 			#print "pre<$pre_ctx>\nline<$line>\nctx<$ctx>\nnext<$lines[$ctx_ln - 1]>\n";
 
 			if ($ctx !~ /{\s*/ && defined($lines[$ctx_ln -1]) && $lines[$ctx_ln - 1] =~ /^\+\s*{/) {
-				ERROR("that open brace { should be on the previous line\n" .
+				CS_ERROR("that open brace { should be on the previous line\n" .
 					"$here\n$ctx\n$rawlines[$ctx_ln - 1]\n");
 			}
 			if ($level == 0 && $pre_ctx !~ /}\s*while\s*\($/ &&
@@ -1790,7 +1809,7 @@ sub process {
 # check for initialisation to aggregates open brace on the next line
 		if ($line =~ /^.\s*{/ &&
 		    $prevline =~ /(?:^|[^=])=\s*$/) {
-			ERROR("that open brace { should be on the previous line\n" . $hereprev);
+			CS_ERROR("that open brace { should be on the previous line\n" . $hereprev);
 		}
 
 #
@@ -1808,7 +1827,7 @@ sub process {
 
 # no C99 // comments
 		if ($line =~ m{//}) {
-			ERROR("do not use C99 // comments\n" . $herecurr);
+			CS_ERROR("do not use C99 // comments\n" . $herecurr);
 		}
 		# Remove C99 comments.
 		$line =~ s@//.*@@;
@@ -1911,7 +1930,7 @@ sub process {
 
 			#print "from<$from> to<$to>\n";
 			if ($from ne $to) {
-				ERROR("\"(foo$from)\" should be \"(foo$to)\"\n" .  $herecurr);
+				CS_ERROR("\"(foo$from)\" should be \"(foo$to)\"\n" .  $herecurr);
 			}
 		} elsif ($line =~ m{\b$NonptrType(\s*(?:$Modifier\b\s*|\*\s*)+)($Ident)}) {
 			my ($from, $to, $ident) = ($1, $1, $2);
@@ -1928,7 +1947,7 @@ sub process {
 
 			#print "from<$from> to<$to> ident<$ident>\n";
 			if ($from ne $to && $ident !~ /^$Modifier$/) {
-				ERROR("\"foo${from}bar\" should be \"foo${to}bar\"\n" .  $herecurr);
+				CS_ERROR("\"foo${from}bar\" should be \"foo${to}bar\"\n" .  $herecurr);
 			}
 		}
 
@@ -1970,18 +1989,18 @@ sub process {
 # or if closed on same line
 		if (($line=~/$Type\s*$Ident\(.*\).*\s{/) and
 		    !($line=~/\#\s*define.*do\s{/) and !($line=~/}/)) {
-			ERROR("open brace '{' following function declarations go on the next line\n" . $herecurr);
+			CS_ERROR("open brace '{' following function declarations go on the next line\n" . $herecurr);
 		}
 
 # open braces for enum, union and struct go on the same line.
 		if ($line =~ /^.\s*{/ &&
 		    $prevline =~ /^.\s*(?:typedef\s+)?(enum|union|struct)(?:\s+$Ident)?\s*$/) {
-			ERROR("open brace '{' following $1 go on the same line\n" . $hereprev);
+			CS_ERROR("open brace '{' following $1 go on the same line\n" . $hereprev);
 		}
 
 # missing space after union, struct or enum definition
 		if ($line =~ /^.\s*(?:typedef\s+)?(enum|union|struct)(?:\s+$Ident)?(?:\s+$Ident)?[=\{]/) {
-		    WARN("missing space after $1 definition\n" . $herecurr);
+		    CS_WARN("missing space after $1 definition\n" . $herecurr);
 		}
 
 # check for spacing round square brackets; allowed:
@@ -1993,7 +2012,7 @@ sub process {
 			if ($prefix !~ /$Type\s+$/ &&
 			    ($where != 0 || $prefix !~ /^.\s+$/) &&
 			    $prefix !~ /{\s+$/) {
-				ERROR("space prohibited before open square bracket '['\n" . $herecurr);
+				CS_ERROR("space prohibited before open square bracket '['\n" . $herecurr);
 			}
 		}
 
@@ -2024,7 +2043,7 @@ sub process {
 			} elsif ($ctx =~ /$Type$/) {
 
 			} else {
-				WARN("space prohibited between function name and open parenthesis '('\n" . $herecurr);
+				CS_WARN("space prohibited between function name and open parenthesis '('\n" . $herecurr);
 			}
 		}
 # Check operator spacing.
@@ -2098,7 +2117,7 @@ sub process {
 				} elsif ($op eq ';') {
 					if ($ctx !~ /.x[WEBC]/ &&
 					    $cc !~ /^\\/ && $cc !~ /^;/) {
-						ERROR("space required after that '$op' $at\n" . $hereptr);
+						CS_ERROR("space required after that '$op' $at\n" . $hereptr);
 					}
 
 				# // is a comment
@@ -2109,13 +2128,13 @@ sub process {
 				#   :   when part of a bitfield
 				} elsif ($op eq '->' || $opv eq ':B') {
 					if ($ctx =~ /Wx.|.xW/) {
-						ERROR("spaces prohibited around that '$op' $at\n" . $hereptr);
+						CS_ERROR("spaces prohibited around that '$op' $at\n" . $hereptr);
 					}
 
 				# , must have a space on the right.
 				} elsif ($op eq ',') {
 					if ($ctx !~ /.x[WEC]/ && $cc !~ /^}/) {
-						ERROR("space required after that '$op' $at\n" . $hereptr);
+						CS_ERROR("space required after that '$op' $at\n" . $hereptr);
 					}
 
 				# '*' as part of a type definition -- reported already.
@@ -2129,26 +2148,26 @@ sub process {
 					 $opv eq '*U' || $opv eq '-U' ||
 					 $opv eq '&U' || $opv eq '&&U') {
 					if ($ctx !~ /[WEBC]x./ && $ca !~ /(?:\)|!|~|\*|-|\&|\||\+\+|\-\-|\{)$/) {
-						ERROR("space required before that '$op' $at\n" . $hereptr);
+						CS_ERROR("space required before that '$op' $at\n" . $hereptr);
 					}
 					if ($op eq '*' && $cc =~/\s*$Modifier\b/) {
 						# A unary '*' may be const
 
 					} elsif ($ctx =~ /.xW/) {
-						ERROR("space prohibited after that '$op' $at\n" . $hereptr);
+						CS_ERROR("space prohibited after that '$op' $at\n" . $hereptr);
 					}
 
 				# unary ++ and unary -- are allowed no space on one side.
 				} elsif ($op eq '++' or $op eq '--') {
 					if ($ctx !~ /[WEOBC]x[^W]/ && $ctx !~ /[^W]x[WOBEC]/) {
-						ERROR("space required one side of that '$op' $at\n" . $hereptr);
+						CS_ERROR("space required one side of that '$op' $at\n" . $hereptr);
 					}
 					if ($ctx =~ /Wx[BE]/ ||
 					    ($ctx =~ /Wx./ && $cc =~ /^;/)) {
-						ERROR("space prohibited before that '$op' $at\n" . $hereptr);
+						CS_ERROR("space prohibited before that '$op' $at\n" . $hereptr);
 					}
 					if ($ctx =~ /ExW/) {
-						ERROR("space prohibited after that '$op' $at\n" . $hereptr);
+						CS_ERROR("space prohibited after that '$op' $at\n" . $hereptr);
 					}
 
 
@@ -2160,7 +2179,7 @@ sub process {
 					 $op eq '%')
 				{
 					if ($ctx =~ /Wx[^WCE]|[^WCE]xW/) {
-						ERROR("need consistent spacing around '$op' $at\n" .
+						CS_ERROR("need consistent spacing around '$op' $at\n" .
 							$hereptr);
 					}
 
@@ -2168,7 +2187,7 @@ sub process {
 				# terminating a case value or a label.
 				} elsif ($opv eq ':C' || $opv eq ':L') {
 					if ($ctx =~ /Wx./) {
-						ERROR("space prohibited before that '$op' $at\n" . $hereptr);
+						CS_ERROR("space prohibited before that '$op' $at\n" . $hereptr);
 					}
 
 				# All the others need spaces both sides.
@@ -2191,7 +2210,7 @@ sub process {
 					}
 
 					if ($ok == 0) {
-						ERROR("spaces required around that '$op' $at\n" . $hereptr);
+						CS_ERROR("spaces required around that '$op' $at\n" . $hereptr);
 					}
 				}
 				$off += length($elements[$n + 1]);
@@ -2221,38 +2240,38 @@ sub process {
 #need space before brace following if, while, etc
 		if (($line =~ /\(.*\){/ && $line !~ /\($Type\){/) ||
 		    $line =~ /do{/) {
-			ERROR("space required before the open brace '{'\n" . $herecurr);
+			CS_ERROR("space required before the open brace '{'\n" . $herecurr);
 		}
 
 # closing brace should have a space following it when it has anything
 # on the line
 		if ($line =~ /}(?!(?:,|;|\)))\S/) {
-			ERROR("space required after that close brace '}'\n" . $herecurr);
+			CS_ERROR("space required after that close brace '}'\n" . $herecurr);
 		}
 
 # check spacing on square brackets
 		if ($line =~ /\[\s/ && $line !~ /\[\s*$/) {
-			ERROR("space prohibited after that open square bracket '['\n" . $herecurr);
+			CS_ERROR("space prohibited after that open square bracket '['\n" . $herecurr);
 		}
 		if ($line =~ /\s\]/) {
-			ERROR("space prohibited before that close square bracket ']'\n" . $herecurr);
+			CS_ERROR("space prohibited before that close square bracket ']'\n" . $herecurr);
 		}
 
 # check spacing on parentheses
 		if ($line =~ /\(\s/ && $line !~ /\(\s*(?:\\)?$/ &&
 		    $line !~ /for\s*\(\s+;/) {
-			ERROR("space prohibited after that open parenthesis '('\n" . $herecurr);
+			CS_ERROR("space prohibited after that open parenthesis '('\n" . $herecurr);
 		}
 		if ($line =~ /(\s+)\)/ && $line !~ /^.\s*\)/ &&
 		    $line !~ /for\s*\(.*;\s+\)/ &&
 		    $line !~ /:\s+\)/) {
-			ERROR("space prohibited before that close parenthesis ')'\n" . $herecurr);
+			CS_ERROR("space prohibited before that close parenthesis ')'\n" . $herecurr);
 		}
 
 #goto labels aren't indented, allow a single space however
 		if ($line=~/^.\s+[A-Za-z\d_]+:(?![0-9]+)/ and
 		   !($line=~/^. [A-Za-z\d_]+:/) and !($line=~/^.\s+default:/)) {
-			WARN("labels should not be indented\n" . $herecurr);
+			CS_WARN("labels should not be indented\n" . $herecurr);
 		}
 
 # Return is not a function.
@@ -2271,10 +2290,10 @@ sub process {
 			}
 #print "value<$value>\n";
 			if ($value =~ /^\s*(?:$Ident|-?$Constant)\s*$/) {
-				ERROR("return is not a function, parentheses are not required\n" . $herecurr);
+				CS_ERROR("return is not a function, parentheses are not required\n" . $herecurr);
 
 			} elsif ($spacing !~ /\s+/) {
-				ERROR("space required before the open parenthesis '('\n" . $herecurr);
+				CS_ERROR("space required before the open parenthesis '('\n" . $herecurr);
 			}
 		}
 # Return of what appears to be an errno should normally be -'ve
@@ -2287,7 +2306,7 @@ sub process {
 
 # Need a space before open parenthesis after if, while etc
 		if ($line=~/\b(if|while|for|switch)\(/) {
-			ERROR("space required before the open parenthesis '('\n" . $herecurr);
+			CS_ERROR("space required before the open parenthesis '('\n" . $herecurr);
 		}
 
 # Check for illegal assignment in if conditional -- and check for trailing
@@ -2337,7 +2356,7 @@ sub process {
 					$stat_real = "[...]\n$stat_real";
 				}
 
-				ERROR("trailing statements should be on next line\n" . $herecurr . $stat_real);
+				CS_ERROR("trailing statements should be on next line\n" . $herecurr . $stat_real);
 			}
 		}
 
@@ -2383,7 +2402,7 @@ sub process {
 		# indent level to be relevant to each other.
 		if ($prevline=~/}\s*$/ and $line=~/^.\s*else\s*/ and
 						$previndent == $indent) {
-			ERROR("else should follow close brace '}'\n" . $hereprev);
+			CS_ERROR("else should follow close brace '}'\n" . $hereprev);
 		}
 
 		if ($prevline=~/}\s*$/ and $line=~/^.\s*while\s*/ and
@@ -2396,7 +2415,7 @@ sub process {
 			$s =~ s/\n.*//g;
 
 			if ($s =~ /^\s*;/) {
-				ERROR("while should follow close brace '}'\n" . $hereprev);
+				CS_ERROR("while should follow close brace '}'\n" . $hereprev);
 			}
 		}
 
@@ -2576,7 +2595,7 @@ sub process {
 					}
 				}
 				if ($seen && !$allowed) {
-					WARN("braces {} are not necessary for any arm of this statement\n" . $herectx);
+					CS_WARN("braces {} are not necessary for any arm of this statement\n" . $herectx);
 				}
 			}
 		}
@@ -2630,7 +2649,7 @@ sub process {
 					$herectx .= raw_line($linenr, $n) . "\n";;
 				}
 
-				WARN("braces {} are not necessary for single statement blocks\n" . $herectx);
+				CS_WARN("braces {} are not necessary for single statement blocks\n" . $herectx);
 			}
 		}
 
@@ -2699,7 +2718,7 @@ sub process {
 
 # warn about spacing in #ifdefs
 		if ($line =~ /^.\s*\#\s*(ifdef|ifndef|elif)\s\s+/) {
-			ERROR("exactly one space required after that #$1\n" . $herecurr);
+			CS_ERROR("exactly one space required after that #$1\n" . $herecurr);
 		}
 
 # check for spinlock_t definitions without a comment.
@@ -2723,24 +2742,24 @@ sub process {
 
 # Check that the storage class is at the beginning of a declaration
 		if ($line =~ /\b$Storage\b/ && $line !~ /^.\s*$Storage\b/) {
-			WARN("storage class should be at the beginning of the declaration\n" . $herecurr)
+			CS_WARN("storage class should be at the beginning of the declaration\n" . $herecurr)
 		}
 
 # check the location of the inline attribute, that it is between
 # storage class and type.
 		if ($line =~ /\b$Type\s+$Inline\b/ ||
 		    $line =~ /\b$Inline\s+$Storage\b/) {
-			ERROR("inline keyword should sit between storage class and type\n" . $herecurr);
+			CS_ERROR("inline keyword should sit between storage class and type\n" . $herecurr);
 		}
 
 # Check for __inline__ and __inline, prefer inline
 		if ($line =~ /\b(__inline__|__inline)\b/) {
-			WARN("plain inline is preferred over $1\n" . $herecurr);
+			CS_WARN("plain inline is preferred over $1\n" . $herecurr);
 		}
 
 # Check for __attribute__ packed, prefer __packed
 		if ($line =~ /\b__attribute__\s*\(\s*\(.*\bpacked\b/) {
-			WARN("__packed is preferred over __attribute__((packed))\n" . $herecurr);
+			CS_WARN("__packed is preferred over __attribute__((packed))\n" . $herecurr);
 		}
 
 # check for sizeof(&)
@@ -2791,7 +2810,7 @@ sub process {
 
 # check for multiple semicolons
 		if ($line =~ /;\s*;\s*$/) {
-		    WARN("Statements terminations use 1 semicolon\n" . $herecurr);
+		    CS_WARN("Statements terminations use 1 semicolon\n" . $herecurr);
 		}
 
 # check for gcc specific __FUNCTION__
@@ -2945,6 +2964,9 @@ sub process {
 			print "NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or\n";
 			print "      scripts/cleanfile\n\n";
 		}
+		if ($nocs == 1) {
+			print "You should rerun without the --nocs switch before patch submission\n";
+		}
 	}
 
 	if ($clean == 1 && $quiet == 0) {
