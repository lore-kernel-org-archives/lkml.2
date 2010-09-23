Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab0IWDRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 23:17:19 -0400
Received: from mail.perches.com ([173.55.12.10]:2263 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771Ab0IWDRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 23:17:15 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] scripts/get_maintainer.pl: Use case insensitive name de-duplication
Date: Wed, 22 Sep 2010 20:17:10 -0700
Message-Id: <87f7f8f900e7011bacebb7547a81ce3a34bf5890.1285209493.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1285209493.git.joe@perches.com>
References: <cover.1285209493.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Case insensitive name and email address matching can help reduce
duplication when authors don't always use the exact same signature.

o Add a --interactive per-file exact_match hash so git history
  can be checked on per-file only when there is no direct maintainer
o Make @interactive_to list global so save_commits_by_<foo> can check
  email names & addresses against this list for duplication
o Don't allow --interactive and --sections
o rename subroutine get_maintainer to get_maintainers
o Added help text option to --interactive menu prompt

Update version to 0.26-beta4

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/get_maintainer.pl |  135 +++++++++++++++++++++++++++++++++-----------
 1 files changed, 101 insertions(+), 34 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index f511760..61d3bb5 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -13,7 +13,7 @@
 use strict;
 
 my $P = $0;
-my $V = '0.26-beta3';
+my $V = '0.26-beta4';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -242,6 +242,7 @@ if ($sections) {
     $subsystem = 0;
     $web = 0;
     $keywords = 0;
+    $interactive = 0;
 } else {
     my $selections = $email + $scm + $status + $subsystem + $web;
     if ($selections == 0) {
@@ -407,13 +408,15 @@ my @scm = ();
 my @web = ();
 my @subsystem = ();
 my @status = ();
+my @interactive_to = ();
 my $signature_pattern;
 
-my @to = get_maintainer();
+my @maintainers = get_maintainers();
 
-@to = merge_email(@to);
-
-output(@to) if (@to);
+if (@maintainers) {
+    @maintainers = merge_email(@maintainers);
+    output(@maintainers);
+}
 
 if ($scm) {
     @scm = uniq(@scm);
@@ -437,7 +440,7 @@ if ($web) {
 
 exit($exit);
 
-sub get_maintainer {
+sub get_maintainers {
     %email_hash_name = ();
     %email_hash_address = ();
     %commit_author_hash = ();
@@ -449,7 +452,7 @@ sub get_maintainer {
     @web = ();
     @subsystem = ();
     @status = ();
-
+    @interactive_to = ();
     if ($email_git_all_signature_types) {
 	$signature_pattern = "(.+?)[Bb][Yy]:";
     } else {
@@ -458,10 +461,11 @@ sub get_maintainer {
 
     # Find responsible parties
 
+    my %exact_pattern_match_hash;
+
     foreach my $file (@files) {
 
 	my %hash;
-	my $exact_pattern_match = 0;
 	my $tvi = find_first_section();
 	while ($tvi < @typevalue) {
 	    my $start = find_starting_index($tvi);
@@ -497,7 +501,9 @@ sub get_maintainer {
 				my $file_pd = ($file  =~ tr@/@@);
 				$value_pd++ if (substr($value,-1,1) ne "/");
 				$value_pd = -1 if ($value =~ /^\.\*/);
-				$exact_pattern_match = 1 if ($value_pd >= $file_pd);
+				if ($value_pd >= $file_pd) {
+				    $exact_pattern_match_hash{$file} = 1;
+				}
 				if ($pattern_depth == 0 ||
 				    (($file_pd - $value_pd) < $pattern_depth)) {
 				    $hash{$tvi} = $value_pd;
@@ -530,14 +536,6 @@ sub get_maintainer {
 		print("\n");
 	    }
 	}
-
-	if ($email && ($email_git ||
-		       ($email_git_fallback && !$exact_pattern_match))) {
-	    vcs_file_signoffs($file);
-	}
-	if ($email && $email_git_blame) {
-	    vcs_file_blame($file);
-	}
     }
 
     if ($keywords) {
@@ -547,6 +545,19 @@ sub get_maintainer {
 	}
     }
 
+    @interactive_to = (@email_to, @list_to);
+
+    foreach my $file (@files) {
+	if ($email &&
+	    ($email_git || ($email_git_fallback &&
+			    !$exact_pattern_match_hash{$file}))) {
+	    vcs_file_signoffs($file);
+	}
+	if ($email && $email_git_blame) {
+	    vcs_file_blame($file);
+	}
+    }
+
     if ($email) {
 	foreach my $chief (@penguin_chief) {
 	    if ($chief =~ m/^(.*):(.*)/) {
@@ -580,7 +591,10 @@ sub get_maintainer {
 	}
     }
 
-    @to = interactive_get_maintainer(\@to) if ($interactive);
+    if ($interactive) {
+	@interactive_to = @to;
+	@to = interactive_get_maintainers(\@interactive_to);
+    }
 
     return @to;
 }
@@ -899,16 +913,16 @@ sub add_categories {
 		}
 		if ($list_additional =~ m/subscribers-only/) {
 		    if ($email_subscriber_list) {
-			if (!$hash_list_to{$list_address}) {
-			    $hash_list_to{$list_address} = 1;
+			if (!$hash_list_to{lc($list_address)}) {
+			    $hash_list_to{lc($list_address)} = 1;
 			    push(@list_to, [$list_address,
 					    "subscriber list${list_role}"]);
 			}
 		    }
 		} else {
 		    if ($email_list) {
-			if (!$hash_list_to{$list_address}) {
-			    $hash_list_to{$list_address} = 1;
+			if (!$hash_list_to{lc($list_address)}) {
+			    $hash_list_to{lc($list_address)} = 1;
 			    push(@list_to, [$list_address,
 					    "open list${list_role}"]);
 			}
@@ -946,8 +960,8 @@ sub email_inuse {
     my ($name, $address) = @_;
 
     return 1 if (($name eq "") && ($address eq ""));
-    return 1 if (($name ne "") && exists($email_hash_name{$name}));
-    return 1 if (($address ne "") && exists($email_hash_address{$address}));
+    return 1 if (($name ne "") && exists($email_hash_name{lc($name)}));
+    return 1 if (($address ne "") && exists($email_hash_address{lc($address)}));
 
     return 0;
 }
@@ -965,8 +979,8 @@ sub push_email_address {
 	push(@email_to, [format_email($name, $address, $email_usename), $role]);
     } elsif (!email_inuse($name, $address)) {
 	push(@email_to, [format_email($name, $address, $email_usename), $role]);
-	$email_hash_name{$name}++;
-	$email_hash_address{$address}++;
+	$email_hash_name{lc($name)}++;
+	$email_hash_address{lc($address)}++;
     }
 
     return 1;
@@ -1259,7 +1273,7 @@ sub vcs_is_hg {
     return $vcs_used == 2;
 }
 
-sub interactive_get_maintainer {
+sub interactive_get_maintainers {
     my ($list_ref) = @_;
     my @list = @$list_ref;
 
@@ -1269,11 +1283,12 @@ sub interactive_get_maintainer {
     my %authored;
     my %signed;
     my $count = 0;
-
+    my $maintained = 0;
     #select maintainers by default
-    foreach my $entry (@list){
+    foreach my $entry (@list) {
 	my $role = $entry->[1];
-	$selected{$count} = ($role =~ /^(maintainer|supporter|open list)/);
+	$selected{$count} = ($role =~ /^(maintainer|supporter|open list)/i);
+	$maintained = 1 if ($role =~ /^(maintainer|supporter)/i);
 	$authored{$count} = 0;
 	$signed{$count} = 0;
 	$count++;
@@ -1286,8 +1301,14 @@ sub interactive_get_maintainer {
     while (!$done) {
 	$count = 0;
 	if ($redraw) {
-	    printf STDERR "\n%1s %2s %-65sauth sign\n",
-		"*", "#", "email/list and role:stats";
+	    printf STDERR "\n%1s %2s %-65s",
+			  "*", "#", "email/list and role:stats";
+	    if ($email_git ||
+		($email_git_fallback && !$maintained) ||
+		$email_git_blame) {
+		print STDERR "auth sign";
+	    }
+	    print STDERR "\n";
 	    foreach my $entry (@list) {
 		my $email = $entry->[0];
 		my $role = $entry->[1];
@@ -1453,6 +1474,27 @@ sub interactive_get_maintainer {
 		    $pattern_depth = $val;
 		    $rerun = 1;
 		}
+	    } elsif ($sel eq "h" || $sel eq "?") {
+		print STDERR <<EOT
+
+Interactive mode allows you to select the various maintainers, submitters,
+commit signers and mailing lists that could be CC'd on a patch.
+
+Any *'d entry is selected.
+
+If you have git or hg installed, You can choose to summarize the commit
+history of files in the patch.  Also, each line of the current file can
+be matched to its commit author and that commits signers with blame.
+
+Various knobs exist to control the length of time for active commit
+tracking, the maximum number of commit authors and signers to add,
+and such.
+
+Enter selections at the prompt until you are satisfied that the selected
+maintainers are appropriate.  You may enter multiple selections separated
+by either commas or spaces.
+
+EOT
 	    } else {
 		print STDERR "invalid option: '$nr'\n";
 		$redraw = 0;
@@ -1461,7 +1503,7 @@ sub interactive_get_maintainer {
 	if ($rerun) {
 	    print STDERR "git-blame can be very slow, please have patience..."
 		if ($email_git_blame);
-	    goto &get_maintainer;
+	    goto &get_maintainers;
 	}
     }
 
@@ -1496,9 +1538,20 @@ sub save_commits_by_author {
 
     foreach my $line (@lines) {
 	if ($line =~ m/$VCS_cmds{"author_pattern"}/) {
+	    my $matched = 0;
 	    my $author = $1;
 	    my ($name, $address) = parse_email($author);
-	    $author = format_email($name, $address, 1);
+	    foreach my $to (@interactive_to) {
+		my ($to_name, $to_address) = parse_email($to->[0]);
+		if ($email_remove_duplicates &&
+		    ((lc($name) eq lc($to_name)) ||
+		     (lc($address) eq lc($to_address)))) {
+		    $author = $to->[0];
+		    $matched = 1;
+		    last;
+		}
+	    }
+	    $author = format_email($name, $address, 1) if (!$matched);
 	    push(@authors, $author);
 	}
 	push(@commits, $1) if ($line =~ m/$VCS_cmds{"commit_pattern"}/);
@@ -1539,6 +1592,20 @@ sub save_commits_by_signer {
 	    my $type = $types[0];
 	    my $signer = $signers[0];
 
+	    my $matched = 0;
+	    my ($name, $address) = parse_email($signer);
+	    foreach my $to (@interactive_to) {
+		my ($to_name, $to_address) = parse_email($to->[0]);
+		if ($email_remove_duplicates &&
+		    ((lc($name) eq lc($to_name)) ||
+		     (lc($address) eq lc($to_address)))) {
+		    $signer = $to->[0];
+		    $matched = 1;
+		    last;
+		}
+		$signer = format_email($name, $address, 1) if (!$matched);
+	    }
+
 	    my $exists = 0;
 	    foreach my $ref(@{$commit_signer_hash{$signer}}) {
 		if (@{$ref}[0] eq $commit &&
-- 
1.7.3

