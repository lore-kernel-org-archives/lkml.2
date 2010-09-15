Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab0IOPRP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 11:17:15 -0400
Received: from ist.d-labs.de ([213.239.218.44]:33981 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753748Ab0IOPRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 11:17:14 -0400
From: florian@mickler.org
To: linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, Florian Mickler <florian@mickler.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Subject: [PATCH RFC v3] scripts/get_maintainer.pl: add interactive mode
Date: Wed, 15 Sep 2010 17:16:36 +0200
Message-Id: <1284563819-11363-1-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1284558207-10223-1-git-send-email-florian@mickler.org>
References: <1284558207-10223-1-git-send-email-florian@mickler.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a first version of an interactive mode for
scripts/get_maintainer.pl .

It allows the user to interact with the script. Each cc candidate can be
selected and deselected and a shortlog of authored commits can be
displayed for each candidate.

The menu is displayed via STDERR, the end result is outputted to STDOUT.
This unusual mechanism allows using get_maintainer.pl in interactive mode via
git send-email --cc-cmd.

---

v2: small bugfix
v3: 
   o added multifile support
   o fixed chief_penguin_handling for interactive mode
   o added supporter: roles to be selected by default


TODO:
 Btw, --rolestats is somewhat broken in the current script, it assembles the statistics 
 sequentially file by file, meaning that candidates that have only commits on the first 
 file get a higher percentage as candidates also active on a later file...


 scripts/get_maintainer.pl |  146 +++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 141 insertions(+), 5 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index b228198..6deabc6 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -32,6 +32,7 @@ my $email_git_max_maintainers = 5;
 my $email_git_min_percent = 5;
 my $email_git_since = "1-year-ago";
 my $email_hg_since = "-365";
+my $interactive = 0;
 my $email_remove_duplicates = 1;
 my $output_multiline = 1;
 my $output_separator = ", ";
@@ -51,6 +52,8 @@ my $help = 0;
 
 my $exit = 0;
 
+my %shortlog_buffer;
+
 my @penguin_chief = ();
 push(@penguin_chief, "Linus Torvalds:torvalds\@linux-foundation.org");
 #Andrew wants in on most everything - 2009/01/14
@@ -91,7 +94,8 @@ my %VCS_cmds_git = (
     "blame_range_cmd" => "git blame -l -L \$diff_start,+\$diff_length \$file",
     "blame_file_cmd" => "git blame -l \$file",
     "commit_pattern" => "^commit [0-9a-f]{40,40}",
-    "blame_commit_pattern" => "^([0-9a-f]+) "
+    "blame_commit_pattern" => "^([0-9a-f]+) ",
+    "shortlog_cmd" => "git log --no-color --oneline --since=\$email_git_since --author=\"\$email\" -- \$file"
 );
 
 my %VCS_cmds_hg = (
@@ -104,7 +108,8 @@ my %VCS_cmds_hg = (
     "blame_range_cmd" => "",		# not supported
     "blame_file_cmd" => "hg blame -c \$file",
     "commit_pattern" => "^commit [0-9a-f]{40,40}",
-    "blame_commit_pattern" => "^([0-9a-f]+):"
+    "blame_commit_pattern" => "^([0-9a-f]+):",
+    "shortlog_cmd" => "ht log --date=\$email_hg_since"
 );
 
 if (-f "${lk_path}.get_maintainer.conf") {
@@ -142,6 +147,7 @@ if (!GetOptions(
 		'git-min-percent=i' => \$email_git_min_percent,
 		'git-since=s' => \$email_git_since,
 		'hg-since=s' => \$email_hg_since,
+		'i|interactive!' => \$interactive,
 		'remove-duplicates!' => \$email_remove_duplicates,
 		'm!' => \$email_maintainer,
 		'n!' => \$email_usename,
@@ -219,6 +225,8 @@ if ($email_git_all_signature_types) {
     $signaturePattern = "(.+?)[Bb][Yy]:";
 }
 
+
+
 ## Read MAINTAINERS for type/value pairs
 
 my @typevalue = ();
@@ -440,10 +448,13 @@ foreach my $file (@files) {
     if ($email && $email_git) {
 	vcs_file_signoffs($file);
     }
-
     if ($email && $email_git_blame) {
 	vcs_file_blame($file);
     }
+    if ($email && $interactive){
+	vcs_file_shortlogs($file);
+
+    }
 }
 
 if ($keywords) {
@@ -476,9 +487,13 @@ if ($email) {
     }
 }
 
+
 if ($email || $email_list) {
     my @to = ();
     if ($email) {
+	if ($interactive) {
+	    @email_to = @{vcs_interactive_menu(\@email_to)};
+	}
 	@to = (@to, @email_to);
     }
     if ($email_list) {
@@ -491,7 +506,6 @@ if ($scm) {
     @scm = uniq(@scm);
     output(@scm);
 }
-
 if ($status) {
     @status = uniq(@status);
     output(@status);
@@ -545,6 +559,7 @@ MAINTAINER field selection options:
     --git-blame => use git blame to find modified commits for patch or file
     --git-since => git history to use (default: $email_git_since)
     --hg-since => hg history to use (default: $email_hg_since)
+    --interactive => display a menu (mostly useful if used with the --git option)
     --m => include maintainer(s) if any
     --n => include name 'Full Name <addr\@domain.tld>'
     --l => include list(s) if any
@@ -1104,6 +1119,127 @@ sub vcs_exists {
     return 0;
 }
 
+sub vcs_interactive_menu {
+    my $list_ref = shift;
+    my @list = @$list_ref;
+
+    return if (!vcs_exists());
+
+    my %selected;
+    my %shortlog;
+    my $input;
+    my $count = 0;
+
+    #select maintainers by default
+    foreach my $entry (@list){
+	    my $role = $entry->[1];
+	    $selected{$count} = ($role =~ /maintainer:|supporter:/);
+	    $count++;
+    }
+
+    #menu loop
+    do {
+	my $count = 0;
+	foreach my $entry (@list){
+	    my $email = $entry->[0];
+	    my $role = $entry->[1];
+	    if ($selected{$count}){
+		print STDERR "* ";
+	    } else {
+		print STDERR "  ";
+	    }
+	    print STDERR "$count: $email,\t\t $role";
+	    print STDERR "\n";
+	    if ($shortlog{$count}){
+		my $entries_ref = vcs_get_shortlog($email);
+		foreach my $entry_ref (@{$entries_ref}){
+		    my $filename = @{$entry_ref}[0];
+		    my @shortlog = @{@{$entry_ref}[1]};
+		    print STDERR "\tshortlog for $filename (authored commits: " . @shortlog . ").\n";
+		    foreach my $commit (@shortlog){
+			print STDERR "\t  $commit\n";
+		    }
+		    print STDERR "\n";
+		}
+	    }
+	    $count++;
+	}
+	print STDERR "\n";
+	print STDERR "Choose whom to cc by entering a commaseperated list of numbers and hitting enter.\n";
+	print STDERR "To show a short list of commits, precede the number by a '?',\n";
+	print STDERR "A blank line indicates that you are satisfied with your choice.\n";
+	$input = <STDIN>;
+	chomp($input);
+
+	my @wish = split(/[, ]+/,$input);
+	foreach my $nr (@wish){
+		my $logtoggle = 0;
+		if ($nr =~ /\?/){
+			$nr =~ s/\?//;
+			$logtoggle = 1;
+		}
+
+		#skip out of bounds numbers
+		next unless ($nr <= $count && $nr >= 0);
+
+		if ($logtoggle){
+			$shortlog{$nr} = !$shortlog{$nr};
+		} else {
+			$selected{$nr} = !$selected{$nr};
+
+			#switch shortlog on if an entry get's selected
+			if ($selected{$nr}){
+				$shortlog{$nr}=1;
+			}
+		}
+	};
+    } while(length($input) > 0);
+
+    #drop not selected entries
+    $count = 0;
+    my @new_emailto;
+    foreach my $entry (@list){
+	if ($selected{$count}){
+		push(@new_emailto,$list[$count]);
+		print STDERR "$count: ";
+		print STDERR $email_to[$count]->[0];
+		print STDERR ",\t\t ";
+		print STDERR $email_to[$count]->[1];
+		print STDERR "\n";
+	}
+	$count++;
+    }
+    return \@new_emailto;
+}
+
+sub vcs_get_shortlog {
+    my $arg = shift;
+    my ($name, $address) = parse_email($arg);
+    return $shortlog_buffer{$address};
+}
+
+sub vcs_file_shortlogs {
+    my ($file) = @_;
+    print STDERR "shortlog processing $file:";
+    foreach my $entry (@email_to){
+	my ($name, $address) = parse_email($entry->[0]);
+	print STDERR ".";
+	my $commits_ref = vcs_email_shortlog($address, $file);
+	push(@{$shortlog_buffer{$address}}, [ $file, $commits_ref ]);
+    }
+    print STDERR "\n";
+}
+
+sub vcs_email_shortlog {
+    my $email = shift;
+    my ($file) = @_;
+
+    my $cmd = $VCS_cmds{"shortlog_cmd"};
+    $cmd =~ s/(\$\w+)/$1/eeg;		#substitute variables
+    my @lines = &{$VCS_cmds{"execute_cmd"}}($cmd);
+    return \@lines;
+}
+
 sub vcs_assign {
     my ($role, $divisor, @lines) = @_;
 
@@ -1179,7 +1315,7 @@ sub vcs_file_blame {
 	my @commit_signers = ();
 
 	my $cmd = $VCS_cmds{"find_commit_signers_cmd"};
-	$cmd =~ s/(\$\w+)/$1/eeg;	#interpolate $cmd
+	$cmd =~ s/(\$\w+)/$1/eeg;	#substitute variables in $cmd
 
 	($commit_count, @commit_signers) = vcs_find_signers($cmd);
 	push(@signers, @commit_signers);
-- 
1.7.2

