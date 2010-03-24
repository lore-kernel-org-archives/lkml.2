Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab0CXUBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 16:01:20 -0400
Received: from mail.perches.com ([173.55.12.10]:1060 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753992Ab0CXUBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 16:01:18 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Frans Pop <elendil@planet.nl>, Greg KH <gregkh@suse.de>,
       devel@driverdev.osuosl.org, apw@shadowen.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] scripts/cvt_kernel_style.pl: kernel style source code reformatter
Date: Wed, 24 Mar 2010 13:01:16 -0700
Message-Id: <71f98699c39e03727b17b46995a801015fcc342a.1269460465.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.14.g7e948
In-Reply-To: <1268191518.1545.228.camel@Joe-Laptop.home>
References: <1268191518.1545.228.camel@Joe-Laptop.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A script to convert kernel source files to a more conformant style.
A supplement to or replacement of Lindent.
A wretched little perl script using regexes.

It's a stupid little tool, don't expect it to be perfect.  It's not.

Conversions should be done one at a time.
Multiple conversions may be performed together, but it's not recommended.

Not all conversions are performed correctly.
Verify all conversions before committing anything.

If the original source file doesn't compile, then any conversion will not
compile either and may eat your source.

Do not use option --overwrite unless you have another copy of the source file.

No option exists to wrap long lines.

Command line use:

$ ./scripts/cvt_kernel_style.pl --help
usage: ./scripts/cvt_kernel_style.pl [options] <files>
version: 0.1

Available conversions:
	all
 	convert_printk_to_pr_level
	coalesce_formats
	cuddle_open_brace
	cuddle_else
	deparenthesize_returns
	space_after_KERN_level
	space_after_if_while_for_switch
	space_after_for_semicolons
	space_after_comma
	space_before_pointer
	space_around_trigraph
	convert_leading_spaces_to_tabs
	coalesce_semicolons
	remove_trailing_whitespace
	remove_whitespace_before_quoted_newline
	remove_whitespace_before_trailing_semicolon
	remove_whitespace_before_bracket
	remove_parenthesis_whitespace
	remove_single_statement_braces
	hoist_assigns_from_if
	convert_c99_comments
Additional conversions which may not work well:
	(enable individually or with --convert=all --broken)
	move_labels_to_column_1
	space_around_logical_tests
	space_around_assign
	space_around_arithmetic

Use --convert=(comma separated list)
   ie: --convert=convert_printk_to_pr_level,coalesce_formats

Input source file descriptions:
  --source-indent => How many spaces are used for an indent (default: 8)

Output file:
  --overwrite => write the changes to the source file
  --suffix => suffix to append to new file (default: .style)

Other options:
  --quiet => don't show conversion warning messages (default: disabled)
  --stats => show conversions done (default: enabled)
  --version => show version
  --help => show this help information

For instance:

$ ./scripts/cvt_kernel_style.pl --convert=hoist_assigns_from_if \
	-o --stats --quiet \
	drivers/net/tulip/de2104x.c
Converted drivers/net/tulip/de2104x.c
1	hoist_assigns_from_if
$ git diff drivers/net/tulip/de2104x.c
(added) diff --git a/drivers/net/tulip/de2104x.c b/drivers/net/tulip/de2104x.c
index cb42972..0cb9f38 100644
--- a/drivers/net/tulip/de2104x.c
+++ b/drivers/net/tulip/de2104x.c
@@ -2153,7 +2153,8 @@ static int de_resume (struct pci_dev *pdev)
                goto out;
        if (!netif_running(dev))
                goto out_attach;
