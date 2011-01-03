Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab1ACDzV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 22:55:21 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:64042 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320Ab1ACDzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 22:55:19 -0500
Date: Sun, 2 Jan 2011 19:55:12 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] scripts/kernel-doc: reorg code for readability
Message-Id: <20110102195512.a44d3bde.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Move 'main' code vs. subroutines around so that they are not so
intermixed, for better readability/understanding (relative to Perl).
It was messy to follow the primary flow of code execution with the
code being mixed.  Now the code begins with data initialization,
followed by all subroutines, then ends with the main code execution.

This is almost totally source code movement, with a few changes as
needed for forward declarations.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/kernel-doc |  102 ++++++++++++++++++++++---------------------
 1 file changed, 54 insertions(+), 48 deletions(-)

--- lnx-2637-rc8.orig/scripts/kernel-doc
+++ lnx-2637-rc8/scripts/kernel-doc
@@ -155,6 +155,8 @@ use strict;
 # '@parameter' - name of a parameter
 # '%CONST' - name of a constant.
 
+## init lots of data
+
 my $errors = 0;
 my $warnings = 0;
 my $anon_struct_union = 0;
@@ -218,21 +220,14 @@ my %highlights_list = ( $type_constant, 
 			$type_param, "\$1" );
 my $blankline_list = "";
 
-sub usage {
-    print "Usage: $0 [ -v ] [ -docbook | -html | -text | -man | -list ]\n";
-    print "         [ -no-doc-sections ]\n";
-    print "         [ -function funcname [ -function funcname ...] ]\n";
-    print "         [ -nofunction funcname [ -nofunction funcname ...] ]\n";
-    print "         c source file(s) > outputfile\n";
-    print "         -v : verbose output, more warnings & other info listed\n";
-    exit 1;
-}
-
 # read arguments
 if ($#ARGV == -1) {
     usage();
 }
 
+my $kernelversion;
+my $dohighlight = "";
+
 my $verbose = 0;
 my $output_mode = "man";
 my $no_doc_sections = 0;
@@ -245,7 +240,7 @@ my $man_date = ('January', 'February', '
 		'November', 'December')[(localtime)[4]] .
   " " . ((localtime)[5]+1900);
 
-# Essentially these are globals
+# Essentially these are globals.
 # They probably want to be tidied up, made more localised or something.
 # CAVEAT EMPTOR!  Some of the others I localised may not want to be, which
 # could cause "use of undefined value" or other bugs.
@@ -353,6 +348,18 @@ while ($ARGV[0] =~ m/^-(.*)/) {
     }
 }
 
+# continue execution near EOF;
+
+sub usage {
+    print "Usage: $0 [ -v ] [ -docbook | -html | -text | -man | -list ]\n";
+    print "         [ -no-doc-sections ]\n";
+    print "         [ -function funcname [ -function funcname ...] ]\n";
+    print "         [ -nofunction funcname [ -nofunction funcname ...] ]\n";
+    print "         c source file(s) > outputfile\n";
+    print "         -v : verbose output, more warnings & other info listed\n";
+    exit 1;
+}
+
 # get kernel version from env
 sub get_kernel_version() {
     my $version = 'unknown kernel version';
@@ -362,15 +369,6 @@ sub get_kernel_version() {
     }
     return $version;
 }
-my $kernelversion = get_kernel_version();
-
-# generate a sequence of code that will splice in highlighting information
-# using the s// operator.
-my $dohighlight = "";
-foreach my $pattern (keys %highlights) {
-#   print STDERR "scanning pattern:$pattern, highlight:($highlights{$pattern})\n";
-    $dohighlight .=  "\$contents =~ s:$pattern:$highlights{$pattern}:gs;\n";
-}
 
 ##
 # dumps section contents to arrays/hashes intended for that purpose.
@@ -1851,34 +1849,6 @@ sub dump_function($$) {
 		       });
 }
 
-sub process_file($);
-
-# Read the file that maps relative names to absolute names for
-# separate source and object directories and for shadow trees.
-if (open(SOURCE_MAP, "<.tmp_filelist.txt")) {
-	my ($relname, $absname);
-	while(<SOURCE_MAP>) {
-		chop();
-		($relname, $absname) = (split())[0..1];
-		$relname =~ s:^/+::;
-		$source_map{$relname} = $absname;
-	}
-	close(SOURCE_MAP);
-}
-
-foreach (@ARGV) {
-    chomp;
-    process_file($_);
-}
-if ($verbose && $errors) {
-  print STDERR "$errors errors\n";
-}
-if ($verbose && $warnings) {
-  print STDERR "$warnings warnings\n";
-}
-
-exit($errors);
-
 sub reset_state {
     $function = "";
     %constants = ();
@@ -2285,3 +2255,39 @@ sub process_file($) {
 	}
     }
 }
+
+
+$kernelversion = get_kernel_version();
+
+# generate a sequence of code that will splice in highlighting information
+# using the s// operator.
+foreach my $pattern (keys %highlights) {
+#   print STDERR "scanning pattern:$pattern, highlight:($highlights{$pattern})\n";
+    $dohighlight .=  "\$contents =~ s:$pattern:$highlights{$pattern}:gs;\n";
+}
+
+# Read the file that maps relative names to absolute names for
+# separate source and object directories and for shadow trees.
+if (open(SOURCE_MAP, "<.tmp_filelist.txt")) {
+	my ($relname, $absname);
+	while(<SOURCE_MAP>) {
+		chop();
+		($relname, $absname) = (split())[0..1];
+		$relname =~ s:^/+::;
+		$source_map{$relname} = $absname;
+	}
+	close(SOURCE_MAP);
+}
+
+foreach (@ARGV) {
+    chomp;
+    process_file($_);
+}
+if ($verbose && $errors) {
+  print STDERR "$errors errors\n";
+}
+if ($verbose && $warnings) {
+  print STDERR "$warnings warnings\n";
+}
+
+exit($errors);
