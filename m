Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345Ab0ITTnM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 15:43:12 -0400
Received: from mail.perches.com ([173.55.12.10]:2151 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757175Ab0ITTnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 15:43:10 -0400
Subject: [RFC PATCH] scripts/get_maintainer.pl: add interactive mode
From: Joe Perches <joe@perches.com>
To: Florian Mickler <florian@mickler.org>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>, Greg KH <greg@kroah.com>
In-Reply-To: <1284563819-11363-1-git-send-email-florian@mickler.org>
References: <1284558207-10223-1-git-send-email-florian@mickler.org>
	 <1284563819-11363-1-git-send-email-florian@mickler.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Sep 2010 12:43:08 -0700
Message-ID: <1285011788.25988.48.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-15 at 17:16 +0200, florian@mickler.org wrote:
> This is a first version of an interactive mode for
> scripts/get_maintainer.pl .

Thank you Flo.

I've used Flo's initial patch and created a rather more
complete version now built on top of mm with the 5
get_maintainer patches posted earlier.

http://lkml.org/lkml/2010/9/16/150

Flo and I have worked together on this and he has some
upcoming enhancements that could improve the rerun
speed quite a bit.

For now, this uses whatever command line options are
passed as well as allows the user to change these
settings from a prompt during use.

There are still defects in this version.

You can see below that Stephen Hemminger's sign-offs
aren't correctly attributed because his MAINTAINER
entry doesn't match how he normally signs-off
(ie: @vyatta.com vs @linux-foundation.org)

For example, the --interactive (or -i) menu looks like:

--------------------------------------------------------------------------------
$ ./scripts/get_maintainer.pl -i -f drivers/net/sky2.c

*  # email/list and role:stats                                        auth sign
*  1 Stephen Hemminger <shemminger@linux-foundation.org>              
     maintainer:SKGE, SKY2 10/100...
*  2 netdev@vger.kernel.org                                           
     open list:SKGE, SKY2 10/100...
*  3 linux-kernel@vger.kernel.org                                     
     open list

#(toggle), A#(author), S#(signed) *(all), ^(none), O(options), Y(approve): 
--------------------------------------------------------------------------------

with options:

Version Control options:
g  use git history      [0]
gf use git-fallback     [1]
b  use git blame        [0]
bs use blame signatures [1]
c# minimum commits      [1]
%# min percent          [5]
d# history to use       [1-year-ago]
x# max maintainers      [5]
t  all signature types  [0]

Additional options:
0  toggle all
f  emails in file       [0]
k  keywords in file     [1]
r  remove duplicates    [1]
p# pattern match depth  [0]

Because git history is now not searched by default
when there is a named maintainer, there are no
commit signers.

If the "G" option is entered, you get:

#(toggle), A#(author), S#(signed) *(all), ^(none), O(options), Y(approve): g
--------------------------------------------------------------------------------
*  # email/list and role:stats                                        auth sign
*  1 Stephen Hemminger <shemminger@linux-foundation.org>                 1    0
     maintainer:SKGE, SKY2 10/100...,commit_signer:38/69=55%
   2 "David S. Miller" <davem@davemloft.net>                             7   57
     commit_signer:57/69=83%
   3 Mike McCormack <mikem@ring3k.org>                                  16   16
     commit_signer:16/69=23%
   4 Joe Perches <joe@perches.com>                                       4    4
     commit_signer:4/69=6%
*  5 netdev@vger.kernel.org                                           
     open list:SKGE, SKY2 10/100...
*  6 linux-kernel@vger.kernel.org                                     
     open list

#(toggle), A#(author), S#(signed) *(all), ^(none), O(options), Y(approve): 
--------------------------------------------------------------------------------

git signers are not selected by default, these can be selected either
individually by #, or all by *, or multiple can be selected/deselected
from a single command like: "2,3"

To see what commits any individual contributor has authored or
signed, enter "A" or "S" with the #(s)

--------------------------------------------------------------------------------
#(toggle), A#(author), S#(signed) *(all), ^(none), O(options), Y(approve): a4

*  # email/list and role:stats                                        auth sign
*  1 Stephen Hemminger <shemminger@linux-foundation.org>                 1    0
     maintainer:SKGE, SKY2 10/100...,commit_signer:38/69=55%
   2 "David S. Miller" <davem@davemloft.net>                             7   57
     commit_signer:57/69=83%
   3 Mike McCormack <mikem@ring3k.org>                                  16   16
     commit_signer:16/69=23%
   4 Joe Perches <joe@perches.com>                                       4    4
     commit_signer:4/69=6%
     Author: drivers/net/sky2.c: Use (pr|netdev)_<level> macro helpers
     Author: drivers/net/sky2: Convert to use netif_printk macros
     Author: drivers/net: Move && and || to end of previous line
     Author: trivial: remove unnecessary semicolons
*  5 netdev@vger.kernel.org                                           
     open list:SKGE, SKY2 10/100...
*  6 linux-kernel@vger.kernel.org                                     
     open list

#(toggle), A#(author), S#(signed) *(all), ^(none), O(options), Y(approve): 
--------------------------------------------------------------------------------

There are also significant improvements in HG runtime.
HG is now faster than git for blame and commit signer
lookups.

Here's the rather large patch:

---
 scripts/get_maintainer.pl |  819 +++++++++++++++++++++++++++++++++++----------
 1 files changed, 638 insertions(+), 181 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index e5a400c..f511760 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -13,7 +13,7 @@
 use strict;
 
 my $P = $0;
-my $V = '0.25';
+my $V = '0.26-beta3';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -27,12 +27,14 @@ my $email_git_penguin_chiefs = 0;
 my $email_git = 0;
 my $email_git_all_signature_types = 0;
 my $email_git_blame = 0;
+my $email_git_blame_signatures = 1;
 my $email_git_fallback = 1;
 my $email_git_min_signatures = 1;
 my $email_git_max_maintainers = 5;
 my $email_git_min_percent = 5;
 my $email_git_since = "1-year-ago";
 my $email_hg_since = "-365";
+my $interactive = 0;
 my $email_remove_duplicates = 1;
 my $output_multiline = 1;
 my $output_separator = ", ";
@@ -50,8 +52,13 @@ my $pattern_depth = 0;
 my $version = 0;
 my $help = 0;
 
+my $vcs_used = 0;
+
 my $exit = 0;
 
+my %commit_author_hash;
+my %commit_signer_hash;
+
 my @penguin_chief = ();
 push(@penguin_chief, "Linus Torvalds:torvalds\@linux-foundation.org");
 #Andrew wants in on most everything - 2009/01/14
@@ -74,7 +81,6 @@ my @signature_tags = ();
 push(@signature_tags, "Signed-off-by:");
 push(@signature_tags, "Reviewed-by:");
 push(@signature_tags, "Acked-by:");
-my $signaturePattern = "\(" . join("|", @signature_tags) . "\)";
 
 # rfc822 email address - preloaded methods go here.
 my $rfc822_lwsp = "(?:(?:\\r\\n)?[ \\t])";
@@ -87,27 +93,62 @@ my %VCS_cmds;
 my %VCS_cmds_git = (
     "execute_cmd" => \&git_execute_cmd,
     "available" => '(which("git") ne "") && (-d ".git")',
-    "find_signers_cmd" => "git log --no-color --since=\$email_git_since -- \$file",
-    "find_commit_signers_cmd" => "git log --no-color -1 \$commit",
-    "find_commit_author_cmd" => "git log -1 --format=\"%an <%ae>\" \$commit",
+    "find_signers_cmd" =>
+	"git log --no-color --since=\$email_git_since " .
+	    '--format="GitCommit: %H%n' .
+		      'GitAuthor: %an <%ae>%n' .
+		      'GitDate: %aD%n' .
+		      'GitSubject: %s%n' .
+		      '%b%n"' .
+	    " -- \$file",
+    "find_commit_signers_cmd" =>
+	"git log --no-color " .
+	    '--format="GitCommit: %H%n' .
+		      'GitAuthor: %an <%ae>%n' .
+		      'GitDate: %aD%n' .
+		      'GitSubject: %s%n' .
+		      '%b%n"' .
+	    " -1 \$commit",
+    "find_commit_author_cmd" =>
+	"git log --no-color " .
+	    '--format="GitCommit: %H%n' .
+		      'GitAuthor: %an <%ae>%n' .
+		      'GitDate: %aD%n' .
+		      'GitSubject: %s%n"' .
+	    " -1 \$commit",
     "blame_range_cmd" => "git blame -l -L \$diff_start,+\$diff_length \$file",
     "blame_file_cmd" => "git blame -l \$file",
-    "commit_pattern" => "^commit [0-9a-f]{40,40}",
-    "blame_commit_pattern" => "^([0-9a-f]+) "
+    "commit_pattern" => "^GitCommit: ([0-9a-f]{40,40})",
+    "blame_commit_pattern" => "^([0-9a-f]+) ",
+    "author_pattern" => "^GitAuthor: (.*)",
+    "subject_pattern" => "^GitSubject: (.*)",
 );
 
 my %VCS_cmds_hg = (
     "execute_cmd" => \&hg_execute_cmd,
     "available" => '(which("hg") ne "") && (-d ".hg")',
     "find_signers_cmd" =>
-	"hg log --date=\$email_hg_since" .
-		" --template='commit {node}\\n{desc}\\n' -- \$file",
-    "find_commit_signers_cmd" => "hg log --template='{desc}\\n' -r \$commit",
-    "find_commit_author_cmd" => "hg log -l 1 --template='{author}\\n' -r \$commit",
+	"hg log --date=\$email_hg_since " .
+	    "--template='HgCommit: {node}\\n" .
+	                "HgAuthor: {author}\\n" .
+			"HgSubject: {desc}\\n'" .
+	    " -- \$file",
+    "find_commit_signers_cmd" =>
+	"hg log " .
+	    "--template='HgSubject: {desc}\\n'" .
+	    " -r \$commit",
+    "find_commit_author_cmd" =>
+	"hg log " .
+	    "--template='HgCommit: {node}\\n" .
+		        "HgAuthor: {author}\\n" .
+			"HgSubject: {desc|firstline}\\n'" .
+	    " -r \$commit",
     "blame_range_cmd" => "",		# not supported
-    "blame_file_cmd" => "hg blame -c \$file",
-    "commit_pattern" => "^commit [0-9a-f]{40,40}",
-    "blame_commit_pattern" => "^([0-9a-f]+):"
+    "blame_file_cmd" => "hg blame -n \$file",
+    "commit_pattern" => "^HgCommit: ([0-9a-f]{40,40})",
+    "blame_commit_pattern" => "^([ 0-9a-f]+):",
+    "author_pattern" => "^HgAuthor: (.*)",
+    "subject_pattern" => "^HgSubject: (.*)",
 );
 
 my $conf = which_conf(".get_maintainer.conf");
@@ -141,6 +182,7 @@ if (!GetOptions(
 		'git!' => \$email_git,
 		'git-all-signature-types!' => \$email_git_all_signature_types,
 		'git-blame!' => \$email_git_blame,
+		'git-blame-signatures!' => \$email_git_blame_signatures,
 		'git-fallback!' => \$email_git_fallback,
 		'git-chief-penguins!' => \$email_git_penguin_chiefs,
 		'git-min-signatures=i' => \$email_git_min_signatures,
@@ -148,6 +190,7 @@ if (!GetOptions(
 		'git-min-percent=i' => \$email_git_min_percent,
 		'git-since=s' => \$email_git_since,
 		'hg-since=s' => \$email_hg_since,
+		'i|interactive!' => \$interactive,
 		'remove-duplicates!' => \$email_remove_duplicates,
 		'm!' => \$email_maintainer,
 		'n!' => \$email_usename,
@@ -187,13 +230,9 @@ if (-t STDIN && !@ARGV) {
     die "$P: missing patchfile or -f file - use --help if necessary\n";
 }
 
-if ($output_separator ne ", ") {
-    $output_multiline = 0;
-}
-
-if ($output_rolestats) {
-    $output_roles = 1;
-}
+$output_multiline = 0 if ($output_separator ne ", ");
+$output_rolestats = 1 if ($interactive);
+$output_roles = 1 if ($output_rolestats);
 
 if ($sections) {
     $email = 0;
@@ -221,10 +260,6 @@ if (!top_of_kernel_tree($lk_path)) {
 	. "a linux kernel source tree.\n";
 }
 
-if ($email_git_all_signature_types) {
-    $signaturePattern = "(.+?)[Bb][Yy]:";
-}
-
 ## Read MAINTAINERS for type/value pairs
 
 my @typevalue = ();
@@ -363,162 +398,193 @@ foreach my $file (@ARGV) {
 
 @file_emails = uniq(@file_emails);
 
+my %email_hash_name;
+my %email_hash_address;
 my @email_to = ();
+my %hash_list_to;
 my @list_to = ();
 my @scm = ();
 my @web = ();
 my @subsystem = ();
 my @status = ();
+my $signature_pattern;
 
-# Find responsible parties
+my @to = get_maintainer();
 
-foreach my $file (@files) {
+@to = merge_email(@to);
 
-    my %hash;
-    my $exact_pattern_match = 0;
-    my $tvi = find_first_section();
-    while ($tvi < @typevalue) {
-	my $start = find_starting_index($tvi);
-	my $end = find_ending_index($tvi);
-	my $exclude = 0;
-	my $i;
-
-	#Do not match excluded file patterns
-
-	for ($i = $start; $i < $end; $i++) {
-	    my $line = $typevalue[$i];
-	    if ($line =~ m/^(\C):\s*(.*)/) {
-		my $type = $1;
-		my $value = $2;
-		if ($type eq 'X') {
-		    if (file_match_pattern($file, $value)) {
-			$exclude = 1;
-			last;
-		    }
-		}
-	    }
-	}
+output(@to) if (@to);
+
+if ($scm) {
+    @scm = uniq(@scm);
+    output(@scm);
+}
+
+if ($status) {
+    @status = uniq(@status);
+    output(@status);
+}
+
+if ($subsystem) {
+    @subsystem = uniq(@subsystem);
+    output(@subsystem);
+}
+
+if ($web) {
+    @web = uniq(@web);
+    output(@web);
+}
+
+exit($exit);
+
+sub get_maintainer {
+    %email_hash_name = ();
+    %email_hash_address = ();
+    %commit_author_hash = ();
+    %commit_signer_hash = ();
+    @email_to = ();
+    %hash_list_to = ();
+    @list_to = ();
+    @scm = ();
+    @web = ();
+    @subsystem = ();
+    @status = ();
+
+    if ($email_git_all_signature_types) {
+	$signature_pattern = "(.+?)[Bb][Yy]:";
+    } else {
+	$signature_pattern = "\(" . join("|", @signature_tags) . "\)";
+    }
+
+    # Find responsible parties
+
+    foreach my $file (@files) {
+
+	my %hash;
+	my $exact_pattern_match = 0;
+	my $tvi = find_first_section();
+	while ($tvi < @typevalue) {
+	    my $start = find_starting_index($tvi);
+	    my $end = find_ending_index($tvi);
+	    my $exclude = 0;
+	    my $i;
+
+	    #Do not match excluded file patterns
 
-	if (!$exclude) {
 	    for ($i = $start; $i < $end; $i++) {
 		my $line = $typevalue[$i];
 		if ($line =~ m/^(\C):\s*(.*)/) {
 		    my $type = $1;
 		    my $value = $2;
-		    if ($type eq 'F') {
+		    if ($type eq 'X') {
 			if (file_match_pattern($file, $value)) {
-			    my $value_pd = ($value =~ tr@/@@);
-			    my $file_pd = ($file  =~ tr@/@@);
-			    $value_pd++ if (substr($value,-1,1) ne "/");
-			    $value_pd = -1 if ($value =~ /^\.\*/);
-			    $exact_pattern_match = 1 if ($value_pd >= $file_pd);
-			    if ($pattern_depth == 0 ||
-				(($file_pd - $value_pd) < $pattern_depth)) {
-				$hash{$tvi} = $value_pd;
+			    $exclude = 1;
+			    last;
+			}
+		    }
+		}
+	    }
+
+	    if (!$exclude) {
+		for ($i = $start; $i < $end; $i++) {
+		    my $line = $typevalue[$i];
+		    if ($line =~ m/^(\C):\s*(.*)/) {
+			my $type = $1;
+			my $value = $2;
+			if ($type eq 'F') {
+			    if (file_match_pattern($file, $value)) {
+				my $value_pd = ($value =~ tr@/@@);
+				my $file_pd = ($file  =~ tr@/@@);
+				$value_pd++ if (substr($value,-1,1) ne "/");
+				$value_pd = -1 if ($value =~ /^\.\*/);
+				$exact_pattern_match = 1 if ($value_pd >= $file_pd);
+				if ($pattern_depth == 0 ||
+				    (($file_pd - $value_pd) < $pattern_depth)) {
+				    $hash{$tvi} = $value_pd;
+				}
 			    }
 			}
 		    }
 		}
 	    }
+	    $tvi = $end + 1;
 	}
 
-	$tvi = $end + 1;
-    }
-
-    foreach my $line (sort {$hash{$b} <=> $hash{$a}} keys %hash) {
-	add_categories($line);
-	if ($sections) {
-	    my $i;
-	    my $start = find_starting_index($line);
-	    my $end = find_ending_index($line);
-	    for ($i = $start; $i < $end; $i++) {
-		my $line = $typevalue[$i];
-		if ($line =~ /^[FX]:/) {		##Restore file patterns
-		    $line =~ s/([^\\])\.([^\*])/$1\?$2/g;
-		    $line =~ s/([^\\])\.$/$1\?/g;	##Convert . back to ?
-		    $line =~ s/\\\./\./g;       	##Convert \. to .
-		    $line =~ s/\.\*/\*/g;       	##Convert .* to *
+	foreach my $line (sort {$hash{$b} <=> $hash{$a}} keys %hash) {
+	    add_categories($line);
+	    if ($sections) {
+		my $i;
+		my $start = find_starting_index($line);
+		my $end = find_ending_index($line);
+		for ($i = $start; $i < $end; $i++) {
+		    my $line = $typevalue[$i];
+		    if ($line =~ /^[FX]:/) {		##Restore file patterns
+			$line =~ s/([^\\])\.([^\*])/$1\?$2/g;
+			$line =~ s/([^\\])\.$/$1\?/g;	##Convert . back to ?
+			$line =~ s/\\\./\./g;       	##Convert \. to .
+			$line =~ s/\.\*/\*/g;       	##Convert .* to *
+		    }
+		    $line =~ s/^([A-Z]):/$1:\t/g;
+		    print("$line\n");
 		}
-		$line =~ s/^([A-Z]):/$1:\t/g;
-		print("$line\n");
+		print("\n");
 	    }
-	    print("\n");
 	}
-    }
-
-    if ($email &&
-	($email_git || ($email_git_fallback && !$exact_pattern_match))) {
-	vcs_file_signoffs($file);
-    }
 
-    if ($email && $email_git_blame) {
-	vcs_file_blame($file);
+	if ($email && ($email_git ||
+		       ($email_git_fallback && !$exact_pattern_match))) {
+	    vcs_file_signoffs($file);
+	}
+	if ($email && $email_git_blame) {
+	    vcs_file_blame($file);
+	}
     }
-}
 
-if ($keywords) {
-    @keyword_tvi = sort_and_uniq(@keyword_tvi);
-    foreach my $line (@keyword_tvi) {
-	add_categories($line);
+    if ($keywords) {
+	@keyword_tvi = sort_and_uniq(@keyword_tvi);
+	foreach my $line (@keyword_tvi) {
+	    add_categories($line);
+	}
     }
-}
 
-if ($email) {
-    foreach my $chief (@penguin_chief) {
-	if ($chief =~ m/^(.*):(.*)/) {
-	    my $email_address;
+    if ($email) {
+	foreach my $chief (@penguin_chief) {
+	    if ($chief =~ m/^(.*):(.*)/) {
+		my $email_address;
 
-	    $email_address = format_email($1, $2, $email_usename);
-	    if ($email_git_penguin_chiefs) {
-		push(@email_to, [$email_address, 'chief penguin']);
-	    } else {
-		@email_to = grep($_->[0] !~ /${email_address}/, @email_to);
+		$email_address = format_email($1, $2, $email_usename);
+		if ($email_git_penguin_chiefs) {
+		    push(@email_to, [$email_address, 'chief penguin']);
+		} else {
+		    @email_to = grep($_->[0] !~ /${email_address}/, @email_to);
+		}
 	    }
 	}
-    }
 
-    foreach my $email (@file_emails) {
-	my ($name, $address) = parse_email($email);
+	foreach my $email (@file_emails) {
+	    my ($name, $address) = parse_email($email);
 
-	my $tmp_email = format_email($name, $address, $email_usename);
-	push_email_address($tmp_email, '');
-	add_role($tmp_email, 'in file');
+	    my $tmp_email = format_email($name, $address, $email_usename);
+	    push_email_address($tmp_email, '');
+	    add_role($tmp_email, 'in file');
+	}
     }
-}
 
-if ($email || $email_list) {
     my @to = ();
-    if ($email) {
-	@to = (@to, @email_to);
-    }
-    if ($email_list) {
-	@to = (@to, @list_to);
+    if ($email || $email_list) {
+	if ($email) {
+	    @to = (@to, @email_to);
+	}
+	if ($email_list) {
+	    @to = (@to, @list_to);
+	}
     }
-    output(merge_email(@to));
-}
-
-if ($scm) {
-    @scm = uniq(@scm);
-    output(@scm);
-}
-
-if ($status) {
-    @status = uniq(@status);
-    output(@status);
-}
 
-if ($subsystem) {
-    @subsystem = uniq(@subsystem);
-    output(@subsystem);
-}
+    @to = interactive_get_maintainer(\@to) if ($interactive);
 
-if ($web) {
-    @web = uniq(@web);
-    output(@web);
+    return @to;
 }
 
-exit($exit);
-
 sub file_match_pattern {
     my ($file, $pattern) = @_;
     if (substr($pattern, -1) eq "/") {
@@ -547,7 +613,7 @@ MAINTAINER field selection options:
   --email => print email address(es) if any
     --git => include recent git \*-by: signers
     --git-all-signature-types => include signers regardless of signature type
-        or use only ${signaturePattern} signers (default: $email_git_all_signature_types)
+        or use only ${signature_pattern} signers (default: $email_git_all_signature_types)
     --git-fallback => use git when no exact MAINTAINERS pattern (default: $email_git_fallback)
     --git-chief-penguins => include ${penguin_chiefs}
     --git-min-signatures => number of signatures required (default: $email_git_min_signatures)
@@ -556,6 +622,7 @@ MAINTAINER field selection options:
     --git-blame => use git blame to find modified commits for patch or file
     --git-since => git history to use (default: $email_git_since)
     --hg-since => hg history to use (default: $email_hg_since)
+    --interactive => display a menu (mostly useful if used with the --git option)
     --m => include maintainer(s) if any
     --n => include name 'Full Name <addr\@domain.tld>'
     --l => include list(s) if any
@@ -832,11 +899,19 @@ sub add_categories {
 		}
 		if ($list_additional =~ m/subscribers-only/) {
 		    if ($email_subscriber_list) {
-			push(@list_to, [$list_address, "subscriber list${list_role}"]);
+			if (!$hash_list_to{$list_address}) {
+			    $hash_list_to{$list_address} = 1;
+			    push(@list_to, [$list_address,
+					    "subscriber list${list_role}"]);
+			}
 		    }
 		} else {
 		    if ($email_list) {
-			push(@list_to, [$list_address, "open list${list_role}"]);
+			if (!$hash_list_to{$list_address}) {
+			    $hash_list_to{$list_address} = 1;
+			    push(@list_to, [$list_address,
+					    "open list${list_role}"]);
+			}
 		    }
 		}
 	    } elsif ($ptype eq "M") {
@@ -867,9 +942,6 @@ sub add_categories {
     }
 }
 
-my %email_hash_name;
-my %email_hash_address;
-
 sub email_inuse {
     my ($name, $address) = @_;
 
@@ -1022,10 +1094,31 @@ sub hg_execute_cmd {
     return @lines;
 }
 
+sub extract_formatted_signatures {
+    my (@signature_lines) = @_;
+
+    my @type = @signature_lines;
+
+    s/\s*(.*):.*/$1/ for (@type);
+
+    # cut -f2- -d":"
+    s/\s*.*:\s*(.+)\s*/$1/ for (@signature_lines);
+
+## Reformat email addresses (with names) to avoid badly written signatures
+
+    foreach my $signer (@signature_lines) {
+	my ($name, $address) = parse_email($signer);
+	$signer = format_email($name, $address, 1);
+    }
+
+    return (\@type, \@signature_lines);
+}
+
 sub vcs_find_signers {
     my ($cmd) = @_;
-    my @lines = ();
     my $commits;
+    my @lines = ();
+    my @signatures = ();
 
     @lines = &{$VCS_cmds{"execute_cmd"}}($cmd);
 
@@ -1033,24 +1126,20 @@ sub vcs_find_signers {
 
     $commits = grep(/$pattern/, @lines);	# of commits
 
-    @lines = grep(/^[ \t]*${signaturePattern}.*\@.*$/, @lines);
-    if (!$email_git_penguin_chiefs) {
-	@lines = grep(!/${penguin_chiefs}/i, @lines);
-    }
-
-    return (0, @lines) if !@lines;
+    @signatures = grep(/^[ \t]*${signature_pattern}.*\@.*$/, @lines);
 
-    # cut -f2- -d":"
-    s/.*:\s*(.+)\s*/$1/ for (@lines);
+    return (0, @signatures) if !@signatures;
 
-## Reformat email addresses (with names) to avoid badly written signatures
+    save_commits_by_author(@lines) if ($interactive);
+    save_commits_by_signer(@lines) if ($interactive);
 
-    foreach my $line (@lines) {
-	my ($name, $address) = parse_email($line);
-	$line = format_email($name, $address, 1);
+    if (!$email_git_penguin_chiefs) {
+	@signatures = grep(!/${penguin_chiefs}/i, @signatures);
     }
 
-    return ($commits, @lines);
+    my ($types_ref, $signers_ref) = extract_formatted_signatures(@signatures);
+
+    return ($commits, @$signers_ref);
 }
 
 sub vcs_find_author {
@@ -1065,14 +1154,20 @@ sub vcs_find_author {
 
     return @lines if !@lines;
 
-## Reformat email addresses (with names) to avoid badly written signatures
-
+    my @authors = ();
     foreach my $line (@lines) {
-	my ($name, $address) = parse_email($line);
-	$line = format_email($name, $address, 1);
+	if ($line =~ m/$VCS_cmds{"author_pattern"}/) {
+	    my $author = $1;
+	    my ($name, $address) = parse_email($author);
+	    $author = format_email($name, $address, 1);
+	    push(@authors, $author);
+	}
     }
 
-    return @lines;
+    save_commits_by_author(@lines) if ($interactive);
+    save_commits_by_signer(@lines) if ($interactive);
+
+    return @authors;
 }
 
 sub vcs_save_commits {
@@ -1144,7 +1239,7 @@ sub vcs_exists {
     %VCS_cmds = %VCS_cmds_git;
     return 1 if eval $VCS_cmds{"available"};
     %VCS_cmds = %VCS_cmds_hg;
-    return 1 if eval $VCS_cmds{"available"};
+    return 2 if eval $VCS_cmds{"available"};
     %VCS_cmds = ();
     if (!$printed_novcs) {
 	warn("$P: No supported VCS found.  Add --nogit to options?\n");
@@ -1156,6 +1251,311 @@ sub vcs_exists {
     return 0;
 }
 
+sub vcs_is_git {
+    return $vcs_used == 1;
+}
+
+sub vcs_is_hg {
+    return $vcs_used == 2;
+}
+
+sub interactive_get_maintainer {
+    my ($list_ref) = @_;
+    my @list = @$list_ref;
+
+    vcs_exists();
+
+    my %selected;
+    my %authored;
+    my %signed;
+    my $count = 0;
+
+    #select maintainers by default
+    foreach my $entry (@list){
+	my $role = $entry->[1];
+	$selected{$count} = ($role =~ /^(maintainer|supporter|open list)/);
+	$authored{$count} = 0;
+	$signed{$count} = 0;
+	$count++;
+    }
+
+    #menu loop
+    my $done = 0;
+    my $print_options = 0;
+    my $redraw = 1;
+    while (!$done) {
+	$count = 0;
+	if ($redraw) {
+	    printf STDERR "\n%1s %2s %-65sauth sign\n",
+		"*", "#", "email/list and role:stats";
+	    foreach my $entry (@list) {
+		my $email = $entry->[0];
+		my $role = $entry->[1];
+		my $sel = "";
+		$sel = "*" if ($selected{$count});
+		my $commit_author = $commit_author_hash{$email};
+		my $commit_signer = $commit_signer_hash{$email};
+		my $authored = 0;
+		my $signed = 0;
+		$authored++ for (@{$commit_author});
+		$signed++ for (@{$commit_signer});
+		printf STDERR "%1s %2d %-65s", $sel, $count + 1, $email;
+		printf STDERR "%4d %4d", $authored, $signed
+		    if ($authored > 0 || $signed > 0);
+		printf STDERR "\n     %s\n", $role;
+		if ($authored{$count}) {
+		    my $commit_author = $commit_author_hash{$email};
+		    foreach my $ref (@{$commit_author}) {
+			print STDERR "     Author: @{$ref}[1]\n";
+		    }
+		}
+		if ($signed{$count}) {
+		    my $commit_signer = $commit_signer_hash{$email};
+		    foreach my $ref (@{$commit_signer}) {
+			print STDERR "     @{$ref}[2]: @{$ref}[1]\n";
+		    }
+		}
+
+		$count++;
+	    }
+	}
+	my $date_ref = \$email_git_since;
+	$date_ref = \$email_hg_since if (vcs_is_hg());
+	if ($print_options) {
+	    $print_options = 0;
+	    if (vcs_exists()) {
+		print STDERR
+"\nVersion Control options:\n" .
+"g  use git history      [$email_git]\n" .
+"gf use git-fallback     [$email_git_fallback]\n" .
+"b  use git blame        [$email_git_blame]\n" .
+"bs use blame signatures [$email_git_blame_signatures]\n" .
+"c# minimum commits      [$email_git_min_signatures]\n" .
+"%# min percent          [$email_git_min_percent]\n" .
+"d# history to use       [$$date_ref]\n" .
+"x# max maintainers      [$email_git_max_maintainers]\n" .
+"t  all signature types  [$email_git_all_signature_types]\n";
+	    }
+	    print STDERR "\nAdditional options:\n" .
+"0  toggle all\n" .
+"f  emails in file       [$file_emails]\n" .
+"k  keywords in file     [$keywords]\n" .
+"r  remove duplicates    [$email_remove_duplicates]\n" .
+"p# pattern match depth  [$pattern_depth]\n";
+	}
+	print STDERR
+"\n#(toggle), A#(author), S#(signed) *(all), ^(none), O(options), Y(approve): ";
+
+	my $input = <STDIN>;
+	chomp($input);
+
+	$redraw = 1;
+	my $rerun = 0;
+	my @wish = split(/[, ]+/, $input);
+	foreach my $nr (@wish) {
+	    $nr = lc($nr);
+	    my $sel = substr($nr, 0, 1);
+	    my $str = substr($nr, 1);
+	    my $val = 0;
+	    $val = $1 if $str =~ /^(\d+)$/;
+
+	    if ($sel eq "y") {
+		$interactive = 0;
+		$done = 1;
+		$output_rolestats = 0;
+		$output_roles = 0;
+		last;
+	    } elsif ($nr =~ /^\d+$/ && $nr > 0 && $nr <= $count) {
+		$selected{$nr - 1} = !$selected{$nr - 1};
+	    } elsif ($sel eq "*" || $sel eq '^') {
+		my $toggle = 0;
+		$toggle = 1 if ($sel eq '*');
+		for (my $i = 0; $i < $count; $i++) {
+		    $selected{$i} = $toggle;
+		}
+	    } elsif ($sel eq "0") {
+		for (my $i = 0; $i < $count; $i++) {
+		    $selected{$i} = !$selected{$i};
+		}
+	    } elsif ($sel eq "a") {
+		if ($val > 0 && $val <= $count) {
+		    $authored{$val - 1} = !$authored{$val - 1};
+		} elsif ($str eq '*' || $str eq '^') {
+		    my $toggle = 0;
+		    $toggle = 1 if ($str eq '*');
+		    for (my $i = 0; $i < $count; $i++) {
+			$authored{$i} = $toggle;
+		    }
+		}
+	    } elsif ($sel eq "s") {
+		if ($val > 0 && $val <= $count) {
+		    $signed{$val - 1} = !$signed{$val - 1};
+		} elsif ($str eq '*' || $str eq '^') {
+		    my $toggle = 0;
+		    $toggle = 1 if ($str eq '*');
+		    for (my $i = 0; $i < $count; $i++) {
+			$signed{$i} = $toggle;
+		    }
+		}
+	    } elsif ($sel eq "o") {
+		$print_options = 1;
+		$redraw = 1;
+	    } elsif ($sel eq "g") {
+		if ($str eq "f") {
+		    bool_invert(\$email_git_fallback);
+		} else {
+		    bool_invert(\$email_git);
+		}
+		$rerun = 1;
+	    } elsif ($sel eq "b") {
+		if ($str eq "s") {
+		    bool_invert(\$email_git_blame_signatures);
+		} else {
+		    bool_invert(\$email_git_blame);
+		}
+		$rerun = 1;
+	    } elsif ($sel eq "c") {
+		if ($val > 0) {
+		    $email_git_min_signatures = $val;
+		    $rerun = 1;
+		}
+	    } elsif ($sel eq "x") {
+		if ($val > 0) {
+		    $email_git_max_maintainers = $val;
+		    $rerun = 1;
+		}
+	    } elsif ($sel eq "%") {
+		if ($str ne "" && $val >= 0) {
+		    $email_git_min_percent = $val;
+		    $rerun = 1;
+		}
+	    } elsif ($sel eq "d") {
+		if (vcs_is_git()) {
+		    $email_git_since = $str;
+		} elsif (vcs_is_hg()) {
+		    $email_hg_since = $str;
+		}
+		$rerun = 1;
+	    } elsif ($sel eq "t") {
+		bool_invert(\$email_git_all_signature_types);
+		$rerun = 1;
+	    } elsif ($sel eq "f") {
+		bool_invert(\$file_emails);
+		$rerun = 1;
+	    } elsif ($sel eq "r") {
+		bool_invert(\$email_remove_duplicates);
+		$rerun = 1;
+	    } elsif ($sel eq "k") {
+		bool_invert(\$keywords);
+		$rerun = 1;
+	    } elsif ($sel eq "p") {
+		if ($str ne "" && $val >= 0) {
+		    $pattern_depth = $val;
+		    $rerun = 1;
+		}
+	    } else {
+		print STDERR "invalid option: '$nr'\n";
+		$redraw = 0;
+	    }
+	}
+	if ($rerun) {
+	    print STDERR "git-blame can be very slow, please have patience..."
+		if ($email_git_blame);
+	    goto &get_maintainer;
+	}
+    }
+
+    #drop not selected entries
+    $count = 0;
+    my @new_emailto = ();
+    foreach my $entry (@list) {
+	if ($selected{$count}) {
+	    push(@new_emailto, $list[$count]);
+	}
+	$count++;
+    }
+    return @new_emailto;
+}
+
+sub bool_invert {
+    my ($bool_ref) = @_;
+
+    if ($$bool_ref) {
+	$$bool_ref = 0;
+    } else {
+	$$bool_ref = 1;
+    }
+}
+
+sub save_commits_by_author {
+    my (@lines) = @_;
+
+    my @authors = ();
+    my @commits = ();
+    my @subjects = ();
+
+    foreach my $line (@lines) {
+	if ($line =~ m/$VCS_cmds{"author_pattern"}/) {
+	    my $author = $1;
+	    my ($name, $address) = parse_email($author);
+	    $author = format_email($name, $address, 1);
+	    push(@authors, $author);
+	}
+	push(@commits, $1) if ($line =~ m/$VCS_cmds{"commit_pattern"}/);
+	push(@subjects, $1) if ($line =~ m/$VCS_cmds{"subject_pattern"}/);
+    }
+
+    for (my $i = 0; $i < @authors; $i++) {
+	my $exists = 0;
+	foreach my $ref(@{$commit_author_hash{$authors[$i]}}) {
+	    if (@{$ref}[0] eq $commits[$i] &&
+		@{$ref}[1] eq $subjects[$i]) {
+		$exists = 1;
+		last;
+	    }
+	}
+	if (!$exists) {
+	    push(@{$commit_author_hash{$authors[$i]}},
+		 [ ($commits[$i], $subjects[$i]) ]);
+	}
+    }
+}
+
+sub save_commits_by_signer {
+    my (@lines) = @_;
+
+    my $commit = "";
+    my $subject = "";
+
+    foreach my $line (@lines) {
+	$commit = $1 if ($line =~ m/$VCS_cmds{"commit_pattern"}/);
+	$subject = $1 if ($line =~ m/$VCS_cmds{"subject_pattern"}/);
+	if ($line =~ /^[ \t]*${signature_pattern}.*\@.*$/) {
+	    my @signatures = ($line);
+	    my ($types_ref, $signers_ref) = extract_formatted_signatures(@signatures);
+	    my @types = @$types_ref;
+	    my @signers = @$signers_ref;
+
+	    my $type = $types[0];
+	    my $signer = $signers[0];
+
+	    my $exists = 0;
+	    foreach my $ref(@{$commit_signer_hash{$signer}}) {
+		if (@{$ref}[0] eq $commit &&
+		    @{$ref}[1] eq $subject &&
+		    @{$ref}[2] eq $type) {
+		    $exists = 1;
+		    last;
+		}
+	    }
+	    if (!$exists) {
+		push(@{$commit_signer_hash{$signer}},
+		     [ ($commit, $subject, $type) ]);
+	    }
+	}
+    }
+}
+
 sub vcs_assign {
     my ($role, $divisor, @lines) = @_;
 
@@ -1206,7 +1606,8 @@ sub vcs_file_signoffs {
     my @signers = ();
     my $commits;
 
-    return if (!vcs_exists());
+    $vcs_used = vcs_exists();
+    return if (!$vcs_used);
 
     my $cmd = $VCS_cmds{"find_signers_cmd"};
     $cmd =~ s/(\$\w+)/$1/eeg;		# interpolate $cmd
@@ -1224,37 +1625,93 @@ sub vcs_file_blame {
     my $total_commits;
     my $total_lines;
 
-    return if (!vcs_exists());
+    $vcs_used = vcs_exists();
+    return if (!$vcs_used);
 
     @all_commits = vcs_blame($file);
     @commits = uniq(@all_commits);
     $total_commits = @commits;
     $total_lines = @all_commits;
 
-    foreach my $commit (@commits) {
-	my $commit_count;
-	my @commit_signers = ();
+    if ($email_git_blame_signatures) {
+	if (vcs_is_hg()) {
+	    my $commit_count;
+	    my @commit_signers = ();
+	    my $commit = join(" -r ", @commits);
+	    my $cmd;
+
+	    $cmd = $VCS_cmds{"find_commit_signers_cmd"};
+	    $cmd =~ s/(\$\w+)/$1/eeg;	#substitute variables in $cmd
 
-	my $cmd = $VCS_cmds{"find_commit_signers_cmd"};
-	$cmd =~ s/(\$\w+)/$1/eeg;	#interpolate $cmd
+	    ($commit_count, @commit_signers) = vcs_find_signers($cmd);
 
-	($commit_count, @commit_signers) = vcs_find_signers($cmd);
+	    push(@signers, @commit_signers);
+	} else {
+	    foreach my $commit (@commits) {
+		my $commit_count;
+		my @commit_signers = ();
+		my $cmd;
 
-	push(@signers, @commit_signers);
+		$cmd = $VCS_cmds{"find_commit_signers_cmd"};
+		$cmd =~ s/(\$\w+)/$1/eeg;	#substitute variables in $cmd
+
+		($commit_count, @commit_signers) = vcs_find_signers($cmd);
+
+		push(@signers, @commit_signers);
+	    }
+	}
     }
 
     if ($from_filename) {
 	if ($output_rolestats) {
 	    my @blame_signers;
-	    foreach my $commit (@commits) {
-		my $i;
-		my $cmd = $VCS_cmds{"find_commit_author_cmd"};
-		$cmd =~ s/(\$\w+)/$1/eeg;	#interpolate $cmd
-		my @author = vcs_find_author($cmd);
-		next if !@author;
-		my $count = grep(/$commit/, @all_commits);
-		for ($i = 0; $i < $count ; $i++) {
-		    push(@blame_signers, $author[0]);
+	    if (vcs_is_hg()) {{		# Double brace for last exit
+		my $commit_count;
+		my @commit_signers = ();
+		@commits = uniq(@commits);
+		@commits = sort(@commits);
+		my $commit = join(" -r ", @commits);
+		my $cmd;
+
+		$cmd = $VCS_cmds{"find_commit_author_cmd"};
+		$cmd =~ s/(\$\w+)/$1/eeg;	#substitute variables in $cmd
+
+		my @lines = ();
+
+		@lines = &{$VCS_cmds{"execute_cmd"}}($cmd);
+
+		if (!$email_git_penguin_chiefs) {
+		    @lines = grep(!/${penguin_chiefs}/i, @lines);
+		}
+
+		last if !@lines;
+
+		my @authors = ();
+		foreach my $line (@lines) {
+		    if ($line =~ m/$VCS_cmds{"author_pattern"}/) {
+			my $author = $1;
+			my ($name, $address) = parse_email($author);
+			$author = format_email($name, $address, 1);
+			push(@authors, $1);
+		    }
+		}
+
+		save_commits_by_author(@lines) if ($interactive);
+		save_commits_by_signer(@lines) if ($interactive);
+
+		push(@signers, @authors);
+	    }}
+	    else {
+		foreach my $commit (@commits) {
+		    my $i;
+		    my $cmd = $VCS_cmds{"find_commit_author_cmd"};
+		    $cmd =~ s/(\$\w+)/$1/eeg;	#interpolate $cmd
+		    my @author = vcs_find_author($cmd);
+		    next if !@author;
+		    my $count = grep(/$commit/, @all_commits);
+		    for ($i = 0; $i < $count ; $i++) {
+			push(@blame_signers, $author[0]);
+		    }
 		}
 	    }
 	    if (@blame_signers) {


