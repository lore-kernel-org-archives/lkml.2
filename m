Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab0IKAWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 20:22:23 -0400
Received: from mail.perches.com ([173.55.12.10]:1651 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755622Ab0IKAWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 20:22:23 -0400
Subject: [PATCH] scripts/get_maintainer.pl: Add --git-blame --rolestats
 "Authored lines" information
From: Joe Perches <joe@perches.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: florian@mickler.org, Andrew Morton <akpm@linux-foundation.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <1284115665.1783.144.camel@Joe-Laptop>
References: <1284111212-10659-1-git-send-email-florian@mickler.org>
	 <1284111767.1783.35.camel@Joe-Laptop>
	 <20100910095259.GC23903@sirena.org.uk>
	 <1284113066.1783.69.camel@Joe-Laptop>
	 <20100910101818.GF3068@rakim.wolfsonmicro.main>
	 <1284115665.1783.144.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Sep 2010 17:22:21 -0700
Message-ID: <1284164541.1783.204.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Something based on percentage of the driver written rather than log
> > entry counts might also be interesting.
> There is a --git-blame option, but it uses a count of file commits
> active in the file rather than % of lines authored.

When options --git-blame and --rolestats are specified, add
the maintainers with the qualifying --git-min-percent amount
of lines authored of the complete file.  Does not add more
authors than specified by --git-max-maintainers.

For anyone using hg, this option works but is _very_ slow.
It's orders of magnitude slower than git slow.

The get_maintainer.pl version was incremented to 0.25.

This can be used with or without --git.

For instance:

$ ./scripts/get_maintainer.pl --git-blame --nogit --rolestats -f lib/bitmap.c
Paul Jackson <pj@sgi.com> (authored lines:406/613=66%,commits:7/20=35%)
Akinobu Mita <mita@miraclelinux.com> (authored lines:87/613=14%,commits:3/20=15%)
Reinette Chatre <reinette.chatre@linux.intel.com> (authored lines:42/613=7%)
Andrew Morton <akpm@linux-foundation.org> (commits:16/20=80%)
Paul Mundt <lethal@linux-sh.org> (commits:3/20=15%)
Randy Dunlap <randy.dunlap@oracle.com> (commits:2/20=10%)

$ ./scripts/get_maintainer.pl --git-blame --git --rolestats -f lib/bitmap.c
Andrew Morton <akpm@linux-foundation.org> (commit_signer:4/5=80%,commits:16/20=80%)
Akinobu Mita <akinobu.mita@gmail.com> (commit_signer:2/5=40%,authored lines:87/613=14%,commits:3/20=15%)
Jack Steiner <steiner@sgi.com> (commit_signer:1/5=20%)
Ben Hutchings <ben@decadent.org.uk> (commit_signer:1/5=20%)
Lee Schermerhorn <lee.schermerhorn@hp.com> (commit_signer:1/5=20%)
Paul Jackson <pj@sgi.com> (authored lines:406/613=66%,commits:7/20=35%)
Reinette Chatre <reinette.chatre@linux.intel.com> (authored lines:42/613=7%)
Paul Mundt <lethal@linux-sh.org> (commits:3/20=15%)
Randy Dunlap <randy.dunlap@oracle.com> (commits:2/20=10%)
linux-kernel@vger.kernel.org (open list)

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/get_maintainer.pl |   60 ++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 57 insertions(+), 3 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index b228198..a91ae63 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -13,7 +13,7 @@
 use strict;
 
 my $P = $0;
-my $V = '0.24';
+my $V = '0.25';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -88,6 +88,7 @@ my %VCS_cmds_git = (
     "available" => '(which("git") ne "") && (-d ".git")',
     "find_signers_cmd" => "git log --no-color --since=\$email_git_since -- \$file",
     "find_commit_signers_cmd" => "git log --no-color -1 \$commit",
+    "find_commit_author_cmd" => "git log -1 --format=\"%an <%ae>\" \$commit",
     "blame_range_cmd" => "git blame -l -L \$diff_start,+\$diff_length \$file",
     "blame_file_cmd" => "git blame -l \$file",
     "commit_pattern" => "^commit [0-9a-f]{40,40}",
@@ -101,6 +102,7 @@ my %VCS_cmds_hg = (
 	"hg log --date=\$email_hg_since" .
 		" --template='commit {node}\\n{desc}\\n' -- \$file",
     "find_commit_signers_cmd" => "hg log --template='{desc}\\n' -r \$commit",
+    "find_commit_author_cmd" => "hg log -l 1 --template='{author}\\n' -r \$commit",
     "blame_range_cmd" => "",		# not supported
     "blame_file_cmd" => "hg blame -c \$file",
     "commit_pattern" => "^commit [0-9a-f]{40,40}",
@@ -1014,6 +1016,9 @@ sub vcs_find_signers {
     if (!$email_git_penguin_chiefs) {
 	@lines = grep(!/${penguin_chiefs}/i, @lines);
     }
+
+    return (0, @lines) if !@lines;
+
     # cut -f2- -d":"
     s/.*:\s*(.+)\s*/$1/ for (@lines);
 
@@ -1027,6 +1032,28 @@ sub vcs_find_signers {
     return ($commits, @lines);
 }
 
+sub vcs_find_author {
+    my ($cmd) = @_;
+    my @lines = ();
+
+    @lines = &{$VCS_cmds{"execute_cmd"}}($cmd);
+
+    if (!$email_git_penguin_chiefs) {
+	@lines = grep(!/${penguin_chiefs}/i, @lines);
+    }
+
+    return @lines if !@lines;
+
+## Reformat email addresses (with names) to avoid badly written signatures
+
+    foreach my $line (@lines) {
+	my ($name, $address) = parse_email($line);
+	$line = format_email($name, $address, 1);
+    }
+
+    return @lines;
+}
+
 sub vcs_save_commits {
     my ($cmd) = @_;
     my @lines = ();
@@ -1084,6 +1111,10 @@ sub vcs_blame {
 	@commits = vcs_save_commits($cmd);
     }
 
+    foreach my $commit (@commits) {
+	$commit =~ s/^\^//g;
+    }
+
     return @commits;
 }
 
@@ -1121,6 +1152,8 @@ sub vcs_assign {
 	@lines = mailmap(@lines);
     }
 
+    return if (@lines <= 0);
+
     @lines = sort(@lines);
 
     # uniq -c
@@ -1165,14 +1198,17 @@ sub vcs_file_blame {
     my ($file) = @_;
 
     my @signers = ();
+    my @all_commits = ();
     my @commits = ();
     my $total_commits;
+    my $total_lines;
 
     return if (!vcs_exists());
 
-    @commits = vcs_blame($file);
-    @commits = uniq(@commits);
+    @all_commits = vcs_blame($file);
+    @commits = uniq(@all_commits);
     $total_commits = @commits;
+    $total_lines = @all_commits;
 
     foreach my $commit (@commits) {
 	my $commit_count;
@@ -1182,10 +1218,28 @@ sub vcs_file_blame {
 	$cmd =~ s/(\$\w+)/$1/eeg;	#interpolate $cmd
 
 	($commit_count, @commit_signers) = vcs_find_signers($cmd);
+
 	push(@signers, @commit_signers);
     }
 
     if ($from_filename) {
+	if ($output_rolestats) {
+	    my @blame_signers;
+	    foreach my $commit (@commits) {
+		my $i;
+		my $cmd = $VCS_cmds{"find_commit_author_cmd"};
+		$cmd =~ s/(\$\w+)/$1/eeg;	#interpolate $cmd
+		my @author = vcs_find_author($cmd);
+		next if !@author;
+		my $count = grep(/$commit/, @all_commits);
+		for ($i = 0; $i < $count ; $i++) {
+		    push(@blame_signers, $author[0]);
+		}
+	    }
+	    if (@blame_signers) {
+		vcs_assign("authored lines", $total_lines, @blame_signers);
+	    }
+	}
 	vcs_assign("commits", $total_commits, @signers);
     } else {
 	vcs_assign("modified commits", $total_commits, @signers);