-       if ((retval = pci_enable_device(pdev))) {
+       retval = pci_enable_device(pdev);
+       if (retval) {
                dev_err(&dev->dev, "pci_enable_device failed in resume\n");
                goto out;
        }

Conversions done badly or a seriously broken manner:

The script doesn't ignore comments, comments will be reformatted.
This may be undesired and should be fixed-up by hand.
C99 comment conversion can occur within comments.

Conversions can occur within quoted strings.
This may be undesired and should be fixed-up by hand.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/cvt_kernel_style.pl |  478 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 478 insertions(+), 0 deletions(-)
 create mode 100755 scripts/cvt_kernel_style.pl

diff --git a/scripts/cvt_kernel_style.pl b/scripts/cvt_kernel_style.pl
new file mode 100755
index 0000000..350c1b0
--- /dev/null
+++ b/scripts/cvt_kernel_style.pl
@@ -0,0 +1,478 @@
+#!/usr/bin/perl -w
+
+# Change some style elements of a source file
+# An imperfect source code formatter.
+# Might make trivial patches a bit easier.
+#
+# usage: perl scripts/cvt_kernel_style.pl <files>
+#
+# Licensed under the terms of the GNU GPL License version 2
+
+use strict;
+use Getopt::Long qw(:config no_auto_abbrev);
+
+my $P = $0;
+my $V = '0.1';
+
+my $source_indent = 8;
+my $quiet = 0;
+my $stats = 1;
+my $overwrite = 0;
+my $modified = 0;
+my $suffix = ".style";
+my $convert_options = "";
+my $broken = 0;
+
+my @std_options = (
+    "all",
+    "convert_printk_to_pr_level",
+    "coalesce_formats",
+    "cuddle_open_brace",
+    "cuddle_else",
+    "deparenthesize_returns",
+    "space_after_KERN_level",
+    "space_after_if_while_for_switch",
+    "space_after_for_semicolons",
+    "space_after_comma",
+    "space_before_pointer",
+    "space_around_trigraph",
+    "convert_leading_spaces_to_tabs",
+    "coalesce_semicolons",
+    "remove_trailing_whitespace",
+    "remove_whitespace_before_quoted_newline",
+    "remove_whitespace_before_trailing_semicolon",
+    "remove_whitespace_before_bracket",
+    "remove_parenthesis_whitespace",
+    "remove_single_statement_braces",
+    "hoist_assigns_from_if",
+    "convert_c99_comments",
+);
+
+my @other_options = (
+    "move_labels_to_column_1",
+    "space_around_logical_tests",
+    "space_around_assign",
+    "space_around_arithmetic",
+);
+
+my $version = 0;
+my $help = 0;
+
+my $logFunctions = qr{(?x:
+	printk|
+	pr_(debug|dbg|vdbg|devel|info|warning|err|notice|alert|crit|emerg|cont)|
+	dev_(printk|dbg|vdbg|info|warn|err|notice|alert|crit|emerg|WARN)|
+	netdev_(printk|dbg|vdbg|info|warn|err|notice|alert|crit|emerg|WARN)|
+	netif_(printk|dbg|vdbg|info|warn|err|notice|alert|crit|emerg|WARN)|
+	WARN|
+	panic
+)};
+
+my $match_balanced_parentheses = qr/(\((?:[^\(\)]++|(?-1))*\))/;
+my $do_cvt;
+
+my %hash;
+
+sub set_all_options {
+    my ($enabled) = @_;
+
+    foreach my $opt (@std_options) {
+	$hash{$opt} = $enabled;
+    }
+
+    if ($broken > 0 || $enabled == -1) {
+	foreach my $opt (@other_options) {
+	    $hash{$opt} = $enabled;
+	}
+    }
+
+}
+
+if (!GetOptions(
+		'source-indent=i' => \$source_indent,
+		'convert=s' => \$convert_options,
+		'broken!' => \$broken,
+		'stats!' => \$stats,
+		'o|overwrite!' => \$overwrite,
+		'q|quiet!' => \$quiet,
+		'v|version' => \$version,
+		'h|help|usage' => \$help,
+		)) {
+    die "$P: invalid argument - use --help if necessary\n";
+}
+
+if ($help) {
+    usage();
+    exit 0;
+}
+
+if ($version) {
+    print "$P: v$V\n";
+    exit 0;
+}
+
+my $max_spaces_before_tab = $source_indent - 1;
+my $spaces_to_tab = sprintf("%*s", $source_indent, "");
+
+set_all_options(-1);
+
+my @actual_options = split(',', $convert_options);
+foreach my $opt (@actual_options) {
+    if ($opt eq "all") {
+	set_all_options(0);
+    }
+    if (exists($hash{$opt})) {
+	$hash{$opt} = 0;
+    } else {
+	print "Invalid --convert option: '$opt', ignored\n";
+    }
+}
+
+sub usage {
+    print <<EOT;
+usage: $P [options] <files>
+version: $V
+
+EOT
+    print "Available conversions:\n";
+    foreach my $convert (@std_options) {
+	print "\t$convert\n";
+    }
+    print "Additional conversions which may not work well:\n";
+    print "\t(enable individually or with --convert=all --broken)\n";
+    foreach my $convert (@other_options) {
+	print "\t$convert\n";
+    }
+    print "\n";
+    print "Use --convert=(comma separated list)\n";
+    print "   ie: --convert=convert_printk_to_pr_level,coalesce_formats\n";
+    print <<EOT;
+
+Input source file descriptions:
+  --source-indent => How many spaces are used for an indent (default: 8)
+
+Output file:
+  --overwrite => write the changes to the source file
+  --suffix => suffix to append to new file (default: .style)
+
+Other options:
+  --quiet => don't show conversion warning messages (default: disabled)
+  --stats => show conversions done (default: enabled)
+  --version => show version
+  --help => show this help information
+EOT
+}
+
+sub check_label {
+    my ($leading, $label) = @_;
+
+    if ($label == "default") {
+	return "$leading$label:";
+    }
+    return "$label:";
+}
+
+sub check_for {
+    my ($leading, $test1, $test2, $test3) = @_;
+
+    $test1 =~ s/^\s+|\s+$//g;
+    $test2 =~ s/^\s+|\s+$//g;
+    $test3 =~ s/^\s+|\s+$//g;
+
+    return "${leading}for ($test1; $test2; $test3)";
+}
+
+sub tabify {
+    my ($leading) = @_;
+
+#convert leading spaces to tabs
+    1 while $leading =~ s@^([\t]*)$spaces_to_tab@$1\t@g;
+#Remove spaces before a tab
+    1 while $leading =~ s@^([\t]*)([ ]{1,$max_spaces_before_tab})\t@$1\t@g;
+
+    return "$leading";
+}
+
+sub default_substitute {
+    my ($argument) = @_;
+
+    return "$argument";
+}
+
+sub subst_line_mode_fn {
+    my ($lines, $match, $fn, $args) = @_;
+
+    my $function = \&$fn;
+    my @lines = split("\n", $lines);
+    my $count = 0;
+
+    foreach my $line (@lines) {
+	my $oldline = $line;
+	$line =~ s@$match@&$function(eval $args)@ge;
+	$count++ if ($oldline ne $line);
+    }
+
+    return ($count, join("\n", @lines) . "\n");
+}
+
+sub subst_line_mode {
+    my ($lines, $match, $substitute) = @_;
+
+    return subst_line_mode_fn($lines, $match, "default_substitute", $substitute);
+}
+
+sub convert {
+    my ($check) = @_;
+
+    return 1 if ($hash{$check} >= 0);
+
+    return 0;
+}
+
+foreach my $file (@ARGV) {
+    my $f;
+    my $text;
+    my $oldtext;
+
+# read the file
+
+    open($f, '<', $file)
+	or die "$P: Can't open $file for read\n";
+    $oldtext = do { local($/) ; <$f> };
+    close($f);
+
+    $text = $oldtext;
+
+# Convert printk(KERN_<level> to pr_<level>(
+    $do_cvt = "convert_printk_to_pr_level";
+    if (convert($do_cvt)) {
+	$hash{$do_cvt} += $text =~ s@\bprintk\s*\(\s*KERN_(INFO|WARNING|ERR|ALERT|CRIT|EMERG|NOTICE|CONT)\s*@pr_\L$1\(@g;
+    }
+
+# Coalesce long formats
+    $do_cvt = "coalesce_formats";
+    if (convert($do_cvt)) {
+	my $count = 0;
+	do {
+	    $count = $text =~ s@\b(${logFunctions}\s*\([^;]+)\"\s*\n\s*\"@$1@g;
+	    $hash{$do_cvt} += $count;
+	} while ($count > 0);
+    }
+
+# Add space between KERN_<LEVEL> and open quote
+    $do_cvt = "space_after_KERN_level";
+    if (convert($do_cvt)) {
+	my @matches = $text =~ m@\b(KERN_(DEBUG|INFO|WARNING|ERR|ALERT|CRIT|EMERG|NOTICE|CONT)) \"@g;
+	$hash{$do_cvt} -= @matches;
+	$hash{$do_cvt} += $text =~ s@\b(KERN_(DEBUG|INFO|WARNING|ERR|ALERT|CRIT|EMERG|NOTICE|CONT))[ \t]*\"@$1 \"@g;
+    }
+
+# Remove unnecessary parentheses around return
+    $do_cvt = "deparenthesize_returns";
+    if (convert($do_cvt)) {
+	my $count = 0;
+	do {
+	    $count = $text =~ s@\breturn\s+\(([^\)]+)\s*\)\s*;@return $1;@g;
+	    $hash{$do_cvt} += $count;
+	} while ($count > 0);
+    }
+
+# This doesn't work very well, too many comments modified
+# Put labels (but not "default:") on column 1
+    $do_cvt = "move_labels_to_column_1";
+    if (convert($do_cvt)) {
+	$hash{$do_cvt} += $text =~ s@^([ \t]+)([A-Za-z0-9_]+)\s*:[ \t]*:[ \t]*$@check_label($1, $2)@ge;
+    }
+
+# Add space after (if, while, for, switch) and open parenthesis
+    $do_cvt = "space_after_if_while_for_switch";
+    if (convert($do_cvt)) {
+	my @matches = $text =~ m@\b(if|while|for|switch) \(@g;
+	$hash{$do_cvt} -= @matches;
+	$hash{$do_cvt} += $text =~ s@\b(if|while|for|switch)[ \t]*\(@$1 \(@g;
+    }
+
+# Add space after comma
+    $do_cvt = "space_after_comma";
+    if (convert($do_cvt)) {
+	$hash{$do_cvt} += $text =~ s@,(?=[\w\(])@, @g;
+    }
+
+# Add spaces around logical tests
+    $do_cvt = "space_around_logical_tests";
+    if (convert($do_cvt)) {
+	$hash{$do_cvt} += $text =~ s@([\)\w]+)(==|!=|>|>=|<|<=)([\(\w\*\-])@$1 $2 $3@g;
+    }
+
+# Add spaces around assign
+    $do_cvt = "space_around_assign";
+    if (convert($do_cvt)) {
+	$hash{$do_cvt} += $text =~ s@([\)\w]+)(=|\+=|\-=|\*=|/=|>>=|<<=)([\(\w\*\-])@$1 $2 $3@g;
+    }
+
+# Add spaces around arithmetic
+    $do_cvt = "space_around_arithmetic";
+    if (convert($do_cvt)) {
+	$hash{$do_cvt} += $text =~ s@([\)\w]+)(\+|\-)([\(\w\*])@$1 $2 $3@g;
+    }
+
+# Add spaces around trigraph
+    $do_cvt = "space_around_trigraph";
+    if (convert($do_cvt)) {
+	my @matches = $text =~ m@([\)\w\"]+) \? ([\(\)\[\]\w\*\" \t\.\>\-]*[^ \t]) \: ([\w\(\"\-])@g;
+	$hash{$do_cvt} -= @matches;
+	$hash{$do_cvt} += $text =~ s@([\)\w\"]+)[ \t]*\?[ \t]*([\(\)\[\]\w\*\" \t\.\>\-]*[^ \t])[ \t]*\:[ \t]*([\w\(\"\-])@$1 ? $2 : $3@g;
+    }
+
+# Use a space before a pointer,
+    $do_cvt = "space_before_pointer";
+    if (convert($do_cvt)) {
+	my @matches = $text =~ m@\bstruct \w+ \*@g;
+	$hash{$do_cvt} -= @matches;
+	$hash{$do_cvt} += $text =~ s@\bstruct\b\s+(\w+)([\t]+)\*[ \t]*@struct $1$2\*@g;
+	$hash{$do_cvt} += $text =~ s@\bstruct\b\s+(\w+) *\*[ \t]*@struct $1 \*@g;
+	$hash{$do_cvt} += $text =~ s@\bstruct\b\s+(\w+)([ \t]+)\*__@struct $1$2\* __@g;
+    }
+
+# Convert "for (foo;bar;baz)" to "for (foo; bar; baz)"
+    $do_cvt = "space_after_for_semicolons";
+    if (convert($do_cvt)) {
+	my $count;
+	($count, $text) = subst_line_mode_fn($text, '^([ \t]*)for\s*\([ \t]*([^;]+);[ \t]*([^;]+);[ \t]*([^\)]+)\)', 'check_for', '$1, $2, $3, $4');
+	$hash{$do_cvt} += $count;
+    }
+
+# cuddle open brace
+    $do_cvt = "cuddle_open_brace";
+    if (convert($do_cvt)) {
+	my @matches = $text =~ m@(\)|\belse\b) \{\n@g;
+	$hash{$do_cvt} -= @matches;
+	$hash{$do_cvt} += $text =~ s@(\)|\belse\b)[ \t]*[ \t]*\n[ \t]+\{[ \t]*\n@$1 \{\n@g;
+    }
+
+# cuddle else
+    $do_cvt = "cuddle_else";
+    if (convert($do_cvt)) {
+	my @matches = $text =~ m@\} else\b@g;
+	$hash{$do_cvt} -= @matches;
+	$hash{$do_cvt} += $text =~ s@\}[ \t]*\n[ \t]+else\b@\} else@g;
+    }
+
+# Remove multiple semicolons at end-of-line
+    $do_cvt = "coalesce_semicolons";
+    if (convert($do_cvt)) {
+	my $count = 0;
+	do {
+	    $count = $text =~ s@;[ \t]*;[ \t]*\n@;\n@g;
+	    $hash{$do_cvt} += $count;
+	} while ($count > 0);
+    }
+
+# Remove spaces before open bracket
+    $do_cvt = "remove_whitespace_before_bracket";
+    if (convert($do_cvt)) {
+	$hash{$do_cvt} += $text =~ s@[ \t]+\[@\[@g;
+    }
+
+# Remove spaces after open parenthesis and before close parenthesis
+    $do_cvt = "remove_parenthesis_whitespace";
+    if (convert($do_cvt)) {
+	$text =~ s@[ \t]*\)@\)@g;
+	$text =~ s@\([ \t]*@\(@g;
+    }
+
+# Convert leading spaces to tabs
+    $do_cvt = "convert_leading_spaces_to_tabs";
+    if (convert($do_cvt)) {
+	my $count;
+	($count, $text) = subst_line_mode_fn($text, '(^[ \t]+)', 'tabify', '$1');
+	$hash{$do_cvt} += $count;
+    }
+
+# Remove trailing whitespace
+    $do_cvt = "remove_trailing_whitespace";
+    if (convert($do_cvt)) {
+	$hash{$do_cvt} += $text =~ s@[ \t]+\n@\n@g;
+    }
+
+# Remove whitespace before quoted newlines
+    $do_cvt = "remove_whitespace_before_quoted_newline";
+    if (convert($do_cvt)) {
+	$hash{$do_cvt} += $text =~ s@(\"[^\"\n]*[^ \t])[ \t]+\\n@$1\\n@g;
+    }
+
+# Remove whitespace before trailing semicolon
+    $do_cvt = "remove_whitespace_before_trailing_semicolon";
+    if (convert($do_cvt)) {
+	$hash{$do_cvt} += $text =~ s@(\n[^\n]+)\s+;[ \t]*\n$@$1;\n@g;
+    }
+
+# Convert c99 comments to /* */ (don't convert (http|ftp)://)
+    $do_cvt = "convert_c99_comments";
+    if (convert($do_cvt)) {
+	$hash{$do_cvt} += $text =~ s@(?<!:)\/\/[ \t]*(.*)[ \t]*\n+@\/* $1 *\/\n@g;
+    }
+
+# Remove braces from single statements (not multiple-line single statements)
+    $do_cvt = "remove_single_statement_braces";
+    if (convert($do_cvt)) {
+	$hash{$do_cvt} += $text =~ s@[ \t]*\{[ \t]*\n([^;\{\n]+;)[ \t]*\n[ \t]+\}[ \t]*\n@\n$1\n@g;
+    }
+
+# Hoist assigns from if
+    $do_cvt = "hoist_assigns_from_if";
+    if (convert($do_cvt)) {
+	$hash{$do_cvt} += $text =~ s@\n([ \t]*)if\s*\(\s*([\!]{0,1})\s*\(\s*([\*\w\-\>\.\[\]]+)\s*=\s*(?=[^=])\s*([\w\-\>\.\* \t\[\]]*\s*${match_balanced_parentheses}*\s*(\?\:\&|\||\>\>|\<\<|\-|\+|\*|\/ \t)*\s*[\w\-\>\.\* \t\[\]]*\s*${match_balanced_parentheses}*)\s*\)@\n$1$3 = $4;\n$1if \($2$3@gx;
+    }
+
+# write the file if something was changed
+
+    if ($text ne $oldtext) {
+	my $newfile = $file;
+
+	$modified = 1;
+
+	if (!$overwrite) {
+	    $newfile = "$newfile$suffix";
+	}
+	open($f, '>', $newfile)
+	    or die "$P: Can't open $newfile for write\n";
+	print $f $text;
+	close($f);
+
+	if (!$quiet || $stats) {
+	    if ($overwrite) {
+		print "Converted $file\n";
+	    } else {
+		print "Converted $file to $newfile\n";
+	    }
+	}
+
+	if ($stats) {
+	    while ((my $key, my $value) = each(%hash)) {
+		next if ($value <= 0);
+		print "$value\t$key\n" if $value;
+		$hash{$key} = 0;	#Reset for next file
+	    }
+	}
+
+    }
+}
+
+
+if ($modified && !$quiet) {
+    print <<EOT;
+
+Warning: these changes may not be correct.
+
+These changes should be carefully reviewed manually and not combined with
+any functional changes.
+
+Compile, build and test your changes.
+
+You should understand and be responsible for all object changes.
+
+Make sure you read Documentation/SubmittingPatches before sending
+any changes to reviewers, maintainers or mailing lists.
+EOT
+}
-- 
1.7.0.14.g7e948

